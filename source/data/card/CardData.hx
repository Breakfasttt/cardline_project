package source.data.card;
import data.card.CardsExtention;
import flixel.FlxSprite;


/**
 * ...
 * @author Breakyt
 */
class CardData 
{
	
	public var extentionRef(default, null) : CardsExtention;
	
	public var name(default, null) : String;
	public var background(default,null) : String;
	public var illustration(default,null) : String;
	public var value(default, null) : Map<String,Float>;
	public var wikilink(default, null)  : String;
	
	public function new(extentionRef : CardsExtention, name : String, background : String, illustration : String, value : Map<String,Float>, wikilink : String = null) 
	{
		this.extentionRef = extentionRef;
		this.name = name;
		this.background = background;
		this.illustration = illustration;
		this.value = value;
		this.wikilink = wikilink;
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