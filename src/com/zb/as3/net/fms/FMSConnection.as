package com.zb.as3.net.fms
{
	import com.zb.as3.interfaces.INection;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	/**
	 * SYNCConnection<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class FMSConnection implements INection
	{
		private var nc:NetConnection = new NetConnection();
		
		private var _ncURL:String;
		private var _client:Object = null;
		public function FMSConnection()
		{
			__init();
			
		}
		
		public function __call(...args):void
		{
		}
		
		public function __connect(command:String, ...args):void
		{
			if( command && nc )
			{
				ncURL = command;
				nc.connect( command , args );
			}
		}
		
		public function __go():void
		{
		}
		
		public function __init():void
		{
			nc.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			nc.client = this;
		}
		
		protected function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					trace("FMS连接成功 , URL : "+ncURL);
					break;
				case "NetConnection.Connect.Rejected":
					trace("You're rejected!");
				case "NetConnection.Connect.Failed":
					trace("Connect Failed");
					break;
			}
		}
		
		public function get ncURL():String
		{
			return _ncURL;
		}

		public function set ncURL(value:String):void
		{
			_ncURL = value;
		}
		/**
		 * 设置 NetConnection.Client<br>
		 * 默认： this
		 */
		public function get client():Object
		{
			return _client;
		}
		public function set client(value:Object):void
		{
			_client = value;
			if( value && nc )
			{
				nc.client = value;
			}
		}
		/**
		 * 关闭NC<br>
		 * 关闭本地打开的连接或到服务器的连接，并调度 netStatus 事件，code 属性值为 NetConnection.Connect.Closed。
		 */
		public function __close():void
		{
			if(nc)	nc.close();
		}
		public function __dispose():void
		{
			__close();
			if(nc)
			{
				nc.removeEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
				nc = null;
			}
		}


	}
}