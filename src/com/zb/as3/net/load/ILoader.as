package org.zengrong.net
{
	/**
	 * 所有的Loader类型的类都必须实现这个接口
	 */
	public interface ILoader
	{
		/**
		 * 返回当前载入的文件类型
		 * */
		function get type():String;
		
		/**
		 * 返回当前是否正在载入
		 */	
		function get loading():Boolean;
		
		function destroy():void;
	}
}
