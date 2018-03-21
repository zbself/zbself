package com.zb.as3.events
{
	import flash.events.Event;

	/**
	 * StageEvent <br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2017-1-1
	 * @see 
	 */
	public class StageEvent extends Event
	{
		/**
		 * 激活
		 */		
		public static const ACTIVATE:String="activate";
		/**
		 * 休眠
		 */		
		public static const DEACTIVATE:String="deactivate";
		/**
		 * 改变
		 */		
		public static const RESIZE:String="resize";
		/**
		 * 不允许全屏
		 */		
		public static const NOT_ALLOWS_FULLSCREEN:String="not_allows_fullscreen";
		
		/**
		 * 构造函数
		 * @param	type:String — 事件类型
		 */
		public function StageEvent($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
		}
		public override function toString():String{
			return formatToString("StageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}