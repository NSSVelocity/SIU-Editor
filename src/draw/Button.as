package draw {
	import classes.ButtonSprite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	public function Button(text:String, res:String = "button"):ButtonSprite {
		var btn:ButtonSprite = new ButtonSprite();
		
		var bmd:BitmapData = Resource.get(res);
		btn.graphics.beginBitmapFill(bmd);
		btn.graphics.drawRect(0, 0, bmd.width, bmd.height);
		btn.graphics.endFill();
		
		var _textfield:TextField = new TextField();
		_textfield.width = btn.width;
		_textfield.height = btn.height  / 2;
		_textfield.selectable = false;
		_textfield.embedFonts = true;
		_textfield.antiAliasType = AntiAliasType.ADVANCED;
		_textfield.defaultTextFormat = Constant.TEXT_FORMAT_CENTER;
		_textfield.text = text;
		_textfield.y = btn.height / 2 - _textfield.height / 2;
		btn.addChild(_textfield);
		
		btn.mouseChildren = false;
		btn.useHandCursor = true;
		btn.buttonMode = true;
		
		return btn;
	}
}