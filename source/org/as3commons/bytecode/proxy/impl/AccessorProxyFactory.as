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
package org.as3commons.bytecode.proxy.impl {
	import flash.events.IEventDispatcher;

	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAccessorBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.emit.event.AccessorBuilderEvent;
	import org.as3commons.bytecode.emit.impl.MethodBuilder;
	import org.as3commons.bytecode.proxy.IAccessorProxyFactory;
	import org.as3commons.bytecode.proxy.error.ProxyBuildError;
	import org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent;
	import org.as3commons.bytecode.reflect.ByteCodeAccessor;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.AccessorAccess;

	/**
	 * @inheritDoc
	 */
	[Event(name="beforeGetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	/**
	 * @inheritDoc
	 */
	[Event(name="beforeSetterBodyBuild", type="org.as3commons.bytecode.proxy.event.ProxyFactoryBuildEvent")]
	public class AccessorProxyFactory extends AbstractMethodBodyFactory implements IAccessorProxyFactory {

		public function AccessorProxyFactory() {
			super();
		}

		/**
		 * Creates an overridden accessor on the specified <code>IClassBuilder</code> instance. Which accessor is determined by the specified <code>MemberInfo</code>
		 * instance.
		 * @param classBuilder The specified <code>IClassBuilder</code> instance.
		 * @param type The specified <code>ByteCodeType</code> instance.
		 * @param memberInfo The specified <code>MemberInfo</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The <code>IAccessorBuilder</code> representing the generated accessor.
		 * @throws org.as3commons.bytecode.proxy.error.ProxyBuildError When the proxied accessor is marked as final.
		 */
		public function proxyAccessor(classBuilder:IClassBuilder, type:ByteCodeType, memberInfo:MemberInfo, multiName:Multiname, bytecodeQname:QualifiedName, failOnFinal:Boolean=true):void {
			CONFIG::debug {
				Assert.notNull(classBuilder, "classBuilder argument must not be null");
				Assert.notNull(type, "type argument must not be null");
				Assert.notNull(memberInfo, "memberInfo argument must not be null");
			}
			var accessor:ByteCodeAccessor = type.getField(memberInfo.qName.localName, memberInfo.qName.uri) as ByteCodeAccessor;
			if (accessor == null) {
				throw new ProxyBuildError(ProxyBuildError.ACCESSOR_NOT_EXISTS, classBuilder.name, memberInfo.qName.localName);
			}
			if ((accessor.isFinal) && (failOnFinal)) {
				throw new ProxyBuildError(ProxyBuildError.FINAL_ACCESSOR_ERROR, accessor.name);
			}
			var accessorBuilder:IAccessorBuilder = classBuilder.defineAccessor(accessor.name, accessor.type.fullName, accessor.initializedValue);
			addMetadata(accessorBuilder, accessor.metadata);
			accessorBuilder.namespaceURI = accessor.namespaceURI;
			accessorBuilder.scopeName = accessor.scopeName;
			accessorBuilder.isOverride = (!type.isInterface);
			accessorBuilder.access = accessor.access;
			accessorBuilder.createPrivateProperty = false;
			accessorBuilder.visibility = (!type.isInterface) ? ProxyFactory.getMemberVisibility(accessor) : MemberVisibility.PUBLIC;
			var getterFunc:Function = function(event:AccessorBuilderEvent):void {
				IEventDispatcher(event.target).removeEventListener(AccessorBuilderEvent.BUILD_GETTER, getterFunc);
				event.builder = createGetter(event.accessorBuilder, classBuilder, multiName, bytecodeQname, type.isInterface);
			};
			accessorBuilder.addEventListener(AccessorBuilderEvent.BUILD_GETTER, getterFunc);
			var setterFunc:Function = function(event:AccessorBuilderEvent):void {
				IEventDispatcher(event.target).removeEventListener(AccessorBuilderEvent.BUILD_SETTER, setterFunc);
				event.builder = createSetter(event.accessorBuilder, classBuilder, multiName, bytecodeQname, type.isInterface);
			};
			accessorBuilder.addEventListener(AccessorBuilderEvent.BUILD_SETTER, setterFunc);
		}

		/**
		 * Creates a basic <code>IMethodBuilder</code> for the specified <code>IAccessorBuilder</code>,
		 * it uses the <code>IAccessorBuilder</code> to retrieve the name, namespace, isFinal, and packageName
		 * values.
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createMethod(accessorBuilder:IAccessorBuilder):IMethodBuilder {
			CONFIG::debug {
				Assert.notNull(accessorBuilder, "accessorBuilder argument must not be null");
			}
			var mb:MethodBuilder = new MethodBuilder();
			mb.name = accessorBuilder.name;
			mb.namespaceURI = accessorBuilder.namespaceURI;
			mb.scopeName = accessorBuilder.scopeName;
			mb.isFinal = accessorBuilder.isFinal;
			mb.isOverride = accessorBuilder.isOverride;
			mb.packageName = accessorBuilder.packageName;
			mb.visibility = accessorBuilder.visibility;
			return mb;
		}

		/**
		 * Generates a getter method for the specified <code>IAccessorBuilder</code> instance.
		 * <p>The specified <code>Multiname</code> and <code>QualifiedName</code> instances are passed on to the <code>addGetterBody()</code> method.</p>
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createGetter(accessorBuilder:IAccessorBuilder, classBuilder:IClassBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(accessorBuilder);
			mb.returnType = accessorBuilder.type;
			addGetterBody(mb, multiName, bytecodeQname, classBuilder, isInterface);
			return mb;
		}

		/**
		 * Generates a setter method for the specified <code>IAccessorBuilder</code> instance.
		 * <p>The specified <code>Multiname</code> and <code>QualifiedName</code> instances are passed on to the <code>addSetterBody()</code> method.</p>
		 * @param accessorBuilder The specified <code>IAccessorBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 * @return The new <code>IMethodBuilder</code> instance.
		 */
		protected function createSetter(accessorBuilder:IAccessorBuilder, classBuilder:IClassBuilder, multiName:Multiname, bytecodeQname:QualifiedName, isInterface:Boolean):IMethodBuilder {
			var mb:IMethodBuilder = createMethod(accessorBuilder);
			mb.returnType = BuiltIns.VOID.fullName;
			mb.defineArgument(accessorBuilder.type);
			addSetterBody(mb, accessorBuilder, multiName, bytecodeQname, classBuilder, isInterface);
			return mb;
		}

		/**
		 * Generates a method body for a getter method in the specified <code>IMethodBuilder</code> instance.
		 * <p>The actionscript for the generated body would look like this:</p>
		 * <listing version="3.0">
		 * override public function get getter():uint {
		 *  return as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.GETTER, new QName("", "getter"), [super.getter]);
		 * }
		 * </listing>
		 * <p>It will pass the current value of the getter in the arguments <code>Array</code> so that it may be examined by any <code>IInterceptor</code>
		 * instances.</p>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		protected function addGetterBody(methodBuilder:IMethodBuilder, multiName:Multiname, bytecodeQname:QualifiedName, classBuilder:IClassBuilder, isInterface:Boolean):void {
			CONFIG::debug {
				Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			}
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_GETTER_BODY_BUILD, methodBuilder, classBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length > 0) {
				return;
			}
			var methodQName:QualifiedName = createMethodQName(methodBuilder);
			methodBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.getproperty, [interceptorRTQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [GetterKindQName]) //
				.addOpcode(Opcode.findpropstrict, [qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [qnameQname, 2]);
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [createMethodQName(methodBuilder)]);
			} else {
				methodBuilder.addOpcode(Opcode.pushnull);
			}
			methodBuilder.addOpcode(Opcode.newarray, [1]) //
				.addOpcode(Opcode.callproperty, [multiName, 4]) //
				.addOpcode(Opcode.returnvalue);

			event = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.AFTER_GETTER_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
		}

		/**
		 * Generates a method body for a setter method in the specified <code>IMethodBuilder</code> instance.
		 * <p>The actionscript for the generated body would look like this:</p>
		 * <listing version="3.0">
		 * override public function set setter(value:uint):void {
		 *  super.getterSetter = as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, new QName("", "setter"), [value, super.setter]);
		 * }
		 * </listing>
		 * <p>If the specified accessor is read and write enabled it will pass the current value of the getter as the second argument, the first argument is the new value.</p>
		 * <p>In the case of a write only accessor the code will be generated like this:</p>
		 * <listing version="3.0">
		 * override public function set setter(value:uint):void {
		 *  super.getterSetter = as3commons_bytecode_proxy::methodInvocationInterceptor.intercept(this, InvocationKind.SETTER, new QName("", "setter"), [value]);
		 * }
		 * </listing>
		 * <p>In this case the intercepting logic needs to be able to return a valid value for the setter method in the case where the nw value is rejected by some kind of business rule.</p>
		 * @param methodBuilder The specified <code>IMethodBuilder</code> instance.
		 * @param multiName The specified <code>Multiname</code> instance.
		 * @param bytecodeQname The specified <code>QualifiedName</code> instance.
		 */
		protected function addSetterBody(methodBuilder:IMethodBuilder, accessorBuilder:IAccessorBuilder, multiName:Multiname, bytecodeQname:QualifiedName, classBuilder:IClassBuilder, isInterface:Boolean):void {
			CONFIG::debug {
				Assert.notNull(methodBuilder, "methodBuilder argument must not be null");
			}
			var event:ProxyFactoryBuildEvent = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.BEFORE_SETTER_BODY_BUILD, methodBuilder, classBuilder);
			dispatchEvent(event);
			methodBuilder = event.methodBuilder;
			if (methodBuilder == null) {
				throw new ProxyBuildError(ProxyBuildError.METHOD_BUILDER_IS_NULL, "ProxyFactoryBuildEvent");
			}
			if (methodBuilder.opcodes.length > 0) {
				return;
			}
			CONFIG::debug {
				Assert.notNull(multiName, "multiName argument must not be null");
				Assert.notNull(bytecodeQname, "bytecodeQname argument must not be null");
			}
			var methodQName:QualifiedName = createMethodQName(methodBuilder);
			var argLen:int = 1;
			var superSetter:QualifiedName = (!isInterface) ? createMethodQName(methodBuilder) : null;
			methodBuilder.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.pushscope) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.findpropstrict, [interceptorRTQName]) //
				.addOpcode(Opcode.findpropstrict, [bytecodeQname]) //
				.addOpcode(Opcode.getproperty, [bytecodeQname]) //
				.addOpcode(Opcode.coerce, [namespaceQualifiedName]) //
				.addOpcode(Opcode.getproperty, [interceptorRTQName]) //
				.addOpcode(Opcode.getlocal_0) //
				.addOpcode(Opcode.findpropstrict, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [invocationKindQualifiedName]) //
				.addOpcode(Opcode.getproperty, [SetterKindQName]) //
				.addOpcode(Opcode.findpropstrict, [qnameQname]) //
				.addOpcode(Opcode.pushstring, [StringUtils.hasText(methodBuilder.namespaceURI) ? methodBuilder.namespaceURI : ""]) //
				.addOpcode(Opcode.pushstring, [methodBuilder.name]) //
				.addOpcode(Opcode.constructprop, [qnameQname, 2]) //
				.addOpcode(Opcode.getlocal_1);
			if ((accessorBuilder.access === AccessorAccess.READ_WRITE) && (superSetter != null)) {
				methodBuilder.addOpcode(Opcode.getlocal_0) //
					.addOpcode(Opcode.getsuper, [superSetter]);
				argLen = 2;
			}
			methodBuilder.addOpcode(Opcode.newarray, [argLen]) //
				.addOpcode(Opcode.callproperty, [multiName, 4]);
			if (!isInterface) {
				methodBuilder.addOpcode(Opcode.setsuper, [superSetter]);
			}
			methodBuilder.addOpcode(Opcode.returnvoid);
			event = new ProxyFactoryBuildEvent(ProxyFactoryBuildEvent.AFTER_SETTER_BODY_BUILD, methodBuilder);
			dispatchEvent(event);
		}

	}
}
