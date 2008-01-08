/**
 * ...
 * @author Dustin Sparks
 * @version 0.11
 */

package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;

    public class SaveXMLtoServer extends Sprite {
		private var loader:URLLoader;
		private var xml:XML;
		private var variables:URLVariables;
		private var request:URLRequest;
		private var url:String;
		
        public function SaveXMLtoServer(xml:XMLObject, username:String, password:String, name:String) {
            this.loader = new URLLoader();
			this.xml = new XML(xml.getXMLObject());
			this.url = "saveXMLtoServer.php";
			
			this.variables = new URLVariables();
            variables.username = username;
            variables.password = password;
			variables.name = name;
			variables.xml = xml;
			
            this.request = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			configureListeners(loader);
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            //trace("completeHandler: " + loader.data);
    
            var vars:URLVariables = new URLVariables(loader.data);
            //trace("The answer is " + vars.answer);
        }

        private function openHandler(event:Event):void {
            //trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
           // trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            //trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            //trace("ioErrorHandler: " + event);
        }
    }
}
