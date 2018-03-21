package com.zb.as3.util.core
{
	/**
	 * Function处理器
	 */
	public class Handler {
		/**处理方法*/
		public var method:Function;
		/**参数*/
		public var args:Array;
		
		public function Handler(method:Function = null, args:Array = null) {
			this.method = method;
			this.args = args;
		}
		
		/**
		 * 执行处理
		 **/
		public function func():void {
			if (method != null) {
				method.apply(null, args);
			}
		}
		/**
		 * 执行处理(增加数据参数)
		 * @param data:Array 执行参数数组
		 **/
		public function func2(data:Array):void {
			if (data == null) {
				return func();
			}
			if (method != null) {
				method.apply(null, args ? args.concat(data) : data);
			}
		}
	}
}