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
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	public interface INamespaceBuilder {
		/**
		 * The fully qualified package name for the current <code>INamespaceBuilder</code>. I.e. <code>com.myclasses.generated</code>.
		 */
		function get packageName():String;
		/**
		 * @private
		 */
		function set packageName(value:String):void;
		function get scopeName():String;
		/**
		 * @private
		 */
		function set scopeName(value:String):void;
		function get URI():String;
		/**
		 * @private
		 */
		function set URI(value:String):void;

		function build():SlotOrConstantTrait;
	}
}