package state;

import data.card.CardsExtension;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSort;
import source.ui.skin.CardSkin;

class PlayState extends FlxState
{
	
	private var extentionTest : CardsExtension;
	
	private var test : FlxTypedGroup<CardSkin>;
	
	override public function create():Void
	{
		super.create();
		
		extentionTest = new CardsExtension("baseExtention", "baseExtention.json", "assets/data/");
		extentionTest.init();
		
		test = new FlxTypedGroup<CardSkin>();
		var totalCard : Int = extentionTest.getNbrCard();
		
		for (i in 0...totalCard)
		{
			var card = extentionTest.getTLCard(i);
			if (card == null)
				continue;
				
			var skin : CardSkin = new CardSkin();
			skin.setText(card.name, Std.string(card.year));
			test.add(skin);
		}
		
		this.add(test);
		
		
	}

	override public function update(elapsed:Float):Void
	{
		test.sort(sortCard, FlxSort.ASCENDING);
		
		super.update(elapsed);
		
		if (FlxG.keys.anyJustPressed([R]))
		{
			
			var rand = Std.random(test.members.length);
			test.members[rand].flip();
			//test.flip();
		}
	}
	
	private function sortCard(value : Int, card1: CardSkin, card2:CardSkin) : Int
	{
		return FlxSort.byValues(value, card1.depth, card2.depth);
	}
	
}