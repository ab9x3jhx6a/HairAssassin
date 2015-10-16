package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxMath; 
import flixel.FlxObject;

class Enemy1 extends FlxSprite
{

	var pos_x:Int;
	var pos_y:Int;
	
	var w:Int;
	var h:Int;
	
	public var isFiring:Bool = false;
	public var facingPlayer:Bool = true;
	
	public var spriteGroup:FlxGroup;
	
	//bullets
	public var bullet_group:FlxGroup;
	var bullet:FlxSprite;
	
	//timer for fire
	private var firetime:Float = 2; //fire a bullet every n seconds
	private var firetimer:Float = 0;
	public var surprised:Int = 0;
	
	private var can_be_hit:Int = 0;
	
	private var sound = SoundFactory.getInstance();

	public function new(pos_x:Int, pos_y:Int) 
	{
		super();
		
		health = 100;
		
		//this.makeGraphic(64, 128, FlxColor.AZURE);
		this.loadGraphic("assets/images/Characters/Enemy/enemy0.png", true, 64, 96);
		this.animation.add("walk", [2,3,4,3], 8, true);
		this.animation.add("fire", [0, 1, 0, 0], 8, false);
		this.animation.add("idle", [2]);
		
		
		//make spriteGroup
		bullet_group = new FlxGroup();
		spriteGroup = new FlxGroup();
		
		spriteGroup.add(bullet_group);
		spriteGroup.add(this);
		
		this.animation.play("walk");
		
		this.setPosition(pos_x,pos_y);
	}
	
	override public function update():Void
	{
		super.update();   
		
		if (firetimer >= firetime && facingPlayer && surprised<=0) {
			//play the fire animaiton
			this.animation.play("fire");
		//add another bullet
			//add animaiton
			isFiring = true;
			
			//reset time
			firetimer = 0;
		}
		else {
			isFiring = false;
			this.animation.play("idle");
			firetimer += FlxG.elapsed;
		}
		
		if (surprised > 0) surprised--;
		if (can_be_hit > 0) can_be_hit--;
		
		
		
	}
	
	public function killEnemy():Void {
			this.velocity.y = -100;
	}
	
	public function surpriseEnemy():Void {
			this.surprised = 60;
	}
	
	public function shootAtEllie(player:HairDresser, eProjectiles:FlxGroup):Void {
		//change which way he's facing based on player's position
			var facing_just_before:String;
			if (this.flipX) facing_just_before = "left";
			else facing_just_before = "right";
			if (this.x > player.x && FlxMath.distanceBetween(this,player)<150 ) {
					this.flipX = true;
					this.facing = FlxObject.LEFT;
					if (facing_just_before=="right") this.surpriseEnemy();
					//trace("Enemy1: I'm facing left!");
				}
			else if (FlxMath.distanceBetween(this,player)<150) {
					this.flipX = false;
					this.facing = FlxObject.RIGHT;
					if (facing_just_before=="left") this.surpriseEnemy();
					//trace("Enemy1: I'm facing right!");
				}
			if (FlxMath.distanceBetween(this, player) < 50 && this.surprised<30) this.surprised = 0;
			
			if (this.isFiring) {
				var newP:Bullet = new Bullet(this.x, this.y + 20, player);
				sound.enemyshoot();
				if (this.flipX) {
					newP.flipX = true;
				}
				else {
					newP.flipX = false;
				}
				eProjectiles.add(newP);
				
				this.isFiring = false;
				
			}
	}
	
	public function updateEnemyFacing(player:HairDresser) {
		//Enemy1's projectile attack
		if (this.facing == FlxObject.LEFT && player.x<this.x) {
			this.facingPlayer = true;
		}
		else if (this.facing == FlxObject.RIGHT && player.x > this.x) {
			this.facingPlayer = true;
		}
		else {
			this.facingPlayer = false;
		}
	
	}
	
	private function takeDamage( obj1:FlxObject, obj2:FlxObject):Void {
		var enemy:Enemy1 = cast obj2;
		var player:HairDresser = cast obj1; 
		if (player.isAttack && can_be_hit==0){
			this.health -= 30;
			can_be_hit = 20;
			sound.enemypain();
		}
	}
	
	public function detectContact(player:HairDresser, enemies:FlxGroup) {
		FlxG.overlap(player, this, takeDamage);
		detectDeath(enemies);
		
		/*if (player.isAttack == false) {
			this.can_be_hit = true;
			color = 0xFFFFFFFF;
		}
		
		//Enemy1's projectile attack
		if (player.facing == FlxObject.LEFT && player.x<this.x && FlxMath.distanceBetween(this,player)<40 && player.isAttack) {
			//player is facing us!
			if (can_be_hit) {
				trace("hit! health =" + health);
				health -= 30;
				color = 0x99FF0000;
				can_be_hit = false;
			}
			
		}
		else if (player.facing == FlxObject.RIGHT && player.x>this.x && FlxMath.distanceBetween(this,player)<40 && player.isAttack) {
			//player is facing us!
			if (can_be_hit) {
				trace("hit! health =" + health);
				health -= 30;
				can_be_hit = false;
			}
			
		}*/
	
	}
	
	public function detectDeath(enemies:FlxGroup):Bool {
		if (health <= 0) {
			//sound.enemydie();
			this.destroy();
			enemies.remove(this);
			return true;
			
		}
		return false;
		
	}
	
	
}