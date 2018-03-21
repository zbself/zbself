package com.zb.as3.net.load.easyloader
{
	/**
	 * every loaded file will be stored this object,easyLoader.getFileByName() and easyLoader.getFileByAlias() can return a LoadedItem object 
	 * @author  liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 */
	
	dynamic public class LoadedItem
	{
		private var _fileName:String
		private var _alias:String
		private var _content:*
		private var _autoRemove:Boolean
		private var _loadTip:String
		private var _method:String
		private var _path:String
		private var _type:String
		private var _id:uint
		private var _data:Object
		public function LoadedItem($content:*=null,$filename:String="",$id:uint=0,$path:String="",$alias:String="",$type:String="",$loadTip:String="",$autoRemove:Boolean=false,$method:String="text") 
		{
			content = $content;
			fileName = $filename;
			id = $id;
			path = $path;
			alias = $alias;
			type = $type;
			loadTip = $loadTip;
			autoRemove = $autoRemove;
			method = $method;
			
		}
		public function set fileName(str:String):void {
			_fileName = str;
		}
		public function set alias(str:String):void {
			_alias = str;
		}
		public function set content(target:*):void {
			_content = target;
		}
		public function set autoRemove(bol:Boolean):void {
			_autoRemove = bol;
		}
		public function set loadTip(str:String):void {
			_loadTip = str;
		}
		public function set method(str:String):void {
			_method = str;
		}
		public function set path(str:String):void {
			_path = str;
		}
		public function set  type(str:String) :void{
			_type = str;
		}
		public function set id(i:uint):void {
			_id=i
		}
		public function get fileName():String {
			return _fileName;  
		}
		public function get alias():String {
			return _alias;
		}
		public function get content():* {
			return _content ;
		}
		public function get autoRemove():Boolean {
			return _autoRemove ;
		}
		public function get loadTip():String {
			return _loadTip;
		}
		public function get method():String {
			return _method ;
		}
		public function get path() :String{
			return _path ;
		}
		public function get  type():String {
			return _type ;
		}
		public function get id():uint {
			return _id;
		}
		public function set data(obj:Object) {
			_data=obj
		}
		public function get data():Object {
			return _data
		}
		public function  dispose():void {
			content = null;
		}
		
	}
}