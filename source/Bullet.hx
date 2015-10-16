package;
import flixel.FlxSprite;

/**
 * ...
 * @author
 */
class Bullet extends FlxSprite 
{
	
	static var projectileSpeed:Int = 500;
	var pos_x:Float;
	var pos_y:Float;
	var aim_x:Float;
	var aim_y:Float;
	public var damage:Float;
	private var lifetime:Int = 100;

	public function new(pos_x:Float, pos_y:Float,player:HairDresser) 
	{
		super();
		
		this.loadGraphic("assets/images/Characters/Enemy/bullet.png", true, 32, 32);
		animation.add("fly", [0, 1, 2, 3, 4, 5], 16, true);
		
		// set init position
		this.setPosition(pos_x, pos_y);
		
		// set velocity
		var dX:Float = player.x - pos_x;
		var dY:Float = player.y - pos_y;
		var dMax:Float = Math.sqrt(Math.pow(dX,2) + Math.pow(dY,2));
		
		this.velocity.x = (dX / dMax) * projectileSpeed;
		this.velocity.y = 0;
		
		damage = 10;
		
		animation.play("fly");
	}
	
	override public function update():Void
	{
		super.update();
		
		lifetime--;
		if (lifetime <= 0) {
			destroy();
		}
		
		
	}
	
}