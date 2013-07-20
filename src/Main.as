package {
	import com.adobe.serialization.json.JSONManager;
	import com.flashfla.components.ProgressBar;
	import com.greensock.OverwriteManager;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite {
		
		public var loadbar:ProgressBar;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Init Classes
			OverwriteManager.init(OverwriteManager.ALL_IMMEDIATE);
			JSONManager.init();
			Resource.init();
			Alerts.init(stage);
			
			stage.stageFocusRect = false;
			addEventListener(Event.ENTER_FRAME, checkResources);
		}
		
		private function checkResources(e:Event):void {
			if (Resource.isComplete) {
				removeEventListener(Event.ENTER_FRAME, checkResources);
				addChildAt(new Editor(), 0);
			}
		}
	}
}