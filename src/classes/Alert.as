package classes {
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	public class Alert extends Sprite {
		public var message:String;
		public var age:int = 120;
		public var time:int = 0;
		
		private var _textfield:TextField;
		private var _background:Sprite;
		
		public function Alert(message:String, age:int = 120) {
			this.message = message;
			this.age = age;
			
			_textfield = new TextField();
			_textfield.x = 6;
			_textfield.y = 2;
			_textfield.selectable = false;
			_textfield.embedFonts = true;
			_textfield.antiAliasType = AntiAliasType.ADVANCED;
			_textfield.autoSize = "left";
			_textfield.defaultTextFormat = Constant.TEXT_FORMAT;
			_textfield.text = message;
			
			_background = new Sprite();
			_background.graphics.lineStyle(1, 0xFFFFFF, 2, true);
			_background.graphics.beginFill(0x000000, 0.75);
			_background.graphics.drawRoundRect(0, 0, _textfield.width + 13, _textfield.height + 3, 8, 8);
			_background.graphics.endFill();
			this.addChild(_background);
			
			this.addChild(_textfield);
			
			this.alpha = 0;
		}
		
		public function progress():void {
			time += 1;
			if (time <= 15) {
				this.alpha = (time / 15);
			} else if (time >= age - 14) {
				this.alpha = 1 + ((age - 14 - time) / 15);
			} else {
				this.alpha = 1;
			}
		}
	}
}