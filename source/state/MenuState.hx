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
import openfl.Lib;
import openfl.net.URLRequest;

class MenuState extends FlxState
{
	private var m_title : FlxText;
	private var m_playBtn : FlxButtonPlus;
	private var m_optionsBtn : FlxButtonPlus;
	private var m_board : FlxSprite;
	
	private var m_goToGithub : FlxButton;
	private var m_goToReportBug : FlxButton;
	private var m_goToTwitch : FlxButton;
	private var m_goToTwitter : FlxButton;
	
	private static var m_playBtnWidth : Int = 400;
	private static var m_buttonSize : Int = 50;
	private static var m_buttonOffset : Float = (m_playBtnWidth - 4 * m_buttonSize) / 3;
	
	override public function create():Void
	{
		super.create();
		
		m_board = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic(AssetPaths.menuBg__jpg));
		
		m_title = new FlxText(0, 100, -1, "Cardline", 92);
		m_title.screenCenter(FlxAxes.X);
		
		m_playBtn = new FlxButtonPlus(0, 325, onClickPlay, "Jouer", m_playBtnWidth, 72);
		
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
		
		this.initGithubBtn();
		this.initReportBtn();
		this.initTwitchBtn();
		this.initTwitterBtn();
		
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
	
	private function goTo(link : String) : Void
	{
		Lib.getURL(new URLRequest(link));
	}
	
	private function initGithubBtn() : Void
	{
		m_goToGithub = new FlxButton(0, 0, "github" , goTo.bind("https://github.com/Breakfasttt/cardline_project"));
		m_goToGithub.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.githubButton__png), true, 256, 256);
		m_goToGithub.setGraphicSize(50, 50);
		m_goToGithub.updateHitbox();
		m_goToGithub.setPosition(m_playBtn.x, m_playBtn.y + m_playBtn.height + 65);
		
		this.add(m_goToGithub);
	}
	
	private function initReportBtn() : Void
	{
		m_goToReportBug = new FlxButton(0, 0, "report bug" , goTo.bind("https://github.com/Breakfasttt/cardline_project/issues"));
		m_goToReportBug.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.bug__png), true, 128, 128);
		m_goToReportBug.setGraphicSize(m_buttonSize, m_buttonSize);
		m_goToReportBug.updateHitbox();
		m_goToReportBug.setPosition(m_goToGithub.x + m_goToGithub.width + m_buttonOffset , m_goToGithub.y);
		
		this.add(m_goToReportBug);
	}
	
	private function initTwitchBtn() : Void
	{
		m_goToTwitch = new FlxButton(0, 0, "twitch" , goTo.bind("https://www.twitch.tv/breakfast_fr"));
		m_goToTwitch.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.twitchBtn__png), true, 256, 256);
		m_goToTwitch.setGraphicSize(m_buttonSize, m_buttonSize);
		m_goToTwitch.updateHitbox();
		m_goToTwitch.setPosition(m_goToReportBug.x + m_goToReportBug.width + m_buttonOffset, m_goToReportBug.y);
		
		this.add(m_goToTwitch);
	}
	
	private function initTwitterBtn() : Void
	{
		m_goToTwitter = new FlxButton(0, 0, "twitter" , goTo.bind("https://twitter.com/breakfast_fr"));
		m_goToTwitter.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.twitterBtn__png), true, 256, 256);
		m_goToTwitter.setGraphicSize(m_buttonSize, m_buttonSize);
		m_goToTwitter.updateHitbox();
		m_goToTwitter.setPosition(m_goToTwitch.x + m_goToTwitch.width + m_buttonOffset, m_goToTwitch.y);
		
		this.add(m_goToTwitter);
	}
}