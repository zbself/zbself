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
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.AbcFile;

	/**
	 * Dispatched when the class loader has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the class loader has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the class loader has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 * Describes an object capable of creating a valid <code>AbcFile</code>, ready to
	 * be loaded into the AVM.
	 * @author Roland Zwaga
	 */
	public interface IAbcBuilder extends IEventDispatcher {
		/**
		 * Creates an <code>IPackageBuilder</code> instance for the specified package name.
		 * <p>An example of a package name: <code>com.myclasses.test</code></p>
		 * @param name The specified package name
		 * @return The specified <code>IPackageBuilder</code> instance.
		 */
		function definePackage(name:String):IPackageBuilder;
		/**
		 * Creates an <code>IClassBuilder</code> instance for the specified fuly qualified class name and super class name.
		 * @param name The fully qualified name of the new class. I.e. <code>com.myclasses.MyGeneratedClass</code>.
		 * @param superClassName The fully qualified super class name. I.e. <code>mx.events.FlexEvent</code>, defaults to <code>Object</code>.
		 * @return The specified <code>IClassBuilder</code> instance.
		 */
		function defineClass(fullName:String, superClassName:String = null):IClassBuilder;
		/**
		 * Creates an <code>IInterfaceBuilder</code> instance for the specified fully qualified interface name and super interface names.
		 * @param name The fully qualified name of the new interface. I.e. <code>com.myinterfaces.IMyGeneratedInterface</code>.
		 * @param superInterfaceNames The fully qualified super interface names. I.e. <code>mx.styles.IStyleClient</code>.
		 * @return The specified <code>IInterfaceBuilder</code> instance.
		 */
		function defineInterface(fullName:String, superInterfaceNames:Array = null):IInterfaceBuilder;
		/**
		 *
		 * @param fullScopeName
		 * @param URI
		 * @return
		 */
		function defineNamespace(fullScopeName:String, URI:String):INamespaceBuilder;
		/**
		 * Builds an <code>AbcFile</code> using the previously defined <code>IPackageBuilder</code> instances.
		 * @param applicationDomain The applicationDomain that has access to the super classes that are defined
		 * for any classes defined in the <code>AbcFile</code>, defaults to <code>ApplicationDomain.currentDomain</code>.
		 * @return The created <code>AbcFile</code>.
		 */
		function build(applicationDomain:ApplicationDomain = null):AbcFile;
		/**
		 * Builds the <code>AbcFile</code> and immediately loads it into the AVM.
		 * <p>This behaviour is asynchronous, so be sure to listen for the <code>Event.COMPLETE</code>, <code>IOErrorEvent.IO_ERROR</code> and
		 * <code>IOErrorEvent.VERIFY_ERROR</code> on the current <code>IAbcBuilder</code>.</p>
		 * <p>Once the <code>Event.COMPLETE</code> event has been fired it will be possible to retrieve a reference to the generated classes through the specified application
		 * domain, like this:</p>
		 * <p><code>var cls:Class = applicationDomain.getDefinition("com.myclasses.MyGeneratedClass") as Class</code></p>
		 * @param applicationDomain The applicationDomain that has access to the super classes that are defined
		 * for any classes defined in the <code>AbcFile</code>, defaults to <code>ApplicationDomain.currentDomain</code>.
		 * @param newApplicationDomain The <code>ApplicationDomain</code> in which the newly created <code>AbcFile</code> will be loaded,
		 * defaults to <code>ApplicationDomain.currentDomain</code>.
		 * @return The created <code>AbcFile</code>.
		 */
		function buildAndLoad(applicationDomain:ApplicationDomain = null, newApplicationDomain:ApplicationDomain = null):AbcFile;

		/**
		 * Builds, serializes and wraps the <code>AbcFile</code> in a SWF, the resulting <code>ByteArray</code> can be saved to
		 * disk as a .swf file for later use.
		 * @param applicationDomain The applicationDomain that has access to the super classes that are defined.
		 * @return The <code>ByteArray</code> containing the serialized <code>AbcFile</code> wrapped inside a SWF.
		 */
		function buildAndExport(applicationDomain:ApplicationDomain = null):ByteArray;
	}
}