package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var m_playBtn : FlxButton;
	
	
	override public function create():Void
	{
		super.create();
		
		this.bgColor = FlxColor.GREEN;
		
		m_playBtn = new FlxButton(0, 0, "play", onClickPlay);
		m_playBtn.label.setFormat(18);
		m_playBtn.setGraphicSize(200, 75);
		m_playBtn.screenCenter(FlxAxes.XY);
		this.add(m_playBtn);
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function onClickPlay() : Void
	{
		FlxG.switchState(new PlayState());
	}
}