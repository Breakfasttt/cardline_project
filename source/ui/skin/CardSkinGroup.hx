package ui.skin;
import flixel.FlxG;
import flixel.group.FlxGroup;
import source.ui.skin.CardSkin;

/**
 * An helper class to sort Card Display on drag
 * @author Breakyt
 */
class CardSkinGroup 
{

	public var groups(default, null) : FlxTypedGroup<CardSkin>;
	
	public function new() 
	{
		groups = new FlxTypedGroup<CardSkin>();
	}
	
	public function add(skin : CardSkin)
	{
		groups.add(skin);
	}
	
	public function remove(skin : CardSkin)
	{
		groups.remove(skin);
	}
	
	/**
	 * This function sort cardskin on drag
	 */
	public function sortCard() : Void
	{
		if (FlxG.mouse.justPressed)
		{
			var cardIdToMove : Int = -1;
			for (i in 0...groups.members.length)
			{
				var card : CardSkin = groups.members[i];
				
				if (card == null)
					continue;
				
				if (card.isDrag)
				{
					cardIdToMove = i;
					break;
				}
			}
			
			if (cardIdToMove == -1)
				return;
				
			var temp = groups.members[cardIdToMove];
			var count : Int = cardIdToMove;
			
			while (count != groups.members.length-1)
			{
				groups.members[count] = groups.members[count + 1];
				count++;
			}
			
			groups.members[groups.members.length - 1] = temp;
		}
	}

}