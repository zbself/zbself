package com.zb.as3.events
{
	import flash.events.Event;
	
	/**
	 * FrameEvent<br>
	 *
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 下午2:17:28 / 2017-3-17
	 * @see Eunjeong, Lee.
	 */
	public class FrameEvent extends Event
	{
		public static const FRAME_START:String = "frameStart";
		public static const FRAME_NEXT_START:String = "frameNextStart";
		public static const FRAME_PREV_START:String = "framePrevStart";
		public static const FRAME_ENDED:String = "frameEnded";
		public static const FRAME_FINISH:String = "frameFinish";
		
		public var frameLabel:String = "";
		public var frameIndex:int = 0;
		
		public function FrameEvent(type:String, frameIndex:int=0, frameLabel:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.frameIndex = frameIndex;
			this.frameLabel = frameLabel;
			
		}
		
		public override function clone():Event{
			return new FrameEvent( type, frameIndex, frameLabel, bubbles, cancelable );
		}
		
		public override function toString():String{
			return formatToString( "FrameEvent", "type", "frameLabel", "frameIndex", "bubbles", "cancelable", "eventPhase" );
		}
	}
}