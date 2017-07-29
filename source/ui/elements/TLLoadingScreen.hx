package ui.elements;
import assets.AssetPaths;
import assets.AssetsManager;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

/**
 * ...
 * @author Breakyt
 */
class TLLoadingScreen 
{

	public var spriteGroup(default, null) : FlxGroup;
	
	private var m_background : FlxSprite;
	private var m_title : FlxText;
	private var m_infos : FlxText;
	
	private var m_globalLoadingBar : FlxSprite;
	//private var m_currentLoadingBar : FlxSprite;
	
	public function new() 
	{
		initBg();
		initTitle();
		initInfos();
		initGlobalLoadingBar();
		//initCurrentLoadingBar();
		
		this.spriteGroup = new FlxGroup();
		
		this.spriteGroup.add(m_background);
		this.spriteGroup.add(m_title);
		this.spriteGroup.add(m_infos);
		this.spriteGroup.add(m_globalLoadingBar);
		//this.spriteGroup.add(m_currentLoadingBar);
	}
	
	private function initBg() : Void
	{
		m_background = new FlxSprite(0, 0, AssetsManager.global.getFlxGraphic(AssetPaths.menuBg__jpg));
		//other stuff ?
	}
	
	private function initTitle() : Void
	{
		m_title = new FlxText(0,150);
		m_title.text = "Chargement";
		m_title.setFormat(AssetPaths.OldNewspaperTypes__ttf,45);
		m_title.screenCenter(FlxAxes.X);
	}
	
	private function initInfos() : Void
	{
		m_infos = new FlxText(0,400);
		m_infos.setFormat(AssetPaths.OldNewspaperTypes__ttf, 36);
		
	}
	
	private function initGlobalLoadingBar() : Void
	{
		m_globalLoadingBar = new FlxSprite(50, 475);
		m_globalLoadingBar.makeGraphic((1920 - 100), 50); // Beurk le hard coding !! han lalala !!!
		m_globalLoadingBar.origin.set(0,0); // test 
	}
	
	/*private function initCurrentLoadingBar() : Void
	{
		m_currentLoadingBar = new FlxSprite(50, 475 + 50 + 75);
		m_currentLoadingBar.makeGraphic((1920 - 100), 50); // Beurk le hard coding !! han lalala !!! (et en plus il copie colle !!)
		m_currentLoadingBar.origin.set(0,0);
	}*/
	
	public function setInfos(infos : String) : Void
	{
		if (m_infos == null)
			return;
			
		m_infos.text = infos;
		m_infos.screenCenter(FlxAxes.X);
	}
	
	public function updateGlobalBar(value : Float)
	{
		m_globalLoadingBar.scale.x = value;
	}
	
	/*public function updateCurrentBar(value : Float)
	{
		m_currentLoadingBar.scale.x = value;
	}*/
	
	
}