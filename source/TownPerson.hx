package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

class TownPerson extends FlxSprite
{
	var walkFrames:Array<Array<Int>> = [[0, 6], [18, 12]];
	var walkIndex:Int;
	var topFrames:Array<Int> = [1, 7, 13];
	var bottomFrames:Array<Int> = [3, 19];
	var hairFrames:Array<Int> = [3, 4, 5, 8, 9, 10, 11, 14, 15, 16, 17, 21, 22, 23];
	var hairIndex:Int;

	var pos_x:Int;
	var pos_y:Int;
	
	public var spriteGroup:FlxGroup;
	var hair_sprite:FlxSprite;
	var top_sprite1:FlxSprite;
	var top_sprite2:FlxSprite;
	var top_sprite3:FlxSprite;
	var bottom_sprite:FlxSprite;
	var sparkle_sprite:FlxSprite;
	var smokeSprite:FlxSprite;
	var isPoof:Bool;
	public var isCut:Bool;
	public static var value:Int = 100; // score added if hair is cut

	public function new(pos_x:Int, pos_y:Int) 
	{
		super();
		
		//this.makeGraphic(64, 128, FlxColor.AZURE);
		var resLocation:String = "assets/images/Characters/TownPeople/TownPeople_0.png";
		this.loadGraphic(resLocation, true, 64, 96);
		walkIndex = FlxRandom.intRanged(0, walkFrames.length - 1);
		this.animation.add("idle", walkFrames[walkIndex], 8, true);
		this.animation.play("idle");
		this.setPosition(pos_x, pos_y);
		isCut = false;
		
		spriteGroup = new FlxGroup();
		
		hair_sprite = new FlxSprite();
		hair_sprite.loadGraphic(resLocation, true, 64, 96);
		hair_sprite.setPosition(pos_x, pos_y);
		hairIndex = FlxRandom.intRanged(0, hairFrames.length - 1);
		hair_sprite.animation.add("idle", [hairFrames[hairIndex]], 1, true);
		hair_sprite.animation.play("idle");
		
		top_sprite1 = new FlxSprite();
		top_sprite1.loadGraphic(resLocation, true, 64, 96);
		top_sprite1.setPosition(pos_x, pos_y);
		top_sprite1.animation.add("idle", [topFrames[FlxRandom.intRanged(0, topFrames.length-1)]], 1, true);
		top_sprite1.animation.play("idle");
		
		top_sprite2 = new FlxSprite();
		top_sprite2.loadGraphic(resLocation, true, 64, 96);
		top_sprite2.setPosition(pos_x, pos_y);
		top_sprite2.animation.add("idle", [topFrames[FlxRandom.intRanged(0, topFrames.length-1)]], 1, true);
		top_sprite2.animation.play("idle");
		
		top_sprite3 = new FlxSprite();
		top_sprite3.loadGraphic(resLocation, true, 64, 96);
		top_sprite3.setPosition(pos_x, pos_y);
		top_sprite3.animation.add("idle", [topFrames[FlxRandom.intRanged(0, topFrames.length-1)]], 1, true);
		top_sprite3.animation.play("idle");
		
		bottom_sprite = new FlxSprite();
		bottom_sprite.loadGraphic(resLocation, true, 64, 96);
		bottom_sprite.setPosition(pos_x, pos_y);
		bottom_sprite.animation.add("idle", [bottomFrames[FlxRandom.intRanged(0, bottomFrames.length-1)]], 1, true);
		bottom_sprite.animation.play("idle");
		
		sparkle_sprite = new FlxSprite();
		sparkle_sprite.loadGraphic("assets/images/Characters/TownPeople/sparkle.png", true, 128, 65);
		sparkle_sprite.setPosition(pos_x-36, pos_y - 18);
		sparkle_sprite.animation.add("sparkle", [0, 1], 12, true);
		sparkle_sprite.alpha = 0;
		
		smokeSprite = new FlxSprite();
		smokeSprite.loadGraphic("assets/images/Characters/Main/smoke.png", true, 96, 96);
		smokeSprite.setPosition(pos_x-16, pos_y-10);
		smokeSprite.animation.add("poof", [0,1,2,3,4,5,6,7,8,9,10,11,12,13], 28, false);
		smokeSprite.alpha = 0;
		isPoof = false;
		
		if (FlxRandom.intRanged(0, 3) > 1.5) {
			this.flipX = true;
			this.hair_sprite.flipX = true;
			this.top_sprite1.flipX = true;
			this.top_sprite2.flipX = true;
			this.top_sprite3.flipX = true;
			this.bottom_sprite.flipX = true;
		}
		
		spriteGroup.add(this);
		spriteGroup.add(top_sprite1);
		spriteGroup.add(top_sprite2);
		spriteGroup.add(top_sprite3);
		spriteGroup.add(bottom_sprite);
		spriteGroup.add(hair_sprite);
		spriteGroup.add(sparkle_sprite);
		spriteGroup.add(smokeSprite);
	}
	
	override public function update():Void
	{
		if (isPoof && smokeSprite.animation.finished) endPoof();
		
		super.update();
		
	}
	
	public function cutHair() {
		// hair is now cut
		isCut = true;
		
		// add points to score
		Reg.score += value;
		
		// change hair to different style
		hairIndex = FlxRandom.intRanged(0, hairFrames.length - 1,[hairIndex]);
		hair_sprite.animation.add("idle2", [hairFrames[hairIndex]], 1, true);
		hair_sprite.animation.play("idle2");
		
		// stop foot from tapping
		this.animation.add("idleEnd", [walkFrames[walkIndex][0]], 1, true);
		this.animation.play("idleEnd");
		
		// do poof animation
		startPoof();
	}
	
	public function startPoof():Void {
		isPoof = true;
		smokeSprite.alpha = 1;
		smokeSprite.animation.play("poof");
	}
	
	public function endPoof():Void {
		// end poof
		isPoof = false;
		
		// make smoke invis
		smokeSprite.alpha = 0;
		
		// run sparkle animation
		sparkle_sprite.alpha = 1;
		sparkle_sprite.animation.play("sparkle");
		
	}
	
}