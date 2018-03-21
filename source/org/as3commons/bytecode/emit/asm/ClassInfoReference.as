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
package org.as3commons.bytecode.emit.asm {
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.lang.Assert;

	public class ClassInfoReference {

		private var _classMultiName:QualifiedName;

		public function ClassInfoReference(clsName:QualifiedName) {
			super();
			init(clsName);
		}

		protected function init(clsName:QualifiedName):void {
			CONFIG::debug {
				Assert.notNull(clsName, "clsName argument must not be null");
			}
			_classMultiName = clsName;
		}

		public function get classMultiName():QualifiedName {
			return _classMultiName;
		}

	}
}