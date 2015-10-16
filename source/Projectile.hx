package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Projectile extends FlxSprite
{
	
	static var projectileSpeed:Int = 500;
	public var startpoint_x:Float;
	var pos_x:Float;
	var pos_y:Float;
	var aim_x:Float;
	var aim_y:Float;
	public var damage:Float;

	public function new(pos_x:Float, pos_y:Float,aim_x:Float, aim_y:Float) 
	{
		super();
		
		this.loadGraphic("assets/images/Characters/Main/magic_effect.png", true, 96, 96);
		animation.add("move", [0, 2, 4, 1, 3, 5], 8, false);
		
		// set init position
		this.setPosition(pos_x, pos_y);
		startpoint_x = pos_x;
		
		// set velocity
		var dX:Float = aim_x - pos_x;
		var dY:Float = aim_y - pos_y;
		var dMax:Float = Math.sqrt(Math.pow(dX,2) + Math.pow(dY,2));
		
		this.velocity.x = (dX / dMax) * projectileSpeed;
		this.velocity.y = (dY / dMax) * projectileSpeed;
		
		damage = 10;
		
		animation.play("move");
	}
	
	override public function update():Void
	{
		super.update();
	}
	
}