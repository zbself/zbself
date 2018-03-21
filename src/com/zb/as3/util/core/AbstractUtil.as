package com.zb.as3.util.core
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	/**
	 * AbstractUtil<br>
	 * 抽象类工具，被子类继承/重写 才可以使用。
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	final public class AbstractUtil
	{
		/**
		 * 阻止抽象类的实例化，【需要子类继承】<br>
		 * 构造函数 AbstractUtil.preventConstructor(this,CurrentClassName);
		 * @param obj	对象
		 * @param AbstractType	抽象类类型
		 * @param errorText 错误描述（一般为空）
		 */
		public static function preventConstructor(obj:*,abstractType:Class,errorText:String = null):void
		{
			if (obj["constructor"] == abstractType)
			{
				if (!errorText)
				{
					var typeName:String = getQualifiedClassName(obj);
					errorText = typeName+" 类为抽象类，不允许实例化，请子类继承！";
				}
				throw new IllegalOperationError(errorText);
			}
		}
		/**
		 * 阻止抽象方法运行【需子类重写】<br>
		 * AbstractUtil.enforceMethod();
		 * @param errorText 错误描述（一般为空）
		 */		
		public static function preventMethod(errorText:String = null):void
		{
			if (!errorText)
			{
				errorText = "不可实现的抽象方法，请子类重写！";
			}
			throw new IllegalOperationError();
		}
	}
}