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
package org.as3commons.bytecode.reflect {

	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.lang.HashArray;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class ByteCodeAccessor extends Accessor implements IVisibleMember {

		private static const FORWARD_SLASH:String = '/';

		public function ByteCodeAccessor(name:String, access:AccessorAccess, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metaData:HashArray = null) {
			super(name, access, type, declaringType, isStatic, applicationDomain, metaData);
		}

		override public function get declaringType():Type {
			return ByteCodeType.forName(declaringTypeName, this.applicationDomain);
		}

		// ----------------------------
		// visibility
		// ----------------------------

		private var _visibility:NamespaceKind = NamespaceKind.PACKAGE_NAMESPACE;

		public function get visibility():NamespaceKind {
			return _visibility;
		}

		// ----------------------------
		// isOverride
		// ----------------------------

		private var _isOverride:Boolean = false;

		public function get isOverride():Boolean {
			return _isOverride;
		}

		// ----------------------------
		// isFinal
		// ----------------------------

		private var _isFinal:Boolean = false;

		public function get isFinal():Boolean {
			return _isFinal;
		}

		// ----------------------------
		// initializedValue
		// ----------------------------

		private var _initializedValue:* = null;

		public function get initializedValue():* {
			return _initializedValue;
		}

		// ----------------------------
		// scopeName
		// ----------------------------

		private var _scopeName:String = "";

		public function get scopeName():String {
			return _scopeName;
		}

		// ----------------------------
		// gettermethod
		// ----------------------------

		private var _getterMethod:ByteCodeMethod;

		public function get getterMethod():ByteCodeMethod {
			return _getterMethod;
		}

		// ----------------------------
		// settermethod
		// ----------------------------

		private var _setterMethod:ByteCodeMethod;

		public function get setterMethod():ByteCodeMethod {
			return _setterMethod;
		}

		as3commons_reflect function setSetterMethod(value:ByteCodeMethod):void {
			_setterMethod = value;
		}

		as3commons_reflect function setGetterMethod(value:ByteCodeMethod):void {
			_getterMethod = value;
		}

		as3commons_reflect function setScopeName(value:String):void {
			_scopeName = value;
		}

		as3commons_reflect function setIsFinal(value:Boolean):void {
			_isFinal = value;
		}

		as3commons_reflect function setIsOverride(value:Boolean):void {
			_isOverride = value;
		}

		as3commons_reflect function setInitializedValue(value:*):void {
			_initializedValue = value;
		}

		as3commons_reflect function setVisibility(value:NamespaceKind):void {
			_visibility = value;
		}

	}
}