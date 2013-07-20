package classes.chart {
	
	public class BPMSegment {
		private var myStart:Number;
		private var myEnd:Number;
		private var myBPM:Number;
		
		public function BPMSegment(start:Number, bpm:Number, end:Number = -1):void {
			myStart = start;
			myEnd = end;
			myBPM = bpm;
		}
		
		public function totalTime():Number {
			return 240.0 * (myEnd - myStart) / myBPM;
		}
		
		public function getStart():Number {
			return myStart;
		}
		
		public function setStart(start:Number):void {
			myStart = start;
		}
		
		public function getEnd():Number {
			return myEnd;
		}
		
		public function setEnd(end:Number):void {
			myEnd = end;
		}
		
		public function getBPM():Number {
			return myBPM;
		}
	}
}

