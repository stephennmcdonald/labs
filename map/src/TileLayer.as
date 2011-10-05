package 
{
	
	import com.google.maps.TileLayerBase;
	import com.google.maps.interfaces.ICopyrightCollection;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	public class TileLayer extends TileLayerBase
	{
		private var urlBase:String = new String();
		public function TileLayer(urlBase:String,copyRightCollection:ICopyrightCollection, minZoom:Number=0, maxZoom:Number=0)
		{
			this.urlBase = urlBase;
			super(copyRightCollection, minZoom, maxZoom);
		}
		
		public override function loadTile(tilePos:Point, zoom:Number):DisplayObject
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			var tileURL:String = this.urlBase + 'z' + zoom + 'y' + tilePos.y + 'x' + tilePos.x + '.png';
			loader.load(new URLRequest(tileURL));
			return loader;
		}

		private function onError(event:IOErrorEvent):void { }
	}
}