package com.zb.as3.util.math
{
	/**
	 * MathUtil 算术类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2017-1-1
	 * @see flashyiyi , Jerry
	 */
	public class MathUtil
	{
		/**
		 * 快速获取输入数的绝对值（可以用来取代Math.abs方法，运算效率远高于Math.abs方法）
		 * @param	value:Number — 一个数字，输入值
		 * @return	int — 一个整数值，计算得到的输入数的绝对值
		 */
		public static function abs(value:Number):int
		{
			return (value ^ (value >> 31)) - (value >> 31);
		}
		
		/**
		 * 快速返回输入数的上限值（可以用来取代Math.ceil方法，运算效率远高于Math.ceil方法）
		 * @param	value:Number — 一个数字，输入值
		 * @return	int — 一个整数值，计算得到的输入数上限整数值
		 */
		public static function ceil(value:Number):int
		{
			return (value is int)?value >> 0:(value >> 0) + 1;
		}
		/**
		 * 快速返回输入数的下限值（可以用来取代Math.floor方法，运算效率远高于Math.floor方法）
		 * @param	value:Number — 一个数字，输入值
		 * @return	int — 一个整数值，计算得到的输入数下限整数值
		 */
		public static function floor(value:Number):int
		{
			return value >> 0;
		}
		
		/**
		 * 获取随机数
		 * @param	min:Number (default = 0) — 一个数字，随机数的最小值
		 * @param	max:Number (default = 1) 一 个数字，随机数的最大值
		 * @param	rounded:Boolean (default = true) — 一个布尔值，为true时对结果进行取整计算；为false时直接输出
		 * @return	Number — 一个数字，随机计算得到的数字
		 */
		public static function getRandomNum(min:Number = 0, max:Number = 1, rounded:Boolean = true):Number
		{
			return rounded ? round(Math.random() * (max - min) + min) : Math.random() * (max - min) + min;
		}
		
		/**
		 * 快速判断输入数值是否为偶数（相当于i = -i;）
		 * @param	value:int — 一个数字，输入值
		 * @return	Boolean — 一个布尔值，为true时，结果为偶数；为false时，结果为非偶数
		 */
		public static function isEven(value:int):Boolean
		{
			return (value & 1) == 0;
		}
		
		/**
		 * 快速判断输入数值是否为奇数
		 * @param	value:int — 一个数字，输入值
		 * @return	Boolean — 一个布尔值，为true时，结果为奇数；为false时，结果为非奇数
		 */
		public static function isOdd(value:int):Boolean
		{
			return (value & 1) == 1;
		}
		
		/**
		 * 判断是否是整数 
		 * @param $value
		 * @return 
		 * 
		 */		
		public static function isInteger($value:Number):Boolean
		{
			return ($value % 1) == 0;
		}
		
		/**
		 * 检测数值是否位于中间
		 * @param $value 检测的数(包括范围边际);
		 * @param $firstValue 范围1
		 * @param $secondValue 范围2
		 * @return 
		 * 
		 */
		public static function isBetween($value:Number, $firstValue:Number, $secondValue:Number):Boolean
		{
			return !($value < Math.min($firstValue, $secondValue) || $value > Math.max($firstValue, $secondValue));
		}
		
		/**
		 * 快速取反
		 * @param	value:Number — 一个数字，输入值
		 * @return	int — 一个整数值，计算得到输入值的取反值
		 */
		public static function not(value:Number):int
		{
			return ~value + 1;
		}
		
		/**
		 * 快速返回输入数的四舍五入值（可以用来取代Math.round方法，运算效率远高于Math.round方法）
		 * @param	value:Number — 一个数字，输入值
		 * @return	int — 一个整数值，计算得到的输入数的四舍五入整数值
		 */
		public static function round(value:Number):int
		{
			var source:Number = value;
			var result:int = (value >> 0);
			var decimal:Number = source - result;
			return (decimal < 0.5) ? result : (++result);
		}
		
		/**
		 * 定点表示法返回数字 
		 * @param	value:Number — 一个数字，输入值
		 * @param	fractionDigits:uint (default = 2) — 一个数字，保留的小数位数，此数字范围在0-20
		 * @return	Number — 使用定点表示法表示的数字
		 */		
		public static function toFixed(value:Number, fractionDigits:uint = 2):Number
		{
			fractionDigits = limitIn( fractionDigits , 0 , 20 );
			return Number(value.toFixed(fractionDigits));
		}
		
		/**
		 * 返回的是数学意义上的atan（坐标系与Math.atan2上下颠倒）
		 * 
		 * @param dx
		 * @param dy
		 * @return 
		 * 
		 */
		public static function atan2(dx:Number, dy:Number):Number
		{
			var a:Number;
			if (dx == 0) 
				a = Math.PI / 2;
			else if (dx > 0) 
				a = Math.atan(Math.abs(dy/dx));
			else
				a = Math.PI - Math.atan(Math.abs(dy/dx));
			
			return dy >= 0 ? a : -a;
		}
		
		/**
		 * 求和
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function sum(arr:Array):Number
		{
			var result:Number = 0.0;
			for each (var num:Number in arr)
			result += num;
			//				result = add(result,num);
			return result;
		}
		public static function add(value1:Number,value2:Number):Number
		{
			return value2 ? add(value1^value2, (value1&value2)<<1) : value1;
		}
		public static function adds(value1:Number,value2:Number):Number
		{
			return value1 + value2;
		}
		
		
		/**
		 * 平均值
		 *  
		 * @param arr
		 * @return 
		 * 
		 */
		public static function avg(arr:Array):Number
		{
			return sum(arr)/arr.length;
		}
		
		/**
		 * 最大值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function max(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] > result)
					result = arr[i];
			}
			return result;
		}
		
		/**
		 * 最小值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function min(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] < result)
					result = arr[i];
			}
			return result;
		}
		
		/**
		 * 将数值限制在一个区间内
		 * 
		 * @param v	数值  小=最小值 / 大=最大值
		 * @param min	最小值
		 * @param max	最大值
		 * 
		 */		
		public static function limitIn(v:Number,min:Number,max:Number):Number
		{
			return v < min ? min : v > max ? max : v;
		}
		
		/**
		 * 随机数 整数
		 * @param low 小数
		 * @param high 大数
		 * @return 中间随机数
		 * 
		 */		
		public static function getIntegerRandomBetween(low:int = 0, high:int = 1):int
		{
			return (Math.round(Math.random() * (high - low)) + low);
		}
		/**
		 * 随机数 整数
		 * @param low 小数
		 * @param high 大数
		 * @return 中间随机数
		 * 
		 */		
		public static function getNumberRandomBetween(low:Number = 0, high:Number = 1):Number
		{
			return (Math.random() * (high - low)) + low;
		}
		
	}
}