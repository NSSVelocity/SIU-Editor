package classes.chart.parse {
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import com.flashfla.media.Beatbox;
	import flash.utils.ByteArray;
	
	public class ChartFFRLegacy extends NoteChart {
		private var song:Object;
		
		public function ChartFFRLegacy(entry:Object, inData:Object, framerate:int = 30):void {
			type = NoteChart.FFR_LEGACY;
			
			super(entry.level, null, framerate);
			
			song = entry;
			
			parseChart(ByteArray(inData));
		}
		
		override public function noteToTime(note:Note):int {
			return Math.floor(note.getPos() * framerate);
		}
		
		public function parseChart(data:ByteArray):void {
			var beatbox:Array = Beatbox.parseBeatbox(data);
			if (beatbox) {
				for each (var beat:Object in beatbox) {
					var beatPos:int = beat[0] + (song.sync || 0);
					Notes.push(new Note(beat[1], beatPos / framerate, beat[2] || "blue", beatPos));
				}
			}
		}
	}
}
