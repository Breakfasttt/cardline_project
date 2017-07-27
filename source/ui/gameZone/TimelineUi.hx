package ui.gameZone;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import source.ui.skin.CardSkin;
import ui.elements.Card;

import flixel.addons.ui.FlxUILine;

/**
 * ...
 * @author Breakyt
 */
class TimelineUi 
{

	private static var m_linePositionY : Int = 300;
	
	private static var m_lineOffset : Int = 25;
	
	private static var m_cardOffset : Int = 25;
	
	/**
	 * Groups
	 */	
	private var m_groupRef : FlxGroup;
	
	private var m_displayGroup : FlxGroup;
	
	/**
	 * UI elements
	 */
	private var m_upBorder : FlxUILine;
	private var m_downBorder : FlxUILine;
	private var m_putZone : FlxSprite;
	private var m_putZoneCollider : FlxSprite;
	
	private var m_leftCollider : FlxSprite;
	private var m_rightCollider : FlxSprite;
	
	/**
	 * Card management
	 */
	private var m_cards : Array<Card>;
	
	private var m_actualIndex : Int;
	
	private var m_firstCardPosition : FlxPoint;
	
	
	/**
	 * Move management
	 */
	
	private static var m_tempoBeforeMove : Float = 0.450;
	private var m_elapsedTime : Float;
	
	
	public function new() 
	{
		m_groupRef = null;
		m_displayGroup = new FlxGroup();
		m_cards = new Array<Card>();
		m_actualIndex = 0;
		m_elapsedTime = 0;

		initBorders();
		initPutZone();
		initCollider();
	}
	
	/**
	 * Use this to add into a state for display (or a subgroup of haxeflixel)
	 * Pass null in parameters to detach this ui.
	 * @param	group
	 */
	public function attachTo(group : FlxGroup) : Void
	{	
		if (m_groupRef != null)
			m_groupRef.remove(m_displayGroup);
		
		m_groupRef = group;
		
		if (m_groupRef != null)
			m_groupRef.add(m_displayGroup);
	}
	
	private function initBorders() : Void
	{
		m_upBorder = new FlxUILine(0, m_linePositionY, LineAxis.HORIZONTAL, 1920, 5, FlxColor.WHITE);
		m_downBorder = new FlxUILine(0, Std.int(m_upBorder.y) +  CardSkin.cardHeight + m_lineOffset * 2, LineAxis.HORIZONTAL, 1920, 5, FlxColor.WHITE);
		
		m_displayGroup.add(m_upBorder);
		m_displayGroup.add(m_downBorder);
	}
	
	private function initPutZone() : Void
	{
		m_putZone = new FlxSprite(0, m_linePositionY + m_lineOffset, null);
		m_putZone.makeGraphic(CardSkin.cardWidth, CardSkin.cardHeight, FlxColor.TRANSPARENT);
		
		var ticknessValue : Int = 5;
		var extend : Int = 0;
		var borderW = CardSkin.cardWidth  + extend + ticknessValue;
		var borderH = CardSkin.cardHeight +extend  + ticknessValue;		
		
		m_putZone.makeGraphic(borderW, borderH, FlxColor.TRANSPARENT);
		
		var lineStyle:LineStyle = { thickness: 5, color: FlxColor.WHITE };
		FlxSpriteUtil.drawRoundRect(m_putZone, ticknessValue/2, ticknessValue/2, CardSkin.cardWidth + extend, CardSkin.cardHeight + extend, 25.0, 25.0, FlxColor.TRANSPARENT, lineStyle);		
		
		m_putZone.color = FlxColor.YELLOW;
		
		m_putZone.screenCenter(FlxAxes.X);
		m_firstCardPosition = new FlxPoint(m_putZone.x + m_putZone.width + m_cardOffset, m_putZone.y);
		
		m_putZoneCollider = new FlxSprite();
		m_putZoneCollider.makeGraphic( Math.ceil(CardSkin.cardWidth * 0.3), Math.ceil(CardSkin.cardHeight * 0.3), FlxColor.TRANSPARENT);
		
		m_putZoneCollider.x = m_putZone.x + m_putZone.width / 2.0 - m_putZoneCollider.width / 2.0;
		m_putZoneCollider.y = m_putZone.y + m_putZone.height / 2.0 - m_putZoneCollider.height / 2.0;
		
		m_displayGroup.add(m_putZoneCollider);
		m_displayGroup.add(m_putZone);
	}
	
	private function initCollider() : Void
	{
		m_leftCollider = new FlxSprite();
		m_rightCollider = new FlxSprite();
		
		m_leftCollider.makeGraphic(Math.ceil(CardSkin.cardWidth * 1.5), CardSkin.cardHeight + 2 * m_lineOffset - Math.ceil(m_upBorder.thickness) , FlxColor.TRANSPARENT);
		m_rightCollider.makeGraphic(Math.ceil(CardSkin.cardWidth * 1.5), CardSkin.cardHeight + 2 * m_lineOffset - Math.ceil(m_upBorder.thickness) , FlxColor.TRANSPARENT);
		
		m_leftCollider.setPosition(0, m_linePositionY + m_upBorder.thickness);
		m_rightCollider.setPosition(FlxG.width - m_rightCollider.width, m_linePositionY + m_upBorder.thickness);
		
		m_displayGroup.add(m_leftCollider);
		m_displayGroup.add(m_rightCollider);
	}
	
	public function addCard(card : Card) : Bool
	{
		if (m_cards == null)
			return false;
		
		if (card == null)
			return false;
		
		var precCard : Card = null;
		var nextCard : Card = null;
		var result : Bool = false;
		var valueSelected : String = GameDatas.self.selectedValue;
		
		if (m_cards.length != 0)
		{
			if (m_actualIndex == 0)
			{
				precCard = null;
				nextCard = m_cards[m_actualIndex];
				
				if (nextCard.data.value.get(valueSelected) >= card.data.value.get(valueSelected))
					result = true;
					
			}
			else if (m_actualIndex >= m_cards.length)
			{
				precCard = m_cards[m_cards.length - 1];
				nextCard = null;
				
				if (precCard.data.value.get(valueSelected) <= card.data.value.get(valueSelected))
					result = true;
			}
			else
			{
				precCard = m_cards[m_actualIndex - 1];
				nextCard = m_cards[m_actualIndex];
				
				if (nextCard.data.value.get(valueSelected) >= card.data.value.get(valueSelected) &&
					precCard.data.value.get(valueSelected) <= card.data.value.get(valueSelected))
				{
					result = true;
				}
			}
		}
		else
			result = true;
		
		if (!result)
			return result;
		
			
		m_cards.insert(m_actualIndex, card);
		card.skin.scaleSkin(1.0, 1.0);
		card.skin.setVisible(true);
		card.skin.draggable = false;
		
		m_displayGroup.add(card.skin);
		updateCardsPosition();
		
		return result;
	}
	
	public function updateCardsPosition() : Void
	{
		for (i in 0...m_cards.length)
		{
			if (m_cards[i] == null)
				continue;
			
			var x : Float = m_firstCardPosition.x;
			var y : Float = m_firstCardPosition.y;
			
			if ( i < m_actualIndex)
				x = m_firstCardPosition.x - ( (m_actualIndex - i + 1) * (CardSkin.cardWidth + m_cardOffset) ) ;
			else
				x = m_firstCardPosition.x + (i - m_actualIndex) * (CardSkin.cardWidth + m_cardOffset);
				
			m_cards[i].skin.setPosition(x, y);
		}
	}
	
	private function moveIndex(toRight : Bool = true) : Void
	{
		if (toRight)
			m_actualIndex++;
		else
			m_actualIndex--;
			
		if (m_actualIndex < 0)
			m_actualIndex = 0;
		else if (m_actualIndex > m_cards.length)
			m_actualIndex = m_cards.length ;
				
		updateCardsPosition();
	}
	
	public function checkPutCollision(card : Card) : Bool
	{
		var overlap : Bool = false;
		
		if(card != null)
			overlap = FlxG.overlap(card.skin, m_putZoneCollider);
		
		if ( overlap)
			m_putZone.color = FlxColor.BLUE;
		else
			m_putZone.color = FlxColor.YELLOW;
			
		return overlap;
	}
	
	public function checkMoveCollision(elapsedTime : Float, card : Card) : Void
	{
		if (m_elapsedTime > 0.0)
		{
			m_elapsedTime -= elapsedTime;
			return;
		}
		
		if(FlxG.overlap(card.skin, m_leftCollider))
			this.moveIndex(false);
		else if (FlxG.overlap(card.skin, m_rightCollider))
			this.moveIndex();
			
		m_elapsedTime = m_tempoBeforeMove;	
	}
	
	public function reinitPutColor() : Void
	{
		if (m_putZone != null)
			m_putZone.color = FlxColor.YELLOW;
	}
}