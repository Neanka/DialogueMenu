package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class errormessage extends MovieClip {
		
		public var t_tf: TextField;
		
		public function errormessage() {
			// constructor code
			visible = false;
		}
		
		public function open(type: int)
		{
			switch (type) 
			{
				case 0:
					t_tf.text = "F4SE Status: FAIL\n\nF4SE is not running. Make sure that F4SE is installed and that you have launched the game with f4se_loader.exe.";
				break;
				case 1:
					t_tf.text = "F4SE Status: OK\nXDI Status: FAIL\n\nXDI is not running. Make sure that XDI.dll is in your Data\\F4SE\\Plugins directory.";
				break;
				default:
			}
			visible = true;
		}
	}
	
}
