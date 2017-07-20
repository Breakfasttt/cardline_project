package tools;

/**
 * ...
 * @author Breakyt
 */
class TimelineTools 
{
	public static function sortByString(a : String, b : String) : Int
	{
		var minLength : Int = Std.int(Math.min(cast(a.length,Float), cast(b.length,Float)));
		
		var testA : String = "";
		var testB : String = "";
		
		for (i in 0...minLength)
		{
			testA = a.charAt(i).toLowerCase();
			testB = b.charAt(i).toLowerCase();
			
			if (testA < testB) return -1;
			if (testA > testB) return 1;
		}
		
		if (a.length < b.length)
			return -1;
		else if (a.length > b.length)
			return 1;
		else
			return 0;
	}
}