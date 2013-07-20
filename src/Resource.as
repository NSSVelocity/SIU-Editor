package {
	import com.flashfla.utils.getDefinitionNames;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class Resource {
		private static var _loader:Loader;
		private static var _res:Array = [];
		public static var isComplete:Boolean = false;
		
		public static function init():void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, lC);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, lE);
			_loader.load(new URLRequest("lib/assets.swf?" + new Date().getTime()));
		}
		
		private static function lC(e:Event = null):void {
			var assets:Array = getDefinitionNames(e.target, false, true);
			for (var i:int = 0; i < assets.length; i++) {
				try { _res[assets[i].split("::")[1]] = e.target.applicationDomain.getDefinition(assets[i]) as Class; } catch (e:Error) {}
			}
			isComplete = true;
		}
		
		private static function lE(e:Event = null):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, lC);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, lE);
			_loader = null;
		}
		
		public static function get(name:String, isNew:Boolean = true):* {
			return isNew ? new (_res[name]) : _res[name];
		}
	}
}