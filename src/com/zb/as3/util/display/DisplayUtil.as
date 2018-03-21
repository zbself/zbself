package com.zb.as3.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.describeType;

	/**
	 * 一些用于图形的公用静态方法
	 */
	public final class DisplayUtil
	{	
		/**
		 * 检测对象是否在屏幕中
		 * @param displayObj	显示对象
		 * 
		 */
		
		public static function inScreen(displayObj:DisplayObject):Boolean
		{
			if (displayObj.stage == null)
				return false;
			
			var screen:Rectangle = Geom.getRect(displayObj.stage);
			return screen.containsRect(displayObj.getBounds(displayObj.stage));
		}
		/**
		 * 判断可显示对象是否在一个Rectangle中间
		 * @param displayObj 可显示对象
		 * @param screen 巨型区域
		 * @return 
		 * 是 true 、否 false 
		 */		
		public static function isIntersect(displayObj:DisplayObject,screen:Rectangle):Boolean
		{
			var displayRectangle:Rectangle = Geom.getRect(displayObj);
			var rect:Rectangle = displayRectangle.intersection(screen);
			if(rect.width!=0&& rect.height!=0)
			{    
				return true;
			}else{    
				return false;
			}
			return false;
		}
		/**
		 * 应用与NPC显示在舞台上面
		 * @param obj NPC对象
		 * @param screen 舞台的可显示对象
		 * @return true 标识在舞台内部    false 标识不在舞台内部
		 * 
		 */		
		public static function isScreenTo(obj:DisplayObject,screen:Rectangle):Boolean
		{
			if(obj.x<screen.topLeft.x - obj.width || obj.y < screen.topLeft.y - obj.height)
			{
				
				return false;
			}
			if(obj.x > screen.bottomRight.x + obj.width|| obj.y > screen.bottomRight.y + obj.height)
			{
				return false;
			}
			
			return true;
		}
		/**
		 * 添加到对象之后
		 * @param container 容器，null=原对象父级对象
		 * @param child 新对象
		 * @param target 原对象（下层）
		 * 
		 */
		public static function addChildAfter(child:DisplayObject,target:DisplayObject,container:DisplayObjectContainer = null):void
		{
			if( !container )
			{
				container = target.parent as DisplayObjectContainer;
			}
			container.addChildAt(child,container.getChildIndex(target) + 1);
		}
		
		/**
		 * 添加到对象之前
		 * @param container 容器，null=原对象父级对象
		 * @param child 新对象
		 * @param target 原对象（上层）
		 * 
		 */
		public static function addChildBefore(child:DisplayObject,target:DisplayObject,container:DisplayObjectContainer = null):void
		{
			if( !container )
			{
				container = target.parent as DisplayObjectContainer;
			}
			container.addChildAt(child,target.parent.getChildIndex(target));
		}
        
        /**
         * 获得子对象数组 
         * @param container
         */
        public static function getChildren(container:DisplayObjectContainer):Array
        {
        	var result:Array = [];
            for (var i:int = 0;i < container.numChildren;i++) 
                result.push(container.getChildAt(i));
            
        	return result;
        }
        
		/**
		 * 移除所有子对象
		 * @param container	目标
		 */
		public static function removeAllChildren(container:DisplayObjectContainer):void
        {
			if(!container)return;
            while (container.numChildren) 
                container.removeChildAt(0);
        }
		/**
		 * 深度移除显示容器底下, 所有所有的显示对象. 不仅仅是子级.
		 */
		public static function removeAllDepthChildren(container : DisplayObjectContainer) : void {
			while (container.numChildren) {
				if (container.getChildAt(0) is DisplayObjectContainer) {
					removeAllChildren(container.getChildAt(0) as DisplayObjectContainer);
				}
				container.removeChildAt(0);
			}
		}
		/**
		 * 置空所有属性  清空内存
		 * @param Obj
		 */
		public static function removeAllProperty(obj:Object):Object
		{
			var description:XML = describeType(obj);
			for each(var xml:XML in description..variable)
			{
				obj[xml.@name] = null;
			}
			return obj;
		}
		/**
		 * 批量增加子对象 
		 */
		public static function addAllChildren(container:DisplayObjectContainer,children:Array):void
		{
			for (var i:int = 0;i < children.length;i++)
			{
				if (children[i] is Array)
					addAllChildren(container,children[i] as Array);
				else	
					container.addChild(children[i])
			}
		}
		
		/**
         * 将显示对象移至顶端
         * @param displayObj	目标
         */        
        public static function moveToHigh(displayObj:DisplayObject):void
        {
			var parent:DisplayObjectContainer = displayObj.parent;
			if (parent)
        	{
        		var lastIndex:int = parent.numChildren - 1;
        		if (parent.getChildIndex(displayObj) < lastIndex)
        			parent.setChildIndex(displayObj, lastIndex);
        	}
        }
        /**
         * 同时设置mouseEnabled以及mouseChildren。
         */        
        public static function setMouseEnabled(displayObj:DisplayObjectContainer,v:Boolean):void
        {
        	displayObj.mouseChildren = displayObj.mouseEnabled = v;
        }
		
		/**
		 * 复制显示对象
		 * @param v
		 * 
		 */
		public static function cloneDisplayObject(v:DisplayObject):DisplayObject
		{
			var result:DisplayObject = v["constructor"]();
			result.filters = result.filters;
			result.transform.colorTransform = v.transform.colorTransform;
			result.transform.matrix = v.transform.matrix;
			if (result is Bitmap)
				(result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
			return result;
		}
        /**
         * 获取舞台Rotation
         * @param displayObj	显示对象
         * @return 
         */        
        public static function getStageRotation(displayObj:DisplayObject):Number
        {
        	var currentTarget:DisplayObject = displayObj;
			var r:Number = 1.0;
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				r += currentTarget.rotation;
				currentTarget = currentTarget.parent;
			}
			return r;
        }
        /**
         * 获取舞台缩放比
         *  
         * @param displayObj
         * @return 
         */
        public static function getStageScale(displayObj:DisplayObject):Point
        {
        	var currentTarget:DisplayObject = displayObj;
			var scale:Point = new Point(1.0,1.0);
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				scale.x *= currentTarget.scaleX;
				scale.y *= currentTarget.scaleY;
				currentTarget = currentTarget.parent;
			}
			return scale;
        }
        
        /**
         * 获取舞台Visible
         * 
         * @param displayObj	显示对象
         * @return 
         */        
        public static function getStageVisible(displayObj:DisplayObject):Boolean
        {
        	var currentTarget:DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget.visible == false) 
					return false;
				currentTarget = currentTarget.parent;
			}
			return true;
        }
		
		/**
		 * 判断对象是否在某个容器中 
		 * @param displayObj
		 * @param container
		 * @return 
		 */
		public static function isInContainer(displayObj:DisplayObject,container:DisplayObjectContainer):Boolean
		{
			var currentTarget:DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget == container) 
					return true;
				currentTarget = currentTarget.parent;
			}
			return false;
		}
		
		/**
		 * 目标：返回鼠标是否碰触到人物
		 * 用BitmapData类里的getPixel32方法返回一个值，值为零时说明没碰撞到，非零是就是碰触到
		 * 用BitmapData对象绘制人物图片
		 * getBounds返回人物所在其父类里所站的巨型位置。
		 * 由于人物图片的坐标点在人物的脚底下，所以要在Matrix矩阵中偏移一定的位置。
		 * */
		public static function isMouseIn(sprite:DisplayObject,parent:DisplayObjectContainer = null):Boolean
		{
			try{
				if(!sprite)return false;
				if(!parent)
				{
					parent = sprite.parent;
				}
				if(!sprite.parent)return false;
				var bitmap:BitmapData=new BitmapData(sprite.width,sprite.height,true,0);
				if(!bitmap)return false;
				var ma:Matrix=new Matrix();
				var bo:Rectangle=sprite.getBounds(parent);
				ma.tx=-(bo.x-sprite.x);
				ma.ty=-(bo.y-sprite.y);
				bitmap.draw(sprite,ma);
				var indexof:uint=bitmap.getPixel32(ma.tx+sprite.mouseX,ma.ty+sprite.mouseY);
			}catch(e:Error)
			{
				trace(e)
			}
			return indexof!=0;
		}
		
		//----------------------------------------------滤镜----------------------------------------------
		/**
		 * 添加滤镜
		 **/
		public static function addFilter(target:DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}
		/**
		 * 给舞台显示对象添加光特效
		 * @param target
		 */		
		public static function setGlowFilter(target:DisplayObject,color:Number = 16711680):void
		{
			if(DisplayUtil.isMouseIn(target))
			{
				if(target.filters.length == 0)
				{
					var filter1:GlowFilter = new GlowFilter(color);
					target.filters = [filter1];
				}
			}else
			{
				if(target.filters.length != 0)
				{
					target.filters = [];
				}
			}
		}
		/**
		 * 清除指定类型的滤镜
		 * */
		public static function unFilterWithType(target:DisplayObject, filterType:Class):void {
			var filters:Array = target.filters;
			if (filters != null && filters.length > 0) {
				for (var i:int = filters.length - 1; i > -1; i--) {
					var filter:* = filters[i];
					if (filter is filterType) {
						filters.splice(i, 1);
					}
				}
				target.filters = filters;
			}
		}
		/**
		 * 移除除_obj外的所有滤镜
		 * @param conten
		 * @param _obj
		 */		
		public static function removeAllGlowFilter(conten:DisplayObjectContainer,_obj:DisplayObject = null):void
		{
			for(var i:int = 0;i<conten.numChildren;i++)
			{
				var obj:DisplayObject = conten.getChildAt(i);
				if(obj == _obj)
				{
					return;
				}else
				{
					obj.filters = [];
				}
			}
		}
		private static const _grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		/**
		 * 设置成黑白效果
		 * @param 设置显示对象
		 * @param isGray 是否灰色
		 **/
		public static function grayFilter(traget:DisplayObject, isGray:Boolean = true):void {
			if (isGray) {
				addFilter(traget, _grayFilter);
			} else {
				unFilterWithType(traget, ColorMatrixFilter);
			}
		}
		/**
		 * 清楚所有滤镜
		 * @param display
		 */		
		public static function unFilter(display:DisplayObject):void
		{
			display.filters = [];
		}
		//----------------------------------------------滤镜----------------------------------------------
		
		/**
		 * 根据网格坐标取得象素坐标
		 * tileWidth  tile的象素宽
		 * tileHeight tile的象素高
		 * tx 网格坐标x
		 * ty 网格坐标x
		 * return 象素坐标的点
		 */
		public static function getPixelPoint(tx:int, ty:int, tileWidth:int = 64, tileHeight:int =32 ):Point
		{
			//偶数行tile中心
			var tileCenter:int = (tx * tileWidth) + tileWidth/2;
			// x象素  如果为奇数行加半个宽
			var xPixel:int = tileCenter + (ty&1) * tileWidth/2 //- tileWidth/2;
			
			// y象素
			var yPixel:int = (ty + 1) * tileHeight/2;
			return new Point(xPixel  , yPixel);//-tileWidth/2
		}
		
		/**
		 * 根据屏幕象素坐标取得网格的坐标
		 * tileWidth  tile的象素宽
		 * tileHeight tile的象素高
		 * px 象素坐标x
		 * py 象素坐标x
		 * return 网格坐标的点
		 */
		public static function getTilePoint(px:int, py:int, tileWidth:int = 64, tileHeight:int = 32):Point
		{
			var xtile:int = 0;	//网格的x坐标
			var ytile:int = 0;	//网格的y坐标
//			px = px + tileWidth/2;
			var cx:int, cy:int, rx:int, ry:int;
			cx = int(px / tileWidth) * tileWidth + tileWidth/2;	//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
			cy = int(py / tileHeight) * tileHeight + tileHeight/2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
			
			rx = (px - cx) * tileHeight/2;
			ry = (py - cy) * tileWidth/2;
			
			if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight/4)
			{
				//xtile = int(pixelPoint.x / tileWidth) * 2;
				xtile = int(px / tileWidth);
				ytile = int(py / tileHeight) * 2;
			}
			else
			{
				px = px - tileWidth/2;
				//xtile = int(pixelPoint.x / tileWidth) * 2 + 1;
				xtile = int(px / tileWidth) + 1;
				
				py = py - tileHeight/2;
				ytile = int(py / tileHeight) * 2 + 1;
			}
			
			var point:Point = new Point();
			point.x = xtile - (ytile&1);
			point.y = ytile;
			
			return point;
		}
		/**
		 * 返回某一个Container下的显示对象的个数
		 */
		public static function getAllChildrenNum(container : DisplayObjectContainer) : uint {
			return container.numChildren;
		}
		/**
		 * 返回某一个Container下的所有显示对象的个数(包括子/"孙"...显示对象).
		 */
		public static function getAllChildrenDepthNum(container : DisplayObjectContainer) : uint {
			var num : uint = container.numChildren;
			for (var i : int = 0;i < container.numChildren;i++) {
				var child : DisplayObject = container.getChildAt(i);
				if (child is DisplayObjectContainer) {
					num += getAllChildrenDepthNum(child as DisplayObjectContainer);
				}
			}
			return num;
		}
		/**
		 * 返回显示列表中的某个显示对象在显示对象树当中的级别.
		 */
		public static function getDisplayObjectLevel(object : DisplayObject) : int {
			if (object is Stage) {
				return 0;
			}
			if (object.stage) {
				var i : int = 0;
				while (object.parent) {
					object = object.parent;
					i++;
				}
				return i;
			} else {
				return -1;
			}
		}
		/**
		 * 将显示对象置顶.
		 */
		public static function swapToTop(obj : DisplayObject) : void {
			if (obj.stage) {
				var fun : Function;
				obj.stage.invalidate();
				obj.stage.addEventListener(Event.RENDER, fun = function(evt : Event):void {
					if(obj != null && obj.stage != null && fun != null) {
						obj.stage.removeEventListener(Event.RENDER, fun);
						obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);
					}
				});
			}
		}
		/**
		 * 判断是否点击到热点区域（非透明区）
		 * @param _bmp
		 * @param mouseX
		 * @param mouseY
		 * @return 
		 * 
		 */		
		public function inHitArea(_bmp:Bitmap ,mouseX:Number, mouseY:Number):Boolean
		{
			return _bmp.bitmapData == null ? false : _bmp.bitmapData.getPixel32(mouseX, mouseY) >>> 24 != 0x00;
		}
		/**
		 * 改变注册点
		 * 
		 * */
		public static function setPosition (view:DisplayObject, dx:Number, dy:Number)
		{
			view.x = dx - view.getBounds(view).left;
			view.y = dy - view.getBounds(view).top;
		}
	}
}