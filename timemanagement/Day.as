package
{
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Day extends Sprite
	{
		
		private var _boxMatrix:Array = [[ 0, 1, 14, 15, 16, 19, 20, 21 ],
									   [ 3, 2, 13, 12, 17, 18, 23, 22 ],
									   [ 4, 7, 8, 11, 30, 29, 24, 25 ],
									   [ 5, 6, 9, 10, 31, 28, 27, 26 ],
									   [ 58, 57, 54, 53, 32, 35, 36, 37 ],
									   [ 59, 56, 55, 52, 33, 34, 39, 38 ],
									   [ 60, 61, 50, 51, 46, 45, 40, 41 ],
									   [ 63, 62, 49, 48, 47, 44, 43, 42 ]];
		
		private var _isEnabled:Boolean = true;
		private var _normalColor:Number = 0x333333;
		private var _afterHoursColor:Number = 0x111111;
		
		private var _numArray:Array = [];		
		private var _bg:Sprite = new Sprite();
		private var _dict:Dictionary = new Dictionary (true);
		private var _xml:XML;
		private var _dateText:String;
		private var _dateDisplay:DateDisplay = new DateDisplay();
		
		public function Day (xml:XML = null)
		{
			_xml = xml;
			
			drawBox();
			
			if (!_xml)
			{
				_normalColor = 0x111111;
				_isEnabled = false;
			}
			else
			{
				drawDate ();
				highlightBox();
			}
			
			addChild(_bg);
			_bg.y = 55;
		}
		
		private function drawDate ():void
		{
			var date:Date = new Date ( int(_xml.@year), (int(_xml.@month) - 1), int(_xml.@day) );
			var display:String;
			switch (date.getDay())
			{
				case 0:
					display = 'Sunday \n';
					break;
				case 1:
					display = 'Monday \n';
					break;
				case 2:
					display = 'Tuesday \n';
					break;
				case 3:
					display = 'Wednesday \n';
					break;
				case 4:
					display = 'Thursday \n';
					break;
				case 5:
					display = 'Friday \n';
					break;
				case 6:
					display = 'Saturday \n';
					break;
			}
			_dateText = display + (date.month + 1) + '/' + date.date + '/' + date.fullYear;
			_dateDisplay.txt.text = _dateText;
			addChild(_dateDisplay);
		}
		
		public function drawBox ():void
		{
			for (var i:int = 0; i < _boxMatrix.length; ++i)
			{
				for (var j:int = 0; j < _boxMatrix.length; ++j)
				{
					var box:Sprite = new Sprite();
					var index:int = 8 * j + i;
					
					box.graphics.lineStyle(1,0x000000,0);
					
					if (_boxMatrix[i][j] > 39)
					{
						box.graphics.beginFill(_afterHoursColor, 1);
					}
					else
					{
						box.graphics.beginFill(_normalColor,1);
					}
					box.graphics.drawRect(0,0,10,10);
					box.graphics.endFill();
					box.x = i * 11;
					box.y = j * 11;
					_bg.addChild(box);
					
					if (_isEnabled)
					{
						_numArray[_boxMatrix[i][j]] = new BoxItem ( box, new Point(i,j) );
						_dict[box] = _numArray[_boxMatrix[i][j]];
					}
				}
			}
		}
		
		private function highlightBox ():void
		{
			var jobs:XMLList = _xml.job;
			var iterate:int = 0;
			if (jobs.length())
			{
				for (var i:int = 0; i < jobs.length(); ++i)
				{
					var startJ:int = iterate;
					var units:String = jobs[i].@units;
					iterate += int(units);
					
					for (var j:int = startJ; j < iterate; ++j)
					{
						if (j < _numArray.length)
						{
							var box:BoxItem = _numArray[j] as BoxItem;
							box.desc = jobs[i].@label;
							box.color = Number(jobs[i].@color);
						
							box.box.addEventListener(MouseEvent.CLICK, onClick);
							box.box.addEventListener(MouseEvent.ROLL_OVER, onOver);
							box.box.addEventListener(MouseEvent.ROLL_OUT, onOut);
						}
					}
					activate ('');
				}
			}
		}
		
		public function activate ( str:String ):void
		{
			for (var i:int = 0; i < _numArray.length; ++i)
			{
				_numArray[i].activate (str);
			}
			
		}
		
		private function changeTitle ( str:String ):void
		{
			if (str)
			{
				_dateDisplay.txt.text = _dateText + '\n' + str;
			}
			else
			{
				_dateDisplay.txt.text = _dateText;
			}
		}
		
		private function onClick ( event:MouseEvent):void
		{
			var item:BoxItem = _dict[event.target] as BoxItem;
			var be:BoxEvent = new BoxEvent (BoxEvent.CLICK);
			be.box = item;
			dispatchEvent (be);
		}
		
		private function onOver ( event:MouseEvent):void
		{
			var item:BoxItem = _dict[event.target] as BoxItem;
			var be:BoxEvent = new BoxEvent (BoxEvent.ROLL_OVER);
			be.box = item;
			dispatchEvent (be);
			changeTitle (item.desc);
		}
		
		private function onOut ( event:MouseEvent):void
		{
			var item:BoxItem = _dict[event.target] as BoxItem;
			var be:BoxEvent = new BoxEvent (BoxEvent.ROLL_OUT);
			be.box = item;
			dispatchEvent (be);
			changeTitle ('');
		}
	}
}