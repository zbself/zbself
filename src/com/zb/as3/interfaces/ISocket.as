package com.zb.as3.interfaces
{
	public interface ISocket extends IBasic
	{
		function __connect():void;
		function get __connected():Boolean;
		function __send(value:*):Boolean;
		function __flush():void;
		function __close():void;
	}
}