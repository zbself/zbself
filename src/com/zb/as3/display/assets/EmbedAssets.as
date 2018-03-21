package com.zb.as3.display.assets
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	/**
	 * EmbedAssets 素材嵌图类<br>
	 *	getTexture			方法 ,（对象加入对象池中）提取素材;
	 * 	delTexture			方法 , 删除对象池中的对象;
	 * 
	 * @author zbself
	 * @E-mail zbself@qq.com
	 * @created 上午00:00:00 / 2015-1-1
	 * @see 
	 */
	public class EmbedAssets
	{
		
		//==========嵌入的资源==========//
//		[Embed(source="tips.png",scaleGridTop="9",scaleGridLeft="9",scaleGridRight="10",scaleGridBottom="10")]
		[Embed(source="tips.png")]
		public static const ASSET_AS3:Class;
		//==========================//
		
		private static var imageDic:Dictionary = new Dictionary();
		/**
		 * 提取嵌入的 图片bitmap
		 * @param name 名称（name 来自Assets类中嵌入的Class名称）
		 * @return bitmap ImageBitmap
		 */
		public static function getTexture(name:String):Bitmap
		{
			if (imageDic[name] == undefined)
			{
				var bitmap:Bitmap = Bitmap( new EmbedAssets[name]() );
				imageDic[name] = bitmap;
			}
			return imageDic[name];
		}
		/**
		 *	清理 
		 * @param name 名称
		 * @return 清理返回true /未清理 返回 false（ 可能因为对象池没有该对象）
		 */
		public static function delTexture(name:String):Boolean
		{
			if( imageDic[name] )
			{
				delete imageDic[name];
				return true;
			}else	return false;
		}
		public function loadAssets( url:String ):void
		{
			
		}
	}
}