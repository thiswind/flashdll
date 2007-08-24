package org.flashdll {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * default DLLLoaderUIView
	 */ 
	public class DefaultDLLUIView extends DLLLoaderUIView {		
		
		private static const FORMAT_BOLD_12:TextFormat = new TextFormat("_sans", 12, 0x666666, true);
		private static const FORMAT_10:TextFormat = new TextFormat("_sans", 10, 0x666666);
		private static const FORMAT_8:TextFormat = new TextFormat("_sans", 8, 0x666666);
		
		private var labelFormat:TextFormat = DefaultDLLUIView.FORMAT_10;
		private var captionFormat:TextFormat = DefaultDLLUIView.FORMAT_BOLD_12;
		
		private var group:Sprite;
		
		private var progressBar:Shape;
		private var speedLabel:TextField;
		private var displayNamelabel:TextField;
		private var percentLabel:TextField;
		private var statusLabel:TextField;
		
		private var dllProgressBar:Shape;
		private var dllPercentLabel:TextField;
		
		public function DefaultDLLUIView() {
			super();
			
			this.createUI();
			this.addEventListener(Event.ADDED_TO_STAGE, this.init);
			this.addEventListener(Event.RENDER, this.init);
		}
		
		private function createUI() :void {
			var g:Graphics = null;
			
			this.group = new Sprite();
			
			var c:Sprite = this.group;
			
			var backgroundShadow:Shape = new Shape();
			g = backgroundShadow.graphics;
			g.beginFill(0x666666);
			g.drawRect(0, 0, 370, 154);
			g.endFill();
			backgroundShadow.x = 4;
			backgroundShadow.y = 5;
			c.addChild(backgroundShadow);
			
			var background:Shape = new Shape();
			g = background.graphics;
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, 370, 154);
			g.endFill();
			c.addChild(background);
			
			var progressBarShadow:Shape = new Shape();
			g = progressBarShadow.graphics;
			g.lineStyle(5, 0xCCCCCC, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			progressBarShadow.x = 35;
			progressBarShadow.y = 60;
			c.addChild(progressBarShadow);
			
			this.progressBar = new Shape();
			g = this.progressBar.graphics;
			g.lineStyle(3, 0x000000, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.progressBar.x = 35;
			this.progressBar.y = 60;
			c.addChild(this.progressBar);
			this.progressBar.scaleX = 0.0;
			
			this.speedLabel = new TextField();
			this.speedLabel.selectable = false;
			this.speedLabel.x = 35;
			this.speedLabel.y = 60;
			c.addChild(this.speedLabel);
			this.setSpeed("no speed");
			
			this.displayNamelabel = new TextField();
			this.displayNamelabel.selectable = false;
			this.displayNamelabel.x = 35;
			this.displayNamelabel.y = 33;
			c.addChild(this.displayNamelabel);
			this.setDisplayName("Please wait...");
			
			this.percentLabel = new TextField();
			this.percentLabel.selectable = false;
			this.percentLabel.x = 305;
			this.percentLabel.y = 60;
			c.addChild(this.percentLabel);
			this.setLoadingProgressBar(0, 100);
			
			this.statusLabel = new TextField();
			this.statusLabel.selectable = false;
			this.statusLabel.x = 4;
			this.statusLabel.y = 136;
			c.addChild(this.statusLabel);
			this.setStatus("Initializing...");
			
			var dllProgressBarShadow:Shape = new Shape();
			g = dllProgressBarShadow.graphics;
			g.lineStyle(5, 0xCCCCCC, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			dllProgressBarShadow.x = 35;
			dllProgressBarShadow.y = 102;
			c.addChild(dllProgressBarShadow);
			
			this.dllProgressBar = new Shape();
			g = this.dllProgressBar.graphics;
			g.lineStyle(3, 0x000000, 1.0, false, "normal", "square");
			g.moveTo(0, 0);
			g.lineTo(300, 0);
			g.endFill();
			this.dllProgressBar.x = 35;
			this.dllProgressBar.y = 102;
			c.addChild(this.dllProgressBar);
			this.dllProgressBar.scaleX = 0.0;
			
			this.dllPercentLabel = new TextField();
			this.dllPercentLabel.selectable = false;
			this.dllPercentLabel.x = 35;
			this.dllPercentLabel.y = 102;
			c.addChild(this.dllPercentLabel);
			this.setDLLProgressBar(0, 0);
		}
		
		private function init(e:Event) :void {
			this.addChild(this.group);
			this.center(this.group);
			trace ("render");
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
		
		override public function setStatus(status:String):void {
			this.statusLabel.text = status;
			this.statusLabel.width = this.statusLabel.textWidth + 6;
			this.statusLabel.setTextFormat(this.labelFormat);
		}
		
		override public function setDLLProgressBar(dllLoaded:uint, dllTotal:uint):void {
			var percent:Number = (dllTotal == 0) ? 0 : (dllLoaded / dllTotal);
			
			this.dllProgressBar.scaleX = percent;
			
			this.dllPercentLabel.text = dllLoaded + " of " + dllTotal;
			this.dllPercentLabel.width = this.dllPercentLabel.textWidth + 6;
			this.dllPercentLabel.setTextFormat(this.labelFormat);
		}
		
		override public function setDisplayName(displayName:String):void {
			this.displayNamelabel.text = displayName;
			this.displayNamelabel.width = this.displayNamelabel.textWidth + 30;
			this.displayNamelabel.setTextFormat(this.captionFormat);
		}
		
		override public function setLoadingProgressBar(bytesLoaded:uint, bytesTotal:uint):void {			
			var percent:Number = (bytesTotal == 0) ? 0 : (bytesLoaded / bytesTotal);
			this.progressBar.scaleX = percent;
			
			this.percentLabel.text = Math.round(100 * percent) + "%";
			this.percentLabel.width = this.percentLabel.textWidth + 6;
			this.percentLabel.setTextFormat(this.labelFormat);
		}
		
		override public function setSpeed(speed:String) :void {
			this.speedLabel.text = speed;
			this.speedLabel.width = this.speedLabel.textWidth + 6;
			this.speedLabel.setTextFormat(this.labelFormat);
		}
	}
}