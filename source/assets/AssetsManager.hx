package assets;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import lime.app.Future;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.ByteArray;


/**
 * An enum to get the file type with the file extention
 */
enum FileType
{
	text;
	bitmap;
	sound;
	bytes;
	musics;
	font;
}

/**
 * Wrapper class For loading Assync assets with openFL/lime
 * After loading, use only openfl.Assets.get...
 * @author Breakyt
 */
class AssetsManager 
{
	/**
	 * a static var to get the main AssetsManager
	 */
	public static var global : AssetsManager;
	
	/**
	 * A map to associate file extention to an enum for use correct loader
	 */
	private static var m_extByFileType : Map<FileType, Array<String>> = [
		FileType.text => ["txt", "json", "xml", "csv", "dat", "ini"],
		FileType.bitmap => ["jpeg", "jpg", "png", "bmp"],
		FileType.sound => ["wav"],
		FileType.musics => ["mp3", "ogg"],
		FileType.font => ["ttf", "otf"],
		FileType.bytes => ["zip"],
	];
	
	/**
	 * Tempon map if a loading currently loading and call loadFiles() a second times before loading 
	 * are curently running
	 */
	private var m_waitForLoading : Map< Array<String>, Array<String>->Void >;
	
	/**
	 * The files currently loading/loaded
	 */
	private var m_currentlyLoading : Array<String>;	
	private var m_currentlyLoaded : Array<String>;
	private var m_currentlyFailed : Array<String>;
	
	/**
	 * If currently loading files
	 */
	private var m_isLoading : Bool;
	
	/**
	 * Global callback when loading finish
	 */
	private var m_onCompleteCallback : Array<String>->Void;
	
	/**
	 * Global progress callback. 
	 * files -> totalfiles -> currentfiles progress % -> Current File name-> void
	 */
	private var m_onProgressCallback : Int -> Int -> Float -> String -> Void; 
	
	
	/**
	 * A fix to openFL.Assets.cache who don't stock the asynchronous loaded text/bytearray
	 */
	private var m_textCache : Map<String,String>;
	private var m_bytesCache : Map<String,ByteArray>;
	 
	
	public function new(progressCb : Int -> Int -> Float -> String -> Void = null) 
	{
		m_waitForLoading = new Map();
		m_currentlyLoading = new Array<String>();
		m_currentlyLoaded = new Array<String>();
		m_currentlyFailed = new Array<String>();
		m_isLoading = false;
		
		m_onCompleteCallback = null;
		m_onProgressCallback = progressCb;
		
		m_textCache = new Map();
		m_bytesCache = new Map();
		
		if (global == null)
			global = this;
		
	}
	
	/**
	 * Load an array of files
	 * You can ca
	 * @param	files
	 * @param	onComplete
	 */
	public function loadFiles(files : Array<String>, onComplete : Array<String>->Void = null) : Void
	{
		files = makeLoadingFileUnique(files);
		
		if (m_isLoading)
		{
			m_waitForLoading.set(files, onComplete);
		}
		else
		{
			m_currentlyLoading = m_currentlyLoading.concat(files.copy());
			m_onCompleteCallback = onComplete;
			startLoad();
		}
	}
	
	private function makeLoadingFileUnique(files : Array<String>) : Array<String>
	{
		var temp : Array<String> = new Array<String>();
		
		while (files.length != 0)
		{
			var file : String = files.pop();
			
			if (Lambda.has(files, file))
				files.remove(file);
				
			temp.push(file);
		}
		
		return files = files.concat(temp);
	}
	
	//loading function
	
	private function startLoad() : Void
	{
		if (m_isLoading)
		{
			FlxG.log.warn("Can't start a loading because another is currently running");
			return;
		}
		
		m_currentlyLoaded = new Array();
		m_currentlyFailed = new Array();
		m_isLoading = true;
		nextLoading();
	}
	
	private function nextLoading() : Void
	{
		if (m_currentlyLoading.length == 0)
		{
			m_isLoading = false;
			
			if (m_waitForLoading.keys().hasNext())
			{
				m_currentlyLoading = m_waitForLoading.keys().next();
				m_onCompleteCallback = m_waitForLoading.get(m_currentlyLoading);
				m_waitForLoading.remove(m_currentlyLoading);
				startLoad();
			}
			else
			{
				if(m_onCompleteCallback != null)
					m_onCompleteCallback(m_currentlyLoaded.copy());
			}
		}
		else
		{
			var fileToLoad : String = m_currentlyLoading.pop();
			
			if (fileToLoad == null)
			{
				trace("Can't load null files");
				nextLoading();
				return;
			}
			
			if (exist(fileToLoad))
			{
				trace("Files already loaded, skipping : " + fileToLoad);
				nextLoading();
				return;
			}
			
			var type : FileType = getFileType(fileToLoad);
			
			if (type == null)
			{
				FlxG.log.error("File : " + fileToLoad + " has no extention. Skipping");
				nextLoading();
				return;
			}		
			
			switch(type)
			{
				case FileType.text : loadText(fileToLoad);
				case FileType.sound : loadSound(fileToLoad);
				case FileType.musics : loadMusic(fileToLoad);
				case FileType.bitmap : loadBitmap(fileToLoad);
				case FileType.font : loadFont(fileToLoad);
				case FileType.bytes : loadBytes(fileToLoad);
				default : loadText(fileToLoad); // must be loadBytes, but don't work (see comment at loadByte fct)
			}
		}
	}
	
	private function loadText(file : String)
	{
		var future  = Assets.loadText(file);
		future.onComplete(onTextLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));
	}
	
	private function loadBitmap(file : String)
	{
		var future  = Assets.loadBitmapData(file);
		future.onComplete(onBitmapLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));
	}
	
	private function loadSound(file : String)
	{
		var future  = Assets.loadSound(file);
		future.onComplete(onSoundLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));
	}
	
	private function loadMusic(file : String)
	{
		var future  = Assets.loadMusic(file);
		future.onComplete(onSoundLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));
	}
	
	private function loadFont(file : String)
	{
		var future  = Assets.loadFont(file);
		future.onComplete(onFontLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));
	}
	
	/**
	 * Not working ? 0o Assets.loadBytes seems to load infinite 
	 * note : working with Assets.loadBytes(file, callback) but no progress/error information..
	 */
	private function loadBytes(file : String)
	{
		onError("Actually, can't load bytes file, skipping", file);
		/*var future : Future<ByteArray> =  Assets.loadBytes(file);
		future.onComplete(onBytesLoaded.bind(_, file));
		future.onProgress(onCurrentlyProgress.bind(_,file));
		future.onError(onError.bind(_,file));*/
	}
	

	//on progress callback
	private function onCurrentlyProgress(data : Float, file : String) : Void
	{
		//trace("Current progress for " + file + " is : " + data);
		if (m_onProgressCallback != null)
		{
			var total = m_currentlyLoaded.length + m_currentlyLoading.length + m_currentlyFailed.length;
			var purcentlist = m_currentlyLoaded.length / total;
			m_onProgressCallback(m_currentlyLoaded.length, total, data, file);
		}
		
	}
	
	//========= onCompleteCallback
	
	private function onTextLoaded(data : String, file : String)
	{
		trace("Text succesfully loaded:" + file);
		m_currentlyLoaded.push(file);
		m_currentlyLoading.remove(file);
		m_textCache.set(file, data);
		nextLoading();
	}
	
	private function onBitmapLoaded(data : BitmapData, file : String)
	{
		trace("Bitmap succesfully loaded:" + file);
		m_currentlyLoaded.push(file);
		m_currentlyLoading.remove(file);
		nextLoading();
	}
	
	private function onSoundLoaded(data : Sound, file : String)
	{
		trace("Sound succesfully loaded:" + file);
		m_currentlyLoaded.push(file);
		m_currentlyLoading.remove(file);
		nextLoading();
	}
	
	private function onFontLoaded(data : Font, file : String)
	{
		trace("Font succesfully loaded:" + file);
		m_currentlyLoaded.push(file);
		m_currentlyLoading.remove(file);
		nextLoading();
	}
	
	private function onBytesLoaded(data : ByteArray, file : String)
	{
		trace("Bytes succesfully loaded:" + file);
		m_currentlyLoaded.push(file);
		m_currentlyLoading.remove(file);
		m_bytesCache.set(file, data);
		nextLoading();
	}
	
	// ========= error ========
	
	private function onError(data : Dynamic, file : String) : Void
	{
		trace("AssetsLibrary:: An error has occur : " + data);
		m_currentlyFailed.push(file);
		m_currentlyLoading.remove(file);
		nextLoading();
	}
	
	//============ getter =====================
	
	public function getText(file : String) : String
	{
		if (m_textCache.exists(file))
			return m_textCache.get(file);
			
		return Assets.getText(file);
	}
	
	public function getBytes(file : String) : ByteArray
	{
		if (m_bytesCache.exists(file))
			return m_bytesCache.get(file);
			
		return Assets.getBytes(file);
	}
	
	public function getSound(file : String) : Sound
	{
		return Assets.getSound(file);
	}
	
	public function getMusic(file : String) : Sound
	{
		return Assets.getMusic(file);
	}
	
	public function getBitmapData(file : String) : BitmapData
	{
		return Assets.getBitmapData(file);
	}
	
	public function getFont(file : String) : Font
	{
		return Assets.getFont(file);
	}

	//tools
	
	public function getFlxGraphic(file : String) : FlxGraphic
	{
		//dafuk. When call a second time with same file name, Bitmapdata is corrupted. Maybe the reference is clean by haxeflixel ?
		// call .clone to fix the problem but need to check memory.
		var bmd = this.getBitmapData(file);
		
		if (bmd == null)
			return null;
			
		bmd = bmd.clone();

		if (bmd == null)
			return null;
		return FlxGraphic.fromBitmapData(bmd);
	}
	
	private function getFileType(file : String) : FileType
	{
		
		if (file == null)
			return null;
		
		var splitArr = file.split(".");
		
		if (splitArr.length == 1) //no .ext found
			return null;
		
		var ext = splitArr.pop().toLowerCase();
		
		for (key in m_extByFileType.keys())
		{
			if (Lambda.has(m_extByFileType.get(key), ext))
				return key;
		}
		
		return FileType.bytes; // no define, load has bytes.
	}
	
	public function exist(file : String) : Bool
	{
		if (file == null)
			return false;
		
		var type : FileType = getFileType(file);
		var data : Dynamic = null;
		
		switch(type)
		{
			case FileType.text : data = getText(file);
			case FileType.sound : data = getSound(file);
			case FileType.musics : data = getMusic(file);
			case FileType.bitmap : data = getBitmapData(file);
			case FileType.font : data = getFont(file);
			case FileType.bytes : data = getBytes(file);
			default : data = getText(file); 
		}
		
		return data != null;
	}
}