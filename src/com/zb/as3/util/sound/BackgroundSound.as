package ghostcat.util.sound
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class BackgroundSound extends EventDispatcher
	{
		public var url:String;
		public var sound:Sound;
		public var channel:SoundChannel;
		public var loopStart:int;
		
		private var _volume:Number;

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume = value;
			setVolume(value);
		}

		
		private var _curVolume:Number;

		public function get curVolume():Number
		{
			return _curVolume;
		}

		public function set curVolume(value:Number):void
		{
			_curVolume = value;
			
			if (channel)
				channel.soundTransform = new SoundTransform(value);
		}

		
		public function BackgroundSound()
		{
		}
		
		public function setVolume(volume:Number,len:Number = 1000):void
		{
			_volume = volume;
			curVolume = volume;
			
			TweenLite.killTweensOf(this,false);
			TweenLite.to(this,len,{curVolume:volume});
		}
		
		public function playBgSound(url:String,len:int = 1000,mute:Boolean = false,volume:int = 1.0, loopStart:int = 0):void
		{
			if (this.sound && this.url == url)
			{
				setVolume(volume);
				return;
			}
			
			this._volume = volume;
			this.loopStart = loopStart;
			this.url = url;
			
			stop();
			
			if (!mute)
				start();
		}
		
		public function start():void
		{
			if (this.url)
			{
				sound = new Sound(new URLRequest(url),new SoundLoaderContext(1000,true));
				channel = sound.play(0,1);
				if (!channel)
					return;
				
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				
				this.curVolume = 0.0;
				
				TweenLite.killTweensOf(this,false);
				TweenLite.to(this,1000,{curVolume:this.volume});
			}
		}
		
		private function soundCompleteListener(evt:Event):void
		{
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				channel = sound.play(loopStart,1,channel.soundTransform);
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
			}
		}
		
		public function stop(dur:int = 1000):void
		{
			if (sound)
			{
				try
				{
					sound.close();	
				} 
				catch(error:Error){	};
			
				sound = null;
			}
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				TweenLite.killTweensOf(channel,false);
				TweenLite.to(channel,dur,{volume:0.0,onComplete:channel.stop});
				channel = null;
			}
		}
	}
}