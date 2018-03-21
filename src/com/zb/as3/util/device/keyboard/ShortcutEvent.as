package com.zb.as3.util.device.keyboard
{
	import flash.events.Event;

	/**
	 * @author itamt@qq.com
	 */
	public class ShortcutEvent extends Event {
		public static const DOWN : String = 'shortcut_down';		public static const UP : String = 'shortcut_UP';

		public var shortcut : Shortcut;

		public function ShortcutEvent(shortcut : Shortcut, type : String, bubbles : Boolean = false, cancelabe : Boolean = true) : void {
			super(type, bubbles, cancelabe);
			
			this.shortcut = shortcut;
		}
	}
}
