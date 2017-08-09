package motion.motionScript;

import flash.display.InteractiveObject;
import flixel.math.FlxPoint;
import source.ui.skin.CardSkin;

/**
 * ...
 * @author Breakyt
 */
class CardGoTo extends BasicMotionScript 
{

	private var m_target : FlxPoint;
	
	private var m_withArrival : Bool;
	
	private var m_startPosition : FlxPoint;
	
	private var m_sens : FlxPoint;
	
	private var m_lengthForArrival : Float;
	
	private var m_endScale : FlxPoint;
	
	private var m_startScale : FlxPoint;
	
	public function new(ref:CardSkin, speed:Float, target : FlxPoint, withArrival : Bool, endScale : FlxPoint, endingCallBack:CardSkin->Void) 
	{
		super(ref, speed, endingCallBack);
		m_target = target;
		m_withArrival = withArrival;
		m_startPosition = ref.getPosition();
		m_startScale = ref.getGeneralScale();
		m_endScale = endScale;
		
		m_sens = FlxPoint.get(m_target.x - m_startPosition.x, m_target.y - m_startPosition.y);
		m_lengthForArrival = Math.sqrt(m_sens.x * m_sens.x + m_sens.y * m_sens.y);
		m_sens.x /= m_lengthForArrival;
		m_sens.y /= m_lengthForArrival;
	}
	
	override public function update(elapsed:Float) 
	{
		if (this.isEnded)
			return;
			
		var actualPosition : FlxPoint = this.cardSkinRef.getPosition();
		var distanceVector : FlxPoint = FlxPoint.get(m_target.x - actualPosition.x, m_target.y - actualPosition.y);
		var distSquare : Float = distanceVector.x * distanceVector.x + distanceVector.y * distanceVector.y;
		var dist : Float = Math.sqrt(distSquare);
		distanceVector.x /= dist;
		distanceVector.y /= dist;
		
		if (dist <= 15)
		{
			this.cardSkinRef.setPosition(m_target.x, m_target.y);
			this.isEnded = true;
			
			if (m_endingCallback != null)
				m_endingCallback(this.cardSkinRef);
			return;
		}
		
		var newX : Float = 0.0;
		var newY : Float = 0.0;
		var ratioDist : Float = dist / m_lengthForArrival;
		
		if (m_withArrival)
		{
			var slow = Math.max(ratioDist*2, 0.50);
			
			if (slow > 1.0)	
				slow = 1.0;
			
			newX = distanceVector.x * speed * slow * elapsed ;
			newY = distanceVector.y * speed * slow * elapsed ;
		}
		else
		{
			newX = distanceVector.x * speed * elapsed ;
			newY = distanceVector.y * speed * elapsed ;
		}
		
		if (m_endScale != null)
		{
			var scaleX = ((m_startScale.x - m_endScale.x) )  * ratioDist + m_endScale.x;
			var scaleY = ((m_startScale.y - m_endScale.y) )  * ratioDist + m_endScale.y;
			this.cardSkinRef.scaleSkin(scaleX, scaleY);
		}
		
		this.cardSkinRef.addPosition(newX, newY);
	}
	
}