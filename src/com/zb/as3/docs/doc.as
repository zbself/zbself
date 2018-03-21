// ActionScript file



ArrayElementType：
这是指定自己定义的数组中元素的类型，应该类似java中的泛型，用的不多(至少我就没用过，找资料的时候顺便找到的)，类似的代码如下：
[ArrayElementType("String")]
public var arrayOfStrings:Array;
这样，这个array就只能放String类型的对象。



Inspectable
属性的代码提示和属性检查，在FlexBuilder中使用该组件时在properties视窗中可以看到该属性的值提示，主要用于一个属性的值为几个固定选项时。类似代码如下：
[Inspectable(category="General", enumeration="text,password", defaultValue="text",type="String")]
public var inputType;



Effect
用来定义事件触发时产生的效果，和Event标签一起使用。类似代码如下：
//定义代码
[Event(name="textChanged", type="flash.events.Event")]
[Effect(name="textChangedEffect", event="textChanged")]
public class SelfInput extends SimpleWidget{
}
//使用代码
<myComp:SelfInput textChanged="textChanged(event)" textChangedEffect="changeEffect"/>
此时，input组件的text改变时产生效果。使用effect可以制作许多花哨的效果，比如翻页什么的，效果的使用以后再开一篇文章记录。



Event
这个标签主要在编写显示组件时使用，使用这个标签就能够为组件提供一个事件处理函数的接口。定义组件时，可以为该组件赋一个方法在事件触发时调用。类似代码如下：
//定义代码
[Event(name="textChanged", type="flash.events.Event")]
public class SelfInput extends SimpleWidget{
	private var _text:String;
	public function set text(s:String):void {
		_text= s;
		var eventObj:Event = new Event("textChanged");
			dispatchEvent(eventObj);
			}
	}
			//调用代码
			<mx:Script>
			<![CDATA[
			public function textChanged(eventObj:Event):void {
				trace(eventObj.target.text);
			}
			]]>
			</mx:Script>
			<myComp:SelfInput textChanged="textChanged(event)"/>
				
				

Bindable：
毫无疑问这是最常用到的一个标签，几乎所有和数据打交道的地方都会用到这个标签。使用这个标签的属性一旦改变就会dispatch一个事件给监听器，可以选择后面带与不带参数两种方式：
[Bindable]:不带参数就表示使用默认事件，那么flex在满足触发条件是自动发送一个propertyChange事件。
[Bindable(event="eventname")]:带参数表示使用指定的事件，当然首先要把事件给注册好才行。
可以在3个地方使用[Bindable]标签：
1.在public class定义前，这个场景不太常用，这个时候[Bindable]会绑定所有作为变量定义的public属性，并且所有的public属性都定义有 getter和setter方法，[Bindable]没有参数，flex会自动创建一个propertyChange事件来处理所有的公有属性。类似代码如下：
	[Bindable]
	public class SelfInput extends SimpleWidget
		
		
		


