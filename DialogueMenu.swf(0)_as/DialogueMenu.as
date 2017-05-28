// Decompiled by AS3 Sorcerer 4.99
// www.as3sorcerer.com

//DialogueMenu

package 
{
    import Shared.IMenu;
    import flash.display.MovieClip;
    import __AS3__.vec.Vector;
    import Shared.AS3.BSButtonHint;
	import Shared.AS3.BSScrollingList;
    import Shared.AS3.BSButtonHintData;
    import Shared.GlobalFunc;
    import __AS3__.vec.*;

    public class DialogueMenu extends IMenu 
    {

        public var FadeHolder_mc:MovieClip;
		//public var List_mc:DialogueList;
        public var BGSCodeObj:Object;
        private var Buttons:Vector.<BSButtonHint>;
        private var ButtonAnimators:Vector.<MovieClip>;
        private var ButtonData:Vector.<BSButtonHintData>;
        private var PositiveBtnData:BSButtonHintData = new BSButtonHintData("", "Down", "PSN_A", "Xenon_A", 1, onPositiveRelease);
        private var NegativeBtnData:BSButtonHintData = new BSButtonHintData("", "Right", "PSN_B", "Xenon_B", 1, onNegativeRelease);
        private var NeutralBtnData:BSButtonHintData = new BSButtonHintData("", "Left", "PSN_X", "Xenon_X", 0, onNeutralRelease);
        private var QuestionBtnData:BSButtonHintData = new BSButtonHintData("", "Up", "PSN_Y", "Xenon_Y", 0, onQuestionRelease);
        private var LastPressedButtonIndex:uint;
        private var _ButtonsShown:Boolean;

        public function DialogueMenu()
        {
            addFrameScript(0, this.frame1, 4, this.frame5);
            this.visible = false;
            this.BGSCodeObj = new Object();
            this.Buttons = new Vector.<BSButtonHint>();
            this.Buttons.push(this.FadeHolder_mc.Positive.Holder.Button_mc);
            this.Buttons.push(this.FadeHolder_mc.Negative.Holder.Button_mc);
            this.Buttons.push(this.FadeHolder_mc.Neutral.Holder.Button_mc);
            this.Buttons.push(this.FadeHolder_mc.Question.Holder.Button_mc);
            this.ButtonAnimators = new Vector.<MovieClip>();
            this.ButtonAnimators.push(this.FadeHolder_mc.Positive);
            this.ButtonAnimators.push(this.FadeHolder_mc.Negative);
            this.ButtonAnimators.push(this.FadeHolder_mc.Neutral);
            this.ButtonAnimators.push(this.FadeHolder_mc.Question);
            this.ButtonData = new Vector.<BSButtonHintData>();
            this.ButtonData.push(this.PositiveBtnData);
            this.ButtonData.push(this.NegativeBtnData);
            this.ButtonData.push(this.NeutralBtnData);
            this.ButtonData.push(this.QuestionBtnData);
            this.LastPressedButtonIndex = uint.MAX_VALUE;
            this._ButtonsShown = false;
            this.FadeHolder_mc.SpeechChallengeAnim_mc.mouseEnabled = false;
            this.FadeHolder_mc.SpeechChallengeAnim_mc.mouseChildren = false;
            this.FadeHolder_mc.SpeechChallengeAnim_mc.addEventListener("OnSpeechChallengeAnimComplete", this.OnSpeechChallengeAnimComplete);
			//List_mc = new DialogueList();
			//FadeHolder_mc.addChild(List_mc);
			this.FadeHolder_mc.Positive.Holder.visible = false;
			this.FadeHolder_mc.Negative.Holder.visible = false;
			this.FadeHolder_mc.Neutral.Holder.visible = false;
			this.FadeHolder_mc.Question.Holder.visible = false;
        }

        override protected function onSetSafeRect():void
        {
            GlobalFunc.LockToSafeRect(this, "BC", SafeX, SafeY);
        }

        public function onCodeObjCreate():*
        {
            this.BGSCodeObj.registerObjects(this.FadeHolder_mc.Positive, this.FadeHolder_mc.Negative, this.FadeHolder_mc.Neutral, this.FadeHolder_mc.Question, this.FadeHolder_mc.SpeechChallengeAnim_mc);
            var _local_1:uint;
            while (_local_1 < this.Buttons.length)
            {
                this.Buttons[_local_1].ButtonHintData = this.ButtonData[_local_1];
                _local_1++;
            };
        }

        public function SetButtonText(_arg_1:uint, _arg_2:String):*
        {
            this.ButtonData[_arg_1].ButtonText = _arg_2;
         //   if (((!(this.visible)) && (_arg_1 == 3)))
		    if (_arg_1 == 3)
            {
                this.visible = true;
				var _local_1:uint;
				var temparray: Array = new Array();
				while (_local_1 < this.Buttons.length)
				{
					//root.atrace(String(_arg_1)+": "+_arg_2);
					//root.atrace(String(_local_1)+": "+this.ButtonData[_local_1].ButtonText);
					temparray.push({"text":this.ButtonData[_local_1].ButtonText,"filterFlag":Math.pow(2,_local_1)}); // 1 2 4 8
					_local_1++;
				};
			root.filltestlist(temparray);
            };

        }

        public function ShowButtonHelp():*
        {
            var _local_1:Number = 0;
            while (((!(this._ButtonsShown)) && (_local_1 < this.Buttons.length)))
            {
                this.Buttons[_local_1].bButtonPressed = false;
                this.ButtonAnimators[_local_1].gotoAndPlay("showButton");
                _local_1++;
            };
            this._ButtonsShown = true;
        }

        public function HideButtonHelp():*
        {
            var _local_1:Number = 0;
            while (((this._ButtonsShown) && (_local_1 < this.ButtonAnimators.length)))
            {
                if (_local_1 == this.LastPressedButtonIndex)
                {
                    this.Buttons[_local_1].bButtonPressed = true;
                    this.ButtonAnimators[_local_1].gotoAndPlay("slowHideButton");
                }
                else
                {
                    this.ButtonAnimators[_local_1].gotoAndPlay("hideButton");
                };
                _local_1++;
            };
            this._ButtonsShown = false;
        }

        public function EnableMenu():*
        {
            gotoAndPlay("showMenu");
        }

        public function DisableMenu():*
        {
            gotoAndPlay("hideMenu");
        }

        private function onPositivePress():*
        {
            this.onButtonPress(0);
        }

        private function onNegativePress():*
        {
            this.onButtonPress(1);
        }

        private function onNeutralPress():*
        {
            this.onButtonPress(2);
        }

        private function onQuestionPress():*
        {
            this.onButtonPress(3);
        }

        private function onPositiveRelease():*
        {
            this.onButtonRelease(0);
        }

        private function onNegativeRelease():*
        {
            this.onButtonRelease(1);
        }

        private function onNeutralRelease():*
        {
            this.onButtonRelease(2);
        }

        private function onQuestionRelease():*
        {
            this.onButtonRelease(3);
        }

        public function ProcessUserEvent(_arg_1:String, _arg_2:Boolean):Boolean
        {

		root.atrace(_arg_1+" "+(_arg_2 ? "pressed" : "released"));
		return;
            var _local_3:Boolean;
            if (this._ButtonsShown)
            {
                _local_3 = true;
                if (_arg_1 == "MultiActivateA")
                {
                    if (_arg_2)
                    {
                        this.onPositivePress();
                    }
                    else
                    {
                        this.onPositiveRelease();
                    };
                }
                else
                {
                    if (_arg_1 == "MultiActivateB")
                    {
                        if (_arg_2)
                        {
                            this.onNegativePress();
                        }
                        else
                        {
                            this.onNegativeRelease();
                        };
                    }
                    else
                    {
                        if (_arg_1 == "MultiActivateX")
                        {
                            if (_arg_2)
                            {
                                this.onNeutralPress();
                            }
                            else
                            {
                                this.onNeutralRelease();
                            };
                        }
                        else
                        {
                            if (_arg_1 == "MultiActivateY")
                            {
                                if (_arg_2)
                                {
                                    this.onQuestionPress();
                                }
                                else
                                {
                                    this.onQuestionRelease();
                                };
                            }
                            else
                            {
                                _local_3 = false;
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        private function onButtonPress(_arg_1:uint):*
        {
            if (_arg_1 < this.Buttons.length)
            {
                this.Buttons[_arg_1].bButtonPressed = true;
            };
        }

        private function onButtonRelease(_arg_1:uint):*
        {
		root.atrace("onButtonRelease "+String(_arg_1));
            if (_arg_1 < this.Buttons.length)
            {
                this.LastPressedButtonIndex = _arg_1;
                this.Buttons[_arg_1].bButtonPressed = false;
                this.BGSCodeObj.onButtonRelease(_arg_1);
            };
        }

        public function PlaySpeechChallengeAnim():*
        {
            this.FadeHolder_mc.SpeechChallengeAnim_mc.gotoAndPlay("startAnim");
        }

        public function OnSpeechChallengeAnimComplete():*
        {
            this.BGSCodeObj.OnSpeechChallengeAnimComplete();
        }

        internal function frame1():*
        {
            stop();
        }

        internal function frame5():*
        {
            stop();
        }


    }
}//package 

