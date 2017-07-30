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
import haxe.Timer;
import lime.utils.Bytes;
import openfl.Assets;
import ui.elements.TLLoadingScreen;

/**
 * ...
 * @author Breakyt
 */
class LoadingState extends FlxState 
{

	private static var m_defaultFiles : Array<String> = [	AssetPaths.extCatalog__json,
															AssetPaths.board__jpg,
															AssetPaths.board2__jpg,
															AssetPaths.menuBg__jpg,
															AssetPaths.menuGame__jpg,
															AssetPaths.button__png, 
															AssetPaths.githubButton__png,
															AssetPaths.bug__png,
															AssetPaths.twitchBtn__png,
															AssetPaths.twitterBtn__png
														];
	
	private var m_loadingScreen : TLLoadingScreen;
	
	private static var m_totalStep : Int = 2;
	private var m_step : Int;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		//start loading assets
		m_step = -1;
		new AssetsManager(onProgress);
		AssetsManager.global.loadFiles( m_defaultFiles, onNeededFilesComplete);
	}
	
	private function onProgress(nbreFile : Int, totalFile : Int, current : Float, currentFile : String) : Void
	{
		trace("Step : " + (m_step / m_totalStep) + " Files Loaded = " + nbreFile/totalFile + " current file : " + currentFile + " (" + current + ")");
		
		
		var stepPurcentDelta = 1 / m_totalStep;
		var filePurcentDelta = 1 / totalFile;
		
		var purcentStepRealised = m_step * stepPurcentDelta;
		var subPurcentRealiser =  stepPurcentDelta * (nbreFile * filePurcentDelta);
		
		var currentPurcent = 0.0;
		if(current <1.0) // special case when a file is fully loaded. Avoid to count 2 time a files (when % current is at 100%, the file is already count as loaded in nbreFile)
			currentPurcent = filePurcentDelta * current;
			
		var total = purcentStepRealised + subPurcentRealiser + currentPurcent;
		
		if (total < 0.0) // special case for file loaded before the loading screen
			total = 0.0;
		
		trace("currentPurcent = " + total);
		
		
		if (m_loadingScreen != null)
			m_loadingScreen.updateGlobalBar(total);
	}
	
	private function onNeededFilesComplete(result : Array<String>) : Void
	{
		trace("NEEDED FILE COMPLETE");
		m_step = 0;
		m_loadingScreen = new TLLoadingScreen();
		m_loadingScreen.updateGlobalBar(0);
		this.add(m_loadingScreen.spriteGroup);
		
		GameDatas.self.extentionManager.init(AssetPaths.extCatalog__json);
		var ext : Array<String> = GameDatas.self.extentionManager.getAllExtentionFiles();
		
		m_loadingScreen.setInfos("Chargement de " + ext.length +  " fichiers d'extension");
		
		AssetsManager.global.loadFiles(ext , onExtentionFileLoaded);
	}
	
	private function onExtentionFileLoaded(result : Array<String>) : Void
	{
		trace("EXTENTION FILE COMPLETE");
		m_step = 1;
		GameDatas.self.extentionManager.initAllExtention();
		
		var allIllus : Array<String> = GameDatas.self.extentionManager.getAllIllustration();
		
		m_loadingScreen.setInfos("Chargement des illustrations des cartes.");
		
		AssetsManager.global.loadFiles(allIllus , onIllustrationFileLoaded);	
	}
	
	private function onIllustrationFileLoaded(result : Array<String>) : Void
	{
		trace("ILLUSTRATION FILE COMPLETE");
		m_step = 2;
		Timer.delay(goToMenu, 800);
	}
	
	function goToMenu() : Void
	{
		FlxG.switchState(new MenuState());
	}
}