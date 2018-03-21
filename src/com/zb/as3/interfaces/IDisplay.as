package com.zb.as3.interfaces
{
	/**
	 * 可视对象类型 接口
	 */
	public interface IDisplay extends IBasic
	{
		//显示
		function __show():void;
		//隐藏
		function __hide():void;
		//添加
		function __add(...params):void;
		//移除
		function __remove(...params):void;
	}
}