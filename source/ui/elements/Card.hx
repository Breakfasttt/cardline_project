package ui.elements;
import source.data.card.CardData;
import source.ui.skin.CardSkin;

/**
 * An helper class who link Card raw data and Card skin for Display
 * @author Breakyt
 */
class Card 
{

	public var data(default, null) : CardData;
	public var skin(default, null) : CardSkin;
	
	public function new(data : CardData, valueToUse : String)  : Void
	{
		if (data == null)
		{
			this.skin = null;
			this.data = null;
			return;
		}
		
		this.data = data;
		this.skin = new CardSkin(this.data, valueToUse);
	}
}