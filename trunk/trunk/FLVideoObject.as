/**
 * ...
 * @author Dustin Sparks
 * @version 0.11
 */ 

package {
    import flash.display.Sprite;
    import flash.events.*;
	import fl.video.*;
	import flash.utils.getTimer;

	/**
	*	The FLVideoObject is a sprite that displays an FLV in sync with a DrawingObject
	*/
    public class FLVideoObject extends Sprite 
	{
		//_______________________________________________________
		//											P R I V A T E
        private var videoURL	:String; 			// Stores the URL the the current video object
		private var xp			:int;				// video x position
		private var yp			:int;				// video y position
		private var w			:int;				// width of the video
		private var h			:int;				// height of the video
		private var fps			:int;				// fps of the video
		private var s			:Object;			// refence back to the main stage --- probably a better way to do this ----
		private var xmlUrl		:String;			// the url to the xml that holds the drawing data (x, y, time)
		
		private var fl			:FLVPlayback; 		// reference to the flash FLVPlayback object that plays the video
        private var time		:int;				// Stores the playhead time of the video
		
		//_________________________________________________________
		//												P U B L I C
		public var drawingObj	:DrawingObject;			// A reference to the drawing object that handles video-synched drawing

		public var timeOffset	:int = 0;				// holds the difference in time from when the SWF is loaded and the time the video is loaded.
		public var mode			:String = "drawing"; 	// drawing, playback, (soon: text)
		
		/**
		 * FLVideoObject	This is the main constructor for the class
		 * The FLVideoObject is an FLVPlayback object with some extra jobs like recording 
		 * time offsets, checking cue points, and adding a drawing object to synch the drawing.
		 * 
		 * @param	src		url to the video located on the server somewhere
		 * @param	xmlUrl	url to the xml holding the video's associated drawing data
		 * @param	xp		x position of the video on the stage
		 * @param	yp		y position of the video on the stage
		 * @param	w		width of the video
		 * @param	h		height of the video
		 * @param	s		the stage (in all its glory)
		 */
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
			
			addChild(fl); // add the flv to the FLVideoObject
			
			loadVideo(); // sets the x and y coordinate to 0.
			
			setVideoDimensions(); // passes on the FLVideoObject's dimensions to the video
			
			fl.addEventListener(VideoEvent.READY, setInitialTime);		// grab the offset so we can synch the video and drawing later
			fl.addEventListener(VideoEvent.PLAYHEAD_UPDATE, setTime);	// update the time so we know when to add the drawing points
			fl.addEventListener(MetadataEvent.METADATA_RECEIVED, checkCuePoints); //listens for cue points, adds coordinates to the drawing when a cuepoint is found
			
			addDrawingObject(); // adds the drawing object that handles the drawing
			sendCallerID();		// tells the drawing object who's using it.
			
			//---- some checks to see what mode the application is in. Drawing or playback. 
			//---- playback mode does not allow drawing, drawing mode does not allow playback. (of the drawing itself, not the video)
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
		
		/**
		 * Once the metadata is in, start checking for cue points.
		 * When a cue point is reached, tell doDrawing to start drawing
		 * @param	e MetaDataEvent :event telling us whether we've got some metadata or not
		 */
		private function checkCuePoints(e:MetadataEvent):void
		{
			fl.addEventListener(MetadataEvent.CUE_POINT, doDrawing);
		}
		
		/**
		 * When the video is ready to play, grab the SWF's time since it loaded.
		 * This helps synch slower loading instances with faster ones.
		 * @param	e VideoEvent :is the video ready to play yet?
		 */
		public function setInitialTime(e:VideoEvent):void
		{
			timeOffset = getTimer();
			trace(fl.totalTime);
		}
		
		/**
		 * Checks the cuepoint to see if it has all the information we need to draw it.
		 * If its all there, tell the drawing object to draw it.
		 * @param	e MetadataEvent
		 */
		public function doDrawing(e:MetadataEvent):void
		{
			//trace(e.info.duration);

			if(e.info.xpos && e.info.fx && e.info.ypos && e.info.time)
			{
				drawingObj.autoDraw(e.info.fx,e.info.xpos,e.info.ypos, e.info.time);
			}
		}
		
		/**
		 * Sends an instance of the FLVideoObject to the drawingObj so they can talk to each other
		 */
		public function sendCallerID():void
		{
			drawingObj.setCallerID(this);
		}
		
		/**
		 * adds the drawingObj to the FLVideObject
		 */
		private function addDrawingObject():void
		{
			var drawingObj:DrawingObject = new DrawingObject(this, s);
			
			this.drawingObj = drawingObj;
			
			addChild(drawingObj);
		}
		
		/**
		 * sets x and y position of the video
		 */
		private function loadVideo():void
		{
			//fl.load(videoURL);
			fl.x = 0;
			fl.y = 0;
		}
		
		/**
		 * passes on video dimensions from the FLVideoObject to the FLVPlayback object
		 */
		public function setVideoDimensions():void
		{
			this.x = xp;
			this.y = yp;
			this.width = w;
			this.height = h;
		}
		
		/**
		 * Tells the FLV to start playing once we've downloaded enough of the video
		 */
		public function playWhenReady():void
		{
			fl.playWhenEnoughDownloaded();
		}
		
		/**
		 * Pauses the video
		 * @param	e
		 */
		public function pause(e:*):void
		{
			fl.pause();
		}
		
		/**
		 * Starts playing the video
		 * @param	e
		 */
		public function play(e:*):void
		{
			fl.play();
		}
		
		/**
		 * getter for the FLVideoObject's time property
		 * @return
		 */
		public function getTime():Number
		{
			return time;
		}
		
		/**
		 * Forces the drawingObj to synch times with the most currenr FLVideoObject time
		 * @param	time integer representing the current time of the video
		 */
		public function setRemoteTime(time:int):void
		{
			drawingObj.setTime(time);
		}
		
		/**
		 * sets the time and synchs it with the drawingObj
		 * @param	e VideoEvent
		 */
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
		
		/**
		 * Toggles between playback mode and drawing mode
		 * @param	me
		 */
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
		
		/**
		 * remotely tells the drawing object to delete all the currently drawn lines.
		 * @param	e
		 */
		private function clear(e:*):void
		{
			//drawingObj.clearLines();
			drawingObj.clearAll();
		}
		
		/**
		 * Adds the cuepoint directly to the video
		 * @param	cuePt
		 */
		public function addCuePoint(cuePt:Object):void
		{
			fl.addASCuePoint(cuePt);
		}
		
		/**
		 * 
		 * @param	t
		 * @param	n
		 */
		public function addCuePoint2(t:Number,n:String):void
		{
			fl.addASCuePoint(t,n);
		}
		
		/**
		 * rewinds the video the the beginning
		 */
		public function rewind():void
		{
			fl.seekSeconds(0);
		}
		
		/**
		 * creates a GrabXML object that is in charge of downloading the XML file containing the recorded drawings.
		 */
		public function grabXML():void
		{
			trace("FLVObj: Grabbing XML Data");
			var gbXML:GrabXML = new GrabXML(xmlUrl,this, fl);
		}
		
		/**
		 * getter for the total FLV playing time
		 * @return
		 */
		public function getFLVTime():Number
		{
			return fl.totalTime;
		}
		
		/**
		 * getter for the current FLV playing time
		 * @return
		 */
		public function getCurrentFLVTime():Number
		{
			return fl.playheadTime;
		}
		
		/**
		 * getter for the percentage of the FLV that has been played
		 * @return
		 */
		public function getCurrentFLVPercentage():Number
		{
			return fl.playheadPercentage;
		}
		
		/**
		 * another getter for the FLV's total time 
		 * (this is redundant and needs to be removed in the next version)
		 * @return
		 */
		public function getTotalTime():Number
		{
			return fl.totalTime;
		}
		
		/**
		 * getter for the FLVideoObject's name
		 * @return
		 */
		public function getName():String
		{
			return this.name;
		}
		
		/**
		 * remotely tells the drawingObj that it needs to change the color of the line its drawing
		 * @param	c
		 */
		public function setColor(c:uint):void
		{
			drawingObj.color = c;
		}
	}
 }