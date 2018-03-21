package com.zb.as3.util.device
{
	import flash.system.Capabilities;

	/**
	 * HardwareUtil<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2017-1-1
	 * @see 
	 */
	public class DeviceUtil
	{
		/**
		 * 检测Flash Player的平台
		 * @param $platform 平台代码，值为WIN/MAC/LNX/AND或空字符串(不区分大小写比较)
		 * @return Boolean 是否相同平台
		 */
		public static function checkPlatform($platform:String):Boolean
		{
			return getPlatform().toLowerCase() == $platform.toLowerCase();
		}
		/**
		 * 获取Flash Player的平台
		 * @return String
		 */
		public static function getPlatform():String
		{
			var __ver:String = Capabilities.version;
			var __split:Array = __ver.split(' ');
			return __split[0];
		}
		/**
		 * 检测Flash Player的版本号
		 * @param $major 主版本号，必须提供
		 * @param $minor 次版本号，可选
		 * @param $build 生成版本号，可选
		 * @param $internal 内部生成版本号，可选
		 * @return 若提供的版本号 大于 当前版本号，则返回1；若相等，则返回0；否则返回-1
		 */
		public static function checkPlatform($major:int, $minor:int=-1, $build:int=-1, $internal:int=-1):int
		{
			var __vList:Array = getVersion();
			if($major > int(__vList[0])) return 1;
			else if($major < int(__vList[0])) return -1;
			else
			{
				if($minor>-1)
				{
					if($minor > int(__vList[1])) return 1;
					else if($minor < int(__vList[1])) return -1;
					else
					{
						if($build > -1)
						{
							if($build > int(__vList[2])) return 1;
							else if($build < int(__vList[2])) return -1;
							else
							{
								if($internal > -1)
								{
									if($internal > int(__vList[3])) return 1;
									else if($internal < int(__vList[3])) return -1;
									else return 0;
								}
								return 0;
							}
						}
						return 0;
					}
				}
				return 0;
			}
		}
		/**
		 * 获取Flash Player的版本号
		 * @return Array
		 */
		public static function getVersion():Array
		{
			var __ver:String = Capabilities.version;
			var __split:Array = __ver.split(' ');
			return String(__split[1]).split(',');
		
		}
	}
}