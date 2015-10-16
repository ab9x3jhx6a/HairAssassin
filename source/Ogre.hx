package;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.FillScaleMode;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxEase;


/**
 * ...
 * @author Robert
 */

 
 class Ogre extends FlxSprite  
{
	//group that stores ogre sprites
	 public var spriteList:FlxGroup;
	 
	//movement and position
	public var maxSpeed:Float;
	public var movePoint:FlxPoint;  //this is the point that the ogre automatically walks towards
	public var centerX:Float;
	public var centerY:Float;
	public var stalled:Bool;
	
	
	//health
	public var startHP:Float;
	public var HP:Float;
	
	//AI variables
	public var _brain:FSM; //FSM that keeps track of current sprite-state
	private var Timer:Float; //timer used for time-dependent sprite-states
	private var stunLimit:Float; //length of stun sprite-state
	private var attackLimit:Float; //length of attack sprite-state
	public var isMove:Bool; //checks if in move state
	
	//attack
	public var swingDist:Float; //Range of ogre's swing attack
	public var damage:Float; //damage dealt by attack
	public var hitsPlayer:Bool; //becomes true if an attakc connects with the player
	
	public var _hammer:Hammer;
	
	public var _player:HairDresser;
	
	private var sound = SoundFactory.getInstance();
	private var sound_recent:Int = 0;
	
	
	public function new(X:Float=0, Y:Float=0, player:HairDresser) {
		super(X, Y);
		
		//Load Ogre art
		loadGraphic("assets/images/Characters/Ogre/Ogre.png", true, 160, 160);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		//run animations
		animation.add("run_right", [0,1,2,1], 8, true);
		//attack animations
		animation.add("hammer_right", [3, 4, 5, 5, 5, 5], 6, false);
		//idle animations
		animation.add("idle_right", [1], 1, true);
		
		//set width to fit only the back half
		width = 80;
		
		_hammer = new Hammer();
		_hammer.x = this.x +80;
		_hammer.y = this.y;
		
		
		//define variables
		drag.x = 450;
		maxSpeed = 200;
		centerX = this.width / 2;
		centerY = this.height / 2;
		stalled = false;
		
		// set gravity
		this.acceleration.y = 1500;
		this.acceleration.x = 0;
		
		//reference player sprite
		_player = player;
		//ogre moves horizontally towards player.  
		//Set a point using the player's x-position and a fixed y-position
		movePoint = new FlxPoint(_player.centerX, _player.centerY);
		
		//_brain starts in stun
		_brain = new FSM(stun);
		isMove = false;
		stunLimit = 50;
		attackLimit = 50;
		Timer = stunLimit;
		
		//set attack variables
		swingDist = 200;
		damage = 20;
		hitsPlayer = false;
		
		//set HP
		startHP = 100;
		HP = startHP;
	
		setPosition(X, Y);
	}
	
	
	//FSM states
	public function stun():Void {
		animation.play("idle_right");
		//when timer runs out, switch to move state
		if (Timer <= 0) {
			_brain.activeState = move;
			isMove = true;
		}
		else
			Timer -= 1;
	}
	
	public function move():Void {
		//stalls prior to changing directions
		stall();
		//move towards player
		FlxVelocity.moveTowardsPoint(this, movePoint, Std.int(maxSpeed));
		if (_player.x - this.x > 10) {
			facing = FlxObject.RIGHT; 
			animation.play("run_right");
		}
		else if (_player.x - this.x < -10) { 
			facing = FlxObject.LEFT; 
			animation.play("run_right");
		}
		else {
			animation.play("idle_right");
		}
	}
	
	public function stall():Void {
		//If not already stalled, stall it if facing and velocity conflict
		//If already stalled, unstall it 
		if (!stalled) {
			if ((facing == FlxObject.LEFT && (_player.x - this.x > 10)) || 
			  (facing == FlxObject.RIGHT && (_player.x - this.x < 10))){
				Timer = stunLimit;
				_brain.activeState = stun;
				stalled = true;
			}
		}
		else {
			if (facing == FlxObject.LEFT && this.velocity.x > 0) facing == FlxObject.RIGHT;
			else if (facing == FlxObject.RIGHT && this.velocity.x < 0) facing == FlxObject.LEFT;
			stalled = false;
		}
	}
	
	public function attack():Void {
		if (sound_recent==0) {
			sound.clubthud();
			sound_recent = 30;
		}
		 
		//when animation is finished, switch to move state
		if (Timer <= 0) {
			_brain.activeState = move;
			hitsPlayer = false;
			isMove = true;
		}
		else Timer -= 1;
		animation.play("hammer_right");
		 
		//If player is still overlapped with ogre, it takes damage
		if (animation.curAnim.curFrame == 1) {
			FlxG.overlap(this, _player, dealDamage);
		}
		
	}
	
	public function dealDamage(Object1:FlxObject, Object2:FlxObject):Void {
		if (!hitsPlayer) {
			hitsPlayer = true;
			var direction:Int;
			//passes int value to player specifying recoil direction. 1=left, 2=right
			if (this.facing == FlxObject.LEFT) direction = -1;
			else direction = 1;
			trace(direction);
			_player.setPosition(this.x + (direction * 100), this.y);
			_player.takeDamage(damage);
		}
	}
	
	//takes damage; switches to stun
	public function takeDamage(damage:Float, startStun:Bool) {
		HP -= damage;
		//if not already stunned, set timer and switch to stun
		if (startStun  && _brain.activeState != stun) {
			Timer = stunLimit;
			_brain.activeState = stun;
			//halt abruptly
			velocity.x = 0;
			isMove = false;
		}
	}
	
	//triggers transition to attack sprite-state
	public function startAttack():Void {
		Timer = attackLimit;
		_brain.activeState = attack;
		isMove = false;
	}
	
	
	override public function update():Void {
		//update movePoint with player's position
		movePoint.x = _player.x;
		movePoint.y = _player.y;
		//update _hammer's position
		if (facing == FlxObject.LEFT) _hammer.x = this.x;
		else _hammer.x = this.x + 80;
		_hammer.y = this.y;
		
		//update FSM
		_brain.update();
		
		if (sound_recent > 0) sound_recent--;
		
		super.update();
	}
	
}
