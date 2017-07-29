package ui.elements;
import source.data.card.CardData;
import source.ui.skin.CardSkin;

/**
 * An helper class who link Card raw data and Card skin for Display
 * @author Breakyt
 */
class Card 
{

	public var data(default, null) : CardData; // reference, don't delete, only set to null to remove
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
	
	public function destroy() : Void
	{
		this.data = null;
		
		if (skin != null)
			skin.destroy();
		skin = null;
	}
}