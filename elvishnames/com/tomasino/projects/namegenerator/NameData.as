package com.tomasino.projects.namegenerator
{
	public class NameData
	{
		public var root:String;
		public var gender:String;
		public var meaning:Array;
		
		public function NameData (xml:XML):void
		{
			/*
			 	<nameData>
					<root>ael</root>
					<gender>n</gender>
					<meanings>
						<meaning>knight</meaning>
					</meanings>
				</nameData>
			*/

			root = xml.root;
			gender = xml.gender;
			meaning = new Array();
			
			for (var i:int = 0; i < xml.meanings.meaning.length(); ++i)
			{
				var m:String = xml.meanings.meaning[i];
				meaning.push ( m );
			}
		}
	}
}