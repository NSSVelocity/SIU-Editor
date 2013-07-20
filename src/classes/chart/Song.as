package classes.chart {
	import arc.ArcGlobals;
	import arc.NoteMod;
	import classes.chart.parse.ChartFFRLegacy;
	import org.audiofx.mp3.MP3ByteArrayLoader;
	import org.audiofx.mp3.MP3SoundEvent;
	import com.flashfla.media.MP3Extraction;
	import com.flashfla.media.SwfSilencer;
	import com.flashfla.net.ForcibleLoader;
	import com.flashfla.utils.Crypt;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import popups.PopupMessage;
	
	public class Song extends EventDispatcher {
		private var _gvars:GlobalVariables = GlobalVariables.instance;
		private var _avars:ArcGlobals = ArcGlobals.instance;
		
		public var musicLoader:*;
		private var chartLoader:URLLoader;
		
		public var id:uint;
		public var entry:Object;
		public var type:String;
		public var chartType:String;
		public var preview:Boolean;
		public var sound:Sound;
		public var music:MovieClip;
		public var chart:NoteChart;
		public var noteMod:NoteMod;
		public var soundChannel:SoundChannel;
		public var musicPausePosition:int;
		public var musicIsPlaying:Boolean = false;
		public var mp3Frame:int = 0;
		
		public var isLoaded:Boolean = false;
		public var isChartLoaded:Boolean = false;
		public var isMusicLoaded:Boolean = false;
		public var isMusic2Loaded:Boolean = true;
		public var loadFail:Boolean = false;
		
		public var bytesLoaded:uint = 0;
		public var bytesTotal:uint = 0;
		
		private static const LOAD_MUSIC:String = "music";
		private static const LOAD_CHART:String = "chart";
		private var musicForcibleLoader:ForcibleLoader;
		public var musicDelay:int = 0;
		
		public function Song(song:Object, isPreview:Boolean = false):void {
			this.entry = song;
			this.id = song.level;
			this.preview = isPreview;
			this.type = (song.type != null ? song.type : NoteChart.FFR);
			this.chartType = song.type || NoteChart.FFR_LEGACY;
			
			noteMod = new NoteMod(this);

			if (type == "EDITOR")
				chart = NoteChart.parseChart(NoteChart.FFR_BEATBOX, { type:NoteChart.FFR_BEATBOX, level:this.id }, '_root.beatBox = [[1, "L", "blue"]];');
			else if (noteMod.modRate || noteMod.modFPS)
				this.type = NoteChart.FFR_MP3;
			
			load();
		}

		public function unload():void {
			isLoaded = isChartLoaded = isMusicLoaded = false;
			isMusic2Loaded = true;
			loadFail = true;
			music = null;
			chart = null;
		}
		
		private function load():void {
			if (type == NoteChart.FFR_MP3)
				musicLoader = new URLLoader();
			else
				musicLoader = new Loader();
			chartLoader = new URLLoader();
			addLoaderListeners();

			switch (type) {
				case NoteChart.FFR:
				case NoteChart.FFR_RAW:
				case NoteChart.FFR_LEGACY:
					musicForcibleLoader = new ForcibleLoader(musicLoader);
					musicForcibleLoader.load(new URLRequest(urlGen(LOAD_MUSIC)));
					break;
				case NoteChart.FFR_MP3:
					musicLoader.dataFormat = URLLoaderDataFormat.BINARY;
					musicLoader.load(new URLRequest(urlGen(LOAD_MUSIC)));
					break;
				default:
					break;
			}

			switch (chartType) {
				case NoteChart.FFR:
				case NoteChart.FFR_BEATBOX:
				case NoteChart.FFR_RAW:
					chartLoader.load(new URLRequest(urlGen(LOAD_CHART)));
					break;
				default:
					break;
			}
		}
		
		public function get progress():int {
			if (musicLoader != null) {
				return Math.floor(((bytesLoaded / bytesTotal) * 97) + (isChartLoaded ? 3 : 0));
			}
			
			return 0;
		}

		public function getMusicContentLoader():Object {
			return type == NoteChart.FFR_MP3 ? musicLoader : musicLoader.contentLoaderInfo;
		}
		
		private function urlGen(fileType:String):String {
			switch (entry.type || type) {
				case NoteChart.FFR:
				case NoteChart.FFR_RAW:
				case NoteChart.FFR_MP3:
					return Constant.SONG_DATA_URL + "?id=" + (preview ? entry.previewhash : entry.playhash) + (preview ? "&mode=2" : "") + (_gvars.userSession != "0" ? "&session=" + _gvars.userSession : "") + "&type=" + NoteChart.FFR + "_" + fileType;
				
				case NoteChart.FFR_LEGACY:
					return ChartFFRLegacy.songUrl(entry);
				
				default:
					return Constant.SONG_DATA_URL;
			}
		}
		
		private function addLoaderListeners():void {
			var music:Object = getMusicContentLoader();
			music.addEventListener(Event.COMPLETE, musicCompleteHandler);
			music.addEventListener(IOErrorEvent.IO_ERROR, musicLoadError);
			music.addEventListener(SecurityErrorEvent.SECURITY_ERROR, musicLoadError);
			musicLoader.addEventListener(ProgressEvent.PROGRESS, musicProgressHandler);
			chartLoader.addEventListener(Event.COMPLETE, chartLoadComplete);
			chartLoader.addEventListener(IOErrorEvent.IO_ERROR, chartLoadError);
			chartLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, chartLoadError);
		}
		
		private function removeLoaderListeners():void {
			var music:Object = getMusicContentLoader();
			music.removeEventListener(Event.COMPLETE, musicCompleteHandler);
			music.removeEventListener(IOErrorEvent.IO_ERROR, musicLoadError);
			music.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, musicLoadError);
			musicLoader.removeEventListener(ProgressEvent.PROGRESS, musicProgressHandler);
			chartLoader.removeEventListener(Event.COMPLETE, chartLoadComplete);
			chartLoader.removeEventListener(IOErrorEvent.IO_ERROR, chartLoadError);
			chartLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, chartLoadError);
		}
		
		public function loadComplete():void {
			if (isChartLoaded && isMusicLoaded && isMusic2Loaded) {
				removeLoaderListeners();
				isLoaded = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function musicProgressHandler(e:ProgressEvent):void {
			bytesLoaded = e.bytesLoaded;
			bytesTotal = e.bytesTotal;
		}
		
		private function musicCompleteHandler(e:Event):void {
			var chartData:ByteArray;
			if (type == NoteChart.FFR_MP3) {
				chartData = e.target.data;
				isMusic2Loaded = false;

				var metadata:Object = new Object();
				var bytes:ByteArray = MP3Extraction.extractSound(chartData, metadata);
				var loader:MP3ByteArrayLoader = new MP3ByteArrayLoader();
				loader.addEventListener(MP3SoundEvent.COMPLETE, mp3CompleteHandler);
				if (!loader.getSound(bytes, metadata.seek, metadata.samples, metadata.format)) {
					loadFail = true;
					return;
				}
				mp3Frame = metadata.frame - 2;

				var mloader:Loader = new Loader();
				var mbytes:ByteArray = SwfSilencer.stripSound(chartData);
				mloader.contentLoaderInfo.addEventListener(Event.COMPLETE, mp3MusicCompleteHandler);
				if (!mbytes) {
					loadFail = true;
					return;
				}
				mloader.loadBytes(mbytes);
			} else {
				music = e.target.content as MovieClip;

				stop();

				chartData = musicForcibleLoader.inputBytes;
				musicForcibleLoader = null;

				isMusicLoaded = true;
				loadComplete();
			}

			if (chartType == NoteChart.FFR_LEGACY) {
				chart = NoteChart.parseChart(chartType, entry, chartData);
				chartLoadComplete(e);
			}
		}

		private function mp3CompleteHandler(e:MP3SoundEvent):void {
			sound = e.sound as Sound;
			if (noteMod.modRate) {
				rateSound = sound;
				sound = new Sound();
				sound.addEventListener("sampleData", onRateSound);
			}

			isMusic2Loaded = true;
			loadComplete();
		}

		private function mp3MusicCompleteHandler(e:Event):void {
			var info:LoaderInfo = e.currentTarget as LoaderInfo;
			music = info.content as MovieClip;

			isMusicLoaded = true;
			loadComplete();
		}

		private var rateSound:Sound;
		private var rateSample:int = 0;
		private var rateSampleCount:int = 0;
		private var rateSamples:ByteArray = new ByteArray();
		private function onRateSound(e:*):void {
			var osamples:int = 0;
			var rate:Number = _gvars.activeUser.songRate;
			while (osamples < 4096) {
				var sample:int = (e.position + osamples) * rate;
				while (sample < rateSample || sample - rateSample >= rateSampleCount) {
					rateSample += rateSampleCount;
					rateSamples.position = 0;
					var seekExtract:Boolean = (sample < rateSample || sample > rateSample + 8192);
					rateSampleCount = (rateSound as Object).extract(rateSamples, 4096, seekExtract ? sample : -1);
					if (seekExtract)
						rateSample = sample;
					if (rateSampleCount <= 0)
						return;
				}
				rateSamples.position = 8 * (sample - rateSample);
				e.data.writeFloat(rateSamples.readFloat());
				e.data.writeFloat(rateSamples.readFloat());
				osamples++;
			}
		}

		private function stopSound(e:*):void {
			musicIsPlaying = false;
		}

		private function chartLoadComplete(e:Event):void {
			switch (chartType) {
				case NoteChart.FFR:
				case NoteChart.FFR_MP3:
					chart = NoteChart.parseChart(NoteChart.FFR, entry, Crypt.ROT255(Crypt.B64Decode(e.target.data)));
					break;
				
				case NoteChart.FFR_BEATBOX:
				case NoteChart.FFR_RAW:
					chart = NoteChart.parseChart(chartType, entry, e.target.data);
					break;
					
				case NoteChart.FFR_LEGACY:
					if (entry.arrows == 0)
						entry.arrows = chart.Notes.length;
					break;
				
				case NoteChart.THIRDSTYLE:
					chart = NoteChart.parseChart(chartType, entry, e.target.data);
					break;
				
				default:
					throw Error("Unsupported NoteChart type!");
			}
			isChartLoaded = true;
			
			loadComplete();
		}
		
		private function musicLoadError(e:Event = null):void {
			_gvars.gameMain.addPopup(new PopupMessage(_gvars.gameMain, "An error occured while loading the music.", "ERROR"));
			removeLoaderListeners();
			loadFail = true;
		}
		
		private function chartLoadError(e:Event = null):void {
			_gvars.gameMain.addPopup(new PopupMessage(_gvars.gameMain, "An error occured while loading the chart file.", "ERROR"));
			removeLoaderListeners();
			loadFail = true;
		}
		
		///- Song Function
		public function start():void {
			updateMusicDelay();
			if (soundChannel) {
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, stopSound);
				soundChannel.stop();
			}
			if (sound) {
				soundChannel = sound.play(musicDelay * 1000 / _gvars.activeUser.songRate / 30);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, stopSound);
			}
			if (music)
				music.gotoAndPlay(2 + musicDelay);
			musicIsPlaying = true;
		}
		
		public function stop():void {
			if (music)
				music.stop();
			if (soundChannel) {
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, stopSound);
				soundChannel.stop();
				musicPausePosition = 0;
				soundChannel = null;
			}
			musicIsPlaying = false;
		}
		
		public function pause():void {
			var pausePosition:int = 0;
			if (soundChannel)
				pausePosition = soundChannel.position;
			stop();
			musicPausePosition = pausePosition;
		}
		
		public function resume():void {
			if (music)
				music.play();
			if (sound) {
				soundChannel = sound.play(musicPausePosition);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, stopSound);
			}
			musicIsPlaying = true;
		}

		private function playClips(clip:MovieClip):void {
			clip.gotoAndPlay(2 + musicDelay);
			for (var i:int = 0; i < clip.numChildren; i++) {
				var subclip:MovieClip = clip.getChildAt(i) as MovieClip;
				if (subclip)
					playClips(subclip);
			}
		}

		public function reset():void {
			stop();
			start();
			if (music)
				playClips(music);
		}
		
		///- Note Functions
		public function getNote(index:int):Note {
			if (noteMod && noteMod.required())
				return noteMod.transformNote(index);
			
			return chart.Notes[index];
		}
		
		public function get totalNotes():int {
			if (noteMod && noteMod.required())
				return noteMod.transformTotalNotes();
			
			if (!chart.Notes)
				return 0;
			
			return chart.Notes.length;
		}
		
		public function get noteSteps():int {
			return chart.framerate + 1;
		}
		
		public function get frameRate():int {
			return type == NoteChart.FFR_MP3 ? _gvars.activeUser.frameRate : chart.framerate;
		}
		
		public function updateMusicDelay():void {
			noteMod.start();
			if (noteMod.modIsolation)
				musicDelay = Math.max(0, chart.Notes[_avars.configIsolationStart].getFrame() - 60);
			else
				musicDelay = 0;
		}

		public function getPosition():int {
			switch (type) {
				case NoteChart.FFR:
				case NoteChart.FFR_RAW:
				case NoteChart.FFR_LEGACY:
					return (music.currentFrame - 2 - musicDelay) * 1000 / 30;

				case NoteChart.FFR_MP3:
				case NoteChart.THIRDSTYLE:
					return soundChannel.position + (mp3Frame - musicDelay) / _gvars.activeUser.songRate * 1000 / 30;

				default:
					return 0;
			}
		}
	}
}
