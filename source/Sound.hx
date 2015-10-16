package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxRandom;
using  flixel.util.FlxSpriteUtil;


/**
 * ...
 * @author Kevin
 * 
 * Note: All the function names are those of the 
 * sounds they call so if you want to play 
 * WAZZUP.wav, you'd call [your sound object].WAZZUP()
 */
class Sound extends FlxTypedGroup<FlxSound>
{
	private var boomeRang:FlxSound;
	private var clubThud:FlxSound;
	private var doorOpen:FlxSound;
	private var ellieHurt:FlxSound;
	private var enemyDie:FlxSound;
	private var enemyPain1:FlxSound;
	private var enemyPain2:FlxSound;
	private var enemyPain3:FlxSound;
	private var enemyPain4:FlxSound;
	private var enemyShoot:FlxSound;
	private var ellieJump:FlxSound;
	private var ellieScissors:FlxSound;
	private var aSwoosh:FlxSound;
	
	

	public function new() 
	{
		super();
		boomeRang = FlxG.sound.load(AssetPaths.boomerang__wav);	
		clubThud = FlxG.sound.load(AssetPaths.clubthud__wav);
		doorOpen = FlxG.sound.load(AssetPaths.dooropen__wav);
		ellieHurt = FlxG.sound.load(AssetPaths.elliehurt__wav);
		enemyDie = FlxG.sound.load(AssetPaths.enemydie__wav);
		enemyPain1 = FlxG.sound.load(AssetPaths.enemypain1__wav);
		enemyPain2 = FlxG.sound.load(AssetPaths.enemypain2__wav);
		enemyPain3 = FlxG.sound.load(AssetPaths.enemypain3__wav);
		enemyPain4 = FlxG.sound.load(AssetPaths.enemypain4__wav);	
		enemyShoot = FlxG.sound.load(AssetPaths.enemyshoot__wav);
		ellieJump = FlxG.sound.load(AssetPaths.jump__wav);
		ellieScissors = FlxG.sound.load(AssetPaths.scissors__wav);
		aSwoosh = FlxG.sound.load(AssetPaths.swoosh__wav);
		
	}
	
	override public function destroy() {
		super.destroy();
		boomeRang = FlxDestroyUtil.destroy(boomeRang);
		clubThud = FlxDestroyUtil.destroy(clubThud);
		doorOpen = FlxDestroyUtil.destroy(doorOpen);
		ellieHurt = FlxDestroyUtil.destroy(ellieHurt);
		enemyDie = FlxDestroyUtil.destroy(enemyDie);
		enemyPain1 = FlxDestroyUtil.destroy(enemyPain1);
		enemyPain2 = FlxDestroyUtil.destroy(enemyPain2);
		enemyPain3 = FlxDestroyUtil.destroy(enemyPain3);
		enemyPain4 = FlxDestroyUtil.destroy(enemyPain4);
		enemyShoot = FlxDestroyUtil.destroy(enemyShoot);
		ellieJump = FlxDestroyUtil.destroy(ellieJump);
		ellieScissors = FlxDestroyUtil.destroy(ellieScissors);
		aSwoosh = FlxDestroyUtil.destroy(aSwoosh);
	}
	
	public function boomerang() {
		boomeRang.play();
	}
	
	public function clubthud() {
		clubThud.play();
	}
	
	public function dooropen() {
		doorOpen.play();
	}
	
	public function elliehurt() {
		ellieHurt.play();
	}
	
	public function enemydie() {
		enemyDie.play();
	}
	
	public function enemypain() {
		var r:Int = FlxRandom.intRanged(0, 3);
		if      (r == 0 && !enemyPain2.playing && !enemyPain3.playing && !enemyPain4.playing) enemyPain1.play();
		else if (r == 1 && !enemyPain1.playing && !enemyPain3.playing && !enemyPain4.playing) enemyPain2.play();
		else if (r == 2 && !enemyPain1.playing && !enemyPain2.playing && !enemyPain4.playing) enemyPain3.play();
		else if (r == 3 && !enemyPain1.playing && !enemyPain2.playing && !enemyPain3.playing) enemyPain4.play();
	}
	
	public function enemyshoot() {
		enemyShoot.play();
	}
	
	public function jump() {
		ellieJump.play();
	}
	
	public function scissors() {
		ellieScissors.play();
	}
	
	public function swoosh() {
		aSwoosh.play();
	}
	
}