package com.zb.as3.util
{
	import flash.utils.Dictionary;
	/**
	 * ArrayUtil 数组类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see flashyiyi
	 */
	public final class ArrayUtil
	{
		/**
		 * 创建一个数组
		 * @param length	长度
		 * @param fill	填充
		 * 
		 */
		public static function create(len:Array,fill:* = null):Array
		{
			len = len.concat();
			
			var arr:Array = [];
			var l:int = len.shift();
			for (var i:int = 0; i < l; i++)
			{
				if (len.length)
					arr[i] = create(len,fill);
				else
					arr[i] = fill;
			}
			return arr;
		}
		
		
		/**
		 * 将一个数组附加在另一个数组之后
		 * 
		 * @param arr	目标数组
		 * @param value	附加的数组
		 * 
		 */
		public function append(arr:Array,value:Array):void
		{
			arr.push.apply(null,value);
		}
		
		/**
		 * 获得两个数组的共用元素
		 * 
		 * @param array1	数组对象1
		 * @param array2	数组对象2
		 * @param result	共有元素
		 * @param array1only	数组1独有元素
		 * @param array2only	数组2独有元素
		 * @return 	共有元素
		 * 
		 */
		public static function hasShare(array1:Array,array2:Array,result:Array = null,array1only:Array = null,array2only:Array = null):Array
		{
			if (result == null)
				result = [];
			
			var array2dict:Dictionary = new Dictionary();
			var obj:*;
			for each (obj in array2)
				array2dict[obj] = null;
			
			if (array2only != null)
				var resultDict:Dictionary = new Dictionary();
			
			for each (obj in array1)
            {
                if (array2dict.hasOwnProperty(obj))
				{
					result[result.length] = obj;
					if (resultDict)
						resultDict[obj] = null;
				}
				else if (array1only != null)
				{
					array1only[array1only.length] = obj;
				}
			}
			
			if (array2only != null)
			{
				for each (obj in array2)
				{
					if (!resultDict.hasOwnProperty(obj))
						array2only[array2only.length] = obj;
				}
			}
			
            return result;
		}
		/**
		 * 获得数组中特定标示的对象
		 * 
		 * getMapping([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x",-2) //{x:-2:y:4}(x = -2)
		 * getMapping([[1,2],[3,4],[5,6]],0,3) //[3,4](第一个元素为3)
		 *  
		 * @param arr	数组
		 * @param value	值
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getMapping(arr:Array, field:*,value:*):Object
        {
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
            	
                if (o[field] == value)
                	return o;
            }
            return null;
        }
        /**
		 * 获得数组中某个键的所有值
		 * 
		 * getFieldValues([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x")	//[0,-2,4]
		 *  
		 * @param arr	数组
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getFieldValues(arr:Array, field:*):Array
        {
        	var result:Array = [];
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
            	
                result[i] = o[field];
            }
            return result;
        }
		
		/**
		 * 数组中 补充数量的键值
		 * 返回新数组，不改变原数组。
		 * @param arr	数组
		 * @param num 数组总长度，原数组为空则使用obj补充。
		 * @param obj	补充值
		 * @return 新数组
		 * 
		 */
		public static function fullNumKeys(arr:Array, num:int, obj:*):Array
		{
			var result:Array = [];
			for (var i:int = 0;i<num;i++)
			{
				var o:* = arr[i] ? arr[i] : obj;
				result[i] = o;
			}
			return result;
		}
		/**
		 * 复制数组 
		 * @param arr
		 * @return 
		 */		
		public static function fullCopy(arr:Array):Array
		{	
			return arr.slice();
		}
		/**
		 * 去掉数组中 重复的对象
		 * @param arr
		 * @return 返回新数组
		 * 
		 */		
		public static function uniqueCopy(arr:Array):Array
		{
			var newArray:Array = new Array();
			var len:Number = arr.length;
			var item:Object;
			for (var i:uint = 0; i < len; ++i)
			{
				item = arr[i];
				if(containsValue(newArray, item))
				{
					continue;
				}
				newArray.push(item);
			}
			return newArray;
		}
		/**
		 * 数组移除该元素
		 * @param value
		 * @param arr
		 * @return 被删除的元素，没有则返回 null
		 */		
		public static function splice(value:Object,arr:Array):*
		{
			var index:int =  arr.indexOf(value);
			return  index != -1 ? arr.splice( index , 1 ) : null;
		}
		public static function containsValue(arr:Array, value:Object):Boolean
		{
			return arr.indexOf(value) != -1;
		}
		/**
		 * 判断两个数组 全等 
		 * @param arr1
		 * @param arr2
		 * @return 
		 * 
		 */
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			for(var i:Number = 0; i < arr1.length; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			return true;
		}
	}
}