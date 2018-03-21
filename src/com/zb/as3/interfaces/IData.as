package com.zb.as3.interfaces
{
	/**
	 * 数据类型 接口
	 */
	public interface IData extends IBasic
	{
		//清除
		function __clear():void;
		//压缩
		function __compress():void;
		//解压缩
		function __uncompress():void;
		
		//加密
		function __encrypt():void;
		//解密
		function __decrypt():void;
		
		//编码
		function __encode():void;
		//解码
		function __decode():void;
	}
}