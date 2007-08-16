/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */

package
{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;

    public class userFiles extends Sprite
    {
		public var files:Array;
		
        public function userFiles(username:String, password:String, video:String)
        {
            var request:URLRequest = new URLRequest("http://localhost/php_test/synthea_tests/userFiles.php?username="+ username +"&password="+ password +"&video="+ video);
			var variables:URLLoader = new URLLoader();
            variables.dataFormat = URLLoaderDataFormat.VARIABLES;
            variables.addEventListener(Event.COMPLETE, completeHandler);
            try
            {
                variables.load(request);
            } 
            catch (error:Error)
            {
                trace("Unable to load URL: " + error);
            }
        }
		
        private function completeHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);
			files = loader.data.files.split(",");
			
			getFiles();
        }
		
		public function getFiles():Array
		{
			//trace(files);
			return files;
		}
		
		public function getFileAt(num:int):String
		{
			//trace(files[num]);
			return files[num];
		}
	}
}

