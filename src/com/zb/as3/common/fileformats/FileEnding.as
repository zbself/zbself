package com.zb.as3.common.fileformats
{
	/**
	 * 保存不同平台的换行符
	 */
	public class FileEnding
	{
		/**
		 * Windows系统的换行符
		 */	
		public static const DOS:String = '\r\n';
		
		/**
		 * Mac系统的换行符
		 */	
		public static const MAC:String = '\r';
		
		/**
		 * 类Unix系统的换行符
		 */	
		public static const UNIX:String = '\n';
	}
}