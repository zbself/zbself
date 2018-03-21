package com.zb.as3.interfaces
{
	/**
	 * 管理器类型 接口
	 */
	public interface IManager extends IBasic
	{
		//配置
		function __config():void;
		//注册
		function __registers():void;
		//注销
		function __unregisters():void;
	}
}