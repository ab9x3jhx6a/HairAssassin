package;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
//import openfl.display.Tilemap;
import openfl.Assets;


/**
 * ...
 * @author Robert
 */
class GameState3 extends FlxState 
{
	var player:HairDresser;
	var ogre:Ogre;
	var hammer:Hammer;
	var enemies:FlxGroup;
	//var enemies_1:FlxGroup;
	
	var floor:FlxTilemap;
	var obstacles:FlxTilemap;
	var scenary:FlxTilemap;
	
	var pProjectiles:FlxGroup;
	var eProjectiles:FlxGroup;
	
	var ui:UI;
	var barHealth:FlxBar;
	
	var background:FlxSprite;
	
	
	public function new() 
	{
		super();
	}
	
	override public function create() {
		super.create();
		FlxG.camera.setBounds(0, 0, 100 * 32, 100 * 32, false);
		background = new FlxSprite();
		background.loadGraphic("assets/images/Muro Sunset.png", false, 1024, 768);
		background.scrollFactor.set();
		add(background);
		
		scenary = new FlxTilemap();
		scenary.loadMap(Assets.getText("assets/data/level3_scenary.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		add(scenary);
		
		floor = new FlxTilemap();
		floor.loadMap(Assets.getText("assets/data/level3_floor.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		//for(i in 0...40) floor.add(new StaticObject(i*32, FlxG.height-32, "assets/images/GroundTile.png"));
		add(floor);
		
		obstacles = new FlxTilemap();
		obstacles.loadMap(Assets.getText("assets/data/level3_obstacle.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		add(obstacles);
		
		player = new HairDresser();
		add(player.spriteGroup);
		
		player.x = 20*32;
		player.y = 30*32;
		
		ogre = new Ogre(16*32, 25*32, player);
		add(ogre);
		hammer = ogre._hammer;
		add(hammer);
		
		enemies = new FlxGroup();
		enemies.add(new Enemy2(10 * 32, 20 * 32) );
		enemies.add(new Enemy2(43 * 32, 19 * 32));
		enemies.add(new Enemy2(61 * 32, 19 * 32));
		
		add(enemies);
		
		pProjectiles = new FlxGroup();
		add(pProjectiles);
		
		eProjectiles = new FlxGroup();
		add(eProjectiles);
		
		ui = new UI();
		add(ui);
		ui.destroyTimer();
		
		barHealth = new FlxBar(0,0,FlxBar.FILL_LEFT_TO_RIGHT, 250,25);
		barHealth.createGradientBar([0xEE000000, 0xEE0C0C0], [0xFF00FF00, 0xFFFFFF00, 0xFFFF0000], 1, 180, true, 0xFF000000);
		updateBarPos();
		
		barHealth.percent = 100;
		add(barHealth);
		
		FlxG.sound.playMusic(AssetPaths.Level3__wav, 1, true);
	}

	override public function update() {
		super.update();
		
		barHealth.y = ogre.y - 30;
		
		if (FlxG.keys.justPressed.R) FlxG.switchState(new RestartState(new CutScene3()));
		else if (FlxG.keys.justPressed.F5) FlxG.switchState(new EndState());
		
		// check if on ground
		player.isOnGround = false;
		FlxG.overlap(player, floor, goundDetect);
		
		//check collisions
		FlxG.collide(player, floor);
		FlxG.collide(ogre, floor);
		FlxG.collide(player, obstacles);
		
		// Ogre attacks when player and _hammer overlap
		if(ogre.isMove) FlxG.overlap(player, ogre._hammer, ogreAttack);
		//player can attack when player and ogre overlap
		FlxG.overlap(player, ogre, playerAttack);
		//Ogre takes damage when overlaps with pProjectile
		FlxG.overlap(pProjectiles, ogre, pProjectileDetect);
		//player takes damage when overlaps with eProjectile
		FlxG.overlap(eProjectiles, player, eProjectileDetect);
		
		updateBarPos();
		ui.updateHealthBar(player.HP);
		
		//player's projectile attack
		if (player.charged) {
			if(player.face_left)
				pProjectiles.add(new Projectile(player.x,player.y,player.x-200,player.y));
			else
				pProjectiles.add(new Projectile(player.x,player.y,player.x+200,player.y));
		}
		
		//Enemy2's projectile attack
		for (obj in enemies) {
			
			var enemy:Enemy2 = cast obj;
			//change which way he's facing based on player's position
			if (enemy.x < player.x) {
					enemy.flipX = true;
				}
				else {
					enemy.flipX = false;
				}
			
			if (enemy.isThrowing) {
				var newP:Projectile2 = new Projectile2(enemy.x, enemy.y, player);
				if (enemy.flipX) {
					newP.flipX = true;
				}
				else {
					newP.flipX = false;
				}
				eProjectiles.add(newP);
				
				enemy.isThrowing = false;
			}
		}
		
		//update projectiles
		for (obj in pProjectiles) {
			var p:Projectile = cast obj;
			projectileUpdate(p);
		}
		
		//super.update();
	}
	
	public function updateBarPos() {
		barHealth.x = (ogre.x + ogre.width / 2) - (barHealth.width/2);
	}
	
	public function updateHealthBar() : Void{
		barHealth.health = ogre.HP;
		barHealth.percent = (ogre.HP / ogre.startHP) * 100;
	}
	
	// player and solid ground interaction
	// detects if player is on ground
	private function goundDetect(Object1:FlxObject, Object2:FlxObject):Void {
		player.isOnGround = true;
	}
	
	// player and enemy interaction
	private function ogreAttack(Object1:FlxObject, Object2:FlxObject):Void {
		ogre.startAttack();
	}
	private function playerAttack(Object1:FlxObject, Object2:FlxObject):Void {
		if (player.isAttack) {
			ogre.takeDamage(player.damage, false);
			updateHealthBar();
			ogreDeath();
			player.isAttack = false;
		}
	}
	
	// update projectiles: if too far from player, destroy it
	private function projectileUpdate(Object:FlxObject):Void {
		var p:Projectile = cast Object;
		
		if ( (p.startpoint_x - p.x) * (p.startpoint_x - p.x) > 99999) {
			p.destroy();
		}
	}
	
	// projectile and enemy interaction
	private function pProjectileDetect(Object1:FlxObject, Object2:FlxObject):Void {
		var p:Projectile = cast Object1;
		var ogre:Ogre = cast Object2;
		
		ogre.takeDamage(p.damage, true);
		updateHealthBar();
		ogreDeath();
		
		p.destroy();
	}
	
	// projectile and player interaction
	private function eProjectileDetect(Object1:FlxObject, Object2:FlxObject):Void {
		var p:Projectile2 = cast Object1;
		var player:HairDresser = cast Object2;
		//shifts player position during stun
		var direction:Int;
		if (p.velocity.x < 0) direction = -1;
		else direction = 1;
		player.setPosition(player.x + (direction * 10), player.y);
		player.takeDamage(p.damage);
		playerDeath();
		
		p.destroy();
	}
	
	//if this damage brings HP at or below zero, destroy it
	public function ogreDeath():Void {
		if (ogre.HP <= 0) {
			FlxSpriteUtil.fadeOut(ogre, 0.5, false, ogreDestroy);
			FlxSpriteUtil.fadeOut(barHealth, 0.5, false, barDestroy);
		}
	}
	
	public function playerDeath():Void {
		if (player.HP <= 0) {
			FlxSpriteUtil.fadeOut(player, 0.5, false, playerDestroy);
		}
	}
	
	//destroy ogre
	public function ogreDestroy(t:FlxTween):Void {
		ogre.kill();
	}
	//destroy barHealth
	public function barDestroy(t:FlxTween):Void {
		barHealth.destroy();
		FlxG.switchState(new EndState());
	}
	//destroy player
	public function playerDestroy(t:FlxTween):Void {
		player.destroy();
		FlxG.switchState(new RestartState(new CutScene3()));
	}
	
}