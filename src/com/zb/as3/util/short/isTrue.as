/**
 * isTrue<br>
 * 
 * @author zbself
 * @E-mail zbself@qq.com
 * @created 上午00:00:00 / 2015-1-1
 * @see 
 */
package com.zb.as3.util.short
{
	/**
	 * 简单类型的快捷检测<br>
	 * @param 检测对象
	 * @return true/false
	 */
	public function isTrue( value:Object ):Boolean
	{
		if( value )
		{
			if( value is Boolean || typeof(value) == "boolean")
			{
				return Boolean( value ? 1:0 );
			}
			else if( value is String || typeof(value) == "string" )
			{
				return Boolean( value != "" && value.length > 0 && value != "0" && (String(value).toLowerCase() != "false")  ? 1:0 );
			}
			else if( value is Number || typeof(value) == "number" )
			{
				return Boolean( value!=0 ? 1:0 );
			}
			else if( value is Array || typeof(value) == "array")
			{
				return Boolean( value.length >0 ? 1:0 );
			}else if( value is Object || typeof(value) == "object")//Object放最后
			{
				return Boolean( value ? 1:0 );
			}
		}
		return false;
	}
}