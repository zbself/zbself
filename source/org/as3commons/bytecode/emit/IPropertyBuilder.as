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
package org.as3commons.bytecode.emit {
	import flash.events.IEventDispatcher;

	import org.as3commons.bytecode.emit.impl.MemberInitialization;

	/**
	 * Describes an object that can generate a property on a class or interface to be used in an <code>AbcFile</code>.
	 * @author Roland Zwaga
	 */
	public interface IPropertyBuilder extends IEmitMember, IEventDispatcher {
		/**
		 * If <code>true</code> the generated property will be marked as a constant.
		 */
		function get isConstant():Boolean;
		/**
		 * @private
		 */
		function set isConstant(value:Boolean):void;
		/**
		 * The fully qualified type name of the generated property. I.e. <code>flash.util.Dictionary</code>.
		 */
		function get type():String;
		/**
		 * @private
		 */
		function set type(value:String):void;
		/**
		 * The initial value for the generated property. I.e. "defaultValue" or 125, etc.
		 */
		function get initialValue():*;
		/**
		 * @private
		 */
		function set initialValue(value:*):void;

		/**
		 * Descibes how to initialize the property if it has a complex type.
		 */
		function get memberInitialization():MemberInitialization;
		/**
		 * @private
		 */
		function set memberInitialization(value:MemberInitialization):void;
		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function build():Object;

		/**
		 * Creates opcodes for all member initializers. These opcodes can later be merged into the
		 * constructor body.
		 * @return An <code>Array</code> of <code>Op</code> instances.
		 */
		function buildPropertyInitializers():Array;
	}
}