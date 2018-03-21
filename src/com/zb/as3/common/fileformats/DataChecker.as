package com.zb.as3.common.fileformats
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	/**
	 * DataChecker<br>
	 * 数据检测类
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class DataChecker
	{
		/**
		 * 判断数据格式是否是XML或者JSON 
		 * @param bytes
		 * @return 返回 json/xml（都不是则返回null）
		 * 
		 */
		static public function isXMLOrJSON(bytes:IDataInput):String
		{
			try
			{
				var v:String = bytes.readUTFBytes(1);
			}
			catch (e:Error){};
			if (v && v.charCodeAt(0) == 65279)//UTF-8文件头
			{
				try
				{
					v = bytes.readUTFBytes(1);//再次读取
				}
				catch (e:Error){};
			}
			
			if (v == "<")
				return "xml";
			else if (v == "{" || v == "[" || v == "\"")
				return "json";
			else
				return null;
		}
	}
}