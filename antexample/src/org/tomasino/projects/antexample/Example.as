package org.tomasino.projects.antexample
{
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="#FFFFFF")]
	public class Example extends Sprite
	{
		public function Example ():void
		{
			if (this.stage) init();
			else addEventListener (Event.ADDED_TO_STAGE, init);
		}

		private function init (e:Event = null):void
		{
			removeEventListener (Event.ADDED_TO_STAGE, init);
		}
	}
}
