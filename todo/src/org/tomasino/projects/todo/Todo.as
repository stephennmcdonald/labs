package org.tomasino.projects.todo
{
	import flash.display.Sprite;
	import flash.events.Event;

	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	import org.tomasino.logging.Log;
	import org.tomasino.logging.Logger;
	import org.tomasino.logging.LogBookConsole;

	[SWF(width="800", height="600", frameRate="30", backgroundColor="#FFFFFF")]
	public class Todo extends Sprite
	{

		private var _log:Logger = new Logger (this);

		public function Todo ():void
		{
			if (this.stage) init();
			else addEventListener (Event.ADDED_TO_STAGE, init);
		}

		private function init (e:Event = null):void
		{
			removeEventListener (Event.ADDED_TO_STAGE, init);

			Log.inst.addConsole ( new LogBookConsole ('_org.tomasino.labs.todo') );

			SWFAddress.addEventListener (SWFAddressEvent.CHANGE, onSWFAddressChange)
		}

		private function onSWFAddressChange (e:SWFAddressEvent):void
		{
			_log.info (e.path);
		}
	}

}
