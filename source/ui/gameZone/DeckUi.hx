package ui.gameZone;
import data.card.CardsExtention;
import data.manager.GameDatas;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import source.data.card.CardData;
import source.ui.skin.CardSkin;
import ui.elements.Card;
import ui.skin.CardSkinGroup;

/**
 * ...
 * @author Breakyt
 */
class DeckUi 
{
	
	/**
	 * The ui group parent
	 */
	private var m_groupRef : FlxGroup;
	
	/**
	 * Position to display the card of the top of the deck
	 */
	private var m_posX : Float;
	private var m_posY : Float;
	
	/**
	 * Haxeflixel group to display the card of the top of the deck on screen 
	 */
	private var m_deckGroup : FlxGroup;
	
	private var m_deckBorder : FlxSprite;
	
	/**
	 * store all played extention
	 */
	private var m_playedExtention : Array<String>;
	
	/**
	 * The deck contains all playabel cars who's not in the hand, graveyard, or play area
	 */
	private var m_deck : Array<Card>;
	
	public function new(playedExtention : Array<String>, x : Float = 50, y : Float = 800) 
	{
		m_posX = x;
		m_posY = y;
		
		var ticknessValue : Int = 5;
		var extend : Int = 30;
		var borderW = CardSkin.cardWidth + extend + ticknessValue;
		var borderH = CardSkin.cardHeight +extend  + ticknessValue;
		
		m_deckBorder = new FlxSprite();
		m_deckBorder.makeGraphic(borderW, borderH, FlxColor.TRANSPARENT);
		var lineStyle:LineStyle = { thickness: 5, color: FlxColor.WHITE };
		FlxSpriteUtil.drawRoundRect(m_deckBorder, ticknessValue/2, ticknessValue/2, CardSkin.cardWidth + extend, CardSkin.cardHeight + extend, 25.0, 25.0, FlxColor.TRANSPARENT, lineStyle);
		
		
		var offsetx = (m_deckBorder.width - CardSkin.cardWidth) / 2;
		var offsety = (m_deckBorder.height - CardSkin.cardHeight) / 2;
		
		m_deckBorder.setPosition(m_posX-offsetx, m_posY-offsety);
		
		m_deckGroup = new FlxGroup();
		m_deckGroup.add(m_deckBorder);
		
		m_playedExtention = playedExtention;
		m_deck = new Array<Card>();
		fillDeck();
		configureCardsState();
		shuffle();
		displayTopOfTheDeck();
	}
	
	/**
	 * Use this to add into a state for display (or a subgroup of haxeflixel)
	 * Pass null in parameters to detach this ui.
	 * @param	group
	 */
	public function attachTo(group : FlxGroup) : Void
	{	
		if (m_groupRef != null)
			m_groupRef.remove(m_deckGroup);
		
		m_groupRef = group;
		
		if (m_groupRef != null)
			m_groupRef.add(m_deckGroup);
	}	

	/**
	 * Fill the deck for the first time with all allowed extention
	 */
	private function fillDeck() : Void
	{
		for (extName in m_playedExtention)
		{
			var ext : CardsExtention = GameDatas.self.extentionManager.getExtentionByUniqueId(extName);
			
			if (ext == null)
				continue;
				
			for (cardData in ext.getAllCard())
				m_deck.push(new Card(cardData));
		}
	}	
	
	/**
	 * Set card comportement
	 */
	private function configureCardsState() : Void
	{
		for (card in m_deck)
		{
			card.skin.draggable = false;
			card.skin.setVisible(false);
		}
	}
	
	private function shuffle() : Void
	{
		if (m_deck.length == 0)
			return;
		
		var randShuffle = Std.random(50) + 50;
		
		for (nbreShuffle in 0...randShuffle)
		{
			var index1 = Std.random(m_deck.length);
			var index2 = Std.random(m_deck.length);
			
			var temp = m_deck[index1];
			m_deck[index1] = m_deck[index2];
			m_deck[index2] = temp;
		}
	}
	
	private function displayTopOfTheDeck(revealCard : Bool = false) : Void
	{
		if (m_deck.length == 0)
			return;
		
		var card : Card = m_deck[m_deck.length - 1];
		card.skin.setPosition(m_posX, m_posY);
		
		m_deckGroup.add(card.skin);
		card.skin.setVisible(revealCard);
	}
	
	/**
	 * Return the card at the top of the deck.
	 * The card is remove from the dec, so be carefull to keep any reference.
	 * Use "putCard" function to add a card into the deck
	 * @return
	 */
	public function drawACard() : Card
	{
		var result = m_deck.pop();
		
		if (result == null)
			return null;
		
		m_deckGroup.remove(result.skin);
		displayTopOfTheDeck();
		return result;
	}
	
	/**
	 * Put a card into the deck after initialization.
	 * @param	card : the card to add, 
	 * @param	atTop : to put cards at the top of deck (like array.push()). Set to false to insert it at begining (array.unshift()). Random parameters make this parameters obsolete
	 * @param	random : Insert it at a random index of the deck. Cancel the "atTop" parameters
	 */
	public function putCard(card : Card, atTop : Bool = true, random : Bool = false, revealTop : Bool = false) : Void
	{
		if (card == null)
			return;
			
		card.skin.draggable = false;
		card.skin.setVisible(false);
		
		if (!random)
		{
			if (atTop)
				m_deck.push(card)
			else
				m_deck.unshift(card);
		}
		else
		{
			var rand : Int = Std.random(m_deck.length);
			m_deck.insert(rand, card);
		}
		
		displayTopOfTheDeck(revealTop);
	}
}