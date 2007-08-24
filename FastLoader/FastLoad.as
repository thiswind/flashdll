package{

import flash.display.*;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import org.flashdll.DLLLoader;
import org.flashdll.DLLLoaderUI;	

/**
 * FastLoad will load the dlls and app first, and then execute the app automatically with the 
 * url param.
 * @author iiley
 */
public class FastLoad extends Sprite{
	
	private var loader:DLLLoader;
	private var appLoader:Loader;
	private var appPath:String;
	
	public function FastLoad(){
		super();
		loader = new DLLLoader();
		var dllsStr:String = loaderInfo.parameters["dlls"];
		var appStr:String = loaderInfo.parameters["app"];
		if(dllsStr != "" && dllsStr != null){
			var dlls:Array = dllsStr.split(",");
			var dllPaths:Array = [];
			for(var i:int=0; i<dlls.length; i++){
				var dll:String = dlls[i];
				var path:String = dll;
				if(dll.substr(0, 5) != "http:"){
					path = "http://www.flashdll.org/"+ dll +".swf"
				}
				loader.addDLL(path, dll);
			}
		}
		appPath = appStr;
		var ui:DLLLoaderUI = new DLLLoaderUI(this, loader);
		loader.addEventListener(DLLLoader.ALL_COMPLETED, __dllLoaded);
		loader.notify();
	}
	
	private var appURLLoader:URLLoader;
	private function __dllLoaded(e:Event):void{
		appURLLoader = new URLLoader();
		appURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
		appURLLoader.addEventListener(Event.COMPLETE, __appByteLoaded);
		appURLLoader.load(new URLRequest(appPath));
	}
	
	private function __appByteLoaded(e:Event):void{
		appLoader = new Loader();
		addChild(appLoader);
		appLoader.loadBytes(appURLLoader.data, new LoaderContext(false, ApplicationDomain.currentDomain));
	}
}
}