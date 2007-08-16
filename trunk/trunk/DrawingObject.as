/**
* @author Dustin Sparks
* @version 0.1
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
	
	public class DrawingObject extends Sprite
	{
		private var spriteName:int = 0;
		private var obj:Object;
		private var s:Object;
		private var caller:FLVideoObject;
		private var xmlObj:XMLObject;
		public var time:Number = 0;
		private var cuePt:Object = new Object();
		
		public var color:uint = 0xff0000;
		
		private var i:int;

		public function DrawingObject (obj : Object, s:Object) : void
		{
			this.name = "DrawingObject1";
			this.obj = obj;
			
			this.xmlObj = new XMLObject(<drawing></drawing>);
			

				obj.addEventListener(MouseEvent.MOUSE_DOWN, createSprite);
				obj.addEventListener(MouseEvent.MOUSE_UP, removeSpriteListener);
				s.addEventListener(KeyboardEvent.KEY_UP, clearDrawing);

		}
		
		private function removeSpriteListener (event : MouseEvent) : void
		{
			obj.removeEventListener (MouseEvent.MOUSE_MOVE, drawInSprite);
			
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = Math.round(mouseX*1000) * .001;
				cuePt.ypos = Math.round(mouseY*1000) * .001;
				cuePt.fx = "end";
				
			caller.addCuePoint(cuePt);
		}
		
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
			//trace ("Sprite created... " + sprite.name);
			
			xmlObj.addSegment();
			
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = Math.round(mouseX*1000) * .001;
				cuePt.ypos = Math.round(mouseY*1000) * .001;
				cuePt.fx = "begin";
				
				caller.addCuePoint(cuePt);
		}
		
		public function autoDraw(fx:String, x:Number, y:Number, time:Number):void
		{
			//trace("fx:" + fx + " x:" + x + " y:" + y + " t:" + time);
			//trace(time);
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
				//trace("offset: "+caller.timeOffset + " time: " +getTimer() + " newTime:" + (getTimer()-caller.timeOffset));
				if(getChildren()[getLastChildIndex()])
				{
					
					//trace("this one worked..." +  + "  " + getLastChildIndex());

					var drawingSprite:Sprite = getChildren()[getLastChildIndex()];
					
					//trace(getChildren()[getLastChildIndex()]);
					
					drawingSprite.graphics.lineStyle (2, color);
					drawingSprite.graphics.lineTo (x, y);
				}
				else
				{
					trace("grr, something's wrong with this one. "+ i +" __  " + getChildren()[getNumberOfChildren].name + "  " + getLastChildIndex());
					i++
				}
			}
		}
		
		private function drawInSprite (event : MouseEvent) : void
		{
			var drawingSprite : Sprite = getChildren ()[getLastChildIndex ()];
			drawingSprite.graphics.lineStyle (2, color);
			drawingSprite.graphics.lineTo (Math.round(mouseX*1000) * .001, Math.round(mouseY*1000) * .001);

			 //create cue point object
				cuePt.time = (getTimer()-caller.timeOffset) * .001;
				cuePt.name = "CP_" + cuePt.time;
				cuePt.type = "actionscript";
				cuePt.xpos = Math.round(mouseX*1000) * .001;
				cuePt.ypos = Math.round(mouseY*1000) * .001;
				cuePt.fx = "null";
				//trace("xpos(after):",cuePt.xpos, " xpos(before):", mouseX);
				
			//caller.addCuePoint(cuePt);
			caller.addCuePoint(cuePt);
			
			xmlObj.addPoint(cuePt.time, Math.round(mouseX*1000) * .001, Math.round(mouseY*1000) * .001);
			
			//caller.getTime() + timeMod
			event.updateAfterEvent();
		}
		
		public function getNumberOfChildren() : int
		{
			return this.numChildren;
		}
		
		public function getLastChildIndex () : int
		{
			return this.numChildren -1;
		}
		
		public function getChildren() : Array
		{
			var childArray : Array = new Array ();
			var i : int;
			for (i = 0; i <= getLastChildIndex(); i ++)
			{
				childArray.push (this.getChildAt(i));
			}
			return childArray;
		}
		
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
				cuePt.xpos = Math.round(mouseX*1000) * .001;
				cuePt.ypos = Math.round(mouseY*1000) * .001;
				cuePt.fx = "delete";
				
				caller.addCuePoint(cuePt);
            }
			
			if(e.ctrlKey && e.keyCode == 83) //Ctrl-S
			{
				var sXML:SaveXMLtoServer = new SaveXMLtoServer(xmlObj, "pixelmixer", "345xvc445", caller.name);
				caller.rewind();
			}
		}
		
		private function tracer(e:Event):void
		{
			//trace("Removed " + e.target.name);
		}
		
		private function toggleDrawing(e:KeyboardEvent):void
		{
			//drawingObject.clearDrawing();
		}
		
		public function setTime(time:int):void
		{
			this.time = time;
			//trace(time);
		}
		
		public override function toString () : String
		{
			return this.name;
		}
		
		public function setCallerID(flvObj:FLVideoObject):void
		{
			this.caller = flvObj;
			//trace(caller);
		}
	}
}
