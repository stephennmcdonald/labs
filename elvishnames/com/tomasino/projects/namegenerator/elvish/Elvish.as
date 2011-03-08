package com.tomasino.projects.namegenerator.elvish
{
	import com.tomasino.projects.namegenerator.NameData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	//http://www.angelfire.com/rpg2/vortexshadow/names.html
	public class Elvish extends EventDispatcher
	{
		private var elvishNames:ElvishNameData = new ElvishNameData();
		private var gender:int;
		private var _textField:TextField;
		
		public function Elvish (textField:TextField, iterations:int):void
		{
			_textField = textField;
			for (var i:int = 0; i < iterations; ++i)
			{
				generateName ();
			}
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		private function generateName ( event:Event = null ):void
		{
			gender = Math.floor ( Math.random() * 2);
			
			var output:String;
			var desc:String = '';
			
			var rollMethod:int = Math.ceil ( Math.random() * 10);
			
			var t1:NameData;
			var t2:NameData;
			var t3:NameData;
			var t4:NameData;
			var t5:NameData;
			
			switch (rollMethod)
			{
				case 1:
				case 2:
				case 3:
				case 4:
					// Roll once on Table 2 and once on Table 3
					t1 = elvishNames.getPrefix(gender);
					t2 = elvishNames.getSuffix(gender);
					output = capitalize (combineStrings (t1.name, t2.name));
					desc = '(' + t1.meaning.join (', ') + ', ' + t2.meaning.join (', ') + ')';
					break;
				case 5:
				case 6:
				case 7:
					// Roll once on Table 2 and twice on Table 3
					t1 = elvishNames.getPrefix(gender);
					t2 = elvishNames.getSuffix(gender);
					t3 = elvishNames.getSuffix(gender);
					output = capitalize (combineStrings (t1.name, t2.name, t3.name));
					desc = '(' + t1.meaning.join (', ') + ', ' + t2.meaning.join (', ') + ', ' + t3.meaning.join (', ') + ')';
					break;
				case 8:
				case 9:
					// Roll once on Table 2 and once on Table 3 for a first name, then once on Table 2 and twice on Table 3 for a second name
					t1 = elvishNames.getPrefix(gender);
					t2 = elvishNames.getSuffix(gender);
					t3 = elvishNames.getPrefix(gender);
					t4 = elvishNames.getSuffix(gender);
					t5 = elvishNames.getSuffix(gender);
					output = capitalize (combineStrings (t1.name, t2.name)) + ' ' + capitalize( combineStrings (t3.name, t4.name, t5.name));
					desc = '(' + t1.meaning.join (', ') + ', ' + t2.meaning.join (', ') + ', ' + t3.meaning.join (', ') + ', ' + t4.meaning.join (', ') + ', ' + t5.meaning.join (', ') + ')';
					break;
				case 10:
					// Roll once on Table 3, add an apostrophe, then roll once on Table 2 and twice on Table 3
					t1 = elvishNames.getSuffix(gender);
					t2 = elvishNames.getPrefix(gender);
					t3 = elvishNames.getSuffix(gender);
					t4 = elvishNames.getSuffix(gender);
					output = capitalize (combineStrings (t1.name) ) + '\'' + capitalize (combineStrings (t2.name, t3.name, t4.name));
					desc = '(' + t1.meaning.join (', ') + ', ' + t2.meaning.join (', ') + ', ' + t3.meaning.join (', ') + ', ' + t4.meaning.join (', ') + ')';
					break;
			}
			
			
			
			switch (gender)
			{
				case NameData.MALE:
					if (_textField) 
					{
						_textField.appendText (output + ' (Male)\n');
						_textField.appendText (desc + '\n\n');
					}
					break;
				case NameData.FEMALE:
					if (_textField)
					{
						_textField.appendText (output + ' (Female)\n');
						_textField.appendText (desc + '\n\n');
					}
					break;
			}
			
		}
		
		private function capitalize ( str:String ):String
		{
			var body:String = str.substr (1);
			var head:String = str.substr (0, 1);
			var returnStr:String = head.toUpperCase() + body.toLowerCase();
			return returnStr;
		}
		
		private function combineStrings (...rest):String
		{
			var strings:Array = new Array();
			for (var i:int = 0; i < rest.length; ++i)
			{
				if (rest[i] is String)
				{
					strings.push (rest[i]);
				}
			}
			
			if (strings.length < 2)
			{
				return strings[0];
			}
			else
			{
				var combine:String = strings[0];
				for (i = 1; i < strings.length; ++i)
				{
					combine = combinePair (combine, strings[i]);
				}
				return combine;
			}
		}
		
		private function combinePair (s1:String, s2:String):String
		{
			var combine:String;
			if (s2.substr(0, 1) == s1.substr( -1, 1))
			{
				combine = combinePair ( s1, s2.substr (1));
			}
			else
			{
				combine = s1 + s2;
			}
			return combine;
		}
	}
}