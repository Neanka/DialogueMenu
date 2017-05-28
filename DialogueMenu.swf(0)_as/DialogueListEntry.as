package {
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	import flash.events.*;
	import flash.ui.*;
	import flash.geom.*;

	public class DialogueListEntry extends BSScrollingListEntry {
		public function DialogueListEntry() {
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField, "shrink");
		}

		override public function SetEntryText(_arg_1: Object, _arg_2: String) {
			super.SetEntryText(_arg_1, _arg_2);
			if (_arg_1.qTextColor) {this.textField.textColor = uint(_arg_1.qTextColor);} else {this.textField.textColor = uint(16777215);}
         var _loc3_:ColorTransform = this.border.transform.colorTransform;
		 if (_arg_1.qBorderColor) {_loc3_.color = uint(_arg_1.qBorderColor);} else {_loc3_.color = uint(16777215);}
         this.border.transform.colorTransform = _loc3_;
			if (_arg_1.type == 1) {
				this.textField.text = this.textField.text.replace(/\$\$val/, "< "+String(_arg_1.val)+" >");
			} else {
			}


		}

	}
} //package