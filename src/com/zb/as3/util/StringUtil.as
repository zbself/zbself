package com.zb.as3.util
{
	import flash.utils.ByteArray;
	
	public class StringUtil {
		/**		<code>""</code>	*/
		private static const EMPTY:String = '';
		private var translateArray:Array = [
			[ "&", "&amp;" ],//这个要放在第一位
			[ " ", "&nbsp;"],
			[ "<", "&lt;" ],
			[ ">", "&gt;" ],
			[ "\"", "&quot;" ],
            [ "'", "&apos;" ],
            [ "", "&szlig;" ],
            [ "\"", "&quot;" ]
        ];
		
		/**文本为非空*/
		public static function isNotEmpty(str:String):Boolean
		{
			if (str == null || str == "") {
				return false;
			}
			return true;
		}
		/**文本为 空*/
		public static function isEmpty(str:String):Boolean
		{
			return isNotEmpty(str)? str.length == 0 : true;
		}
		/**
		 * 比较字符是否全相等;
		 */		
		public static function equals(char1:String,char2:String):Boolean
		{
			return char1 == char2;
		}
		/**
		 * 比较字符是否相等(忽略大小写)
		 */		
		public static function equalsIgnoreCase(char1:String,char2:String):Boolean
		{
			return char1.toLowerCase() == char2.toLowerCase();
		}
		/**
		 * 比较字符是否相等(去掉空格/换行等符号)
		 */
		public static function equals2(char1:String,char2:String):Boolean
		{
			
			return trimAll(char1) == trimAll(char2);
		}
		/**
		 * 比较字符是否相等(忽略大小写&去掉空格/换行等符号)
		 */
		public static function equals3(char1:String,char2:String):Boolean
		{
			
			return trimAll(char1.toLowerCase()) == trimAll(char2.toLowerCase());
		}
		/**
		 * 去除换行/制表/回车/换页
		 */
		public static function clearLine( char:String ):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\t|\r|\n|\b|\f|\v/g;
			return char.replace(pattern,"");
		}
		
		/**
		 * 是否为Email地址;
		 */
		public static function isEmail(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否是手机号码
		 */;
		public static function isPhone(char:String):Boolean
		{
			var pattern:RegExp =  /^0?(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否是数值字符串;
		 */
		public static function isNumber(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			return !isNaN(Number(char));
		}
		/**
		 * 是否为Double型数据;
		 * @param char
		 * @return 
		 */		
		public static function isDouble(char:String):Boolean
		{
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为Integer 整数;
		 * @param char
		 * @return 
		 */	
		public static function isInteger(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 英文字母 
		 * @param char
		 * @return 
		 */		
		public static function isEnglish(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 中文汉字 
		 * @param char
		 * @return 
		 */		
		public static function isChinese(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 双字节 
		 * @param char
		 * @return 
		 */		
		public static function isDoubleChar(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 判断字节长度，汉字2个，英文1个 
		 * @param str
		 * @return 
		 */		
		public static function getByteLen(str:String):int
		{
			var len:int = 0;
			for(var i:int = 0;i<str.length;i++)
			{
				if(isChinese(str.charAt(i)))
				{
					len +=2;
				}else
				{
					len +=1;				
				}
			}
			return len;
		}
		/**
		 * 含有中文汉字 
		 * @param char
		 * @return 
		 */		
		public static function hasChineseChar(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		
		/**
		 * 一般注册用户名格式 
		 * @param char
		 * @param len
		 * @return 
		 */		
		public static function hasAccountChar(char:String,len:uint=15):Boolean
		{
			if (char == null) {
				return false;
			}
			if (len < 10) {
				len = 15;
			}
			char = trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", "");//字母开头，字母结尾
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * URL地址 
		 * https|http|ftp|rtsp|mms 开头
		 * @param char
		 * @return 
		 */		
		public static function isURL(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^((https|http|ftp|rtsp|mms)?:\/\/)[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * IP地址 
		 * 0.0.0.0 > 255.255.255.255
		 * @param char
		 * @return 
		 */		
		public static function isIP(char:String):Boolean
		{
			if (char == null) {
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}		
		/**
		 *  如果指定的字符串是单个空格、制表符、回车符、换行符或换页符，则返回 true。
		 *  @param str 查询的字符串。
		 *  @return 如果指定的字符串是单个空格、制表符、回车符、换行符或换页符，则为<code>true</code>。
		 */
		public static function isWhitespace(char:String):Boolean
		{
			switch (char) {
				case " " :
				case "\t" :
				case "\r" :
				case "\n" :
				case "\f" :
					return true;
				default :
					return false;
			}
		}
		/**
		 * 是否身份证合法
		 * @param idcard
		 * @return 
		 */
		static public function isIDCard(idcard:String):Boolean
		{
			var pattern:RegExp = /^\s*|\s*$/;
			if(idcard =="")
			{
				trace("输入身份证号码不能为空!");  
				return (false);
			}
			if (idcard.length != 15 && idcard.length != 18)//必须为15位或者是18位
			{
				trace("输入身份证号码格式不正确1!");  
				return (false);  
			}
			
			var area:Object = {11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"};   
			//			var areaArray:Array=new Array();
			//			areaArray=[11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,
			//				63,64,65,71,81,82,91]
			//			var areaId:int=parseInt(idcard.substr(0,2));
			//			for (var j:int = 0; j < areaArray.length; j++) 
			//			{
			//				if (areaArray[i]!=areaId)//没有匹配项的话就不合法
			//				{
			//					trace("身份证号码不正确(地区非法)!");  
			//					return (false);  
			//				}
			//			}
			if(area[parseInt(idcard.substr(0,2))]==null) 
			{
				trace("身份证号码不正确(地区非法)!");  
				return (false);  
			}
			if (idcard.length == 15)
			{
				pattern= /^\d{15}$/;  
				if (pattern.exec(idcard)==null)
				{
					trace("15位身份证号码必须为数字！");  
					return (false);
				}
				var birth:Number = parseInt("19" + idcard.substr(6,2));
				var month:String = idcard.substr(8,2);
				var day:Number = parseInt(idcard.substr(10,2));
				switch(month)
				{
					case '01':  
					case '03':  
					case '05':  
					case '07':  
					case '08':  
					case '10':  
					case '12':  
						if(day>31)
						{
							trace('输入身份证号码不格式正确2!');  
							return false;  
						}
						break;  
					case '04':
					case '06':
					case '09':
					case '11':
						if(day>30)
						{
							trace('输入身份证号码不格式正确3!');
							return false;
						}
						break;
					case '02':
						if((birth % 4 == 0 && birth % 100 != 0) || birth % 400 == 0)//闰年
						{
							if(day>29)
							{
								trace('输入身份证号码不格式正确4!');
								return false;
							}
						}
						else 
						{
							if(day>28) {
								trace('输入身份证号码不格式正确5!');
								return false;
							}
						}
						break;
					default:
						trace('输入身份证号码不格式正确6!');
						return false;
				}
				var nowYear:Number = new Date().fullYear;
				if( nowYear - parseInt( String(birth))<0 || nowYear - parseInt(String(birth))>110 )//年龄限制
				{
					trace('输入身份证号码不格式正确7!');
					return false;
				}
				return (true);
			}
			//系数
			var Wi:Array= new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2);
			var   lSum:Number  = 0;
			var   nNum:Number  = 0;
			var   nCheckSum:Number  = 0;
			for (var i:int = 0; i < 17; ++i)
			{
				if ( idcard.charAt(i) < '0' || idcard.charAt(i) > '9' )
				{
					trace("输入身份证号码格式不正确8!");
					return (false);
				}
				else
				{
					nNum = Number(idcard.charAt(i)); //获得每个位子上的数字
				}
				lSum += nNum * Wi[i];  //将这17位数字和系数相乘的结果相加
			}
			if( idcard.charAt(17) == 'X' || idcard.charAt(17) == 'x')
			{
				lSum += 10*Wi[16];
			}
			else if ( idcard.charAt(17) < '0' || idcard.charAt(17) > '9' )
			{
				trace("输入身份证号码格式不正确9!");
				return (false);
			}
			else
			{
				lSum += Number(( idcard.charAt(17))) * Wi[16];
			}
			var yu:Number=lSum % 11;//用加出来的和除以11，看余数是多少？
			
			switch(yu)//余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字。
				//其分别对应的最后一位身份证的号码为1－0－X －9－8－7－6－5－4－3－2 。
			{
				case 0:
				{
					return true;
				}
				case 1:
				{  
					return true;  
				}  
				case 2:
				{  
					return true;  
				}  
				case 3:
				{  
					return true;  
				}  
				case 4:
				{  
					return true;  
				}  
				case 5:
				{  
					return true;  
				}  
				case 6:
				{  
					return true;  
				}  
				case 7:
				{  
					return true;  
				}  
				case 8:
				{  
					return true;  
				}  
				case 9:
				{  
					return true;  
				}  
				case 10:
				{  
					return true;  
				} 
				default:
				{
					trace("输入身份证号码格式不正确10!");  
					return (false);  
				}
			}
		}
		
		/**
		 * 去左右两端空格;
		 * @param char
		 * @return 
		 */	
		public static function trim(char:String):String
		{
			if (char == null) {
				return null;
			}
			return rtrim(ltrim(char));
		}
		/**
		 * 去 左空格; ^
		 * @param char
		 * @return 
		 */	
		public static function ltrim(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return char.replace(pattern,"");
		}
		/**
		 * 去 右空格; $
		 * @param char
		 * @return 
		 */		
		public static function rtrim(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return char.replace(pattern,"");
		}
		/**
		 * 去除所有空格换行... 符号
		 * @param char
		 * @return 
		 */		
		public static function trimAll(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\s/g;
			return char.replace(pattern,"");
		}
		/**
		 * 是否为前缀字符串;
		 * @param char
		 * @param prefix
		 * @return 
		 * 
		 */		
		public static function beginsWith(char:String, prefix:String):Boolean
		{
			return prefix == char.substring(0,prefix.length);
		}
		/**
		 *  是否为后缀字符串;
		 * @param char
		 * @param suffix
		 * @return 
		 * 
		 */
		public static function endsWith(char:String, suffix:String):Boolean
		{
			return (suffix == char.substring(char.length - suffix.length));
		}
		/**
		 * 去除指定字符串;
		 * @param char 原字符串
		 * @param remove 要删除的字符串
		 * @return 新的字符串
		 */
		public static function remove(char:String,remove:String):String
		{
			return replace(char,remove,"");
		}
		/**
		 * 去除指定特殊字符串集合;
		 * @param char 原字符串
		 * @param remove 要删除的字符串集合（删除每个特殊字符: &^%#@#$%...)
		 * @return 新的字符串
		 */
		public static function removes(char:String,removes:String):String
		{
			var arr:Array = removes.split('');
			for each (var str:String in arr) 
			{
				char = remove( char , str );
			}
			return char;
		}
		/**
		 * 字符串替换
		 * @param char 原始字符串
		 * @param replace 旧值
		 * @param replaceWith 新值
		 * @param rpAll 替换全部匹配字符
		 * @return 
		 */		
		public static function replace(char:String, replace:String, replaceWith:String,rpAll:Boolean=false):String
		{
			while(char.indexOf(replace)!=-1)
			{
				char = char.replace(replace, replaceWith);
				if(!rpAll) return char;
			}
			return char;
		}
		/**
		 * 字符串替换
		 * @param char 原始字符串
		 * @param replace 旧值
		 * @param replaceWith 新值
		 * @return 
		 */		
		public static function replaceAll(char:String, replace:String, replaceWith:String):String
		{
			return char.split(replace).join(replaceWith);
		}
		/**
		 * utf16转utf8编码;
		 * @param char
		 * @return 
		 */		
		public static function utf16to8(char:String):String
		{
			var out:Array = new Array();
			var len:uint = char.length;
			for (var i:uint=0; i<len; i++) {
				var c:int = char.charCodeAt(i);
				if (c >= 0x0001 && c <= 0x007F) {
					out[i] = char.charAt(i);
				} else if (c > 0x07FF) {
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
					                                                 0x80 | ((c >>  6) & 0x3F),
					                                                 0x80 | ((c >>  0) & 0x3F));
				} else {
					out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
					                                                 0x80 | ((c >>  0) & 0x3F));
				}
			}
			return out.join('');
		}
		/**
		 * utf8转utf16编码;
		 * @param char
		 * @return 
		 */	
		public static function utf8to16(char:String):String
		{
			var out:Array = new Array();
			var len:uint = char.length;
			var i:uint = 0;
			while (i<len) {
				var c:int = char.charCodeAt(i++);
				switch (c >> 4) {
					case 0 :
					case 1 :
					case 2 :
					case 3 :
					case 4 :
					case 5 :
					case 6 :
					case 7 :
						// 0xxxxxxx
						out[out.length] = char.charAt(i-1);
						break;
					case 12 :
					case 13 :
						// 110x xxxx   10xx xxxx
						var char1:int = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char1 & 0x3F));
						break;
					case 14 :
						// 1110 xxxx  10xx xxxx  10xx xxxx
						var char2:int = char.charCodeAt(i++);
						var char3:int = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
						                            ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}
		
		private static const punctuationMapping:Array = [[",",".",":",";","?","\\","\/","[","]","`"],
			["，","。","：","；","？","、","、","【","】","·"]]
		/**
		 * 转换中文标点 
		 * @param v
		 * @param m1	是右单引号
		 * @param m2	是右双引号
		 * @return 
		 * 
		 */
		public static function toChinesePunctuation(v:String,m1:Boolean = false,m2:Boolean = false):String
		{
			var result:String = "";
			for (var i:int = 0;i<v.length;i++)
			{
				var ch:String = v.charAt(i);
				if (ch == "'")
				{
					m1 = !m1;
					result += m1?"‘":"’";
				}
				else if (ch == "\"")
				{
					m2 = !m2;
					result += m2?"“":"”";
				}
				else
				{
					var index:int = (punctuationMapping[0] as Array).indexOf(v.charAt(i));
					if (index != -1)
						result += punctuationMapping[1][index];
					else
						result += v.charAt(i);
				}
			}
			return result;
		}
		/**
		 * 从右向左搜索字符串，并返回在 val 之后的字符串
		 * @param _str 所需要截取的字符串
		 * @param val 要搜索的字符串
		 * @return 所需要截取的字符串
		 */		
		public static function lastSubstring(str:String,val:String):String
		{
			str = StringUtil.trim(str);
			return str.substring(str.lastIndexOf(val)+1,str.length);
		}
		
		/**`
		 * 截取字符串
		 * @param str
		 * @param choice
		 * @param val
		 * @return 
		 * 
		 */
		public static function InterceptString(str:String, choice:Boolean = false,val:String=","):String
		{
			var num:uint = str.indexOf(val);
			if (choice) str = str.slice(num+1);
			else str = str.slice(0,num);
//			choice ? str.slice( str.indexOf(val)+1) : str.slice(0,str.indexOf(val));
			return str;
		}
		/**
		 * 一字符串截掉前几位
		 * @param str 要截取的字符串
		 * @param num 从左开始共截取几位
		 * @return 截后的新字符串
		 * 
		 */		
		public static function subNum(str:String,num:int):String
		{
			var len:int = str.length;
			if(len>=num)
			{
				return str.substring(0,len-num+1);
			}else
			{
				return "";
			}
		}
		/**
		 * 截取一字符串的后几位 
		 * @param str 要截取的字符串
		 * @param num 从右开始共截取几位
		 * @return 截后的新字符串
		 * 
		 */		
		public static function subLastNum(str:String,num:int):String
		{
			var len:int = str.length;
			if(len>=num)
			{
				return str.substring(len-num,len);
			}else
			{
				return "";
			}
		}
		/**
		 * 替换屏蔽关键字方法
		 */		
		public static function replaceShieldingWord(_str:String):String
		{
			var newStr:String;
			var len:int;
			for each(var word:String in _str)
			{
				len = word.length;
				newStr = "";
				for(var i:int = 0;i<len;i++)
				{
					newStr += "*"
				}
				var myPattern:RegExp = new RegExp(word,"g");  
				
				_str = _str.replace(myPattern,newStr)
			}
			return _str;
		}
		
		/**
		 * 小数计算整数位 省略 $digit 位小数
		 * @param $value 原值
		 * @param $$digit 省略小数位位数
		 * 
		 * @return 返回原值
		 */
		public static function decimal(value:Number,n:Number):Number
		{    
			var tn:Number = Math.pow(10,n);
			return Math.round(value*tn)/tn;
		}
		/**
		 * 获取字符换 .后缀(扩展名)
		 * 
		 * @param char 文件名
		 * @return 后缀名( 没有,则返回:"")
		 * 
		 */		
		public static function getExtension(char:String):String
		{
			var flag:int = char.lastIndexOf(".");
			if(flag==-1) flag = char.length;
			//.扩展名
			var extension:String = char.substr(flag, char.length);
			return extension;
		}
		/**		去掉数字		*/
		public static function onlyNumber(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\D/g;
			return char.replace(pattern,"");
		}
		/**		去掉字母 a-z A-Z		*/
		public static function clearLetter(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /[a-zA-Z]/g;
			return char.replace(pattern,"");
		}
		/**		去掉点 .		*/
		public static function clearDot(char:String):String
		{
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /[.]/g;
			return char.replace(pattern,"");
		}
		
		
		public static function getVal( char:String ):Number
		{
			return isNumber(char)?Number(char):0;
		}
		
		
		/**
		 * 从左侧截取某索引的字符串
		 * @param char 字符串
		 * @param index 左侧索引 默认0
		 */
		public static function lcut(char:String,index:int=0):String
		{
			return char.charAt(index);
		}
		/**
		 * 从右侧截取某索引的字符串
		 * @param char 字符串
		 * @param index 右侧索引 默认0
		 */
		public static function rcut(char:String,index:int=0):String
		{
			return  isEmpty(char)?"":char.charAt(char.length-index-1);
		}
		/**
		 * 截取字符串
		 * @param char 字符串
		 * @param startIndex 起始索引 默认0
		 * @param endIndex 结束索引 默认int.MAX_VALUE,即数组最大索引
		 */
		public static function cut(char:String,startIndex:int=0,endIndex:int=int.MAX_VALUE):String
		{
			if(isEmpty(char)) return "";
//			if(endIndex==0) endIndex = char.length;
			return char.substring(startIndex,endIndex);
		}
		/**
		 * 截取字符串
		 * @param char 字符串
		 * @param startIndex 起始索引 默认0
		 * @param endIndex 结束索引 默认int.MAX_VALUE,即数组最大长度
		 */
		public static function cut2(char:String,startIndex:int=0,length:int=int.MAX_VALUE):String
		{
			if(isEmpty(char)) return "";
			return char.substr(startIndex,length);
		}
		/**
		 * 截取字符串
		 * @param char 字符串
		 * @param startIndex 起始索引 默认0
		 * @param endIndex 结束索引 默认int.MAX_VALUE,即数组最大索引
		 */
		public static function cut3(char:String,startIndex:int=0,endIndex:int=int.MAX_VALUE):String
		{
			if(isEmpty(char)) return "";
			return char.slice(startIndex,endIndex);
		}
		/**
		 * 取得某个字符的ASCII码
		 */ 
		public static function charCodeAt(src:String, index:int):int{
			return src.charCodeAt(index);
		}
		
		/**
		 * 按照某个标识分割成数组
		 */ 
		public static function toArray(char:String, flg:String):Array{
			return char.split(flg);
		}
		/**
		 * 是否包含
		 */ 
		public static function contains(char:String, flg:String):Boolean{
			return char.indexOf(flg) !=- 1;
		}
		/**
		 * 把xml里面的特殊字符转换成替代字符
		 */ 
		public function encodeXML(text:String):String{
			var s:String = text;
			for (var i:int = 0; i < translateArray.length; i++) {
				s = replaceAll(s, translateArray[i][0], translateArray[i][1]);
			}
			return s;
		}
		/**
		 * 把替代字符还原成xml字符
		 */
		public function decodeXML(text:String):String{
			var s:String = text;
			for (var i:int = 0; i < translateArray.length; i++) {
				s = replaceAll(s, translateArray[i][1], translateArray[i][0]);
			}
			return s;
		}
		/**
		 * 把字符串转换成UTF-8的编码
		 */ 
		public static function encodeUTF(src:String):String{
			return encodeURIComponent(src);
		}
		/**
		 * 从UTF-8转换成原来的编码
		 */ 
		public static function decodeUTF(src:String):String
		{
			return decodeURIComponent(src);
		}
		//--------------------------------------------------//
		//-----------------------End-----------------------//
		//--------------------------------------------------//
		public function StringUtil(enforcer:SingletonEnforcer)
		{
			throw new Error("StringUtil class is static container only");
		}
		
	}
}
class SingletonEnforcer {}