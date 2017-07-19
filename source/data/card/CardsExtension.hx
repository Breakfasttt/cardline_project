package data.card;
import assets.AssetPaths;
import flixel.FlxG;
import flixel.system.debug.log.Log;
import haxe.Json;
import openfl.Assets;
import source.data.card.TLCard;

/**
 * ...
 * @author Breakyt
 */

 typedef CardInfos =
 {
	var name : String;
	var year : Int;
 }
 
class CardsExtension 
{

	public var name(default, null) : String;
	
	private var m_extentionJsonFilePath : String;
	private var m_extentionJsonFileName : String;
	private var m_fullpath : String;
	
	private var m_rawData : String;
	
	private var m_allCardData : Array<TLCard>;
	
	public function new(name : String, JsonFilename : String, Jsonfilepath : String = "./") 
	{
		this.name = name;
		m_extentionJsonFileName = JsonFilename;
		m_extentionJsonFilePath = Jsonfilepath;
		m_fullpath = m_extentionJsonFilePath + m_extentionJsonFileName;
		
	}
	
	private function loadRawData() : Void
	{
		m_rawData = Assets.getText(m_fullpath);
		if (m_rawData == null)
		{
			trace("Card extention " + name + " : file not found [" + m_fullpath + "]" );
			FlxG.log.error("Card extention " + name + " : file not found [" + m_fullpath + "]" );
		}	
	}
	
	private function parseRawData() : Void
	{
		m_allCardData = new Array();
		
		if (m_rawData == null)
			return;
		
		var allCardinfos : Array<CardInfos> = null;
		
		try
		{
			allCardinfos = Json.parse(m_rawData);
		}
		catch (e : Dynamic)
		{
			trace("Fail to parse Json for extention " + this.name + " because " + e);
			FlxG.log.error("Fail to parse Json for extention " + this.name + " because " + e);
		}
		
		if (allCardinfos == null)
			return;
		
		for (info in allCardinfos)
		{
			m_allCardData.push(new TLCard(info.name, info.year));
		}
	}
	
	public function init() : Void
	{
		this.release();
		this.loadRawData();
		this.parseRawData();
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
	
	public function getTLCard(cardIndex : Int) : TLCard
	{
		if (m_allCardData == null)
			return null;
		else if (m_allCardData.length == 0)
			return null;
		else if (cardIndex < 0 || cardIndex >= m_allCardData.length)
			return null;
			
		return m_allCardData[cardIndex];
	}
	
	
	
}