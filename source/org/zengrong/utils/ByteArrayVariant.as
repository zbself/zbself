////////////////////////////////////////////////////////////////////////////////
//  zengrong.net
//  创建者:	zrong(zrongzrong@gmail.com)
//  创建时间：2012-02-07
////////////////////////////////////////////////////////////////////////////////
package org.zengrong.utils
{
import flash.errors.EOFError;
import flash.utils.ByteArray;

/**
 * 在ByteArray的基础上实现Variant整型的写入与读取
 * @author zrong
 * 创建日期：2012-02-07
 */
public class ByteArrayVariant extends ByteArray
{
	/**
	 * 将提供的ByteArray转换成ByteArrayVariant类型
	 * @param $source 要转换的ByteArray对象
	 * @param $setPosToZero 是否将新的ByteArrayVariant的position设置为0
	 */
	static public function toVariant($byteArray:ByteArray, $setPosToZero:Boolean=false):ByteArrayVariant
	{
		var __vb:ByteArrayVariant = new ByteArrayVariant();
		__vb.endian = $byteArray.endian;
		var __oldpos:int = $byteArray.position;
		$byteArray.position = 0;
		$byteArray.readBytes(__vb);
		__vb.position = $setPosToZero ? 0 : __oldpos;
		return __vb;
	}

	public function ByteArrayVariant()
	{
		super();
	}

	/**
	 * 将32bit的字节保存的多个数字读取成为unit数组<br>
	 * 为了节省数据量，可以使用不同的位数来保存数字，使用这个方法将保存在32位字节中的n个数组读取成一个uint数组。
	 * @param $len 要读取的数字的数量
	 * @param $bitPerInt 指定使用几位来保存1个数字
	 */
	public function readVariantUintVector($len:uint=6, $bitPerInt:uint=5):Vector.<uint>
	{
		//根据数字占有的位数获取对应位数的移位符
		//例如$bitPerInt=5，则移位符为0x1F(111111)；若为6，则移位符为0x3F(111111)
		var __shift:uint = (1<<$bitPerInt)-1;
		var __uint:uint = this.readUnsignedVariantInt();
		var __vector:Vector.<uint> = new Vector.<uint>($len, true);
		for(var i:int=0;i<$len;i++)
		{
			__vector[i] = __uint>>($bitPerInt*i)&__shift;
		}
		return __vector;
	}

	/**
	 * 写入一个有符号可变整型
	 */
	public function writeVariantInt($value:int):void
	{
		var __uint:uint = zigZagEncode($value);
		encodeVarint(__uint);
	}

	/**
	 * 写入一个无符号可变整型
	 */
	public function writeUnsignedVariantInt($value:uint):void
	{
		encodeVarint($value);
	}

	/**
	 * 读取一个有符号可变整型
	 * @throws flash.errors.EOFError  读取到文件尾或者解码错误的时候，抛出错误
	 */
	public function readVariantInt():int
	{
		var __uint:uint = decodeVarint();
		return zigZagDecode(__uint);
	}

	/**
	 * 读取一个无符号可变整型
	 * @throws flash.errors.EOFError 读取到文件尾或者解码错误的时候，抛出错误
	 */
	public function readUnsignedVariantInt():uint
	{
		return decodeVarint();
	}
	
	/**
	 * 读取一个UTF-8字符串，假定字符串前面是无符号的可变整型
	 */	
	public function readVariantUTF():String
	{
		var __len:uint = this.readUnsignedVariantInt();
		return this.readUTFBytes(__len);
	}
	
	public function writeVariantUTF($str:String):void
	{
		//取得字符串的byte长度
		var __ba:ByteArray = new ByteArray();
		__ba.writeUTFBytes($str);
		this.writeUnsignedVariantInt(__ba.length);
		this.writeUTFBytes($str);
	}
	
	/**
	 * 编码并写入Varint字节
	 * @private
	 */
    private function encodeVarint($value:uint):void
	{
      var __bits:int = $value & 0x7f;
	  var __value:uint = $value >> 7; 
	  //解决大于int.MAX_VALUE高位始终为1，导致死循环的情况
	  __value &= 0x01ffffff;
      while(__value)
	  {
		  this.writeByte(0x80|__bits)
		  __bits = __value & 0x7f;
		  __value >>= 7;
		  //解决大于int.MAX_VALUE高位始终为1，导致死循环的情况
		  __value &= 0x01ffffff;
	  }
	  this.writeByte(__bits);
	}

	/**
	 * 解码Varint字节
	 * @private
	 */
    private function decodeVarint():uint
	{
        var __result:int = 0;
        var __shift:int = 0;
		var __byte:int;
        while(this.position<this.length)
		{
            __byte = this.readByte();
            __result |= ((__byte & 0x7f) << __shift);
			//trace('byte:', __byte, ',result:', __result, ',shift', __shift);
            if(!(__byte & 0x80))
			{
				return __result;
			}
			__shift += 7;
			if(__shift >= 32) throw new EOFError('Varint解码错误。');
		}
		throw new EOFError('Varint读取遇到文件尾。');
	}

	/**
	 * 将有符号整型转成无符号整型，方便Varint编码
	 * 转换后，1＝2,-1＝1,-2=3,2=4
	 * @private
	 */
    private function zigZagEncode($value:int):uint
	{
      if ($value >= 0) return $value << 1;
      return ($value << 1) ^ (~0);
	}

	/**
	 * 将编码后的无符号整型进行解码
	 * @private
	 */
    private function zigZagDecode($value:uint):int
	{
    	if(!($value & 0x1)) return $value >> 1;
		return ($value >> 1) ^ (~0);
	}
}
}
