package org.flashdll {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	[Event(name="install", type="org.flashdll.DLLLoader")]
	[Event(name="allCompleted", type="org.flashdll.DLLLoader")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	public class DLLLoader extends EventDispatcher{
		
		public static const INSTALL:String = "install";
		public static const ALL_COMPLETED:String = "all completed";
		
		private var stream:URLStream;
		private var loader:Loader;
		
		private var dlls:Array = new Array();
		private var currentDLL:DLL;
		private var dllCount:int = 0;
		private var dllLoadedCount:int = 0;
		
		private var startTime:Number;
		private var currentSpeed:Number;
		
		private const MAX_FAULT_COUNT:int = 3;
		private var faultCount:int = 0;
			
		public function DLLLoader(){
			this.stream = new URLStream();
			this.stream.addEventListener(Event.OPEN, this.onOpen);
			this.stream.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
			this.stream.addEventListener(Event.COMPLETE, this.onStreamComplete);
			this.stream.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
			this.stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
			this.stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHttpStatus);
			
			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete);
		}
		
		public function addDLL(path:String, displayName:String) :void {
			var dll:DLL = new DLL();
			dll.path = path;
			dll.desplayName = displayName;
			this.dlls.push(dll);
			this.dllCount++;
		}
		public function notify() :void {
			this.process();
		}
		
		
		public function getCurrentDisplayName() :String {
			return this.currentDLL.desplayName;
		}
		public function getDLLsLoaded() :uint {
			return this.dllLoadedCount;
		}
		public function getDLLsTotal() :uint {
			return this.dllCount;
		}
		public function getcurrentSpeed() :Number {
			return this.currentSpeed;
		}
		
		public function getVersion() :String {
			return "0.4";
		}
		
		protected function process() :void {
			this.currentDLL = this.dlls.shift();
			//trace ("process:" + this.currentDLL);
			
			if (this.currentDLL != null) {
			    this.loadStream();
			} else {
				this.dispatchEvent(new Event(DLLLoader.ALL_COMPLETED));
			}
		}
		protected function loadStream() :void {
			var request:URLRequest = new URLRequest(this.currentDLL.path);
			stream.load(request);
		}
		protected function loadBytes(bytes:ByteArray) :void {
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			this.loader.loadBytes(bytes, context);
		}
		
		private function onOpen(e:Event) :void {
			//trace ("opened");
			
			var now:Date = new Date();
			this.startTime = now.getTime();
			
			this.dispatchEvent(e);
		}
		
		private function onIOError(e:IOErrorEvent) :void {
		    this.faultCount++;
		    
		    if (this.faultCount > this.MAX_FAULT_COUNT) {
		        this.dispatchEvent(e);
		    } else {
		        var timer:Timer = new Timer(500, 1);
			    timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent) :void {loadStream();});
				timer.start();
		    }
		}
		
		private function onSecurityError(e:SecurityErrorEvent) :void {
			this.faultCount++;
		    
		    if (this.faultCount > this.MAX_FAULT_COUNT) {
		        this.dispatchEvent(e);
		    } else {
		        var timer:Timer = new Timer(500, 1);
			    timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent) :void {loadStream();});
				timer.start();
		    }
		}
		
		private function onHttpStatus(e:HTTPStatusEvent) :void {
			this.dispatchEvent(e);
		}
		
		private function onProgress(e:ProgressEvent) :void {
			//trace ("progress " + Math.round(100 * e.bytesLoaded / e.bytesTotal) + "%");
			
			var now:Date = new Date();
			var elapsedTime:Number = now.getTime() - this.startTime;
			this.currentSpeed = e.bytesLoaded / elapsedTime;
			
			this.dispatchEvent(e);
		}
		
		private function onStreamComplete(e:Event) :void {
			//trace ("dll streamed");
			
			var bytes:ByteArray = new ByteArray();
			var length:int = this.stream.bytesAvailable;
			this.stream.readBytes(bytes, 0, length);
			this.stream.close();
			
			//trace ("dll byted");
			this.dispatchEvent(new Event(DLLLoader.INSTALL));
			
			//install dll
			this.loadBytes(bytes);
		}
		
		private function onLoaderComplete(e:Event) :void {
			//trace ("dll installed");
			
			this.dllLoadedCount++;
			this.dispatchEvent(e);
			
			//load next
			this.process();
		}
	}
} 

class DLL {
	public var path:String;
	public var desplayName:String;
}