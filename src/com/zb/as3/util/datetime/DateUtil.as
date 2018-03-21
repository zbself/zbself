package com.zb.as3.util.datetime
{
	import com.zb.as3.util.math.NumberFormatUtil;

	/**
	 * DateUtil 日期类<br>
	  *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2017-1-1
	 * @see flashyiyi,zrong
	 */
	public final class DateUtil
	{
		/**
		 * 基准日期。可用于所有需要基准日起的方法。例如：getTimestamp 
		 */	
		public static var baseDate:Date;
		
		private static const dayNamesLong:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		private static const dayNamesShort:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		private static const monthNamesLong:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		private static const monthNamesShort:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec"];
		private static const timeOfDay:Array = ["AM", "PM"];
		/**
		 * 获得当前月的天数 
		 * @param d
		 * 
		 */
		static public function getDayInMonth(d:Date):int
		{
			const days:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
			var day:int = days[d.month];
			if (isLeapYear(d.fullYear))
			{
				day++;
			}
			return day;
		}
		/**
		 * 是否是闰年
		 * @param year
		 * @return 
		 * 
		 */
		static public function isLeapYear(year:int):Boolean
		{
			if(((year%4==0) && (year%100!=0)) || (year%400==0) )
			{
				return true;
			}
			return false;
		}
		/**
		 * 根据字符串创建日期 
		 * (yy-mm-dd)
		 * @param v
		 * 
		 */
		static public function createDateFromString(v:String,timezone:Number = NaN):Date
		{
			v = v.replace(/-/g,"/");
			if (!isNaN(timezone))
			{
				var str:String = Math.abs(timezone).toString();
				if (str.length == 1)
					str = "0" + str;
				
				v = v + " GMT" + (timezone >= 0 ? "+" : "-") + str + "00";
			}
			return new Date(v);
		}
		/**
		 * 获取当前的时间，并格式化后作为字符串返回
		 * @param $separator 分隔符
		 * @param $date 传递一个date用于格式化
		 */
		public static function getFormatedTime($date:Date=null,$separator:String=':'):String
		{
			var __curDate:Date = null;
			if($date)
				__curDate = $date;
			else
				__curDate = new Date();
			
			var __curHour:int = __curDate.getHours();
			var __curMinutes:int = __curDate.getMinutes();
			var __curSeconds:int = __curDate.getSeconds();
			
			var __curHourString:String = __curHour.toString();
			var __curMinutesString:String = __curMinutes.toString();
			var __curSecondsString:String = __curSeconds.toString();
			
			__curHourString = __curHour<10 ? ("0" + __curHourString) : __curHourString;			
			__curMinutesString = __curMinutes<10 ? ("0" + __curMinutesString) : __curMinutesString;			
			__curSecondsString = __curSeconds<10 ? ("0" + __curSecondsString) : __curSecondsString;
			
			return __curHourString + $separator +__curMinutesString + $separator +__curSecondsString;
		}
		/**
		 * 获取当前的日期，并格式化后作为字符串返回
		 * @param $date 传递一个date用于格式化
		 */
		public static function getFormatedDate($date:Date=null,$separator:String='-'):String
		{
			var __date:Date = null;
			if($date)
				__date = $date;
			else
				__date = new Date();
			
			var __curYear:int = __date.getFullYear();
			var __curMonth:int = __date.getMonth() + 1;
			var __curDate:int = __date.getDate();
			return __curYear + $separator + (__curMonth < 10 ? ('0' + __curMonth) : __curMonth) + $separator + ( __curDate < 10 ? ('0' + __curDate) : __curDate); 
		}
		/**
		 * 获取当前的日期和时间，并格式化后作为字符串返回
		 * @param $date 传递一个date用于格式化
		 */	
		public static function getFormatedDateAndTime($date:Date=null):String
		{
			var __date:Date = null;
			if($date)
				__date = $date;
			else
				__date = new Date();
			return getFormatedDate( __date) + ' ' + getFormatedTime(__date);
		}
		public static function toRFC822(d:Date):String
		{
			var date:Number = d.getUTCDate();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var sb:String = new String();
			sb += dayNamesShort[d.getUTCDay()];
			sb += ", ";
			
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += " ";
			//sb += DateUtil.SHORT_MONTH[d.getUTCMonth()];
			sb += monthNamesShort[d.getUTCMonth()];
			sb += " ";
			sb += d.getUTCFullYear();
			sb += " ";
			if (hours < 10)
			{			
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{			
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{			
				sb += "0";
			}
			sb += seconds;
			sb += " GMT";
			return sb;
		}
		/**
		 * 获取一个时间戳，它是从过去某一个时刻到现在的毫秒数。
		 * @param $oldDate 过去的某个时刻，默认为2010年国庆节
		 */
		public static function getTimestamp($oldDate:Date=null):uint
		{
			var __oldDate:Date = $oldDate ? $oldDate : ( baseDate ? baseDate : (baseDate = new Date(2010, 9, 1)));
			return uint((new Date()).time - __oldDate.time);
		}
		/**
		 * 创建时间
		 * @param v
		 * 
		 */
		public static function createDate(v:*):Date
		{
			if (isNaN(Number(v)))
				v = v.replace(/-/g,"/");
			return new Date(v);
		}
		/**
		 * 将日期转换为字符串
		 * 
		 * @param date	日期
		 * @param format	日期格式<br>（mm-dd,yyyy-mm-dd,yyyy-m-d,yyyy年m月d日,Y年M月D日）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDateString(date:Date,format:String="yyyy-mm-dd",utc:Boolean = false):String
		{
			var y:int = utc ? date.fullYearUTC : date.fullYear;
			var m:int = utc ? date.monthUTC : date.month;
			var d:int = utc ? date.dateUTC : date.date;
			
			switch (format){
				case "mm-dd":
					return NumberFormatUtil.fillZeros((m + 1).toString(),2) + "-" + NumberFormatUtil.fillZeros(d.toString(),2);
					break;
				case "yyyy-mm-dd":
					return y +"-" + NumberFormatUtil.fillZeros((m + 1).toString(),2) + "-" + NumberFormatUtil.fillZeros(d.toString(),2);
					break;
				case "yyyy-m-d":
					return y +"-" + (m + 1).toString() +"-" + d;
					break;
				case "yyyy年m月d日":
					return y +"年" + (m + 1).toString() +"月" + d + "日";
					break;
				case "Y年M月D日":
					return NumberFormatUtil.toChineseNumber(y) +"年" + NumberFormatUtil.toChineseNumber(m + 1) +"月" + NumberFormatUtil.toChineseNumber(d) + "日";
					break;
			}
			return date.toString();
		}
	}
}