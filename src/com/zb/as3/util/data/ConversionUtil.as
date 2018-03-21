package com.zbself.as3.framework.utils.data
{
	/**
	 * 数据形式转换 
	 */
	public final class ConversionUtil
	{
		/**
		 * 逗号分隔的ASC转换为数组 
		 * @param source
		 * @return （以逗号，区分的一维数组）
		 * 
		 */
		public static function ASCToArray(source:String):Object
		{
			var data:Array = source.split("\n");
			for (var i:int = 0;i<data.length;i++)
			{
				var text:String = data[i];
				text = text.replace("\r","");
				data[i] = text.split(",");
			}
			return data;
		}
		
		/**
		 * 对象数组转换为带标题二维数组 
		 * @param source
		 * @return （增加第一组数组 0—Max索引）
		 * 
		 */
		public static function objectArrayToTitleArray(source:Array):Array
		{
			if (source.length == 0)
				return [];
			
			var result:Array = [];
			var key:*;
			var arr:Array;
			arr = [];
			for (key in source[0])
				arr.push(key);
			result.push(arr);
			
			for (var i:int = 0; i < source.length; i++)
			{
				arr = [];
				var data:Object = source[i];
				for (key in data)
					arr.push(data[key]);
				result.push(arr);	
			}
			return result;
		}
		
		/**
		 * 带标题二维数组转换为对象数组 
		 * @param source
		 * @return （通过objectArrayToTitleArray转化的标题数组 转化为 对象数组）普通数组不可以使用该方法，会导致去掉第一维数组
		 * 
		 */
		public static function titleArrayToObjectArray(source:Array,itemClass:Class = null):Array
		{
			if (source.length <= 1)
				return [];
			
			var result:Array = [];
			for (var i:int = 1; i < source.length; i++)
			{
				var data:Object = itemClass ? new itemClass() : new Object();
				for (var j:int = 0;j < source[0].length;j++)
					data[source[0][j]] = source[i][j];
				result.push(data);	
			}
			return result;
		}
		
		/**
		 * 对象数组转换为单一对象 
		 * @param source
		 * @return 获取对象数组（新对象.源数组[key]=源数组[value]）
		 */
		public static function arrayToObject(source:Array,key:String,value:String):Object
		{
			if (!source)
				return null;
			
			var result:Object = {};
			for (var i:int = 0; i < source.length; i++)
			{
				result[source[i][key]] = source[i][value];
			}
			return result;
		}
		
		/**
		 * 过滤对象数组列 （一维数组）
		 * @param source 源数组
		 * @param filter 过滤保留的属性数组
		 * 
		 * ConversionUtil.filterObjectArray( [{"a1":"aa","b1":"bb","c1":"cc","d1":"dd"}] ,["a1","b1"]); // [{"a1":"aa","b1":"bb"}]
		 * @return 
		 */
		public static function filterObjectArray(source:Array,filter:Array):Array
		{
			var i:int;
			for (i = 0; i < source.length;i++)
			{
				var newObj:Object = {};
				for (var j:int = 0;j < filter.length;j++)
				{
					var key:* = filter[j];
//					newObj[key] = source[i][key];
					newObj[i] = source[i][key];
				}
				source[i] = newObj;
			}
			
			return source;
		}
		
		/**
		 * 过滤数组列  （通过objectArrayToTitleArray转化的标题数组 转化为 对象数组）<br>
		 * 修改代码 新索引顺序填充/滤值对应的索引值填充
		 * @param source 源数组
		 * @param filter 标题数值 [0,1,2,3];//过滤提取titile数值为 0,1,2,3 的索引值，
		 * @return 
		 */
		public static function filterTitleArray(source:Array,filter:Array):Array
		{
			var i:int;
			var newHeader:Array = [];
			var arr:Array = [];
			for (i = 0; i < filter.length;i++)
			{
				trace("source0   "+source[0]);
				var index:int = source[0].indexOf(filter[i]);
				if (index != -1)
				{
					arr.push(index);
					newHeader.push(filter[i]);
				}
			}
			filter = arr;
			
			source = source.slice(1);
			for (i = 0; i < source.length;i++)
			{
				var newObj:Array = [];
				for (var j:int = 0;j < filter.length;j++)
				{
					var key:* = filter[j];
					newObj[j] = source[i][key];//依次索引 填充
					newObj[key] = source[i][key];//按过滤值对应的索引值 填充
				}
				source[i] = newObj;
			}
			source.unshift(newHeader);
			return source;
		}
	}
}