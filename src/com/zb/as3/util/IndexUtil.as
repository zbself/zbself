package com.zbself.as3.framework.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * IndexUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class IndexUtil
	{
		/**
		 * 针对数组 将某元素排首位
		 * @param value
		 * @param array
		 * @return 
		 * 
		 */
		public static function bring2First( value:*,array:Array ):Array
		{
			var idx:int = array.indexOf( value );
			if( idx != -1 && idx != 0 )
			{
				array.splice( idx,1 );
				array.splice( 0,0,value );
			}
			return array;
		}
		/**
		 * 针对数组 将某元素排末位
		 * @param value
		 * @param array
		 * @return 
		 * 
		 */		
		public static function bring2End( value:*,array:Array):Array
		{
			var idx:int = array.indexOf( value );
			if( idx != -1 && idx != array.length-1 )
			{
				array.splice( idx,1 );
				array.splice( array.length,0,value );
			}
			return array;
		}
		/**
		 * 针对可视对象 将对象置于父级容器顶层 
		 * @param value
		 * 
		 */		
		public static function bring2Top( value:DisplayObject ):void
		{
			var parent:DisplayObjectContainer = value.parent;
			if(parent == null) return;
			var maxIndex:int = parent.numChildren-1;
			if(parent.getChildIndex(value) != maxIndex){
				parent.setChildIndex(value, maxIndex);
			}
		}
		/**
		 * 针对可视对象 将对象置于父级容器底层 
		 * @param value
		 * 
		 */		
		public static function bring2Bottom( value:DisplayObject ):void
		{
			var parent:DisplayObjectContainer = value.parent;
			if(parent == null){ return; }
			if(parent.getChildIndex(value) != 0){
				parent.setChildIndex(value, 0);
			}
		}
		/**
		 * 是否在显示对象父级最顶层
		 */
		public static function isTop(mc:DisplayObject):Boolean{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null) return true;
			return (parent.numChildren-1) == parent.getChildIndex(mc);
		}
		
		/**
		 * 是否在显示对象父级最底层
		 */
		public static function isBottom(mc:DisplayObject):Boolean{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null) return true;
			var depth:int = parent.getChildIndex(mc);
			if(depth == 0){
				return true;
			}
			return false;
		}
		/**
		 * aboveMC 刚好在 mc 的上层。
		 * 父级不同 直接返回：false
		 * 间隔索引：1
		 */
		public static function isJustBelow(mc:DisplayObject, aboveMC:DisplayObject):Boolean{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null) return false;
			if(aboveMC.parent != parent) return false;
			
			return parent.getChildIndex(mc) == parent.getChildIndex(aboveMC)-1;
		}
		/**
		 * belowMC 在 mc 的下层。
		 * 父级不同 直接返回：false
		 * 间隔索引：1
		 */	
		public static function isJustAbove(mc:DisplayObject, belowMC:DisplayObject):Boolean{
			return isJustBelow(belowMC, mc);
		}
		/**
		 * aboveMC 在 mc 的上层。
		 * 父级不同 直接返回：false
		 */
		public static function isBelow(mc:DisplayObject, aboveMC:DisplayObject):Boolean{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null) return false;
			if(aboveMC.parent != parent) return false;
			
			return parent.getChildIndex(mc) < parent.getChildIndex(aboveMC);
		}
		/**
		 * belowMC 在 mc 的下层。
		 * 父级不同 直接返回：false
		 */	
		public static function isAbove(mc:DisplayObject, belowMC:DisplayObject):Boolean{
			return isBelow(belowMC, mc);
		}
	}
}