package com.zb.as3.net.load.classLoader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * ClassLoader<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	public class ClassLoader extends EventDispatcher implements IClassLoader
	{
		
		public static const LOAD_ERR : String = "加载出错";
		public static const LOAD_COMPLETE : String = "加载完成";
		private var _loader : Loader;
		private var _isFree : Boolean = true;
		
		public function ClassLoader()
		{
			super();
			_loader = new Loader();
		}
		
		/**
		 * @param url 提供类定义的swf文件
		 * @param rsl 是否为运行时共享，默认false，如果为true，则在加载完成后所有需要用的地方可直接使用类定义而不必要用getClass
		 * @param cacheCode 破除缓存用的码
		 */
		public function loadFile(url : String, rsl : Boolean = false, cacheCode : String = "") : void
		{
			var context : LoaderContext;
			if (rsl)
			{
				// 子级和父级完全定义共享，但先到先得
				context = new LoaderContext(false, ApplicationDomain.currentDomain);
			}
			else
			{
				// 子级可用父级类定义，父级用子级的需要getClass
				context = new LoaderContext(false, null);
			}
			var urlRequest : URLRequest = new URLRequest(url);
			if (cacheCode)
			{
				urlRequest.data = new URLVariables("cacheCode=" + cacheCode);
			}
			_loader.load(urlRequest, context);
			_isFree = false;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompH);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorH);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorH);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressH);
		}
		
		private function onProgressH(event : ProgressEvent) : void
		{
			dispatchEvent(event);
		}
		
		private function onSecurityErrorH(event : SecurityErrorEvent) : void
		{
			trace("ClassLoader.onSecurityErrorH" + event.text);
			dispatchEvent(new Event(LOAD_ERR));
		}
		
		private function onIoErrorH(event : IOErrorEvent) : void
		{
			trace("ClassLoader.onIoErrorH," + event.text);
			dispatchEvent(event);
			// 兼容旧版
			
			dispatchEvent(new Event(LOAD_ERR));
		}
		
		private function onLoadCompH(event : Event) : void
		{
			dispatchEvent(event);
			// 兼容旧版
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		/**
		 * 获得加载的外部类定义
		 *  note1.只在加载完成后可用
		 *  note2.如果是rsl，则可直接获得类定义
		 */
		public function getClass(name:String) : Class
		{
			return _loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
		}
		/**
		 * 启用运行时共享 可以直接
		 */		
		private function getRSLObject(name:String):void
		{
//			var cls:Class =  getDefinitionByName(name) as Class;
//			var mc:MovieClip = new cls();
//			this.addChild( mc );
		}
		
		public function isFree() : Boolean
		{
			return _isFree;
		}
	}
}