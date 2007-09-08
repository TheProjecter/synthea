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

    public class userVideos extends Sprite
    {
		public var videos:Array;
		
        public function userVideos(username:String, password:String, video:String)
        {
            var request:URLRequest = new URLRequest("userVideos.php?username="+ username +"&password="+ password +"&video="+ video);
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
			videos = loader.data.videos.split(",");
			
			getVideos();
        }
		
		public function getVideos():Array
		{
			//trace(files);
			return videos;
		}
		
		public function getVideoAt(num:int):String
		{
			//trace(files[num]);
			return videos[num];
		}
	}
}

