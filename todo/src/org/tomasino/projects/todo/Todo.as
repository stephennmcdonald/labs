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

			SWFAddress.addEventListener (SWFAddressEvent.INIT, onSWFAddressInit);
			SWFAddress.addEventListener (SWFAddressEvent.EXTERNAL_CHANGE, onExternalChange);
			SWFAddress.addEventListener (SWFAddressEvent.INTERNAL_CHANGE, onInternalChange);
		}
		
		private function onSWFAddressInit ( e:SWFAddressEvent ):void
		{
			SWFAddress.removeEventListener (SWFAddressEvent.INIT, onSWFAddressInit);
			_log.info ('SWFAddress Init:');
		}

		private function onExternalChange ( e:SWFAddressEvent ):void
		{
			_log.info ('External Change:', e.path);
		}
		
		private function onInternalChange ( e:SWFAddressEvent ):void
		{
			_log.info ('Internal Change:', e.path)
		}
	}
}
