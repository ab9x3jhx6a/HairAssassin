package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class CutScene2 extends FlxState
{
	var labelTest:FlxText;
	var texts:Array<String>;
	var backgrounds:Array<String>;
	var whichText:Int;
	var whichBackground:Int;
	private var ui:UI;

	public function new() 
	{
		super();		
	}
	
	override public function create():Void
    {
		super.create();
		
		labelTest = new FlxText(0, FlxG.height / 2, FlxG.width, "In a town a long, long time ago...");
		labelTest.setFormat(null, 40, FlxColor.WHITE, "center");
		
		//add(labelTest);
		
		//new FlxTimer(1.0, endCutScene, 1);
		
		texts = new Array<String>();
		texts.push("Dan: There was a kid, Hunter Leventhorpe, who was the terror of Widebrook. No one could get him to behave, much less cut his hair. But Ellie Prescott never shied away from the challenge. She-");
		texts.push("Ambrose: You're getting it all confused, Dan. A child wasn't her biggest challenge!");
		texts.push("Dan: Well why don't you take up the story now Ambrose.");
		texts.push("Ambrose: Widebrook wasn't always peaceful like you see it today, Will. Some 50 years ago, in rode the Leventhorpe Gang, a band of bloodthirsty cutthroats. If you came at odds with one of them, somebody was gonna die.");
		texts.push("Will: And they had their eyes on Widebrook?");
		texts.push("Ambrose: The town was doomed to be raided by the gang, if not for Ellie Prescott, the greatest hairdresser-assassin who ever lived.");
		texts.push("Will: You say that like there have been multiple hairdresser-assassins.");
		texts.push("Ambrose: Ellie Prescott was determined to rid the town of the scourge, that execrable Leventhorpe gang. She set out at once...");
		
		backgrounds = new Array<String>();
		backgrounds.push("assets/images/placeholder_background_2_1.png");
		backgrounds.push("assets/images/placeholder_background_2_2.png");
		
		whichText = -1;
		whichBackground = 0;
		ui = new UI();
		
		add(ui);
		
		ui.displayFullscreenImage(backgrounds[whichBackground]);
		
		FlxG.sound.pause();
		
    }
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justReleased.SPACE) {
			if (whichText == 7){ FlxG.switchState(new GameState2()); return;}
			
			whichText += 1;
			
			ui.updateText(texts[whichText]);
			
			if (whichText==3) {
				ui.displayFullscreenImage(backgrounds[++whichBackground]);
			}
		}
	}	
	
	function endCutScene(Timer:FlxTimer):Void {
	
		FlxG.switchState(new GameState2());
		
	}
	
}