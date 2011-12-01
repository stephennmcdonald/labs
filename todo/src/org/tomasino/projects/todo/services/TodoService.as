package org.tomasino.projects.todo.services
{
	import flash.net.Responder;
	import flash.events.Event;
	import flash.net.NetConnection;

	import org.tomasino.logging.Logger;

	public class TodoService
	{
		private var _log:Logger = new Logger (this);
		private var _remotingService:NetConnection;

		public function TodoService (serviceURL:String):void
		{
			_remotingService = new RemotingService( serviceURL );
		}

		public function test ():void
		{
			var responder:Responder = new Responder ( onTestResult, onFault );
			_log.info ('Initiating Service Call');
			_remotingService.call ("TodoAMF.test", responder);
		}

		private function onTestResult (result:Object):void
		{
			_log.info ("onTestResult:", result.toString());
		}

		private function onFault (fault:Object):void
		{
			_log.error ("onFault:", fault.toString());
		}
	}
}
