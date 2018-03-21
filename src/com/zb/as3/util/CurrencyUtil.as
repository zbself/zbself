package com.zb.as3.util
{
	/**
	 * CurrencyUtil 货币类<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see aswing
	 * @info http://qq.ip138.com/hl.asp 自行修改汇率
	 */
	public class CurrencyUtil
	{
		public function CurrencyUtil()
		{
		}
		/**
		 * 国际货币转换 人民币CNY>>USD美元
		 * @param value人民币
		 * 
		 * @return 美元
		 */
		public static function CNY2USD( value:Number):int
		{
			var rate:Number = 0.145033;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>EUR欧元
		 * @param value人民币
		 * 
		 * @return 欧元
		 */
		public static function CNY2EUR( value:Number):int		{
			var rate:Number = 0.136476;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>HKD港元
		 * @param value人民币
		 * 
		 * @return 港元
		 */
		public static function CNY2HKD( value:Number):int		{
			var rate:Number = 1.126759;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>AUD澳门元
		 * @param value人民币
		 * 
		 * @return 澳门元
		 */
		public static function CNY2AUD( value:Number):int		{
			var rate:Number = 0.193474;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>TWD台币
		 * @param value人民币
		 * 
		 * @return 台币
		 */
		public static function CNY2TWD( value:Number):int		{
			var rate:Number = 4.435098;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>GBP英镑
		 * @param value人民币
		 * 
		 * @return 英镑
		 */
		public static function CNY2GBP( value:Number):int		{
			var rate:Number = 0.116026;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>KRW韩元
		 * @param value人民币
		 * 
		 * @return 韩元
		 */
		public static function CNY2KRW( value:Number):int		{
			var rate:Number = 165.440174;
			return rate * value;
		}
		/**
		 * 国际货币转换 人民币CNY>>JPY日元
		 * @param value人民币
		 * 
		 * @return 日元
		 */
		public static function CNY2JPY( value:Number):int		{
			var rate:Number = 15.909935;
			return rate * value;
		}
		
	}
}