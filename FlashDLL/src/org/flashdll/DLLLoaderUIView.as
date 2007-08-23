package org.flashdll {
	public interface DLLLoaderUIView {
		function setLoadingProgressBar(bytesLoaded:uint, bytesTotal:uint) :void;
		
		function setDLLProgressBar(dllLoaded:uint, dllTotal:uint) :void;
		
		function setDisplayName(displayName:String) :void;
		
		function setStatus(status:String) :void;
		
		function setSpeed(speed:String) :void;
	}
}