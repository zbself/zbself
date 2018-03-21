package com.zb.as3.util.math
{
	/**
	 * DigitCombination<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class DigitCombination
	{
		//测试数组 计算
		public static var arrs:Array = [1,9];
		
		public function DigitCombination()
		{
			
		}
		/**
		 * 计算数组中 所有数字的互相组合总个数 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function getCombinations( arr:Array ):Array
		{
			
			var zhu:Array = new Array();
			for (var i:int = 1; i < (1 << arr.length); i++)//循环次数：2的N(数组长度)次方-1 Math.pow(2,arr.length).  [ 1 << arr.length 解释:1*2的n次方 (n等于数组长度) ]
			{
				var _arr:Array = new Array();
				for (var j:int = 0; j < arr.length; j++)
				{
					if ((i & 1 << j) != 0)
					{
						_arr.push(arr[j]);
					}
				}
				zhu.push(_arr);
			}
			return zhu;
		}
	}
}