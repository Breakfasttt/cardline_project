package state;

import data.manager.CardExtentionManager;
import data.card.CardsExtention;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSort;
import source.data.card.CardData;
import source.ui.skin.CardSkin;
import ui.group.CardSkinGroup;

class PlayState extends FlxState
{
	private static var m_maxCardsOnMainHand : Int = 6 ;
	
	private var m_playedExtention : Array<String>;
	
	//raw data
	private var m_deck : Array<CardData>;
	private var m_onHand : Array<CardData>;
	private var m_graveyard : Array<CardData>;
	
	//display only
	private var m_mainHand : CardSkinGroup;

	override public function create():Void
	{
		super.create();	
		m_playedExtention = GameDatas.self.extentionManager.getAllExtentionsName();
		m_mainHand = new CardSkinGroup();
		
		fillDeck();
		
		this.add(m_mainHand.groups);
		fillMainHand();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		m_mainHand.sortCard();
	}
	
	private function fillDeck() : Void
	{
		m_deck = new Array<CardData>();
		m_onHand = new Array<CardData>();
		m_graveyard = new Array<CardData>();
		
		for (extName in m_playedExtention)
		{
			var ext : CardsExtention = GameDatas.self.extentionManager.getExtentionByName(extName);
			
			if (ext == null)
				continue;
				
			m_deck = m_deck.concat(ext.GetAllCard());
		}
	}
	
	private function fillMainHand() : Void
	{
		for (i in 0...m_maxCardsOnMainHand)
		{
			drawACard();
		}
	}
	
	/**
	 * Pick a random card on a random Played Extention
	 * @return
	 */
	private function drawACard() : Void
	{
		if (m_deck == null || m_deck.length == 0)
			return;
		
		var rand = Std.random(m_deck.length);
		
		var card = m_deck[rand];
		
		if (card == null)
			return;
			
		m_onHand.push(card);
		m_mainHand.add(new CardSkin(card));
		m_deck.remove(card);
	}
}