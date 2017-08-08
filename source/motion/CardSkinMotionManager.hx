package motion;
import flixel.FlxBasic;
import motion.motionScript.BasicMotionScript;
import source.ui.skin.CardSkin;

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
	
	public function remove(skin : CardSkin, classToRemove : Class<BasicMotionScript> = null)
	{
		for (script in m_motionScripts)
		{
			if (script.cardSkinRef == skin)
			{
				if (classToRemove != null)
				{
					if (Type.getClass(script) == classToRemove)
						script.isEnded = true;
				}
				else
				{
					script.isEnded = true;
				}
			}
		}
	}
}