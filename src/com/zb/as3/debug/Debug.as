package com.zb.as3.debug
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.system.Security;
	import flash.utils.getQualifiedClassName;

	/**
	 * Debug<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class Debug
	{
		/**
		 * 显示的Debug过滤通道列表，设置为null表示全部可以显示。
		 * 这种方法可以避免铺天盖地的trace造成的困扰。
		 */		
		public static var channels:Array;
		
		/**
		 * 是否处于DEBUG模式。系统可借助此属性来切换调试与非调试模式。
		 * 在非调试模式下，将禁用trace。因为自定义trace编译不会被自动删除，此属性对于提高效率是必须的。
		 */
		public static var DEBUG:Boolean = false;
		
		/**
		 * 记录日志用。实际运行时，可在程序出错后将客户端日志信息发送出去，做为服务端日志的有效补充。 
		 */		
		public static var logs:String = "";
		/**
		 * 是否激活日志记录 
		 */		
		public static var enabledLog:Boolean = false;
		
		/**
		 * 激活浏览器控制台，信息将同时输出到firebug/Chrome的控制台
		 */
		public static var enabledBrowserConsole:Boolean = false;
		/**
		 * 是否显示时间
		 */
		public static var showTime:Boolean = false;
		/**
		 * 日志发送的地址 
		 */		
		public static var logUrl:String;
		/**
		 * 出错时，执行的方法
		 */		
		public static var errorHandler:Function = defaultErrorHandler;
		
		public function Debug()
		{
			
		}
		/**
		 * 
		 * @param channel	使用的通道，设置为null则表示任何时候都会显示
		 * @return
		 */		
		public static function trace(channel:*, ...rest):void
		{
			var text:String = getHeader(channel)+ (rest as Array).join(",");
			if (DEBUG && (channels==null || channel==null || channels.indexOf(channel) != -1))
			{
				log( text );
			}
		}
		/**
		 * 出错时调用，将会将日志发送至服务器
		 * 
		 * @param text 错误信息
		 */
		public static function error(text:String=null):void
		{
			
			if (DEBUG && enabledBrowserConsole && ExternalInterface.available)
				ExternalInterface.call("console.error",text);
			
			errorHandler(text);
			
			if (logUrl)
			{
				var values:URLVariables = new URLVariables();
				values.log = logs;
				var req:URLRequest = new URLRequest(logUrl);
				req.data = values;
				sendToURL(req);
				
				logs = "";
			}
		}
		
		private static function defaultErrorHandler(text:String):void
		{
			if (text)
			{
				throw new Error(text);
			}
		}
		private static function getHeader(channel:*):String
		{
			var result:String = "";
			if (showTime)
			{
				var date:Date = new Date();
				result = "[" + date.hours +":"+ date.minutes+":"+ date.seconds +":"+ date.milliseconds + "]";
			}
			if (channel)
				result += "[" + channel + "]"
			
			return result;
		}
		/**
		 * 获得对象的值
		 * @param obj
		 * @param filters
		 * @return 
		 * 
		 */
		public static function getObjectValues(obj:Object,...filters):String
		{
			var result:String = getQualifiedClassName(obj);
			var key:*;
			if (filters && filters.length > 0)
			{
				for each (key in filters)
				result += " " + key + "=" + obj[key];
			}
			else
			{
				for (key in obj)
					result += " " + key + "=" + obj[key];
			}
			return result;
		}
		
		/**
		 * 判断是否在网络上
		 * @return 
		 * 
		 */
		public static function get isNetWork():Boolean
		{
			return Security.sandboxType == Security.REMOTE;
		}
		/**
		 * 判断是否在浏览器上
		 * @return 
		 * 
		 */
		public static function get isBrower():Boolean
		{
			return ExternalInterface.available;
		}
		
	}
}