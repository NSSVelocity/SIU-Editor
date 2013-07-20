package popup {
	import draw.Button;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	public class Popup_FileIn extends Popup {
		
		private var _tf:TextField;
		
		public function Popup_FileIn(leftFun:Function = null, rightFun:Function = null) {
			leftBtn = Button("Load");
			rightBtn = Button("Cancel");
			
			super(leftFun, rightFun);
			
			_tf = new TextField();
			_tf.border = true;
			_tf.borderColor = 0x121212;
			_tf.x = (Constant.GAME_WIDTH / 2) - (Constant.POPUP_WIDTH / 2) + 5;
			_tf.y = (Constant.GAME_HEIGHT / 2) - (Constant.POPUP_HEIGHT / 2) + 5;
			_tf.width = Constant.POPUP_WIDTH - 10;
			_tf.height = Constant.POPUP_HEIGHT - 65;
			_tf.multiline = true;
			_tf.selectable = true;
			_tf.embedFonts = true;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.defaultTextFormat = Constant.TEXT_FORMAT;
			_tf.type = "input";
			addChild(_tf);
		}
		
		override protected function returnVariable():* {
			return _tf.text;
		}
	}
}