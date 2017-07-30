package data.manager;
import assets.AssetsManager;
import data.card.CardsExtention;
import flixel.FlxG;
import flixel.util.FlxSort;
import haxe.Json;
import haxe.macro.CompilationServer.ContextOptions;
import openfl.Assets;
import tools.TimelineTools;


typedef ExtentionDef =
{
	var uniqueId : String;
	var extentionFolder : String;
	var extentionFile : String;
}

typedef ExtentionDefFile = 
{
	var extentionsFolder : String;
	var allExtentions : Array<ExtentionDef>;
}

/**
 * ...
 * @author Breakyt
 */
class CardExtentionManager 
{
	//path to extentions folder
	private var m_rawDataFiles : String;
	
	private var m_extentionsFolderPath : String;
	
	private var m_rawData : String;
	
	private var m_extentions : Map<String, CardsExtention>;
	
	public function new() 
	{
		m_extentionsFolderPath = "";
	}
	
	public function init(rawDataFile : String) : Void
	{
		m_rawDataFiles = rawDataFile;
		m_rawData = AssetsManager.global.getText(m_rawDataFiles);
		releaseExtentions();
		parseRawData();
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
			FlxG.log.error("CardExtentionManager:: Fail to parse file :" + m_rawDataFiles);
		}
		
		if (data == null)
		{
			FlxG.log.error("CardExtentionManager:: Invalid file :" + m_rawDataFiles);
			return;
		}
		
		m_extentionsFolderPath = data.extentionsFolder;
		
		for (extData in data.allExtentions)
		{
			if (m_extentions.exists(extData.uniqueId))
			{
				FlxG.log.warn("CardExtentionManager:: Extention " + extData.uniqueId + " already exist. Skipped");
				continue;
			}
			
			var loadedExtensions : CardsExtention = new CardsExtention(extData.uniqueId, m_extentionsFolderPath + extData.extentionFolder, extData.extentionFile);
			m_extentions.set(extData.uniqueId, loadedExtensions);
		}
	}
	
	
	public function getAllExtentionFiles() : Array<String>
	{
		var result : Array<String> = new Array();
		for (ext in m_extentions)
		{
			if(!Lambda.has(result, ext.extentionFile))
				result.push(ext.extentionFile);
		}
			
		return result;
	}
	
	public function initAllExtention() : Void
	{
		for (ext in m_extentions)
			ext.init();
	}
	
	public function getAllIllustration() : Array<String>
	{
		var result : Array<String> = new Array();
		for (ext in m_extentions)
			result = result.concat(ext.getAllIllustrationPath());
			
		return result;
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
	
	public function getExtentionName(uniqueId : String) : String
	{
		var ext : CardsExtention = getExtentionByUniqueId(uniqueId);
		if (ext == null)
			return "";
		
		return ext.name;
	}
	
	public function getExtentionByUniqueId(uniqueId : String) : CardsExtention
	{
		if (m_extentions == null)
			return null;
			
		return m_extentions.get(uniqueId);
	}
	
	public function getAllExtentionsUniqueId() : Array<String>
	{
		var ret : Array<String> = new Array<String>();
		
		if (m_extentions == null)
			return ret;
			
		for (key in  m_extentions.keys())
			ret.push(key);
			
		ret.sort(TimelineTools.sortByString);
			
		return ret;
	}
	
	public function getAllExtentionsName() : Array<String>
	{
		
		var ret : Array<String> = new Array<String>();
		
		if (m_extentions == null)
			return ret;
			
		for (key in  m_extentions.keys())
			ret.push(m_extentions.get(key).name);
			
		ret.sort(TimelineTools.sortByString);
			
		return ret;
	}
	
	public function getExtentionByName(extName : String) : CardsExtention
	{
		
		if (m_extentions == null)
			return null;
			
		for (key in m_extentions.keys())
		{
			var result = m_extentions.get(key);
			if (result.name == extName)
				return result;
		}
			
		return null;
	}
	
	public function getAllPlayableValueByExtentionsUID(uniqueIds : Array<String>) : Array<String>
	{
		var result : Array<String> = new Array<String>();
		
		if (uniqueIds == null)
			return result;
		else if (m_extentions == null)
			return result;
			
		for (name in uniqueIds)
		{
			var ext : CardsExtention = this.getExtentionByUniqueId(name);
			
			if (ext == null)
				continue;
				
			var tempResult : Array<String> = ext.getPlayableValue();
			
			if (tempResult == null)
				continue;
				
			for (value in tempResult)
			{
				if (!Lambda.has(result, value))
					result.push(value);
			}	
		}
		
		return result;		
		
	}
	
	public function getAllPlayableValueByExtentionsName(arrExtName : Array<String>) : Array<String>
	{
		var result : Array<String> = new Array<String>();
		
		if (arrExtName == null)
			return result;
		else if (m_extentions == null)
			return result;
			
		for (name in arrExtName)
		{
			var ext : CardsExtention = this.getExtentionByName(name);
			
			if (ext == null)
				continue;
				
			var tempResult : Array<String> = ext.getPlayableValue();
			
			if (tempResult == null)
				continue;
				
			for (value in tempResult)
			{
				if (!Lambda.has(result, value))
					result.push(value);
			}
				
		}
		
		return result;
	}
	
	public function getNbreCardOfExtention(uniqueId : String) : Int
	{
		var ext : CardsExtention = this.getExtentionByUniqueId(uniqueId);
		if (ext == null)
			return 0;
			
			
		return ext.getNbrCard();	
	}
}