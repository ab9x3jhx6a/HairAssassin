package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author robert
 */

class Hammer extends FlxSprite {

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		
		makeGraphic(80, 160, FlxColor.TRANSPARENT);
	}
	
	
}