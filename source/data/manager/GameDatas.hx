package data.manager;

/**
 * ...
 * @author Breakyt
 */
class GameDatas 
{

	public static var self(default, null) : GameDatas = new GameDatas();
	
	
	public var extentionManager(default, null) : CardExtentionManager;
	
	private function new() 
	{
		
	}
	
	public function init() : Void
	{
		extentionManager = new CardExtentionManager("extentionDefinition.json", "assets/data/");
		extentionManager.init();
	}
	
	
	
	
	
}