package com.zb.as3.util.net
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.utils.getDefinitionByName;
	
	/**
	 * JSUtil JavaScript交互类<br>
	 * 使用JS的alert、confirm、close与浏览器交互
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see zrong
	 */
	public class JSUtil
	{
		/**
		 * 函数名称记录列表（用于注销已注册的接口方法）
		 * @private
		 */
		private static var recordList:Array;
		
		private static const ERROR_TXT:String = '[错误]：外部容器接口不可用！';
		/**
		 * 弹出 JavaScript.Alert 对话框
		 * @param $info 要显示的消息
		 */
		public static function alert($info:String):void
		{
			call('alert', $info);
		}
		/**
		* 弹出JavaScript confirm确认对话框，根据用户的交互返回是否确认布尔值
		* @param $info 要显示的信息
		* @param $closeFun 关闭确认对话框时调用的函数，该函数必须包含1个Boolean参数，如果用户选择确认，则这个参数为true
		*/
		public static function confirm($info:String, $closeFun:Function):void
		{
			$closeFun(call('confirm', $info));
		}
		/**
		 * 关闭一个浏览器窗口 
		 */
		public static function close():void
		{
			call('window.close');
		}
		/**
		 * 打开一个浏览器窗口 
		 * @param url 新链接URL地址
		 */
		public static function open(url:String,type:String="_blank"):void
		{
			call('window.open',url,type);
		}
		/**
		 * 注册外部容器调用ActionScript的接口方法，将closure设为null则可删除回调注册
		 * @param	functionName:String — 一个函数名称，JavaScript函数名称
		 * @param	closure:Function — 一个闭包函数，指定JavaScript调用的函数
		 */
		public static function addCallback(functionName:String, closure:Function):void
		{
			if(available)
			{
				try
				{
					ExternalInterface.addCallback(functionName, closure);
					
					if(closure != null)
					{
						addFunctionNameToList(functionName);
					}
					else
					{
						removeFunctionNameFromList(functionName);
					}
				}
				catch(e : Error)
				{
					throw "[异常错误]：" + e.message;
				}
				catch(e : SecurityError)
				{
					throw "[安全错误]：" + e.message;
				}
			}
			else
			{
				throw ERROR_TXT;
			}
		}
		
		/**
		 * ActionScript调用外部容器方法
		 * @param	functionName:String — 一个字符串，外部容器中被AS调用的函数名
		 * @param	...rest — 传递到容器函数中的参数
		 * @return	 * — 从容器接收的响应。如果调用失败，则会返回 null 并引发错误。
		 */
		public static function call(functionName:String, ... rest):*
		{
			if(available)
			{
				try
				{
					rest.splice(0, 0, functionName);
					return ExternalInterface.call.apply(null, rest);
				}
				catch(e : Error)
				{
					throw "[异常错误]：" + e.message;
				}
				catch(e : SecurityError)
				{
					throw "[安全错误]：" + e.message;
				}
			}
			else
			{
				throw ERROR_TXT;
			}
		}
		
		/**
		 * 删除所有的回调函数注册
		 */
		public static function clearClosureFromList():void
		{
			if(!recordList)
			{
				return;
			}
			
			for each(var funcName : String in recordList)
			{
				addCallback(funcName, null);
			}
			recordList = null;
		}
		
		/**
		 * 添加函数名称到列表中
		 * @private
		 * @param	functionName:String — 一个字符串，需添加列表中的函数名
		 */
		private static function addFunctionNameToList(functionName:String):void
		{
			if(!recordList)
			{
				recordList = [];
			}
			
			for each(var funcName : String in recordList)
			{
				if(funcName == functionName)
				{
					return;
				}
			}
			recordList.push(functionName);
		}
		
		/**
		 * 从列表中删除指定函数名称
		 * @param	functionName:String —  一个字符串，需添加列表中的函数名
		 */
		private static function removeFunctionNameFromList(functionName:String):void
		{
			if(!recordList)
			{
				return;
			}
			
			for(var i:int = 0, length:int = recordList.length; i < length; i++)
			{
				if(recordList[i] == functionName)
				{
					recordList.splice(i, 1);
					return;
				}
			}
		}
		/**
		 * 是否 浏览器/容器嵌套 环境下。
		 * @return 
		 */
		private static function get available():Boolean
		{
			return ExternalInterface.available;
		}
		/**
		 * 设置一个布尔值，指示FlashPlayer与容器之前是否可以传递错误异常信息
		 */
		public static function set marshallExceptions(value:Boolean):void
		{
			ExternalInterface.marshallExceptions = value;
		}
		/**
		 * 获取浏览器地址栏中的参数部分
		 * @retrun Object对象 object[name] 获取,或使用 locationParamValueFromName 访问
		 */
		public static function get locationParams():Object
		{
			var params:Object = {}
			if(available)
			{
				var query:String = ExternalInterface.call("window.location.search.substring",1); 
				if(query) {
					var paris:Array = query.split("&"); 
					for(var i:uint=0; i<paris.length; i++) { 
						var pos:int = paris[i].indexOf("="); 
						if(pos!=-1) { 
							var argname:String = paris[i].substring(0,pos); 
							var value:String = paris[i].substring(pos+1); 
							params[argname] = value;
						}
					}
				}
			}
			return params;
		}
		/**
		 * 通过参数名称获取浏览器地址栏中的参数
		 * @param $name 参数名称
		 * @retrun String对象 
		 */
		public static function get locationParamValueFromName($name:String):String
		{
			var params:Object = locationParams();
			return params[$name]?params[$name]:"";
		}
		/**
		 * 获取Flashvars参数部分
		 * @param $stage 默认:null (纯flash项目 需传入stage实例)
		 * @retrun Object对象 object[name] 获取,或使用 flashvarsParamValueFromName 访问
		 */
		public static function get flashvarsParams($stage:Stage = null):Object
		{
			var params:Object = {};
			try
			{
				params = Class(getDefinitionByName("mx.core.FlexGlobals"))["topLevelApplication"]["parameters"];
			}
			catch(error:Error)
			{
				if( $stage )
				{
					params = $stage.loaderInfo.parameters;
				}
			}
			return params;
		}
		/**
		 * 通过参数名称获取flashvars中的参数
		 * @param $name 参数名称
		 * @param $stage 默认:null (纯flash项目 需传入stage实例)
		 * @retrun String对象
		 */
		public static function get flashvarsParamValueFromName($name:String,$stage:Stage):String
		{
			var params:Object = flashvarsParams($stage);
			return params[$name]?params[$name]:"";
		}
		
	}
}