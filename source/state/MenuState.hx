package state;

import assets.AssetPaths;
import assets.AssetsManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxButtonPlus;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextFormat;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	private var m_title : FlxText;
	private var m_playBtn : FlxButtonPlus;
	private var m_optionsBtn : FlxButtonPlus;
	private var m_board : FlxSprite;
	
	
	override public function create():Void
	{
		super.create();
		
		m_board = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic(AssetPaths.menuBg__jpg));
		
		m_title = new FlxText(0, 100, -1, "Cardline", 92);
		m_title.screenCenter(FlxAxes.X);
		
		m_playBtn = new FlxButtonPlus(0, 325, onClickPlay, "Jouer", 400, 72);
		
		m_playBtn.textNormal.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_playBtn.textHighlight.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_playBtn.screenCenter(FlxAxes.X);
		
		m_playBtn.updateInactiveButtonColors([FlxColor.BROWN, FlxColor.BROWN, FlxColor.BROWN]);
		m_playBtn.updateActiveButtonColors([FlxColor.BROWN, FlxColor.GRAY]);
		
		m_optionsBtn = new FlxButtonPlus(0, 0, null, "Options", 400, 50);
		m_optionsBtn.x = m_playBtn.x;
		m_optionsBtn.y = m_playBtn.y + m_playBtn.height + 10;
		m_optionsBtn.textNormal.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_optionsBtn.textHighlight.setFormat(FlxAssets.FONT_DEFAULT, 32);
		
		this.add(m_board);
		this.add(m_title);
		this.add(m_playBtn);
		//this.add(m_optionsBtn);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function onClickPlay() : Void
	{
		FlxG.switchState(new ConfigGameState());
	}
}