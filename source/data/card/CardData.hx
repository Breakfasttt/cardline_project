package source.data.card;
import flixel.FlxSprite;


/**
 * ...
 * @author Breakyt
 */
class CardData 
{
	
	public var name(default,null) : String;
	public var year(default,null) : Int;
	
	public function new(name : String, year : Int) 
	{
		this.name = name;
		this.year = year;
	}
	
	public function release()
	{
		this.name = null;
		this.year = -1;
	}
	
}