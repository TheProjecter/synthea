/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */

package {
	import fl.video.FLVPlayback;
	
	public class XMLPlayback {
		private var data:Object;
		private var flvObj:FLVideoObject;
		private var fl:FLVPlayback;
		private var cuePt:Object = new Object();
		private var xml:XML;
		
		public function XMLPlayback(data:Object, flvObj:FLVideoObject, fl:FLVPlayback)
		{
			this.data = XML(data);
			this.flvObj = flvObj;
			this.fl = fl;
			
			xmlToCuePoints();
		}
		
		public function xmlToCuePoints():void
		{
			var segments:int = getNumberOfSegments();
			
			var points:int;
			for(var i:int = 0; i < segments; i++)
			{
				points += getNumberOfPointsAt(i);
				for(var j:int = 0; j < getNumberOfPointsAt(i); j++)
				{
					if(getPointAt(i,j).@id == 0)
					{
						setFunctionType(i,j,"begin");
						//trace(getPointAt(i,j).toXMLString());
					}
					else if(getPointAt(i,j).@id == getNumberOfPointsAt(i)-1)
					{
						setFunctionType(i,j,"end");
						//trace(getPointAt(i,j).toXMLString());
					}
					
					cuePt.time = getPointAt(i,j).@time;
					cuePt.name = "CP_" + cuePt.time;
					cuePt.type = "actionscript";
					cuePt.xpos = getPointAt(i,j).@x;
					cuePt.ypos = getPointAt(i,j).@y;
					cuePt.fx = getPointAt(i,j).@fx;
					addCuePoint();
				}
			}

			trace("Segments: "+ segments + " Points: " + points);
		}
		private function setFunctionType(i:int, j:int, fx:String):void
		{
			getPointAt(i,j).@fx = fx;
		}
			
		public function addCuePoint():void
		{
			flvObj.addCuePoint(cuePt);
		}
		
		private function getNumberOfPointsAt(i:int):int
		{
			return data.segment.(@id==i).point.length();
		}
		
		private function getPointAt(i:int, j:int):XML
		{
			return data.segment.(@id==i).point[j];
		}
		
		private function getNumberOfSegments():int
		{
			return data.segment.length();
		}
	}
	
}