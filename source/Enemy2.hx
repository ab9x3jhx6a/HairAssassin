package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;

class Enemy2 extends FlxSprite
{

	var pos_x:Int;
	var pos_y:Int;
	
	var w:Int;
	var h:Int;
	
	public var isThrowing:Bool;
	private var startThrow:Bool = false; //for tracking the end of animation
	
	public var spriteGroup:FlxGroup;
	
	//Projectiles
	public var projectile_group:FlxGroup;
	var projectile:FlxSprite;
	
	//throw timer
	private var throwtime:Float = 4; //throw stuff every n seconds
	private var throwtimer:Float = 0;

	public function new(pos_x:Int, pos_y:Int) 
	{
		super();
		
		//this.makeGraphic(64, 128, FlxColor.AZURE);
		this.loadGraphic("assets/images/Characters/Enemy/enemy1.png", true, 64, 96);
		this.animation.add("throw", [1,2,3], 8, false);
		this.animation.add("idle", [5]);
		this.animation.add("idle_throw", [4, 4, 4], 8, false);
		
		//make spriteGroup
		projectile_group = new FlxGroup();
		spriteGroup = new FlxGroup();
		
		spriteGroup.add(projectile_group);
		spriteGroup.add(this);	
				
		this.setPosition(pos_x, pos_y);
		
		isThrowing = false;
	}
	
	override public function update():Void
	{
		super.update();
		
		if(startThrow == true){
			if(this.animation.finished){
				isThrowing = true;
				startThrow = false;
				this.animation.play("idle_throw");
			}
		}
		else{
			if (throwtimer >= throwtime) {
				//play the throw animation
				this.animation.play("throw");
				
				startThrow = true;
			
				//reset the timer
				throwtimer = 0;
			}
			else {
				throwtimer += FlxG.elapsed;
				if(this.animation.finished){
					this.animation.play("idle");
				}
			}
		}
	}
	
	public function projectile_movement():Void {
		
	}
	
	public function killEnemy():Void {
			this.velocity.y = -100;
	}
	
}