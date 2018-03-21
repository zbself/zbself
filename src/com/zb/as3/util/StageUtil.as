package com.zb.as3.util
{
	
	import com.zb.as3.events.StageEvent;
	import com.zb.as3.util.short.debug;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="activate", type="com.zb.as3.events.StageEvent")]
	[Event(name="deactivate", type="com.zb.as3.events.StageEvent")]
	[Event(name="resize", type="com.zb.as3.events.StageEvent")]
	[Event(name="not_allows_fullscreen", type="com.zb.as3.events.StageEvent")]
	
	/**
	 *  Stage的代理引用类
	 * 先设置 StageUtil.stage = stage;
	 * 
	 * 只有事件 需要监听 StageUtil.instance
	 */	
	public class StageUtil extends EventDispatcher
	{
		private static var _instance:StageUtil;
		private static var _stage:Stage;
		private static var _quality:String;
		private static var _fullScreen:String;
		private static var _align:String;
		private static var _scaleMode:String;
		
		private static var _activate:Boolean = false;
		private static var _resize:Boolean = false;
		
		public function StageUtil()
		{
			if(_instance)
			{
				throw new Error("Error: Use StageUtil.instance");
			}
		}
		/**
		 *	获取instance（ StageUtil.instance ）
		 * @return
		 */
		public static function get instance():StageUtil
		{
			if( _instance == null)
			{
				_instance = new StageUtil();
			}
			return _instance;
		}
		/**
		 * 关联当前stage
		 * @return 
		 */
		public static function get stage():Stage
		{
				return _stage;
		}
		public static function set stage(value:Stage):void
		{
			if(_stage == null)
			{
				_stage = value;
			}
		}
		/**
		 * 获取舞台的宽度
		 * @return 
		 * 
		 */		
		public static function get width():int
		{
			return stage ? stage.stageWidth:0;
		}
		/**
		 * 获取舞台的高度 
		 * @return 
		 * 
		 */		
		public static function get height():int
		{
			return stage ? stage.stageHeight:0;
		}
		/**
		 * 设置 舞台对齐方式<br>
		 * StageAlign 的静态值
		 * @param value
		 */
		public static function get align():String
		{
			return _align;
		}
		public static function  set align(value:String):void
		{
			if( _stage && value )
			{
				_align = stage.align = value;
			}
		}
		/**
		 * 设置 舞台全屏<br>
		 * StageDisplayState 的静态值
		 * @param value
		 */	
		public static function get fullScreen():String
		{
			return _fullScreen;
		}
		public static function  set fullScreen(value:String):void
		{
			if( _stage && value )
			{
				if( stage.allowsFullScreen )
				{
					_fullScreen = stage.displayState = value;
				}else{
					instance.dispatchEvent( new StageEvent( StageEvent.NOT_ALLOWS_FULLSCREEN ));
				}
				
			}
		}
		/**
		 * 设置 舞台品质<br>
		 * StageQuality 的静态值 
		 * @param value
		 */
		public static function get quality():String
		{
			return _quality;
		}
		public static function  set quality(value:String):void
		{
			if( _stage && value )
			{
				_quality = _stage.quality = value;
				
			}
		}
		/**
		 * 设置 舞台缩放模式<br>
		 * StageScaleMode 的静态值
		 * @param value
		 */
		public static function get scaleMode():String
		{
			return _scaleMode;
		}
		public static function  set scaleMode(value:String):void
		{
			if( _stage && value)
			{
				_scaleMode = stage.scaleMode = value;
			}
		}
		/**
		 * 获取当前的焦点对象 
		 * @return 
		 * 
		 */		
		public static function get focus():InteractiveObject
		{
			return _stage?stage.focus:null;
		}
		/**
		 * 设置焦点 
		 * @param o 需要被焦点的对象
		 * 
		 */		
		public static function set focus(child:InteractiveObject):void
		{
			if( _stage && child)
			{
				_stage.focus=child;
			}
		}
		public static function addChild(child:DisplayObject):void
		{
			if( _stage && child)
			{
				_stage.addChild(child);
			}
		}
		
		public static function removeChild(child:DisplayObject):void
		{
			if( _stage && child)
			{
				_stage.removeChild(child);
			}
		}
		/**
		 * 设置对象的深度 
		 * @param child
		 * @param index
		 */		
		public static function setChildIndex(child:DisplayObject,index:int):void
		{
			if( _stage && child && _stage.contains(child) )
			{
				_stage.setChildIndex(child,index);
			}
		}
		/**
		 * 添加舞台事件
		 * @param type
		 * @param listener
		 */		
		public static function addEventListener(type:String,listener:Function):void
		{
			if( _stage && type && (!_stage.hasEventListener(type)) )
			{
				_stage.addEventListener(type,listener,false,0.0,true);
			}
		}
		/**
		 * 删除舞台事件 
		 * @param type
		 * @param listener
		 */		
		public static function removeEventListener(type:String,listener:Function):void
		{
			if( _stage && type && _stage.hasEventListener(type) )
			{
				stage.removeEventListener(type,listener);
			}
		}
		
		/**
		 *  设置 舞台焦点（激活/冻结）监听（有时候需要设置减少渲染等工作，节能省电）<br>
		 * 	StageUtil.instance 派发 StageEvent.ACTIVATE / StageEvent.DEACTIVATE  事件接收
		 * @param value
		 * 
		 */
		public static function get activate():Boolean
		{
			return _activate;
		}
		public static function set activate(value:Boolean):void
		{
			_activate = value;
			if( _stage )
			{
				if( value )
				{
					if(!_stage.hasEventListener( Event.ACTIVATE ))
						_stage.addEventListener(Event.ACTIVATE,onActivate);
					if(!_stage.hasEventListener( Event.DEACTIVATE ))
						_stage.addEventListener(Event.DEACTIVATE,onActivate);
				}else{
					if(_stage.hasEventListener( Event.ACTIVATE ))
						_stage.removeEventListener(Event.ACTIVATE,onActivate);
					if(_stage.hasEventListener( Event.DEACTIVATE ))
						_stage.removeEventListener(Event.DEACTIVATE,onActivate);
				}
			}
		}
		private static function onActivate(e:Event):void
		{
			if( e.type == Event.ACTIVATE )
			{
				debug( "activate" );//舞台激活
				instance.dispatchEvent( new StageEvent( StageEvent.ACTIVATE ));
			}else if( e.type == Event.DEACTIVATE )
			{
				debug( "deactivate" );//舞台休眠
				instance.dispatchEvent( new StageEvent( StageEvent.DEACTIVATE ));
			}
		}
		public static function get resize():Boolean
		{
			return _resize;
		}
		/**
		 *  设置 舞台缩放监听<br>
		 * 	StageUtil.instance 派发 StageEvent.RESIZE 事件接收
		 * @param value
		 * 
		 */		
		public static function set resize(value:Boolean):void
		{
			_resize = value;
			if( _stage )
			{
				if( value )
				{
					if(!_stage.hasEventListener( Event.RESIZE ))
						_stage.addEventListener(Event.RESIZE,onResize);
				}else{
					if(_stage.hasEventListener( Event.RESIZE ))
						_stage.removeEventListener(Event.RESIZE,onResize);
				}
			}
		}
		private static function onResize(e:Event):void
		{
//			debug( "stageW : "+_stage.stageWidth +" —— stageH : "+_stage.stageHeight );
			instance.dispatchEvent( new StageEvent( StageEvent.RESIZE ));
		}
	}
}