package {
	import classes.ButtonSprite;
	import classes.chart.Note;
	import classes.chart.NoteChart;
	import com.flashfla.components.ScrollBar;
	import com.flashfla.components.ScrollPane;
	import draw.Button;
	import draw.ResourceSprite;
	import draw.TileSprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import popup.Popup_FileIn;
	import popup.Popup_FileOut;
	
	public class Editor extends Sprite {
		private var noteChart:NoteChart = NoteChart.smartParseChart(19, Constant.TEST_CHART, 60);
		private var noteWindow:ScrollPane;
		private var noteWindowScrollbar:ScrollBar;
		private var renderColors:Boolean = false;
		
		public function Editor() {
			// Add Background
			var sp:Sprite = TileSprite("bg_main", Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			addChild(sp);
			
			// Add Editor Lines
			sp = TileSprite("bg_editor_linebars", 1005, Constant.GAME_HEIGHT);
			addChild(sp);
			
			// Add Editor Numbers
			sp = ResourceSprite("editor_lane_numbers");
			sp.y = 505;
			addChild(sp);
			
			// Build Editor Area
			noteWindow = new ScrollPane(1005, Constant.GAME_HEIGHT);
			noteWindow.content.addEventListener(MouseEvent.CLICK, e_noteWindowClick);
			noteWindow.addEventListener(MouseEvent.MOUSE_WHEEL, e_noteWindowWheel);
			addChild(noteWindow);
			noteWindowScrollbar = new ScrollBar(23, Constant.GAME_HEIGHT, ResourceSprite("scrollbar_dragger"), TileSprite("scrollbar_bg", 23, Constant.GAME_HEIGHT));
			noteWindowScrollbar.x = 1005;
			noteWindowScrollbar.addEventListener(Event.CHANGE, e_scrollbarChange);
			addChild(noteWindowScrollbar);
			
			// Add Sidebar
			sp = TileSprite("bg_sidebar", 249, Constant.GAME_HEIGHT);
			sp.x = Constant.X_SIDEBAR;
			addChild(sp);
			
			// Add Sidebar - Preview Area
			sp = ResourceSprite("bg_preview_area");
			sp.x = Constant.X_SIDEBAR;
			sp.y = 9;
			addChild(sp);
			
			var bsp_save:ButtonSprite = Button("Save");
			bsp_save.x = Constant.X_SIDEBAR + 10;
			bsp_save.y = Constant.GAME_HEIGHT - bsp_save.height - 10;
			bsp_save.action = "saveChart";
			bsp_save.addEventListener(MouseEvent.CLICK, e_mouseClickHandler);
			addChild(bsp_save);
			
			var bsp_load:ButtonSprite = Button("Load");
			bsp_load.x = Constant.X_SIDEBAR + 10;
			bsp_load.y = Constant.GAME_HEIGHT - bsp_load.height - bsp_save.height - 20;
			bsp_load.action = "loadChart";
			bsp_load.addEventListener(MouseEvent.CLICK, e_mouseClickHandler);
			addChild(bsp_load);
			
			renderNotes();
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, stageInit);
		}
		
		private function e_noteWindowWheel(e:MouseEvent):void {
			var dist:Number = noteWindowScrollbar.scroll + 0.01 * (e.delta > 0 ? -1 : 1);
			noteWindow.scrollTo(dist);
			noteWindowScrollbar.scrollTo(dist);
		}
		
		private function stageInit(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardHandler);
		}
		
		//- Event Handlers
		// Click Event
		private function e_mouseClickHandler(e:Event):void {
			switch(e.target.action) {
				case "saveChart":
					addChild(new Popup_FileOut(noteChart.toString(NoteChart.SIU_BEATBOX)));
					break;
				case "loadChart":
					addChild(new Popup_FileIn(loadChart));
					break;
			}
		}
		
		// Keyboard Event
		private function e_keyboardHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.CONTROL:
					renderColors = !renderColors;
					renderNotes();
					break;
			}
		}
		
		// Note Editor Window Click
		private function e_noteWindowClick(e:MouseEvent):void {
			var nD:int = int(e.localX / 28) * 10;
			var nF:int = int(e.localY / 10);
			
			if (!noteChart.noteRemove(nD, nF)) {
				if (validNote(nF)) {
					noteChart.noteAdd(nD, nF);
				}
			}
			renderNotes();
		}
		
		// Scrollbar Drag
		private function e_scrollbarChange(e:Event):void {
			noteWindow.scrollTo(e.target.scroll);
		}
		
		// Functions
		private function loadChart(text:String):void {
			noteChart = NoteChart.smartParseChart(1, text);
			
			if (noteChart != null) {
				renderNotes();
				Alerts.addAlert("Loaded Chart: " + noteChart.type);
			}
			else {
				Alerts.addAlert("Invalid Chart");
			}
		}
		
		public function validNote(noteFrame:Number):Boolean {
			for (var i:int = noteChart.Notes.length - 1; i >= 0; i--) {
				var n:Note = noteChart.Notes[i];
				if (n.getFrame() == noteFrame) {
					return false;
				}
			}
			return true;
		}
		
		// Render Functions
		public function renderNotes():void {
			if (noteChart == null) return;
			
			noteWindow.content.graphics.clear();
			noteWindow.content.graphics.lineStyle(1, 0, 1);
			for (var i:int = noteChart.Notes.length - 1; i >= 0; i--) {
				var n:Note = noteChart.Notes[i];
				noteWindow.content.graphics.beginFill(getNoteColor(n));
				noteWindow.content.graphics.drawRect(n.getDir() * 2.8, n.getFrame() * 10, 27, 10);
				noteWindow.content.graphics.endFill();
			}
			noteWindow.content.graphics.lineStyle(0, 0xffffff, 0.05);
			for (i = noteWindow.content.height; i >= 0; i -= 10) {
				noteWindow.content.graphics.moveTo(0, i);
				noteWindow.content.graphics.lineTo(1005, i);
			}
			noteWindow.content.graphics.beginFill(0, 0);
			noteWindow.content.graphics.drawRect(0, 0, 1005, noteWindow.content.height);
			noteWindow.content.graphics.endFill();
		}
		
		private function getNoteColor(n:Note):int {
			if (!renderColors)
				return 0xFFFF00;
			
			switch (n.getColor()) {
				default:
				case "yellow":
					return 0xE8F30F;
					break;
				
				case "blue":
					return 0x0F94F3;
					break;
				
				case "red":
					return 0xF30F0F;
					break;
				
				case "green":
					return 0x79F02A;
					break;
				
				case "orange":
					return 0xF3990F;
					break;
				
				case "pink":
					return 0xFA5EF8;
					break;
				
				case "purple":
					return 0xCB2FF5;
					break;
				
				case "cyan":
					return 0x2FF5AE;
					break;
				
				case "white":
					return 0xFFFFFF;
					break;
			}
		}
	}
}