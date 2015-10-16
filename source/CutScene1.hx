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
class CutScene1 extends FlxState
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
		texts.push("Tom Wilcox: Oh quit tuggin' on that beard a' yours Ambrose, we all seen you got it trimmed.");
		texts.push("Ambrose Starr: I was not doing anything of the sort. Quality facial hair needs no promotion- it speaks for itself.");
		texts.push("Tom: Yeah, yeah, sure. Will, he's like this all the time- overproud of the hair on his face, if you're askin' me. Even has a family legend that his grandfather was a regular customer of Ellen Prescott.");
		texts.push("Dan Monroe: Ha!");
		texts.push("Will Morgan: Who?");
		texts.push("Tom: Oh come now Will, even with you bein' an out-of-towner, I'd figure you knew the legendary Ellie Prescott.");
		texts.push("Will: Haven't the foggiest notion of who that is.");
		texts.push("Tom: Now you see you've got Ambrose all in a state. I can't see as to how you'd never heard of the greatest hero the States have ever known, the pride of our very own Widebrook, Virginia. You need to be told.   Dan, tell him.");
		texts.push("Dan: Never was there a hairdresser so prolific, so redoubtable, as the great Ellie Prescott.");
		texts.push("Will: The greatest hero in America was a hairdresser?");
		texts.push("Dan: She could cut hair just by walkin' past it. She could toss a blade 'crost the room and trim a five o'clock shadow clean off. Why, she could split a lady's hair right down its length as easy as you could make a line in the sand...");
	
		backgrounds = new Array<String>();
		backgrounds.push("assets/images/placeholder_background_1_1.png");
		backgrounds.push("assets/images/placeholder_background_1_2.png");
		
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
			if (whichText == 10){ FlxG.switchState(new GameState1()); return;}
			
			whichText += 1;
			
			ui.updateText(texts[whichText]);
			
			if (whichText==8) {
				ui.displayFullscreenImage(backgrounds[++whichBackground]);
			}
		}
	}	
	
	function endCutScene(Timer:FlxTimer):Void {
	
		FlxG.switchState(new GameState1());
		
	}
	
}