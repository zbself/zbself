package com.zb.as3.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	/**
	 * 快速创建简单文本
	 */
	public class Text
	{
		/**
		 * 创建一个单行的TextLine
		 * @param $str 文本内容
		 * @param $width 文本宽度
		 * @return 单行的TextLine
		 */	
		public static function createTextLine($str:String, $width:Number, $family:String="Microsoft YaHei" ,$bold:Boolean=true, $color:uint=0x000000, $size:int=12, $font:FontDescription=null):TextLine
		{
			if(!$font)
				$font = new FontDescription($family||="Microsoft YaHei" , $bold?'bold':"normal");
			var __ef:ElementFormat = new ElementFormat($font);
			__ef.color = $color;
			__ef.fontSize = $size;
			var __tb:TextBlock = new TextBlock(new TextElement($str, __ef));
			return __tb.createTextLine(null, $width);
		}
		public static function creatTextField($str:String, $width:Number, $height:Number, $family:String="Microsoft YaHei", $bold:Boolean=false, $color:uint=0x000000, $size:int=12):TextField
		{
			var textField:TextField = new TextField();
			textField.width = $width;
			textField.height = $height;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = $str;
			var textFormat:TextFormat = new TextFormat($family,$size,$color,$bold);
			textFormat.align = TextFormatAlign.LEFT;
			textField.defaultTextFormat = textFormat;
			return textField;
		}
	}
}