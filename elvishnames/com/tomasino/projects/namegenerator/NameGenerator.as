package com.tomasino.projects.namegenerator
{
	import com.tomasino.utils.ButtonHelper;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	
	import com.tomasino.xml.XMLLoader;
	import com.tomasino.logging.Logger;
	import com.tomasino.utils.QueryString;
	
	public class NameGenerator extends Sprite
	{
		private static const DEFAULT_XML:String = 'elvishnamedata.xml';
		private var _xmlLoader:XMLLoader;
		private var _xml:XML;
		private var _filters:Array = new Array();
		private var _lists:Array = new Array();
	
		public var r1:RadioButton;
		public var r2:RadioButton;
		public var btn:MovieClip;
		public var charName:TextField;
		public var charDesc:TextField;
		private var rbg:RadioButtonGroup;
		
		private var _log:Logger = new Logger (this);
		
		public function NameGenerator ():void
		{
			_log.info ('Load NameGenerator Data');
			
			var dataURL:String = this.stage.loaderInfo.parameters['namedata'] || DEFAULT_XML;
			dataURL = QueryString.params['namedata'] || dataURL;
			
			_xmlLoader = new XMLLoader (dataURL);
			_xmlLoader.addEventListener (Event.COMPLETE, onXML);
		}
		
		private function onXML(e:Event):void 
		{
			_xml = _xmlLoader.xml;
			var listsXML:XMLList = _xml.list;
			var filtersXML:XMLList = _xml.pattern;
			
			for (var i:int = 0; i < listsXML.length(); ++i)
			{
				var listData:XML = listsXML[i];
				_lists.push ( new List ( listData ) );
			}

			for (i = 0; i < filtersXML.length(); ++i)
			{
				var filterString:String = filtersXML[i].@string;
				if (filterString) _filters.push ( new Filter (filterString) );
			}
			
			rbg = new RadioButtonGroup ('RadioButtonGroup');
			r1.group = rbg;
			r2.group = rbg;
			btn.addEventListener (MouseEvent.CLICK, onClick);
			ButtonHelper.MakeButton (btn);
			onClick (null);
		}
		
		function onClick ( e:MouseEvent ):void
		{
			
			var gender:String = (rbg.selection.label == 'Male') ? 'm' : 'f';
			var rnd:int = Math.floor ( Math.random () * _filters.length);
			var rndFilter:Filter = _filters [rnd];
			var result:FilterResults = rndFilter.apply ( _lists, gender);
			
			
			charName.text = result.name;
			charDesc.text = result.meaning.join (', ').toString();
			
		}
	}
}