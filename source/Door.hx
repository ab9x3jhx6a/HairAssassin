package;

import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxPoint;

class Door extends FlxSprite
{

	public var pos_x:Int;
	public var pos_y:Int;
	
	public var isOpen:Bool;
	public var isMoving:Bool;
	
	public var range:Int;
	public var hitBox:FlxSprite;

	public function new(pos_x:Int, pos_y:Int) 
	{
		super();
		
		this.loadGraphic("assets/images/Door.png", true, 160, 128);
		this.animation.add("closeDoor", [4,3,2,1,0], 20, false);
		this.animation.add("openDoor", [0,1,2,3,4], 20, false);
		
		this.setPosition(pos_x,pos_y);
		this.immovable = true;
		this.isOpen = false;
		this.isMoving = false;
		this.range = 100;
		this.hitBox = new FlxSprite();
		
		// modify door hitbox to range you can open door
		// x = 32
		// x end = 47
		//this.width = (47 - 32) + range * 2;
		//this.offset.x -= range;
		
		// modify invis hitbox to closed door bounds
		this.hitBox.makeGraphic(47 - 32, 128, FlxColor.TRANSPARENT);
		this.hitBox.setPosition(pos_x+32,pos_y);
		this.hitBox.immovable = true;
		
	}
	
	override public function update():Void
	{
		super.update();
		
	}
	
	public function openDoor():Void {
		if(this.animation.finished){
			this.animation.play("openDoor");
			this.isOpen = true;
		}
	}
	
	public function closeDoor():Void {
		if(this.animation.finished){
			this.animation.play("closeDoor");
			this.isOpen = false;
		}
	}
	
	
}