﻿package com.zb.as3.util.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 单例模式 继承
	 *
	 * @author zbself
	 * @E-mail: zbself@qq.com
	 * @creation-time： 2015-1-1 上午11:45:20
	 * @from flashyiyi
	 */
	public class Singleton extends EventDispatcher
	{
		//静态单例字典
		private static var dict:Dictionary = new Dictionary();
		/**
		 * 构造函数
		 */
		 public function Singleton()
        {
        	var ref:Class = this["constructor"] as Class;
            if (dict[ref])
                throw new IllegalOperationError(getQualifiedClassName(this)+" 只允许实例化一次！");
            else
            	dict[ref] = this;
        }
		/**
         * 销毁方法
         * 
         */
        public function destory():void
        {
            var ref:Class = this["constructor"] as Class;
            delete dict[ref];
        }
		/**
         * 获取单例类，若不存在则返回空
         * 
         * @param ref	继承自Singleton的类
         * @return 
         * 
         */
        public static function getInstance(ref:Class):*
        {
            return dict[ref];
        }
		/**
         * 获取单例类，若不存在则创建
         * 
         * @param ref	继承自Singleton的类
         * @return 
         * 
         */        
        public static function getInstanceOrCreate(ref:Class):*
        {
        	if (dict[ref] == null)
        		dict[ref] = new ref();
        	
        	return dict[ref];
        }
		 /**
         * 创建单例类，若已创建则报错
         * 
         * @param ref	继承自Singleton的类
         * @return 
         * 
         */        
        public static function create(ref:Class):*
        {
        	dict[ref] = new ref();
        	return dict[ref];
        }
	}
}