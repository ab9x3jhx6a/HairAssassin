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

class TiledGameState extends FlxState
{
	var hairDresser:HairDresser;
	var tileMap:FlxTilemap;

	public function new() 
	{
		super();
		
	}
	
	
	override public function create():Void
    {
        super.create();
		
		hairDresser = new HairDresser();
		
		tileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/testlevel.csv");
        var mapTilePath:String = "assets/images/Levels/tilemap.png";
        tileMap.loadMap(mapData, mapTilePath, 32, 32);
		
        add(tileMap);
		add(hairDresser);
		
	}
	
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(hairDresser,tileMap);
	}
		
	
}