package {
	import classes.Alert;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class Alerts {
		private static var _stage:Stage;
		
		private static var activeAlert:Alert;
		private static var alertsQueue:Array = [];
		
		public static function init(stage:Stage):void {
			_stage = stage;
		}
	
		public static function addAlert(message:String, age:int = 120):void {
			if (activeAlert == null) {
				activeAlert = new Alert(message, age);
				activeAlert.x = Constant.GAME_WIDTH - activeAlert.width - 5;
				activeAlert.y = Constant.GAME_HEIGHT - activeAlert.height - 5;
				_stage.addChild(activeAlert);
				
				_stage.addEventListener(Event.ENTER_FRAME, alertOnFrame);
			} else {
				alertsQueue.push({ms: message, ag: age});
			}
		}
		
		private static function alertOnFrame(e:Event):void {
			// Progress Active Alert
			if (activeAlert) {
				activeAlert.progress();
				if (activeAlert.time > activeAlert.age) {
					_stage.removeChild(activeAlert);
					activeAlert = null;
					_stage.removeEventListener(Event.ENTER_FRAME, alertOnFrame);
				}
			}
			
			// Add new alert if the old alert is finished
			if (activeAlert == null && alertsQueue.length >= 1) {
				var newAlert:Object = alertsQueue.splice(0, 1)[0];
				addAlert(newAlert.ms, newAlert.ag);
			}
			
			// General cleanup in case
			if (activeAlert == null && alertsQueue.length == 0) {
				_stage.removeEventListener(Event.ENTER_FRAME, alertOnFrame);
			}
		}
	}
}