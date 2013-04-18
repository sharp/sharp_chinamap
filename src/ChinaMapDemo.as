package
{
	import event.MapEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	[SWF(width="600",height="500",frameRate="25",backgroundColor="#FFFFFF")]
	public class ChinaMapDemo extends Sprite
	{
		public function ChinaMapDemo()
		{
			super();
			var mapLoader:Loader = new Loader();
			mapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,init);
			mapLoader.load(new URLRequest("ChinaMap.swf"));
			addChild(mapLoader);
		}
		
		private function init(e:Event):void {
			e.currentTarget.content.loaderInfo.parameters.title = "中国地图";
			var demoMap:ChinaMap = e.currentTarget.content as ChinaMap;
			demoMap.addEventListener(MapEvent.ITEMCLICK,clickHandler);
		}
		
		private function clickHandler(e:MapEvent):void {
			trace(e.value);
		}
		
	}
}