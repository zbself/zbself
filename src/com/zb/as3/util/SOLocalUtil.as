package com.zb.as3.util
{
	import com.zb.as3.util.StringUtil;
	import com.zb.as3.util.datetime.DateUtil;
	import com.zb.as3.util.short.debug;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.Dictionary;
	
	/**
	 * SharedObjectManager 本地缓存管理类<br>
	 * 提供SO的快速读写功能
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see spe,zrong
	 */
	public class SOLocalUtil
	{
		/**
		 * name 不支持的特殊字符,自动排除
		 */
		private static const DISALLOWED_CHARACTER:String = "~˜%&\\;:\" ',<>?#";
		public static var list:Dictionary = new Dictionary();
		/**
		 * 获取一个SOUtil的实例。如果该名称SOUtil存在，直接返回，否则就创建一个SO
		 * @param $name 要获取的so的名称。该名称可以包含正斜杠 (/)；例如，work/addresses 是合法名称。 共享对象名称中不允许使用空格，也不允许使用以下字符：  ~ % & \ ; : " ' , < > ? # 
		 * @param $localPath 创建了共享对象的 SWF 文件的完整路径或部分路径，这将确定共享对象的本地存储位置。如果未指定此参数，则使用完整路径。
		 * @param  $secure 是否仅限https访问
		 */
		public static function getSOUtil($name:String,$localPath:String="/",$secure:Boolean=false):SOLocalUtil
		{
			if(list[$name]) return list[$name] as SOLocalUtil;
			var __soutil:SOLocalUtil = new SOLocalUtil( new SingletonSOLocalUtil(), $name, $localPath, $secure);
			list[$name] = __soutil;
			return __soutil;
		}
		/**
		 * 列表中删除一个 SOUtil 实例。
		 * @param $name 
		 * @param $clear 删除前 实例是否进行清除 clear();
		 * 
		 */		
		public static function delSOUtil($name:String,$doClear:Boolean = false):void
		{
			var __soUtil:SOLocalUtil =  list[$name] as SOLocalUtil;
			if( __soUtil )
			{
				__soUtil.so.removeEventListener(NetStatusEvent.NET_STATUS, __soUtil.net_Status);
				//				__soUtil.so.removeEventListener(SyncEvent.SYNC, __soUtil.Sync)
				//				__soUtil.so.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, __soUtil.async_Error)
				if( $doClear )
				{
					__soUtil.clear();
				}
			}
			delete list[$name];
			$name = null;
		}
		
		private var _name:String;
		private var _so:SharedObject;
		/**
		 * 创建共享对象
		 * @param $sig 禁止实例化
		 * @param	name  对象的名称。 该名称可以包含正斜杠 (/)；例如，work/addresses 是合法名称。 共享对象名称中不允许使用空格，也不允许使用以下字符：  ~ % & \ ; : " ' , < > ? # 
		 * @param	localPath 创建了共享对象的 SWF 文件的完整路径或部分路径，这将确定共享对象的本地存储位置。 如果未指定此参数，则使用完整路径。
		 * @param	secure
		 */
		public function SOLocalUtil( $sig:SingletonSOLocalUtil,$name:String,$localPath:String="/",$secure:Boolean=false)
		{
			_name = $name;
			_so = createSO( $name , $localPath , $secure );
		}
		private function createSO( $name:String,$localPath:String,$secure:Boolean):SharedObject
		{
			$name = StringUtil.removes( $name , DISALLOWED_CHARACTER );//存在不允许特殊字符,自动删除
			
			var __so:SharedObject = SharedObject.getLocal($name, $localPath, $secure);
			__so.addEventListener(NetStatusEvent.NET_STATUS, net_Status);
			//			__so.addEventListener(SyncEvent.SYNC,Sync)
			//			__so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, async_Error)
			return __so;
		}
		/**
		 * 在服务器更新了远程共享对象后调度。
		 */
		private function Sync(e:SyncEvent):void{};
		/**
		 * 在异步引发异常（即来自本机异步代码）时调度。
		 */
		private function async_Error(e:AsyncErrorEvent):void{};
		/**
		 * 在 SharedObject 状态事件
		 */
		private function net_Status(e:NetStatusEvent):void 
		{
			trace('[so ',name,' netStatus ] :' ,e.info.code);
			switch (e.info.code) {
				case "SharedObject.Flush.Success":
					trace("User granted permission -- value saved.\n");
					break;
				case "SharedObject.Flush.Failed":
					trace("User denied permission -- value not saved.\n");
					break;
			}
		}
		/**
		 * 本地存储对象
		 */
		public function get so():SharedObject { return _so; }
		/**
		 * 本地对象数据
		 */
		public function get data():Object { return _so.data; }
		/**
		 * 本地对象名
		 */
		public function get name():String { return _name; }
		/**
		 * 数据大小
		 */
		public function size():uint { return _so.size; }
		/**
		 * 对于本地共享对象，清除所有数据并从磁盘删除共享对象。 
		 */
		public function clear():void { _so.clear(); }
		/**
		 * 对于本地共享对象，清除所有数据并从磁盘删除共享对象。 
		 */
		public function close():void { _so.close(); }
		/**
		 * 立即插入数据
		 * @return
		 */
		public function flush($miniDiskSpace:int=0):String
		{
			var result:String = null;
			try
			{
				result = so.flush($miniDiskSpace);
			}
			catch(error:Error)
			{
				debug( 'Could not write SharedObject to disk');
				Security.showSettings();
				Security.showSettings( SecurityPanel.LOCAL_STORAGE );
			}
			if( result != null )
			{
				switch(result)
				{
					case SharedObjectFlushStatus.PENDING:
					{
						debug( 'Requesting permission to save object...' );
						//同时 在此处响应 NetStatusEvent.NET_STATUS 事件，检测是否写入成功
						break;
					}
					case SharedObjectFlushStatus.FLUSHED:
					{
						debug( 'flushed to disk' );
						break;
					}
					default:
						break;
				}
			}
			return result;
		}
		/**
		 * 保存数据，如果不提供$name参数，则自动建立name
		 * @param $data 要保存的数据
		 * @param $name 数据的键名
		 */
		public function save($data:Object, $key:String=''):void
		{
			var __key:String;
			if($key)
			{
				__key = $key;
				_so.data[__key] = $data;
			}
			else
			{
				__key = 'auto_save_' + list().length;
				_so.data[__key] = $data;
			}
			//			_so.data['lastTime'] = new Date();
			var _date:String = DateUtil.getFormatedDateAndTime();
			_so.data['lastTime'] = DateUtil.createDateFromString( _date );
			trace( _so.data['lastTime'] + "     -lasttime");
			flush();
		}
		/**
		 * 是否拥有属性
		 * @param	value
		 * @return
		 */
		public function has($key:String):Boolean
		{
			return data[$key] != undefined;
		}
		/**
		 * 获取最后修改事件
		 * @return 
		 */		
		public function lastTime():Date
		{
			return get("lastTime");
		}
		/**
		 * 今天是否修改过
		 * @param $date null : 当前时间
		 */
		public function hasModifiedToday($date:Date = null):Boolean
		{
			var d:Date = lastTime();
			if( !d ) return false;
			
			if( $date == null )
				$date = new Date();
			return $date.fullYear == d.fullYear && $date.month == d.month && $date.date == d.date;
		}
		/**
		 * 获取$name键名的值
		 * @param $name
		 */	
		public function get($key:String):*
		{
			try 
			{
				return data[$key];
			} 
			catch(e:Error) { trace( 'fail to get' );};
			return null;
		}
		
		/**
		 * 删除$name键
		 * @param $name
		 * 
		 */	
		public function del($key:String):void
		{
			try 
			{
				delete data[$key];
			} 
			catch(e:Error) { trace('fail to delete' );};
		}
		/**
		 * 获取so中保存的所有键值对的数组
		 */	
		public function list():Array
		{
			var __list:Array = [];
			for(var __key:String in _so.data)
			{
				__list.push({name:__key, value:_so.data[__key]});
			}
			return __list;
		}
	}
}
class SingletonSOLocalUtil{	};