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
package org.as3commons.bytecode.tags.serialization {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.io.AbcSerializer;
	import org.as3commons.bytecode.tags.DoABCTag;
	import org.as3commons.bytecode.tags.ISWFTag;
	import org.as3commons.bytecode.tags.struct.RecordHeader;
	import org.as3commons.bytecode.util.SWFSpec;

	public class DoABCSerializer extends AbstractTagSerializer {

		private var _deserializer:AbcDeserializer;
		private var _serializer:AbcSerializer;

		public function DoABCSerializer(serializerFactory:IStructSerializerFactory) {
			super(serializerFactory);
		}

		public function set deserializer(value:AbcDeserializer):void {
			_deserializer = value;
		}

		public function set serializer(value:AbcSerializer):void {
			_serializer = value;
		}

		public function get deserializer():AbcDeserializer {
			if (_deserializer == null) {
				_deserializer = new AbcDeserializer();
			}
			return _deserializer;
		}

		public function get serializer():AbcSerializer {
			if (_serializer == null) {
				_serializer = new AbcSerializer();
			}
			return _serializer;
		}

		override public function read(input:ByteArray, recordHeader:RecordHeader):ISWFTag {
			var tag:DoABCTag = new DoABCTag();
			tag.flags = SWFSpec.readUI32(input);
			tag.byteCodeName = SWFSpec.readString(input);
			trace("Starting deserialization for ABC Tag " + tag.byteCodeName);
			deserializer.byteStream = input;
			tag.abcFile = deserializer.deserialize(input.position);
			return tag;
		}

		override public function write(output:ByteArray, tag:ISWFTag):void {
			var abcTag:DoABCTag = DoABCTag(tag);
			writeTagHeader(output, abcTag);
			var serializedTag:ByteArray = serializer.serializeAbcFile(abcTag.abcFile);
			serializedTag.position = 0;
			output.writeBytes(serializedTag);
		}

		public function writeTagHeader(output:ByteArray, abcTag:DoABCTag):void {
			SWFSpec.writeUI32(output, abcTag.flags);
			SWFSpec.writeString(output, abcTag.byteCodeName);
		}

	}
}