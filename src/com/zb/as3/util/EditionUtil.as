package  com.zb.as3.util
{
	import com.google.zxing.maxicode.MaxiCodeReader;
	import com.zb.as3.util.math.NumberFormatUtil;
	
	/**
	 * EditionUtil<br>
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public final class EditionUtil
		
	{
		//上一个版本号变动 下级要归零
		//日期为发布时的当前日期
		/**
		 * 基础版本（基础框架 简单功能/布局 ）——初级
		 */		
		public static const BASE:String = "base";
		/**
		 * 初级版本（测试版本 内部交流使用 BUG多）——交测试
		 */		
		public static const ALPHA:String = "alpha";
		/**
		 * 修正版本（基本修复BUG）——测试验收
		 */		
		public static const BETA:String = "beta";
		/**
		 * 成熟版本 （即发行版）——公测版
		 */		
		public static const RC:String = "rc";
		/**
		 * 发布版本（最终标准版本）——上线
		 */		
		public static const RELEASE:String = "release";
		/**
		 * type 版本等级,越高越新
		 */		
		private static const EDITION_TYPES:Array = [BASE,ALPHA,BETA,RC,RELEASE];
		
		public function EditionUtil()
		{
		}
		/**
		 * 输出版本号
		 * @param major 主版本号
		 * @param minor 次版本号
		 * @param build 修订/创建版本号
		 * @param date 发布日期（直接显示date字符 / 若为 EditionUtil.DATA :默认当前日期/时间。）
		 * @param showTime 显示时间 01:00
		 * @param type Base/Alpha/Beta/RC/Release
		 * @param head 补充参数（通常为空）：ver 0.0.1
		 * @return 
		 * 
		 */		
		public static function exout( major:int,minor:int,build:int,date:String='',showTime:Boolean=false,type:String='',head:String=''):String
		{
			var end:String='';
			if(head)	end += head;
			end += major?		major	:'0';
			end += minor?	'.'+minor	:'.0';
			end += build?	'.'+build	:'.0';
			end += date?	'.'+date		: '.'+getEditionDate(showTime)	;
			end += type?		'_'+type		:'';
			return end;
		}
		/**
		 * 获取当前发布的版本时间
		 * @return 
		 * 20170101 > 170101
		 */
		private static function getEditionDate(showTime:Boolean=false):String
		{
			var date:Date = new Date();
			var tYear:String = StringUtil.subLastNum(String(date.fullYear),2);
			var tMonth:String = NumberFormatUtil.fillZeros(String(date.month+1),2);
			var tDate:String = NumberFormatUtil.fillZeros(String(date.date),2);
			var tHour:String = NumberFormatUtil.fillZeros(String(date.hours),2);
			var tMinutes:String = NumberFormatUtil.fillZeros(String(date.minutes),2);
			
			if(showTime)
			{
				tDate += ' '+tHour+':'+tMinutes;
			}
			return tYear+tMonth+tDate;
		}
		/**
		 * 判断是否是新版本
		 * 0.0.1.150101 11:00 > 0.0.1.150101 12:00
		 * 
		 * @return 最新:true 旧版本:false
		 **/
		public static function compareVersion(currentV:String, newV:String):Boolean
		{
//			currentV.length > newV.length ? newV = NumberUtil.fillEndZeros( newV , currentV.length ,'.0')	:	currentV = NumberUtil.fillEndZeros( currentV , newV.length ,'.0');//bug废弃方法
			trace( currentV +" - "+newV );
			var crtType:String , newType:String , crtTypeIndex:int , newTypeIndex:int;
			var crtGroup:Array = currentV.split('_');
			currentV = crtGroup[0];
			crtType = crtGroup.length>1 ? crtGroup[1] : '';
			
			var newGroup:Array = newV.split('_');
			newV = newGroup[0];
			newType = newGroup.length>1 ? newGroup[1] : '';
			
			var crtArr:Array = currentV.split('.');
			var newArr:Array = newV.split('.');
			var maxLen:int = crtArr.length < newArr.length ? newArr.length : crtArr.length;
			crtArr = ArrayUtil.fullNumKeys( crtArr , maxLen , "0" );
			newArr = ArrayUtil.fullNumKeys( newArr , maxLen , "0" );
			
			if( compareNums( crtArr , newArr ) )
			{
				crtTypeIndex = EDITION_TYPES.indexOf( crtType );
				newTypeIndex = EDITION_TYPES.indexOf( newType );
//				if( (crtTypeIndex != -1) && ( newTypeIndex != -1) )
				return (crtTypeIndex >= newTypeIndex);
			}
			return false;
		}
		/*
		 * 返回是否最新版
		 **/
		private static function compareNums( crtArr:Array , newArr:Array ):Boolean
		{
			var crtStr:String,crtV:Number,newStr:String,newV:Number;
			for (var i:int = 0; i < crtArr.length; i++) 
			{
				crtStr = crtArr[i] ? crtArr[i] : '0';
				crtV =  Number(StringUtil.onlyNumber( crtStr ));
				
				newStr = newArr[i] ? newArr[i] : '0';
				newV = Number(StringUtil.onlyNumber( newStr ));
				
				if(crtV == newV)
					continue;
				else
					return crtV >= newV ;
			}
			return true;
		}
	}
}