package popup {
	import draw.ResourceSprite;
	import draw.TileSprite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Popup extends Sprite {
		protected var leftBtn:Sprite;
		protected var rightBtn:Sprite;
		private var leftFun:Function;
		private var rightFun:Function;
		
		public function Popup(leftFun:Function = null, rightFun:Function = null) {
			this.leftFun = leftFun;
			this.rightFun = rightFun;
			
			// Draw Background
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			graphics.endFill();
			
			// Draw Window
			var bg:Sprite = ResourceSprite("bg_popup");
			bg.x = ((Constant.GAME_WIDTH / 2) - (bg.width / 2));
			bg.y = ((Constant.GAME_HEIGHT / 2) - (bg.height / 2));
			addChild(bg);
			
			// Add buttons
			// Singles
			if (leftBtn && !rightBtn) {
				leftBtn.x = (bg.width / 2 - leftBtn.width / 2);
				leftBtn.y = ((Constant.GAME_HEIGHT / 2) + (bg.height / 2)) - 10 - leftBtn.height;
			} else if (rightBtn && !leftBtn) {
				rightBtn.x = (bg.width / 2 - rightBtn.width / 2);
				rightBtn.y = ((Constant.GAME_HEIGHT / 2) + (bg.height / 2)) - 10 - rightBtn.height;
			}
			// Both
			else if (leftBtn && rightBtn) {
				leftBtn.x = ((Constant.GAME_WIDTH / 2) - (bg.width / 2)) + 10;
				leftBtn.y = ((Constant.GAME_HEIGHT / 2) + (bg.height / 2)) - 10 - leftBtn.height;
				
				rightBtn.x = ((Constant.GAME_WIDTH / 2) + (bg.width / 2)) - 10 - rightBtn.width;
				rightBtn.y = ((Constant.GAME_HEIGHT / 2) + (bg.height / 2)) - 10 - leftBtn.height;
			}
			
			if (leftBtn) {
				leftBtn.addEventListener(MouseEvent.CLICK, buttonLeft);
				addChild(leftBtn);
			}
			if (rightBtn) {
				rightBtn.addEventListener(MouseEvent.CLICK, buttonRight);
				addChild(rightBtn);
			}
		}
		
		protected function returnVariable():* {
			return null;
		}
		
		protected function buttonLeft(e:MouseEvent):void {
			removePopup();
			if (leftFun != null) {
				leftFun(returnVariable());
			}
		}
		
		protected function buttonRight(e:MouseEvent):void {
			removePopup();
			if (rightFun != null) {
				rightFun(returnVariable());
			}
		}
		
		protected function removePopup():void {
			if (this.parent) {
				if (this.parent.contains(this)) {
					this.parent.removeChild(this);
				}
			}
		}
	}
}