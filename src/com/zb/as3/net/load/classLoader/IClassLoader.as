package com.zb.as3.net.load.classLoader
{
	public interface IClassLoader
	{
		function loadFile(url:String,shared:Boolean=false,cacheCode:String=""):void;
		function getClass(name:String):Class;
		function isFree():Boolean;
	}
}