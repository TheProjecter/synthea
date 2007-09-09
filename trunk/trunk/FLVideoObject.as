 package {
    import flash.display.Sprite;
    import flash.events.*;
	import fl.video.*;
	import flash.utils.getTimer;

    public class FLVideoObject extends Sprite 
	{
        private var videoURL:String;
		private var xp:int;
		private var yp:int;
		private var w:int;
		private var h:int;
		private var fps:int;
		private var s:Object;
		private var xmlUrl:String;
		
		private var fl:FLVPlayback;
        private var time:int;
		public var drawingObj:DrawingObject;

		public var timeOffset:int = 0;
		public var mode:String = "playback"; //drawing, playback, (soon: text)
		
        public function FLVideoObject(src:String,xmlUrl:String,xp:int,yp:int,w:int,h:int, s:Object) 
		{
			this.videoURL = src;
			this.xp = xp;
			this.yp = yp;
			this.w = w;
			this.h = h;
			this.s = s;
			this.xmlUrl = xmlUrl;
			this.name = "Video";
			
			fl = new FLVPlayback();
			fl.name = this.name;
			fl.source = src;
			
			addChild(fl);
			
			loadVideo();
			
			setVideoDimensions();

			fl.addEventListener(VideoEvent.READY, setInitialTime);
			fl.addEventListener(VideoEvent.PLAYHEAD_UPDATE, setTime);
			fl.addEventListener(MetadataEvent.METADATA_RECEIVED, checkCuePoints);
			
			addDrawingObject();
			sendCallerID();
			
			if(mode == "playback")
			{
				grabXML();
				
			}
			else if(mode == "drawing")
			{
				//sendCallerID();
			}
			
			
			
			/*
			if(mode == "drawing")
			{
				// Do something here when in drawing mode.
				
			}
			else if(mode == "playback")
			{
				// Do something here when in playback mode.
				addDrawingObject();
				grabXML();
				fl.addEventListener(MetadataEvent.CUE_POINT, doDrawing);
			}
			*/
		}
		private function checkCuePoints(e:MetadataEvent):void
		{
			fl.addEventListener(MetadataEvent.CUE_POINT, doDrawing);
			//trace(xml + " :::");
		}
		
		public function setInitialTime(e:VideoEvent):void
		{
			timeOffset = getTimer();
			trace(fl.totalTime);
		}
		
		public function doDrawing(e:MetadataEvent):void
		{
			//trace(e.info.duration);

			if(e.info.xpos && e.info.fx && e.info.ypos && e.info.time)
			{
				drawingObj.autoDraw(e.info.fx,e.info.xpos,e.info.ypos, e.info.time);
			}
		}
		
		public function sendCallerID():void
		{
			drawingObj.setCallerID(this);
		}
		
		private function addDrawingObject():void
		{
			var drawingObj:DrawingObject = new DrawingObject(this, s);
			
			this.drawingObj = drawingObj;
			
			addChild(drawingObj);
		}
		
		private function loadVideo():void
		{
			//fl.load(videoURL);
			fl.x = 0;
			fl.y = 0;
		}
		
		public function setVideoDimensions():void
		{
			this.x = xp;
			this.y = yp;
			this.width = w;
			this.height = h;
		}
		
		public function playWhenReady():void
		{
			fl.playWhenEnoughDownloaded();
		}
		
		public function pause(e:*):void
		{
			fl.pause();
		}
		
		public function play(e:*):void
		{
			fl.play();
		}
		
		public function getTime():Number
		{
			return time;
		}
		
		public function setRemoteTime(time:int):void
		{
			drawingObj.setTime(time);
		}
		
		private function setTime(e:VideoEvent):void
		{
			time = e.currentTarget.playheadTime * 1000;			
			setRemoteTime(time);
			
			var tmer:Object = stage.getChildByName("timer");
			var tmcd:Object = stage.getChildByName("timeCode");
			
			var modeToggler:Object = stage.getChildByName("draw");
			
			var tmcdoffset:Number = tmer.x + tmer.width - tmcd.width - 1;
			
			//trace(e.currentTarget.playheadTime);
			if(tmcdoffset > tmer.x)
			{
				tmcd.x = tmcdoffset;
				tmcd.textColor = 0xFFFFFF;
			}
			else
			{
				tmcd.x = tmcdoffset + tmcd.width + 5;
				tmcd.textColor = 0x000000;
			}
			
			tmcd.text = uint(time*.001) +"/"+uint(e.currentTarget.totalTime);
			tmer.scaleX = getCurrentFLVPercentage()*.01;
			
			modeToggler.addEventListener(MouseEvent.MOUSE_DOWN, toggleModes);
			
			s.getChildByName("playBtn").addEventListener(MouseEvent.MOUSE_DOWN, play);
			s.getChildByName("pauseBtn").addEventListener(MouseEvent.MOUSE_DOWN, pause);
			
			s.getChildByName("save").addEventListener(MouseEvent.MOUSE_DOWN,drawingObj.doSave);
			
			s.getChildByName("erase").addEventListener(MouseEvent.MOUSE_DOWN,clear);
		}
		
		private function toggleModes(me:MouseEvent):void
		{
			if(mode == "playback")
			{
				mode = "drawing";
				
			}
			else if(mode == "drawing")
			{
				mode = "playback";
				
			}
			clear(null);
			rewind();
		}
		
		private function clear(e:*):void
		{
			//drawingObj.clearLines();
			drawingObj.clearAll();
		}
		
		public function addCuePoint(cuePt:Object):void
		{
			fl.addASCuePoint(cuePt);
		}
		
		public function addCuePoint2(t:Number,n:String):void
		{
			fl.addASCuePoint(t,n);
		}
		
		public function rewind():void
		{
			fl.seekSeconds(0);
		}
		
		public function grabXML():void
		{
			trace("FLVObj: Grabbing XML Data");
			var gbXML:GrabXML = new GrabXML(xmlUrl,this, fl);
		}
		
		public function getFLVTime():Number
		{
			return fl.totalTime;
		}
		
		public function getCurrentFLVTime():Number
		{
			return fl.playheadTime;
		}
		
		public function getCurrentFLVPercentage():Number
		{
			return fl.playheadPercentage;
		}
		
		public function getTotalTime():Number
		{
			return fl.totalTime;
		}
		
		public function getName():String
		{
			return this.name;
		}
		
		public function setColor(c:uint):void
		{
			drawingObj.color = c;
		}
	}
 }