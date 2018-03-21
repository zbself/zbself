package com.zb.as3.net.socket
{
	public class SocketCache
	{
		private static var _instance:SocketCache;
		
		public function SocketCache()
		{
		}
		public static function get instance():SocketCache
		{
			if( _instance==null )
				_instance = new SocketCache();
			return _instance;
		}
		/**
		 * 
		 */		
		public var list:Array = [];
	}
}