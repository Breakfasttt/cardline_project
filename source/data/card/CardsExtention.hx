package data.card;
import assets.AssetPaths;
import assets.AssetsManager;
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
	var illustration : String;
	var values : Dynamic; // map string/int
 } 
 
 typedef ExtentionInfos = 
 {
	var name : String;
	var background : String;
	var illusFolder : String;
	var cards : Array<CardInfos>;
 }
 
class CardsExtention 
{

	public var name(default, null) : String;
	private var m_uniqueId : String;
	
	public var extentionFile(default,null) : String;
	
	private var m_rawData : String;
	
	private var m_allCardData : Array<CardData>;
	
	private var m_backgroundFile : String;
	
	private var m_playableValue : Array<String>;
	
	public function new(uniqueId : String, extentionFolder : String, extentionFile : String) 
	{
		m_uniqueId = uniqueId;
		this.extentionFile = extentionFolder + extentionFile;
	}
	
	public function init() : Bool
	{
		this.release();
		m_rawData = AssetsManager.global.getText(extentionFile);
		return this.parseRawData();
	}	
	
	private function parseRawData() : Bool
	{
		m_allCardData = new Array();
		
		if (m_rawData == null)
			return false;
		
		var extentionInfos : ExtentionInfos = null;
		
		try
		{
			extentionInfos = Json.parse(m_rawData);
		}
		catch (e : Dynamic)
		{
			trace("Fail to parse Json for extention " + this.name + " because " + e);
			FlxG.log.error("Fail to parse Json for extention " + this.name + " because " + e);
			return false;
		}
		
		this.name = extentionInfos.name;
		m_backgroundFile = extentionInfos.background;
		var illusFolder : String = extentionInfos.illusFolder;
		
		
		if (extentionInfos == null)
			return false;
		
		m_playableValue = new Array();	
		for (card in extentionInfos.cards)
		{
			var mapResult : Map<String, Int> = new Map<String, Int>();
			var allValues : Array<String> = Reflect.fields(card.values);
			
			for (value in allValues)
			{
				mapResult.set(value, Reflect.getProperty(card.values, value));
				
				if (!Lambda.has(m_playableValue, value))
					m_playableValue.push(value);
			}
			
			m_allCardData.push(new CardData(card.name, m_backgroundFile, illusFolder + card.illustration, mapResult));
		}
		
		return true;
	}
	

	public function release() : Void
	{
		m_rawData = null;
		
		if(m_allCardData!=null)
			for (card in m_allCardData)
				card.release();
			
		m_allCardData = null;
	}
	
	public function getAllIllustrationPath() : Array<String>
	{
		var result : Array<String> = [m_backgroundFile];
		
		for (card in m_allCardData)
		{
			if(!Lambda.has(result, card.illustration))
				result.push(card.illustration);
		}
		return result;
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