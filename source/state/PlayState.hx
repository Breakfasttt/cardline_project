package state;

import assets.AssetPaths;
import assets.AssetsManager;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import source.ui.skin.CardSkin;
import ui.elements.Card;
import ui.elements.ConfirmPopup;
import ui.gameZone.DeckUi;
import ui.gameZone.MainHandUi;
import ui.gameZone.TimelineUi;

import flixel.addons.ui.FlxUIPopup;

class PlayState extends FlxState
{
	private static var m_maxCardOnHand : Int = 6;
	
	private static var m_scaleDeckAndGraveyard : Float = 0.60;
	
	private var m_board : FlxSprite;
	
	private var m_deckUI : DeckUi;
	
	private var m_graveyardUI : DeckUi;
	
	private var m_mainHandUI : MainHandUi;
	
	private var m_timeline : TimelineUi;
	
	private var m_quitBtn : FlxButtonPlus;
	
	private var m_confirmPopup : ConfirmPopup;

	override public function create():Void
	{
		super.create();	
		
		m_board = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic(AssetPaths.board2__jpg));
		
		m_deckUI = new DeckUi(GameDatas.self.selectedExtention.copy(), "Pioche", 50, 25);
		m_deckUI.setScale(m_scaleDeckAndGraveyard, m_scaleDeckAndGraveyard);
		
		m_graveyardUI = new DeckUi(new Array<String>(), "Défausse" ,50 + CardSkin.cardWidth*m_scaleDeckAndGraveyard + 30, 25);
		m_graveyardUI.setScale(m_scaleDeckAndGraveyard, m_scaleDeckAndGraveyard);
		
		m_mainHandUI = new MainHandUi(m_maxCardOnHand, onPutCard);
		
		m_timeline = new TimelineUi();
		
		initConfirmPopup();
		
		// put a first card on timeline
		var card : Card = m_deckUI.drawACard();
		m_timeline.addCard(card);
		
		//pick X card from deck to hand
		for (i in 0...m_maxCardOnHand)
			deckToMainHand();
			
		m_quitBtn = new FlxButtonPlus(0, 0, onQuitBtn, "Abandonner", 300, 45);
		m_quitBtn.setPosition(1920 - m_quitBtn.width - 50, 50); 
		
		m_quitBtn.textNormal.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_quitBtn.textHighlight.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_quitBtn.updateInactiveButtonColors([FlxColor.BROWN, FlxColor.BROWN, FlxColor.BROWN]);
		m_quitBtn.updateActiveButtonColors([FlxColor.BROWN, FlxColor.GRAY]);		
			
		this.add(m_board);
		m_timeline.attachTo(this);
		m_deckUI.attachTo(this);
		m_graveyardUI.attachTo(this);
		m_mainHandUI.attachTo(this);
		this.add(m_quitBtn);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		m_mainHandUI.update(elapsed);
		
		var draggedCard : Card = m_mainHandUI.getDraggedCard();
		
		//dragged card == null is check into tthe funct because of mouse moving possibility
		m_timeline.checkMoveCollision(elapsed, draggedCard); 
		
		if (draggedCard != null)
		{
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
				card.skin.blink();
				deckToMainHand();
			}
			else
			{
				card.skin.blink();
			}
		}
			
	}
	
	private function initConfirmPopup() : Void
	{
		m_confirmPopup = new ConfirmPopup("Etes-vous sur de vouloir abandonner ?",onAccept, onCancel);
	}
	
	private function onQuitBtn() : Void
	{
		m_confirmPopup.attachTo(this);
	}	
	
	private function onCancel() : Void
	{
		m_confirmPopup.attachTo(null);
	}		
	
	private function onAccept() : Void
	{
		m_confirmPopup.attachTo(null);
		releaseAll();
		FlxG.switchState(new MenuState());
	}
	
	private function releaseAll() : Void
	{
		m_deckUI.destroy();
		m_graveyardUI.destroy();
		
		m_mainHandUI.destroy();
		m_timeline.destroy();
		
		this.remove(m_board);
		m_board.destroy();
		m_board = null;
		
		this.remove(m_quitBtn);
		m_quitBtn.destroy();
		m_quitBtn = null;
		
		m_graveyardUI = null;
		m_deckUI = null;
		m_mainHandUI = null;
		m_timeline = null;
	}
}