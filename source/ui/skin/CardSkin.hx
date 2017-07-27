package source.ui.skin;
import assets.AssetPaths;
import assets.AssetsManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import haxe.unit.TestRunner;
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
	
	public static var illusWidth : Int = cardWidth - (cardBorder*2); //px
	public static var illusHeight : Int = cardHeight - (cardBorder*2); //px
	
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
	
	public function new(cardData : CardData, valueToUse : String) 
	{
		super();
		
		m_initScaleBg = new FlxPoint(1, 1);
		m_initScaleIllus = new FlxPoint(1, 1);
		m_initScaleTitle = new FlxPoint(1, 1);
		m_initScaleValue = new FlxPoint(1, 1);
		
		initBackGround();
		initIllustration();
		m_titleTxt = new FlxText(0, 0, -1, "", 24);
		m_valueTxt = new FlxText(0, 0, -1, "", 24);
		
		//m_titleTxt.setFormat(AssetPaths.OptimusPrinceps__ttf,24);
		//m_valueTxt.setFormat(AssetPaths.OptimusPrinceps__ttf,24);
		
		m_titleTxt.color = FlxColor.BLACK;
		m_valueTxt.color = FlxColor.BLACK;
		
		m_titleTxt.bold = true;
		m_valueTxt.bold = true;
		
		m_titleTxt.alignment = FlxTextAlign.CENTER;
		m_valueTxt.alignment = FlxTextAlign.CENTER;
		
		m_titleTxt.scale.copyTo(m_initScaleTitle);
		m_valueTxt.scale.copyTo(m_initScaleValue);
		
		setVisible(true);
		this.draggable = true;
		
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
		
		setText(m_cardDataRef.name, value); // temp
		reconstructSkinOrder();
	}
	
	public function scaleSkin(x: Float, y : Float)
	{
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
			
		
		m_background.x = 0;
		m_background.y = 0;
		this.updatePosition();
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
			
		m_illustration.setPosition(m_background.x + cardBorder, m_background.y + cardBorder);
		
		m_titleTxt.x = m_background.x + (m_background.width / 2.0) - m_titleTxt.fieldWidth*m_titleTxt.scale.x / 2.0;
		m_titleTxt.y = m_background.y;
		
		m_valueTxt.x = m_background.x + (m_background.width / 2.0) - m_valueTxt.fieldWidth*m_valueTxt.scale.x / 2.0;
		m_valueTxt.y = m_background.y + m_background.height - m_valueTxt.height;
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
			
		m_background.x = FlxG.mouse.x - m_mouseOffsetX;
		m_background.y = FlxG.mouse.y - m_mouseOffsetY;
		
		if (m_background.x < 0)
			m_background.x = 0;
		
		if (m_background.y < 0)
			m_background.y = 0;
			
		if ( m_background.x > (FlxG.width - m_background.width))
			m_background.x = FlxG.width - m_background.width;
			
		
		if ( m_background.y  > (FlxG.height - m_background.height ))
			m_background.y = FlxG.height - m_background.height;
			

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
		m_valueTxt.visible = isVisible;
	}
	
	public function setPosition(x : Float, y : Float)
	{
		m_background.x = x;
		m_background.y = y;
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
			
		this.add(m_background);
		this.add(m_illustration);
		this.add(m_titleTxt);
		this.add(m_valueTxt);
	}
	
	
	
}