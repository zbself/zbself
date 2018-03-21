package com.zb.as3.util.cache
{
	import com.zb.as3.zb_internal;

	/**
	 * InitData<br>
	 * 添加固定类数据信息
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class InitData
	{
		//内部程序版本号（可用于破缓存，辨识文件版本）
		private static var _edition:Number = 0.1;
		/**
		 * 本地资源版本号 破缓存
		 */
		public static function get edition():Number
		{
			return _edition;
		}
		zb_internal static function set edition(value:Number):void
		{
			_edition = value;
			return _edition;
		}
		/**
		 * 变化数 破缓存 永不相同<br>
		 * 利用 Date.time( 自1970-1-1 00:00 至今的毫秒数,数值太大,取数值的一半);
		 * @return 
		 */
		public static function get noCacheEdition():Number
		{
			var d:Date = new Date();
			return d.time>>1 ;
		}
	}
}