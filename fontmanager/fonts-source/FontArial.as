package
{
	import flash.display.Sprite;
	public class FontArial extends Sprite
	{
		/** Fonts By Unicode Range:
		  * http://www.alanwood.net/unicode/fontsbyrange.html#u0000
		  */
		[Embed(systemFont="Arial",
			fontName="ArialFont", /* This name must match the string literal in your class */
			mimeType="application/x-font",
			unicodeRange="U+0000-U+007E,U+2000-U+206F")]
			var regular:Class;
			
		[Embed(systemFont="Arial",
			fontName="ArialFont",
			mimeType="application/x-font",
			fontWeight="bold",
			unicodeRange="U+0000-U+007E,U+2000-U+206F")]
			var bold:Class;
		
		public function FontArial ():void
		{
			Font.registerFont(regular);
			Font.registerFont(bold);
		}
	}
}
