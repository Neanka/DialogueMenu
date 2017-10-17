package DialogueMenu_fla
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.*;
	import debug.Log;
	import Shared.AS3.BSScrollingList;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.getQualifiedClassName;
	import myShared;
	
	public dynamic class MainTimeline extends flash.display.MovieClip
	{
		private var debugmode:Boolean = false;
		public var List_mc:DialogueList;
		public var name_tf:TextField;
		public var quest_tf:TextField;
		public var dtf:TextField;
		
		public var oldSubtitlesX:Number;
		public var oldSubtitlesY:Number;
		public var newSubtitlesX:Number;
		public var newSubtitlesY:Number;
		
		public static const F4SE_INITIALIZED:String = "F4SE::Initialized";
		private static var _instance:MainTimeline;
		
		public var f4seinit:Boolean = false
		public var xdiinit:Boolean = false;
		
		public var Menu_mc:DialogueMenu;
		public var EM_mc:errormessage;
		
		public function MainTimeline()
		{
			Log.info("constructor starting")
			MainTimeline._instance = this;
			this.addEventListener(F4SE_INITIALIZED, this.initialized);
			this.List_mc.alpha = 0;
			this.name_tf.alpha = 0;
			this.List_mc.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp1);
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS, this.onItemPress);
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE, this.onSelectionChange);
			if (stage)
			{
				this.init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, this.init);
			}
			super();
			this.setprops();
			return;
		}
		
		public function onKeyUp1(event:KeyboardEvent){
			if (!this.List_mc.disableInput){
				switch (event.keyCode) {
				case Keyboard.W:
					this.List_mc.moveSelectionUp();
					event.stopPropagation();
					return;
				case Keyboard.S:
					this.List_mc.moveSelectionDown();
					event.stopPropagation();
					return;
				case Keyboard.A:
				case Keyboard.LEFT:
					this.listmcspindown();
					event.stopPropagation();
					return;
				case Keyboard.D:
				case Keyboard.RIGHT:
					this.listmcspinup();
					event.stopPropagation();
					return;
				}
				if (event.keyCode>=Keyboard.NUMBER_1 && event.keyCode <= Keyboard.NUMBER_9 && myShared.enableNumbersHotkeys) 
				{
					var num: int = event.keyCode - Keyboard.NUMBER_1;
					atrace("button: " + String(num+1) + " pressed");
					itemPressed(num);
				}
			};
		}
		
		public function listmcspinup():*
		{
			//atrace("listmcspinup");
			if (this.List_mc.selectedEntry.type == 1)
			{
				//atrace("checking passed");
				if (this.List_mc.selectedEntry.val < this.List_mc.selectedEntry.maxval)
				{
					//atrace("val<maxval");
					this.List_mc.selectedEntry.val += this.List_mc.selectedEntry.step;
					this.List_mc.UpdateList()
				}
			}
		}
		
		public function listmcspindown():*
		{
			if (this.List_mc.selectedEntry.type == 1)
			{
				if (this.List_mc.selectedEntry.val > this.List_mc.selectedEntry.minval)
				{
					this.List_mc.selectedEntry.val -= this.List_mc.selectedEntry.step;
					this.List_mc.UpdateList()
				}
			}
		}
		
		function listprocedures():*
		{			
			this.List_mc.InvalidateData();
			if (this.List_mc.entryList.length > 5 || this.List_mc.sa1.visible)
			{
				this.List_mc.brackets.height = 21 + 6 * 36;
			}
			else
			{
				this.List_mc.brackets.height = this.List_mc.shownItemsHeight + 26.7; // TODO probably should be tuned
					//this.List_mc.brackets.height = 21+this.List_mc.entryList.length*36;
			}
			
			this.List_mc.UpdateList();
			this.List_mc.selectedIndex = this.List_mc.GetEntryFromClipIndex(0);
			stage.focus = this.List_mc;
		}
		
		public function filltestlist(ar:Array):*
		{
			this.List_mc.ClearList();
			this.List_mc.entryList = ar;
			listprocedures();
			return;
		}
		
		public function onItemPress(_arg_1:Event)
		{
			itemPressed(this.List_mc.selectedIndex);
		}
		
		public function itemPressed(id: int):void 
		{
			//atrace("itemlist with OptionID: " + String(this.List_mc.entryList[id]["optionID"]) + " pressed");
			if (this.List_mc.entryList[id].type == 1) 
			{
				Menu_mc.BGSCodeObj.SetXDIResult(Number(this.List_mc.entryList[id].val));
			}
			if (this.List_mc.entryList[id]["CallbackID"] != "none")
			{
				root.f4se.SendExternalEvent("Dialogue::OptionReturned", String(this.List_mc.entryList[id].CallbackID), int(this.List_mc.entryList[id].val));
				//atrace("send event: Dialogue::OptionReturned, " + String(this.List_mc.entryList[id].CallbackID) + ", " + String(this.List_mc.entryList[id].val));
			}
			listToggle(false);
			if (myShared.isFrameworkActive)
			{
				Menu_mc.BGSCodeObj.SelectDialogueOption(this.List_mc.entryList[id]["optionID"]);
			}
			else
			{
				Menu_mc.onButtonRelease(this.List_mc.entryList[id]["optionID"]);
			}
		}

		
		public function listToggle(state:Boolean)
		{
			TweenLite.to(List_mc, 0.5, {alpha: (state ? 1 : 0)});
			TweenLite.to(name_tf, 0.5, {alpha: (state ? 1 : 0)});
			TweenMax.delayedCall(0.5, Menu_mc.BGSCodeObj.SetWheelZoomEnabled, [!state]);
			TweenMax.delayedCall(0.5, Menu_mc.BGSCodeObj.SetFavoritesEnabled, [!state]);
			this.List_mc.disableInput = !state;
			this.List_mc.disableSelection = !state;
			Menu_mc.BGSCodeObj.SetSubtitlePosition(state ? newSubtitlesX : oldSubtitlesX, state ? newSubtitlesY : oldSubtitlesY);
			//atrace("subtitles moved");
			//atrace(String(Menu_mc.BGSCodeObj.GetSubtitlePosition()[0]) + " " + String(Menu_mc.BGSCodeObj.GetSubtitlePosition()[1]));
		
		}
		
		private function traceObj(obj:Object):void
		{
			for (var id:String in obj)
			{
				var value:Object = obj[id];
				
				if (getQualifiedClassName(value) == "Object")
				{
					trace("-->");
					traceObj(value);
				}
				else
				{
					trace(id + " = " + value);
				}
			}
		}
		
		private function onSelectionChange(_arg_1:Event)
		{
			Menu_mc.BGSCodeObj.SetMovementEnabled(this.List_mc.selectedEntry.type != 1);
			//atrace("itemlist with OptionID: " + String(this.List_mc.selectedEntry["optionID"]) + " selected");
		}
		
		function setprops()
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			;
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "DialogueListEntry";
			this.List_mc.numListItems = 6;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "Multi-Line";
			this.List_mc.verticalSpacing = -4.25;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
			}
			catch (e:Error)
			{
			}
			;
		}
		
		public function atrace(param1:String):*
		{
			if (!debugmode)
			{
				return
			}
			;
			dtf.appendText(param1 + "\n");
			trace(param1);
			dtf.scrollV = dtf.maxScrollV;
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.init);
		
		}
		
		public static function get instance():MainTimeline
		{
			return _instance;
		}
		
		public function XDI_Init():*
		{
			xdiinit = true;
		}
		
		private function initialized(e:Event):void
		{
			removeEventListener(F4SE_INITIALIZED, this.initialized);
			Log.info("f4se initialized");
			f4seinit = true;
			stage.dispatchEvent(new Event(F4SE_INITIALIZED));
			
			oldSubtitlesX = Menu_mc.BGSCodeObj.GetSubtitlePosition()[0];
			oldSubtitlesY = Menu_mc.BGSCodeObj.GetSubtitlePosition()[1];
			newSubtitlesX = Number(Menu_mc.BGSCodeObj.GetModSetting("fSubtitlesX:DialogueMenu"));
			newSubtitlesY = Number(Menu_mc.BGSCodeObj.GetModSetting("fSubtitlesY:DialogueMenu"));
			debugmode = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bEnable:Debug"));
			myShared.fittext = !Boolean(Menu_mc.BGSCodeObj.GetModSetting("bWrapText:DialogueMenu"));
			myShared.dimming = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bDimSpokenOptions:DialogueMenu"));
			myShared.showQuestionIcon = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bShowQuestionIcon:DialogueMenu"));
			myShared.showNumbers = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bShowOptionNumbers:DialogueMenu"));
			myShared.enableNumbersHotkeys = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bEnableOptionHotkeys:DialogueMenu"));
			this.List_mc.brackets.bShowBrackets = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bShowBrackets:DialogueMenu"))
			this.List_mc.brackets.getChildAt(0).visible = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bShowShadedBackground:DialogueMenu"))
			myShared.showIcons = Boolean(Menu_mc.BGSCodeObj.GetModSetting("bShowIcons:DialogueMenu"));
			//ct_green: ColorTransform;
			myShared.ct_yellow = new ColorTransform(0.9411765336990356, 1, 0.2235294282436371);
			myShared.ct_orange = new ColorTransform(0.9411765336990356, 0.6431372761726379, 0.08627451211214066);
			myShared.ct_red = new ColorTransform(0.9333333969116211, 0.3372549116611481, 0.2156862914562225);
			myShared.ct_white = new ColorTransform();
			var r:int = int(Menu_mc.BGSCodeObj.GetINISetting("iHUDColorR:Interface"));
			var g:int = int(Menu_mc.BGSCodeObj.GetINISetting("iHUDColorG:Interface"));
			var b:int = int(Menu_mc.BGSCodeObj.GetINISetting("iHUDColorB:Interface"));
			myShared.ct_UI_color = new ColorTransform(r / 255, g / 255, b / 255);
			this.List_mc.brackets.transform.colorTransform = myShared.ct_UI_color;
			this.List_mc.sa1.transform.colorTransform = myShared.ct_UI_color;
		}
	}
}