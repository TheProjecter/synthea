/**
 * ...
 * @author Dustin Sparks
 * @version 0.11
 */

package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	import fl.video.*;

    public class GrabXML extends Sprite {
		private var url:String;
		private var data:Object;
		private var flvObj:FLVideoObject;
		private var fl:FLVPlayback;
		
        public function GrabXML(url:String, flvObj:FLVideoObject, fl:FLVPlayback) {
            var loader:URLLoader = new URLLoader();
			this.url = url;
			this.flvObj = flvObj;
			this.fl = fl;
			
            configureListeners(loader);

            var request:URLRequest = new URLRequest(url);
            
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            trace("Loading XML Complete");
			this.data = loader.data;
			
			var xp:XMLPlayback = new XMLPlayback(data, flvObj, fl);
			
			flvObj.playWhenReady();
        }
		
		public function getData():Object
		{
			return data;
		}

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }


        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
    }
}