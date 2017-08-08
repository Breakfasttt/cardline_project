package motion;
import flixel.FlxBasic;
import motion.motionScript.BasicMotionScript;

/**
 * ...
 * @author Breakyt
 */
class CardSkinMotionManager extends FlxBasic
{

	private var m_motionScripts : Array<BasicMotionScript>;
	
	private var m_toRemove : Array<BasicMotionScript>;
	
	public function new() 
	{
		super();
		m_motionScripts = new Array<BasicMotionScript>();
		m_toRemove = new Array<BasicMotionScript>();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		for (script in m_motionScripts)
		{
			if (script.isEnded)
			{
				m_toRemove.push(script);
				continue;
			}
			script.update(elapsed);
		}
		
		for (script in m_toRemove)
		{
			m_motionScripts.remove(script);	
			script.release();
			script = null;
			
		}
		m_toRemove = new Array<BasicMotionScript>();
	}
	
	public function add(script : BasicMotionScript) : Void
	{
		m_motionScripts.push(script);
	}
}