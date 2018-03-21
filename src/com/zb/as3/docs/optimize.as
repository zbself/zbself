用乘法来代替除法，用位运算代替除2或乘2

将多行赋值转为单行赋值(a=b=c=0)

将可以在循环外进行的运算提取到循环外。获取某些对象的属性，数组的成员等等都可以算作计算
	
尽可能使用内联代码以减少代码中函数的调用次数。
	
避免使用嵌套的if结构：例如if(a>1&&b>1){}比嵌套的if(a>1){if(b>1){}}要快且代码清晰。

避免使用with语句。

用int不用Math.floor():前者比后者快。

var obj:Object = new Object()比var obj:Object = {}快。

var arr:Array = []比 var arr:Array = new Array()快。

if (myObj) 比if (myObj != null) 快。
	
当程序里有多条分支时，将频繁发生的分支放在上面.
	
	
final或static的getter和setter函数会自动成为内联函数，不需要[Inline]元数据，且在未开启“-inline”参数时，已默认为内联函数。
	
	
@@@
避免使用for in循环：for in 循环比普通的for循环浪费更多的时间，应该避免。
采用更快的算法，尽量用Vector或Array的API.
	
	
	
	
	
	