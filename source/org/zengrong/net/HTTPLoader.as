////////////////////////////////////////////////////////////////////////////////
// zengrong.net
// 创建者:	zrong(zrongzrong@gmail.com)
// 创建时间：2010-12-30
// 最后修改：2012-12-04
// 此Class在某些情况下可能出现不响应的情况，建议使用HTTPLoaderAsync替代它
////////////////////////////////////////////////////////////////////////////////
package org.zengrong.net
{
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import org.zengrong.utils.ObjectUtil;

/**
 * 与服务器通信，可以传递多重资料和载入多个文件
 * */
public class HTTPLoader
{
	/**
	 * 由于超时没有返回造成的错误
	 */
	public static const ERROR_TIMEROUT:String = 'timeout';
	
	/**
	 * 由于IOErrorEvent造成的错误
	 */
	public static const ERROR_IO:String = 'ioError';
	
	/**
	 * 由于SecurityEvent造成的错误
	 */
	public static const ERROR_SECURITY:String = 'securityError';
	
	/**
	 * 构造函数，提供两个Function参数供Load成功或者失败的时候调用
	 * @param $done 载入成功的时候调用的Function，必须接受一个HTTPLoaderDoneVO或Array参数。参数的类型取决于是单载入还是多重载入。
	 * @param $error 载入错误的时候调用的Function，必须接受一个HTTPLoaderErrorVO参数。
	 * @see org.zengrong.net.HTTPLoaderDoneVO
	 * @see org.zengrong.net.HTTPLoaderErroVO
	 * 
	 */	
	public function HTTPLoader($done:Function, $error:Function)
	{
		init();
		_fun_loadDone = $done;
		_fun_loadError = $error;
	}
	
	protected var _timeout:uint = 5000;
	
	protected var _timeoutid:int = -1;
	
	/**
	 * 载入成功后的回调函数
	 * */
	protected var _fun_loadDone:Function;
	
	/**
	 * 载入错误时的回调函数
	 * */
	protected var _fun_loadError:Function;
	
	protected var _method:String = 'GET';
	
	protected var _dataFormat:String = 'text';
	
	/**
	 * 是否正在载入。这个变量保证同一时间只能有一次或者一组载入。
	 */
	protected var _loading:Boolean;			
	
	/**
	 * 是否是多文件载入
	 */	
	protected var _multi:Boolean;
	
	protected var _loader:URLLoader;
	
	/**
	 * 每次提交都需要的
	 */
	protected var _submitVar:Object;
	
	/**
	 * 每次提交的时候需要原样返回的参数。这些参数在服务器返回的时候会原样提供给调用者
	 */
	protected var _returnVar:Object;
	
	/**
	 * 保存当次提交的变量
	 */ 
	protected var _curSubmitVar:URLVariables;
	
	/**
	 * 保存当次提交需要返回的参数。
	 */ 
	protected var _curReturnVar:Object;
	
	/**
	 * 保存当次提交的URL
	 */
	protected var _curUrl:String;

	/**
	 * 多文件载入保存每次载入的路径
	 */
	protected var _urls:Array;
	
	/**
	 * 如果是多文件载入，这个变量保存每次提交的时候需要返回的参数。所有的多重载入提供的参数都将统一视为需要返回的参数
	 */
	protected var _submitVars:Array;
	
	/**
	 * 保存多文件载入时候返回的值
	 */
	protected var _results:Array;
	
	//----------------------------------------		
	// init
	//----------------------------------------
	protected function init():void
	{
		initLoader();
		addEvent();
		_loading = false;
		_multi = false;
	}
	
	protected function initLoader():void
	{
		_loader = new URLLoader();
		_loader.dataFormat = _dataFormat;
	}

	//----------------------------------------
	// getter/setter
	//----------------------------------------
	/**
	 * 当前正在进行的请求的数量
	 */
	public function get requestNum():uint
	{
		if(!_urls) return 0;
		return _urls.length;
	}
	
	public function get loading():Boolean
	{
		return _loading;
	}
	
	/**
	 * 默认的超时时间为5秒，过了这个时间就认为返回错误
	 */
	public function get timeout():uint
	{
		return _timeout;
	}

	/**
	 * @private
	 */
	public function set timeout(value:uint):void
	{
		_timeout = value;
	}
	
	/**
	 * 指定使用何种方法提交数据到服务器
	 * @see flash.net.URLRequestMethod
	 */
	public function get method():String
	{
		return _method;
	}
	
	public function set method($method:String):void
	{
		_method = $method;
	}
	
	/**
	 * 控制如何接收下载数据
	 * @see flash.net.URLLoaderDataFormat
	 */
	public function get dataFormat():String
	{
		return _dataFormat;
	}

	public function set dataFormat($format:String):void
	{
		_dataFormat = $format;
	}

	/**
	 * 返回需要的真实数据。返回的数据可能是各种格式，例如二进制流等等。
	 * 子类可以覆盖这个方法，在将返回的数据保存之前处理一下，获得需要的格式。
	 */
	protected function get loaderData():*
	{
		return _loader.data;
	}

	//----------------------------------------
	// public 
	//----------------------------------------
	/**
	 * <p>通过这个方法加入的参数，不仅会传给服务端，同时也会在返回的时候提供。</p>
	 * <p>如果使用的是单载入，那么每次载入完毕后，这些参数会被清空。</p>
	 * <p>如果使用的是多重载入，那么使用此方法添加的参数，在每次提交和返回的时候都会提供。</p>
	 * @param $key
	 * @param $value
	 */	
	public function addReturnVar($key:String, $value:*):void
	{
		if(!_returnVar) _returnVar = {};
		_returnVar[$key] = $value;
		addVariable($key, $value);
	}
	/**
	 * <p>添加要传递给服务器的信息</p>
	 * <p>如果使用的是单载入，那么每次载入完毕后，这些参数会被清空。</p>
	 * <p>如果使用的是多重载入，那么使用此方法添加的参数，在每次提交的时候都会提供。</p>
	 * @param $key
	 * @param $value
	 */	
	public function addVariable($key:String, $value:*):void
	{
		if(!_submitVar)
			_submitVar = {};
		_submitVar[$key] = $value;
	}
	
	/**
	 * 开始载入。
	 * @param $url 要载入的地址。地址可以是String或者包含字符串的Array。如果是String，将其作为载入URL对待；如果是Array，将其作为包含需要批量载入的URL对待。
	 * @param $requestVar 载入时要传递的参数。参数可以是Object或者Array。如果$url是Array，则这里也必须提供与$url元素相同的Array，Array的每个元素应该是Object。载入的时候，将传递Object中包含的键和值。
	 */	
	public function load($url:* , $requestVar:*=null):void
	{
		if(!$url) throw new ArgumentError('必须提供URL参数!');
		if($url && ($url is Array) && ($url as Array).length==0)
			throw new ArgumentError('提供的URL数组元素数量为0!');
		//如果正在载入，就将要载入的url和值加入队列中，但不执行
		if(_loading)
		{
			//不能确定单载入是否定义了_urls。第一次单载入的时候，肯定是没有_urls的，但单载入有可能在第一次载入没有完成的时候被连续调用
			//因此需要初始化_urls，但如果是_multi状态的话，在loading的时候，_urls肯定是有值的
			if(!_multi && !_urls) 
			{
				_urls = [];
				_results = [];
			}
			_urls = _urls.concat($url);
			//在loading的情况下载入，_multi要设置成true
			_multi = true;
			//这个和urls的情况类似，不过要判断$requestVar是否设置
			if($requestVar)
			{
				if(!_submitVars)
					_submitVars = [];
				_submitVars = _submitVars.concat($requestVar);
			}
			return;
		}
		//如果提供的是地址字符串，就视为单载入
		if($url is String)
		{
			_loading = true;
			_multi = false;
			perform($url, $requestVar);
		}
		//否则视为多重载入
		else if($url is Array)
		{
			_loading = true;
			_multi = true;
			_results = [];
			//保存提供的数组参数
			_urls = $url as Array;
			_submitVars = $requestVar as Array;
			//如果提供了参数，就将参数传入
			if(_submitVars)
			{
				perform(_urls.shift(), _submitVars.shift());
			}
			else
			{
				perform(_urls.shift());
			}
		}
	}
	
	public function destroy():void
	{
		clearVar();
		removeEvent();
		_loader = null;
		_fun_loadDone = null;
		_fun_loadError = null;
	}

	//----------------------------------------
	// private 
	//----------------------------------------
	protected function perform($url:String, $var:Object=null):void
	{
		_curUrl = $url;
		//如果提供了每次提交参数，就将参数中的值全部加入要提交的变量中
		if(_submitVar)
		{
			if(!_curSubmitVar)
				_curSubmitVar = new URLVariables();
			for(var __key:String in _submitVar)
			{
				_curSubmitVar[__key] = _submitVar[__key];
			}
		}
		//如果本次提交提供了参数，就将参数中的所有值加入到本次要提交的变量中
		if($var)
		{
			if(!_curSubmitVar)
				_curSubmitVar = new URLVariables();
			for(var __key2:String in $var)
			{
				_curSubmitVar[__key2] = $var[__key2];
			}
			//将本次提交的所有变量值都作为要返回的变量进行保存，以便在返回的时候提供
			_curReturnVar = $var;
		}
		var __request:URLRequest = new URLRequest(_curUrl);
		__request.method = _method;
		if(_curSubmitVar)
			__request.data = _curSubmitVar; 
		_loader.dataFormat = _dataFormat;
		_loader.load(__request);
		//开始载入并计算超时
		_timeoutid = setTimeout(loadTimeout, _timeout);
	}
	
	protected function addEvent():void
	{
		_loader.addEventListener(IOErrorEvent.IO_ERROR, handler_error);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_error);
		_loader.addEventListener(Event.COMPLETE, handler_complete);
	}
	
	protected function removeEvent():void
	{
		if(_loader)
		{
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handler_error);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_error);
			_loader.removeEventListener(Event.COMPLETE, handler_complete);
		}
	}
	
	//创建返回的时候加入的参数
	private function createReturnData():Object
	{
		var __returnData:Object = null;
		//如果提供了返回变量，就将返回变量作为参数加入到返回值中
		if(_returnVar)
			__returnData = ObjectUtil.clone(_returnVar);
		//如果提供了每次返回的变量（实际上就是load的时候提供的所有变量），就将这些变量加入到返回值的returnData中
		if(_curReturnVar)
		{
			if(!__returnData)
				__returnData = {};
			for(var __key:String in _curReturnVar)
				__returnData[__key] = _curReturnVar[__key];
		}
		return __returnData;
	}
	
	
	private function clearVar():void
	{
		_curReturnVar = null;
		_curSubmitVar = null;
		_returnVar = null;
		_submitVar = null;
		_loading = false;
		_results = null;
	}
	
	private function createError($errorType:String, $errorMsg:String):HTTPLoaderErrorVO
	{
		var __result:HTTPLoaderErrorVO = new HTTPLoaderErrorVO()
		__result.returnData = createReturnData();
		if($errorType == IOErrorEvent.IO_ERROR) __result.type = ERROR_IO;
		else if($errorType == SecurityErrorEvent.SECURITY_ERROR) __result.type = ERROR_SECURITY;
		else __result.type = $errorType;
		__result.message = $errorMsg;
		return __result;
	}

	//----------------------------------------
	// handler
	//----------------------------------------
	protected function handler_error(evt:ErrorEvent):void
	{
		checkTimeout();
		//如果载入错误，就立即将错误返回
		var __result:HTTPLoaderErrorVO = createError(evt.type, '载入【'+_curUrl+'】失败，错误信息：'+evt.toString());
		_fun_loadError.call(null, __result);
		//对于多重载入，即使载入错误，依然要继续载入。但检测的时候，不将返回输入加入数组中。
		//也就是说最终返回的结果数组，将不包含这次载入错误的数据。
		if(_multi) checkMultiLoadDone(false);
		else clearVar();
	}
	
	protected function handler_complete(evt:Event):void
	{
		checkTimeout();
		//如果是多重载入，就是用数组保存
		if(_multi)
		{
			checkMultiLoadDone();
		}
		//如果是单次载入，就直接返回result的值
		else
		{
			var __result:HTTPLoaderDoneVO = new HTTPLoaderDoneVO();
			__result.returnData = createReturnData();
			__result.resultData = loaderData;
			//提交的url地址
			__result.url = _curUrl;
			clearVar();
			//此句必须放在最后，因为如果在_fun_loadDone中再次调用load，就会影响_urls的值，导致跳过某些载入
			_fun_loadDone.call(null, __result);
		}
	}
	
	protected function checkTimeout():void
	{
		if(_timeoutid>=0) clearTimeout(_timeoutid);
		_timeoutid = -1;
	}
	
	/**
	 * 载入超时没有返回之后的处理
	 */
	protected function loadTimeout():void
	{
		_timeoutid = -1;
		var __result:Object = createError(ERROR_TIMEROUT, '载入【'+_curUrl+'】超时！');
		_fun_loadError.call(null, __result);
		//取消侦听，避免对loader的关闭操作造成IOError
		removeEvent();
		//关闭载入
		_loader.close();
		//重置Loader
		initLoader();
		//重新开始侦听
		addEvent();
		//对于多重载入，即使超时，依然要继续载入。但检测的时候，不将返回输入加入数组中。
		//也就是说最终返回的结果数组，将不包含这次载入错误的数据。
		if(_multi) checkMultiLoadDone(false);
		else clearVar();
	}

	/**
	 * 检测多重载入是否全部完成。
	 * @param $addReturn 值为true，则将返回的结果加入数组；否则不加入数组。
	 */	
	private function checkMultiLoadDone($addResult:Boolean=true):void
	{
		if($addResult)
		{
			//__result是一次提交返回的值
			var __result:HTTPLoaderDoneVO = new HTTPLoaderDoneVO();
			__result.returnData = createReturnData();
			//真实的返回值
			__result.resultData = loaderData;
			//提交的url地址
			__result.url = _curUrl;
			//将返回的值加入数组
			_results.push(__result);
		}
		//如果载入没有完毕，就继续载入
		if(_urls.length>0)
		{
			_curReturnVar = null;
			_curSubmitVar = null;
			//再次调用载入
			perform(_urls.shift(), _submitVars ? _submitVars.shift() : null);
		}
		//如果载入完毕就调用函数，传递结果数组
		else
		{
			//call必须最后调用，以避免call中再调用load导致不可预见的错误。所以要将_results进行复制，然后清空变量。
			var __resultArr:Array = _results.concat();
			clearVar();
			_urls = null;
			_submitVars = null;
			_fun_loadDone.call(null, __resultArr);
		}
	}
}
}
