package DialogueMenu_fla 
{
    import flash.display.*;
    
    public dynamic class Button_FadeAnim_3 extends flash.display.MovieClip
    {
        public function Button_FadeAnim_3()
        {
            super();
            addFrameScript(0, this.frame1, 1, this.frame2, 9, this.frame10, 10, this.frame11, 19, this.frame20, 20, this.frame21);
            return;
        }

        function frame1():*
        {
            visible = false;
            stop();
            return;
        }

        function frame2():*
        {
            visible = true;
            return;
        }

        function frame10():*
        {
            stop();
            return;
        }

        function frame11():*
        {
            visible = true;
            return;
        }

        function frame20():*
        {
            gotoAndStop(1);
            return;
        }

        function frame21():*
        {
            visible = true;
            return;
        }

        public var Holder:flash.display.MovieClip;
    }
}
