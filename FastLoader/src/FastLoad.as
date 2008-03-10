package{

import flash.display.*;
import flash.net.*;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import org.flashdll.DLLLoader;
import org.flashdll.DLLLoaderUI;	

/**
 * FastLoad will load the dlls and app first, and then execute the app automatically with the 
 * url param.
 * @author iiley
 */
public class FastLoad extends Sprite{
	
	private var loader:DLLLoader;
	private var ui:DLLLoaderUI;
	
	public function FastLoad(){
		super();
		if(stage){
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		loader = new DLLLoader(this);
		ui = new DLLLoaderUI(this, loader);
		var dllsStr:String = loaderInfo.parameters["dlls"];
		if(dllsStr != null && dllsStr != ""){
			startLoad(dllsStr);
		}else{
			new XMLLoader(
				function(xmlStr:String):void{
					if(xmlStr){
						startLoad(xmlStr);
					}else{
						ui.getView().setStatus("can't load dlls.xml!");
					}
				}
			).load(new URLRequest("dlls.xml"));
		}
	}
	
	private function startLoad(xmlStr:String):void{
		var xml:XMLDocument = new XMLDocument();
		try{
			xml.ignoreWhite = true;
			xml.parseXML(xmlStr);
		}catch(e:Error){
			ui.getView().setStatus("XML error : " + e);
			return;
		}
		for(var node:XMLNode = xml.firstChild.firstChild; node!=null; node=node.nextSibling){
			loader.addDLL(node.attributes.path, node.attributes.name, node.attributes.execute);
		}
		loader.notify();
	}
}
}

import flash.net.*;
import flash.xml.XMLDocument;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ErrorEvent;
import flash.events.SecurityErrorEvent;

class XMLLoader extends URLLoader{
	
	private var xml:XMLDocument;
	private var loadedHandler:Function;
	
	/**
	 * loadedHandler(xml:XMLDocument)
	 */
	public function XMLLoader(loadedHandler:Function=null){
		super();
		this.loadedHandler = loadedHandler;
		this.dataFormat = URLLoaderDataFormat.TEXT;
		this.addEventListener(Event.COMPLETE, __xmlComplete);
		this.addEventListener(IOErrorEvent.IO_ERROR, __error);
		this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __error);
	}
	
	private function __error(e:ErrorEvent):void{
		loadedHandler(null);
	}
	
	private function __xmlComplete(e:Event):void{
		loadedHandler(data);
	}
}