package org.zengrong.utils
{
import flash.geom.Point;

/**
 * 计算坐标位置的功能函数集合。
 * @author zrong
 */
public class Vec2D
{
    public var x:Number = 0;
    public var y:Number = 0;

    public function Vec2D($x:Number = 0, $y:Number = 0)
    {
        this.x = $x;
        this.y = $y;
    }

	//----------------------------------
	//  getter/setter
	//----------------------------------
	/**
	 * 使用勾股定理计算两点间的距离
	 * x、y在这里代表直角三角形的两条直角边。
	 * @return 自身的x、y代表的直角三角形的斜边的长度。
	 */	
	public function get len() : Number
	{
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	
	/**
	 * 使用勾股定理计算两点间的距离，但不开方。
	 * x、y在这里代表直角三角形的两条直角边。
	 */
	public function get len2() : Number
	{
		return this.x * this.x + this.y * this.y;
	}
	
	/**
	 * 计算直角边与斜边的比值，存入一个新的Vec2D对象并返回。
	 * 使用这个比值，可以计算出与自己代表的直角三角形的同比直角三角形的斜边上的任意一个坐标点。
	 * 例如，使用Vec2D.mulN(n)，可以得到根据斜边n的长度计算出来x、y坐标点。
	 * @return 保存了自己所代表两个直角边比值的Vec2D对象。
	 */	
	public function get normalized() : Vec2D
	{
		var __len:Number = this.len;
		var __vec:Vec2D = new Vec2D(0, 0);
		__vec.x = this.x / __len;
		__vec.y = this.y / __len;
		return __vec;
	}
	
	/**
	 * 根据自己的坐标值返回一个point对象。
	 */	
	public function get point() : Point
	{
		return new Point(this.x, this.y);
	}
	
	/**
	 * 根据提供的point的坐标设置自己的坐标。
	 */	
	public function set point($point:Point) : void
	{
		this.x = $point.x;
		this.y = $point.y;
	}
	
	/**
	 * 获取自己与坐标0,0点的角度值。
	 */	
	public function get angle() : Number
	{
		return radian * 180 / Math.PI;
	}
	
	/**
	 * 根据自己与0,0点的角度值设置自己的坐标。
	 */	
	public function set angle($angle:Number) : void
	{
		var __radian:Number = $angle * Math.PI / 180;
		radian = __radian;
	}
	
	/**
	 * 获取自己与坐标0,0点的弧度，并保证弧度为正值。
	 */	
	public function get radian():Number
	{
		var __radian:Number = Math.atan2(this.y, this.x); 
		if(__radian < 0)
			__radian += Math.PI*2;
		return __radian;
	}
	
	/**
	 * 根据与0,0点的弧度值设置自己的坐标。
	 */	
	public function set radian($radian:Number):void
	{
		this.x = Math.cos($radian);
		this.y = Math.sin($radian);
	}
	
	/**
	 * 复制当前的值到一个新的vec2D对象。
	 */	
	public function get vec() : Vec2D
	{
		return new Vec2D(this.x, this.y);
	}
	
	/**
	 * 根据提供的vec2D的值设置自己的坐标。
	 */	
	public function set vec($vec:Vec2D) : void
	{
		this.x = $vec.x;
		this.y = $vec.y;
	}
	
	/**
	 * 将自己的y值取负值，创建一个新的Vec2D对象并返回。
	 */	
	public function get normal() : Vec2D
	{
		return new Vec2D(-this.y, this.x);
	}
	
	/**
	 * 将自己的x和y值均取负值，创建一个新的Vec2D对象并返回。
	 */	
	public function get reverse() : Vec2D
	{
		return new Vec2D(-this.x, -this.y);
	}
	
	public function getAngle($vec:Vec2D) : Number
	{
		var __num:Number = this.nDot($vec);
		return Math.acos(__num) * 180 / Math.PI;
	}
	
	//----------------------------------
	//  公有方法
	//----------------------------------
	public function isLeft($vec:Vec2D) : Boolean
	{
		return this.cross($vec) >= 0;
	}
	
	public function isLeft2($vec:Vec2D):Boolean
	{
		return x < $vec.x;
	}
	
    public function cross($vec:Vec2D) : Number
    {
        return this.x * $vec.y - this.y * $vec.x;
    }

    public function dot($vec:Vec2D) : Number
    {
        return this.x * $vec.x + this.y * $vec.y;
    }
	
	public function nDot($vec:Vec2D) : Number
	{
		var __thisVec:Vec2D = this.normalized;
		var __otherVec:Vec2D = $vec.normalized;
		return __thisVec.x * __otherVec.x + __thisVec.y * __otherVec.y;
	}
	
	public function project($vec:Vec2D) : Vec2D
	{
		var __dot1:Number = this.dot($vec);
		var __dot2:Number = $vec.dot($vec);
		var __num:Number = __dot1 / __dot2;
		return $vec.mulNum(__num);
	}
	
	/**
	 * 更新自己的vec的值，详见normalized。
	 */	
	public function normalize() : void
	{
		this.vec = this.normalized;
	}
	
	
	public function toString() : String
	{
		return 'Vec2D:('+this.x.toString() + " " + this.y.toString()+')';
	}
	
	//----------------------------------
	//  num四则运算，修改自身
	//----------------------------------
	/**
	 * 将当前保存的值与参数相加并保存
	 * @param $num 要增加的数字 
	 */	
	public function addN($x:Number, $y:Number=NaN) : void
	{
		if(isNaN($y))
			$y = $x;
		this.x = this.x + $x;
		this.y = this.y + $y;
	}
	
	/**
	 * 将当前保存的值减去参数并保存
	 * @param $num 要减去的数字
	 */	
	public function subN($x:Number, $y:Number=NaN) : void
	{
		if(isNaN($y))
			$y = $x;
		this.x = this.x - $x;
		this.y = this.y - $y;
	}
	
	/**
	 * 将当前保存的值乘以一个数字并更新
	 * @param $num 要相乘的数字
	 */	
    public function mulN($x:Number, $y:Number=NaN) : void
    {
		if(isNaN($y))
			$y = $x;
        this.x = this.x * $x;
        this.y = this.y * $y;
    }
	
	/**
	 * 将当前保存的值除以一个数字并更新
	 * @param $num 要作为除数的数字
	 */	
	public function divN($x:Number, $y:Number=NaN) : void
	{
		if(isNaN($y))
			$y = $x;
		this.x = this.x / $x;
		this.y = this.y / $y;
	}
	
	//----------------------------------
	//  Num四则运算，返回一个新的Vec2D
	//----------------------------------
	/**
	 * 将当前保存的值与参数相加，并返回一个新的Vec2D
	 * @param $num 要增加的数字 
	 */	
	public function addNum($x:Number, $y:Number=NaN) : Vec2D
	{
		if(isNaN($y))
			$y = $x;
		return new Vec2D(this.x + $x, this.y + $y);
	}
	
	/**
	 * 将当前保存的值减去参数并返回一个新的Vec2D
	 * @param $num 要减去的数字
	 */		
	public function subNum($x:Number, $y:Number=NaN) : Vec2D
	{
		if(isNaN($y))
			$y = $x;
		return new Vec2D(this.x - $x, this.y - $y);
	}
	
	/**
	 * 将当前保存的值乘以一个数字并返回一个新的Vec2D
	 * @param $num 要相乘的数字
	 */	
	public function mulNum($x:Number, $y:Number=NaN) : Vec2D
	{

		if(isNaN($y))
			$y = $x;
		return new Vec2D(this.x * $x, this.y * $y);
	}
	
	/**
	 * 将当前保存的值除以一个数字并返回一个新的Vec2D
	 * @param $num 要作为除数的数字
	 */	
	public function divNum($x:Number, $y:Number=NaN) : Vec2D
	{
		if(isNaN($y))
			$y = $x;
		return new Vec2D(this.x / $x, this.y / $y);
	}
	
	//----------------------------------
	//  对vec进行处理的四则运算，修改自身
	//----------------------------------
	/**
	 * 将当前保存的值与参数相加并保存
	 * @param $vec 要增加的Vec2D
	 */	
    public function addV($vec:Vec2D) : void
    {
        this.x = this.x + $vec.x;
        this.y = this.y + $vec.y;
    }

	/**
	 * 将当前保存的值减去参数并保存
	 * @param $vec 要减去的Vec2D
	 */	
    public function subV($vec:Vec2D) : void
    {
        this.x = this.x - $vec.x;
        this.y = this.y - $vec.y;
    }
	
	/**
	 * 将当前保存的值乘以参数并更新
	 * @param $num 要相乘Vec2D
	 */	
	public function mulV($vec:Vec2D) : void
	{
		this.x = this.x * $vec.x;
		this.y = this.y * $vec.y;
	}
	
	/**
	 * 将当前保存的值除以参数并更新
	 * @param $num 要作为除数的Vec2D
	 */	
	public function divV($vec:Vec2D) : void
	{
		this.x = this.x / $vec.x;
		this.y = this.y / $vec.y;
	}
	
	//----------------------------------
	//  对vec进行处理的四则运算，返回新的Vec2D
	//----------------------------------
	public function addVec($vec:Vec2D) : Vec2D
	{
		return new Vec2D(this.x + $vec.x, this.y + $vec.y);
	}
	
	public function subVec($vec:Vec2D) : Vec2D
	{
		return new Vec2D(this.x - $vec.x, this.y - $vec.y);
	}
	
	public function mulVec($vec:Vec2D) : Vec2D
	{
		return new Vec2D(this.x * $vec.x, this.y * $vec.y);
	}
	
	public function divVec($vec:Vec2D) : Vec2D
	{
		return new Vec2D(this.x / $vec.x, this.y / $vec.y);
	}
}
}
