package;

import assets.AssetPaths;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets;
import openfl.display.Sprite;
import state.LoadingState;
import state.MenuState;
import state.PlayState;
import assets.CardlinePreloader;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		FlxAssets.FONT_DEFAULT = AssetPaths.OldNewspaperTypes__ttf;
		
		var fullscreen : Bool = false;
		#if html5
			fullscreen = true;
		#end
		
		addChild(new FlxGame(1920, 1080, LoadingState, 1.0, 60 , 60, true, fullscreen));
		FlxG.plugins.add(new FlxMouseEventManager());
		
		
	}
}