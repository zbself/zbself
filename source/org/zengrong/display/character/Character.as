////////////////////////////////////////////////////////////////////////////////
//  zengrong.net
//  创建者:	zrong
//  最后更新时间：2011-09-14
////////////////////////////////////////////////////////////////////////////////
package org.zengrong.display.character
{
import org.zengrong.text.FTEFactory;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

/**
 * 所有的角色形象的基类，提供以下功能：
 * 帧动画功能以及帧频控制
 * 超出屏幕范围自动隐藏
 * 翻转功能
 * 显示title
 * 居中功能
 * 自动Z索引
 */
public class Character extends Sprite 
{

	public function Character($bmds:Vector.<BitmapData>=null)
	{
		this.mouseChildren = false;
		this.mouseEnabled = false;
		_bmds = $bmds;
		init();
	}

	//----------------------------------------
	// public变量
	//----------------------------------------
	/**
	 * 是否填充了正确的图像。用于替代的图像不算正确填充
	 * 这个变量是在“延时载入”时判断该Layer是否需要置换载入的新图片
	 */
	public var isFill:Boolean = false;

	/**
	 * 角色的z轴值，因为z已经被Sprite使用，因此采用wz
	 */
	public var wz:int;

	/**
	 * 角色的形象，是主文件名字符串
	 */
	public var fname:String;

	/**
	 * 角色的类型
	 */
	public var type:String;

	/**
	 * 单击角色的时候要执行的动作，可能是任何类型
	 */
	public var fun:Object;

	/**
	 * 是否自动计算z的值。如果为false，就使用固定的z值
	 */
	public var isAutoZ:Boolean;

	/**
	 * 是否在超过屏幕范围的时候自动隐藏
	 */
	public var isAutoHide:Boolean = true;

	/**
	 * 屏幕范围
	 */
	public var osdLimit:Rectangle;

	/**
	 * 是否重复播放，如果为真，那么当播放到最后一帧的时候，会跳转到第一帧。否则就会停止在最后帧
	 */	
	public var isRepeat:Boolean = false;
	
	/**
	 * 是否显示中心定位点，这个功能应该仅用于调试
	 */	
	public var showCentralPoint:Boolean = false;

	//----------------------------------------
	// protected变量
	//----------------------------------------
	
	/**
	 * 是否已经初始化
	 */
	protected var _init:Boolean = false;

	/**
	 * 图像列表
	 */
	protected var _bmds:Vector.<BitmapData>;

	/**
	 * 用以显示图像的位图
	 */
	protected var _bmp:Bitmap;

	/**
	 * 用以在玩家头顶显示信息
	 */
	protected var _titleDisplay:DisplayObject;

	/**
	 * 用来保存玩家顶部显示的信息
	 */
	protected var _title:*;

	/**
	 * 当前是否是翻转状态
	 */
	protected var _flip:Boolean;

	/**
	 * 用户翻转之后计算xy的偏移
	 */
	protected var _flipMatrix:Matrix;

	/**
	 * 当前是否为帧停止状态，值为true的时候不更新帧动画
	 */
	protected var _stop:Boolean;

	/**
	 * 当前播放到第几帧（0基）
	 */	
	protected var _curFrame:int = 0;

	/**
	 * 播放的帧率，根据这个值计算多长时间应该切换一次帧
	 */
	protected var _frameRate:int = 8;

	/**
	 * 根据frameRate计算换帧的时间间隔，单位秒。默认frameRate是8，因此这个值默认是1/8
	 */
	protected var _delay:Number = .125;

	/**
	 * 记录上一次切换帧的时间，根据时间间隔计算这次更新是否应该换帧，单位秒
	 */
	protected var _lastChangeFrame:Number = 0;
	
	/**
	 * 中心点的x比例，这个比例是相对于位图的宽度
	 */
	protected var _centralRatioX:Number = 0;

	/**
	 * 中心点的y比例，这个比例相对于位图的高度
	 */
	protected var _centralRatioY:Number = 0;

	/**
	 * 中心点的x偏移值，单位像素
	 */
	protected var _centralOffsetX:Number = 0;

	/**
	 * 中心点的y偏移值，单位像素
	 */
	protected var _centralOffsetY:Number = 0;
	
	

	//----------------------------------------
	// init
	//----------------------------------------

	protected function init():void
	{
		_init = true;
		_flipMatrix = new Matrix(-1,0,0,1);
		_bmp = new Bitmap();
		this.addChild(_bmp);
		if(_bmds) 
		{
			goto(0);
		}
		else
		{
			_bmds = new Vector.<BitmapData>;
		}
	}

	public function destroy():void
	{
		_init = false;
		this.removeChild(_bmp);
		_bmp = null;
		_bmds = null;
		_lastChangeFrame = 0;
		_curFrame = 0;
		wz = 0;
		frameRate = 10;
		isAutoZ = false;
		osdLimit = null;
		type = null;
		if(_titleDisplay)
		{
			if(this.contains(_titleDisplay)) this.removeChild(_titleDisplay);
			_titleDisplay = null;
		}
	}

	//----------------------------------
	//  getter/setter
	//----------------------------------

	public function get isInit():Boolean
	{
		return _init;
	}

	public function get centralRatioX():Number
	{
		return _centralRatioX;
	}

	public function get centralRatioY():Number
	{
		return _centralRatioY;
	}

	public function get centralOffsetX():Number
	{
		return _centralOffsetX;
	}

	public function get centralOffsetY():Number
	{
		return _centralOffsetY;
	}

	/**
	 * 当前是否正在播放帧动画
	 */
	public function get isPlaying():Boolean
	{
		return !_stop;
	}

	/**
	 * 获取Sprite的反转状态
	 */
	public function get flip():Boolean
	{
		return _flip;
	}

	/**
	 * 设置sprite的翻转状态，如果当前没有设置过翻转，就从原始状态中绘制翻转。
	 */
	public function set flip($flip:Boolean):void
	{
		if(_flip == $flip)
			return;
		_flip = $flip;
		_bmp.scaleX = _flip ? -1 : 1;
		setBmpFlipX();
		//trace(this.name ,_title, '设置翻转, _flip:', _flip, ',bmp.x:', _bmp.x, ',bmp.w:', _bmp.width);
		moveTitle();
	}

	public function get frameRate():int
	{
		return _frameRate;
	}

	public function set frameRate($rate:int):void
	{
		_frameRate = $rate;
		_delay = 1/_frameRate;
	}

	public function get currentFrame():int
	{
		return _curFrame;
	}
	
	public function get totalFrames():int
	{
		return _bmds.length;
	}

	public function get title():*
	{
		return _title;
	}

	public function set title($title:*):void
	{
		if(_title == $title) return;
		_title = $title;
		if(!_title || !_title is String) return;
		if(_titleDisplay && this.contains(_titleDisplay))
		{
			this.removeChild(_titleDisplay);
			_titleDisplay = null;
		}
		_titleDisplay = FTEFactory.createSingleTextLine(_title.toString(), 1000);
		if(_titleDisplay)
		{
			moveTitle();
			this.addChild(_titleDisplay);
		}
	}

	/**
	 * 获取帧的位图
	 */
	public function getFrame($index:int):BitmapData
	{
		return _bmds[$index];
	}

	//----------------------------------
	//  公开方法
	//----------------------------------
	public function update($elapsed:Number, $delay:Number):void
	{
		if(!isInit) return;
		updateFrame($elapsed);
		hideOnOverEdge();
		//自动计算z值，z值其实是y值
		if(isAutoZ)
			this.wz = this.y;
	}

	public function updateFrame($elapsed:Number):void
	{
		//如果过去的时间大于帧间隔，且当前处于播放状态，就切换帧
		if(!_stop && _bmds && ($elapsed - _lastChangeFrame >= _delay))
		{
			//trace('Character.update:', $elapsed, _lastChangeFrame);
			next();
			_lastChangeFrame = $elapsed;
		}
	}

	/**
	 * 设置对象中的所有帧
	 */
	public function setFrames($bmds:Vector.<BitmapData>):void
	{
		_bmds = $bmds;
		goto(0);
	}

	/**
	 * 向对象中增加一帧
	 */
	public function addFrame($bmd:BitmapData):void 
	{
		_curFrame = _bmds.length;
		_bmds[_bmds.length] = $bmd;
		_bmp.bitmapData = getFrame(_bmds.length-1);
	}
	
	/**
	 * 移除所有帧
	 * @param $disposeBitmapData 是否销毁列表中的BitmapData
	 */
	public function removeAllFrame($disposeBitmapData:Boolean=false):void
	{
		//_bmds为固定的，说明是从SpriteSheet生成的，这样的_bmds不能销毁，因为其他的角色还需要它
		//固定的就直接新建一个空bmds替换
		if(!_bmds) return;
		if(_bmds.fixed)
		{
			_bmds = new Vector.<BitmapData>;
		}
		else
		{
			while(_bmds.length>0)
			{
				var __bmd:BitmapData = _bmds.pop();
				if($disposeBitmapData) __bmd.dispose();
			}
		}
	}

	/**
	 * 向后移动一帧，并返回新帧
	 * @return 
	 */	
	public function next():BitmapData
	{
		//图像列表不存在或者只有1帧图像，就不必更新帧
		//if(!_bmds || _bmds.length<=1) return;
		if(++_curFrame >= _bmds.length)
		{
			if(isRepeat) _curFrame = 0;
			else
			{
				//如果不是重复状态，就停止播放
				_curFrame = _bmds.length - 1;
				_stop = true;
			}
		}
		_bmp.bitmapData = getFrame(_curFrame);
		return _bmp.bitmapData; 
	}
	
	/**
	 * 跳转到指定的帧，并返回该帧
	 * @param $frame 帧编号，0基
	 */	
	public function goto($frame:int):BitmapData
	{
		if($frame >= _bmds.length)
			_curFrame = isRepeat ? 0 : _bmds.length - 1;
		else
			_curFrame = $frame;
		_bmp.bitmapData = getFrame(_curFrame);
		return _bmp.bitmapData; 
	}

	/**
	 * 开始播放帧动画
	 */
	public function play():void
	{
		_stop = false;
	}

	/**
	 * 停止播放帧动画，形象将停止在当前帧
	 */
	public function stop():void
	{
		_stop = true;
	}

	/**
	 * <p>
	 * 偏移中心点<br>
	 * 有时候希望基于像素精确控制偏移值，使用center无法实现<br>
	 * 可以使用这个方法实现<br>
	 * </p>
	 * @param $ox 基于中心点的x偏移值
	 * @param $oy 基于中心点的y偏移值
	 */
	public function offsetCenter($ox:Number=NaN, $oy:Number=NaN):void
	{
		if(!isNaN($ox)) _centralOffsetX = $ox;
		if(!isNaN($oy)) _centralOffsetY = $oy;
		center();
	}

	/**
	 * <p>
	 * 确定角色的中心点位置，需要提供相对于包含的位图的尺寸的比例<br>
	 * 例如，如果希望将角色基于底部中心对齐（这是大多数角色的默认值），则x传递0.5，y传递-1<br>
	 * 若希望居中对齐，则x传递0.5，y传递0.5<br>
	 * 在更新了角色的形象后，需要重新执行center，因为角色形象可能在更新后产生了宽高变化<br>
	 * 如果不希望改变已经存在的中心点，只希望刷新以体现变化，那么不带参数使用center<br>
	 * 如果只希望单独改变x或者y的比例，则不希望改变的那个值，传递NaN<br>
	 * 默认的对齐方式为基于角色形象的左上角0,0点
	 * </p>
	 * @param $rx 中心点所处的宽度的比例
	 * @param ry 中心点所处的高度的比例
	 */
	public function center($rx:Number=NaN, $ry:Number=NaN):void
	{
		if(!isNaN($rx)) _centralRatioX = $rx;
		if(!isNaN($ry)) _centralRatioY = $ry;
		
		setBmpFlipX();
		_bmp.y = _centralRatioY*_bmp.height+_centralOffsetY;
		//trace('Character.', this.name, _title, ' center:', _bmp.x, _bmp.y, ' width:', _bmp.width, ' bmdWidth:', _bmp.bitmapData.width);
		this.graphics.clear();
		if(showCentralPoint)
		{
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0,0,4,4);
			this.graphics.endFill();
		}
		moveTitle();
	}

	/**
	 * 根据bmp的位置确定title的位置
	 */
	public function moveTitle():void
	{
		if(_titleDisplay)
		{
			//trace('Character.moveTitle:',_titleDisplay.width, _titleDisplay.textBlock.content.text );
			_titleDisplay.x = (_flip ? -1*_bmp.x : _bmp.x) + (_bmp.width-_titleDisplay.width)*.5;
			_titleDisplay.y = _bmp.y-10;
		}
	}

	/**
	 * 测试坐标是否在角色的有效像素范围内
	 */
	public function hitTest($x:int, $y:int):Boolean
	{
		if(!_init) return false;
		//获取真实的左上角全局坐标
		var __rx:int = this.x+_bmp.x;
		var __ry:int = this.y+_bmp.y;
		//将检测坐标转换成本地坐标
		var __lp:Point = new Point($x - __rx, $y - __ry);
		//翻转状态需要变换坐标，无法使用下面“注释1”的方法计算坐标，因为角色的形象被翻转了，如果采用注释1的方法，计算出的坐标对应的点其实是该位置翻转后的像素
		//TODO 2011-07-19 可以使用display.transform.matrix计算flip，这样在center和flip的时候，就可以不计算bmp宽度的一半
		if(_flip) __lp = _flipMatrix.transformPoint(__lp);
		if(__lp.x>0 && __lp.x<_bmp.width && __lp.y>0 && __lp.y<_bmp.height)
		{	
			var __argb:uint = _bmp.bitmapData.getPixel32(__lp.x, __lp.y);
			return (__argb>>24&0xFF) > 0;
		}
		return false;
		//注释1，旧的错误方法
		//var __rx:int = this.x+_bmp.scaleX*_bmp.x;
		//var __ry:int = this.y+_bmp.y;
		//var __lx:int = $x - __rx;
		//var __ly:int = $y - __ry;
		//this.graphics.clear();
		//this.graphics.lineStyle(0,0xFF0000);
		//this.graphics.drawRect(_bmp.x * _bmp.scaleX, _bmp.y, _bmp.width, _bmp.height);
		//this.graphics.lineStyle(0,0x0000FF);
		//this.graphics.drawCircle(__lx+_bmp.x, __ly+_bmp.y, 5);
		//if(__lx>0 && __lx<_bmp.width && __ly>0 && __ly<_bmp.height)
		//{	
		//	var __rgba:uint = _bmp.bitmapData.getPixel32(__lx, __ly);
		//	return (__rgba>>24&0xFF) > 0;
		//}
	}

	//----------------------------------
	//  私有方法
	//----------------------------------
	/**
	 * 计算角色的世界x位置，如果超出屏幕范围就隐藏自己
	 */
	protected function hideOnOverEdge():void
	{
		//trace('计算超限,wx:', this.wx, 'limit:',osdLimit);
		if(isAutoHide && osdLimit)
			this.visible = !(this.x+this.width*.5 < osdLimit.x || this.x-this.width*.5 > osdLimit.right);
	}
	
	/**
	 * 根据flip的值设置_bmp的x值
	 */	
	protected function setBmpFlipX():void
	{
		var __x:int = _flip ? (_centralRatioX*_bmp.width) : (-1*_centralRatioX*_bmp.width);
		__x += _centralOffsetX;
		_bmp.x = __x;
	}

}
}
