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
	import myShared;
	
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
			if (!MainTimeline.instance.f4seinit) 
			{
				MainTimeline.instance.EM_mc.visible = true;
				MainTimeline.instance.EM_mc.t_tf.text="F4SE Status: FAIL\n\nF4SE is not running. Make sure that F4SE is installed and that you have launched the game with f4se_loader.exe.";
				this.visible = true;
			}
			else if (!this.BGSCodeObj.IsFrameworkActive)
			{
				MainTimeline.instance.EM_mc.visible = true;
				MainTimeline.instance.EM_mc.t_tf.text="F4SE Status: OK\nXDI Status: FAIL\n\nXDI is not running. Make sure that XDI.dll is in your Data\\F4SE\\Plugins directory.";
				this.visible = true;
			}
		}
		
		public function SetButtonText(_arg_1:uint, _arg_2:String):*
		{
			this.ButtonData[_arg_1].ButtonText = _arg_2;
			//MainTimeline.instance.atrace(String(this.visible)+" "+String(_arg_1));
			if (myShared.menuStatus && _arg_1 == 3)
				//if (_arg_1 == 3)
			{
				root.name_tf.text = this.BGSCodeObj.GetTargetName();
				var dlgf:Boolean = this.BGSCodeObj.IsFrameworkActive();
				var temparr:Array = this.BGSCodeObj.GetDialogueOptions();
				MainTimeline.instance.atrace("<font color=\"#00FF00\">got options</font>");
				//traceObj(temparr);
				this.visible = true;
				myShared.menuStatus = false;
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
				var sCallbackID:String;
				//{"Type":0,"Val":0,"MinVal":0,"MaxVal":0,"TextColor":80000000,"BorderColor":80000000,"Icon":80000000,"IconColor":80000000,"CallbackID":"none"}
				//
				//
				while (counter < temparr.length)
				{
					//MainTimeline.instance.atrace("linkedToSelf "+ String(temparr[counter].linkedToSelf));
					iType = 0;
					iVal = 0;
					iMinVal = 0;
					iMaxVal = 0;
					iTextColor = 80000000;
					iBorderColor = 80000000;
					iIconColor = 80000000;
					iIcon = 80000000;
					sCallbackID = "none";
					if (temparr[counter].response != "" && temparr[counter].enabled)
					{
						if (temparr[counter].prompt.charAt(0) == "{")
						{
							try
							{
								dataObj = com.adobe.serialization.json.JSON.decode(temparr[counter].prompt) as Object;
								if (dataObj.hasOwnProperty("Type"))
								{
									iType = int(dataObj.Type)
								}
								if (dataObj.hasOwnProperty("Val"))
								{
									iVal = int(dataObj.Val)
								}
								if (dataObj.hasOwnProperty("MinVal"))
								{
									iMinVal = int(dataObj.MinVal)
								}
								if (dataObj.hasOwnProperty("MaxVal"))
								{
									iMaxVal = int(dataObj.MaxVal)
								}
								if (dataObj.hasOwnProperty("TextColor"))
								{
									iTextColor = int(dataObj.TextColor)
								}
								if (dataObj.hasOwnProperty("BorderColor"))
								{
									iBorderColor = int(dataObj.BorderColor)
								}
								if (dataObj.hasOwnProperty("IconColor"))
								{
									iIconColor = int(dataObj.IconColor)
								}
								if (dataObj.hasOwnProperty("Icon"))
								{
									iIcon = int(dataObj.Icon)
								}
								if (dataObj.hasOwnProperty("CallbackID"))
								{
									sCallbackID = String(dataObj.CallbackID)
								}
							}
							catch (err:Error)
							{
								trace("ERROR JSON PARSING")
							}
						}
						temparray.push({"text": temparr[counter].response, "dlgf": dlgf, "optionID": temparr[counter].optionID, "challengeLevel": temparr[counter].challengeLevel, "challengeResult": temparr[counter].challengeResult, "linkedToSelf": temparr[counter].linkedToSelf, "said": temparr[counter].said, "endsScene": temparr[counter].endsScene, "type": iType, "val": iVal, "minval": iMinVal, "maxval": iMaxVal, "iTextColor": iTextColor, "iBorderColor": iBorderColor, "iIconColor": iIconColor, "icon": iIcon, "CallbackID": sCallbackID});
					}
					counter++;
				}
				root.filltestlist(temparray);
			}
			else if (!myShared.menuStatus && _arg_1 == 3)
			{
				myShared.menuStatus = true;
			}
		}
		
		private function traceObj(obj:Object):void
		{
			for (var id:String in obj)
			{
				var value:Object = obj[id];
				
				if (getQualifiedClassName(value) == "Object")
				{
					root.atrace("-->");
					//trace("-->");
					traceObj(value);
				}
				else
				{
					root.atrace(String(id) + " = " + String(value));
						//trace(id + " = " + value);
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
			MainTimeline.instance.atrace("<b>showMenu</b>");
			MainTimeline.instance.List_mc.visible = true;
			MainTimeline.instance.name_tf.visible = true;
		}
		
		public function DisableMenu():*
		{
			gotoAndPlay("hideMenu");
			MainTimeline.instance.atrace("<b>hideMenu</b>");
			MainTimeline.instance.List_mc.visible = false;
			MainTimeline.instance.name_tf.visible = false;
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
			if (!_arg_2)
			{
				if (MainTimeline.instance.List_mc.alpha != 0) 
				{
					switch (_arg_1)
					{
					case "MultiActivateA": 
						if (uiPlatform != 0) 
						{
							MainTimeline.instance.onItemPress(null);
							return true;
						}
						break;
					default:
						return false;
					}
				}
				else 
				{
					return false;
				}
			}
			root.atrace(_arg_1 + " " + (_arg_2 ? "pressed" : "released"));
			switch (_arg_1)
			{
			case "Forward": 
			case "QuickkeyUp": 
				MainTimeline.instance.List_mc.moveSelectionUp();
				break;
			case "Back": 
			case "QuickkeyDown": 
				MainTimeline.instance.List_mc.moveSelectionDown();
				break;
			case "StrafeLeft": 
			case "QuickkeyLeft": 
				MainTimeline.instance.listmcspindown();
				break;
			case "StrafeRight": 
			case "QuickkeyRight": 
				MainTimeline.instance.listmcspinup();
				break;
			default: 
			}
			return true;
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

