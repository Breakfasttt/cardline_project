package data.manager;

/**
 * ...
 * @author Breakyt
 */
class GameDatas 
{

	public static var self(default, null) : GameDatas = new GameDatas();
	
	
	public var extentionManager(default, null) : CardExtentionManager;
	
	public var selectedValue : String;
	
	public var selectedExtention : Array<String>;
	
	private function new() 
	{
		extentionManager = new CardExtentionManager();
		selectedValue = null;
		selectedExtention = null;
	}
}