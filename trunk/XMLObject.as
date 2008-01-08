/**
 * ...
 * @author Dustin Sparks
 * @version 0.11
 */

package {
	import flash.xml.*;
	
	public class XMLObject
	{
		private var xml:XML;
		
		//_________________________________________________________________________
		//												      C O N S T R U C T O R
		public function XMLObject(node:XML):void
		{
			this.xml = new XML(node);
		}
		
		//_________________________________________________________________________
		//																P O I N T S
		public function addPoint(time:Number, x:Number, y:Number, fx:String = ""):void
		{
			xml.segment.(@id == getNewestSegmentId()-1).
			appendChild(<point id={getSegmentNewestPointId()} time={time} x={x} y={y} fx={fx}/>);
		}
		
		public function addPointToNewestSegmentAt(id:int):void
		{
			xml.segment.(@id == getNewestSegmentId()-1).
			appendChild(<point id={id}/>);
		}
		
		public function addPointToSegmentAt(segmentId:int):void
		{
			xml.segment.(@id == segmentId).
			appendChild(<point id={getNewestPointIdAtSegment(segmentId)}/>);
		}
		
		private function getNewestPointIdAtSegment(id:int):int
		{
			return xml.segment.(@id == id).point.length();
		}
		
		private function getSegmentNewestPointId():int
		{
			return xml.segment.(@id == getNewestSegmentId()-1).point.length();
		}
		
		//_________________________________________________________________________
		//															S E G M E N T S
		public function addSegment():void
		{
			xml.appendChild(<segment id={getNewestSegmentId()}></segment>);
		}
		
		private function getNewestSegmentId():int
		{
			return xml.segment.length();
		}
		
		//_________________________________________________________________________
		//												   D I R E C T  A C C E S S
		public function getXMLObject():XML
		{
			return xml;
		}
		
		public function toString():String
		{
			return xml.toXMLString();
		}
	}
}