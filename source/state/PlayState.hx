package state;

import assets.AssetPaths;
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
import ui.group.CardSkinGroup;
import ui.zone.DeckUi;
import ui.zone.MainHandUi;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	private static var m_maxCardOnHand : Int = 6;
	
	private var m_board : FlxSprite;
	
	private var m_deckUI : DeckUi;
	
	private var m_mainHandUI : MainHandUi;


	override public function create():Void
	{
		super.create();	
		
		m_board = new FlxSprite(0, 0, AssetPaths.board__jpg);
		
		m_deckUI = new DeckUi(GameDatas.self.extentionManager.getAllExtentionsName());
		m_mainHandUI = new MainHandUi(m_maxCardOnHand);
		
		for (i in 0...m_maxCardOnHand)
		{
			deckToMainHand();
		}
		
		this.add(m_board);
		m_deckUI.attachTo(this);
		m_mainHandUI.attachTo(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		m_mainHandUI.update(elapsed);
	}
	
	private function deckToMainHand() : Void
	{
		var cardDrawed = m_deckUI.drawACard();
		if (!m_mainHandUI.addToHand(cardDrawed))
			m_deckUI.putCard(cardDrawed);
	}
	


}