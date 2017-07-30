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
	var wikilink : String; // optionnal
 } 
 
 typedef ExtentionInfos = 
 {
	var name : String;
	var background : String;
	var illusFolder : String;
	var unitsName : Dynamic; // optionnal
	var cards : Array<CardInfos>;
 }
 
class CardsExtention 
{
	/**
	 * An extention is valid only if it has 10+ cards
	 */
	public static var validMinNbreCard : Int = 10;
	
	public var name(default, null) : String;
	private var m_uniqueId : String;
	
	public var extentionFile(default,null) : String;
	
	private var m_rawData : String;
	
	private var m_allCardData : Array<CardData>;
	
	private var m_backgroundFile : String;
	
	private var m_playableValue : Map<String, Int>;
	
	private var m_mapUnitsName : Map<String,String>;
	
	/**
	 * An extention is valid only if it has 10+ cards
	 */
	public var isValid : Bool;
	
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
		m_allCardData = new Array<CardData>();
		m_playableValue = new Map<String,Int>();
		m_mapUnitsName = new Map<String,String>();
		
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
		
		if (extentionInfos.unitsName != null) 
		{
			var fields : Array<String> = Reflect.fields(extentionInfos.unitsName);
			for (field in fields)
				m_mapUnitsName.set(field, Reflect.getProperty(extentionInfos.unitsName, field));
		}
		
		var valueValid : Bool = false;
		for (card in extentionInfos.cards)
		{
			var mapResult : Map<String, Float> = new Map<String, Float>();
			var allValues : Array<String> = Reflect.fields(card.values);
			
			for (value in allValues)
			{
				mapResult.set(value, Reflect.getProperty(card.values, value));
				
				if (m_playableValue.exists(value))
				{
					var count = m_playableValue.get(value);
					count++;
					m_playableValue.set(value, count);
					
					if (count >= CardsExtention.validMinNbreCard)
						valueValid = true;
				}
				else
					m_playableValue.set(value, 1);
			}
			
			m_allCardData.push(new CardData(this, card.name, m_backgroundFile, illusFolder + card.illustration, mapResult, card.wikilink));
		}
			
		
		this.isValid = valueValid && (m_allCardData.length >= CardsExtention.validMinNbreCard);
		
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
	
	public function getAllCard() : Array<CardData>
	{
		if (m_allCardData  == null)
			return null;
			
		return m_allCardData.copy();
	}
	
	public function getPlayableValue() : Array<String> 
	{
		if (m_playableValue == null)
			return null;
			
		var result : Array<String> = new Array<String>();
		
		for (key in m_playableValue.keys())
		{
			if (m_playableValue.get(key) >= CardsExtention.validMinNbreCard)
				result.push(key);
		}

		return result;
	}
	
	public function getUnitOfValue(value : String) : String
	{
		if (m_mapUnitsName == null)
			return "";
			
		var result = m_mapUnitsName.get(value);
		
		if (result == null)
			return "";	
			
		return result;
	}
}