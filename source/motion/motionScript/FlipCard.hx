package motion.motionScript;

import flixel.math.FlxPoint;
import source.ui.skin.CardSkin;

/**
 * ...
 * @author Breakyt
 */
class FlipCard extends BasicMotionScript 
{

	private var m_startScale : FlxPoint;
	
	private var m_middleFlip : Bool ;
	
	private var m_currentMotion : Float;
	
	/**
	 * 
	 * @param	ref : the cardskin reference 
	 * @param	speed : the flip speed in scale/sec
	 * @param	endingCallBack
	 */
	public function new(ref:CardSkin, speed : Float, endingCallBack:CardSkin->Void) 
	{
		super(ref, speed, endingCallBack);
		m_startScale = this.cardSkinRef.getGeneralScale();
		m_currentMotion = 1.0;
		m_middleFlip = false;
	}
	
	override public function update(elapsed:Float) 
	{
		if (this.isEnded)
			return;
		
		if(!m_middleFlip)
			m_currentMotion -= elapsed * this.speed;
		else
			m_currentMotion += elapsed * this.speed;
			
		if (m_currentMotion < 0.0)
			m_currentMotion = 0.0;
		else if (m_currentMotion > 1.0)
			m_currentMotion = 1.0;
			
		var newScale = m_startScale.x * m_currentMotion;
		this.cardSkinRef.scaleSkin(newScale, m_startScale.y);
		
		var diff = (CardSkin.cardWidth - CardSkin.cardWidth * newScale) / 2.0;
		
		this.cardSkinRef.setOffset(diff, 0);
		
		if (!m_middleFlip && m_currentMotion <= 0.0)
		{
			m_middleFlip = !m_middleFlip;
			this.cardSkinRef.flip();
		}
		else if (m_middleFlip && m_currentMotion >= 1.0)
		{
			this.isEnded = true;
			if (m_endingCallback != null)
				m_endingCallback(this.cardSkinRef);
		}
		
	}
	
}