package com.tomasino.projects.namegenerator
{
	public class List
	{
		private var _id:String;
		
		private var _data:Array;
		private var _male:Array;
		private var _female:Array;
		
		private var _maleLength:int;
		private var _femaleLength:int;
		private var _dataLength:int;
		
		public function List (xml:XML):void
		{
			_data = new Array();
			parseXML (xml);
		}
		
		public function getData ( gender:String = 'n' ):NameData
		{
			var rnd:int;
			
			switch (gender.toLowerCase())
			{
				case 'm':
					rnd = Math.floor ( Math.random() * _maleLength );
					return _male[rnd];
					break;
				case 'f':
					rnd = Math.floor ( Math.random() * _femaleLength );
					return _female[rnd];
					break;
				default:
					rnd = Math.floor ( Math.random() * _dataLength );
					return _data[rnd];
					break;
			}
		}
		
		public function get id():String { return _id; }
		
		public function get data():Array { return _data; }
		
		public function get male():Array { return _male; }
		
		public function get female():Array { return _female; }
		
		private function parseXML(xml:XML):void
		{
			
			_id = xml.@id;
			
			trace (_id);
			var nameDataXML:XMLList = xml.nameData;
			
			if (nameDataXML)
			{
				var totalData:int = nameDataXML.length();

				for (var i:int = 0; i < totalData; ++i)
				{
					var data:XML = nameDataXML[i];
					var nameData:NameData = new NameData (data);
					_data.push (nameData);
				}
				
				_male = _data.filter ( filterMale );
				_female = _data.filter ( filterFemale );
				
			}
			else
			{
				trace ('can not find nameData');
			}
			
			_dataLength = _data.length;
			_maleLength = _male.length;
			_femaleLength = _female.length;
		}
		
		public function filterMale (item:*,  index:int = 0, array:Array = null):Boolean
		{
			if (item is NameData)
			{
				if (NameData(item).gender != 'f')
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		public function filterFemale (item:*,  index:int = 0, array:Array = null):Boolean
		{
			if (item is NameData)
			{
				if (NameData(item).gender != 'm')
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
}