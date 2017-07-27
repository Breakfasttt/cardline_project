package ui.gameZone;
import assets.AssetPaths;
import data.card.CardsExtention;
import data.manager.GameDatas;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.group.FlxGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
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
	
	private var m_txtInfos : FlxText;
	
	/**
	 * store all played extention
	 */
	private var m_playedExtention : Array<String>;
	
	/**
	 * The deck contains all playabel cars who's not in the hand, graveyard, or play area
	 */
	private var m_deck : Array<Card>;
	
	private var m_actualScale : FlxPoint;
	
	public function new(playedExtention : Array<String>, infos : String, x : Float = 50, y : Float = 800) 
	{
		m_posX = x;
		m_posY = y;
		
		m_actualScale = new FlxPoint(1, 1);
		
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
		
		m_deckBorder.setPosition(m_posX - offsetx, m_posY - offsety);
		
		m_txtInfos = new FlxText(0, 0, CardSkin.cardWidth, infos);
		m_txtInfos.alignment = FlxTextAlign.CENTER;
		m_txtInfos.setFormat(AssetPaths.OldNewspaperTypes__ttf, 32);
		m_txtInfos.setPosition(m_posX, m_deckBorder.y + m_deckBorder.height + 10);
		
		m_deckGroup = new FlxGroup();
		m_deckGroup.add(m_deckBorder);
		m_deckGroup.add(m_txtInfos);
		
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
			var valueToUse : String = GameDatas.self.selectedValue;
			
			if (ext == null)
				continue;
				
			for (cardData in ext.getAllCard())
			{
				// if card data don't contains the value, don't create the card and skip it.
				// maybe not the best to make this into DeckUi class. because of GameDatas access.
				// it's ok for this project.
				if (!cardData.value.exists(valueToUse)) 
					continue;
				m_deck.push(new Card(cardData, valueToUse));
			}
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
		card.skin.scaleSkin(m_actualScale.x, m_actualScale.y);
		card.skin.setPosition(m_posX, m_posY);
		card.skin.setVisible(revealCard);
		
		m_deckGroup.add(card.skin);
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
		card.skin.scaleSkin(m_actualScale.x, m_actualScale.y);
		
		//hide the card at top just in case
		if (m_deck.length > 0)
			m_deck[m_deck.length - 1].skin.visible = false;		
		
		if (!random)
		{
			if (atTop)
				m_deck.push(card);
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
	
	public function setScale(x : Float, y : Float)
	{
		m_actualScale.set(x, y);
		
		for (card in m_deck)
			card.skin.scaleSkin(x, y);
			
		if (m_deck.length != 0)
		{
			var card : Card = m_deck[m_deck.length - 1];
			card.skin.setPosition(m_posX, m_posY);
		}
		
		m_deckBorder.scale.set(x, y);
		m_deckBorder.updateHitbox();
		
		var offsetx = (m_deckBorder.width - CardSkin.cardWidth*x) / 2;
		var offsety = (m_deckBorder.height - CardSkin.cardHeight*y) / 2;
		
		m_deckBorder.setPosition(m_posX - offsetx, m_posY - offsety);
		m_txtInfos.fieldWidth = -1;
		m_txtInfos.setPosition(m_posX + m_deckBorder.width/2 - m_txtInfos.width/2.0 - offsetx, m_deckBorder.y + m_deckBorder.height + 5*y);
		
	}
}