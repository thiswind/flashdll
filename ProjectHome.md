**Do you want to make your swf as small as html? No doubt, Find your DLLs on http://www.flashdll.org**

You can find the dlls you need on http://www.flashdll.org

if you wanna add your dll into flashdll.org, please mail us at thiswind@gmail.com.
you should attach your dll in the mail, and a simple introduction of it's usage.
we'll check it, and then, it will be posted for everyone:)

example code:
```
package {
    import flash.display.Sprite;
    import flash.events.Event;

    import org.flashdll.DLLLoader;
    import org.flashdll.DLLLoaderUI;

    import org.aswing.AsWingManager;
    import org.aswing.JFrame;

    public class FlashDLLTest extends Sprite
    {
        public function FlashDLLTest()
        {

            //create a dll loader and add a listener for "all completed"
            var loader:DLLLoader = new DLLLoader(this);
            loader.addEventListener(DLLLoader.ALL_COMPLETED , this.init);
            
            //create an ui to get a visible loading (it's optional)
            var ui:DLLLoaderUI = new DLLLoaderUI(this, loader);
            
            //specify your dlls
            loader.addDLL("http://www.flashdll.org/AsWingDLL_1_1_0.swf", "AsWing");
            // in fact, you can add more than one dlls if you need.
            // we recommand you to find out the dlls you need on http://www.flashdll.com it will comming soon_
            //loader.addDLL("http://www.flashdll.org/AsWingDLL_1_1_0.swf", "AsWing 2");
            //loader.addDLL(" http://www.flashdll.org/AsWingDLL_1_1_0.swf", "AsWing 3");
            //loader.addDLL("http://www.flashdll.org/AsWingDLL_1_1_0.swf ", "AsWing 4");
            
            //now notify the loader, and it will start download dlls at once
            loader.notify();
        }
        
        //when all dlls needed has loaded and installed
        private function init(e:Event) :void {

            //now you can use the dlls' services
            AsWingManager.initSdandard(this);

            var frame:JFrame = new JFrame(this, "DLL Test");
            frame.setSizeWH(300, 200);
            frame.show();
        }
    }
}
```


For the example above, you need FlashDLL.swc in this project's library path.and set the AsWing.swc link type as "external".Once you downloaded the AsWingDLL, it will always in your IE cache, and no matter what Flash applications used that DLL, you'll never need to download it again.

You'll find you swf becomming much smaller (save 95%).

It's the best way to speed up your Flash application on Web.


Update in July 1, 2008


DLLLoader in Adobe AIR project:
```
package org.flashdll
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.flashdll.DLLLoader;
	
	 // @author gaoyan
	 // qq:270517797
	 // DLLLoader类air版  
	 // 此类专门用于air项目中的flashdll加载，是我在air项目发现原始flashdll类用安全错误，而进行编写的。大家在使用中可以修改、提出意见。
	 // 使用方法上和 普通的DLLLoader 一样 ，不需要对具体代码进行修改。 
	 
	 // dispatch when a dll is installed into current domain
	 
	[Event(name="install", type="org.flashdll.ExtendDLLLoader")]
	
	// dispatch when all dlls loaded and installed
	  
	[Event(name="allCompleted", type="org.flashdll.ExtendDLLLoader")]
		
	public class AIRDLLLoader extends DLLLoader
	{
		public static const INSTALL:String = "install";
		public static const ALL_COMPLETED:String = "all completed";
		public function ExtendDLLLoader(root:DisplayObjectContainer=null)
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
			this.loader.loadBytes(bytes, context);
		}
	}
}
```