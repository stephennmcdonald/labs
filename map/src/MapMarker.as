package
{
	import com.google.maps.LatLng;
	import com.google.maps.MapOptions;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.styles.StrokeStyle;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	public class MapMarker extends Marker
	{
		public var id:String = '';
		public var iconURL:String = '';
		public var labelFormat:TextFormat;
		public var options:MarkerOptions;
		
		public function MapMarker ( id:String, latLng:LatLng, markerOptions:MarkerOptions=null )
		{
			this.id = id;
			
			if (!markerOptions) 
			{
				labelFormat = new TextFormat();
				labelFormat.font = "Arial";
				labelFormat.size = 14;
				labelFormat.color = 0xFFFFFF;
				labelFormat.bold = true;
				
				markerOptions = new MarkerOptions();
				markerOptions.label = id;
				markerOptions.labelFormat = labelFormat;
				//markerOptions.icon = new MarkerCircle();
				markerOptions.iconAlignment = MarkerOptions.ALIGN_BOTTOM + MarkerOptions.ALIGN_HORIZONTAL_CENTER;
			}
			
			options = markerOptions;

			super(latLng, markerOptions);
		}
		
		public function setIcon ( iconURL:String ):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.load( new URLRequest( iconURL ) );

			options.icon = loader;
			options.hasShadow = true;
			options.iconAlignment = MarkerOptions.ALIGN_BOTTOM + MarkerOptions.ALIGN_HORIZONTAL_CENTER;
			options.strokeStyle = new StrokeStyle ();
			setOptions( options );
			iconURL = iconURL;
		}
		
		public function setDraggable( isDraggable:Boolean ):void
		{
			options.draggable = isDraggable;
			this.setOptions( options );
		}
		
		private function onIOError ( e:IOErrorEvent ):void {}
	}
}
import flash.display.Sprite;

internal class MarkerCircle extends Sprite
{
	public function MarkerCircle ():void
	{
		this.graphics.beginFill(0);
		this.graphics.drawCircle(0,0,5);
		this.graphics.endFill();
	}
}