﻿package {	import com.sickworks.components.DateChooser;	import org.tomasino.encoding.VIC;	import flash.events.Event;	import flash.display.Sprite;	public class VICEncoder extends Sprite	{		public var vic:VIC = new VIC ();		public var dc:DateChooser;				private var _standardRegExp:RegExp = /[^A-Za-z0-9]/g;		private var _messageRegExp:RegExp = /[^A-Za-z0-9\.]/g;				private var _date:Date = new Date(1752, 8, 3);		private var _msg:String;		private var _s:String;		private var _mi:String;		private var _pid:String;				private function update():void		{			var encode:String = vic.encode(_s, _mi, _date, _pid, _msg);			code.text = encode;		}		public function VICEncoder()		{			song.addEventListener(Event.CHANGE, validate);			rawMessage.addEventListener(Event.CHANGE, validate);			MI.addEventListener(Event.CHANGE, validate);			personalID.addEventListener(Event.CHANGE, validate);						MI.restrict = "0-9";			personalID.restrict = "0-9";			MI.maxChars = 5;			personalID.maxChars = 2;			dc = new DateChooser(false, 9, 1752);			dc.allowMultiple = false;			dc.y = 150; dc.x = 26;			dc.setCellSize(34, 20);			dc.headerHeight = 30;			dc.setBackgroundColors([14870251, 16777215]);			dc.gradientOffset = 35;			dc.cellColor = 14870251;			dc.highlightColor = 10079487;			dc.selectedColor = 10066329;			dc.todayColor = 14870251;			dc.setBorderStyle(1, 13421772);			dc.selectedDates = new Array (_date);			addChild(dc);						dc.addEventListener( DateChooser.SELECTION_CHANGED, onDate );			validate();		}				private function onDate (e:Event = null):void		{			var dates:Array = dc.selectedDates;			_date = dates[0] as Date;						validate();		}		public function validate(e:Event = null):void		{			var valid:Boolean = true;			valid &&= validateSong();			valid &&= validateMessage();			valid &&= validateMI();			valid &&= validatePersonalID();			valid &&= validateDate();						if (valid) update();		}				private function validateSong ():Boolean		{			_s = song.text;			_s = _s.replace(_standardRegExp,'');			if (_s.length >= 20) return true;			else return false;		}				private function validateMessage ():Boolean		{			_msg = rawMessage.text;			_msg = _msg.replace(_messageRegExp, '');			if (_msg.length) return true;			else return false;		}				private function validateMI ():Boolean		{			_mi = MI.text;			if (_mi.length != 5) return false;			else return true;		}				private function validatePersonalID ():Boolean		{			_pid = personalID.text;			if (int(_pid) < 0) 			{				personalID.text = '0';				return false;			}			if (int(_pid) > 16)			{				personalID.text = '16';				return false;			}						return true;		}				private function validateDate ():Boolean		{			if (_date) return true;			else return false;		}	}}