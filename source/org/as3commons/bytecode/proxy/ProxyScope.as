/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.bytecode.proxy {
	import flash.utils.Dictionary;

	public final class ProxyScope {

		private static const ITEMS:Dictionary = new Dictionary();

		public static const PUBLIC:ProxyScope = new ProxyScope(PUBLIC_NAME);
		public static const PROTECTED:ProxyScope = new ProxyScope(PROTECTED_NAME);
		public static const PUBLIC_PROTECTED:ProxyScope = new ProxyScope(PUBLIC_PROTECTED_NAME);
		public static const ALL:ProxyScope = new ProxyScope(ALL_NAME);
		public static const NONE:ProxyScope = new ProxyScope(NONE_NAME);

		private static const PUBLIC_NAME:String = "publicProxyScope";
		private static const PROTECTED_NAME:String = "protectedProxyScope";
		private static const PUBLIC_PROTECTED_NAME:String = "publicProtectedProxyScope";
		private static const ALL_NAME:String = "allProxyScope";
		private static const NONE_NAME:String = "noneProxyScope";

		private var _value:String;

		public function ProxyScope(val:String) {
			super();
			_value = val;
			ITEMS[_value] = this;
		}

		public function get value():String {
			return _value;
		}

		public static function determineProxyScope(value:String):ProxyScope {
			return ITEMS[value] as ProxyScope;
		}

	}
}