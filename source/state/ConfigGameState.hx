package state;


import assets.AssetPaths;
import assets.AssetsManager;
import data.card.CardsExtention;
import data.manager.GameDatas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.ui.FlxUIList;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.FlxSlider;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import tools.TimelineTools;

/**
 * ...
 * @author Breakyt
 */
class ConfigGameState extends FlxState
{

	/**
	 * Other ui 
	 */
	private var m_background : FlxSprite;
	private var m_infos1 : FlxText;
	private var m_infos2 : FlxText;
	var m_playBtn : FlxButtonPlus;
	
	
	/**
	 * UI element for choose extention
	 */
	private var m_allExtention : Array<IFlxUIWidget>;
	private var m_selectedExtention : Array<String>;
	private var m_sliderExtention : FlxSlider;
	private var m_listExtention : FlxUIList;
	
	/**
	 * UI element for choose extention
	 */
	private var m_allValue : Array<IFlxUIWidget>;
	private var m_sliderValue : FlxSlider;
	private var m_listValue : FlxUIList;
	
	
	public function new() 
	{
		super();
	}
	//
	override public function create():Void 
	{
		super.create();
		
		initBg();
		initInfos1();
		initExtentionChoice();
		initInfos2();
		initValueChoice();
		initPlayBtn();

	}
	
	private function initBg() : Void
	{
		m_background = new FlxSprite();
		m_background.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.board2__jpg));
		this.add(m_background);
	}
	
	private function initInfos1() : Void
	{
		m_infos1 = new FlxText(0, 50, -1, "Cocher les extensions avec lesquelles vous voulez jouer : ", 52);
		m_infos1.color = FlxColor.BLACK;
		m_infos1.screenCenter(FlxAxes.X);
		this.add(m_infos1);
	}
	
	private function initInfos2() : Void
	{
		m_infos2 = new FlxText(0, 550, -1, "Cocher la valeur avec laquelle vous voulez jouer : ", 52);
		m_infos2.color = FlxColor.BLACK;
		m_infos2.screenCenter(FlxAxes.X);
		this.add(m_infos2);
	}
	
	private function initExtentionChoice() : Void
	{
		m_allExtention = new Array<IFlxUIWidget>();
		m_selectedExtention = new Array<String>();
		var allExtId : Array<String> = GameDatas.self.extentionManager.getAllExtentionsUniqueId();
		
		for (extId in allExtId)
		{
			var ext : CardsExtention =  GameDatas.self.extentionManager.getExtentionByUniqueId(extId);
			if (ext == null)
			{
				FlxG.log.notice("Extension " + extId + " is unknow");
				continue;
			}
			
			if(!ext.isValid)
			{
				FlxG.log.notice("Extension " + extId + " is invalid (not enough card : " + ext.getNbrCard() + "/" + CardsExtention.validMinNbreCard + ")");
				continue;
			}
			
			var txt : String = ext.name + " (" + ext.getNbrCard() + ")";
			
			var box : FlxUICheckBox = new FlxUICheckBox(0, 0, null, null, txt);
			box.box.setGraphicSize(50, 50);
			box.box.updateHitbox();
			box.button.setGraphicSize(50, 50);
			box.button.updateHitbox();
			box.mark.setGraphicSize(50, 50);
			box.mark.updateHitbox();
			var boxLabel = box.getLabel();
			boxLabel.setFormat(AssetPaths.ATypewriterForMe__ttf,32);
			boxLabel.fieldWidth = 245;
			//boxLabel.color = FlxColor.BLACK;
			box.textX = 5;
			box.textY = 2;
			box.checked = true;
			box.callback = onCheckExtentionId.bind(box, extId);
			m_selectedExtention.push(extId);
			m_allExtention.push(box);
		}
		
		GameDatas.self.selectedExtention = m_selectedExtention;
		
		m_listExtention = new FlxUIList(10, 250, m_allExtention, 1920, 75, "Suivant...", FlxUIList.STACK_HORIZONTAL, 300);

		m_sliderExtention = new FlxSlider(m_listExtention, "scrollIndex", 0, m_listExtention.y + m_listExtention.height, 0, m_allExtention.length - 5, 1920, 30, 50, FlxColor.BROWN, FlxColor.WHITE);
		m_sliderExtention.minLabel.visible = false;
		m_sliderExtention.maxLabel.visible = false;
		m_sliderExtention.nameLabel.visible = false;
		m_sliderExtention.valueLabel.visible = false;
		
		if (m_allExtention.length <= 5)
			m_sliderExtention.visible = false;
		
		this.add(m_listExtention);
		this.add(m_sliderExtention);		
	}
	
	private function initValueChoice() : Void
	{
		m_listValue = new FlxUIList(10, 750, [], 1920, 75, "Suivant...", FlxUIList.STACK_HORIZONTAL, 300);

		m_sliderValue = new FlxSlider(m_listValue, "scrollIndex", 0, m_listValue.y + m_listValue.height, 0, 10, 1920, 30, 50, FlxColor.BROWN, FlxColor.WHITE);
		m_sliderValue.minLabel.visible = false;
		m_sliderValue.maxLabel.visible = false;
		m_sliderValue.nameLabel.visible = false;
		m_sliderValue.valueLabel.visible = false;
		
		resetValueBoxes();
		
		this.add(m_listValue);
		this.add(m_sliderValue);
	}
	
	private function initPlayBtn() : Void
	{
		m_playBtn = new FlxButtonPlus(1920-400 - 50, 1080-50-50, onClickPlay, "Jouer", 400, 50);
		m_playBtn.textNormal.setFormat(AssetPaths.ATypewriterForMe__ttf, 32);
		m_playBtn.textHighlight.setFormat(AssetPaths.ATypewriterForMe__ttf, 32);
		
		m_playBtn.updateInactiveButtonColors([FlxColor.BROWN, FlxColor.BROWN, FlxColor.BROWN]);
		m_playBtn.updateActiveButtonColors([FlxColor.BROWN, FlxColor.GRAY]);
		
		this.add(m_playBtn);
	}
	
	private function resetValueBoxes() : Void
	{
		if (m_allValue != null)
		{
			for (value in m_allValue)
			{
				if (m_listValue != null)
					m_listValue.remove(cast(value, FlxUICheckBox), true);
				
				m_listValue.members;	
				value.destroy();
			}
		}
		
		m_allValue = new Array<IFlxUIWidget>();
		GameDatas.self.selectedValue = null;
		
		var allPlayableValue : Array<String> = GameDatas.self.extentionManager.getAllPlayableValueByExtentionsUID(m_selectedExtention);
		allPlayableValue.sort(TimelineTools.sortByString);
		
		var firstChecked : Bool = false;
		
		for (value in allPlayableValue)
		{
			var box : FlxUICheckBox = new FlxUICheckBox(0, 0, null, null, value,100, null);
			box.box.setGraphicSize(50, 50);
			box.box.updateHitbox();
			box.button.setGraphicSize(50, 50);
			box.button.updateHitbox();
			box.mark.setGraphicSize(50, 50);
			box.mark.updateHitbox();
			var boxLabel = box.getLabel();
			boxLabel.setFormat(AssetPaths.ATypewriterForMe__ttf, 32);
			//boxLabel.color = FlxColor.BLACK;
			boxLabel.fieldWidth = 245;
			box.textX = 5;
			box.textY = 2;
			box.callback = onCheckValue.bind(box, value);
			
			if (!firstChecked)
			{
				box.checked = true;
				firstChecked = true;
				GameDatas.self.selectedValue = value;
			}
				
			m_allValue.push(box);
			
			if (m_listValue != null)
				m_listValue.add(box);
				
			if (m_sliderValue != null)
			{
				if (m_allValue.length <= 5)
				{
					m_sliderValue.maxValue = m_allValue.length - 5;
					m_sliderValue.visible = false;
				}
				else
					m_sliderValue.maxValue = m_allValue.length - 5;
			}
		}
	}
	
	private function onCheckExtentionId(box : FlxUICheckBox, uniqueId : String) : Void
	{
		if(box.checked && !Lambda.has(m_selectedExtention, uniqueId))
			m_selectedExtention.push(uniqueId);
		else if (!box.checked)
			m_selectedExtention.remove(uniqueId);
		
		GameDatas.self.selectedExtention = m_selectedExtention;
		resetValueBoxes();
		
		checkPlayBtnStatut();
	}
	
	
	private function onCheckValue(box : FlxUICheckBox, value : String)
	{
		for (value in m_allValue)
		{
			var otherBox : FlxUICheckBox = cast(value, FlxUICheckBox);
			
			if (otherBox == null)
				continue;
				
			otherBox.checked = false;
		}
		
		box.checked = true;
		
		GameDatas.self.selectedValue = value;
		checkPlayBtnStatut();
	}
	
	private function onClickPlay() : Void
	{
		FlxG.switchState(new PlayState());
	}
	
	private function checkPlayBtnStatut() : Void
	{
		m_playBtn.visible = GameDatas.self.selectedValue != null && GameDatas.self.selectedExtention != null && GameDatas.self.selectedExtention.length != 0;
	}
	
}