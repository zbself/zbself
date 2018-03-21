package com.zb.as3.interfaces
{
	/**
	 *	连接类 接口
	 */
	public interface INection extends IBasic
	{
		
		function __call(...args):void;
		function __close():void;
		function __connect( ...args):void;
		
	}
}