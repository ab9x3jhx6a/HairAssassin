package;

 import flixel.FlxBasic;
 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxTypedGroup;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;
 import flixel.ui.FlxBar;
 import flixel.util.FlxTimer;
 using flixel.util.FlxSpriteUtil;

/**
 * @author Kevin
 */
class UI extends FlxTypedGroup<FlxSprite> 
{
	
	var frame:Int = 0;
	var waitframe:Int = -1;
	
	var barHealth:FlxBar;
	var sprTextBox:FlxSprite;
	var textTextBox:FlxText;
	
	var sprHair:FlxSprite;
	var healthicon:FlxSprite;
	var healthicon_half:FlxSprite;
	var healthicon_low:FlxSprite;
	var textHair:FlxText;
	var textTime:FlxText;
	var timerClock:FlxTimer;
	
	
	var goalString:String = "";
	var goalStringIndex:Int = 0;
	public var hairCount = 0;
	
	var sprFullScreen:FlxSprite;
	
	var MAX_LENGTH_OF_TEXT:Int = 240;
	public var TIMER_LENGTH:Int = 0 * 60 + 30 * 1;
	
	public function new() 
	{
		super();
		
		barHealth = new FlxBar(0,0,FlxBar.FILL_LEFT_TO_RIGHT, 250,50);
		barHealth.createGradientBar([0xEE000000, 0xEE0C0C0], [0xFF00FF00, 0xFFFFFF00, 0xFFFF0000], 1, 180, true, 0xFF000000);
		barHealth.x = FlxG.width - barHealth.width;
		barHealth.percent = 100;
		sprTextBox = new FlxSprite().makeGraphic(700, 150);
		sprTextBox.x = (FlxG.width - sprTextBox.width)/2; //center it onscreen
		sprTextBox.y = (4 / 5) * FlxG.height;
		sprTextBox.alpha = 0;
		textTextBox = new FlxText(0, (2 / 3) * FlxG.height, (4 / 5) * FlxG.width, "", 20/*, BOOL use imbedded fonts)*/); 
		textTextBox.systemFont = "Courier New";
		textTextBox.bold = true;
		textTextBox.color = 0xFF000000;
		textTextBox.fieldWidth = sprTextBox.width - 40;
		textTextBox.x = sprTextBox.x + 20;
		textTextBox.y = sprTextBox.y + 20;
		textTextBox.alignment = "left";
		if (textTextBox.text.length > MAX_LENGTH_OF_TEXT) FlxG.cameras.bgColor = 0xFF000000;
		sprHair = new FlxSprite(FlxG.width * (1 / 10) + 10, 5, "assets/images/items/score.png"); 
		healthicon = new FlxSprite(FlxG.width * (7 / 10) - 10, 5, "assets/images/items/health.png");
		healthicon_half = new FlxSprite(FlxG.width * (7 / 10) - 10, 5, "assets/images/items/health_half.png");
		healthicon_low = new FlxSprite(FlxG.width * (7 / 10) - 10, 5, "assets/images/items/health_low.png");
		textHair = new FlxText(sprHair.x + sprHair.width + 15, sprHair.y + sprHair.width / 2 - 12, 85, "x00", 20);
		textHair.color = 0xFF000000;
		textTime = new FlxText(5, 5, 85, "5:00", 20);
		textTime.color = 0xFF000000;
		timerClock = new FlxTimer(TIMER_LENGTH, null, 1);
		sprFullScreen = new FlxSprite(0, 0, "assets/images/racoon.jpg");
		sprFullScreen.alpha = 0;
		
		//add(sprHealth);
		add(barHealth);
		add(sprHair);
		add(healthicon);
		add(healthicon_half);
		add(healthicon_low);
		add(textTime);
		add(textHair);
		add(sprFullScreen);
		add(sprTextBox);
		add(textTextBox);
		
		healthicon.alpha = 1;
		healthicon_half.alpha = 0;
		healthicon_low.alpha = 0;
		
		//prevent any scrolling onscreen
		forEach(function(spr:FlxSprite) {
             spr.scrollFactor.set();
         });
		 
	}
	
	override public function update():Void {
		frame++;
		
		if (frame == waitframe) {
			waitframe = -1;
			textTextBox.alpha = 0;
			sprTextBox.alpha = 0;
		}
		
		if (textTextBox.text != goalString) {
			if (textTextBox.text.length > MAX_LENGTH_OF_TEXT) {
				goalString = goalString.substring(textTextBox.text.length, goalString.length);
				textTextBox.text = "";
				goalStringIndex = 0;
			}
			if (frame % 1 == 0){
				textTextBox.text += goalString.charAt(goalStringIndex);
				goalStringIndex++;
			}
		}
		
		updateClockDisplay();
		
		super.update();
	}
	
	public function updateHealthBar(healthe:Float) : Void{
		//barHealth.health = _player.HP;
		barHealth.percent = healthe;
		if (barHealth.percent > 50 && barHealth.percent < 100) {
			healthicon.alpha = 1;
			healthicon_half.alpha = 0;
			healthicon_low.alpha = 0;
		}
		else if (barHealth.percent > 25 && barHealth.percent <= 50) {
			healthicon.alpha = 0;
			healthicon_half.alpha = 1;
			healthicon_low.alpha = 0;	
		}
		else if (barHealth.percent <= 25) {
			healthicon.alpha = 0;
			healthicon_half.alpha = 0;
			healthicon_low.alpha = 1;	
		}
	}
	
	public function updateText(texte:String) : Void {
		textTextBox.alpha = 1;
		sprTextBox.alpha = 1;
		goalString = texte;
		textTextBox.text = "";
		goalStringIndex = 0;
		waitframe = frame + texte.length + 900; //This relies upon the fact that we draw one letter per frame
	}
	
	public function setTimer(duration:Int) {
		TIMER_LENGTH = duration;
		timerClock = new FlxTimer(duration, null, 1);
	}
	
	public function destroyTimer() {
			timerClock.destroy();
			this.remove(textTime);
	}
	
	private function updateClockDisplay() {
		var seconds_left:Int = Std.int(TIMER_LENGTH - timerClock.progress * TIMER_LENGTH);
		var min:String = Std.string(Std.int(seconds_left / 60));
		var sec:String = Std.string(seconds_left % 60);
		if (min.length == 1) min = "0" + min;
		if (sec.length == 1) sec = "0" + sec;
		textTime.text = min + ":" + sec;
		
		if (min == "00" && sec == "00") TIMER_LENGTH = 0;
		
		//turn red when < 20 seconds left
		if (min == "00" && Std.parseFloat(sec) < 20) textTime.color = 0xFFFF0000;
		
		//alternatively,  turn red when under x percentage
		/*var x:Int = 20; //<-- 10 means ten percent of time left
		if (timerClock.progress >= (1 - .01 * x) )
			textTime.color = 0xFFFF0000;*/
	}
	
	public function getRemainingTime():Int {
		return Std.int(TIMER_LENGTH - timerClock.progress);
	}
	
	public function updateHairCount(haire:Int) : Void {
		hairCount = haire;
		var prefix:String = "x";
		if (hairCount < 10) prefix += "0";
		textHair.text = prefix + Std.string(hairCount);
	}
	
	public function increaseHairCount(haire:Int=1) : Void {
		hairCount += haire;
		var prefix:String = "x";
		if (hairCount < 10) prefix += "0";
		textHair.text = prefix + Std.string(hairCount);
	}
	
	public function displayFullscreenImage(image:String = "assets/images/ford.jpg") {
			sprFullScreen.alpha = 1;
			sprFullScreen.loadGraphic(image);
	}
	
	public function clearFullscreenImage() {
			sprFullScreen.alpha = 0;
	}
}