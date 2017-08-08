package source.ui.skin;
import assets.AssetPaths;
import assets.AssetsManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.unit.TestRunner;
import openfl.Lib;
import openfl.net.URLRequest;
import openfl.text.AntiAliasType;
import openfl.text.TextFieldAutoSize;
import source.data.card.CardData;

/**
 * ...
 * @author Breakyt
 */
class CardSkin extends FlxTypedGroup<FlxSprite>
{
	public static var cardWidth : Int = 265; //px
	public static var cardHeight : Int = 350; //px
	
	public static var cardBorder : Int = 6; //px
	public static var offsetForText : Int = 35; //px
	
	public static var illusWidth : Int = cardWidth - (cardBorder*2); //px
	public static var illusHeight : Int = cardHeight - (cardBorder*2) - (2*offsetForText); //px
	
	private var m_cardDataRef : CardData;
	
	private var m_background: FlxSprite;
	private var m_illustration: FlxSprite;
	
	private var m_titleTxt : FlxText;
	private var m_valueTxt : FlxText;
	
	public var isDrag(default,null) : Bool;
	private var m_mouseOffsetX : Int;
	private var m_mouseOffsetY : Int;
	
	public var isVisible(default, null) : Bool;
	
	public var draggable : Bool;
	
	public var isPuttable : Bool;
	
	/**
	 * Called when dragg start
	 */
	public var onStartDragCallback : CardSkin->Void;
	
	/**
	 * Called when dragg stop
	 */
	public var onStopDragCallback : CardSkin->Void;
	 
	/**
	 * Called when dragging adn AFTER position update
	 */
	public var onDragCallback : CardSkin->Void;
	
	/**
	 * For scaling
	 */
	private var m_initScaleBg : FlxPoint;
	private var m_initScaleIllus : FlxPoint;
	private var m_initScaleTitle : FlxPoint;
	private var m_initScaleValue : FlxPoint;
	
	private var m_generalPosition : FlxPoint;
	private var m_generalOffset : FlxPoint;
	private var m_generalScaling : FlxPoint;
	
	private var m_wikiBtn : FlxButton;
	
	public function new(cardData : CardData, valueToUse : String) 
	{
		super();
		
		m_generalScaling = new FlxPoint(1, 1);
		m_generalOffset = new FlxPoint(0, 0);
		m_generalPosition = new FlxPoint(1, 1);
		m_initScaleBg = new FlxPoint(1, 1);
		m_initScaleIllus = new FlxPoint(1, 1);
		m_initScaleTitle = new FlxPoint(1, 1);
		m_initScaleValue = new FlxPoint(1, 1);
		
		initBackGround();
		initIllustration();
		m_titleTxt = new FlxText(0, 0, CardSkin.cardWidth - CardSkin.cardBorder*2, "", 24);
		m_valueTxt = new FlxText(0, 0, CardSkin.cardWidth - CardSkin.cardBorder*2, "", 24);
		
		m_titleTxt.setFormat(AssetPaths.OldNewspaperTypes__ttf,24);
		m_valueTxt.setFormat(AssetPaths.OldNewspaperTypes__ttf,24);
		
		m_titleTxt.color = FlxColor.BLACK;
		m_valueTxt.color = FlxColor.BLACK;
		
		m_titleTxt.alignment = FlxTextAlign.CENTER;
		m_valueTxt.alignment = FlxTextAlign.CENTER;
		
		m_titleTxt.wordWrap = true;
		m_valueTxt.wordWrap = true;
		
		m_titleTxt.scale.copyTo(m_initScaleTitle);
		m_valueTxt.scale.copyTo(m_initScaleValue);
		
		setVisible(true);
		this.draggable = true;
		this.isPuttable = false;
		
		setCardData(cardData, valueToUse);
	}
	
	/**
	 * Set CardData to the skin.
	 * If value don't exist, the card data is not set. Return false in this case. 
	 * Return true if set is ok
	 * @param	cardData
	 * @param	valueToUse
	 * @return
	 */
	public function setCardData(cardData : CardData, valueToUse : String) : Void
	{
		if (cardData == null)
		{
			m_cardDataRef = null;
			setText("", null);
			return;
		}
		
		m_cardDataRef = cardData;
		
		initBackGround();
		initIllustration();
		
		var value : String = "";
		if (m_cardDataRef.value.exists(valueToUse))
			value = Std.string(m_cardDataRef.value.get(valueToUse));
		
		var unit : String = "";
		if(m_cardDataRef.extentionRef != null)
			unit = m_cardDataRef.extentionRef.getUnitOfValue(valueToUse);	
			
		setText(m_cardDataRef.name, value + " " + unit); // temp
		initWikiButton(m_cardDataRef.wikilink);
		reconstructSkinOrder();
	}
	
	public function scaleSkin(x: Float, y : Float)
	{
		m_generalScaling.set(x, y);
		
		
		if (m_background != null)
		{
			m_background.scale.set(m_initScaleBg.x * x, m_initScaleBg.y * y);
			m_background.updateHitbox();
		}
			
		if (m_illustration != null)
		{
			m_illustration.scale.set(m_initScaleIllus.x * x, m_initScaleIllus.y * y);
			m_illustration.updateHitbox();
		}
			
		if (m_titleTxt != null)
		{
			m_titleTxt.scale.set(m_initScaleTitle.x * x, m_initScaleTitle.y * y);
			m_titleTxt.updateHitbox();
		}
		
		if (m_valueTxt != null)
		{
			m_valueTxt.scale.set(m_initScaleValue.x * x, m_initScaleValue.y * y);
			m_valueTxt.updateHitbox();
		}
			
		
		this.updatePosition();
	}
	
	public function getGeneralScale() : FlxPoint
	{
		return new FlxPoint(m_generalScaling.x, m_generalScaling.y);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (isDrag)
		{
			// to prevent release btn mouse out the game window
			// if btn release out the game window, The event "onMouseDown" is not call
			if (FlxG.mouse.justReleased) 
				stopDrag();			
			
			this.onDrag();
			this.updatePosition();
		}
	}
	
	private function setText(name : String, value : String)
	{
		if(m_titleTxt!=null)
			m_titleTxt.text = name;
		
		if(m_valueTxt!=null)
			m_valueTxt.text = value;
			
		updatePosition();
	}
	
	private function updatePosition() : Void
	{
		if (m_background == null || m_illustration == null || m_titleTxt == null || m_valueTxt == null)
			return;
			
		m_background.x = m_generalPosition.x + m_generalOffset.x;
		m_background.y = m_generalPosition.y + m_generalOffset.y;
			
		m_illustration.setPosition(m_background.x + cardBorder * m_generalScaling.x, m_background.y + CardSkin.cardBorder * m_generalScaling.y + CardSkin.offsetForText* m_generalScaling.y);
		
		m_titleTxt.x = m_background.x + (m_background.width / 2.0) - m_titleTxt.fieldWidth*m_titleTxt.scale.x / 2.0;
		m_titleTxt.y = m_background.y + CardSkin.cardBorder;
		
		m_valueTxt.x = m_background.x + (m_background.width / 2.0) - m_valueTxt.fieldWidth*m_valueTxt.scale.x / 2.0;
		m_valueTxt.y = m_background.y + m_background.height - m_valueTxt.height - CardSkin.cardBorder;
		
		if (m_wikiBtn != null)
		{
			m_wikiBtn.setPosition(	m_illustration.x + m_illustration.width - m_wikiBtn.width, 
									m_illustration.y + m_illustration.height - m_wikiBtn.height);
		}
		
	}
	
	
	private function onMouseDown(item : FlxSprite)
	{
		if(this.draggable)
			startDrag();
	}
	
	private function onMouseUp(item : FlxSprite)
	{
		stopDrag();
	}
	
	private function startDrag() : Void
	{
		if (isDrag)
			return;
		
		isDrag = true;
		m_mouseOffsetX = FlxG.mouse.x - Math.ceil(m_background.x);
		m_mouseOffsetY = FlxG.mouse.y - Math.ceil(m_background.y);
		
		if (onStartDragCallback != null)
			onStartDragCallback(this);
	}
	
	private function stopDrag()
	{
		if (!isDrag)
			return;
		
		isDrag = false;

		if (onStopDragCallback != null)
			onStopDragCallback(this);
	}
	
	private function onDrag() : Void
	{
		if (!isDrag)
			return;
			
		m_generalPosition.x = FlxG.mouse.x - m_mouseOffsetX;
		m_generalPosition.y = FlxG.mouse.y - m_mouseOffsetY;
		
		if (m_generalPosition.x < 0)
			m_generalPosition.x = 0;
		
		if (m_generalPosition.y < 0)
			m_generalPosition.y = 0;
			
		if ( m_generalPosition.x > (FlxG.width - m_background.width))
			m_generalPosition.x = FlxG.width - m_background.width;
			
		
		if ( m_generalPosition.y  > (FlxG.height - m_background.height ))
			m_generalPosition.y = FlxG.height - m_background.height;
			
		updatePosition();

		if (onDragCallback != null)
			onDragCallback(this);			
	}
	
	
	public function flip() : Void
	{
		setVisible(!isVisible);
	}
	
	/**
	 * Hide or show the value.
	 * todo : change background skin
	 * @param	vis
	 */
	public function setVisible(vis : Bool)
	{
		isVisible = vis;
		this.reconstructSkinOrder();
		//m_valueTxt.visible = isVisible;
		
		/*if (m_wikiBtn != null)
		{
			
			if (isVisible)
			{
				this.add(m_wikiBtn);
			}
			else
				this.remove(m_wikiBtn);
		}*/
	}
	
	public function setOffset(x : Float, y : Float) : Void
	{
		m_generalOffset.x = x;
		m_generalOffset.y = y;
		updatePosition();
	}
	
	public function addPosition(x : Float, y : Float) : Void
	{
		m_generalPosition.x += x;
		m_generalPosition.y += y;
		updatePosition();
	}
	
	public function setPosition(x : Float, y : Float)
	{
		m_generalPosition.x = x;
		m_generalPosition.y = y;
		updatePosition();
	}
	
	private function initBackGround() : Void
	{
		if (m_background == null)
			m_background = new FlxSprite(0, 0, null);
		
		FlxMouseEventManager.remove(m_background);
		
		if (m_cardDataRef != null && m_cardDataRef.background != null && AssetsManager.global.exist(m_cardDataRef.background))
		{
			var graphic = AssetsManager.global.getFlxGraphic(m_cardDataRef.background);
			m_background.loadGraphic(graphic);
			m_background.setGraphicSize(cardWidth, cardHeight);
			m_background.updateHitbox();
		}
		else
		{
			m_background.makeGraphic(cardWidth, cardHeight, FlxColor.WHITE, false, "cardBackground");
		}
		
		
		m_background.scale.copyTo(m_initScaleBg);
		FlxMouseEventManager.add(m_background, onMouseDown, onMouseUp, null, null,false, true, false);
	}
	
	private function initIllustration() : Void
	{
		if (m_illustration == null)
			m_illustration = new FlxSprite(0, 0, null);	
		
		if (m_cardDataRef != null && m_cardDataRef.illustration != null && AssetsManager.global.exist(m_cardDataRef.illustration))
		{
			var graphic = AssetsManager.global.getFlxGraphic(m_cardDataRef.illustration);
			m_illustration.loadGraphic(graphic);
			m_illustration.setGraphicSize(illusWidth, illusWidth);
			m_illustration.updateHitbox();
		}
		else
		{
			
			m_illustration.makeGraphic(illusWidth, illusHeight, FlxColor.PURPLE, false, "cardIllus");
		}
		
		m_illustration.scale.copyTo(m_initScaleIllus);
	}
	
	private function initWikiButton(wikiLink : String) : Void
	{
		if (m_wikiBtn != null)
		{
			this.remove(m_wikiBtn);
			m_wikiBtn.destroy();
			m_wikiBtn = null;
		}

		if (wikiLink == null)
			return ;
			
		m_wikiBtn = new FlxButton(0, 0, "", goToWiki.bind(wikiLink));
		m_wikiBtn.loadGraphic(AssetsManager.global.getFlxGraphic(AssetPaths.button__png), true, 256, 256);
		m_wikiBtn.setGraphicSize(50, 50);
		m_wikiBtn.updateHitbox();
		
		this.add(m_wikiBtn);
	}
	
	private function goToWiki(wikilink : String) : Void
	{
		Lib.getURL(new URLRequest(wikilink));
	}
	
	private function reconstructSkinOrder() : Void
	{
		if (m_background != null)
			this.remove(m_background);
			
		if (m_illustration != null)
			this.remove(m_illustration);
			
		if (m_titleTxt != null)
			this.remove(m_titleTxt);
			
		if (m_valueTxt != null)
			this.remove(m_valueTxt);
			
		if (m_wikiBtn != null)
			this.remove(m_wikiBtn);
			
		this.add(m_background);
		this.add(m_illustration);
		this.add(m_titleTxt);
		
		if(isVisible)
			this.add(m_valueTxt);
		
		if (m_wikiBtn != null && isVisible)
			this.add(m_wikiBtn);
	}
	
	public function blink() : Void
	{
		forEach(startBlink);
	}
	
	private function startBlink(sprite : FlxSprite)
	{
		FlxFlicker.flicker(sprite, 0.5, 0.1);
	}
	
	override public function destroy():Void 
	{
		m_cardDataRef = null;
		
		FlxMouseEventManager.remove(m_background);
		this.remove(m_background);
		
		if (m_background != null)
		{
			m_background.destroy();
			m_background = null;
		}
		
		this.remove(m_illustration);
		
		if (m_illustration != null)
		{
			m_illustration.destroy();
			m_illustration = null;
		}
		
		this.remove(m_titleTxt);
		
		if (m_titleTxt != null)
		{
			m_titleTxt.destroy();
			m_titleTxt = null;
		}
		
		this.remove(m_valueTxt);
		
		if (m_valueTxt != null)
		{
			m_valueTxt.destroy();
			m_valueTxt = null;
		}
		
		if (m_wikiBtn != null)
		{
			this.remove(m_wikiBtn);
			m_wikiBtn.destroy();
			m_wikiBtn = null;
		}
		
		onStartDragCallback = null;
		onStopDragCallback = null;
		
		m_initScaleBg.destroy();
		m_initScaleIllus.destroy();
		m_initScaleTitle.destroy();
		m_initScaleValue.destroy();
		
		m_initScaleBg = null;
		m_initScaleIllus = null;
		m_initScaleTitle = null;
		m_initScaleValue = null;	
		
		super.destroy();
	}
	
}