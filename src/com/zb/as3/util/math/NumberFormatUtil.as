package com.zb.as3.util.math
{
	/**
	 * NumberFormatUtil<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 下午2:15:00 / 2017-3-17
	 * @see Eunjeong, Lee
	 */
	public class NumberFormatUtil
	{
		/**
		 * 1234567.890 -> 1,234,567.89
		 * @param $num
		 * @param $digit(default=0) 保留小数点位数
		 * @param $round(true) 默认四舍五入
		 * @return 
		 */		
		public static function withCommas( $num:Number, $digit:int=0, $round:Boolean=true ):String{
			var largeNumber:String = String( $num );
			var front:Array = largeNumber.split(".");
			var reg:RegExp=/\d{1,3}(?=(\d{3})+(?!\d))/g;
			front[0] = front[0].replace( reg,"$&," );
			if( $digit > 0 ){
				if( $round ){
					var pow:int = Math.pow( 10, $digit );
					var str:String = String( Math.round($num*pow)/pow );
					front[1] = str.split( "." )[1];
				}else{
					if( front[1] == undefined ) front[1] = "0";
					front[1] = front[1].substr( 0, $digit );
				}
				if( front[1] == undefined ) front[1] = "0";
				while( front[1].length<$digit ) front[1] += "0";
			}else front.splice( 1, 1 );
			return front.join(".");
		}
		
		/**
		 * 1000 -> 1k
		 * 1000000 -> 1m
		 * 1000000000 -> 1b
		 * 1000000000000 -> 1t
		 * 
		 * @param $num
		 * @param $capital(false)	
		 * @param $digit(default=2)		1.82k
		 * @param $round(true)			1.76k -> 1.8k
		 * @param $start(default=1000)  				
		 * @param $iteration			
		 * @return 
		 */		
		public static function withChar( $num:Number, $capital:Boolean=false, $digit:int=2, $round:Boolean=true, $start:int=1000, $iteration:int=0 ):String{
			if( $num < $start ) return withCommas( $num, 0, $round );
			var char:String = "kmbt";
			if( $capital ) char = "KMBT";
			var i:int = 0;
			var n:int = 1000;
			for( i; i<$iteration; i++ ){
				n = n*1000;
			}
			$num = $num/n;
			while( $num>=1000 && $iteration<char.length ){
				$num = $num/1000;
				$iteration ++;
			}
			var pow:int = Math.pow( 10, $digit );
			if( $round ) $num = Math.round( $num*pow )/pow;
			else $num = int( $num*pow )/pow;
			return withCommas( $num, $digit, false ) + char.charAt( $iteration );
		}
		/**
		 * 次序 缩写的序号缩写
		 * first, 1st
		 * second, 2nd
		 * third, 3rd
		 * fourth，4th
		 * 之后的数字都加th。
		 * 
		 * @param $order	21:21st、22:22nd、23:23rd、24:24th、25:25th
		 * @return 
		 */		
		public static function addOrdinal( $order:int ):String{
			if (( $order % 100 < 20 ) && ( $order % 100 > 10 )) {
				return "th";
			}else{
				switch (int($order%10)) {
					case 1:
						return "st";
					case 2:
						return "nd";
					case 3:
						return "rd";
				}
			}
			return "th";
		}
		
		private static const chineseMapping:Array = ["","一","二","三","四","五","六","七","八","九"];
		private static const chineseLevelMapping:Array = ["","十","百","千"]
		private static const chineseLevel2Mapping:Array = ["","万","亿","兆"]
		/**
		 * 转换为汉字数字
		 * 
		 */		
		public static function toChineseNumber(n:int):String
		{
			var result:String = "";
			var level:int = 0;
			while (n > 0)
			{
				var v:int = n % 10;
				if (level % 4 ==0)
					result = chineseLevel2Mapping[level / 4] + result;
				
				if (v > 0)
				{
					if (level % 4 == 1 && v == 1){
						result = chineseLevelMapping[level % 4] + result;
					}else{
						result = chineseMapping[v] + chineseLevelMapping[level % 4] + result;
					}
				}
				else
				{
					result = chineseMapping[v] + result;
				}
				n = n / 10;
				level++;
			}
			
			return result;
		}
		
		/**
		 * 在数字中添加千位分隔符
		 * 
		 */		 	
		public static function addNumberSeparator(value:Number):String
		{
			var result:String = "";
			while (value >= 1000)
			{
				var v:int = value % 1000;
				result =  "," + fillZeros(v.toString(),3) + result;
				value = Math.floor(value / 1000);
			}
			value = Math.floor(value);
			return result = String(value) + result;
		}
		
		/**
		 * 将数字用0补足长度
		 * len=2		5=05 10=10
		 */		
		public static function fillZeros(str:String, len:int, flag:String="0"):String
		{
			while (str.length < len) 
			{
				str = flag + str;
			}
			return str;
		}
		/**
		 * 位数差，后补齐字符
		 * 
		 * len=2		0.1=0.10
		 * 
		 */		
		public static function fillEndZeros(str:String, len:int, flag:String="0"):String
		{
			while (str.length < len) 
			{
				str =  str + flag;
			}
			return str;
		}
		public static function fillEndNumZeros(str:String , num:int , flag:String="0"):void
		{
			var i:int = 0;
			while(i<num)
			{
				str = str + flag;
				i++;
			}
		}
	}
}