package com.zb.as3.util
{
	import flash.utils.getTimer;

	/**
	 * Performance 测试性能时 使用<br>
	 * Performance.init(); >中间消耗的毫秒数> Performance.consume();
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	final public class Performance
	{
		public function Performance($sig:SingletonPerformance)
		{
		}
		private static var timer:Number = 0;
		/**
		 * 初始化 getTimer
		 */		
		public static function init():void
		{
			timer = getTimer();
		}
		/**
		 * 截取时段时 前，先运行 init() 初始化时间<br>
		 * 计算自 init(); 之后 到执行 consume(); 消耗的毫秒数
		 * @param char 提示说明内容
		 * 
		 */		
		public static function consume( char:String = ""):Number
		{
			var delay:Number = getTimer() - timer;
			trace( char + " >> " + delay );
			return delay;
		}
	}
}
class SingletonPerformance{};