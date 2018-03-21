package com.zb.as3.util
{
	import flash.utils.getQualifiedClassName;
	import flash.system.ApplicationDomain;
	import flash.display.DisplayObject;
	
	/**
	 * ClassUtil 类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see aswing
	 */
	public final class ReflectUtil{
		
		
		/**
		 * 创建实例（可视对象 DisplayObject）
		 * @param fullClassName 完整类型名称
		 * @param applicationDomain 域
		 * @return DisplayObject实例
		 * 
		 */
		public static function createDisplayObjectInstance(fullClassName:String, applicationDomain:ApplicationDomain=null):DisplayObject{
			return createInstance(fullClassName, applicationDomain) as DisplayObject;
		}
		/**
		 * 创建实例 
		 * @param fullClassName 完整类型名称
		 * @param applicationDomain 域
		 * @return 对象实例
		 * 
		 */
		public static function createInstance(fullClassName:String, applicationDomain:ApplicationDomain=null):*{
			var assetClass:Class = getClass(fullClassName, applicationDomain);
			if(assetClass != null){
				return new assetClass();
			}
			return null;		
		}
		/**
		 * 通过 完整类名称/域 获取类 
		 * @param fullClassName
		 * @param applicationDomain
		 * @return 
		 * 
		 */
		public static function getClass(fullClassName:String, applicationDomain:ApplicationDomain=null):Class{
			if(applicationDomain == null){
				applicationDomain = ApplicationDomain.currentDomain;
			}
			var assetClass:Class = applicationDomain.getDefinition(fullClassName) as Class;
			return assetClass;		
		}
		/**
		 * 完整类型名称
		 * @param o
		 * @return 
		 * 
		 */
		public static function getFullClassName(o:*):String{
			return getQualifiedClassName(o);
		}
/*		public static function getClassName(o:*):String{
			var name:String = getFullClassName(o);
			var lastI:int = name.lastIndexOf(".");
			if(lastI >= 0){
				name = name.substr(lastI+1);
			}
			return name;
		}*/
		/**
		 * 获取指定对象的类名（不完全限定类名）
		 * @param	object:Object — 对象
		 * @return String — 指定对象的类名称
		 */
		public static function getShortClassName(object:Object):String
		{
			var className:String = getQualifiedClassName(object);
			var strs:Array = className.split("::");
			className = strs.length > 1?strs[1]:strs[0];
			return className;
		}
		/**
		 * 首包名称
		 * @param o
		 * @return 
		 * 
		 */
		public static function getPackageName(o:*):String{
			var name:String = getFullClassName(o);
			var lastI:int = name.lastIndexOf(".");
			if(lastI >= 0){
				return name.substring(0, lastI);
			}else{
				return "";
			}
		}
		/**
		 * 完整包名称
		 * @param o
		 * @return
		 */
		public static function getFullPackageName(o:*):String{
			var className:String = getQualifiedClassName(o);
			var strs:Array = className.split("::");
			return strs.length>1 ? strs[0] : '';
		}
		/**
		 * 判断 ApplicationDomain.currentDomain 是否有类的定义
		 **/
		public static function hasClass(name:String):Boolean {
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
	}
}