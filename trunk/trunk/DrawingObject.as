/**
*-----
* @author Dustin Sparks
* @version 0.11
*/

package
{
	import fl.video.VideoEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
	
	/**
	*	The DrawingObject is a sprite that is overlayed on top and in sync with the FLVideoObject
	*/
	public class DrawingObject extends Sprite
	{
		private var spriteName		:int = 0;				// An incremental name modifier for new drawing segments (speed issues)
		private var obj				:Object;				// A holder to hold the FLVideoObject
		private var s				:Object;				// A reference back to the Stage object
		private var caller			:FLVideoObject;			// Reference back to the FLVideObject
		private var xmlObj			:XMLObject;				// An object in charge of holding all the XML information
		private var cuePt			:Object = new Object(); // Holder object for default cuepoint
		private var childArray		:Array;					// Holder for all the child sprites (drawing segments)
		private var i				:int;					// Counts the number of bad/unsusable cuepoints.
		
		public var time				:Number = 0;			// Video Elapsed Time Holder
		public var color			:uint = 0xff0000; 		// Default Line Color
		
		
		/**
		* Constructor for DrawingObject. Gives it a name, sets up the XMLObject, and adds mouse and keylisteners.
		* @param obj	Object
		* @param s		Object
		*/
		public function DrawingObject (obj : Object, s:Object) : void
		{
			this.name = "DrawingObject1";
			this.obj = obj;
			
			this.xmlObj = new XMLObject(<drawing></drawing>);
		
				obj.addEventListener(MouseEvent.MOUSE_DOWN, createSprite);
				obj.addEventListener(MouseEvent.MOUSE_UP, removeSpriteListener);
				s.addEventListener(KeyboardEvent.KEY_UP, clearDrawing);
		}
		
		
		/**
		* Stops the event and records a cue point of the event. It also finds the time offset and adds it to the cue point.
		* @param event MouseEvent
		*/
		private function removeSpriteListener (event : MouseEvent) : void
		{
			obj.removeEventListener (MouseEvent.MOUSE_MOVE, drawInSprite);
			
				cuePt.time = (getTimer()-caller.timeOffset) * .001; // This is where most of the magic happens when it comes to syncronizing the drawing with the video later
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = int(mouseX*1000) * .001; // changed from Math.round for efficiency... increased speed about 75%
				cuePt.ypos = int(mouseY*1000) * .001; 
				cuePt.fx = "end";
				
			caller.addCuePoint(cuePt);
		}
		
		/**
		* Creates a new sprite on MouseDown, draws a line inside the new sprite, and records a cue point when the segment is created. 
		* It also adds a MouseMove event to record drawn points within the container.
		* @param event MouseEvent
		*/
		private function createSprite (event : MouseEvent) : void
		{
			spriteName ++;
			
			var sprite : Sprite = new Sprite ();
			sprite.name = "spriteHolder_" + spriteName;
			sprite.x = 0;
			sprite.y = 0;
			sprite.cacheAsBitmap = true;
			
			sprite.graphics.moveTo (mouseX, mouseY);
			
			obj.addEventListener (MouseEvent.MOUSE_MOVE, drawInSprite);
			addChild (sprite);
			
			xmlObj.addSegment();
			
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = int(mouseX*1000) * .001; // changed from Math.round
				cuePt.ypos = int(mouseY*1000) * .001; // changed from Math.round
				cuePt.fx = "begin";
				
				caller.addCuePoint(cuePt);
		}
		
		/**
		* autoDraw implements drawings. It creates a sprite holder, then caches it as a bitmap for speed.
		* after the sprite is done drawing, it is never drawn to again.
		* This addresses the issue with the drawing API where drawing alot of lines on top of each other slows down framerates.
		* @param fx String
		* @param x Number
		* @param y Number
		* @param time Number
		*/
		public function autoDraw(fx:String, x:Number, y:Number, time:Number):void
		{
			if(fx && x && y && time)
			{
				if(fx == "begin")
				{
					var sprite : Sprite = new Sprite ();
					sprite.name = "spriteHolder_" + spriteName;
					sprite.x = 0;
					sprite.y = 0;
					sprite.cacheAsBitmap = true;
					
					sprite.graphics.moveTo(x, y);
					
					addChild (sprite);
					
					spriteName ++;
				}
				else
				{
					if(getChildren()[getLastChildIndex()])
					{
						var drawingSprite:Sprite = getChildren()[getLastChildIndex()];
						
						drawingSprite.graphics.lineStyle (2, color);
						drawingSprite.graphics.lineTo (x, y);
					}
					else
					{
						trace("Something went wrong with the cue point: "+ i +" __  " + getChildren()[getNumberOfChildren].name + "  " + getLastChildIndex());
						i++
					}
				}
			}
		}
		
		/**
		* Creates cue points recording time and coordinates when the mouse is moved.
		* @param event MouseEvent
		*/
		private function drawInSprite (event : MouseEvent) : void
		{
			var drawingSprite : Sprite = getChildren ()[getLastChildIndex ()];
			drawingSprite.graphics.lineStyle (2, color);
			drawingSprite.graphics.lineTo (uint(mouseX*1000) * .001, uint(mouseY*1000) * .001); // changed from Math.round

			 //create cue point object
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = int(mouseX*1000) * .001; // changed from Math.round
				cuePt.ypos = int(mouseY*1000) * .001; // changed from Math.round
				cuePt.fx = "null";
				
			//caller.addCuePoint(cuePt);
			if(caller.mode == "playback")
			{
				caller.addCuePoint(cuePt);
			}
			xmlObj.addPoint(cuePt.time, uint(mouseX*1000) * .001, uint(mouseY*1000) * .001);
			
			event.updateAfterEvent();
		}
		
		/**
		* getter for the number of children (drawing segments --or sprites) in the DrawingObject
		* @return int
		*/
		public function getNumberOfChildren() : int
		{
			return this.numChildren;
		}
		
		/**
		* getter for the last child index so that removing them from the parent doesnt throw an out of bounds exception for an index that doesnt exist.
		* @return int
		*/
		public function getLastChildIndex () : int
		{
			return this.numChildren -1;
		}
		
		/**
		* getter for all the drawing segments in the holder.
		* @return Array of sprites
		*/
		public function getChildren() : Array
		{
			childArray = new Array ();
			var i : int;
			for (i = 0; i <= getLastChildIndex(); i ++)
			{
				childArray.push (this.getChildAt(i));
			}
			return childArray;
		}
		
		/**
		* Deletes the last line in the DrawingObject
		*/
		public function clearLines():void
		{
			this.removeChildAt(getLastChildIndex());
			getChildAt(getLastChildIndex()).addEventListener(Event.REMOVED,tracer);
		}
		
		/**
		* Sets up the delete and ctrl-s keys to delete the lines and save the drawing - respectively.
		* @param e KeyboardEvent
		*/
		public function clearDrawing(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACKSPACE || e.keyCode == Keyboard.DELETE) 
			{
				this.removeChildAt(getLastChildIndex());
				getChildAt(getLastChildIndex()).addEventListener(Event.REMOVED,tracer);
		
				spriteName = getLastChildIndex()+1;
				
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = int(mouseX*1000) * .001;
				cuePt.ypos = int(mouseY*1000) * .001;
				cuePt.fx = "delete";
				
				caller.addCuePoint(cuePt);
            }
			
			if(e.ctrlKey && e.keyCode == 83) //Ctrl-S
			{
				doSave(null);
			}
		}
		
		
		/**
		* Deletes all of the lines in the drawingObject
		*/
		public function clearAll():void
		{
			var i:int = 0;
			while(childArray.length > 0)
			{
				
				if(childArray[i] is Sprite)
				{
					removeChild(childArray[i]);
				}
				else
				{
					break;
				}
				i++
			}
		}
		
		/**
		* Sends the XMLObject to a new SaveXMLtoServer object that communicates with PHP to save an XML file to the server.
		* It then rewinds the video the beginning
		* @param e *
		*/
		public function doSave(e:*):void
		{
			var sXML:SaveXMLtoServer = new SaveXMLtoServer(xmlObj, "pixelmixer", "345xvc445", caller.name);
				caller.rewind();
		}
		
		/**
		* Traces out various event information.
		* @param e Event
		*/
		private function tracer(e:Event):void
		{
			//trace("Removed " + e.target.name);
		}
		
		/**
		* Incomplete --- originally intended to turn the drawing mode on and off.
		* @param e KeyboardEvent
		*/
		private function toggleDrawing(e:KeyboardEvent):void
		{
			//drawingObject.clearDrawing();
		}
		
		/**
		* setter that forces the drawingObject to update its time
		* @param time int
		*/
		public function setTime(time:int):void
		{
			this.time = time;
		}
		
		/**
		* Overrides the toString() method to show the name of the object instead of its intended string
		*/
		public override function toString () : String
		{
			return this.name;
		}
		
		/**
		* setter tells the drawingObject how to contact the FLVideoObject by setting its caller property
		* @param flvObj FLVideoObject
		*/
		public function setCallerID(flvObj:FLVideoObject):void
		{
			this.caller = flvObj;
		}
	}
}
