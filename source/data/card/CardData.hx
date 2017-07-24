package source.data.card;
import flixel.FlxSprite;


/**
 * ...
 * @author Breakyt
 */
class CardData 
{
	
	public var name(default, null) : String;
	public var background(default,null) : String;
	public var illustration(default,null) : String;
	public var value(default,null) : Map<String,Int>;
	
	public function new(name : String, background : String, illustration : String, value : Map<String,Int>) 
	{
		this.name = name;
		this.background = background;
		this.illustration = illustration;
		this.value = value;
	}
	
	public function getAllPlayableValue() : Array<String>
	{
		var result = new Array();
		for (key in this.value.keys())
		{
			result.push(key);
		}
		return result;
	}
	
	public function release()
	{
		this.name = null;
		this.illustration = null;
		this.value = null;
	}
	
}