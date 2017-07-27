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

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new FlxGame(1920, 1080, LoadingState, 1.0, 60 , 60, true, false));
		FlxG.plugins.add(new FlxMouseEventManager());
		FlxAssets.FONT_DEFAULT = AssetPaths.ATypewriterForMe__ttf;
		
	}
}