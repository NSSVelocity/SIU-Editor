package classes.chart {
	
	public class Note {
		private var myDir:Number;
		private var myPos:Number;
		private var myColor:String;
		private var myFrame:Number;
		
		/**
		 * Defines a new Note object.
		 * @param	direction
		 * @param	pos
		 * @param	color
		 * @param	frame
		 * @tiptext
		 */
		public function Note(direction:*, pos:Number, color:String, frame:Number = -1):void {
			if (direction is String) {
				myDir = parseDir(direction);
			}
			else {
				myDir = direction;
			}
			myPos = pos;
			myColor = color;
			myFrame = frame;
		}
		
		public function getPos():Number {
			return myPos;
		}
		public function setPos(pos:Number):void {
			myPos = pos;
		}
		
		public function getDir():Number {
			return myDir;
		}
		
		public function setDir(dir:Number):void {
			myDir = dir;
		}
		
		public function getColor():String {
			return myColor;
		}
		
		public function setColor(color:String):void {
			myColor = color;
		}
		
		public function getFrame():Number {
			return myFrame;
		}
		
		public function setFrame(frame:Number):void {
			myFrame = frame;
		}
		
		public static function parseDir(dir:String):Number {
			if (dir == "U") return 40;
			if (dir == "L") return 130;
			if (dir == "D") return 220;
			if (dir == "R") return 310;
			return 0;
		}
	
	}
}