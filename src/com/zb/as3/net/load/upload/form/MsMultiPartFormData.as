package com.zbself.as3.framework.net.load.upload.form
{
	import flash.utils.ByteArray;
	
	/** 
	 * 用于打包multipart/form-data格式HTTP数据包的类 [Form方式 二进制上传]<br>
	 * <br>
	 * 用法:<br>
	 * var formData:MsMultiPartFormData = new MsMultiPartFormData();<br>
	 * formData.AddFormField();//添加字段<br>
	 * form.AddStreamFile("test","test.jpg",jpgEncode.encode(bitmapData));//添加文件二进制流<br>
	 * form.AddFile("test","test.jpg",jpgEncode.encode(bitmapData),"application/octet-stream");//添加文件(指定二进制数据类型)<br>
	 * form.PrepareFormData();//打包<br>
	 * var header:URLRequestHeader = new URLRequestHeader ("Content-Type", "multipart/form-data; boundary="+MsMultiPartFormData.Boundary);<br>
	 * var request:URLRequest = new URLRequest(url);<br>
	 * request.requestHeaders.push(header);<br>
	 * request.method="POST";<br>
	 * request.data = frm.GetFormData();<br>
	 * var urlLoader:URLLoader = new URLLoader(request);<br>
	 */
	public class MsMultiPartFormData
	{
		public var Boundary:String= "---------------------------7db1851cd1158";
		
		private var fieldName:String="Content-Disposition: form-data; name=\"XXXX\"";
		
		private var fieldValue:String= "XXXX";
		
		private var fileField:String="Content-Disposition: form-data; name=\"XXXX\"; filename=\"XXXXXXXX\"";
		
		private var fileContentType:String= "Content-Type: XXXX";
		
		private var formData:ByteArray;
		
		/**
		 * ...  
		 */
		public function MsMultiPartFormData ()
		{
			formData=new ByteArray();
		}
		
		/**
		 * 添加一个字段数据到From的数据包中
		 */
		public function AddFormField( FieldName:String,  FieldValue:String):void
		{
			var newFieldName:String=fieldName;   
			var newFieldValue:String=fieldValue;   
			
			newFieldName=newFieldName.replace("XXXX",FieldName);   
			newFieldValue=newFieldValue.replace("XXXX",FieldValue);   
			
			formData.writeMultiByte( "--"+Boundary+"\r\n","UTF-8");   
			formData.writeMultiByte( newFieldName+"\r\n\r\n","UTF-8");   
			formData.writeMultiByte( newFieldValue+"\r\n","UTF-8");   
		}
		
		
		/**
		 * 添加一个文件二进流数据到Form的数据包中，并指定二进流数据的类型
		 */
		public function AddFile( FieldName:String, FileName:String,FileContent:ByteArray, ContentType:String):void
		{
			var newFileField:String=fileField;
			var newFileContentType:String=fileContentType;
			
			newFileField=newFileField.replace("XXXX",FieldName);
			newFileField=newFileField.replace("XXXXXXXX",FileName);
			
			newFileContentType=newFileContentType.replace("XXXX",ContentType);
			
			formData.writeMultiByte( "--"+Boundary+"\r\n","UTF-8");
			formData.writeMultiByte( newFileField+"\r\n","UTF-8");
			formData.writeMultiByte( newFileContentType+"\r\n\r\n","UTF-8");
			
			formData.writeBytes(FileContent,0,FileContent.length);
			
			formData.writeMultiByte("\r\n","UTF-8");
		}
		
		/**
		 * 添加一个文件二进流数据到Form的数据包中
		 */
		public function AddStreamFile( FieldName:String, FileName:String,FileContent:ByteArray):void
		{
			AddFile( FieldName, FileName, FileContent,"application/octet-stream");
		}
		
		/**
		 * 把Form中所有的字段与二进制流数据打包成一个完整的From数据包
		 */
		public function PrepareFormData():void
		{
			formData.writeMultiByte( "--"+Boundary+"--","UTF-8");
		}
		
		/**
		 * 获得From的完整数据
		 */
		public function GetFormData():ByteArray
		{
			return formData;
		}
	}
}