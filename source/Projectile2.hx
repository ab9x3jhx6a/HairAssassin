package;
import flixel.FlxSprite;

/**
 * ...
 * @author robert
 */
class Projectile2 extends FlxSprite 
{
	
	static var projectileSpeed:Int = 500;
	var pos_x:Float;
	var pos_y:Float;
	var aim_x:Float;
	var aim_y:Float;
	public var damage:Float;

	public function new(pos_x:Float, pos_y:Float,player:HairDresser) 
	{
		super();
		
		this.loadGraphic("assets/images/Characters/Enemy/projectile.png", true, 64, 64);
		animation.add("move", [0, 1], 16, true);
		
		// set init position
		this.setPosition(pos_x, pos_y);
		
		// set velocity
		var dX:Float = player.x - pos_x;
		var dY:Float = player.y - pos_y;
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