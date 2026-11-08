package backend;

class TouchInput
{
	public static var pressedMap:Map<String, Bool> = new Map<String, Bool>();
	public static var prevMap:Map<String, Bool> = new Map<String, Bool>();
	public static var justPressedMap:Map<String, Bool> = new Map<String, Bool>();
	public static var justReleasedMap:Map<String, Bool> = new Map<String, Bool>();

	public static function beginFrame():Void
	{
		prevMap = new Map<String, Bool>();
		for (k in pressedMap.keys())
			prevMap.set(k, pressedMap.get(k));
	}

	public static function setPressed(name:String, value:Bool):Void
	{
		pressedMap.set(name, value);
	}

	public static function endFrame():Void
	{
		justPressedMap = new Map<String, Bool>();
		justReleasedMap = new Map<String, Bool>();
		for (k in pressedMap.keys())
		{
			var cur:Bool = pressedMap.get(k);
			var prevVal:Bool = prevMap.exists(k) ? prevMap.get(k) : false;
			justPressedMap.set(k, cur && !prevVal);
			justReleasedMap.set(k, !cur && prevVal);
		}
	}

	public static function pressed(name:String):Bool
	{
		return pressedMap.exists(name) ? pressedMap.get(name) : false;
	}

	public static function justPressed(name:String):Bool
	{
		return justPressedMap.exists(name) ? justPressedMap.get(name) : false;
	}

	public static function justReleased(name:String):Bool
	{
		return justReleasedMap.exists(name) ? justReleasedMap.get(name) : false;
	}
}
