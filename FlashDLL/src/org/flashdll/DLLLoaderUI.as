package org.flashdll {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;	
	
	/**
	 * DLLLoaderUI is a UI wrapper of DLLLoader
	 * @author Hukuang
	 */ 
	public class DLLLoaderUI  {
		
		private var loader:DLLLoader;
		private var owner:DisplayObjectContainer;
		private var view:DLLLoaderUIView;
		
		public function DLLLoaderUI(owner:DisplayObjectContainer, loader:DLLLoader, view:DLLLoaderUIView=null) {
			this.owner = owner;
			this.loader = loader;
			
			this.loader.addEventListener(Event.OPEN, this.__onOpen);
			this.loader.addEventListener(ProgressEvent.PROGRESS, this.__onProgress);
			this.loader.addEventListener(Event.COMPLETE, this.__onComplete);
			this.loader.addEventListener(DLLLoader.INSTALL, this.__onInstall);
			this.loader.addEventListener(DLLLoader.ALL_COMPLETED, this.__onAllComplete);
			this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.__onIOError);
			this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.__onSecurityError);
			this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.__onHttpStatus);
			
			this.setView(view);
		}
		
		public function setView(view:DLLLoaderUIView) :void {
			if (view == null) {
				view = new DefaultDLLUIView();
			}
			
			this.view = view;
			this.owner.addChild(DisplayObject(this.view));
		}
		
		private function __onOpen(e:Event) :void {
			this.view.setDisplayName(this.loader.getCurrentDisplayName());
			this.view.setDLLProgressBar(this.loader.getDLLsLoaded(), this.loader.getDLLsTotal());
			this.view.setStatus("Loading...");
		}
		
		private function __onIOError(e:IOErrorEvent) :void {
			this.view.setStatus("IOError:" + e.text);
		}
		
		private function __onSecurityError(e:SecurityErrorEvent) :void {
			this.view.setStatus("SecurityError:" + e.text);
		}
		
		private function __onHttpStatus(e:HTTPStatusEvent) :void {
			this.view.setStatus("HttpStatus:" + e.status);
		}
		
		private function __onProgress(e:ProgressEvent) :void {
			this.view.setLoadingProgressBar(e.bytesLoaded, e.bytesTotal);
			this.view.setSpeed(Math.round(e.bytesLoaded/1024) + " (kb) of " + Math.round(e.bytesTotal/1024) + " (kb) at " + Math.round(this.loader.getcurrentSpeed()/1024 * 1000) + " (kb/s)");
		}
		private function __onComplete(e:Event) :void {
			this.view.setStatus("Complete");
			this.view.setDLLProgressBar(this.loader.getDLLsLoaded(), this.loader.getDLLsTotal());
		}
		private function __onInstall(e:Event) :void {
			this.view.setStatus("Installing...");
		}
		private function __onAllComplete(e:Event) :void {
			this.owner.removeChild(this.view as DisplayObject);
			this.view = null;
		}
	}
}