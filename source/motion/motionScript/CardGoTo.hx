package motion.motionScript;

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
	
	
	public function new(ref:CardSkin, speed:Float, target : FlxPoint, withArrival : Bool, endingCallBack:CardSkin->Void) 
	{
		super(ref, speed, endingCallBack);
		m_target = target;
		m_withArrival = withArrival;
		m_startPosition = ref.getPosition();
		
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
		
		if (m_withArrival)
		{
			var slow = Math.max((dist / m_lengthForArrival), 0.50);
			newX = distanceVector.x * speed * slow * elapsed ;
			newY = distanceVector.y * speed * slow * elapsed ;
		}
		else
		{
			newX = distanceVector.x * speed * elapsed ;
			newY = distanceVector.y * speed * elapsed ;
		}
		
		this.cardSkinRef.addPosition(newX, newY);
	}
	
}