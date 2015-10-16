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
class CutScene3 extends FlxState
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
		texts.push("Ambrose: And then all that was left was to confront their villainous leader, the terrible-");
		texts.push("Tom: Ogre! You haven't gotten to The Hunter yet, have you?");
		texts.push("Ambrose: Now see here Tom, you know right well there wasn't an ogre in Widebrook. I'm telling the story just as my mother told me twenty years ago.");
		texts.push("Tom: Well, this is the story that I heard from Daisy Prescott, Ellie's niece, not ten years ago. Did you hear the story from a relative of Ellen Prescott?");
		texts.push("Ambrose: ...");
		texts.push("Tom: I thought not. Now then, an ogre had just arrived in town, and iff'n his demise wasn't rapidly exacted, he would kill each an' every living thing in the county.");
		texts.push("Will: Couldn't have been a real ogre, could it?");
		texts.push("Tom: It happened right here in Widebrook. We oughter know now shouldn't we?");
		texts.push("Dan: He has a point.");
		texts.push("Tom: Fortunately, Ellie Prescott, the hairdresser-assassin, was agilitous enough to outpace an ogre and the townspeople knew that she would rid us of the monster and re-pacificate Widebrook...");
		
		backgrounds = new Array<String>();
		backgrounds.push("assets/images/placeholder_background_3_1.png");
		backgrounds.push("assets/images/placeholder_background_3_2.png");
		backgrounds.push("assets/images/placeholder_background_3_3.png");
		
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
			if (whichText == 9){ FlxG.switchState(new GameState3()); return;}
			
			whichText += 1;
			
			ui.updateText(texts[whichText]);
			
			if (whichText==1) {
				ui.displayFullscreenImage(backgrounds[++whichBackground]);
			}
			if (whichText==5) {
				ui.displayFullscreenImage(backgrounds[++whichBackground]);
			}
		}
	}	
	
	function endCutScene(Timer:FlxTimer):Void {
	
		FlxG.switchState(new GameState2());
		
	}
	
}