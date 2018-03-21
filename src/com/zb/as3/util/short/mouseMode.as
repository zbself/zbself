/**
 * mouseMode<br>
 * 
 * @author zbself
 * @E-mail zbself@qq.com
 * @created 上午00:00:00 / 2015-1-1
 * @see 
 */
package com.zb.as3.util.short
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;

	
	/**
	 * 快捷设置/禁用 对象的鼠标交互<br>
	 * @param $display 设置对象
	 * @param $state 鼠标状态
	 */	
	public function mouseMode($display:DisplayObjectContainer,$state:Boolean = false):void
	{
		if($display is DisplayObjectContainer) $display.mouseChildren = $state;
		if($display is InteractiveObject) $display.mouseEnabled = $state;
	}
}