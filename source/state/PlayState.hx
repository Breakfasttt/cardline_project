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
import ui.skin.CardSkinGroup;
import ui.gameZone.DeckUi;
import ui.gameZone.MainHandUi;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	private static var m_maxCardOnHand : Int = 6;
	
	private var m_board : FlxSprite;
	
	private var m_deckUI : DeckUi;
	
	private var m_graveyardUI : DeckUi;
	
	private var m_mainHandUI : MainHandUi;


	override public function create():Void
	{
		super.create();	
		
		m_board = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic("assets/images/board.jpg"));
		
		m_deckUI = new DeckUi(GameDatas.self.selectedExtention.copy());
		
		m_graveyardUI = new DeckUi(new Array<String>(), (1920 - 50 - CardSkin.cardWidth), 800);
		
		m_mainHandUI = new MainHandUi(m_maxCardOnHand);
		
		for (i in 0...m_maxCardOnHand)
		{
			deckToMainHand();
		}
		
		this.add(m_board);
		m_deckUI.attachTo(this);
		m_graveyardUI.attachTo(this);
		m_mainHandUI.attachTo(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		m_mainHandUI.update(elapsed);
		
		if (FlxG.keys.anyJustPressed([G]))
		{
			var card : Card = m_mainHandUI.pickACard();
			cardToGraveyard(card);
			deckToMainHand();
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


}