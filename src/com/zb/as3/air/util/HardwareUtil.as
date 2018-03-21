package com.zb.as3.air.util
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	/**
	 * HardwareUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 下午5:11:14 / 2017-3-20
	 * @see 
	 */
	public class HardwareUtil
	{
		/**
		 * 根据 $name 获取描述文件
		 */
		public static function getDesc($name:String):String
		{
			var __desc:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var __ns:Namespace = __desc.namespace();
			return __desc.__ns::[$name];
		}
		/**网络硬件列表
		 * 自动排除掉系统干扰项
		 */
		private static function get networkHardwareList():Vector.<NetworkInterface>
		{
			if(NativeProcess.isSupported)
			{
				var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				for (var i:int = interfaces.length-1; i >=0 ; i--)
				{
					var networkInterface:NetworkInterface = interfaces[i];
					if(!(networkInterface.active && networkInterface.hardwareAddress && (networkInterface.hardwareAddress!="00-00-00-00-00-00-00-E0")))
					{
						interfaces.removeAt(i);
					}
				}
				return interfaces;
			}
			return null;
		}
		/**
		 * 获取网络硬件 第一个设备
		 * @return 硬件mac地址
		 */		
		public static function getHardwareAddress():String
		{
			if(networkHardwareList.length)
			{
				return networkHardwareList[0].hardwareAddress;
			}
			return "";
		}
		/**
		 * 获取网络硬件 通过设备名称
		 * @return 硬件mac地址
		 */
		public static function getHardwareAddressByName($name:String="本地连接"):String
		{
			for each (var i:NetworkInterface in networkHardwareList)
			{
				if(i.displayName	==$name)
				{
					return i.hardwareAddress;
				}
			}
			return "";
		}
		/** 本地局域网ip地址
		 * @param $name
		 * @return 网络硬件ip地址
		 */		
		public static function getLocalAddress($name:String="本地连接"):String
		{
			for each (var i:NetworkInterface in networkHardwareList) 
			{
				if(i.displayName	==$name)
				{
					if(i.addresses.length)
					{
						return InterfaceAddress(i.addresses[0]).address;
					}
				}
			}
			return "";
		}
	}
}