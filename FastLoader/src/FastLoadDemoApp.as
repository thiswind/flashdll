package
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import org.aswing.AsWingManager;
import org.aswing.JFrame;
import org.aswing.JLabel;

public class FastLoadDemoApp extends Sprite{
	
	public function FastLoadDemoApp(){
		super();
	}
	
	/**
	 * The application entry
	 * @param displayRoot the root
	 */
	public function main(displayRoot:DisplayObjectContainer):void{
		AsWingManager.initAsStandard(displayRoot);
		var jf:JFrame = new JFrame(displayRoot, "FastLoadDemoApp");
		jf.setSizeWH(240, 140);
		jf.setClosable(false);
		jf.show();
	}
}
}