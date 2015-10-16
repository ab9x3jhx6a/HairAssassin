package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxBasic;
import flixel.tweens.FlxTween;
import sys.io.File;

using flixel.util.FlxSpriteUtil;

class GameState2 extends FlxState
	{
	
	var floorGroup:FlxTilemap;
	var wallGroup:FlxTilemap;
	var sceneGroup:FlxTilemap;
	var enemyGroup:FlxGroup;
	var eProjectiles:FlxGroup;
		
	var hairDresser:HairDresser;
	var ui:UI;
	
	var sound:Sound;
	
	var endState:FlxSprite;

	public function new() 
	{
		super();
		
	}
	
	override public function create():Void
    {
        super.create();
		
		FlxG.camera.setBounds(0, 0, 100 * 32, 100 * 32, false);
		FlxG.sound.playMusic(AssetPaths.Level2__wav, 1, true);
		
		sound = SoundFactory.getInstance();
		
		hairDresser = new HairDresser();
		hairDresser.x = Reg.hair_x;
		hairDresser.y = Reg.hair_y - 30 * 32;
		hairDresser.health = Reg.score / 100 * 4; // 4 points of health per haircut
		
		ui = new UI();
		// set time to play
		ui.destroyTimer();
		
		// prevScore is score at start of level
		// when reset occures, score is then prev score
		Reg.prevScore = Reg.score;
		
		floorGroup = new FlxTilemap();
		wallGroup = new FlxTilemap();
		sceneGroup = new FlxTilemap();
		enemyGroup = new FlxGroup();
		eProjectiles = new FlxGroup();
		
		// floor
        floorGroup.loadMap(Assets.getText("assets/data/level2_floor.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		
		// other collidable that is not floor
		wallGroup.loadMap(Assets.getText("assets/data/level2_obstacle.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		
		// scenery
		sceneGroup.loadMap(Assets.getText("assets/data/level2_scenary.csv"), "assets/images/Levels/tilemap.png", 32, 32);
		
		// enemies
		var refs:Array<PositionRef> =  TileMapLoader.load(100, 100, 32, 32, "assets/data/level2_enemy.csv");
		for (ref in refs) {
			if(ref.index != -1){
				enemyGroup.add(new Enemy1(ref.x,ref.y));
			}
		}
		
		endState = new FlxSprite();
		endState.makeGraphic(32 * 4, 32 * 8, FlxColor.TRANSPARENT);
		endState.x = 32 * 5;
		endState.y = (100 - 13) * 32;
		
		add(new Background());
		add(sceneGroup);
		add(floorGroup);
		add(wallGroup);
		add(enemyGroup);
		add(eProjectiles);
		add(endState);
		
		add(hairDresser.spriteGroup);
		add(ui);
    }
	
	override public function update():Void
	{
		super.update();
		
		// check if on ground
		hairDresser.isOnGround = false;
		FlxG.collide(hairDresser, floorGroup, goundDetect);
		
		// move character
		FlxG.collide(hairDresser, wallGroup);
		FlxG.collide(hairDresser, floorGroup);
		
		// update health
		ui.updateHealthBar(hairDresser.HP);
		
		// if player reaches end state, switch to next stage
		if (FlxG.overlap(hairDresser,endState)) {
			FlxG.camera.fade(FlxColor.BLACK, .5, false,
			function() {
			FlxG.switchState(new CutScene3());
			});
			
		}
		
		if (Reg.score != ui.hairCount) ui.updateHairCount(Reg.score);
		
		for (obj in enemyGroup) {
			var enemy:Enemy1 = cast obj;
			enemy.shootAtEllie(hairDresser, eProjectiles);
			enemy.updateEnemyFacing(hairDresser);
			enemy.detectContact(hairDresser, enemyGroup);
			if (enemy.detectDeath(enemyGroup)) Reg.score+=100;
		}
		
		FlxG.overlap(eProjectiles, hairDresser, eProjectileDetect);
		
		
	}
	
	// player and solid ground interaction
	// detects if player is on ground
	private function goundDetect(Object1:FlxObject, Object2:FlxObject):Void {
		hairDresser.isOnGround = true;
	}
	
	//destroy player
	public function playerDestroy(t:FlxTween):Void {
		hairDresser.kill();
		FlxG.switchState(new RestartState(new CutScene3()));
	}
	
	public function playerDeath():Void {
		if (hairDresser.HP <= 0) {
			FlxSpriteUtil.fadeOut(hairDresser, 0.5, false, playerDestroy);
		}
	}
	
	private function eProjectileDetect(Object1:FlxObject, Object2:FlxObject):Void {
		var p:Projectile2 = cast Object1;
		var player:HairDresser = cast Object2;
		//shifts player position during stun
		var direction:Int;
		if (p.velocity.x < 0) direction = -1;
		else direction = 1;
		player.setPosition(player.x + (direction * 10), player.y);
		ui.updateHealthBar(player.takeDamage(p.damage));
		playerDeath();
		
		p.destroy();
	}
}