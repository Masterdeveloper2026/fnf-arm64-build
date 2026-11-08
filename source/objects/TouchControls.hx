package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;
import backend.TouchInput;

class TouchControls extends FlxSpriteGroup
{
	var buttonNames:Array<String> = [];
	var buttonRects:Array<Rectangle> = [];
	var buttonSprites:Array<FlxSprite> = [];

	public function new()
	{
		super();
		var minDim:Float = Math.min(FlxG.width, FlxG.height);
		var size:Int = Std.int(minDim * 0.16);
		var pad:Int = Std.int(size * 0.2);

		addButton('note_left', pad, FlxG.height - size - pad, size, 0);
		addButton('note_down', pad, FlxG.height - size * 2 - pad * 2, size, 1);
		addButton('note_right', FlxG.width - size - pad, FlxG.height - size - pad, size, 3);
		addButton('note_up', FlxG.width - size - pad, FlxG.height - size * 2 - pad * 2, size, 2);
		addButton('pause', FlxG.width - Std.int(size * 0.75) - pad, pad, Std.int(size * 0.75), 4);

		scrollFactor.set(0, 0);
	}

	function addButton(name:String, x:Int, y:Int, size:Int, dir:Int):Void
	{
		var bmp:BitmapData = makeArrow(size, dir);
		var spr:FlxSprite = new FlxSprite(x, y, bmp);
		spr.alpha = 0.4;
		spr.scrollFactor.set(0, 0);
		add(spr);

		buttonNames.push(name);
		buttonRects.push(new Rectangle(x, y, size, size));
		buttonSprites.push(spr);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		TouchInput.beginFrame();
		for (i in 0...buttonNames.length)
			TouchInput.setPressed(buttonNames[i], false);

		for (touch in FlxG.touches.list)
		{
			if (!touch.pressed) continue;
			var tx:Float = touch.x;
			var ty:Float = touch.y;
			for (i in 0...buttonNames.length)
			{
				var r:Rectangle = buttonRects[i];
				if (tx >= r.x && tx <= r.x + r.width && ty >= r.y && ty <= r.y + r.height)
					TouchInput.setPressed(buttonNames[i], true);
			}
		}

		if (FlxG.mouse.pressed)
		{
			var mx:Float = FlxG.mouse.x;
			var my:Float = FlxG.mouse.y;
			for (i in 0...buttonNames.length)
			{
				var r:Rectangle = buttonRects[i];
				if (mx >= r.x && mx <= r.x + r.width && my >= r.y && my <= r.y + r.height)
					TouchInput.setPressed(buttonNames[i], true);
			}
		}

		TouchInput.endFrame();

		for (i in 0...buttonNames.length)
		{
			buttonSprites[i].alpha = TouchInput.pressed(buttonNames[i]) ? 0.85 : 0.4;
		}
	}

	static function makeArrow(size:Int, dir:Int):BitmapData
	{
		var bmp:BitmapData = new BitmapData(size, size, true, 0x00000000);
		var bg:Shape = new Shape();
		bg.graphics.beginFill(0xFFFFFF, 0.18);
		bg.graphics.drawRoundRect(0, 0, size, size, size * 0.3, size * 0.3);
		bg.graphics.endFill();
		bmp.draw(bg);

		var tri:Shape = new Shape();
		tri.graphics.beginFill(0xFFFFFF, 0.85);
		var m:Float = size * 0.22;
		switch (dir)
		{
			case 0: // left
				tri.graphics.moveTo(size - m, m);
				tri.graphics.lineTo(m, size * 0.5);
				tri.graphics.lineTo(size - m, size - m);
			case 1: // down
				tri.graphics.moveTo(m, m);
				tri.graphics.lineTo(size * 0.5, size - m);
				tri.graphics.lineTo(size - m, m);
			case 2: // up
				tri.graphics.moveTo(m, size - m);
				tri.graphics.lineTo(size * 0.5, m);
				tri.graphics.lineTo(size - m, size - m);
			case 3: // right
				tri.graphics.moveTo(m, m);
				tri.graphics.lineTo(size - m, size * 0.5);
				tri.graphics.lineTo(m, size - m);
			case 4: // pause
				var w:Int = Std.int(size * 0.18);
				var h:Int = Std.int(size * 0.5);
				var cx:Int = Std.int(size * 0.5);
				var cy:Int = Std.int(size * 0.5);
				tri.graphics.beginFill(0xFFFFFF, 0.85);
				tri.graphics.drawRect(cx - w * 2, cy - h * 0.5, w, h);
				tri.graphics.drawRect(cx + w, cy - h * 0.5, w, h);
		}
		tri.graphics.endFill();
		bmp.draw(tri);
		return bmp;
	}
}
