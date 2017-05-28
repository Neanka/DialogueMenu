package DialogueMenu_fla {
	import flash.display.MovieClip;
	import flash.events.*;
	import debug.Log;
	import Shared.AS3.BSScrollingList;
	import flash.text.TextField;
	import flash.events.*;
	import flash.ui.*;

	public dynamic
	class MainTimeline extends flash.display.MovieClip {
		private var debugmode: Boolean = false;
		public var List_mc: DialogueList;
		public var name_tf: TextField;
		public var dtf: TextField;
		private var _datarecieved: Boolean = false;
		private var _originalfilled: Boolean = false;
		public var customentries: Array = new Array();
		public var scenename: String = "None";
		

		public static const F4SE_INITIALIZED: String = "F4SE::Initialized";
		private static var _instance: MainTimeline;

		public var f4seinit: Boolean = false;

		public var Menu_mc: DialogueMenu;


		public function MainTimeline() {
			this.setprops();
			Log.info("constructor starting")
			MainTimeline._instance = this;
			this.addEventListener(F4SE_INITIALIZED, this.initialized);
			this.List_mc.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown1);
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS, this.onItemPress);
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE, this.onSelectionChange);
			if (stage) {
				this.init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, this.init);
			}
			super();
			return;
		}
		public function onKeyDown1(event:KeyboardEvent){
			if (!this.bDisableInput){
			switch (event.keyCode) {
			case Keyboard.W:
				this.List_mc.moveSelectionUp();
				event.stopPropagation();
				break;
			case Keyboard.S:
				this.List_mc.moveSelectionDown();
				event.stopPropagation();
				break;
			case Keyboard.A:
			case Keyboard.LEFT:
				this.listmcspindown();
				event.stopPropagation();
				break;
			case Keyboard.D:
			case Keyboard.RIGHT:
				this.listmcspinup();
				event.stopPropagation();
				break;
			}
			};
		}
		
		private function listmcspinup():*{
			if (this.List_mc.selectedEntry.type == 1){
				if (this.List_mc.selectedEntry.val < this.List_mc.selectedEntry.maxval){
				this.List_mc.selectedEntry.val +=1;
				this.List_mc.UpdateList()
				}
			}
		}
		private function listmcspindown():*{
			if (this.List_mc.selectedEntry.type == 1){
				if (this.List_mc.selectedEntry.val > this.List_mc.selectedEntry.minval){
				this.List_mc.selectedEntry.val -=1;
				this.List_mc.UpdateList()
				}
			}
		}
		
		public function customentriesrecieved(): void {
		trace("PAPYRUS DATA RECIEVED");
			if (!_datarecieved){
				var tempar: Array = this.List_mc.entryList;
			var i: int = 0;
			for each(var obj in customentries){
			trace(String(obj["__var__"]["__struct__"]["__data__"]["sScene"]));
			trace(String(obj["__var__"]["__struct__"]["__data__"]["qtext"]));
			trace(int(obj["__var__"]["__struct__"]["__data__"]["iFilterFlag"]));
				tempar.push({
					"scene": String(obj["__var__"]["__struct__"]["__data__"]["sScene"]),
					"text": String(obj["__var__"]["__struct__"]["__data__"]["qtext"]),
					"filterFlag": int(obj["__var__"]["__struct__"]["__data__"]["iFilterFlag"]),
					"type": int(obj["__var__"]["__struct__"]["__data__"]["qType"]),
					"val": int(obj["__var__"]["__struct__"]["__data__"]["qVal"]),
					"minval": int(obj["__var__"]["__struct__"]["__data__"]["qMinVal"]),
					"maxval": int(obj["__var__"]["__struct__"]["__data__"]["qMaxVal"]),
					"qTextColor": int(obj["__var__"]["__struct__"]["__data__"]["qTextColor"]),
					"qBorderColor": int(obj["__var__"]["__struct__"]["__data__"]["qBorderColor"])
				});
			i++;
			}
			trace("RESULT ARRAY: "+ tempar);
			trace("_originalfilled: "+_originalfilled);
				this.List_mc.entryList = tempar;
				listprocedures();
				_datarecieved = true;
			}
		}
		function listprocedures():*{
			
			this.List_mc.InvalidateData();
			this.List_mc.brackets.height = 21+this.List_mc.itemsShown*36;
			this.List_mc.UpdateList();
			this.List_mc.selectedIndex = 0;
			stage.focus = this.List_mc;
		}


		public function filltestlist(ar: Array): * {
			if (List_mc.entryList.length>0 && List_mc.entryList[0].text == ar[0].text){
				return;
			}
			if (!_originalfilled && _datarecieved) {
			trace("!_originalfilled && _datarecieved");
			var tempar: Array = this.List_mc.entryList;
			trace("new array: "+ar.concat(tempar));
			this.List_mc.entryList = ar.concat(tempar);
			//this.List_mc.filterer.itemFilter = 4294967295;
			_originalfilled = true;
			listprocedures();
			return;
			}
			
			
			_datarecieved = false;
			this.List_mc.ClearList();
			scenename = "None";
			this.List_mc.entryList = ar;
			this.List_mc.filterer.itemFilter = 4294967295;
			_originalfilled = true;
			listprocedures();
		}
		
		public function setfilterflag(iFilterFlag: Number):*{
			this.List_mc.filterer.itemFilter = iFilterFlag;			
			listprocedures();
		}

		private function onItemPress(_arg_1: Event) {
		atrace("itemlist "+String(this.List_mc.selectedIndex)+" clicked")
		root.f4se.SendExternalEvent("Dialogue::OptionReturned",scenename,this.List_mc.selectedIndex);//this.List_mc.selectedEntry.scene
		if (this.List_mc.selectedIndex<4) {
		atrace("running default function");
			Menu_mc.onButtonRelease(this.List_mc.selectedIndex);
		} //else {
		//atrace("there should be some callback papyrus function");
		//root.f4se.SendExternalEvent("Dialogue::OptionReturned",scenename,this.List_mc.selectedIndex);//this.List_mc.selectedEntry.scene
		//}
			
		}
		
		private function onSelectionChange(_arg_1: Event) {
			atrace("itemlist "+String(this.List_mc.selectedIndex)+" selected")
			atrace(String(this.List_mc.numListItems)+" : "+String(this.List_mc.itemsShown));
		}

		function setprops() {
			try {
				this.List_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {};
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "DialogueListEntry";
			this.List_mc.numListItems = 6;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 0;
			try {
				this.List_mc["componentInspectorSetting"] = false;
			} catch (e: Error) {};
		}

		public function atrace(param1: String): * {
			if (!debugmode) {
				return
			};
			dtf.appendText(param1 + "\n");
			dtf.scrollV = dtf.maxScrollV;
		}
		private function init(e: Event = null): void {
			removeEventListener(Event.ADDED_TO_STAGE, this.init);

		}
		public static function get instance(): MainTimeline {
			return _instance;
		}

		private function initialized(e: Event): void {
			removeEventListener(F4SE_INITIALIZED, this.initialized);
			var loc5:Date = new Date();
			Log.info(loc5.toLocaleString());
			Log.info("f4se initialized");
			trace("root.f4se " + root.f4se);
			f4seinit = true;
			stage.dispatchEvent(new Event(F4SE_INITIALIZED));
		}
	}
}