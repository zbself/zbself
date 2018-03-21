package com.zb.as3
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	
	/**
	 * @author zb
	 */	
	public class ZBLogo extends Shape
	{
		private var thickness:Number = 0;
		public function ZBLogo(size:Number=50,color:uint=0,alpha:Number=1)
		{
			//ZB
			graphics.lineStyle(size>=20?5:size>=10?3:1.5,color,alpha,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			graphics.moveTo(0,0);
			graphics.lineTo(size,0);
			graphics.lineTo(0,size);
			graphics.lineTo(size<<1,size);
			graphics.lineTo(size<<1,0);
			graphics.lineTo(size,0);
			graphics.lineTo(size,size);
			graphics.lineTo(size,size>>1);
			graphics.lineTo(size<<1,size>>1);
			//end
		}
	}
}