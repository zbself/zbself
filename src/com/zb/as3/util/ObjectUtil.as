package com.zb.as3.util
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * ObjectUtil Object类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class ObjectUtil
	{
		/**
		 * 序列化复制一个对象
		 * Deep clone object
		 * @param value Object
		 */	
		public static function clone(source:*):Object
		{
			var typeName:String = getQualifiedClassName(source);
			var packageName:String = typeName.split("::")[1];
			var type:Class = Class(getDefinitionByName(typeName));
			registerClassAlias(packageName, type);
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
		}
		
		/**
		 * 读取AMF
		 * */
		public static function readAMF(bytes:ByteArray):Object {
			if (bytes && bytes.length > 0 && bytes.readByte() == 0x11) {
				return bytes.readObject();
			}
			return null;
		}
		/**
		 * 序列化
		 * 写入AMF
		 * */
		public static function writeAMF(obj:Object):ByteArray {
			var bytes:ByteArray;
			bytes.writeByte(0x11);
			bytes.writeObject(obj);
			return bytes;
		}
		
		
		/**
		 * Checks wherever passed-in value is <code>String</code>.
		 */
		public static function isString(value:*):Boolean {
			return ( typeof(value) == "string" || value is String );
		}
		/**
		 * Checks wherever passed-in value is <code>Number</code>.
		 */
		public static function isNumber(value:*):Boolean {
			return ( typeof(value) == "number" || value is Number );
		}
		/**
		 * Checks wherever passed-in value is <code>Boolean</code>.
		 */
		public static function isBoolean(value:*):Boolean {
			return ( typeof(value) == "boolean" || value is Boolean );
		}
		/**
		 * Checks wherever passed-in value is <code>Array</code>.
		 */
		public static function isArray(value:*):Boolean {
			return ( typeof(value) == "array" || value is Array );
		}
		/**
		 * Checks wherever passed-in value is <code>Function</code>.
		 */
		public static function isFunction(value:*):Boolean {
			return ( typeof(value) == "function" || value is Function );
		}
		/**
		 * Checks wherever passed-in value is <code>Object</code>.
		 */
		public static function isObject(value:*):Object {
			return ( typeof(value) == "object" || value is Object );
		}
		/**
		 * 简单类型
		 */
		public static function isSimple(object:Object):Boolean {
			switch (typeof(object)) {
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return (object is Date) || (object is Array);
			}
			return false;
		}
		
	}
}