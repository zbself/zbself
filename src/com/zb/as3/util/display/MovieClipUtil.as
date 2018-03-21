package com.zb.as3.util.display
{
	import com.zb.as3.events.FrameEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * MovieClipUtil 影片剪辑类
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see carlylee
	 */
	public class MovieClipUtil
	{
		/**
		 * @param $mc:MovieClip
		 * @param $reset:Boolean  全面冻结MovieClip。true：停止第一帧。flash：停止当前帧
		 */
		public static function freezeMovieClip( $mc:MovieClip, $reset:Boolean=false ):void{
			if( $mc==null ) return;
			var i:int = $mc.numChildren;
			if( $reset ) $mc.gotoAndStop( 1 );
			else $mc.stop();
			while( --i>-1 ){
				if($mc.getChildAt(i) is MovieClip)
				{
					freezeMovieClip( MovieClip( $mc.getChildAt(i) ), $reset );
				}
			}
		}
		
		/**
		 * @param $mc
		 * @param $fromFirstFrame 全面激活MovieClip。true：播放第一帧。flash：播放当前帧
		 */
		public static function unfreezeMovieClip( $mc:MovieClip, $fromFirstFrame:Boolean=false ):void{
			if( $mc==null ) return;
			var i:int = $mc.numChildren;
			if( $fromFirstFrame ) $mc.gotoAndPlay( 1 );
			else $mc.play();
			while( --i>-1 ){
				if($mc.getChildAt(i) is MovieClip)
				{
					unfreezeMovieClip( MovieClip( $mc.getChildAt(i) ), $fromFirstFrame );
				}
			}
		}
		/**
		 * 顺播MovieClip
		 * @param $mc:MovieClip 播放对象
		 * @param $playNum 播放次数（0：无限循环播放。1：播放一次。2：播放二次...）
		 * (使用EnterFrame播放)
		 */
		public static function playNextFrame( $mc:MovieClip , $playNum:int = 0):void{
			$mc.playNum = $playNum;
			$mc.addEventListener( Event.ENTER_FRAME, onNextEnter );
			$mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_NEXT_START ));
		}
		private static function onNextEnter( $e:Event ):void{
			var mc:MovieClip = $e.currentTarget as MovieClip;
			if( mc.currentFrame < mc.totalFrames ){
				mc.nextFrame();
			}else{
				mc.playNum--;
				if(mc.playNum)
				{
					mc.gotoAndStop(1);
					mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_FINISH ));
				}else{
					mc.removeEventListener( Event.ENTER_FRAME, onNextEnter );
					mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_ENDED ));
				}
			}
		}
		/**
		 * 倒播MovieClip
		 * @param $mc:MovieClip 播放对象
		 * @param $playNum 播放次数（0：无限循环播放。1：播放一次。2：播放二次...）
		 * (使用EnterFrame播放)
		 */
		public static function playPrevFrame( $mc:MovieClip , $playNum:int = 0):void{
			$mc.playNum = $playNum;
			$mc.addEventListener( Event.ENTER_FRAME, onPrevEnter );
			$mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_PREV_START ));
		}
		private static function onPrevEnter( $e:Event ):void{
			var mc:MovieClip = $e.currentTarget as MovieClip;
			if( mc.currentFrame > 1 ){
				mc.prevFrame();
			}else{
				mc.playNum--;
				if(mc.playNum)
				{
					mc.gotoAndStop(mc.totalFrames);
					mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_FINISH ));
				}else{
					mc.removeEventListener( Event.ENTER_FRAME, onPrevEnter );
					mc.dispatchEvent( new FrameEvent( FrameEvent.FRAME_ENDED ));
				}
			}
		}
	}
}