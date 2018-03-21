package com.zbself.as3.framework.net.socket
{
	import com.zb.as3.interfaces.ISocket;
	import com.zb.as3.net.socket.PacketBuffer;
	import com.zb.as3.net.socket.SocketBoxSendMode;
	import com.zbself.as3.framework.events.SocketBoxEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	[Event(name="connecting",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	[Event(name="connect_success",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	[Event(name="receiving_data",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	[Event(name="received_data",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	[Event(name="error",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	[Event(name="close",type="com.zbself.as3.framework.events.SocketBoxEvent")]
	/**
	 * SocketBox<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class SocketBox extends EventDispatcher implements ISocket
	{
		private var _host:String;
		private var _port:int = 8080;
		
		private var _socket:Socket;
		
		/**
		 * 出错时执行的方法
		 */
		public var faultHander:Function;
		
		protected var cache:ByteArray;
		
		/**
		 * socket 通讯的模式：简易/高级【SocketBoxEvent 的静态属性】<br>
		 * 简易模式 使用 writeUTFBytes、readUTFBytes<br>
		 * 高级模式使用拆包/验证模式<br>
		 */	
		public var mode:String = 'simple';
		/**
		 * PacketMode=false；简单模式的数据值
		 */
		public var message:String = '';
		
		
		private static var _instance:SocketBox;
		public function SocketBox($sig:Singleton)
		{
			//实例化
			__init();
			
		}
		/**
		 * 获取单例 
		 * @param $host
		 * @param $port
		 * @return 
		 */		
		public static function getInstance($host:String = "localhost" , $port:int = 80):SocketBox
		{
			if( _instance == null )
			{
				_instance = new SocketBox( new Singleton() );
			}
			_instance._host = $host;
			_instance._port = $port;
			return _instance;
		}
		/**
		 *	发送信息
		 * @param value  简易模式：String  高级模式：ByteArray( 接收未全 )<br>
		 * 
		 * @return 成功发出
		 */
		public function __send(value:*):Boolean
		{
			trace("Socket -------------- " + value +"~~~~"+mode );
			switch(mode)
			{
				case SocketBoxSendMode.SIMPLE:
				{
					if( value is String)
					{
						return sendSimple( value );
					}else{
						trace( '简易模式 请写入String值' );
					}
					break;
				}
				case SocketBoxSendMode.ADVANCED:
				{
					if( value is ByteArray)
					{
						return sendAdvanced( value );
					}else{
						trace( '高级模式 请写入String值' );
					}
					break;
				}
				default:
					break;
			}
			return false;
		}
		public function __init():void
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,socketConnectedHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,receiveDataHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,socketIoErrorHandler);
			_socket.addEventListener(IOErrorEvent.NETWORK_ERROR,socketIoErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			_socket.addEventListener(Event.CLOSE,socketServerCloseHandler);
			
			this.cache = new ByteArray();
		}
		private function socketConnectedHandler(e:Event):void
		{
			//Socket连接成功
			trace("SOCKET CONNECT ");
			this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.CONNECT_SUCCESS , e.toString()) );
		}
		
		protected function socketServerCloseHandler(e:Event):void
		{
			trace("socket服务器关闭");
			trace("close");
			this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.CLOSE , e.toString()) );
		}
		protected function receiveDataHandler(event:ProgressEvent):void
		{
			if( mode == SocketBoxSendMode.SIMPLE )
			{
				message = _socket.readUTFBytes(_socket.bytesAvailable);
				message = message.split("\n")[0];//删除末尾\n
			}
			else
			{
				//message mode 复杂模式
				
			}
			this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.RECEIVED_DATA , message ) );
		}
		private function socketIoErrorHandler(e:IOErrorEvent):void
		{
			//IO错误
			trace("IO");
			this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.Error , e.toString()) );
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			//安全沙箱错误
			trace("沙箱");
			this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.Error , e.toString()) );
		}
		
		/**
		 * 简易模式 发送String 
		 * @param value
		 * @return 是否成功发出
		 * 
		 */		
		private function sendSimple( $value:String ):Boolean
		{
			try
			{
				if( __connected )
				{
					socket.writeUTFBytes( $value );
					__flush();
					trace( "send : "+$value );
					return true;
				}else{
					trace('No socket connection');
				}
			}
			catch(error:Error)
			{
				trace( error.message );
			}
			return false;
		}
		private function sendAdvanced( $bytesArray:ByteArray ):Boolean
		{
			try
			{
				if( __connected )
				{
					var __tempBuffer:ByteArray = PacketBuffer.getSendBA(100,$bytesArray );
					_socket.writeBytes(__tempBuffer , 0 , __tempBuffer.length );
					__flush();
					trace( "send : "+ __tempBuffer);
					return true;
				}else{
					trace('No socket connection');
				}
			} 
			catch(error:Error) 
			{
				trace( error.message );
			}
			return false;
		}
		/**
		 * 将缓存区的数据 刷新发送
		 */		
		public function __flush():void
		{
			if( socket )
				socket.flush();
		}
		/**不使用*/
		public function __go():void
		{
		}
		/**
		 * 关闭Socket连接
		 */		
		public function __close():void
		{
			if( socket )
				socket.close();
		}
		/**
		 * 连接Socket ( 需要先提供 host & port )
		 */		
		public function __connect():void
		{
			if( socket && (!socket.connected) )
			{
				this.dispatchEvent( new SocketBoxEvent( SocketBoxEvent.CONNECTING ));
				socket.connect( host , port );
				trace("connect");
			}
		}
		/**
		 * 注销 清理（不再使用）
		 */
		public function __dispose():void
		{
			if( socket )
			{
				_socket.removeEventListener(Event.CONNECT,socketConnectedHandler);
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA,receiveDataHandler);
				_socket.removeEventListener(IOErrorEvent.IO_ERROR,socketIoErrorHandler);
				_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				_socket.removeEventListener(Event.CLOSE,socketServerCloseHandler);
				_socket = null;
			}
			host = null;
			port = null;
			cache = null;
			faultHander = null;
		}
		/**
		 * 表示此 Socket 对象目前是否已连接。如果该套接字当前已连接，则对此属性的调用将返回值 true，否则将返回 false。
		 */		
		public  function get __connected():Boolean
		{
			return socket ? socket.connected : false;
		}
		/**
		 * 获取Socket实例
		 */		
		public function get socket():Socket
		{
			return _socket;
		}
		/**
		 * 设置Socket 地址
		 */
		public function get host():String
		{
			return _host;
		}
		public function set host(value:String):void
		{
			_host = value;
		}
		/**
		 * 设置Socket 端口
		 */
		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}
	}
}
class Singleton{}//不再单例 废弃不用