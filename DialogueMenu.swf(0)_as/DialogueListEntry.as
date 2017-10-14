package
{
	import DialogueMenu_fla.MainTimeline;
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	import flash.events.*;
	import flash.ui.*;
	import flash.geom.*;
	import myShared;
	
	public class DialogueListEntry extends BSScrollingListEntry
	{
		private static const DLG_ICON_BARTER:int = 1;
		private static const DLG_ICON_EXIT:int = 2;
		private static const DLG_ICON_QUEST:int = 3;
		private static const DLG_ICON_QUEST_IN_PROGRESS:int = 4;
		private static const DLG_ICON_SPEECH:int = 5;
		private static const DLG_ICON_LOOP:int = 6;
		private static const DLG_ICON_QUESTION_BUBBLE:int = 7;
		private static const DLG_ICON_BACK:int = 8;
		private static const DLG_ICON_INV:int = 9;
		
		public var icon_placeholder:MovieClip;
		
		public function DialogueListEntry()
		{
			icon_placeholder = new MovieClip();
			icon_placeholder.x = 5;
			icon_placeholder.y = 5;
			addChild(icon_placeholder);
			Extensions.enabled = true;
		}
		
		override public function SetEntryText(_arg_1:Object, _arg_2:String)
		{
			super.SetEntryText(_arg_1, _arg_2);
			//set options numbers
			if (myShared.showNumbers)
			{
				GlobalFunc.SetText(this.textField, String(_arg_1.num + 1) + ". " + _arg_1.text, true);
			}
			//set text color
			if (_arg_1.iTextColor < 80000000)
			{
				this.textField.textColor = uint(_arg_1.iTextColor);
			}
			else
			{
				this.textField.textColor = myShared.getColor(myShared.ct_UI_color);
			}
			//set border color
			var borderCT:ColorTransform;
			if (_arg_1.iBorderColor < 80000000)
			{
				borderCT = myShared.getCT(_arg_1.iBorderColor);
			}
			else
			{
				borderCT = myShared.ct_UI_color;
			}
			this.border.transform.colorTransform = borderCT;
			this.border.alpha = this.selected ? 1 : 0;
			//set option type
			if (_arg_1.type == 1)
			{
				this.textField.text = this.textField.text.replace(/\$\$val/, "< " + String(_arg_1.val) + " >");
			}
			//clean icon placeholder
			var icon:MovieClip;
			if (icon_placeholder.numChildren > 0)
			{
				icon_placeholder.removeChildAt(0);
			}
			if (_arg_1.icon != 0)
			{
				if (myShared.showIcons)
				{
					if (_arg_1.icon != 80000000)
					{
						switch (_arg_1.icon)
						{
						case DLG_ICON_BARTER: 
							icon = new icon_barter();
							break;
						case DLG_ICON_EXIT: 
							icon = new icon_exit();
							break;
						case DLG_ICON_QUEST: 
							icon = new icon_quest();
							break;
						case DLG_ICON_QUEST_IN_PROGRESS: 
							icon = new icon_quest_in_progress();
							break;
						case DLG_ICON_SPEECH: 
							icon = new icon_speech();
							break;
						case DLG_ICON_LOOP: 
							icon = new icon_loop();
							break;
						case DLG_ICON_QUESTION_BUBBLE: 
							icon = new icon_question_bubble();
							break;
						case DLG_ICON_BACK: 
							icon = new icon_back();
							break;
						case DLG_ICON_INV: 
							icon = new icon_inv();
							break;
						}
					}
					else if (_arg_1.challengeLevel > 0 && _arg_1.challengeResult == -1)
					{
						icon = new icon_speech();
					}
					else if (_arg_1.isBarterOption)
					{
						icon = new icon_barter();
					}
					else if (_arg_1.isInventoryOption)
					{
						icon = new icon_inv();
					}
					else if (_arg_1.endsScene)
					{
						icon = new icon_exit();
					}
					else if (_arg_1.linkedToSelf && myShared.showQuestionIcon)
					{
						icon = new icon_question_bubble();
					}
					else
					{
						
					}
				}
				else
				{
					if (_arg_1.challengeLevel > 0 && _arg_1.challengeResult == -1)
					{
						icon = new icon_speech();
					}
				}
			}

			
			//set icon color
			if (icon)
			{
				var iconCT:ColorTransform;
				if (_arg_1.challengeLevel > 0 && _arg_1.challengeResult == -1)
				{
					switch (_arg_1.challengeLevel)
					{
					case 1: 
					case 5: 
						iconCT = myShared.ct_yellow;
						break;
					case 2: 
					case 6: 
						iconCT = myShared.ct_orange;
						break;
					case 3: 
					case 7: 
						iconCT = myShared.ct_red;
						break;
					default: 
						iconCT = myShared.ct_UI_color;
					}
				}
				else if (_arg_1.iIconColor < 80000000)
				{
					iconCT = myShared.getCT(_arg_1.iIconColor);
				}
				else
				{
					iconCT = myShared.ct_UI_color;
				}
				icon_placeholder.addChild(icon);
				icon.transform.colorTransform = iconCT;
			}
			// fit text
			if (myShared.fittext)
			{
				TextFieldEx.setTextAutoSize(textField, "shrink");
			}
			else
			{
				textField.multiline = true;
				textField.wordWrap = true;
				textField.autoSize = "left";
				textField.height = textField.textHeight + 4;
				border.height = textField.height;
			}
			if (myShared.dimming)
			{
				this.textField.alpha = _arg_1.said ? 0.6 : 1;
				icon_placeholder.alpha = _arg_1.said ? 0.6 : 1;
			}
		}
	}
} //package