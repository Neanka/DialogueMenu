package
{
	import flash.geom.ColorTransform;
	
	public class myShared
	{
		
		public static var ct_green: ColorTransform;
		public static var ct_yellow: ColorTransform;
		public static var ct_orange: ColorTransform;
		public static var ct_red: ColorTransform;
		public static var ct_white: ColorTransform;
		public static var ct_UI_color: ColorTransform;
		
		public static var fittext: Boolean = true;
		public static var dimming: Boolean = true;
		public static var showQuestionIcon: Boolean = false;
		
		public static var menuStatus: Boolean = false;
		
		public function myShared()
		{
			super();
		}
		
		static public function getColor(tempMainCT:ColorTransform):int
		{
			return int(256 * 256 * 255 * tempMainCT.redMultiplier) + int(256 * 255 * tempMainCT.greenMultiplier) + int(255 * tempMainCT.blueMultiplier);
		}
		
		static public function getCT(rgb: int): ColorTransform
		{
			return new ColorTransform(((rgb >> 16) & 0xFF) / 255, ((rgb >> 8) & 0xFF) / 255, (rgb & 0xFF) / 255);
		}
	}

}
