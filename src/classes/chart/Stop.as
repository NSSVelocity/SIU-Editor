package classes.chart {
	
	public class Stop {
		private var myPos:Number;
		private var myLength:Number;
		
		public function Stop(pos:Number, length:Number):void {
			myPos = pos;
			myLength = length;
		}
		
		public function getPos():Number {
			return myPos;
		}
		
		public function setPos(pos:Number):void {
			myPos = pos;
		}
		
		public function getLength():Number {
			return myLength;
		}
		
		public function setLength(length:Number):void {
			myLength = length;
		}
	}
}