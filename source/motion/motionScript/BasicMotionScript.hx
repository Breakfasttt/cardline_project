package motion.motionScript;
import source.ui.skin.CardSkin;

/**
 * ...
 * @author Breakyt
 */
class BasicMotionScript 
{

	/**
	 * The CardSkin reference. Don't set to null or call cardSkinRef.destroy()
	 * Call this.release() to cleanup the script
	 * use
	 */
	public var cardSkinRef(default, null) : CardSkin;
	
	/**
	 * The motion speed. Unit depend of specific script
	 */
	public var speed : Float; 
	
	/**
	 * Set this bool when motion is ended
	 */
	public var isEnded : Bool;
	
	/**
	 * The callback called when motion is finished
	 */
	private var m_endingCallback : CardSkin->Void;
	
	public function new(ref : CardSkin, speed : Float, endingCallBack : CardSkin->Void) 
	{
		this.isEnded = false;
		this.cardSkinRef = ref;
		this.speed = speed;
		m_endingCallback = endingCallBack;
	}
	
	public function update(elapsed : Float)
	{
		//need to be override
	}
	
	public function release() : Void
	{
		this.cardSkinRef = null;
		m_endingCallback = null;
	}
	
}