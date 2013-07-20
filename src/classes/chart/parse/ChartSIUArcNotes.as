package classes.chart.parse {
	import classes.chart.BPMSegment;
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import classes.chart.Stop;
	
	public class ChartSIUArcNotes extends NoteChart {
		//- Input:
		// _root.beatBox = [[66, 20, "blue"], ......... , [4375, 20, "red"]];
		
		public function ChartSIUArcNotes(id:Number, inData:String, framerate:int = 60):void {
			type = NoteChart.SIU_BEATBOX;
			super(id, inData.replace(/\s|"|;/g, "").replace("_root.arcNotes=[", "").split("],["), framerate);
			
			// Extract Notes
			for (var i:int = 0; i < this.chartData.length; i++) {
				var note:Array = this.chartData[i].split(",").map(clean);
				this.Notes.push(new Note(Number(note[1]), Number(note[0]), note[2], Number(note[0])));
			}
		}
		
		override public function noteToTime(n:Note):int {
			return Math.floor(n.getPos() * 60);
		}

		private function clean(ins:String, param2:Object = null, param3:Object = null):String {
			return String(ins).replace(/[[\]]|\s|"|'/g, "");
		}
	}
}