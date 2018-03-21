package com.zb.as3.util.net
{
	/**
	 * URLUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class URLUtil
	{
		public function URLUtil()
		{
			
		}
		 public static function isHTTP(v:String):Boolean
		{
			return v.substr(0,7).toLowerCase() == "http://" || v.substr(0,8).toLowerCase() == "https://";
		}
	}
}