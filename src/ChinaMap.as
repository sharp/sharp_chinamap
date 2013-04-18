package {
	import event.MapEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	[SWF(width="600",height="500",frameRate="25",backgroundColor="#FFFFFF")]
	
	public class ChinaMap extends Sprite {
		
		private var mapConfig:Object;
		private var mapBackGroud:MapBackgound;
		private var mapArea:MapArea;
		private var mapXML:XMLList;
		private var mapTip:MapTip;
		private var tipShandow:Sprite;
		private var wrapperFunction:String;
		
		public function ChinaMap(){
			mapConfig = new Object();
			mapConfig.title = loaderInfo.parameters.title;
			wrapperFunction = loaderInfo.parameters.jsHandler;
			/*UI*/
			var mapLoading:MapLoading = new MapLoading();
			addChild(mapLoading);
			var xmlLoader:URLLoader = new URLLoader();
			var xmlAdress:String = (loaderInfo.parameters.xmlurl != null)?loaderInfo.parameters.xmlurl:"data/d.xml";
			xmlLoader.addEventListener(Event.COMPLETE,function(e:Event):void{
				mapXML = new XML(e.target.data).area;
				removeChild(mapLoading);
				drawUI();
			});
			xmlLoader.load(new URLRequest(xmlAdress));
		}
		
		private function drawUI():void {
			mapBackGroud = new MapBackgound();
			mapBackGroud.title = (mapConfig.title == null)?"所有学校列表":mapConfig.title;
			addChild(mapBackGroud);
			mapArea = new MapArea();
			mapArea.x  = mapArea.y = 20;
			addChild(mapArea);
			stopAll(mapArea.map);
			registAction(mapArea.map);
			tipShandow = new Sprite();
			addChild(tipShandow);
			mapTip = new MapTip();
			addChild(mapTip);
			mapTip.visible = false;
		}
		
		private function registAction(c:DisplayObjectContainer):void {
			var me:DisplayObject;
			for(var i:uint = 0; i<c.numChildren; i++) {
				me = c.getChildAt(i);
				if(me is MovieClip && me.name != "bg") {
					me.alpha = 0.5;
					f:for each(var node:XML in mapXML){
						if(node.@id == me.name) {
							me.alpha = 1;
							(me as MovieClip).title = node.@title;
							(me as MovieClip).value = node.@value;
							(me as MovieClip).navUrl = node.@url;
							(me as MovieClip).navTarget = node.@target;
							(me as MovieClip).buttonMode = true;
							(me as MovieClip).addEventListener(MouseEvent.MOUSE_OVER,mapOverHandler);
							(me as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,mapOutHandler);
							(me as MovieClip).addEventListener(MouseEvent.CLICK,mapClipHandler);
							break f;
						}
					}
				}
			}
			function mapOverHandler(e:MouseEvent):void {
				(e.currentTarget as MovieClip).gotoAndStop(2);
				showTip((e.currentTarget as MovieClip),(e.currentTarget as MovieClip).value);
			}
			function mapOutHandler(e:MouseEvent):void {
				(e.currentTarget as MovieClip).gotoAndStop(1);
				if(mouseX < mapTip.x || mouseX > (mapTip.x+mapTip.width) || mouseY < mapTip.y || mouseY > (mapTip.y+mapTip.height)) {
					hideTip();
				}
			}
			function mapClipHandler(e:MouseEvent):void {
				var me:MovieClip = e.currentTarget as MovieClip;
				if(me.navUrl != null) {
					navigateToURL(new URLRequest(me.navUrl),me.navTarget);
				}
				var clickEvent:MapEvent = new MapEvent(MapEvent.ITEMCLICK,true,true);
				clickEvent.value = me.name;
				dispatchEvent(clickEvent);
				if (ExternalInterface.available) {
					try {
						var t:Object = new Object();
						t.value = me.name;
						ExternalInterface.call(wrapperFunction,t);
					} catch(err:Error) {
						trace(err);
					}
				}
			}
		}
		
		private function showTip(mc:MovieClip,t:String):void {
			mapTip.addEventListener(Event.ENTER_FRAME,moveTip);
			mapTip.visible = true;
			mapTip.t.htmlText = t;
		}
		private function hideTip():void {
			mapTip.visible=false;
			mapTip.t.text="";
			mapTip.removeEventListener(Event.ENTER_FRAME,moveTip);
		}
		
		private function moveTip(e:Event):void {
			e.currentTarget.x = mouseX+10;
			e.currentTarget.y = mouseY+10;
			if((e.currentTarget.x+e.currentTarget.width) > stage.stageWidth) {
				e.currentTarget.x = stage.stageWidth - e.currentTarget.width;
			}
		}
		
		private function stopAll(c:DisplayObjectContainer):void {
			var me:DisplayObject;
			for(var i:uint = 0; i<c.numChildren; i++) {
				me = c.getChildAt(i);
				if(me is MovieClip) {
					(me as MovieClip).stop();
				}
			}
		}
	}
}
