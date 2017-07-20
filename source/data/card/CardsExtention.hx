package data.card;
import assets.AssetPaths;
import flixel.FlxG;
import flixel.system.debug.log.Log;
import haxe.Json;
import openfl.Assets;
import source.data.card.CardData;

/**
 * ...
 * @author Breakyt
 */

 typedef CardInfos =
 {
	var name : String;
	var year : Int;
 }
 
class CardsExtention 
{

	public var name(default, null) : String;
	
	private var m_extentionJsonFilePath : String;
	private var m_extentionJsonFileName : String;
	private var m_fullpath : String;
	
	private var m_rawData : String;
	
	private var m_allCardData : Array<CardData>;
	
	public function new(name : String, JsonFilename : String, Jsonfilepath : String = "./") 
	{
		this.name = name;
		m_extentionJsonFileName = JsonFilename;
		m_extentionJsonFilePath = Jsonfilepath;
		m_fullpath = m_extentionJsonFilePath + m_extentionJsonFileName;
		
	}
	
	private function loadRawData() : Bool
	{
		m_rawData = Assets.getText(m_fullpath);
		if (m_rawData == null)
		{
			trace("Card extention " + name + " : file not found [" + m_fullpath + "]" );
			FlxG.log.warn("Card extention " + name + " : file not found [" + m_fullpath + "]" );
			return false;
		}
		
		return true;
	}
	
	private function parseRawData() : Bool
	{
		m_allCardData = new Array();
		
		if (m_rawData == null)
			return false;
		
		var allCardinfos : Array<CardInfos> = null;
		
		try
		{
			allCardinfos = Json.parse(m_rawData);
		}
		catch (e : Dynamic)
		{
			trace("Fail to parse Json for extention " + this.name + " because " + e);
			FlxG.log.error("Fail to parse Json for extention " + this.name + " because " + e);
			return false;
		}
		
		if (allCardinfos == null)
			return false;
		
		for (info in allCardinfos)
		{
			m_allCardData.push(new CardData(info.name, info.year));
		}
		
		return true;
	}
	
	public function init() : Bool
	{
		this.release();
		
		var loadResult : Bool = this.loadRawData();
		var loadParse : Bool = this.parseRawData();
		
		return loadResult && loadParse;
	}
	
	public function release() : Void
	{
		m_rawData = null;
		
		if(m_allCardData!=null)
			for (card in m_allCardData)
				card.release();
			
		m_allCardData = null;
	}
	
	public function getNbrCard() : Int
	{
		if (m_allCardData == null)
			return 0;
		
		return m_allCardData.length;
	}
	
	public function getTLCard(cardIndex : Int) : CardData
	{
		if (m_allCardData == null)
			return null;
		else if (m_allCardData.length == 0)
			return null;
		else if (cardIndex < 0 || cardIndex >= m_allCardData.length)
			return null;
			
		return m_allCardData[cardIndex];
	}
	
	public function getRandomCard() : CardData
	{
		if (m_allCardData == null)
			return null;
		else if (m_allCardData.length == 0)
			return null;
		
		var rand : Int = Std.random(m_allCardData.length);
		return m_allCardData[rand];
	}
	
	public function GetAllCard() : Array<CardData>
	{
		if (m_allCardData  == null)
			return null;
			
		return m_allCardData.copy();
	}
	
	
	
}