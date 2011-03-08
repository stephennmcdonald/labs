package
{
	import com.tomasino.utils.ButtonHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.tomasino.xml.XMLLoader;
	import com.tomasino.display.ScrollWheelWindow;
	import com.greensock.TweenLite;
	
	public class Status extends Sprite
	{
		private var _xmlLoader:XMLLoader;
		private var _days:Sprite = new Sprite();
		private var _daysArray:Array = [];
		
		public function Status ()
		{
			addChild(_days);
			_days.x = 50;
			_days.y = 50;
			
			addEventListener (Event.ADDED_TO_STAGE, onAdd);
			var rndSeed:Number = Math.floor(Math.random() * 10000000);
			var url:String = 'status.xml?rnd=' + rndSeed;
			_xmlLoader = new XMLLoader(url);
			_xmlLoader.addEventListener ( Event.COMPLETE, onXML );
			
			var scrollWindow:ScrollWheelWindow = new ScrollWheelWindow (this, 20);
		}
		
		private function onAdd ( event:Event ):void
		{
			this.stage.align = "T";
			
			removeEventListener (Event.ADDED_TO_STAGE, onAdd);
			addEventListener (Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onRemove ( event:Event ):void
		{
			addEventListener (Event.ADDED_TO_STAGE, onAdd);
			removeEventListener (Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onXML( event:Event = null ):void
		{
			var days:XMLList = _xmlLoader.xml.date;
			var t:Date = new Date();
			var today:Date = new Date (t.fullYear, t.month, t.date); // get today at midnight
			
			for (var i:int = 0; i < days.length(); ++i)
			{
				var date:Date = new Date ( int(days[i].@year), (int(days[i].@month) - 1), int(days[i].@day) );
				if (date)
				{
					_daysArray.push (days[i]);
				}
			}
			
			drawDays ();
		}
		
		private function drawDays ():void
		{
			var startDate:XML = _daysArray[0];
			var date:Date = new Date ( int(startDate.@year), (int(startDate.@month) - 1), int(startDate.@day) );
			var dayOfWeek:int = date.getDay();
			
			for (var k:int = 0; k < dayOfWeek; ++k)
			{
				_daysArray.unshift(null);
			}
			
			for (var j:int = 0; j < _daysArray.length / 7; ++j)
			{
				var daysInWeek:int = _daysArray.length - (j * 7);

				for (var i:int = 0; i < 7; ++i)
				{
					var day:XML = _daysArray[i + (j * 7)];
					if (day)
					{
						var d:Day = new Day(day);
					}
					else
					{
						d = new Day(null)
					}
					
					_days.addChild(d);
					_days.addEventListener (BoxEvent.ROLL_OVER, onRoll);
					_days.addEventListener (BoxEvent.ROLL_OUT, onOut);
					_days.addEventListener (BoxEvent.CLICK, onClick);
					d.x = 100 * i;
					d.y = 160 * j;
				}
			}
		}
		
		private function onRoll ( event:BoxEvent ):void
		{
			var item:BoxItem = event.box as BoxItem;
			for (var i:int = 0; i < _days.numChildren; ++i)
			{
				Day(_days.getChildAt(i)).activate(item.desc);
			}
		}
		
		private function onOut ( event:BoxEvent ):void
		{
			var item:BoxItem = event.box as BoxItem;
			for (var i:int = 0; i < _days.numChildren; ++i)
			{
				Day(_days.getChildAt(i)).activate('');
			}
		}
		
		private function onClick ( event:BoxEvent ):void
		{
		}
		
		private function removeAllChildren ( container:DisplayObjectContainer ):void
		{
			for (var i:int = 0; i < container.numChildren; ++i)
			{
				var disp:DisplayObject = container.removeChildAt(0) as DisplayObject;
				if (disp is DisplayObjectContainer) removeAllChildren( DisplayObjectContainer(disp) );
				disp = null;
			}
		}
	}
}