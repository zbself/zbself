package com.zb.as3.util
{
	import com.zb.as3.util.short.debug;
	import com.zb.as3.util.short.isTrue;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;

	/**
	 * PrintUtil 打印类<br>
	 * 
	 * .print(); 启动打印
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class PrintUtil
	{
		private static var instance:PrintJob;
		/**
		 * printAsBitmap 如果为 true，则此对象作为位图打印。如果为 false，则此对象作为矢量图打印。
		 * 如果要打印的内容包括位图图像，则请将 printAsBitmap 属性设置为 true，以包括任何 Alpha 透明度和色彩效果。如果内容不包含位图图像，则请省略此参数，以便以较高品质的矢量格式（默认选项）打印内容。
		 * 注意：Adobe AIR 在 Mac OS 中不支持矢量打印。
		 */
		public static var option:PrintJobOptions = new PrintJobOptions( true );//true：默认位图打印 、false：矢量图打印
		
		public function PrintUtil()
		{
		}
		/**
		 *  获取PrintJob 实例
		 * @return PrintJob
		 */		
		private static function get instancePrintJob():PrintJob
		{
			if( instance==null ) instance = new PrintJob();
			return instance;
		}
		/**
		 * 启动打印，参数接入打印对象，每个参数为一页。
		 * @param displays 接收多个参数（sprite类型）
		 * @return 支持打印
		 * 
		 */
		public static function print( ...displays ):Boolean
		{
			trace( PrintJob.isSupported +" 支持打印");
			if( !PrintJob.isSupported ) return false;
			if(isTrue(displays))
			{
				if(instancePrintJob.start())
				{
					addSheet( displays );
					instancePrintJob.send();
				}
			}
			return true;
		}
		/**
		 * 添加打印页 
		 * @param sheets [Sprite对象数组]
		 */		
		public static function addSheet( sheets:Array ):void
		{
			
			for each (var i:Sprite in sheets)
			{
				try
				{
					instancePrintJob.addPage(i,null,option);
				}
				catch(error:Error)
				{
					debug( i +" 添加打印页引发错误 : "+error.toString() );
				}
			}
		}
		
	}
}