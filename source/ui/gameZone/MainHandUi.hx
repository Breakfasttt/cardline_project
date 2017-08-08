package ui.gameZone;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import motion.CardSkinMotionManager;
import motion.motionScript.CardGoTo;
import source.ui.skin.CardSkin;
import ui.elements.Card;
import ui.skin.CardSkinGroup;

/**
 * Representation of Main Hand
 * @author Breakyt
 */
class MainHandUi 
{

	/**
	 * The ui group parent
	 */
	private var m_groupRef : FlxGroup;
	
	/**
	 * The max card on hand at the same time
	 */
	private var m_maxCardOnHand : Int;
	
	//position Y to show the hand on ui
	private var m_yLine : Float;
	
	//position X to show the hand on ui
	private var m_xStart : Float;	
	
	//offset between each card
	private var m_offsetXBetweenCard : Float = 15.0;
	
	// all card in the hand part
	private var m_cards : Array<Card>;
	
	// Haxeflixel group to update/render all the main and
	private var m_handUI : CardSkinGroup;
	
	// an help variable to keep the card curently dragged.
	private var m_cardOnDrag : Card;
	
	// callback When card is put on timeline
	private var m_callbackOnPut : Card->Void;
	
	/**
	 * Reference du motion manager
	 */
	private var m_motionManagerRef : CardSkinMotionManager;	
	
	public function new(motion : CardSkinMotionManager,  maxCardOnHand : Int, callback : Card->Void) 
	{
		m_motionManagerRef = motion;
		m_maxCardOnHand = maxCardOnHand;
		m_callbackOnPut = callback;
		m_cards = new Array<Card>();
		
		for (i in 0...maxCardOnHand)
			m_cards.push(null);
		
			
		m_handUI = new CardSkinGroup();
	}
	
	/**
	 * Use this to add into a state for display (or a subgroup of haxeflixel)
	 * Pass null in parameters to detach this ui.
	 * @param	group
	 */
	public function attachTo(group : FlxGroup) : Void
	{	
		if (m_groupRef != null)
			m_groupRef.remove(m_handUI.groups);
		
		m_groupRef = group;
		
		if (m_groupRef != null)
			m_groupRef.add(m_handUI.groups);
	}
	
	/**
	 * Add a card to the hand
	 * @param	card
	 * @return
	 */
	public function addToHand(card : Card) : Bool
	{
		if (card == null)
			return false;
		
		var index = getFirstFreeIndex();
		
		if (index < 0)
			return false;
		
			
		m_cards[index] = card;
		card.skin.scaleSkin(1, 1);
		card.skin.draggable = true;
		card.skin.setVisible(false);
		
		//some callback for special effect
		card.skin.onStartDragCallback = this.onCardStartDrag.bind(_, card);
		card.skin.onStopDragCallback = this.onCardStopDrag.bind(_, card);
		card.skin.onDragCallback = this.onCardDrag.bind(_, card);
		
		m_handUI.add(card.skin);
		//moveToSlot(card);
		refreshCardPosition();
		return true;
	}
	
	/**
	 * pick a card from hand and return it.
	 * Warning ! Ref in MainHand are totally remove.
	 * @return
	 */
	public function pickACard():Card
	{
		//to remove null slot
		var randCardArray : Array<Card> = new Array();
		
		for (card in m_cards)
		{
			if (card == null)
				continue;
				
			randCardArray.push(card);
		}
		
		var random : Int = Std.random(randCardArray.length);
		var card : Card = randCardArray[random];
		removeToHand(card);
		return card;
	}
	
	/**
	 * remove a card to the hand
	 * @param	card
	 * @return
	 */
	public function removeToHand(card : Card) : Bool
	{
		if (card == null)
			return false;
			
		var index : Int = m_cards.indexOf(card);
		if (index < 0)
			return false;
		
		m_cards[index] = null;
		card.skin.onDragCallback = null;
		card.skin.onStartDragCallback = null;
		card.skin.onStopDragCallback = null;
		m_handUI.remove(card.skin);
		
		for (i in (index)...(m_cards.length - 1))
			m_cards[i] = m_cards[i + 1];
		m_cards[m_cards.length - 1] = null;
			
		refreshCardPosition();
		
		return true;
	}
	
	public function update(elapsed : Float)
	{
		m_handUI.sortCard();
	}
	
	/**
	 * @return the first free index on cards array. 
	 * If no slot available, return -1
	 */
	private function getFirstFreeIndex() : Int
	{
		for (i in 0...m_maxCardOnHand)
		{
			if (m_cards[i] == null)
				return i;
		}
		
		return -1;
	}
	
	/**
	 * Move the skin of a card to a position dependings of his index
	 * @param	card
	 */
	private function moveToSlot(card : Card) : Void
	{
		if (card == null)
			return;
		
		var index : Int = m_cards.indexOf(card);
		
		if (index < 0)
			return;
				
		var posX = m_xStart + index * (CardSkin.cardWidth + m_offsetXBetweenCard);
		
		m_motionManagerRef.remove(card.skin, CardGoTo);
		m_motionManagerRef.add(new CardGoTo(card.skin, 3600, FlxPoint.get(posX, m_yLine), true, null));
		//card.skin.setPosition(posX, m_yLine);
	}
	
	/**
	 * When a card from Main hand start to be drag
	 * @param	skin
	 * @param	card
	 */
	private function onCardStartDrag(skin : CardSkin, card : Card) : Void
	{
		if (skin != card.skin)
		{
			FlxG.log.error("MainHandUI::onCardStartDrag:: Strange error !");
		}
		
		m_cardOnDrag = card;
	}
	
	/**
	 * When the dragging card stop to be drag
	 * @param	skin
	 * @param	card
	 */
	private function onCardStopDrag(skin : CardSkin, card : Card) : Void
	{
		if (skin != card.skin)
		{
			FlxG.log.error("MainHandUI::onCardStopDrag:: Strange error !");
		}
		
		if (!skin.isPuttable)
			moveToSlot(card);
		else
		{
			if (m_callbackOnPut != null)
				m_callbackOnPut(card);
		}
			
		m_cardOnDrag = null;
	}
	
	/**
	 * Maybe for special effect on the card currently drag
	 */
	private function onCardDrag(skin : CardSkin, card : Card) : Void
	{
		if (skin != card.skin)
		{
			FlxG.log.error("MainHandUI::onCardDrag:: Strange error !");
		}
	}
	
	private function calculStartCoord() : Void
	{
		var totalWidth : Float = (CardSkin.cardWidth + m_offsetXBetweenCard) * getRemainingCard() - m_offsetXBetweenCard;
		
		m_xStart = FlxG.width / 2.0 - totalWidth / 2.0;
		m_yLine = FlxG.height - (CardSkin.cardHeight * 75/100);
	}
	
	private function refreshCardPosition() :Void
	{
		calculStartCoord();	
		for (card in m_cards)
			this.moveToSlot(card);
	}
	
	public function getRemainingCard() : Int
	{
		var result = 0;
		for (card in m_cards)
		{
			if (card != null)
				result++;
		}
		return result;
	}
	
	public function getDraggedCard() : Card
	{
		return m_cardOnDrag;
	}
	
	public function destroy() : Void
	{
		m_cardOnDrag = null;
		attachTo(null);
		m_groupRef = null;
		
		for (card in m_cards)
		{
			if (card != null)
			{
				m_handUI.remove(card.skin);
				card.destroy();
				card = null;
			}
		}
		
		m_handUI = null;
		m_cards = null;
		m_callbackOnPut = null;
		
	}
}