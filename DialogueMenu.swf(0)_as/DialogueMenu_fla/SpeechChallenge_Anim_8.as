package DialogueMenu_fla 
{
    import flash.display.*;
    import flash.events.*;
    
    public dynamic class SpeechChallenge_Anim_8 extends flash.display.MovieClip
    {
        public function SpeechChallenge_Anim_8()
        {
            super();
            addFrameScript(0, this.frame1, 5, this.frame6, 6, this.frame7, 69, this.frame70);
            return;
        }

        function frame1():*
        {
            visible = false;
            return;
        }

        function frame6():*
        {
            stop();
            return;
        }

        function frame7():*
        {
            this.BaseClip_mc.gotoAndPlay("ThumbsUp");
            visible = true;
            return;
        }

        function frame70():*
        {
            dispatchEvent(new flash.events.Event("OnSpeechChallengeAnimComplete"));
            visible = false;
            stop();
            return;
        }

        public var BaseClip_mc:flash.display.MovieClip;
    }
}
