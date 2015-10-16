package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxG;

class Background extends FlxTypedGroup<FlxSprite>
{
	var b1:FlxSprite;
	
	var b2:FlxSprite;
	var b3:FlxSprite;
	
	var p1:FlxSprite;
	var p2:FlxSprite;

	public function new() 
	{
		super();
		
		b1 = new FlxSprite();
		b1.loadGraphic("assets/images/Muro Sunset.png", false, 1024, 768);
		b1.scrollFactor.set();
		
		b2 = new FlxSprite();
		b2.loadGraphic("assets/images/BGShadow.png", false, 2111, 641);
		b3 = new FlxSprite();
		b3.loadGraphic("assets/images/BGShadow.png", false, 2111, 641);
		
		b2.y = FlxG.camera.height - b2.height;
		b3.y = FlxG.camera.height - b3.height;
		
		p1 = new FlxSprite();
		p1.loadGraphic("assets/images/Cloudy.png", false, 1240, 585);
		
		p2 = new FlxSprite();
		p2.loadGraphic("assets/images/Cloudy.png", false, 1240, 585);
		
		add(b1);
		
		//add(b2);
		//add(b3);
		
		add(p1);
		add(p2);
	}
	
	override public function update():Void
	{
		p1.x = FlxG.camera.scroll.x - (FlxG.camera.scroll.x * 0.5) % (p1.width);
		p2.x = FlxG.camera.scroll.x - (FlxG.camera.scroll.x * 0.5) % (p1.width) + p1.width;
		
		//b2.x = FlxG.camera.scroll.x - (FlxG.camera.scroll.x * 0.5) % (b2.width);
		//b3.x = FlxG.camera.scroll.x - (FlxG.camera.scroll.x * 0.5) % (b2.width) + b2.width;
		
		super.update();
	}
	
}