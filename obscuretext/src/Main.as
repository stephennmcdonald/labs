package
{
	import com.tomasino.utils.ObscureText;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author tomasino
	 */
	public class Main extends Sprite
	{
		private var pressedKeys:Object = { };
		private var text:TextField;
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			text = new TextField ();
			text.multiline = true;
			text.wordWrap = true;
			text.width = stage.stageWidth;
			text.height = stage.stageHeight;
			addChild (text);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener ( Event.RESIZE, resizeHandler );
			stage.addEventListener ( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener ( KeyboardEvent.KEY_UP, keyUpHandler );
		}
		
		private function resizeHandler(e:Event):void
		{
			text.width = stage.stageWidth;
			text.height = stage.stageHeight;
		}
		
		private function keyDownHandler( e:KeyboardEvent ):void
		{
			// The keyDown event is repeatedly fired while a key is
			// held down, so we can do this to ensure we only deal with
			// the event the first time a key is pressed.
			if( pressedKeys[ e.keyCode ] )
			{
			//	return;
			}
			
			pressedKeys[ e.keyCode ] = 1;
			displayText( e );
		}
		
		private function keyUpHandler( e:KeyboardEvent ):void
		{
			delete pressedKeys[ e.keyCode ];
		}
		
		private function displayText ( e:KeyboardEvent ):void
		{
			switch (e.charCode)
			{
				case 8:
					text.text = text.text.substring ( 0, text.text.length - 1);
					break;
				case 13:
					text.appendText ('\n');
					break;
				default:
					text.appendText ( ObscureText.randomCharByCode (e.charCode) );
					trace ( String.fromCharCode ( e.charCode ), e.charCode);
			}
		}
	}
	
}