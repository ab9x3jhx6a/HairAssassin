package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

using flixel.util.FlxSpriteUtil;

class StaticObject extends FlxSprite
{
	var pos_x:Int;
	var pos_y:Int;

	public function new(pos_x:Int, pos_y:Int, path:String) 
	{
		super();
		
		this.loadGraphic(path,false,32,32);
		
		this.setPosition(pos_x,pos_y);
		this.immovable = true;
	}
	
	override public function update():Void
	{
		super.update();
		
	}
	
	
	
}