package scaleform.gfx 
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    
    public final class Extensions extends Object
    {
        public function Extensions()
        {
            super();
            return;
        }

        public static function set enabled(arg1:Boolean):void
        {
            return;
        }

        public static function get enabled():Boolean
        {
            return false;
        }

        public static function set noInvisibleAdvance(arg1:Boolean):void
        {
            return;
        }

        public static function get noInvisibleAdvance():Boolean
        {
            return false;
        }

        public static function getTopMostEntity(arg1:Number, arg2:Number, arg3:Boolean=true):flash.display.DisplayObject
        {
            return null;
        }

        public static function getMouseTopMostEntity(arg1:Boolean=true, arg2:uint=0):flash.display.DisplayObject
        {
            return null;
        }

        public static function setMouseCursorType(arg1:String, arg2:uint=0):void
        {
            return;
        }

        public static function getMouseCursorType(arg1:uint=0):String
        {
            return "";
        }

        public static function get numControllers():uint
        {
            return 1;
        }

        public static function get visibleRect():flash.geom.Rectangle
        {
            return new flash.geom.Rectangle(0, 0, 0, 0);
        }

        public static function getEdgeAAMode(arg1:flash.display.DisplayObject):uint
        {
            return EDGEAA_INHERIT;
        }

        public static function setEdgeAAMode(arg1:flash.display.DisplayObject, arg2:uint):void
        {
            return;
        }

        public static function setIMEEnabled(arg1:flash.text.TextField, arg2:Boolean):void
        {
            return;
        }

        public static function get isScaleform():Boolean
        {
            return false;
        }

        
        {
            isGFxPlayer = false;
        }

        public static const EDGEAA_INHERIT:uint=0;

        public static const EDGEAA_ON:uint=1;

        public static const EDGEAA_OFF:uint=2;

        public static const EDGEAA_DISABLE:uint=3;

        public static var isGFxPlayer:Boolean=false;

        public static var CLIK_addedToStageCallback:Function;

        public static var gfxProcessSound:Function;
    }
}
