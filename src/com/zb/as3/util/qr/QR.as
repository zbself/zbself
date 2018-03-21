package com.zb.as3.util.qr
{
	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.EncodeHintType;
	import com.google.zxing.MultiFormatWriter;
	import com.google.zxing.Writer;
	import com.google.zxing.common.BitMatrix;
	import com.google.zxing.common.flexdatatypes.HashTable;
	import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 *
	 * 使用google zxing  一维/二维码...
	 */
	public class QR extends Sprite
	{
		private var qrImg:Bitmap;
		private var myWriter:Writer;
		private var hints:HashTable;
		
		public function QR()
		{
			super();
			creatUI();
		}
		private function creatUI():void
		{
			myWriter = new MultiFormatWriter();
			qrImg = new Bitmap();
			addChild(qrImg);
		}
		
		public function refreshCode(value:String,_width:int=250,_height:int=250):void
		{
			if(qrImg.bitmapData==null)
			{
				qrImg.bitmapData = new BitmapData(_width,_height);
			}
			
			var textString:String = value;
			var matrix:BitMatrix;
			
			//var qrEncoder:MultiFormatWriter = new MultiFormatWriter();
			 hints = new HashTable();
			// 指定纠错等级  
			hints._put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
			
			// 指定编码格式  
			//hints.put(EncodeHintType.CHARACTER_SET, "GBK");
			try
			{
			//	matrix = myWriter.encode(textString,BarcodeFormat.QR_CODE,250,250) as BitMatrix;
//				matrix = myWriter.encode(textString,BarcodeFormat.QR_CODE,_width,_height,hints) as BitMatrix;
				matrix = myWriter.encode(textString,BarcodeFormat.CODE_128,_width,_height,hints) as BitMatrix;
				
			}
			catch (e:Error)
			{
				trace('err');
				return;
			}
			var bmd:BitmapData = new BitmapData(_width, _height, false, 0x808080);
			for (var h:int = 0; h < _height; h++)
			{
				for (var w:int = 0; w < _width; w++)
				{
					if (matrix._get(w, h) == 0)
					{
						bmd.setPixel(w, h, 0xffffff);
					}
					else
					{
						bmd.setPixel(w, h, 0x000000);
					}
				}
			}
			
			var myMatrix:Matrix=new Matrix();
			myMatrix.scale(_width/250,_height/250);
			qrImg.bitmapData.draw(bmd,myMatrix);
			
			qrImg.bitmapData = bmd;
		}
	}
}