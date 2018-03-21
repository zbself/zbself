package com.zb.as3.events
{
	import com.zb.as3.events.i.EventBase;
	
	import flash.events.Event;
	/**
	 * ZEvent<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 下午2:16:22 / 2017-3-17
	 * @see 
	 */
	public class ZEvent extends EventBase
	{
//		[Event(name="start",type="com.zbself.as3.framework.events.ZEvent")]
		/**
		 * Z自定义：启动
		 */
		public static const START:String="z:start";
		/**
		 * Z自定义：暂停
		 */
		public static const PAUSE:String="z:pause";
		/**
		 * Z自定义：继续
		 */
		public static const GOON:String="z:goon";
		/**
		 * ZB自定义：停止
		 */
		public static const STOP:String="z:stop";
		/**
		 * Z自定义：刷新
		 */
		public static const REFRESH:String="z:refresh";
		
		public function ZEvent($type:String, $info:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $info, $bubbles, $cancelable);
		}
		
		public override function clone():Event{
			return new ZEvent( type, info, bubbles, cancelable );
		}
		public override function toString():String{
			return formatToString("ZEvent", "type", "info", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}