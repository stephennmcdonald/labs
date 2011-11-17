package org.tomasino.projects.todo
{
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(width="800", height="600", frameRate="30", backgroundColor="#FFFFFF")]
	public class Todo extends Sprite
	{
		public function Todo ():void
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
