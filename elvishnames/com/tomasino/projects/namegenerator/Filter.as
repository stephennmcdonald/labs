package com.tomasino.projects.namegenerator
{
	import com.adobe.utils.ArrayUtil;
	
	public class Filter
	{
		private var _displayPattern:Array = new Array();
		public var pattern:String;
		
		public function Filter (filterString:String):void
		{
			pattern = filterString;
			parseFilter (filterString);
		}
		
		public function apply (listArray:Array, gender:String):FilterResults
		{
			var result:FilterResults = new FilterResults ();
			
			for (var i:int = 0; i < _displayPattern.length; ++i)
			{
				var disp:String = _displayPattern[i];
				var trailingChar:String = result.name.substr ( -1 );
				
				var addChars:String;
				var addMeaning:Array;
				
				if (disp.substr(0, 1) == '%')
				{
					var listNum:int = int ( disp.substr(1) ) - 1;
					if (listArray.length > listNum)
					{
						var list:List = listArray[listNum] as List;
						if (list)
						{
							var nameData:NameData = list.getData (gender);
							if (nameData)
							{
								addChars = nameData.root;
								if (trailingChar == addChars.substr (0, 1))
								{
									addChars = addChars.substr ( 1 );
								}
								addMeaning = nameData.meaning;
							}
						}
					}
				}
				else
				{
					addChars = disp;
				}
				
				// Test for doubled letters at sync points
				if (trailingChar == addChars.substr (0, 1))
				{
					addChars = addChars.substr ( 1 );
				}
				
				// Capitalization test
				if (trailingChar == ' ' || trailingChar == '' || trailingChar == '\'')
				{
					var headStr:String = addChars.substr (0, 1);
					var bodyStr:String = addChars.substr (1);
					addChars = headStr.toUpperCase () + bodyStr.toLowerCase();
				}
				
				result.name += addChars;
				if (addMeaning) result.meaning = ArrayUtil.createUniqueCopy(result.meaning.concat(addMeaning));

			}
			
			return result;
		}
		
		
		private function parseFilter(str:String):void
		{
			var repIndex:int = str.indexOf('%');
			
			if (repIndex == -1)
			{
				_displayPattern.push (str);
			}
			
			if (repIndex > 0)
			{
				_displayPattern.push ( str.substr(0, repIndex) );
				parseFilter ( str.substr (repIndex) );
			}
			
			if (repIndex == 0)
			{
				var rep:String = '%';
				var strArr:Array = str.split('');
				for (var i:int = 1; i < strArr.length; ++i)
				{
					if (!isNaN(strArr[i]) && strArr[i] != ' ')
					{
						rep += strArr[i];
					}
					else
					{
						break;
					}
				}
				_displayPattern.push (rep);
				var rest:String = str.substr (i);
				parseFilter (rest);
			}
		}
	}
}