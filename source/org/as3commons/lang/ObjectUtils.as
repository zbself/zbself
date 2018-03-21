/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.lang {
	
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	/**
	 * Provides utility methods for working with Object objects.
	 *
	 * @author Christophe Herreman
	 */
	public class ObjectUtils {
		
		/**
		 * @private
		 */
		public function ObjectUtils() {
		}
		
		/**
		 * Returns whether or not the given object is simple data type.
		 *
		 * @param the object to check
		 * @return true if the given object is a simple data type; false if not
		 */
		public static function isSimple(object:Object):Boolean {
			switch (typeof(object)) {
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return (object is Date) || (object is Array);
			}
			
			return false;
		}
		
		/**
		 * Returns an array with the keys of this object.
		 */
		public static function getKeys(object:Object):Array {
			var result:Array = [];
			
			for (var k:*in object) {
				result.push(k);
			}
			return result;
		}
		
		/**
		 * Returns the number of properties in the given object.
		 *
		 * @param object the object for which to get the number of properties
		 * @return the number of properties in the given object
		 */
		public static function getNumProperties(object:Object):int {
			var result:int = 0;
			
			for (var p:String in object) {
				result++;
			}
			return result;
		}
		
		/**
		 * Returns an array with the properties of the given object.
		 */
		public static function getProperties(object:Object):Array {
			var result:Array = [];
			
			for each (var p:Object in object) {
				result.push(p);
			}
			return result;
		}
		
		/**
		 *
		 */
		public static function clone(object:Object):* {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}
		
		/**
		 * Converts a plain vanilla object to be an instance of the class
		 * passed as the second variable.  This is not a recursive funtion
		 * and will only work for the first level of nesting.  When you have
		 * deeply nested objects, you first need to convert the nested
		 * objects to class instances, and then convert the top level object.
		 *
		 * TODO: This method can be improved by making it recursive.  This would be
		 * done by looking at the typeInfo returned from describeType and determining
		 * which properties represent custom classes.  Those classes would then
		 * be registerClassAlias'd using getDefinititonByName to get a reference,
		 * and then objectToInstance would be called on those properties to complete
		 * the recursive algorithm.
		 *
		 * @author Darron Schall (darron@darronschall.com)
		 * http://www.darronschall.com/weblog/archives/000247.cfm
		 *
		 * @param object The plain object that should be converted
		 * @param clazz The type to convert the object to
		 */
		public static function toInstance(object:Object, clazz:Class):* {
			var bytes:ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;
			
			// Find the objects and byetArray.writeObject them, adding in the
			// class configuration variable name -- essentially, we're constructing
			// and AMF packet here that contains the class information so that
			// we can simplly byteArray.readObject the sucker for the translation
			
			// Write out the bytes of the original object
			var objBytes:ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject(object);
			
			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = describeType(clazz);
			var fullyQualifiedName:String = typeInfo.@name.toString().replace(/::/, ".");
			registerClassAlias(fullyQualifiedName, clazz);
			
			// Write the new object information starting with the class information
			var len:int = fullyQualifiedName.length;
			bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"
			bytes.writeUTF(fullyQualifiedName);
			// After the class name is set up, write the rest of the object
			bytes.writeBytes(objBytes, 1);
			
			// Read in the object with the class property added and return that
			bytes.position = 0;
			
			// This generates some ReferenceErrors of the object being passed in
			// has properties that aren't in the class instance, and generates TypeErrors
			// when property values cannot be converted to correct values (such as false
			// being the value, when it needs to be a Date instead).  However, these
			// errors are not thrown at runtime (and only appear in trace ouput when
			// debugging), so a try/catch block isn't necessary.  I'm not sure if this
			// classifies as a bug or not... but I wanted to explain why if you debug
			// you might seem some TypeError or ReferenceError items appear.
			var result:* = bytes.readObject();
			return result;
		}
		
		/**
		 * Checks if the given object is an explicit instance of the given class.
		 *
		 * <p>That means that true will only be returned if the object
		 * was instantiated directly from the given class.</p>
		 *
		 * @param object the object to check
		 * @param clazz the class from which the object should be an explicit instance
		 * @return true if the object is an explicit instance of the class, false if not
		 */
		public static function isExplicitInstanceOf(object:Object, clazz:Class):Boolean {
			var c:Class = ClassUtils.forInstance(object);
			return (c == clazz);
		}
		
		/**
		 * Returns the class name of the given object.
		 */
		public static function getClassName(object:Object):String {
			return ClassUtils.getName(ClassUtils.forInstance(object));
		}
		
		/**
		 * Returns the fully qualified class name of the given object.
		 */
		public static function getFullyQualifiedClassName(object:Object, replaceColons:Boolean = false):String {
			return ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(object), replaceColons);
		}
	}
}