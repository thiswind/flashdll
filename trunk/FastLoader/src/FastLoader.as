package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.StageScaleMode;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import org.flashdll.DLLLoader;

	[SWF(width=800, height=600)]
	public class FastLoader extends Sprite
	{
		public function FastLoader()
		{
			super();
						
			var loader:DLLLoader = new DLLLoader();
			loader.addDLL("CA.swf", "CA");
			loader.addEventListener(DLLLoader.ALL_COMPLETED, this.onLoaded);
			
			loader.notify();
		}
		
		private function onLoaded(e:Event) :void {
			trace ("loaded");
		}
	}
}
