package com.leiner.calendar.calendar
{
	import com.leiner.events.EventsManager;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author ...Carl E. Leiner
	 */
	public class HeaderButtons extends Sprite
	{
		private var mgr:EventsManager;
		private var app:String = getQualifiedClassName(this) + Math.random() * 2000;;

		private var prevMonth:Sprite;
		private var nextMonth:Sprite;
		private var format:TextFormat;
		private var _date:Date;
		private var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]			;
		private var txtYear:TextField;
		private var txtMonth:TextField;
		private var caption:Sprite;
		
		public function HeaderButtons():void 
		{
			if (stage) init()
			else addEventListener(Event.ADDED_TO_STAGE,init)
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init)
			mgr = EventsManager.getInstance()
			mgr.add([app], this, Event.REMOVED_FROM_STAGE, cleanup);
			format = Calendar.headerFormat;
			format.leftMargin = format.rightMargin = 5;
			format.align = 'center';
			drawBack();
			drawMonthButtons();
			addChild(caption = new Sprite());
			drawYearCaption();
			drawMonthCaption();
		}
		
		private function drawBack():void
		{
			with (graphics)
			{
				clear();
				beginFill(0, 0);
				drawRect(0, 0,((Calendar.cellWidth+Calendar.cellPadding)*6)-Calendar.cellPadding, Calendar.headerHeight);
				endFill();
			}
		}
		
		private function drawMonthCaption():void
		{
			caption.addChildAt(txtMonth = new TextField(),0)
			with (txtMonth)
			{   
				autoSize = TextFieldAutoSize.RIGHT;
				format.align = 'right';
				defaultTextFormat = format;
				format.align = 'left';
				height = txtYear.height;
				mouseEnabled = false;
			}
		}
		
		private function drawYearCaption():void
		{
			caption.addChildAt(txtYear = new TextField(),0)
			with (txtYear)
			{   
				format.align = 'left';
				boarderColor = 0x666666
				backgroundColor = 0xffffff;
				autoSize = TextFieldAutoSize.LEFT;
				defaultTextFormat = format;
				text = '9999';
				width = txtYear.textWidth+4;
				height = format.size + 6;
				
				type = 'input';
				autoSize = TextFieldAutoSize.NONE;
				restrict = '0-9';
				text = '';
			}
			mgr.add([app],txtYear, FocusEvent.FOCUS_IN, yearFocusIn);
			mgr.add([app],txtYear, FocusEvent.FOCUS_OUT, yearFocusOut);
			mgr.add([app], txtYear, KeyboardEvent.KEY_DOWN, yearEnterAction);
			mgr.add([app],txtYear, Event.CHANGE, dummy);
			yearFocusOut(null);
		}
		//keeps keyboardEvent from propogating  change event to calendar 
		private function dummy(e:Event):void 
		{	e.stopImmediatePropagation();		}
		
		private function yearEnterAction(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if (e.keyCode == 13) 
			{ 
				date = new Date(int(txtYear.text), _date.month, 1)
				dispatchEvent(new Event(Event.CHANGE))
			}
		}
		
		private function yearFocusOut(e:FocusEvent):void
		{
			try{trace(e.type)}catch(e){}
			txtYear.border = false;
			txtYear.background = false;
			txtYear.defaultTextFormat = format;
			txtYear.text = txtYear.text;
		}
		
		private function yearFocusIn(e:FocusEvent):void
		{
			txtYear.border = true;
			txtYear.background = true;
			txtYear.textColor = 0;
		}
		
		private function paintMonthButton(button:*):void					
		{
			var matrix=new Matrix()
			with(button.graphics)
			{
				clear();
				lineStyle(1, Calendar.headerButtonOutlineColor,Calendar.headerButtonOutlineAlpha,true);
				matrix.createGradientBox(Calendar.headerButtonSize, Calendar.headerButtonSize, Math.PI * (90) / 180);
				beginGradientFill(GradientType.LINEAR, Calendar.headerButtonColors, Calendar.headerButtonAlphas, [0, 255], matrix, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB, 0);
				drawRoundRect(0, 0, Calendar.headerButtonSize, Calendar.headerButtonSize, 7);
				lineStyle();
				beginFill(Calendar.triangleColor,Calendar.triangleAlpha);
				switch(button)
				{
					case prevMonth:
						moveTo(Math.ceil(Calendar.headerButtonSize * .6), Math.ceil(Calendar.headerButtonSize * .25));
						lineTo(Math.ceil(Calendar.headerButtonSize * .3), Math.ceil(Calendar.headerButtonSize *.5));
						lineTo(Math.ceil(Calendar.headerButtonSize * .6), Math.ceil(Calendar.headerButtonSize * .75));
						lineTo(Math.ceil(Calendar.headerButtonSize * .6), Math.ceil(Calendar.headerButtonSize * .25));			
					break;
					case nextMonth:
						moveTo(Math.ceil(Calendar.headerButtonSize * .4), Math.ceil(Calendar.headerButtonSize * .25));
						lineTo(Math.ceil(Calendar.headerButtonSize * .7), Math.ceil(Calendar.headerButtonSize *.5));
						lineTo(Math.ceil(Calendar.headerButtonSize * .4), Math.ceil(Calendar.headerButtonSize * .75));
						lineTo(Math.ceil(Calendar.headerButtonSize * .4), Math.ceil(Calendar.headerButtonSize * .25));
					break
				}
				endFill();
			}
		}				
		
		private function drawMonthButtons():void 
		{
			addChild(prevMonth=new Sprite())
			paintMonthButton(prevMonth);
			prevMonth.name = 'prev';
			prevMonth.alpha = .8;
			prevMonth.mouseChildren = false;
			mgr.registerButton(prevMonth, [app], { click:prevNext, over:ourNout, out:ourNout} );
			addChild(nextMonth=new Sprite())
			paintMonthButton(nextMonth);
			nextMonth.name = 'next';
			nextMonth.alpha = .8;
			nextMonth.mouseChildren = false;
			mgr.registerButton(nextMonth, [app], { click:prevNext, over:ourNout, out:ourNout} );
			
			prevMonth.x =2
			nextMonth.x = (Calendar.cellWidth + Calendar.cellPadding) * 7 - Calendar.headerButtonSize - Calendar.cellPadding - 2;// 15  
			prevMonth.y = nextMonth.y = Calendar.headerHeight - Calendar.headerButtonSize >> 1;
		} 
		
		private function ourNout(e:MouseEvent):void
		{	e.target.alpha = e.type == 'mouseOver'?1:.8;	}

		private function prevNext(e:MouseEvent):void
		{
			if (!_date) return;
			var tmp:Date = new Date(_date.fullYear, _date.month, 1)
			if (e.ctrlKey && e.altKey)
			tmp=new Date()
			else if (e.ctrlKey)
			e.target.name == 'prev'?tmp.fullYear -= 1:tmp.fullYear += 1
			else
			e.target.name == 'prev'?tmp.month -= 1:tmp.month += 1
			
			date = tmp;
			dispatchEvent(new Event(Event.CHANGE))
		}
		
		//public function get label():String { return txt.text; }
		//public function set label(value):void	{	txt.text = value;	}
		
		public function get date():Date { return _date; }
		public function set date(value:Date):void 
		{	
			_date = value;
			var m = months[_date.month];
			m= (Calendar.headerMonthDisplayMode == -1)?m:(Calendar.headerMonthDisplayMode == 3)?m.substr(0, 3):m.charAt(0);
			var yr = _date.fullYear.toString();
			yr = (Calendar.headerYearDisplayMode == -1)?yr:yr.substr(2);

//			txt.text = m + ' ' + yr;
			txtMonth.text = m;
			txtMonth.x = 0;
			txtYear.text = yr;
			txtYear.x = txtMonth.width;
			caption.x = this.width - caption.width >> 1;
			caption.y = Calendar.headerHeight-txtYear.height>>1;
		}
		
		private function cleanup(e:Event):void 
		{	mgr.removeGroup(app);		}
	}
}