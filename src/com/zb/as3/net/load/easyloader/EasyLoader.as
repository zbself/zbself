package com.zb.as3.net.load.easyloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.net.URLLoaderDataFormat
	
	/**
	 * Hi,guys!Very happy to announce to the world,my easyLoader project was updated to 1.012.
	 * this class can be used to load sound,video,txt,xml,image,swf,event dae and on.and you guys can add custom file type for easyLoader.
	 * author :liuyi email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 * 
	 * What is easyLoader?
	 * This work is use load all the assets of  website or game,it is an good assets manager.
	 * People can use it to load sound,video,txt,xml,image,swf,dae and so on.
	 * 
	 * Why we need it?
	 * -easy of use
	 * 	 Every method have a good naming,you can use it likes speak to an friend.Only need several lines to complete the work.
	 * 
	 * -never be lost items
	 *   load items one by one.
	 * 
	 * -excellent memory manage
	 * 	 Using it continually more than 24 hours,memory do not increase without limit.item can be destoried,easyLoader Object(include all assets) too.
	 * 
	 * -flexible
	 * 	User can add custom file type to loading.
	 * 
	 * -dynamic add items for easyLoader
	 *  EasyLoader can add and load new assets anytime and anywhere,although all the items were loaded.
	 * 
	 * -Updates
	 *  will updates according to user's requirements.
	 * 
	 * 
	 * How to use?
	 * 
	 * Realy only need several lines:
	 * 
	 * step1:
	 * new a easyLoader Object
	 * line1: var _assetsManager = new EasyLoader();
	 * 
	 * step2:
	 * add some necessary event Listener
	 * line2: _assetsManager.addEventListener(EasyLoaderEvent.COMPLETED,assetsLoaded)
	 * 
	 * step3:add the assetsLoaded function
	 * line2:private function assetsLoaded(e:EasyLoaderEvent) {
	   line3:     //put some code to here like init()
	   line4:}
	   
	   step4:load assets according to config xml
	   line5:_assetsManager.loadConfig("assets.xml")
	   
	   ok,this is all!
	   
	 * 
	 * 
	 * 非常高兴easyLoader 这个项目终于发布了。现在的最新版本是1.011;它可以用来干不少事情，比如说加载声音、视频、XML、TXT文本、DAE的模型，玩家还可以自己定义要加载的文件类型。
	 * 比如你有个新的文件类型，或想将要Load进来的FLASH改成其他的名字比如说:myswf.cc等.
	 * 希望大家可以喜欢。
	 * 作者：刘毅 
	 * 
	 * 可能会有朋友要问什么是easyLoader?
	 * easyLoader 是我自己在工作中一直使用的一个资源加载类，每个项目都会用它来加载网站或游戏需要的各种资源文件，比如SWF、图片、XML、TXT文档、DAE模型、视频流等。
	 * 也可以单单用来做预加载的工具。。。
	 * 
	 * 为什么我需要它呢？理由如下：
	 * 
	 * -非常非常容易使用；
	 *   每个方法的名字都写的通俗易懂，一看名字就知道是干什么的。而且需要用到的方法就几个，几乎不用学，看到例子就会用了。
	 * 
	 * -不会有丢失下载内容的现象
	 *   因为是一个下载完再去下载另外一个的，所以不会发生一次加载N多个，然后偶尔会出现某些资源丢失的诡异现象。
	 * 
	 * -优秀的内存管理
	 *   每个被指定的资源都可以完全被摧毁掉干净，整个easyLoader对象也是。不会再反复持续的使用中增加内存的使用。
	 * 
	 * -更富有弹性
	 *   使用者可以使用自定义的文件后缀名，并进行加载；不止是这样，用户还可以选择自己想要的加载模式。比如说 bytes/variables 等；
	 * 
	 * -动态增加新需要加载的文件
	 *   EasyLoader可以随时增加需要加载的资源文件并开始加载，即使已经刚刚从写好的XML文件里加载好了其他的文件。只需要addFile()就可以了。
	 * 
	 * -更新及时和实用
	 *   将及时更新新的实用版本，但不会去改变接口，使新旧版本可以平滑过渡。并且根据用户的需求来决定加入或移除某些不必要的功能。
	 * 
	 * 大家如果有作品使用了这个类，如果愿意的话可以将网站链接发给我吗？然后分享给大家。谢谢了。
	 * 
	 * 如何使用?
	 * 
	 * 真的只需要几行代码就可以了:
	 * 
	 * 第一步:
	 * 先实例化一个 easyLoader 对象
	 * line1: var _assetsManager = new EasyLoader();
	 * 
	 * 第二步:
	 * 增加必须要的事件侦听
	 * line2: _assetsManager.addEventListener(EasyLoaderEvent.COMPLETED,assetsLoaded)
	 * 
	 * 第三步:增加一个加载完事件相对应的方法
	 * line2:private function assetsLoaded(e:EasyLoaderEvent) {
	   line3:     //put some code to here like init()
	   line4:}
	   
	   第四部:开始根据XML配置文件来加载资源吧！
	   line5:_assetsManager.loadConfig("assets.xml")
	   
	   ok,this is all!
	 * 
	 * version:1.012
	 * add a new get function:loadStatus, what status the easyLoader was
	 * 增加了一个新的方法 loadStatus，用来让使用者获取当前easyLoader对象是处在什么状态。
	 * 
	 */
	public class EasyLoader extends EventDispatcher
	{   
		//config xml source data
		private var _xml:XML;
		//config xml urlLoader
		private var _urlLoader:URLLoader
		//config xml size
		private var _bytesTotal:Number  
		//config xml loaded
		private var _bytesLoaded:Number
		//all the loaded files list
		private var _loadList:Array;
		//all the load fault files list(only infomation not real files)
		private var _faultList:Array;
		//when config xml loaded,if auto load files;
		private var _autoLoad:Boolean;
		//load status
		private var _loadStatus:String;
		//if ignore load error to download next file.
		private var _ignoreError:Boolean;
		//the length of all the need load files list 
		private var _length:uint;
		//index of current file according to  xml childs number
		private var _index:uint;
		//information of curent loading file 
		private var _currentLoadingObj:Object
		//types of  files,let preloader know how to download them.user can add custom file type with function addType()
		private var _typeList:Array
		
		
		
		public static const LOADING_INITING:String="loading_initing"
		public static const FREE:String = "free";
		public static const LOADING_ERROR:String="loading_error"
		public static const LOADING_COMPLETED:String="loading_completed"
		public static const LOADING_PROGRESS:String = "loading_progress"
		public static const LOADING_PAUSE:String = "loading_pause"
		public static const LOADING_CONFIG_INITED:String = "loading_config_inited"
		
		public static const LOADING_METHOD_VARIABLES:String="variables"
		public static const LOADING_METHOD_XML:String="xml"
		public static const LOADING_METHOD_BYTES:String="bytes"
		public static const LOADING_METHOD_TEXT:String = "text"
		public static const VERSION:String="1.011"
		
		private var _tempAddFilesList:Array
		
		public const LOADING_ITEM_STATUS_FAULT:String = "Loading_item_Status_Fault";
		
		/*Create a new EasyLoader Object*/
		public function EasyLoader() 
		{
			initType();
			rest();
		}
		
		/* Preloader Init,
		 * obj:
		 * It can be assigned to a String or XML.If the value is a String,easyLoader will load a config xml file with this path;If the value is a XML object,easyLoader will init with this XML object. 
		 * $autoLoad:
		 * true or false,if this value equal true.when easyLoader initialized config data,it will auto preload assets according to config data. 
		 * $ignoreError:
		 * true or false,suggest set to true.once this params set to false,when easyLoader meet a error,it will puase download assets.
		 * */
		public function init(obj:*=null,$autoLoad:Boolean=true,$ignoreError:Boolean=true):Boolean {
			
			_autoLoad = $autoLoad;
			_ignoreError = $ignoreError;
		    if (obj != null) {
				if (obj is String ) {
					loadCofingXML(obj);
					return true
				}else if(obj is XML){
					_xml = obj;
					configLoaded()
					return true
				}else {
					trace("warin:need right source")
					return false
				}
			}else {
				return true
			}
			
		}
		
		/*size of config xml files */
		public function get bytesTotal():Number {
			return _bytesTotal;
		}
		/*size of config xml files has loaded */
		public function get bytesLoaded():Number {
			return _bytesLoaded;
		}
		
		public function get currentLoadingObj():Object {
			var obj:Object = new Object()
			for (var i:* in _currentLoadingObj) {
				obj[i]=_currentLoadingObj[i]
			}
			return obj
		}
		public function set autoLoad(bol:Boolean):void {
			_autoLoad = bol;
		}
		public function get autoLoad():Boolean {
			return _autoLoad;
		}
		
		public function get index():uint {
			return _index
		}
		
		public function set ignoreError(bol:Boolean):void {
			_ignoreError = bol;
		}
		public function get ignoreError():Boolean {
			return _ignoreError ;
		}
		
		public function get length():uint {
			return _length;
		}
		
		public function get loadStatus():String {
			return _loadStatus
		}
		/*public function get list():Array {
			return _loadList
		}*/
		 
		public function addType($type:String, $name:String):Boolean {
			if ($name.charAt(0) != '.') {
				return false
			}else{
				for (var i:* in _typeList) {
					 if (_typeList[i]['name'] == $type) {
						//trace('found:'+_typeList[i]['name'])
						_typeList[i]['list'] += $name;
						return true
						//trace(_typeList[i]['list'])
					} 
				}
				return false;
			}
		}
		public function loadConfig(str:String):void {
			loadCofingXML(str)
		}
		public function pause():void {
			_loadStatus = LOADING_PAUSE;
			var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.PAUSE);
			dispatchEvent(event)
		}
		public function unPause():void {
			if(_loadStatus==LOADING_PAUSE){
				_loadStatus = LOADING_PROGRESS;
				start()
			}
		}
		
		public function start():void {
			if(_loadStatus != LOADING_PROGRESS && _loadStatus != LOADING_COMPLETED ){
				_loadStatus = LOADING_PROGRESS;
				itemLoad();
			}
		}
		
		public function addFile(path:String, alias:String = "", loadTip:String="", autoRemove:Boolean = false, method:String = "text"):void {
			var xmlList:XMLList = new XMLList("<item alias='" + alias + "' loadTip='" + loadTip + "' autoRemove='" + autoRemove.toString() + "' method='" + method + "'>" + path + "</item>")
			_tempAddFilesList.push(xmlList)
		}
		
		//remove a item which will be preload,maybe somebody need it.If this file preload completed,this function would not be use.
		public function removeFileByAlias(alias:String):Boolean {
			for (var i:int = 0 ; i < _length;i++ ) {
				if (_xml.child(i).@alias == alias) {
					if(i>_index){
						delete _xml.item[i];
						return true;
					}
					
					break;
				}
			}
			return false
		}
		//remove a item which will be preload,maybe somebody need it.If this file preload completed,this function would not be use.
		public function removeFileByName(name:String):Boolean {
			for (var i:int = 0 ; i < _length;i++ ) {
				if (getName(_xml.child(i))==name) {
					if(i>_index){
						delete _xml.item[i];
						return true;
					}
					break;
				}
			}
			return false
		}
		
		public function dispose():void {
			var $loadlistLenth:uint=_loadList.length
			pause();
			for (var i:int = 0 ; i < $loadlistLenth;i++ ) {
			/*	for (var k in _loadList[i]) {
					 
					_loadList[i][k]=null
					k = null
					 
				}*/
				_loadList[i].dispose();
				_loadList[i]=null
				 
			}
			try{
				_urlLoader.close();
			}catch (e:*) {
				
			}
		     
			_urlLoader.addEventListener(Event.COMPLETE, configLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, configErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, configLoading);
			_xml = null
			_loadList = null
			 
			while (_faultList.length>0) {
				_loadList[0] = null
				_loadList.splice(0);
			}
			_faultList = null
			
			_currentLoadingObj=null
			_currentLoadingObj = null
			
			while (_tempAddFilesList.length>0) {
				_tempAddFilesList[0] = null
				_tempAddFilesList.splice(0);
			}
			_tempAddFilesList=null
			
			
			while (_typeList.length>0) {
				_typeList[0] = null
				_typeList.splicet(0);
			}
			
			trace("all disposed")
		}
		
		public function disposeFileByName(name:String) :Boolean{
			 var length:int = _loadList.length;
			for (var i:int = 0 ; i < length; i++ ) {
				//trace("disposeFileByName>>>"+_loadList[i]["fileName"]+"/"+name)
				if (_loadList[i]["fileName"]==name) {
				//	trace("disposeFileByName:"+name)
					/*for (var k in _loadList[i]) {
						//trace(i + ">>>>" + _loadList[i] + "/" + k + "/" + _loadList[i][k])
						_loadList[i][k]=null
						k = null
						 
					}*/
					_loadList[i].dispose();
					_loadList[i] = null
					return true
					break;
				}
			}
			return false
		}
		public function disposeFileByAlias(alias:String):Boolean {
			var length :int= _loadList.length;
			for (var i:int = 0 ; i < length; i++ ) {
				if (_loadList[i]["alias"]==alias) {
				//	trace("disposeFileByAlias:"+alias)
					/*for (var k in _loadList[i]) {
						//trace(i + ">>>>" + _loadList[i] + "/" + k + "/" + _loadList[i][k])
						_loadList[i][k]=null
						k = null
						
						 
					}*/
					_loadList[i].dispose();
					_loadList[i] = null
					return true
					break;
				}
			}
			return false
		}
		
		
		public function getFileByName(name:String):LoadedItem {
			 var length :int= _loadList.length;
			for (var i:int = 0 ; i < length; i++ ) {
				//trace("getFileByName>>>"+_loadList[i]["fileName"]+"/"+name)
				if (_loadList[i]["fileName"]==name) {
					 
					return _loadList[i]
					break;
				}
			}
			return new LoadedItem()
		}
		public function getFileByAlias(alias:String):LoadedItem {
			 var length:int = _loadList.length;
			for (var i:int = 0 ; i < length; i++ ) {
				//trace("getFileByAlias>>>"+_loadList[i]["alias"]+"/"+alias)
				if (_loadList[i]["alias"]==alias) {
					 
					return _loadList[i]
					break;
				}
			}
			return new LoadedItem()
		}
		
		public function getFileByIndex(number:uint):LoadedItem {
			return _loadList[number] 
		}
		
		//maybe no one need this function,so i drop it.if some body want it indeed,please connect me.
		//这个功能不打算完成了，因为我发现可能没人需要它；但是如果有朋友需要，我会将它在下一版本中完成。可以随时联系我。
		/*public function reTryErrorAssets() {
			
		}*/
		/*****************public function  end***********************************/
		private function addAlltoXML():void {
			while ( _tempAddFilesList.length>0) {
				addtoXML(_tempAddFilesList[0]);
				_tempAddFilesList.splice(0);
				
			}
		}
		private function addtoXML(xmlList:XMLList):void {
			
			if (_xml.toXMLString() == "") {
				_xml = new XML("<easyLoader></easyLoader>");
			}
			_xml.appendChild(xmlList)
			_length = _xml.child("*").length();
			 
		}
		
		private function loadCofingXML(path:String):void {
			_loadStatus=LOADING_INITING
			if(_urlLoader==null){
				_urlLoader = new URLLoader()
			}else {
				try{
				_urlLoader.close();
				}catch(e:*){}
			}
			_urlLoader.addEventListener(Event.COMPLETE, configLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, configErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, configErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, configLoading);
			_urlLoader.load(new URLRequest(path))
		}
		private function rest():void {
			_xml = new XML();
			_xml.ignoreWhitespace = true;
			if (_urlLoader==null) {
				_urlLoader = new URLLoader()
			}else {
				try{
				_urlLoader.close();
				}catch (e:*) {
					
				}
			}
			_bytesLoaded = 0
			_bytesTotal=999999
			_loadList = [];
			_faultList = [];
			_currentLoadingObj=null
			_currentLoadingObj = { };
			_tempAddFilesList=[]
			 
			_autoLoad = true;
			_ignoreError = true;
			_loadStatus = FREE;
			
		}
		
		
		private function configLoading(e:ProgressEvent):void {
			_bytesTotal = e.bytesTotal;
			_bytesLoaded = e.bytesLoaded;
			dispatchEvent(e)
		}
		private function configLoaded(e:Event=null):void {
			if (e!=null) {
				_xml=new XML(_urlLoader.data)
			}
			
			_urlLoader.removeEventListener(Event.COMPLETE, configLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, configErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configErrorHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, configLoading);
			
			
			_length = _xml.child("*").length();
			_loadStatus=LOADING_CONFIG_INITED
			
			var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.CONFIG_INITED,true)
			dispatchEvent(event)
			
			if(_autoLoad==true){
				itemLoad();
			} 
		}
		private function configErrorHandler(e:*) :void{
			//trace("EasyLoader -> configErrorHandler:" + e)
			_loadStatus = LOADING_ERROR
			_urlLoader.removeEventListener(Event.COMPLETE, configLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, configErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, configErrorHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, configLoading);
			dispatchEvent(new EasyLoaderEvent(EasyLoaderEvent.CONFIG_INIT_ERROR,true))
		}
		private function initType() :void{
			_typeList = [];
			_typeList.push( { name:"text", list:".xml.txt.css.dae" } );
			_typeList.push( { name:"video", list:".flv.mov.mp4.f4v" } );
			_typeList.push( { name:"sound", list:".mp3.wav" } );
			_typeList.push( { name:"image", list:".jpg.gif.png.swf" } );
			_typeList.push({name:"bytes",list:".pat.dat"})
		 

		}
		
		private function itemLoad() :void {
			trace("ASEASDD")
			_loadStatus = LOADING_PROGRESS
			addAlltoXML()
			
			var str:String = new String(_xml.child(_index))
			var typeName:String = getType(str);
			var type:String
			for (var i:* in _typeList) {
				// trace("for:"+_typeList[i]['list'].indexOf(typeName))
				if (_typeList[i]['list'].indexOf(typeName)>=0) {
					type = _typeList[i]['name']
					//trace(" if item load: "+type+"/"+typeName)
					break;
				}
			}
			if (_xml.child(_index).@method == LOADING_METHOD_BYTES) {
				textLoad(URLLoaderDataFormat.BINARY, typeName)
			}else {
				
				 if (type == "image") { 
					 imageLoad(str,typeName)
				 }
				 else if (type=="sound") {
					soundLoad(typeName)
				 } 
				 else if (type=="video") {
					videoLoad(typeName);
				 }
				 else if (type == "text") {
					 if(_xml.child(_index).@method==LOADING_METHOD_VARIABLES){
						textLoad(URLLoaderDataFormat.VARIABLES, typeName)
					 }else{
						textLoad(URLLoaderDataFormat.TEXT, typeName)
					 }
				 }
				 else if(type=="bytes") {
					textLoad(URLLoaderDataFormat.BINARY,typeName)
				 }
				 
			}
			 trace("ASEASDD2")
			 type = null
			 str=null
		}
		private function getType(str:String):String {
			
			return str.substring(str.lastIndexOf('.'))
		}
		private function getName(str:String):String {
			return str.substring(str.lastIndexOf('/')+1)
		}
		private function itemLoaded():void {
			//trace("itemLoaded:"+_index+"/"+_length)
			addAlltoXML()
			if(_index<_length-1){
				_index++;
				itemLoad();
			}else {
				allLoaded();
			}
			
		}
		private function itemLoadError(e:*=null) :void{
			//trace("itemLoadError->[index:" + _index + "] [file:" + _xml.child(_index) + "] [info:" + e + "]");
			_loadStatus = LOADING_ERROR
			var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.LOADING_ERROR)
			event.data={index:_index,file: _xml.child(_index),info:e}
			dispatchEvent(event);
			
			if (_ignoreError == true && _index < _length - 1) {
				trace("whihiwhiweh")
				    var _cell:LoadedItem = new LoadedItem()
					_loadList.push(_cell)
					_index++;
					itemLoad()
				 
			}else {
				pause();
			}
		}
		
		
		private function imageLoad(url:String, typeName:String):void {
			
			var loader:Loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.INIT, imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
			addEventListener(EasyLoaderEvent.PAUSE, imagePuaseHandler);
			var $autoRemove:Boolean = (_xml.child(_index).@autoRemove == "true")?true:false
			var $method:String=_xml.child(_index).@method 
			_currentLoadingObj={fileName:getName(_xml.child(_index)),id:_index, bytesTotal:0,bytesLoaded:99999999,alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip}
			loader.load(new URLRequest(url))
			
			function imageLoaded(e:Event):void {
				//trace("imageLoaded")
			   
				_loadList.push(new LoadedItem(loader.content,getName(_xml.child(_index)),_index,String(_xml.child(_index)),_xml.child(_index).@alias,typeName,_xml.child(_index).@loadTip,$autoRemove,$method))
				//_loadList.push( { fileName:getName(_xml.child(_index)),id:_index,type:typeName,  content:loader.content, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				imageRemove($autoRemove);
				itemLoaded()
			}
			
			function imageLoadError(e:IOErrorEvent) :void{
				//trace("imageLoadError"+e)
				imageRemove(true)
				
				_faultList.push( { fileName:getName(_xml.child(_index)),status:LOADING_ITEM_STATUS_FAULT,id:_index, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				itemLoadError(e);
			}
			
			function imageLoading(e:ProgressEvent):void {
				 	//trace("imageLoading:"+e.bytesLoaded+"/"+e.bytesTotal)
					_currentLoadingObj['bytesLoaded'] = e.bytesLoaded;
					_currentLoadingObj['bytesTotal'] = e.bytesTotal;
					 
				 	var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.PROGRESS)
				 	dispatchEvent(event)
					 
					
				
			}
			function imageRemove(bol:Boolean):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageLoadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, imageLoading)
				removeEventListener(EasyLoaderEvent.PAUSE, imagePuaseHandler);
				if (bol) {
					try{
					loader.close();
					}catch (e:*) {
						
					}
					
					loader.unload();
					loader=null
				}
			}
			
			function imagePuaseHandler():void {
				imageRemove(true)
			}
			
			
			
			
		}
		
		
		private function textLoad(dataFormat:String,typeName:String):void {
			var textLoader:URLLoader = new URLLoader()
			textLoader.dataFormat=dataFormat
			textLoader.addEventListener(Event.COMPLETE, textLoaded);
			textLoader.addEventListener(ProgressEvent.PROGRESS, textLoading);
			textLoader.addEventListener(IOErrorEvent.IO_ERROR, textLoadError);
			addEventListener(EasyLoaderEvent.PAUSE, textPuaseHandler);
			var $autoRemove:Boolean = (_xml.child(_index).@autoRemove == "true")?true:false
			var $method:String = _xml.child(_index).@method
			
			_currentLoadingObj={fileName:getName(_xml.child(_index)),id:_index, bytesTotal:0,bytesLoaded:99999999,alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip}
			textLoader.load(new URLRequest(_xml.child(_index)));
			function textLoaded(e:Event):void {
				//trace("textLoaded>>>>>>>>");
				var $content:*
				if(typeName==".xml" || $method==LOADING_METHOD_XML){
					$content = new XML(e.target.data);
					$content.ignoreWhitespace = true;
					//trace(dataFormat+">>>>>>>>"+e.target.data)
				}else {
					$content = e.target.data;
				}
				
				_loadList.push(new LoadedItem($content,getName(_xml.child(_index)),_index,String(_xml.child(_index)),_xml.child(_index).@alias,typeName,_xml.child(_index).@loadTip,$autoRemove,$method))
			//	_loadList.push( {fileName:getName(_xml.child(_index)),id:_index,type:typeName, content:$content, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				
				 
				textRemove($autoRemove);
				 
				itemLoaded()
			}
			function textLoading(e:ProgressEvent) :void{
				//trace("textLoading:" + e.bytesLoaded + "/" + e.bytesTotal)
				_currentLoadingObj['bytesLoaded'] = e.bytesLoaded;
				_currentLoadingObj['bytesTotal'] = e.bytesTotal;
				var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.PROGRESS)
				dispatchEvent(event)
				
			}
			
			function textLoadError(e:IOErrorEvent) :void{
				_faultList.push( {fileName:getName(_xml.child(_index)),status:LOADING_ITEM_STATUS_FAULT,id:_index, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip} );
				textRemove(true)
				itemLoadError(e);
			}
			
			function textRemove(bol:Boolean = false) :void{
				textLoader.removeEventListener(Event.COMPLETE, textLoaded);
				textLoader.removeEventListener(ProgressEvent.PROGRESS, textLoading);
				removeEventListener(EasyLoaderEvent.PAUSE, textPuaseHandler);
				if (bol) {
					try{
						textLoader.close()
					}catch (e:*) {
						
					}
					textLoader = null
				}
			}
			
			function textPuaseHandler() :void{
				textRemove(true)
			}
		}
		 
		private function videoLoad(typeName:String):void {
			var $autoRemove:Boolean = (_xml.child(_index).@autoRemove == "true")?true:false
			var $method:String = _xml.child(_index).@method
			
			var netConn:NetConnection = new NetConnection();
			netConn.connect(null);
			var netStream:NetStream = new NetStream(netConn);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, videoLoadStatus);
			addEventListener(EasyLoaderEvent.PAUSE, videoPuaseHandler);
			var client:Object = new Object();
			netStream.client = client;
			_currentLoadingObj={fileName:getName(_xml.child(_index)),id:_index, bytesTotal:0,bytesLoaded:99999999,alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip}
			var path:String=_xml.child(_index).toString()
			netStream.play(path);
			 
			netStream.pause() 
			
			var timer:Timer = new Timer(50,  int.MAX_VALUE)
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, timerHandler)
			function videoLoaded() :void{
				//trace("videoLoaded>>>")
				 
				videoRemove($autoRemove);
				_loadList.push(new LoadedItem(netStream,getName(_xml.child(_index)),_index,String(_xml.child(_index)),_xml.child(_index).@alias,typeName,_xml.child(_index).@loadTip,$autoRemove,$method))
			 
				//_loadList.push( {fileName:getName(_xml.child(_index)),id:_index,type:typeName, content:netStream, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				
				itemLoaded();
			}
			function timerHandler(e:TimerEvent):void {
				
				_currentLoadingObj['bytesLoaded'] = netStream.bytesLoaded;
				_currentLoadingObj['bytesTotal'] = netStream.bytesTotal;
				var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.PROGRESS)
				dispatchEvent(event)
				if (_currentLoadingObj['bytesLoaded']==_currentLoadingObj['bytesTotal'] && _currentLoadingObj['bytesTotal']!=0) {
					videoLoaded();
				}
				
			}
			function videoLoadStatus(e:NetStatusEvent):void {
			//	trace("videoLoadStatus:"+e.info.code)
				if(e.info.code=="NetStream.Publish.BadName" ||e.info.code=="NetStream.Play.StreamNotFound" ||e.info.code=="NetStream.Play.Failed"||e.info.code=="NetStream.Play.NoSupportedTrackFound"||e.info.code=="NetStream.Play.FileStructureInvalid") {
					 
						
						videoLoadError(e.info.code)
					 
				}
			}
			
			function videoLoadError(e:String) :void{
				 
				_faultList.push( { fileName:getName(_xml.child(_index)),status:LOADING_ITEM_STATUS_FAULT, id:_index, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				videoRemove(true);
				itemLoadError(e);
			}
			
			function videoPuaseHandler(e:Event) :void{
				videoRemove(true)
			}
			
			function videoRemove(bol:Boolean = false):void {
				try{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					netStream.removeEventListener(NetStatusEvent.NET_STATUS, videoLoadStatus);
					if (bol) {
						try{
						netStream.close();
						netConn.close();
						}catch (e:*) {
							
						}
						netStream = null;
						netConn = null;
					}
				}catch (e:*) {
					
				}
			}
		}
		private function soundLoad(typeName:String) :void{
			var $autoRemove:Boolean = (_xml.child(_index).@autoRemove == "true")?true:false
			var $method:String = _xml.child(_index).@method
			
			var sound:Sound = new Sound();
			sound.addEventListener(Event.COMPLETE, soundLoaded);
			sound.addEventListener(ProgressEvent.PROGRESS, soundLoading);
			sound.addEventListener(IOErrorEvent.IO_ERROR, soundLoadError);
			addEventListener(EasyLoaderEvent.PAUSE, soundPuaseHandler);
			_currentLoadingObj={fileName:getName(_xml.child(_index)),id:_index, bytesTotal:0,bytesLoaded:99999999,alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip}
			
			sound.load(new URLRequest(String(_xml.child(_index))));
			
			function soundLoaded(e:Event) :void{
				//trace("soundLoaded>>>")
				_loadList.push(new LoadedItem(sound,getName(_xml.child(_index)),_index,String(_xml.child(_index)),_xml.child(_index).@alias,typeName,_xml.child(_index).@loadTip,$autoRemove,$method))
			 
				//_loadList.push( {fileName:getName(_xml.child(_index)),id:_index,type:typeName, content:sound, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				 
				soundRemove($autoRemove);
				 
				itemLoaded();
			}
			
			function soundLoading(e:ProgressEvent) :void{
				_currentLoadingObj['bytesLoaded'] = e.bytesLoaded;
				_currentLoadingObj['bytesTotal'] = e.bytesTotal;
			 	var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.PROGRESS)
				dispatchEvent(event)
			}
			function soundLoadError(e:IOErrorEvent):void {
				_faultList.push( { fileName:getName(_xml.child(_index)),status:LOADING_ITEM_STATUS_FAULT, id:_index, alias:_xml.child(_index).@alias, autoRemove:_xml.child(_index).@autoRemove, loadTip:_xml.child(_index).@loadTip } );
				soundRemove(true)
				itemLoadError(e);
			}
			
			function soundRemove(bol:Boolean = false):void {
				sound.removeEventListener(Event.COMPLETE, soundLoaded);
				sound.removeEventListener(ProgressEvent.PROGRESS, soundLoading);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundLoadError);
				removeEventListener(EasyLoaderEvent.PAUSE, soundPuaseHandler);
				if (bol) {
					try{
					sound.close();
					}catch(e:*){}
					sound = null;
					
				} 
			}
			
			function soundPuaseHandler(e:Event):void {
				soundRemove(true);
			}
		}
		
		private function allLoaded():void {
			trace("allLoaded"+this.index+"/"+this.length)
			_loadStatus=LOADING_COMPLETED
			var event:EasyLoaderEvent = new EasyLoaderEvent(EasyLoaderEvent.COMPLETED)
			dispatchEvent(event);
		}
	}

}