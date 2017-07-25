package state;

import assets.AssetPaths;
import assets.AssetsManager;
import data.manager.GameDatas;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSpriteUtil;
import lime.utils.Bytes;
import openfl.Assets;
import ui.elements.TLLoadingScreen;

/**
 * ...
 * @author Breakyt
 */
class LoadingState extends FlxState 
{

	private static var m_extCatalog : String = "assets/extentions/extCatalog.json";
	private static var m_defaultBg : String = "assets/images/board.jpg";
	
	private var m_loadingScreen : TLLoadingScreen;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		//start loading assets
		new AssetsManager(onProgress);
		AssetsManager.global.loadFiles( [m_extCatalog, m_defaultBg], onNeededFilesComplete);
	}
	
	private function onProgress(total : Float, current : Float, currentFile : String) : Void
	{
		trace("total = " + total + " current file : " + currentFile + " (" + current +")");
		
		if (m_loadingScreen != null)
		{
			m_loadingScreen.updateGlobalBar(total);
			m_loadingScreen.updateCurrentBar(current);
		}
		
	}
	
	private function onNeededFilesComplete(result : Array<String>) : Void
	{
		trace("NEEDED FILE COMPLETE");
		m_loadingScreen = new TLLoadingScreen();
		this.add(m_loadingScreen.spriteGroup);
		m_loadingScreen.updateGlobalBar(0);
		m_loadingScreen.updateCurrentBar(0);
		
		GameDatas.self.extentionManager.init(m_extCatalog);
		var ext : Array<String> = GameDatas.self.extentionManager.getAllExtentionFiles();
		
		m_loadingScreen.setInfos("Chargement de " + ext.length +  " fichiers d'extension");
		
		AssetsManager.global.loadFiles(ext , onExtentionFileLoaded);
	}
	
	private function onExtentionFileLoaded(result : Array<String>) : Void
	{
		trace("EXTENTION FILE COMPLETE");
		GameDatas.self.extentionManager.initAllExtention();
		
		var allIllus : Array<String> = GameDatas.self.extentionManager.getAllIllustration();
		
		m_loadingScreen.setInfos("Chargement des illustrations des cartes.");
		m_loadingScreen.updateGlobalBar(0);
		m_loadingScreen.updateCurrentBar(0);
		
		AssetsManager.global.loadFiles(allIllus , onIllustrationFileLoaded);	
	}
	
	private function onIllustrationFileLoaded(result : Array<String>) : Void
	{
		//all init change state
		trace("ILLUSTRATION FILE COMPLETE");
		FlxG.switchState(new MenuState());
	}
	

	
}