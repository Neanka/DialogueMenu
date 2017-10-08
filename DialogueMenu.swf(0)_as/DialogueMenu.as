// Decompiled by AS3 Sorcerer 4.99
// www.as3sorcerer.com

//DialogueMenu

package
{
	import DialogueMenu_fla.MainTimeline;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import __AS3__.vec.Vector;
	import Shared.AS3.BSButtonHint;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import __AS3__.vec.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import com.adobe.serialization.json.*;
	
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
		private var mainColor:int = 16777215;
		
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
			}
			;
		}
		
		public function SetButtonText(_arg_1:uint, _arg_2:String):*
		{
			this.ButtonData[_arg_1].ButtonText = _arg_2;
			//   if (((!(this.visible)) && (_arg_1 == 3)))
			if (_arg_1 == 3)
			{
				root.name_tf.text = this.BGSCodeObj.GetTargetName();
				//trace(this.FadeHolder_mc.getChildAt(0).transform.colorTransform);
				//trace(this.FadeHolder_mc.getChildAt(1).transform.colorTransform);
				//trace(this.FadeHolder_mc.getChildAt(2).transform.colorTransform);
				//trace(this.FadeHolder_mc.getChildAt(3).transform.colorTransform);
				//var defColors:Array = new Array();
				//defColors.push(getColor(this.FadeHolder_mc.getChildAt(0).transform.colorTransform));
				//defColors.push(getColor(this.FadeHolder_mc.getChildAt(3).transform.colorTransform));
				//defColors.push(getColor(this.FadeHolder_mc.getChildAt(2).transform.colorTransform));
				//defColors.push(getColor(this.FadeHolder_mc.getChildAt(1).transform.colorTransform));
				mainColor = getColor(this.FadeHolder_mc.getChildAt(4).transform.colorTransform);
				root.List_mc.brackets.transform.colorTransform = this.FadeHolder_mc.getChildAt(4).transform.colorTransform;
				//root.List_mc.sa1.transform.colorTransform = this.FadeHolder_mc.getChildAt(4).transform.colorTransform;
				var dlgf:Boolean = this.BGSCodeObj.IsFrameworkActive();
				var temparr:Array = this.BGSCodeObj.GetDialogueOptions();
				traceObj(temparr);
				this.visible = true;
				MainTimeline.instance.listToggle(true);
				var counter:uint = 0;
				var temparray:Array = new Array();
				var dataObj:Object = new Object();
				var iType:int;
				var iVal:int;
				var iMinVal:int;
				var iMaxVal:int;
				var iTextColor:int;
				var iBorderColor:int;
				var iIconColor:int;
				var iIcon:int;
				//{"aiType":0,"aiVal":0,"aiMinVal":0,"aiMaxVal":0,"aiTextColor":16777215,"aiBorderColor":16777215,"aiIcon":0}
				//
				//"iIconColor":16777215
				while (counter < temparr.length)
				{
					iType = 0;
					iVal = 0;
					iMinVal = 0;
					iMaxVal = 0;
					iTextColor = mainColor;
					iBorderColor = mainColor;
					iIconColor = mainColor;
					iIcon = 0;
					if (temparr[counter].response != "" && temparr[counter].enabled)
					{
						//if (!dlgf && counter < defColors.length)
						//{
						//	iTextColor = defColors[counter];
						//	iBorderColor = iTextColor;
						//}
						if (temparr[counter].prompt.charAt(0) == "{")
						{
							try
							{
								dataObj = com.adobe.serialization.json.JSON.decode(temparr[counter].prompt) as Object;
								if (dataObj.hasOwnProperty("aiType"))
								{
									iType = int(dataObj.aiType)
								}
								if (dataObj.hasOwnProperty("aiVal"))
								{
									iVal = int(dataObj.aiVal)
								}
								if (dataObj.hasOwnProperty("aiMinVal"))
								{
									iMinVal = int(dataObj.aiMinVal)
								}
								if (dataObj.hasOwnProperty("aiMaxVal"))
								{
									iMaxVal = int(dataObj.aiMaxVal)
								}
								if (dataObj.hasOwnProperty("aiTextColor"))
								{
									iTextColor = int(dataObj.aiTextColor)
								}
								if (dataObj.hasOwnProperty("aiBorderColor"))
								{
									iBorderColor = int(dataObj.aiBorderColor)
								}
								if (dataObj.hasOwnProperty("aiIconColor"))
								{
									iIconColor = int(dataObj.aiIconColor)
								}
								if (dataObj.hasOwnProperty("aiIcon"))
								{
									iIcon = int(dataObj.aiIcon)
								}
							}
							catch (err:Error)
							{
								trace("ERROR JSON PARSING")
							}
						}
						temparray.push({"text": temparr[counter].response, "dlgf": dlgf, "optionID": temparr[counter].optionID, "challengeLevel": temparr[counter].challengeLevel, "challengeResult": temparr[counter].challengeResult, "type": iType, "val": iVal, "minval": iMinVal, "maxval": iMaxVal, "qTextColor": iTextColor, "qBorderColor": iBorderColor, "qIconColor": iIconColor, "icon": iIcon});
					}
					counter++;
				}
				root.filltestlist(temparray);
			}
		}
		
		private function getColor(tempMainCT:ColorTransform):int
		{
			return int(256 * 256 * 255 * tempMainCT.redMultiplier) + int(256 * 255 * tempMainCT.greenMultiplier) + int(255 * tempMainCT.blueMultiplier);
		}
		
		private function traceObj(obj:Object):void
		{
			for (var id:String in obj)
			{
				var value:Object = obj[id];
				
				if (getQualifiedClassName(value) == "Object")
				{
					root.atrace("-->");
					trace("-->");
					traceObj(value);
				}
				else
				{
					root.atrace(String(id) + " = " + String(value));
					trace(id + " = " + value);
				}
			}
		}
		
		public function ShowButtonHelp():*
		{
			var _local_1:Number = 0;
			while (((!(this._ButtonsShown)) && (_local_1 < this.Buttons.length)))
			{
				this.Buttons[_local_1].bButtonPressed = false;
				this.ButtonAnimators[_local_1].gotoAndPlay("showButton");
				_local_1++;
			}
			;
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
				}
				;
				_local_1++;
			}
			;
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
			
			root.atrace(_arg_1 + " " + (_arg_2 ? "pressed" : "released"));
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
					}
					;
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
						}
						;
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
							}
							;
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
								}
								;
							}
							else
							{
								_local_3 = false;
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
			return (_local_3);
		}
		
		private function onButtonPress(_arg_1:uint):*
		{
			if (_arg_1 < this.Buttons.length)
			{
				this.Buttons[_arg_1].bButtonPressed = true;
			}
			;
		}
		
		private function onButtonRelease(_arg_1:uint):*
		{
			root.atrace("onButtonRelease " + String(_arg_1));
			if (_arg_1 < this.Buttons.length)
			{
				this.LastPressedButtonIndex = _arg_1;
				this.Buttons[_arg_1].bButtonPressed = false;
				this.BGSCodeObj.onButtonRelease(_arg_1);
			}
			;
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

