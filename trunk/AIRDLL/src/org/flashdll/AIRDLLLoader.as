package org.flashdll
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.flashdll.DLLLoader;
	/**
	 * 
	 * @author gaoyan
	 * qq:270517797
	 * 
	 * DLLLoader类air版  
	 *	
	 * 此类专门用于air项目中的flashdll加载，是我在air项目发现原始flashdll类用安全错误，而进行编写的。
	 * 大家在使用中可以修改、提出意见	
	 * 
	 * 使用方法上和 普通的DLLLoader 一样 ，不需要对具体代码进行修改。 
	 */
	 
	/**
	 * dispatch when a dll is installed into current domain
	 */ 
	[Event(name="install", type="org.flashdll.AIRDLLLoader")]
	
	/**
	 * dispatch when all dlls loaded and installed
	 */ 
	[Event(name="allCompleted", type="org.flashdll.AIRDLLLoader")]
		
	public class AIRDLLLoader extends DLLLoader
	{
		public static const INSTALL:String = "install";
		public static const ALL_COMPLETED:String = "all completed";
		public function AIRDLLLoader(root:DisplayObjectContainer=null)
		{
			super(root);
		}
		override protected function loadBytes(bytes:ByteArray):void
		{
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			//allowLoadBytesCodeExecution属性就是关键
			//它是用来标记是否可以用loadBytes()方法在air程序中运行时加载外部swf
			//如果不是true就会运行时抛出错误
			//具体说明请参见 air文档			
			context.allowLoadBytesCodeExecution=true;
			//this.loader.loadBytes(bytes, context);
			this.getLoader().loadBytes(bytes, context);
		}
	}
}