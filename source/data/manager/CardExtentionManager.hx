package data.manager;
import data.card.CardsExtention;
import flixel.FlxG;
import flixel.util.FlxSort;
import haxe.Json;
import haxe.macro.CompilationServer.ContextOptions;
import openfl.Assets;
import tools.TimelineTools;


typedef ExtentionDef =
{
	var extentionName : String;
	var extentionFile : String;
}

typedef ExtentionDefFile = 
{
	var extentionFolder : String;
	var allExtentions : Array<ExtentionDef>;
}

/**
 * ...
 * @author Breakyt
 */
class CardExtentionManager 
{

	// path for extentions definitions
	private var m_extDefFilename : String;
	private var m_extDefFilepath : String;
	private var m_fullpath : String;
	
	//path to extentions folder
	private var m_extentionsFolderPath : String;
	
	private var m_rawData : String;
	
	private var m_extentions : Map<String, CardsExtention>;
	
	public function new(defFilename : String, defFilepath : String = "./") 
	{
		m_extDefFilename = defFilename;
		m_extDefFilepath = defFilepath;
		m_fullpath = m_extDefFilepath + m_extDefFilename;
		
		m_extentionsFolderPath = "";
	}
	
	public function init() : Void
	{
		releaseExtentions();
		loadDefinitionFile();
		parseRawData();
	}
	
	private function loadDefinitionFile() : Void
	{
		m_rawData = Assets.getText(m_fullpath);
		
		if (m_rawData == null)
		{
			FlxG.log.error("CardExtentionManager:: " + m_fullpath + "Files not found");
		}
	}
	
	private function parseRawData() : Void
	{
		
		m_extentions = new Map();
		
		if (m_rawData == null)
			return;
		
		var data : ExtentionDefFile = null;	
			
		try
		{
			data = Json.parse(m_rawData);
		}
		catch (e : Dynamic)
		{
			FlxG.log.error("CardExtentionManager:: Fail to parse file :" + m_fullpath);
		}
		
		if (data == null)
		{
			FlxG.log.error("CardExtentionManager:: Invalid file :" + m_fullpath);
			return;
		}
		
		m_extentionsFolderPath = data.extentionFolder;
		
		for (extData in data.allExtentions)
		{
			if (m_extentions.exists(extData.extentionName))
			{
				FlxG.log.warn("CardExtentionManager:: Extention " + extData.extentionName + " already exist. Skipped");
				continue;
			}
			
			var loadedExtensions : CardsExtention = new CardsExtention(extData.extentionName, extData.extentionFile, m_extentionsFolderPath);
			
			if(loadedExtensions.init())
				m_extentions.set(loadedExtensions.name, loadedExtensions);
			else
				FlxG.log.warn("CardExtentionManager:: Extention " + loadedExtensions.name + " failed init. Store cancelled");
		}
	}
	
	private function releaseExtentions() : Void
	{
		if (m_extentions != null)
		{
			for (key in m_extentions.keys())
			{	
				m_extentions.set(key, null);
			}
			
			m_extentions = null;
		}	
	}
	
	public function getExtentionByName(extentionName : String) : CardsExtention
	{
		if (m_extentions == null)
			return null;
			
		return m_extentions.get(extentionName);
	}
	
	public function getAllExtentionsName() : Array<String>
	{
		var ret : Array<String> = new Array<String>();
		
		if (m_extentions == null)
			return ret;
			
		for (key in  m_extentions.keys())
			ret.push(key);
			
		ret.sort(TimelineTools.sortByString);
			
		return ret;
	}
}