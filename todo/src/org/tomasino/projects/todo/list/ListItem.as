package org.tomasino.projects.todo.list
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class ListItem extends Sprite
	{
		private var _boundaryWidth:Number;
		private var _boundaryHeight:Number;
		private var _width:Number;
		private var _height:Number;

		public function ListItem ():void
		{
			
		}

		public function get boundaryWidth():Number
		{
			return _boundaryWidth;
		}

		public function get boundaryHeight():Number
		{
			return _boundaryHeight;
		}

		override public function set width (val:Number):void
		{
			// Do boundaryWidth calculations
			super.width = val;
			dispatchEvent (new Event( Event.RESIZE ));
		}

		override public function set height (val:Number):void
		{
			// Do boundaryHeight calculations
			super.height = val;
			dispatchEvent (new Event( Event.RESIZE ));
		}
	}
}

