package assets;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.system.FlxBasePreloader;

/**
 * ...
 * @author Breakyt
 */
class CardlinePreloader  extends FlxBasePreloader
{
	
	private var m_background : Sprite;
	private var m_textField : TextField;

	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{
		super(MinDisplayTime, AllowedURLs);
	}
	
	override function create():Void 
	{
		m_background = new Sprite();
		m_background.addChild(new Bitmap(new BitmapData(this._width, this._height, false, 0x00345e )));//
		this.addChild(m_background);
		
		m_textField = new TextField();
		m_textField.width = this._width;
		m_textField.height = 32;
		m_textField.x = 0.0;
		m_textField.y = 0.0;/*this._height / 2.0 - 32 / 2.0;*/
		m_textField.getTextFormat().align = TextFormatAlign.CENTER;
		m_background.addChild(m_textField);
		
		super.create();
	}
	
	override function destroy():Void 
	{
		m_background = null;
		m_textField = null;
		super.destroy();
	}
	
	override function update(Percent:Float):Void 
	{
		m_textField.htmlText = "Pre-chargement : " + Percent + "%";
		super.update(Percent);
	}
	
}