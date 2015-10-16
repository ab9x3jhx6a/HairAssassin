package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var ui:UI;
	private var sound:Sound;
	private var text:String = "";
	private var health:Int = 100;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		ui = new UI();
		sound = new Sound();
		
		add(ui);
		add(sound);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.pressed.Z) {
			ui.updateHealthBar(health--);
		}
		if (FlxG.keys.pressed.X) {
			ui.updateHealthBar(health++);
		}
		
		if (FlxG.keys.pressed.A) {
			ui.updateText("Harrison Ford: Hello whale");
			sound.scissors();
		}
		
		if (FlxG.keys.pressed.B) {
			ui.updateText("Verily, I am the greatest warrior of our time, gifted with swag and charisma of the most admirable vein.");
		}
		
		if (FlxG.keys.pressed.SPACE) {
			ui.updateText("");
		}
		
		if (FlxG.keys.pressed.C) {
			ui.updateText("I wanna be the very best, like no one ever was. To catch them is my real test, to train them is my cause. I will travel across the land, searchin' far and wide. Teach Pokemon to understand the power that's inside. POKEMON!!! Gotta catch em all I'ts you anD me I no its' my dstiney");
		}
		
		if (FlxG.keys.pressed.H) {
			ui.increaseHairCount();
		}
		
		if (FlxG.keys.justReleased.F) {
			ui.displayFullscreenImage();
		}
		
		
		
		super.update();
	}	
}