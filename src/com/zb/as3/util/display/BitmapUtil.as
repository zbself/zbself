package com.zb.as3.util.display
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	/**
	 * BitmapUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 */
	public final class BitmapUtil
	{
		import flash.display.BitmapData;
		import flash.display.DisplayObject;
		import flash.display.IBitmapDrawable;
		import flash.geom.Matrix;
		import flash.geom.Rectangle;
		
		private static const IDEAL_RESIZE_PERCENT : Number = .5;
		
		public function BitmapUtil()
		{
		}
		/**
		 * 快捷创建位图
		 * */
		public static function createBitmap(width:int, height:int, color:uint = 0, alpha:Number = 1):Bitmap {
			var bitmap:Bitmap = new Bitmap(new BitmapData(1, 1, false, color));
			bitmap.alpha = alpha;
			bitmap.width = width;
			bitmap.height = height;
			return bitmap;
		}
		
		/**
		 * 
		 * 显示对象截图
		 * @param source Display显示对象
		 * @param width
		 * @param height
		 * @param resizeStyle 缩放模式: ResizeStyle的静态属性
		 * @param area
		 * 
		 * @return 截取的 BitmapDate
		 */
		public static function snapshot(source : IBitmapDrawable, width : uint = 0, height : uint = 0, resizeStyle : String = "constrainProportions", area : Rectangle = null) : BitmapData {
			var bitmapData : BitmapData = source as BitmapData;
			
			if (area) {
				bitmapData = new BitmapData(area.width, area.height, true, 0);
				var matrix : Matrix = new Matrix();
				matrix.translate(-area.x, -area.y);
				bitmapData.draw(source, matrix);
			} else if (!bitmapData) {
				bitmapData = new BitmapData(DisplayObject(source).width, DisplayObject(source).height, true, 0);
				bitmapData.draw(source);
			}
			
			if (width || height) {
				var temp : BitmapData = bitmapData;
				bitmapData = resizeImage(temp, width, height, resizeStyle);
				if (temp != source) {
					temp.dispose();
				}
			}
			
			return bitmapData;
		}
			
			// Find the scale to reach the final size
			var scaleX : Number = width / source.width;
			var scaleY : Number = height / source.height;
			
			if (width == 0 && height == 0) {
				scaleX = scaleY = 1;
				width = source.width;
				height = source.height;
			} else if (width == 0) {
				scaleX = scaleY;
				width = scaleX * source.width;
			} else if (height == 0) {
				scaleY = scaleX;
				height = scaleY * source.height;
			}
			
			if (crop) {
				if (scaleX < scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			} else if (constrain) {
				if (scaleX > scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			}
			
			var originalWidth : uint = source.width;
			var originalHeight : uint = source.height;
			var originalX : int = 0;
			var originalY : int = 0;
			var finalWidth : uint = Math.round(source.width * scaleX);
			var finalHeight : uint = Math.round(source.height * scaleY);
			
			if (fill) {
				originalWidth = Math.round(width / scaleX);
				originalHeight = Math.round(height / scaleY);
				originalX = Math.round((originalWidth - source.width) / 2);
				originalY = Math.round((originalHeight - source.height) / 2);
				finalWidth = width;
				finalHeight = height;
			}
			
			if (scaleX >= 1 && scaleY >= 1) {
				try {
					bitmapData = new BitmapData(finalWidth, finalHeight, true, 0);
				} catch (error : ArgumentError) {
					error.message += " Invalid width and height: " + finalWidth + "x" + finalHeight + ".";
					throw error;
				}
				bitmapData.draw(source, new Matrix(scaleX, 0, 0, scaleY, originalX * scaleX, originalY * scaleY), null, null, null, true);
				return bitmapData;
			}
			
			// scale it by the IDEAL for best quality
			var nextScaleX : Number = scaleX;
			var nextScaleY : Number = scaleY;
			while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
			while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;
			
			if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
			if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			bitmapData = new BitmapData(Math.round(originalWidth * nextScaleX), Math.round(originalHeight * nextScaleY), true, 0);
			bitmapData.draw(source, new Matrix(nextScaleX, 0, 0, nextScaleY, originalX * nextScaleX, originalY * nextScaleY), null, null, null, true);
			
			nextScaleX *= IDEAL_RESIZE_PERCENT;
			nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX : Number = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
				var actualScaleY : Number = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
				var temp : BitmapData = new BitmapData(Math.round(bitmapData.width * actualScaleX), Math.round(bitmapData.height * actualScaleY), true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= IDEAL_RESIZE_PERCENT;
				nextScaleY *= IDEAL_RESIZE_PERCENT;
				bitmapData = temp;
			}
			
			return bitmapData;
		}
		
		/**获取9宫格拉伸位图数据*/
		public static function scale9Bmd(bmd:BitmapData, sizeGrid:Array, width:int, height:int):BitmapData {
			if (bmd.width == width && bmd.height == height) {
				return bmd;
			}
			//转换为rect格式进行转换
			var grid:Rectangle = new Rectangle(sizeGrid[0], sizeGrid[1], bmd.width - sizeGrid[0] - sizeGrid[2], bmd.height - sizeGrid[1] - sizeGrid[3]);
			width = Math.max(width, bmd.width - grid.width);
			height = Math.max(height, bmd.height - grid.height);
			
			var newBmd:BitmapData = new BitmapData(width, height, bmd.transparent, 0x00000000);
			var rows:Array = [0, grid.top, grid.bottom, bmd.height];
			var cols:Array = [0, grid.left, grid.right, bmd.width];
			var newRows:Array = [0, grid.top, height - (bmd.height - grid.bottom), height];
			var newCols:Array = [0, grid.left, width - (bmd.width - grid.right), width];
			var newRect:Rectangle;
			var clipRect:Rectangle;
			var m:Matrix = new Matrix();
			for (var i:int = 0; i < 3; i++) {
				for (var j:int = 0; j < 3; j++) {
					newRect = new Rectangle(cols[i], rows[j], cols[i + 1] - cols[i], rows[j + 1] - rows[j]);
					clipRect = new Rectangle(newCols[i], newRows[j], newCols[i + 1] - newCols[i], newRows[j + 1] - newRows[j]);
					m.identity();
					m.a = clipRect.width / newRect.width;
					m.d = clipRect.height / newRect.height;
					m.tx = clipRect.x - newRect.x * m.a;
					m.ty = clipRect.y - newRect.y * m.d;
					newBmd.draw(bmd, m, null, null, clipRect, true);
				}
			}
			return newBmd;
		}
		
		/**创建切片资源*/
		public static function createClips(bmd:BitmapData, xNum:int, yNum:int):Vector.<BitmapData> {
			var clips:Vector.<BitmapData> = new Vector.<BitmapData>();
			var width:int = Math.max(bmd.width / xNum, 1);
			var height:int = Math.max(bmd.height / yNum, 1);
			var point:Point = new Point();
			for (var i:int = 0; i < xNum; i++) {
				for (var j:int = 0; j < yNum; j++) {
					var item:BitmapData = new BitmapData(width, height);
					item.copyPixels(bmd, new Rectangle(i * width, j * height, width, height), point);
					clips.push(item);
				}
			}
			return clips;
		}
		
		/**
		 * 回收一个数组内所有的BitmapData
		 *  
		 * @param bitmapDatas
		 * 
		 */
		public static function dispose(items:Array):void
		{
			for each (var item:* in items)
			{
				if (item is BitmapData)
					(item as BitmapData).dispose();
				
				if (item is Bitmap)
				{
					(item as Bitmap).bitmapData.dispose();
					if ((item as Bitmap).parent)
						(item as Bitmap).parent.removeChild(item as Bitmap);
				}
			}
		}
		
		
	}
}