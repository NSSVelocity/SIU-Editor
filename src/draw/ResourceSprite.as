package draw {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public function ResourceSprite(res:String):Sprite {
		var bmd:BitmapData = Resource.get(res);
		var sp:Sprite = new Sprite();
		sp.graphics.beginBitmapFill(bmd);
		sp.graphics.drawRect(0, 0, bmd.width, bmd.height);
		sp.graphics.endFill();
		return sp;
	}
}