package com.zbself.as3.framework.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * SocketBoxEvent<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class SocketBoxEvent extends Event
	{
		
		public static const CONNECTING:String = "connecting";
		public static const CONNECT_SUCCESS:String = "connect_success";
		public static const RECEIVING_DATA:String = "receiving_data";
		public static const RECEIVED_DATA:String = "received_data";
		public static const Error:String = "error";
		public static const CLOSE:String = "close";
		
		public var info:String;
		public var data:*;
		
		public function SocketBoxEvent(type:String, $data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = $data;
		}
		public override function clone():Event
		{
			var e:SocketBoxEvent = super.clone() as SocketBoxEvent;
			e.data = data;
			e.info = info;
			return e;
		}
		public override function toString():String{
			return formatToString("SocketBoxEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
}