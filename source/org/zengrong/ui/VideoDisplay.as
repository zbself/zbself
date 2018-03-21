////////////////////////////////////////////////////////////////////////////////
//  zengrong.net
//  创建者:	zrong
//  修改时间：2011-7-12
//  更新时间：2011-10-12
////////////////////////////////////////////////////////////////////////////////
package org.zengrong.ui
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.media.Camera;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

import org.zengrong.media.NetConnectionInfoCode;

[Event(name='close', type='flash.events.Event')]
[Event(name='complete', type='flash.events.Event')]

/**
 * 支持视频流、视频文件和摄像头视频的显示。
 * @author zrong
 */
public class VideoDisplay extends UI
{
	public static const URI_STREAM:String = 'uristream'
	public static const NET_STREAM:String = 'netstream';
	public static const CAMERA:String = 'camera';
	
	public function VideoDisplay($width:int=320, $height:int=240)
	{
		_width = $width;
		_height = $height;
		init();
		addChildren();
		draw();
	}
	
	//--------------------------------------------------------------------------
	//  实例变量
	//--------------------------------------------------------------------------
	
	private var _video:Video;
	private var _type:String;
	private var _playing:Boolean;
	private var _streamName:String;
	private var _serverURI:String;
	private var _nc:NetConnection;
	private var _ns:NetStream;
	
	private var _maintainAspectRatio:Boolean;
	private var _muted:Boolean;
	
	//--------------------------------------------------------------------------
	//  init
	//--------------------------------------------------------------------------
	
	override protected function init():void
	{
		_type = null;
		_playing = false;
		_streamName = null;
		_serverURI = null;
		_nc = null;
		_ns = null;
		_maintainAspectRatio = false;
		_muted = false;
	}
	
	override protected function addChildren():void
	{
		trace('VideoDisplay addChildren:', _width, _height);
		_video = new Video(_width, _height);
		_video.visible = false;
		_video.smoothing = true;
		this.addChild(_video);
	}
	
	override protected function draw():void
	{
		this.graphics.clear();
		this.graphics.beginFill(0x0000000);
		this.graphics.drawRect(0, 0, _width, _height);
		this.graphics.endFill();
	}
	
	//--------------------------------------------------------------------------
	//  公共方法
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  getter变量
	//----------------------------------
	public function get type():String
	{
		return _type;
	}
	
	public function get playing():Boolean
	{
		return _playing;
	}
	
	public function get muted():Boolean
	{
		return _muted;
	}
	
	public function get maintainAspectRatio():Boolean
	{
		return _maintainAspectRatio;
	}

	public function set maintainAspectRatio($maintainAspectRatio:Boolean):void
	{
		_maintainAspectRatio = $maintainAspectRatio;
	}
	
	override public function get width():Number
	{
		return _video.width;
	}
	
	override public function set width($w:Number):void
	{
		super.width = $w;
		_video.width = _width;
		trace('set VideoDisplay width', _width, this.width);
	}
	
	override public function get height():Number
	{
		return _video.height;
	}

	override public function set height($h:Number):void
	{
		super.height = $h;
		_video.height = _height;
		trace('set VideoDisplay height', _width, this.height);
	}

	public function get deblocking():int
	{
		return _video.deblocking;
	}

	public function set deblocking($deb:int):void
	{
		_video.deblocking = $deb;
	}

	public function get smoothing():Boolean
	{
		return _video.smoothing;
	}

	public function set smoothing($smo:Boolean):void
	{
		_video.smoothing = $smo;
	}
	
	public function set muted($muted:Boolean):void
	{
		_muted = $muted;
		setMuted();	
	}
	
	//----------------------------------
	//  附加视频流的方法
	//----------------------------------
	/**
	 * 为Video显示对象附加一个可以播放的流对象。 
	 * @param $ns NetStream对象
	 * @throw Error
	 */	
	public function attachNetStream($ns:NetStream):void
	{
		if(type != null)
			throw new Error('VideoDisplay已經被用於NetStream視訊！');
		_type = NET_STREAM;
		_playing = true;
		_video.clear();
		_video.attachNetStream($ns);
		_video.visible = true;
		trace('VideoDisplay.attachNetStream,ns:', $ns);
	}
	
	/**
	 * 为Video显示对象附加一个Camera对象。 
	 * @param $cam Camera对象
	 * @throw Error
	 */	
	public function attachCamera($cam:Camera):void
	{
		if(type != null)
			throw new Error('VideoDisplay已經被用於Camera視訊！');
		_type = CAMERA;
		_playing = true;
		_video.clear();
		_video.attachCamera($cam);
		_video.visible = true;
		trace('VideoDisplay.attachCamera:_video.width:',_video.width,'$cam.width:',$cam.width);
	}
	
	/**
	 * 为Video显示对象附加一个用来播放的URI地址文件。 
	 * @param $serverURI 要播放的URI地址，不包含文件名部分。
	 * @param $streamName 要播放的视频文件名，命名方式为video.flv/video.mp4/video.f4v等等。
	 * @param $param 要传递的参数
	 * 
	 */	
	public function attachURIStream($serverURI:String, $streamName:String, ...$param:Array):void
	{
		var __streamNameArr:Array = $streamName.split('.');
		//如果当前类型为空，就初始化
		if(type == null || type == URI_STREAM) 
		{
			_serverURI = $serverURI;
			//将streamName变成需要的形式，例如视频文件名为video.flv，则会转换为flv:video，这是播放文件视频流需要的方式。
			_streamName = __streamNameArr[1] + ':' + __streamNameArr[0];
			initNC();
			var __param:Array = [_serverURI];
			_nc.connect.apply(_nc, __param.concat($param));
			_video.visible = true;
			_type = URI_STREAM;	
		}	
		else
		{
			throw new Error('VideoDisplay已經被用於其它視訊！');		
		}
	}
	
	//----------------------------------
	//  清除视频显示的方法
	//---------------------------------- 
	public function clear():void
	{
		trace("//**** VideoDisplay.clear 执行****//");
		if((type==NET_STREAM) || (type==URI_STREAM))
		{
			_video.attachNetStream(null);
			trace("停止显示NetStream");
		}
		else if(type == CAMERA)
		{				
			_video.attachCamera(null);
			trace("停止显示Camera");
		}
		//由于使用了_video.clear仍然无法清空视频，因此取消视频的可见性
		_playing = false;
		_video.clear();
		_video.visible = false;
		trace("清除显示内容");
	}
	
	public function close():void
	{
		clear();
		//只有URI_STREAM使用了NC，因此也只有它需要关闭NC
		if(_type == URI_STREAM)
		{
			if(_nc.connected) _nc.close();
		}
		_type = null;
	}

	override public function destroy():void
	{
		close();
		this.removeChild(_video);
		if(_ns)
		{
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, handler_nsStatus);
			_ns = null;
		}
		if(_nc)
		{
			if(_nc.client)
				_nc.client.destroy();
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, handler_ncStatus);
			_nc.client = null;
			_nc = null;
		}
	}
	
	//--------------------------------------------------------------------------
	//  私有方法
	//--------------------------------------------------------------------------
	
	private function initNC():void
	{
		if(_nc == null)
		{
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, handler_ncStatus);
		}
		else
		{
			if(_nc.connected)
			{
				close();
			}
		}
	}
	
	private function handler_ncStatus(evt:NetStatusEvent):void
	{
		var __code:String = evt.info.code;
		trace('VideoDisplay,nc statue:', __code);
		switch(__code)
		{
			case NetConnectionInfoCode.SUCCESS:
				if(_ns == null)
				{
					_ns = new NetStream(_nc);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, handler_nsStatus);
					_ns.client = new StreamClient(this);
					setMuted();
					trace('VideoDisplay._ns.soundTransform.volume:', _ns.soundTransform.volume);
				}
				_ns.play(_streamName);
				_video.attachNetStream(_ns);
				trace('VideoDisplay.nc success， uri:', _nc.uri, ' streamName:', _streamName);
				break;
			case NetConnectionInfoCode.CLOSED:
				if(_ns != null)
				{
					_ns.close();
					_ns.removeEventListener(NetStatusEvent.NET_STATUS, handler_nsStatus);
					_ns = null;
				}
				dispatchEvent(new Event(Event.CLOSE));
				break;
		}
	}
	
	private function setMuted():void
	{
		if(_ns == null) return;
		var __st:SoundTransform = _ns.soundTransform;
		__st.volume = muted ? 0 : 1;
		_ns.soundTransform = __st;
	}
	
	private function handler_nsStatus(evt:NetStatusEvent):void
	{
		trace('VideoDisplay,ns statue:', evt.info.code);
	}
}
}

import flash.events.Event;

import org.zengrong.ui.VideoDisplay;
import org.zengrong.media.NetStreamInfoCode;

/**
 * 这个包外类负责处理URI_STREAM的流事件
 * @author zrong
 */
class StreamClient
{
	private var _videoDisplay:VideoDisplay;
	
	public function StreamClient($video:VideoDisplay)
	{
		_videoDisplay = $video;
	} 
	
	/**
	 * 视频流的播放状态会触发这个方法 
	 * @param $obj 播放状态信息对象
	 */
	public function onPlayStatus($obj:Object):void
	{
		trace('VideoDisplay.NetStream.onPlayStatus:', $obj.code);
		if($obj.code == NetStreamInfoCode.PLAY_COMPLETE)
		{
			_videoDisplay.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	/**
	 * 在收到视频中嵌入的数据信息的时候被触发 
	 * @param $obj 包含视频源数据信息的对象
	 */	
	public function onMetaData($obj:Object):void
	{
		trace('VideoDisplay.NetStream.onMetaData(width,height):', $obj.width, $obj.height);
		_videoDisplay.width = $obj.width;
		_videoDisplay.height = $obj.height;
	}

	public function destroy():void
	{
		_videoDisplay = null;
	}
}
