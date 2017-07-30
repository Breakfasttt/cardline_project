package state;
import assets.AssetPaths;
import assets.AssetsManager;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;

/**
 * ...
 * @author Breakyt
 */
class EndGameState extends FlxState
{ 

	private var m_bg : FlxSprite;
	
	private var m_endTxt : FlxText;
	
	private var m_endButton : FlxButton;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		initBackground();
		initTxt();
		initEndButton();
	}
	
	private function initBackground() : Void
	{
		m_bg = new FlxSprite();
		m_bg.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.board2__jpg));
		this.add(m_bg);
	}
	
	private function initTxt() : Void
	{
		m_endTxt = new FlxText();
		m_endTxt.setFormat(AssetPaths.OldNewspaperTypes__ttf, 72);
		m_endTxt.alignment = FlxTextAlign.CENTER;
		
		if(GameDatas.self.isWin)
			m_endTxt.text = "Félicitation pour votre victoire !";
		else
			m_endTxt.text = "Dommage !\nRetourner au menu pour lancer une nouvelle partie.";
			
		m_endTxt.screenCenter(FlxAxes.X);
		m_endTxt.y = 300;
		this.add(m_endTxt);
	}
	
	private function initEndButton() : Void
	{
		m_endButton = new FlxButton(0, 0, "Retour au menu", onEndButtonClick);
		m_endButton.label.setFormat(AssetPaths.OldNewspaperTypes__ttf, 32);
		m_endButton.label.fieldWidth = 300;
		m_endButton.setGraphicSize(300, 75);
		m_endButton.updateHitbox();
		
		m_endButton.screenCenter(FlxAxes.X);
		m_endButton.y = m_endTxt.y + m_endTxt.height + 100;
		this.add(m_endButton);
	}
	
	private function onEndButtonClick() : Void
	{
		FlxG.switchState(new MenuState());
	}
	
}