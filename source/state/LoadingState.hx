package state;

import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author Breakyt
 */
class LoadingState extends FlxState 
{

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		//Loading & initialisation of datas game
		GameDatas.self.init();
		
		
		//all init change state
		FlxG.switchState(new MenuState());
	}
	
}