package com.zb.as3.debug.util
{
	import flash.utils.describeType;
	
	/**
	 * PropertyTools<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class PropertyTools
	{
		public function PropertyTools()
		{
		}
		public static function getProperties(obj:Object):Array
		{
			var ary:Array = [];
			try
			{
				var xmlDoc:XML = describeType(obj);
				trace(xmlDoc);
				for each(var item:XML in xmlDoc.accessor)
				{
					trace(item);
					var name:String = item.@name.toString();
					var type:String = item.@type.toString();
					var value:Object = obj[name] != null ? obj[name] : "";
					ary.push({name:name, type:type, value:value});
				}
			}catch(e:Error)
			{
			}
			return ary;
		}
		public static function getVariables(obj:Object):Array
		{
			var ary:Array = [];
			try
			{
				var xmlDoc:XML = describeType(obj);
				trace(xmlDoc);
				for each(var item:XML in xmlDoc.variable)
				{
					trace(item);
					var name:String = item.@name.toString();
					var type:String = item.@type.toString();
					var value:Object = obj[name] != null ? obj[name] : "";
					ary.push({name:name, type:type, value:value});
				}
			}catch(e:Error)
			{
			}
			return ary;
		}
		
		public static function getMethods(obj:Object):Array
		{
			var ary:Array = [];
			try
			{
				var xmlDoc:XML = describeType(obj);
				trace(xmlDoc);
				for each(var item:XML in xmlDoc.method)
				{
					trace(item);
					var name:String = item.@name.toString();
					var type:String = item.@type.toString();
					var value:Object = obj[name] != null ? obj[name] : "";
					ary.push({name:name, type:type, value:value});
				}
			}catch(e:Error)
			{
			}
			return ary;
		}
		
	}
}