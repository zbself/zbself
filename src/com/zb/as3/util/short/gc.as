/**
 * gc<br>
 * 
 * @author zbself
 * @E-mail zbself@qq.com
 * @created 上午00:00:00 / 2015-1-1
 * @see zrong
 */
package com.zb.as3.util.short
{
	
	import flash.net.LocalConnection;
	import flash.system.System;

	/**
	 * 执行强制垃圾回收<br>
	 * 每次执行约耗费200ms，若引用关系复杂则更甚，慎用慎用<br>
	 * @param weak true：弱回收 / false：强回收
	 */
	public function gc(weak:Boolean=false):void
	{
		//连续两次连接同一地址会抛出异常，Flash Player在遇到异常的时候会强制进行垃圾回收
		//使用LocalConnection的原因是这个操作很不常用，不易发生冲突
		if(weak) System.gc();
		else
		{
			start(); start();
		}
		function start ():void {try { new LocalConnection().connect('gc:gc'); } catch (e:Error) { System.gc()} }
	}
}