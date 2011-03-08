package com.tomasino.logging
{
	import flash.system.Capabilities;
	import com.tomasino.utils.QueryString;
	import com.tomasino.logging.IConsole;
	
	public class TraceConsole implements IConsole
	{
		private var _enabled:Boolean;
		private var _lastcategory:String;
		
		public function TraceConsole ():void
		{
			var d:String = QueryString.params['debug'] as String;
			if (d)
				if (d.toLowerCase() == 'true')
					_enabled = true;
			
			if (Capabilities.playerType == "External")
				_enabled = true;
		}
		
		public function log (category:String, level:Number, message:String):void
		{
			if (_enabled)
			{
				var t:String = ''; // Define output string
				if (category != _lastcategory)
				{
					t += (_lastcategory) ? '\n' : '';
					t += '==> ' + category + '\n';
				}
				
				t += '\t';
				
				switch (level)
				{
					case LogLevel.DEBUG:
						t += 'DEBUG -- ';
						break;
					case LogLevel.INFO:
						t += 'INFO  -- ';
						break;
					case LogLevel.WARN:
						t += 'WARN  -- ';
						break;
					case LogLevel.ERROR:
						t += 'ERROR -- ';
						break;
					case LogLevel.FATAL:
						t += 'FATAL -- ';
						break;
				}
				
				t += message;
				
				_lastcategory = category;
				
				if (t) trace(t);
			
			}
		}
	}
}