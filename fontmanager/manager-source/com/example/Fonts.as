package com.example
{
	import com.tomasino.fonts.FontManager;
	
	public class Fonts extends FontManager
	{
		private var urls:Object = new Object();
		
		// String Literal must match FontName property.
		public static const ARIAL:String = 'ArialFont';
		public static const GROTESQUE:String = 'GrotesqueMTFont';
		
		public function Fonts ():void
		{
			super();
	
			urls[ARIAL] = 'fonts/arial.swf';
			urls[GROTESQUE] = 'fonts/grotesque.swf';
			
			for (var s:String in urls)
			{
				register (s, urls[s]);
			}
		}
	}
}
