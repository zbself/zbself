package com.zb.as3.util.datetime
{
	import com.zb.as3.util.math.NumberFormatUtil;
	/**
	 * 时间格式 类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see pethan,lee
	 */
	public class TimeUtil {
		
		//-----------------------------------------------------------------------------------
		//---------------------------------时间长度 格式化--------------------------------
		//-----------------------------------------------------------------------------------
		/**
		 * 西方格式的时间：00:01:01.010
		 */
		public static const ENGLISH_FULL_TIME : String = "English_Full_Time";
		/**
		 * 缩写的西方格式时间： 1:1.10
		 */
		public static const ENGILSH_SHORT_TIME : String = "English_Short_Time";
		/**
		 * 中方格式时间：00小时01分钟01秒010毫秒
		 */
		public static const CHINESE_FULL_TIME : String = "Chinese_Time";
		/**
		 * 中方格式时间：1分钟1秒10毫秒
		 */
		public static const CHINESE_SHORT_TIME : String = "Chinese_Short_Time";
		/**
		 * 简单的中方时间：00时01分01秒010毫秒
		 */
		public static const CHINESE_SIMPLE_FULL_TIME : String = "Chinese_Simple_Time";
		/**
		 * 简单缩写的中方时间：1分1秒10毫秒
		 */
		public static const CHINESE_SIMPLE_SHORT_TIME : String = "Chinese_Simple_Short_Time";
		
		/**
		 * 时间长度格式化 6种格式化
		 * @param time 单位：milliSecond 毫秒
		 * @param type TimeUtil. 类型（暂时6种）
		 * @param needMS 是否显示毫秒
		 * @return 
		 */		
		public static function number2TimeString(time:int,type:String,needMS:Boolean=false):String
		{
			var milliSecond:int = time % 1000;
			time *= 0.001;
			var hour : int = time / 3600;
			//分钟
			time = time % 3600;
			var minitue : int = time / 60;
			//秒
			var second : int = time % 60;
//			trace( hour +"~"+minitue+"~"+second+"~"+milliSecond);
			return TimeUtil.toTimeFormat(hour, minitue, second, milliSecond, type,needMS);
		}
		/**
		 * 得到时间格式的字符串 (6种进行格式化.)
		 * @param h		小时
		 * @param m		分钟
		 * @param s		秒
		 * @param ms 	毫秒 //除非有值 不然默认不显示毫秒
		 * @param type	TimeUtil. 静态属性类型.是否带单位字符串
		 * @param needMS 是否显示毫秒
		 * 
		 * @see 转换更复杂类型 使用 NumberUtil（时间长度，时间，日期）
		 */
		public static function toTimeFormat(h:int,m:int,s:int,ms:int,type:String=ENGLISH_FULL_TIME,needMS:Boolean=false):String
		{
			var ret:String = "";
			switch(type) {
				case ENGLISH_FULL_TIME:
					ret = getFull(h) + ":" + getFull(m) + ":" + getFull(s) + (needMS? "."+msFormat(ms):"");
					break;
				case ENGILSH_SHORT_TIME:
					ret = getSimple(h, ":") + getSimple(m, ":") + s + (needMS? "."+ms:"");
					break;
				case CHINESE_SIMPLE_FULL_TIME:
					ret = getFull(h) + "时" + getFull(m) + "分" + getFull(s) + "秒"+ (needMS?msFormat(ms)+"毫秒":"");
					break;
				case CHINESE_SIMPLE_SHORT_TIME:
					ret = getSimple(h, "时") + getSimple(m, "分") + getSimple(s, "秒") +  (needMS?getSimple(ms,"毫秒"): "");
					break;
				case CHINESE_FULL_TIME:
					ret = getFull(h) + "小时" + getFull(m) + "分钟" + getFull(s) + "秒"+ (needMS?msFormat(ms)+"毫秒":"");
					break;
				case CHINESE_SHORT_TIME:
					ret = getSimple(h, "小时") + getSimple(m, "分钟") + getSimple(s, "秒") + (needMS?getSimple(ms,"毫秒"):"");
					break;
			}
			return ret;
		}
		//得到完整的时间
		private static function getFull(num:int):String
		{
			return (num < 10) ? "0"+num.toString():num.toString();
		}
		//只针对毫秒格式化
		private static function msFormat(num:int):String
		{
			var str:String = '';
			if(num<10) str = "00"+num.toString();
			else if( (num>=10 )&&(num<100) ) str = "0"+num.toString();
			else str = num.toString();
			return str;
		}
		//获取非0的字符
		private static function getSimple(num:int,format:String):String
		{
			return (num != 0) ? num+format : "";
		}
		
		
		/**
		 * 将时间转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式<br>（hh:mm , h:m , hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h点m分s秒，H点M分S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toTimeString(date:Date,format:String="hh:mm:ss",utc:Boolean = false):String
		{
			var h:int = utc ? date.hoursUTC : date.hours;
			var m:int = utc ? date.minutesUTC : date.minutes;
			var s:int = utc ? date.secondsUTC : date.seconds;
			var ms:Number = (utc ? date.millisecondsUTC : date.milliseconds) / 10;
			
			switch (format)
			{
				case "hh:mm":
					return NumberFormatUtil.fillZeros(h.toString(),2) + ":" + NumberFormatUtil.fillZeros(m.toString(),2);
					break;
				case "h:m":
					return h + ":" + m;
					break;
				case "hh:mm:ss":
					return NumberFormatUtil.fillZeros(h.toString(),2) + ":" + NumberFormatUtil.fillZeros(m.toString(),2) + ":" + NumberFormatUtil.fillZeros(s.toString(),2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return NumberFormatUtil.fillZeros(h.toString(),2) + ":" + NumberFormatUtil.fillZeros(m.toString(),2) + ":" + NumberFormatUtil.fillZeros(s.toString(),2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h点m分s秒":
					return (h ? (h + "点"):"") + (m ? (m + "分"):"") + s + "秒";
					break;
				case "H点M分S秒":
					return (h ? (NumberFormatUtil.toChineseNumber(h) + "点"):"") + (m ? (NumberFormatUtil.toChineseNumber(m) + "分"):"") + NumberFormatUtil.toChineseNumber(s) + "秒";
					break;
			}
			return date.toString();
		}
		
		/**
		 * 将时间长度转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式<br>（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h小时m分钟s秒，H小时M分钟S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDurTimeString(time:Number,format:String="hh:mm:ss"):String
		{
			var ms:Number = (time % 1000) / 10;
			time /= 1000;
			var s:int = time % 60;
			time /= 60;
			var m:int = time % 60;
			time /= 60;
			var h:int = time;
			
			switch (format)
			{
				case "hh:mm:ss":
					return NumberFormatUtil.fillZeros(h.toString(),2) + ":" + NumberFormatUtil.fillZeros(m.toString(),2) + ":" + NumberFormatUtil.fillZeros(s.toString(),2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return NumberFormatUtil.fillZeros(h.toString(),2) + ":" + NumberFormatUtil.fillZeros(m.toString(),2) + ":" + NumberFormatUtil.fillZeros(s.toString(),2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h小时m分钟s秒":
					return (h ? (h + "小时"):"") + (m ? (m + "分钟"):"") + s + "秒";
					break;
				case "H小时M分钟S秒":
					return (h ? (NumberFormatUtil.toChineseNumber(h) + "小时"):"") + (m ? (NumberFormatUtil.toChineseNumber(m) + "分钟"):"") + NumberFormatUtil.toChineseNumber(s) + "秒";
					break;
			}
			return time.toString();
		}
		
		
		
		
		
		
		
		
		//---------------------------------------------------------------------------------
		//---------------------------------时间长度 转型---------------------------------
		//---------------------------------------------------------------------------------
		/**
		 * @param $seconds:int 31536000
		 * @param $isMillisecond:Boolean 是否毫秒? 
		 * @return:Number 年
		 */	
		public static function timeFormatYear( $seconds:Number, $isMillisecond:Boolean=false ):Number {
			if( $isMillisecond ) return Math.floor( $seconds/31536000000 );
			else return Math.floor( $seconds/31536000 );
		}
		/**
		 * @param $seconds:int  18144000
		 * @param $isMillisecond:Boolean 是否毫秒? 
		 * @return:Number 月
		 */	
		public static function timeFormatMonth( $seconds:Number, $isMillisecond:Boolean=false ):Number {
			if( $isMillisecond ) return Math.floor( $seconds/18144000000 );
			else return Math.floor( $seconds/18144000 );
		}
		/**
		 * @param $seconds:int  604800
		 * @param $isMillisecond:Boolean 是否毫秒?
		 * @return:Number 周
		 */	
		public static function timeFormatWeek( $seconds:Number, $isMillisecond:Boolean=false ):Number {
			if( $isMillisecond )  return Math.floor( $seconds/604800000 );
			else return Math.floor( $seconds/604800 );
		}
		/**
		 * @param $seconds:int 86400
		 * @param $isMillisecond:Boolean 是否毫秒?
		 * @return:Number 天
		 */	
		public static function timeFormatDay( $seconds:Number, $isMillisecond:Boolean=false ):Number {
			if( $isMillisecond )  return Math.floor( $seconds/86400000 );
			else return Math.floor( $seconds/86400 );
		}
		/**
		 * @param $seconds:int 3600
		 * @param $isMillisecond:Boolean 是否毫秒?
		 * @return:Number 时
		 */		
		public static function timeFormatHour( $seconds:Number, $isMillisecond:Boolean=false ):Number{
			if( $isMillisecond ) return Math.floor( int(( $seconds/3600000 )+1));
			else return Math.floor( int(( $seconds/3600 )+1));
		}
		/**
		 * @param $seconds:int 60
		 * @param $isMillisecond:Boolean 是否毫秒? 
		 * @return:Number	 分
		 */		 
		public static function timeFormatMin( $seconds:Number, $isMillisecond:Boolean=false ):Number{
			if( $isMillisecond ) return Math.floor( $seconds/60000 );
			else return Math.floor( $seconds/60 ); 
		}
	}
}
