package;
import flixel.FlxState;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;


/**
 * ...
 * @author robert
 */
class RestartState extends FlxState 
{
	//store name of cut scene to return to
	var cutScene:FlxState;
	var restartLabel:FlxText;
	
	public function new(scene:FlxState) 
	{
		super();
		cutScene = scene;
	}
	
	override public function create():Void
    {
		super.create();
		
		restartLabel = new FlxText(0, FlxG.height / 2, FlxG.width, "Wait!\nThat's not how it happened!");
		restartLabel.setFormat(null, 40, FlxColor.WHITE, "center");
		add(restartLabel);
		
		FlxG.sound.pause();
		
    }
	
	override public function update():Void
	{
		
		super.update();
		
		if (FlxG.keys.justPressed.SPACE) FlxG.switchState(cutScene);
	}	
	
}