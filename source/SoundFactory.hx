package;

/**
 * ...
 * @author ...
 */
class SoundFactory
{

	private static var sound:Sound;
	
	public static function getInstance():Sound{
		if (sound == null) {
			sound = new Sound();
		}
		return sound;
	}
}