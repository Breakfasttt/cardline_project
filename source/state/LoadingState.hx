package state;

import assets.AssetsManager;
import data.manager.GameDatas;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import lime.utils.Bytes;
import openfl.Assets;

/**
 * ...
 * @author Breakyt
 */
class LoadingState extends FlxState 
{

	private static var m_extCatalog : String = "assets/extentions/extCatalog.json";
	private static var m_defaultBg : String = "assets/images/board.jpg";
	
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
	}
	
	private function onNeededFilesComplete(result : Array<String>) : Void
	{
		trace("NEEDED FILE COMPLETE");
		GameDatas.self.extentionManager.init(m_extCatalog);
		var ext : Array<String> = GameDatas.self.extentionManager.getAllExtentionFiles();
		AssetsManager.global.loadFiles(ext , onExtentionFileLoaded);
	}
	
	private function onExtentionFileLoaded(result : Array<String>) : Void
	{
		trace("EXTENTION FILE COMPLETE");
		GameDatas.self.extentionManager.initAllExtention();
		AssetsManager.global.loadFiles( GameDatas.self.extentionManager.getAllIllustration(), onIllustrationFileLoaded);	
	}
	
	private function onIllustrationFileLoaded(result : Array<String>) : Void
	{
		//all init change state
		trace("ILLUSTRATION FILE COMPLETE");
		FlxG.switchState(new MenuState());
	}
	

	
}