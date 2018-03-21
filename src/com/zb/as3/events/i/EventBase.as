package com.zb.as3.events.i
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * EventBase<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class EventBase extends Event implements IEvent
	{
//		[Event(name="start",type="com.zbself.as3.framework.events.InfoEvent")]
		/**
		 * 事件综合参数
		 */
		private var _info:Object;
		public function EventBase(type:String, $info:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.info = $info;
		}
		
		public function get info():Object { return _info; }
		public function set info(value:Object):void{ _info = value; };
		
		public override function clone():Event
		{
			return new EventBase(type,_info,bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString( getQualifiedClassName(this), "info", "bubbles", "cancelable", "eventPhase" );
		}
	}
}