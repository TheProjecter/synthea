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

    public class userList extends Sprite
    {
		public var users:Array;
		
        public function userList(username:String, password:String, video:String)
        {
            var request:URLRequest = new URLRequest("http://localhost/php_test/synthea_tests/userList.php?username="+ username +"&password="+ password +"&video="+ video);
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
			users = loader.data.users.split(",");
			
			getUsers();
        }
		
		public function getUsers():Array
		{
			//trace(users);
			return users;
		}
		
		public function getFileAt(num:int):String
		{
			//trace(users[num]);
			return users[num];
		}
	}
}

