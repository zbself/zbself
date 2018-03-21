package com.zb.as3.util
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * PhysicsUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class PhysicsUtil
	{
		public function PhysicsUtil()
		{
		}
		
		/**
		 *两点间的直线距离
		 */
		static public function distance(point1:Point,point2:Point):Number{
			return Math.sqrt(Math.pow( (point1.x-point2.x),2)+Math.pow( (point1.y-point2.y),2));
		}
		/**
		 * 角度转弧度
		 */
		public static function angleToRadian(angle:Number):Number{
			return (angle * Math.PI)/180;
		}
		/**
		 * 弧度转角度
		 */
		public static function radianToAngle(radian:Number):Number{
			return (radian * 180)/Math.PI;
		}
		/**
		 * 缓动x
		 * @param target 目标对象
		 * @param endX 目的地x 坐标
		 * @param easingValue 缓动系数（默认：1  直接到达结束）
		 * @return Boolean：是否缓动到目的地。
		 */
		public static function easingX( target:DisplayObject , endX:Number = 0 , easingValue:Number = 1 ):Boolean
		{
			var distance:Number = endX – target.x;
//			if( distance )	target.x += distance * easingValue;
//			else	return false;
			distance ? target.x += distance * easingValue : return true;
			return false;
		}
		/**
		 * 缓动y
		 * @param target 目标对象
		 * @param endX 目的地yx 坐标
		 * @param easingValue 缓动系数（默认：1  直接到达结束）
		 *  @return Boolean：是否缓动到目的地。
		 */
		public static function easingY( target:DisplayObject , endY:Number = 0 , easingValue:Number = 1 ):Boolean
		{
			var distance:Number = endY – target.y;
//			if( distance )	target.y += distance * easingValue;
//			else	return false;
			distance ? target.y += distance * easingValue : return true;
			return false;
		}
	}
}