package event
{
	import flash.events.Event;

	public class MapEvent extends Event
	{
		public static var ITEMCLICK:String = "itemClick";
		
		public var value:String;
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}