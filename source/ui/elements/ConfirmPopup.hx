package ui.elements;
import assets.AssetPaths;
import assets.AssetsManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

/**
 * ...
 * @author Breakyt
 */
class ConfirmPopup 
{
	
	private var m_parent : FlxState;
	
	private var m_displayGroup : FlxGroup;
	
	private var m_calque : FlxSprite;
	
	private var m_background : FlxSprite;
	
	private var m_desc : FlxText;
	
	private var m_confirmBtn : FlxButton;
	private var m_cancelBtn : FlxButton;
	
	private var m_acceptCb : Void->Void;
	private var m_cancelCb : Void->Void;
	
	private var m_width : Int;
	private var m_height : Int;
	private var m_descStr : String;

	public function new(desc : String, accept : Void->Void, Cancel : Void->Void, w : Int = 800, h : Int = 600) 
	{
		m_parent = null;
		m_displayGroup = new FlxGroup();
		m_acceptCb = accept;
		m_cancelCb = Cancel;
		
		m_width = w;
		m_height = h;
		m_descStr = desc;
		
		initCalque();
		initBackground();
		initDesc();
		initButtons();
	}
	
	public function attachTo(item : FlxState)
	{
		if (m_parent == null && item != null)
		{
			m_parent = item;
			m_parent.add(m_displayGroup);
			FlxMouseEventManager.add(m_calque);
		}
		else
		{
			m_parent.remove(m_displayGroup);
			m_parent = item;
			
			if (m_parent == null)
				FlxMouseEventManager.remove(m_calque);
			else
				m_parent.add(m_displayGroup);
				
		}
	}
	
	private function initCalque() : Void
	{
		m_calque = new FlxSprite();
		m_calque.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 178));
		m_displayGroup.add(m_calque);
	}
	
	private function initBackground() : Void
	{
		m_background = new FlxSprite();
		m_background.loadGraphic( AssetsManager.global.getFlxGraphic(AssetPaths.board2__jpg));
		m_background.setGraphicSize(m_width, m_height);
		m_background.updateHitbox();
		m_background.screenCenter(FlxAxes.XY);
		m_displayGroup.add(m_background);
	}
	
	private function initDesc() : Void
	{
		m_desc = new FlxText(m_background.x + 50, m_background.y +50, m_background.width - 100, m_descStr);
		m_desc.alignment = FlxTextAlign.CENTER;
		m_desc.setFormat(AssetPaths.OldNewspaperTypes__ttf, 30);
		m_desc.color = FlxColor.BLACK;
		m_displayGroup.add(m_desc);
	}
	
	private function initButtons() : Void
	{
		m_confirmBtn = new FlxButton(0, 0, "Accepter", onAccept);
		m_confirmBtn.setGraphicSize(200, 50);
		m_confirmBtn.updateHitbox();
		m_confirmBtn.setPosition(m_background.x + 50, m_background.y + m_background.height - m_confirmBtn.height - 50);
		m_confirmBtn.label.fieldWidth = 200;
		m_confirmBtn.label.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_confirmBtn.label.color = FlxColor.BLACK;

		
		m_cancelBtn = new FlxButton(0, 0, "Annuler", onCancel);
		m_cancelBtn.setGraphicSize(200, 50);
		m_cancelBtn.updateHitbox();
		m_cancelBtn.setPosition(m_background.x + m_background.width - m_cancelBtn.width -50, m_background.y + m_background.height - m_cancelBtn.height - 50);
		m_cancelBtn.label.fieldWidth = 200;
		m_cancelBtn.label.setFormat(FlxAssets.FONT_DEFAULT, 32);
		m_cancelBtn.label.color = FlxColor.BLACK;
		
		m_displayGroup.add(m_confirmBtn);
		m_displayGroup.add(m_cancelBtn);
	}
	
	private function onAccept() : Void
	{
		if (m_acceptCb != null)
			m_acceptCb();
	}
	
	private function onCancel() : Void
	{
		if (m_cancelCb != null)
			m_cancelCb();
	}
}