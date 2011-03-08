package
{
	import flash.geom.Point;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	public class BoxItem
	{
		public var box:Sprite;
		public var point:Point;
		public var desc:String;
		public var color:Number;
		
		public function BoxItem (b:Sprite, p:Point)
		{
			TweenPlugin.activate([ TintPlugin ]);
			
			box = b;
			point = p;
		}
		
		public function activate ( str:String )
		{
			if (!(isNaN(color)))
			{
				if (str == desc)
				{
					TweenLite.to (box, .25, {tint:0xFFFFFF});
				}
				else
				{
					TweenLite.to (box, .25, {tint:color});
				}
			}
			else
			{
				//TweenLite.to (box, .5, {removeTint:true} );
			}
		}
	}
}