package org.flashdll {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DefaultDLLUIView extends Sprite implements DLLLoaderUIView {		
		public function DefaultDLLUIView() {
			super();
			
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private static const FORMAT_BOLD_12:TextFormat = new TextFormat(null, 12, 0x666666, true);
		private static const FORMAT_10:TextFormat = new TextFormat(null, 10, 0x666666);
		private static const FORMAT_8:TextFormat = new TextFormat(null, 8, 0x666666);
		
		private var labelFormat:TextFormat = DefaultDLLUIView.FORMAT_10;
		private var captionFormat:TextFormat = DefaultDLLUIView.FORMAT_BOLD_12;
		
		private var progressBar:Shape;
		private var speedLabel:TextField;
		private var displayNamelabel:TextField;
		private var percentLabel:TextField;
		private var statusLabel:TextField;
		
		private var dllProgressBar:Shape;
		private var dllPercentLabel:TextField;
		
		private function init(e:Event) :void {
			var g:Graphics = null;
			
			var backgroundShadow:Shape = new Shape();
			g = backgroundShadow.graphics;
			g.beginFill(0x666666);
			g.drawRect(0, 0, 370, 154);
			g.endFill();
			this.center(backgroundShadow, 4, 5);
			this.addChild(backgroundShadow);
			
			var background:Shape = new Shape();
			g = background.graphics;
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, 370, 154);
			g.endFill();
			this.center(background);
			this.addChild(background);
			
			var progressBarShadow:Shape = new Shape();
			g = progressBarShadow.graphics;
			g.lineStyle(5, 0xCCCCCC, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.center(progressBarShadow, 0, -24);
			this.addChild(progressBarShadow);
			
			this.progressBar = new Shape();
			g = this.progressBar.graphics;
			g.lineStyle(3, 0x000000, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.center(this.progressBar, 0, -25);
			this.progressBar.scaleX = 0.0;
			this.addChild(this.progressBar);
			
			this.speedLabel = new TextField();
			this.speedLabel.selectable = false;
			this.center(this.speedLabel, -150, -20, true, true);
			this.addChild(this.speedLabel);
			this.setSpeed("no speed");
			
			this.displayNamelabel = new TextField();
			this.displayNamelabel.selectable = false;
			this.addChild(this.displayNamelabel);
			this.setDisplayName("Please wait...");
			
			this.percentLabel = new TextField();
			this.percentLabel.selectable = false;
			this.center(this.percentLabel, 120, -20, true, true);
			this.addChild(this.percentLabel);
			this.setLoadingProgressBar(0, 100);
			
			this.statusLabel = new TextField();
			this.statusLabel.selectable = false;
			this.center(this.statusLabel, -176, 60, true, true);
			this.addChild(this.statusLabel);
			this.setStatus("Initializing...");
			
			var dllProgressBarShadow:Shape = new Shape();
			g = dllProgressBarShadow.graphics;
			g.lineStyle(5, 0xCCCCCC, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.center(dllProgressBarShadow, 0, 31);
			this.addChild(dllProgressBarShadow);
			
			this.dllProgressBar = new Shape();
			g = this.dllProgressBar.graphics;
			g.lineStyle(3, 0x000000, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.center(this.dllProgressBar, 0, 30);
			this.dllProgressBar.scaleX = 0.0;
			this.addChild(this.dllProgressBar);
			
			this.dllPercentLabel = new TextField();
			this.dllPercentLabel.selectable = false;
			this.center(this.dllPercentLabel, 120, 34, true, true);
			this.addChild(this.dllPercentLabel);
			this.setDLLProgressBar(0, 0);
			
			this.visible = true;
		}
		private function center(display:DisplayObject, xoffset:int=0.0, yoffset:int=0.0, noWidth:Boolean=false, noHeight:Boolean=false) :void {
			var width:uint = display.width;
			var height:uint = display.height;
			
			if (noWidth) {
				width = 0;
			}
			if (noHeight) {
				height = 0;
			}
			
			var cx:uint = Math.round((this.stage.stageWidth-width)/2);
			var cy:uint = Math.round((this.stage.stageHeight-height)/2);
			
			cx += this.x;
			cy += this.y;
			
			cx += xoffset;
			cy += yoffset;
			
			display.x = cx;
			display.y = cy;
		}
		
		public function setStatus(status:String):void {
			this.statusLabel.text = status;
			this.statusLabel.width = this.statusLabel.textWidth + 6;
			this.statusLabel.setTextFormat(this.labelFormat);
		}
		
		public function setDLLProgressBar(dllLoaded:uint, dllTotal:uint):void {
			var percent:Number = (dllTotal == 0) ? 0 : (dllLoaded / dllTotal);
			
			this.dllProgressBar.scaleX = percent;
			
			this.dllPercentLabel.text = dllLoaded + " of " + dllTotal;
			this.dllPercentLabel.width = this.dllPercentLabel.textWidth + 6;
			this.dllPercentLabel.setTextFormat(this.labelFormat);
		}
		
		public function setDisplayName(displayName:String):void {
			this.displayNamelabel.text = displayName;
			this.displayNamelabel.width = this.displayNamelabel.textWidth + 6;
			this.displayNamelabel.setTextFormat(this.captionFormat);
			this.center(this.displayNamelabel, 0, -48, false, true);
		}
		
		public function setLoadingProgressBar(bytesLoaded:uint, bytesTotal:uint):void {			
			var percent:Number = (bytesTotal == 0) ? 0 : (bytesLoaded / bytesTotal);
			//trace (percent);
			this.progressBar.scaleX = percent;
			
			this.percentLabel.text = Math.round(100 * percent) + "%";
			this.percentLabel.width = this.percentLabel.textWidth + 6;
			this.percentLabel.setTextFormat(this.labelFormat);
		}
		
		public function setSpeed(speed:String) :void {
			this.speedLabel.text = speed;
			this.speedLabel.width = this.speedLabel.textWidth + 6;
			this.speedLabel.setTextFormat(this.labelFormat);//"Verdana"
		}
	}
}