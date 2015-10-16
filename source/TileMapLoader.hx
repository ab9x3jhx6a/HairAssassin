package;
import flixel.group.FlxGroup;
import sys.io.File;

/**
 * ...
 * @author ...
 */
class TileMapLoader
{
	
	public static function load(_w:Int,_h:Int,_x:Int,_y:Int,path:String):Array<PositionRef>
	{
		// read in level data
		var csvData:String = File.getContent(path);
		
		// split string by newline, which gives an array of rows
		var rows:Array<String> = csvData.split("\n");
		
		var rowIndex:Int = 0;
		var positions:Array<PositionRef> = new Array<PositionRef>();
		for (row in rows) {
			
			// split by comma to get values
			var valuesRaw:Array<String> = row.split(",");
			
			var colIndex:Int = 0;
			for (valueRaw in valuesRaw) {
					// cast to int
					var value:Int = Std.parseInt(valueRaw);
					
					positions.push(new PositionRef(colIndex*_y,rowIndex*_x,value));
					
					colIndex++;
			}
			
			rowIndex++;
		}
		
		return positions;
		
	}
	
}