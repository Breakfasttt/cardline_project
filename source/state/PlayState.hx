package state;

import assets.AssetPaths;
import assets.AssetsManager;
import data.manager.CardExtentionManager;
import data.card.CardsExtention;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxSort;
import openfl.Assets;
import source.data.card.CardData;
import source.ui.skin.CardSkin;
import ui.elements.Card;
import ui.gameZone.TimelineUi;
import ui.skin.CardSkinGroup;
import ui.gameZone.DeckUi;
import ui.gameZone.MainHandUi;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	private static var m_maxCardOnHand : Int = 6;
	
	private static var m_scaleDeckAndGraveyard : Float = 0.60;
	
	private var m_board : FlxSprite;
	
	private var m_deckUI : DeckUi;
	
	private var m_graveyardUI : DeckUi;
	
	private var m_mainHandUI : MainHandUi;
	
	private var m_timeline : TimelineUi;


	override public function create():Void
	{
		super.create();	
		
		m_board = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic(AssetPaths.menuGame__jpg));
		
		m_deckUI = new DeckUi(GameDatas.self.selectedExtention.copy(), 50, 25);
		m_deckUI.setScale(m_scaleDeckAndGraveyard, m_scaleDeckAndGraveyard);
		
		m_graveyardUI = new DeckUi(new Array<String>(), 50 + CardSkin.cardWidth*m_scaleDeckAndGraveyard + 30, 25);
		m_graveyardUI.setScale(m_scaleDeckAndGraveyard, m_scaleDeckAndGraveyard);
		
		m_mainHandUI = new MainHandUi(m_maxCardOnHand, onPutCard);
		
		m_timeline = new TimelineUi();
		
		// put a first card on timeline
		var card : Card = m_deckUI.drawACard();
		m_timeline.addCard(card);
		
		//pick X card from deck to hand
		for (i in 0...m_maxCardOnHand)
			deckToMainHand();
			
		
		this.add(m_board);
		m_timeline.attachTo(this);
		m_deckUI.attachTo(this);
		m_graveyardUI.attachTo(this);
		m_mainHandUI.attachTo(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		m_mainHandUI.update(elapsed);
		
		var draggedCard : Card = m_mainHandUI.getDraggedCard();
		
		if (draggedCard != null)
		{
			m_timeline.checkMoveCollision(elapsed, draggedCard);
			
			if (m_timeline.checkPutCollision(draggedCard))
			{
				// other stuff ?
				draggedCard.skin.isPuttable = true;
			}
			else
			{
				draggedCard.skin.isPuttable = false;
			}
			
		}
		
	}
	
	private function deckToMainHand() : Void
	{
		var cardDrawed : Card = m_deckUI.drawACard();
		
		if (cardDrawed == null)
		{
			trace("No card remaining in deck.");
			return;
		}
		
		if (!m_mainHandUI.addToHand(cardDrawed))
			m_deckUI.putCard(cardDrawed);

	}
	
	
	private function cardToGraveyard(card : Card) : Void
	{
		m_graveyardUI.putCard(card, true, false, true);
		//maybe other stuff ?
	}
	
	private function cardToTimeline(card : Card) : Void
	{
		if (!m_timeline.addCard(card))
		{
			cardToGraveyard(card);
			deckToMainHand();
		}
		
	}
	
	private function onPutCard(card : Card) : Void
	{
		if (card == null)
			return;
			
		if (m_mainHandUI.removeToHand(card))
		{
			m_timeline.reinitPutColor();
			if (!m_timeline.addCard(card))
			{
				cardToGraveyard(card);
				deckToMainHand();
			}
		}
			
	}

}