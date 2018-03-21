package com.zb.as3.net.load.easyloader
{
	import flash.events.Event;
	/**
	 * All the Event Type of easyLoader
	 * @author  liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 */
	public class EasyLoaderEvent extends Event
	{
		public static const PROGRESS:String = "easyLoaderEventProgress";
		public static const LOADING_ERROR:String = "loadingError";
		public static const COMPLETED :String= "completed";
		public static const PAUSE:String = "pause";
		public static const UNPAUSE:String = "unPause";
		public static const START:String = "start";
		public static const DISPOSE:String = "dispose";
		public static const CONFIG_INITED:String = "configInited"
		public static const CONFIG_INIT_ERROR:String = "configInitError"
		
		private var _data:Object
		
		public function EasyLoaderEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable)
		}
		
		public function set data(obj:Object):void {
			_data=obj
		}
		public function get data():Object {
			return _data
		}
		
	}
}