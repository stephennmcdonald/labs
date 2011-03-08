package com.example
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import com.example.Fonts;
	
	public class FontManagerExample extends Sprite
	{
		private var f:Fonts;
		
		public function FontManagerExample ():void
		{
			traceFonts ();
			
			f = new Fonts ();
			f.addEventListener (Event.COMPLETE, onFontsLoaded);
			f.loadFont (Fonts.ARIAL);
			f.loadFont (Fonts.GROTESQUE);
			f.start();
		}
		
		private function onFontsLoaded (e:Event):void
		{
			traceFonts();
		}

		private function traceFonts ():void
		{
			trace ('------------Start Fonts Loaded --------------');
			
			var fontArray:Array = Font.enumerateFonts(false);
			
			for (var item:String in fontArray)
			{
				trace (fontArray[item].fontName);
			}
			
			trace ('------------ End Fonts Loaded  --------------\n');
		}
	}
}









