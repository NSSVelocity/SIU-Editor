package draw {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public function TileSprite(res:String, width:Number, height:Number):Sprite {
		var sp:Sprite = new Sprite();
		sp.graphics.beginBitmapFill(Resource.get(res));
		sp.graphics.drawRect(0, 0, width, height);
		sp.graphics.endFill();
		return sp;
	}
}