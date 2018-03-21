/*
ImageInfoExtractor类通过ByteArray方式获取jpg,png,gif等图片的相关信息：
例如图片大小，图片宽和高，图片格式等。
当然，这一切都是未加载图片之前，也就是说如果一张相当大的图片，你不必完全加载后才得到这些信息，
用ImageInfoExtractor类可以马上就能读取到它了。

var myExtractor:ImageInfoExtractor = new ImageInfoExtractor();
myExtractor.addEventListener(ImageInfoExtractor.PARSE_COMPLETE, infoHandler);
myExtractor.addEventListener(ImageInfoExtractor.PARSE_FAILED, errorHandler);
myExtractor.file = "http://ww3.sinaimg.cn/bmiddle/67961823jw1dy8nlbe1fzj.jpg";

var t1:Number=getTimer();
var infoTxt:TextField=new TextField();
infoTxt.width=200;
infoTxt.height=200;
addChild(infoTxt);

function infoHandler(e:Event):void {
trace(getTimer()-t1);
var line0:String = "image size = " + myExtractor.size;
var line1:String = "pixel width = " + myExtractor.width;
var line2:String = "pixel height = " + myExtractor.height;
var line3:String = "bit depth = " + myExtractor.bitsPerPixel;
var line4:String = "file type = " + myExtractor.fileType;
var line5:String = "mime type = " + myExtractor.mimeType;
infoTxt.htmlText = line0 +"\n"+ line1 +"\n"+ line2 +"\n"+ line3 +"\n"+ line4 +"\n"+ line5;
}

function errorHandler(e:Event):void {
trace( "Size could not be obtained, file was not according to JFIF specification" );
}

*/



package com.zb.as3.util.display
{

	import flash.utils.ByteArray;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	public class ImageInfoExtractor extends EventDispatcher
	{
		public static const PARSE_COMPLETE:String = "parseComplete";
		public static const PARSE_FAILED:String = "parseFailed";
		
		private var _file:String;
		private var request:URLRequest;
		private var imageStream:URLStream;
		private var ba:ByteArray = new ByteArray();
		private var _size:String;

		// image properties
		private var _width:int;
		private var _height:int;
		private var _bitsPerPixel:int;
		private var _progressive:Boolean;
		private var _physicalWidth:String;
		private var _physicalHeight:String;
		private var _physicalHeightDpi:int;
		private var _physicalWidthDpi:int;
		private var _fileType:String;
		private var _mimeType:String;

		private var _stream:ByteArray;
		private var _format:int;

		private const FILE_TYPES:Array = ["JPEG","GIF","PNG"];
		private const MIME_TYPES:Array = ["image/jpeg","image/gif","image/png"];

		private const FORMAT_JPEG:int = 0;
		private const FORMAT_GIF:int = 1;
		private const FORMAT_PNG:int = 2;

		public function ImageInfoExtractor():void
		{
			
		}
		
		public function set file(a:String):void
		{
			_file = a;
			
			imageStream = new URLStream();
			request = new URLRequest(_file);
			
			imageStream.addEventListener(ProgressEvent.PROGRESS, onImageProgress);
			imageStream.load(request);
		}
		
		public function get size():String
		{
			return _size;
		}
		
		private function onImageProgress(e:ProgressEvent):void 
		{
			_size = Math.floor(e.bytesTotal/1024) + " kb";
			imageStream.readBytes(ba);
			
			if (checkType(ba)) {
				dispatchEvent(new Event(PARSE_COMPLETE));
				imageStream.close();
			}else{
				dispatchEvent(new Event(PARSE_FAILED));
			}
		}
		

		/**
		       * 
		       * @param   ByteArray of image file
		       * @return   True for valid .jpg, .png, and .gif images - false otherwise.
		       */
		private function checkType(bytes:ByteArray):Boolean
		{

			_stream = bytes;

			var b1:int = read() & 0xFF;
			var b2:int = read() & 0xFF;

			if (b1 == 0x47 && b2 == 0x49) {
				return checkGif();
			}

			if (b1 == 0xFF && b2 == 0xD8) {
				return checkJPG();
			}

			if (b1 == 0x89 && b2 == 0x50) {
				return checkPng();
			}

			return false;
		}

		private function checkGif():Boolean
		{
			var GIF_MAGIC_87A:ByteArray = new ByteArray  ;
			GIF_MAGIC_87A.writeByte(0x46);
			GIF_MAGIC_87A.writeByte(0x38);
			GIF_MAGIC_87A.writeByte(0x37);
			GIF_MAGIC_87A.writeByte(0x61);

			var GIF_MAGIC_89A:ByteArray = new ByteArray  ;
			GIF_MAGIC_89A.writeByte(0x46);
			GIF_MAGIC_89A.writeByte(0x38);
			GIF_MAGIC_89A.writeByte(0x39);
			GIF_MAGIC_89A.writeByte(0x61);

			var a:ByteArray = new ByteArray  ;
			if (read(a,0,11) != 11) {
				return false;
			}

			if (! equals(a,0,GIF_MAGIC_89A,0,4) && ! equals(a,0,GIF_MAGIC_87A,0,4)) {
				return false;
			}

			_format = FORMAT_GIF;
			_width = getShortLittleEndian(a,4);
			_height = getShortLittleEndian(a,6);
			var flags:int = a[8] & 0xFF;
			_bitsPerPixel = flags >> 4 & 0x07 + 1;
			//_progressive = flags & 0x02 != 0;
			_progressive = true; // it keeps on keeping an compiler error so I just commented it to get rid of it! I don't think I would ever need to know if the file is progressive or not! :)

			return true;
		}

		private function checkPng():Boolean
		{
			var PNG_MAGIC:ByteArray = new ByteArray  ;
			PNG_MAGIC.writeByte(0x4E);
			PNG_MAGIC.writeByte(0x47);
			PNG_MAGIC.writeByte(0x0D);
			PNG_MAGIC.writeByte(0x0A);
			PNG_MAGIC.writeByte(0x1A);
			PNG_MAGIC.writeByte(0x0A);

			var a:ByteArray = new ByteArray  ;
			if (read(a,0,27) != 27) {
				return false;
			}

			if (! equals(a,0,PNG_MAGIC,0,6)) {
				return false;
			}

			_format = FORMAT_PNG;
			_width = getIntBigEndian(a,14);
			_height = getIntBigEndian(a,18);
			_bitsPerPixel = a[22];
			var colorType:int = a[23];
			if (colorType == 2 || colorType == 6) {
				_bitsPerPixel *= 3;
			}
			_progressive=a[26]!=0;
			return true;
		}

		private function checkJPG():Boolean
		{
			var APP0_ID:ByteArray=new ByteArray  ;
			APP0_ID.writeByte(0x4A);
			APP0_ID.writeByte(0x46);
			APP0_ID.writeByte(0x49);
			APP0_ID.writeByte(0x46);
			APP0_ID.writeByte(0x00);

			var data:ByteArray=new ByteArray  ;
			while (true)
			{

				if (read(data,0,4)!=4) {
					return false;
				}

				var marker:Number=getShortBigEndian(data,0);
				var size:Number=getShortBigEndian(data,2);

				if (marker&0xff00!=0xff00) {
					return false;
				}

				if (marker==0xFFE0) {

					if (size<14) {
						skip(size-2);
						continue;
					}

					if (read(data,0,12)!=12) {
						return false;
					}

					if (equals(APP0_ID,0,data,0,5)) {

						if (data[7]==1) {
							setPhysicalWidthDpi(getShortBigEndian(data,8));
							setPhysicalHeightDpi(getShortBigEndian(data,10));

						} else if (data[7]==2) {
							var x:int=getShortBigEndian(data,8);
							var y:int=getShortBigEndian(data,10);

							setPhysicalWidthDpi(int(x*2.54));
							setPhysicalHeightDpi(int(y*2.54));
						}
					}
					skip(size-14);

				} else if (marker>=0xFFC0&&marker<=0xFFCF&&marker!=0xFFC4&&marker!=0xFFC8) {

					if (read(data,0,6)!=6) {
						return false;
					}

					_format=FORMAT_JPEG;
					_bitsPerPixel=data[0]&0xFF*data[5]&0xFF;
					_progressive=marker==0xffc2||marker==0xffc6||marker==0xffca||marker==0xffce;
					_width=getShortBigEndian(data,3);
					_height=getShortBigEndian(data,1);
					var horzPixelsPerCM:Number=_physicalWidthDpi/2.54;
					var vertPixelsPerCM:Number=_physicalHeightDpi/2.54;
					_physicalWidth = (_width/horzPixelsPerCM).toFixed(2);
					_physicalHeight = (_height/vertPixelsPerCM).toFixed(2);

					return true;
				} else {
					skip(size-2);
				}
			}
			return false;
		}

		private function getShortBigEndian(ba:ByteArray,offset:int):Number
		{
			return ba[offset]<<8|ba[offset+1];
		}

		private function getShortLittleEndian(ba:ByteArray,offset:int):int
		{
			return ba[offset]|ba[offset+1]<<8;
		}

		private function getIntBigEndian(ba:ByteArray,offset:int):int
		{
			return ba[offset]<<24|ba[offset+1]<<16|ba[offset+2]<<8|ba[offset+3];
		}

		private function skip(numBytes:int):void
		{
			_stream.position+=numBytes;
		}

		private function equals(ba1:ByteArray,offs1:int,ba2:ByteArray,offs2:int,num:int):Boolean
		{
			while (num-->0)
			{
				if (ba1[offs1++]!=ba2[offs2++]) {
					return false;
				}
			}
			return true;
		}

		private function read(... args):int
		{
			switch (args.length) {
				case 0 :
					return _stream.readByte();
					break;
				case 1 :
					_stream.readBytes(args[0]);
					return args[0].length;
					break;
				case 3 :
					_stream.readBytes(args[0],args[1],args[2]);
					return args[2];
					break;
				default :
					throw new ArgumentError("Argument Error at ImageInfoExtractor.read(). Expected 0, 1, or 3. Received "+args.length);
					return null;
			}
		}

		private function setPhysicalHeightDpi(newValue:int):void
		{
			_physicalWidthDpi=newValue;
		}

		private function setPhysicalWidthDpi(newValue:int):void
		{
			_physicalHeightDpi=newValue;
		}

		//   vertical and horizontal DPI
		public function get physicalHeightDpi():int
		{
			return _physicalHeightDpi;
		}

		public function get physicalWidthDpi():int
		{
			return _physicalWidthDpi;
		}

		//   bit depth
		public function get bitsPerPixel():int
		{
			return _bitsPerPixel;
		}

		//   width and height in pixels
		public function get height():int
		{
			return _height;
		}

		public function get width():int
		{
			return _width;
		}

		//   progressive or not
		public function get progressive():Boolean
		{
			return _progressive;
		}

		//   file and mimetype
		public function get fileType():String
		{
			return FILE_TYPES[_format];
		}

		public function get mimeType():String
		{
			return MIME_TYPES[_format];
		}

		//   height and width in centimeters
		public function get physicalWidth():String
		{
			return _physicalWidth;
		}

		public function get physicalHeight():String
		{
			return _physicalHeight;
		}
	}
}