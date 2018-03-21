package com.zb.as3.util
{
	import com.zb.as3.events.ZEvent;
	import com.zb.as3.util.short.debug;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * EventUtil 事件辅助类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2017-1-1
	 * @see flashyiyi
	 */
	public class EventUtil
	{
		/** 快捷事件派发的实例对象临时名称
		 */
		public static const singletonEventDispath:String = "_default_event_";
		
		static public var turnels:Dictionary=new Dictionary();
		/**
		 * 添加一个只执行一次的事件 
		 * @param target	事件目标
		 * @param type	事件类型
		 * @param handler	事件函数
		 * @param useParam	是否传入参数
		 * @param param	参数列表
		 * 
		 * @see 执行完毕 自动removeEventListener
		 */
		static public function addEventListenerOnce(target:IEventDispatcher, type:String, handler:Function, useParam:Boolean = false, param:Array = null):void
		{
			target.addEventListener(type,onceEventHandler);
			function onceEventHandler(e:Event):void
			{
				target.removeEventListener(type,onceEventHandler);
				if (useParam)
					handler.apply(null,param);
				else
					handler(e);
			}
		}
		/**
		 * 弃用 直接使用 EventUtil.on/off
		 * 快速注册移除事件
		 * @param addOrRemove    true注册事件 / false移除事件
		 * @param target    添加事件的对象
		 * @param eventType 添加的事件类型
		 * @param func 事件方法
		 */
		public static function eventListener(addOrRemove:Boolean, target:Object,eventType:String, func:Function):void
		{
			if(!target) return;
			if(target.hasEventListener(eventType))
			{
				if(!addOrRemove )	target.removeEventListener(eventType,func);
			}else
			{
				if( addOrRemove )	target.addEventListener(eventType,func);
			}
		}
		/**
		 * 注册事件
		 * @param eventType
		 * @param target
		 * @param func
		 */
		public static function on(eventType:String, func:Function, target:EventDispatcher=null):void
		{
			if(!target)	target = getInstance();
			target.addEventListener(eventType,func);
		}
		/**
		 * 移除事件
		 * @param eventType
		 * @param target
		 * @param func
		 */
		public static function off(eventType:String, func:Function, target:EventDispatcher=null):void
		{
			if(!target)	target = getInstance();
			if(target.hasEventListener(eventType))
			{
				try
				{
					target.removeEventListener(eventType,func);
				}
				catch(error:Error)
				{
					debug(error.toString());
				}
			}
		}
		/**
		 * 快捷派发 -  ZEvent
		 * @param eventType  事件类型
		 * @param data  事件的传递参数信息
		 * @param target 若空,默认使用全局单例对象( "_default_event_" )
		 */
		public static function send(eventType:String, info:*=null , target:EventDispatcher=null):void
		{
			if(target == null)
			{
				target = getInstance();
			}
			target.dispatchEvent(new ZEvent(eventType , info));
		}
		/**
		 * 快捷接收 - ZEvent
		 * @param eventType 事件类型
		 * @param listenerFunc 接收事件函数
		 * @param target 若空,默认使用全局单例对象( "_default_event_" )
		 */
		public static function listener(eventType:String, listenerFunc:Function, target:EventDispatcher=null):void
		{
			if(target){
				turnels[target] = target;
			}else{
				target = getInstance();
			}
			target.addEventListener(eventType, listenerFunc);
		}
		/** 移除事件者
		 * @param value
		 * @return
		 */
		public static function removeInstance(value:*=singletonEventDispath):EventDispatcher
		{
			if(value && turnels[value])
			{
				delete turnels[value];
				turnels[value] = null;
			}
			return turnels[value];
		}
		/** 获取事件者
		 * @param value
		 * @return
		 */
		public static function getInstance(value:String=singletonEventDispath):EventDispatcher
		{
			if(!turnels[value])
			{
				turnels[value] = new EventDispatcher();
			}
			return turnels[value];
		}
	}
}