/**
 * htmlAlert<br>
 * 
 * @author zbself
 * @E-mail zbself@qq.com
 * @created 上午00:00:00 / 2015-1-1
 * @see 
 */
package com.zb.as3.util.short
{
	import com.zb.as3.util.net.JSUtil;
	/**
	 * 网页Alert<br>
	 */
	public function htmlAlert($info:String):void
	{
		JSUtil.alert( $info );
	}
}