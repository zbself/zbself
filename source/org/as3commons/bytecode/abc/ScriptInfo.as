/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc {
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.util.CloneUtils;

	/**
	 * as3commons-bytecode representation of <code>script_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Script" in the AVM Spec (page 32)
	 */
	public final class ScriptInfo implements ICloneable {
		public var scriptInitializer:MethodInfo;
		public var traits:Array;

		public function ScriptInfo() {
			super();
			traits = [];
		}


		public function clone():* {
			var scriptInfo:ScriptInfo = new ScriptInfo();
			scriptInfo.scriptInitializer = scriptInitializer.clone();
			scriptInfo.traits = CloneUtils.cloneList(traits);
			return scriptInfo;
		}

		public function toString():String {
			return StringUtils.substitute("ScriptInfo[\n\tscriptInitializer={0}\n\ttraits=[\n\t\t{1}\n\t]\n]", scriptInitializer, traits.join("\n\t\t"));
		}
	}
}