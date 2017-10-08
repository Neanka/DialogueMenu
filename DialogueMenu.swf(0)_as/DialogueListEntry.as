package {
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gx.TextFieldEx;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	import flash.events.*;
	import flash.ui.*;
	import flash.geom.*;

	public class DialogueListEntry extends BSScrollingListEntry {
		
		private static const DLG_ICON_BARTER:int = 1;
		private static const DLG_ICON_EXIT:int = 2;
		private static const DLG_ICON_QUEST:int = 3;
		private static const DLG_ICON_QUEST_IN_PROGRESS:int = 4;
		
		private static const DLG_ICON_SPEECH:int = 4000;
		
		public var icon_placeholder: MovieClip;
		public function DialogueListEntry() {
		icon_placeholder = new MovieClip();
		icon_placeholder.x = 5;
		icon_placeholder.y = 5;
		addChild(icon_placeholder);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField, "fit");
		}

		override public function SetEntryText(_arg_1: Object, _arg_2: String) {
			super.SetEntryText(_arg_1, _arg_2);
			if (_arg_1.qTextColor) {this.textField.textColor = uint(_arg_1.qTextColor);} else {this.textField.textColor = uint(16777215);}
         var _loc3_:ColorTransform = this.border.transform.colorTransform;
		 if (_arg_1.qBorderColor) {_loc3_.color = uint(_arg_1.qBorderColor);} else {_loc3_.color = uint(16777215);}
         this.border.transform.colorTransform = _loc3_;
			if (_arg_1.type == 1) {
				this.textField.text = this.textField.text.replace(/\$\$val/, "< "+String(_arg_1.val)+" >");
			}
			var icon:MovieClip;
			
			if (icon_placeholder.numChildren >0){
			icon_placeholder.removeChildAt(0);
			}
			if (_arg_1.challengeLevel > 0 && _arg_1.challengeResult>-1) 
			{
				icon = new icon_speech();
			}
			else
			{
				switch (_arg_1.icon) {
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
				}
			}
			if (icon) {
			icon_placeholder.addChild(icon);
			_loc3_.alphaMultiplier = 1;
			icon_placeholder.transform.colorTransform = _loc3_;
			}

		}

	}
} //package