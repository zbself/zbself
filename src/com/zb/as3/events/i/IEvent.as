package com.zb.as3.events.i
{
	import flash.events.IEventDispatcher;

	public interface IEvent
	{
		//自定义事件接口
		function get info():Object;
		function set info(value:Object):void;
	}
}