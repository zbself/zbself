/**
 * scaleXY<br>
 * 
 * @author zbself
 * @E-mail zbself@qq.com
 * @created 上午00:00:00 / 2015-1-1
 * @see 
 */
package com.zb.as3.util.short
{
	import flash.display.DisplayObject;
	/**
	 * 等比例缩放<br>
	 * scaleX = scaleY = value; 
	 */	
	public function scaleXY( display:DisplayObject , value:Number = 1 ):void
	{
		if( display )
		{
			display.scaleX = display.scaleY = value;
		}
	}
}