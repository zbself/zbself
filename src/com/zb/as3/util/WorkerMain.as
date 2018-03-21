package com.zb.as3.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	/**
	 * WorkerMain<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class WorkerMain extends Object
	{
		private var works:Vector<Worker>;
		
		private var worker:Worker;
		private var _root:DisplayObject;
		
		/** maintoworker 通道
		 */
		protected var mainToWorker:MessageChannel;
		/** workertomain 通道
		 */
		protected var workerToMain:MessageChannel;
		
		/** WORKER_STATE 事件的回调函数
		 * */
		public var workerStateFunc:Function;
		public var isSupported:Boolean;
		/**
		 * 共享字节组
		 */
		public var shareBytes:ByteArray;
		
		/**
		 * 主类 [this]
		 */
		public function WorkerMain( $root:DisplayObject )
		{
			_root = $root;
			
			init();
			super();
		}
		private function init():void
		{
			isSupported = Worker.isSupported;
			if( isSupported )
			{
				//创建共享字节组
				shareBytes = new ByteArray();
				shareBytes.shareable = true;
				
				if( Worker.current.isPrimordial )//主线程
				{
					worker = WorkerDomain.current.createWorker( _root.loaderInfo.bytes );
					worker.addEventListener(Event.WORKER_STATE, workerStateFunc ? workerStateFunc : workStateHandler );
					
					mainToWorker = Worker.current.createMessageChannel( worker );
					worker.setSharedProperty( 'mtw',mainToWorker );
					
					workerToMain = worker.createMessageChannel( Worker.current );
					worker.setSharedProperty( 'wtm',workerToMain );
					workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWToM);
					
					//worker.setSharedProperty('key',true);
				}else{
					//var foo:Boolean = Worker.current.getSharedProperty("foo");
					mainToWorker = Worker.current.getSharedProperty("mtw");
					workerToMain = Worker.current.getSharedProperty("wtm");
					
					mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMToW);
					
				}
			}
		}
		public function start():void
		{
			if( worker ) worker.start();
		}
		protected function onWToM(event:Event):void
		{
			
		}
		protected function onMToW(event:Event):void
		{
			
		}
		protected function workStateHandler(event:Event):void
		{
			trace();
		}
	}
}