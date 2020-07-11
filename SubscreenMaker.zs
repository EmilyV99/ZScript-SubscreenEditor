#option SHORT_CIRCUIT on
#option HEADER_GUARD on
#include "std.zh"
#include "VenrobSubscreen.zh"
#include "VenrobCursor.zh"
#include "SubscreenMakerGUI.zs"
#include "VenrobBitmaps.zh"

/* NOTES
 * '.z_asub', '.z_psub' for individual subscreens
 * '.z_sub_proj' for bundle project
 * '.zs' for script export
 */

namespace Venrob::SubscreenEditor
{
	using namespace Venrob::Subscreen;
	using namespace Venrob::Subscreen::Internal;
	using namespace Venrob::SubscreenEditor::DIALOG::PARTS;
	char32 FileEncoding[] = "Venrob_Subscreen_FileSystem"; //Do not change this! This is used for validating saved files.
	
	DEFINE VERSION_ASUB = 1;
	DEFINE VERSION_PSUB = 1;
	DEFINE VERSION_PROJ = 1;
	DEFINE VERSION_SSET = 1;
	//start SubEditorData
	untyped SubEditorData[MAX_INT] = {0, 0, 0, 0, false, false, false, false, false, false, KEY_ENTER, KEY_ENTER_PAD, KEY_ESC, 0, 0, 0, NULL, 0, 0, false};
	enum
	{
		SED_HIGHLIGHTED,
		SED_DRAGGING,
		SED_ACTIVE_PANE,
		SED_PANE_MENU_TYPE,
		SED_LCLICKED,
		SED_RCLICKED,
		SED_MCLICKED,
		SED_LCLICKING,
		SED_RCLICKING,
		SED_MCLICKING,
		SED_DEFAULTBTN,
		SED_DEFAULTBTN2,
		SED_CANCELBTN,
		SED_LASTMOUSE_X,
		SED_LASTMOUSE_Y,
		SED_GUISTATE,
		SED_GUI_BMP,
		SED_QUEUED_DELETION,
		SED_GLOBAL_TIMER,
		SED_JUST_CLONED
	}; //end
	//start System Settings
	untyped sys_settings[MAX_INT];
	enum sysSetting
	{
		SSET_CURSORTILE, //if >0, tile to draw for cursor
		SSET_CURSOR_VER, //if SED_CURSORTILE <= 0, then which packaged cursor style to draw
		SSET_DELWARN,
		SSET_MAX
	}; //end
	
	void do_init() //start
	{
		Subscreen::init();
		//start Init Filesystem
		file f;
		f->Create("SubEditor/Instructions.txt");
		f->WriteString("Files of format '###.z_psub' and '###.z_asub' in this folder"
					   " represent passive and active subscreen data respectively.\n"
					   "The number represents it's saved index. These files need not"
					   " be modified manually, though you can back them up to save "
					   "your subscreens individually.\n"
					   "These files are created automatically, and will be overwritten"
					   " if a project file is loaded.\n"
					   "A '.z_sub_proj' file stores an entire set of subscreens as"
					   " a project package. These can be any name, and loaded via the"
					   " 'Load' option in the script.\n"
					   "These are NOT created automatically; they are only saved via the"
					   "'Save' menu.\n"
					   "'z_sub_proj' files are not usable in a final quest; they only"
					   " act as a way to save your working files. To export a subscreen"
					   " set for use in a quest, you will need to use the '.zs' option"
					   " in the 'Save' menu.\n"
					   "To use an exported '.zs' file, simply import it as any other script,"
					   " and assign the dmapdata scripts 'ActiveSub' and 'PassiveSub'.\n"
					   "Set 'InitD[7]' to the index of the Passive Subscreen, and"
					   " 'InitD[6]' to the index of the Active Subscreen.\n");
		f->Close();
		//end Init Filesystem
		
		untyped buf[MODULE_BUF_SIZE];
		//start Init ASub
		if(FileSystem->FileExists("SubEditor/tmpfiles/001.z_asub"))
		{
			f->Open("SubEditor/tmpfiles/001.z_asub");
			load_active_file(f);
			f->Close();
		}
		else
		{
			MakeBGColorModule(buf);
			add_active_module(buf);
			buf[P1] = DGRAY;
			add_passive_module(buf);
			MakePassiveSubscreen(buf);
			add_active_module(buf);
			//
			MakeSelectableItemID(buf);
			buf[P1] = I_CANDLE1;
			buf[P2] = 0;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 3;
			buf[P3+DIR_RIGHT] = 1;
			buf[M_X] = 32;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_SWORD;
			buf[P2] = 1;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 0;
			buf[P3+DIR_RIGHT] = 2;
			buf[M_X] = 48;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_ARROW;
			buf[P2] = 2;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 1;
			buf[P3+DIR_RIGHT] = 3;
			buf[M_X] = 64;
			buf[M_Y] = 80;
			add_active_module(buf);
			//
			MakeSelectableItemClass(buf);
			buf[P1] = IC_BRANG;
			buf[P2] = 3;
			buf[P3+DIR_UP] = -1;
			buf[P3+DIR_DOWN] = -1;
			buf[P3+DIR_LEFT] = 2;
			buf[P3+DIR_RIGHT] = 0;
			buf[M_X] = 80;
			buf[M_Y] = 80;
			add_active_module(buf);
			f->Create("SubEditor/tmpfiles/001.z_asub");
			save_active_file(f);
			f->Close();
		} //end
		//start Init PSub
		if(FileSystem->FileExists("SubEditor/tmpfiles/001.z_psub"))
		{
			f->Open("SubEditor/tmpfiles/001.z_psub");
			load_passive_file(f);
			f->Close();
		}
		else
		{
			MakeBButtonItem(buf);
			buf[M_X] = 128;
			buf[M_Y] = 24;
			add_passive_module(buf);
			MakeAButtonItem(buf);
			buf[M_X] = 144;
			buf[M_Y] = 24;
			add_passive_module(buf);
			f->Create("SubEditor/tmpfiles/001.z_psub");
			save_passive_file(f);
			f->Close();
		}
		//end
		loadSysSettings();
		f->Free();
		for(int q = 0; q < CR_SCRIPT1; ++q) Game->Counter[q] = Game->MCounter[q] = 60;
		Hero->MaxHP = HP_PER_HEART * 10;
		Hero->HP = Hero->MaxHP;
		Hero->MaxMP = MP_PER_BLOCK * 8;
		Hero->MP = Hero->MaxMP;
	} //end Init
	
	int count_subs(bool passive) //start
	{
		int ret;
		char32 format[] = "SubEditor/tmpfiles/%s.z_#sub";
		format[24] = passive ? 'p' : 'a';
		while(ret < 999)
		{
			char32 numbuf[4];
			sprintf(numbuf, "%03d", ret+1);
			char32 path[256];
			sprintf(path, format, numbuf);
			if(FileSystem->FileExists(path))
				++ret;
			else break;
		}
		return ret;
	} //end
	
	global script onF6 //start
	{
		void run()
		{
			using namespace Venrob::SubscreenEditor::DIALOG;
			if(!DEBUG)
			{
				ProcRet r = yesno_dlg("Exit Game","Would you like to save first, or just exit?","Save","Quit");
				if(r == PROC_CANCEL) return;
				if(r == PROC_CONFIRM)
				{
					//UNFINISHED Call save dialog
				}
			}
			Game->End();
		}
	} //end
	
	global script onExit //start
	{
		void run()
		{
			saveSysSettings();
		}
	} //end
	
	DEFINE PASSIVE_EDITOR_TOP = ((224/2)-(56/2))-56;
	global script Active //Subscreen Editor
	{
		void run()
		{
			Game->DisableActiveSubscreen = true;
			Game->ClickToFreezeEnabled = false;
			setRules();
			do_init();
			TypeAString::setEnterEndsTyping(false); TypeAString::setAllowBackspaceDelete(true); TypeAString::setOverflowWraps(false);
			while(true)
				DIALOG::MainMenu(); //Constantly call the main menu
		}
	}
	
	void setRules() //start
	{
		Game->FFRules[qr_OLD_PRINTF_ARGS] = false;
		Game->FFRules[qr_BITMAP_AND_FILESYSTEM_PATHS_ALWAYS_RELATIVE] = true;
	} //end
	//start Misc
	void runFauxActiveSubscreen()
	{
		runFauxPassiveSubscreen(false);
		for(int q = 1; q < g_arr[NUM_ACTIVE_MODULES] ; ++q)
		{
			untyped buf[MODULE_BUF_SIZE];
			saveModule(buf, q, true);
			runFauxModule(q, buf, true, true);
		}
		runPreparedSelector(true);
		getSubscreenBitmap(true)->Blit(7, RT_SCREEN, 0, 0, 256, 224, 0, -56, 256, 224, 0, 0, 0, 0, 0, true);
		activetimers();
		clearActive1frame();
	}

	void runFauxPassiveSubscreen(bool interactive)
	{
		++g_arr[PASSIVE_TIMER];
		g_arr[PASSIVE_TIMER]%=3600;
		for(int q = 1; q < g_arr[NUM_PASSIVE_MODULES] ; ++q)
		{
			untyped buf[MODULE_BUF_SIZE];
			saveModule(buf, q, false);
			runFauxModule(q, buf, false, interactive);
		}
		runPreparedSelector(false);
	}

	void runFauxModule(int mod_indx, untyped module_arr, bool active, bool interactive)
	{
		if(active) interactive = true;
		bitmap bit = getSubscreenBitmap(active);
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_BGCOLOR:
			{
				//Cannot drag
				if(active)
				{
					bit->Rectangle(module_arr[M_LAYER], 0, 0, 256, 224, module_arr[P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[M_LAYER], 0, 0, 255, 223, mod_indx, active, true);
				}
				else
				{
					bit->Rectangle(module_arr[M_LAYER], 0, 0, 256, 56, module_arr[P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[M_LAYER], 0, 0, 254, 55, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			{
				int itmid = module_arr[M_TYPE] == MODULE_TYPE_ABUTTONITEM ? I_SWORD1 : I_CANDLE1;
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[active ? ACTIVE_TIMER : PASSIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->FastTile(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
						ty = module_arr[M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			}
			
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
			{
				unless(active) break; //Not allowed on passive
				bool class = (module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_CLASS);
				int itmid = (class?(get_item_of_class(module_arr[P1])):(module_arr[P1]));
				if(itmid < 0) itmid = class ? get_item_of_class(module_arr[P1], true) : 0;
				if(itmid < 0) itmid = 0;
				
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[ACTIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->FastTile(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
					    ty = module_arr[M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			}
			
			case MODULE_TYPE_PASSIVESUBSCREEN:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->BlitTo(module_arr[M_LAYER], getSubscreenBitmap(false), 0, 0, 256, 56, module_arr[M_X], module_arr[M_Y], 256, 56, 0, 0, 0, 0, 0, true);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], 255, 55, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_MINIMAP:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				minimap(module_arr, bit, active);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], 5*16-1, 3*16-1, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_TILEBLOCK:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				bit->DrawTile(0,  module_arr[M_X], module_arr[M_Y], module_arr[P1], module_arr[P3], module_arr[P4], module_arr[P2], -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], module_arr[P3]*16-1, module_arr[P4]*16-1, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_HEART:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				heart(bit, module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], module_arr[P3], module_arr[P1], module_arr[P2]);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], 7, 7, mod_indx, active, true);
				}
				break;
			}
			
			case MODULE_TYPE_HEARTROW:
			{
				if(interactive) handleDragging(module_arr, mod_indx, active);
				if(module_arr[M_FLAGS1] & FLAG_RTOLHEARTS)
					invheartrow(bit, module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], module_arr[P3], module_arr[P1], module_arr[P2], module_arr[P4], module_arr[P5]);
				else
					heartrow(bit, module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], module_arr[P3], module_arr[P1], module_arr[P2], module_arr[P4], module_arr[P5]);
				if(interactive)
				{
					editorCursor(module_arr[M_LAYER], module_arr[M_X], module_arr[M_Y], (module_arr[P4]) * (7 + module_arr[P5])+8-module_arr[P5], 7, mod_indx, active, true);
				}
				break;
			}
			
			//case :
		}
	}
	
	void handleDragging(untyped module_arr, int mod_indx, bool active)
	{
		if(SubEditorData[SED_DRAGGING] == mod_indx)
		{
			clearPreparedSelector();
			int dx = Input->Mouse[MOUSE_X] - SubEditorData[SED_LASTMOUSE_X],
				dy = Input->Mouse[MOUSE_Y] - SubEditorData[SED_LASTMOUSE_Y];
			module_arr[M_X] = VBound(module_arr[M_X]+dx, max_x(module_arr), min_x(module_arr));
			module_arr[M_Y] = VBound(module_arr[M_Y]+dy, max_y(module_arr, active), min_y(module_arr));
			setModX(mod_indx, active, module_arr[M_X]);
			setModY(mod_indx, active, module_arr[M_Y]);
		}
		else if(SubEditorData[SED_HIGHLIGHTED] == mod_indx)
		{
			if(Input->Press[CB_UP])
			{
				module_arr[M_Y] = VBound(module_arr[M_Y]-1, max_y(module_arr, active), min_y(module_arr));
				setModY(mod_indx, active, module_arr[M_Y]);
			}
			else if(Input->Press[CB_DOWN])
			{
				module_arr[M_Y] = VBound(module_arr[M_Y]+1, max_y(module_arr, active), min_y(module_arr));
				setModY(mod_indx, active, module_arr[M_Y]);
			}
			if(Input->Press[CB_LEFT])
			{
				module_arr[M_X] = VBound(module_arr[M_X]-1, max_x(module_arr), min_x(module_arr));
				setModX(mod_indx, active, module_arr[M_X]);
			}
			else if(Input->Press[CB_RIGHT])
			{
				module_arr[M_X] = VBound(module_arr[M_X]+1, max_x(module_arr), min_x(module_arr));
				setModX(mod_indx, active, module_arr[M_X]);
			}
		}
	}
	
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active)
	{
		editorCursor(layer, x, y, wid, hei, mod_indx, active, false);
	}
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active, bool overlapBorder)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return; //A GUI pane is open, halt all other cursor action
		//bool overlapBorder = (wid >= 16*3 || hei >= 16*3); //Overlap the border on large (3 tile wide/tall or larger) objects
		int sx = overlapBorder ? x+1 : x, sy = overlapBorder ? y+1 : y, swid = overlapBorder ? wid-2 : wid, shei = overlapBorder ? hei-2 : hei;
		bool onGUI = DIALOG::isHoveringGUI();
		bool isHovering = !onGUI && (active ? CursorBox(x, y, x+wid, y+hei, 0, 56) : CursorBox(x, y, x+wid, y+hei, 0, PASSIVE_EDITOR_TOP - 56));
		bool isDragging = SubEditorData[SED_DRAGGING] == mod_indx;
		if(isHovering && SubEditorData[SED_LCLICKED]) //Clicking
		{
			SubEditorData[SED_DRAGGING] = mod_indx;
			if(SubEditorData[SED_HIGHLIGHTED] != mod_indx)
			{
				SubEditorData[SED_HIGHLIGHTED] = mod_indx;
				return;
			}
		}
		if(SubEditorData[SED_HIGHLIGHTED] == mod_indx)
		{
			if(DIALOG::keyproc(KEY_DEL) || DIALOG::keyproc(KEY_DEL_PAD))
			{
				if(mod_indx>1 && DIALOG::delwarn())
				{
					SubEditorData[SED_QUEUED_DELETION] = active ? mod_indx : -mod_indx;
					SubEditorData[SED_HIGHLIGHTED] = 0;
					if(isDragging) SubEditorData[SED_DRAGGING] = 0;
				}
			}
			if(!isDragging && isHovering)
			{
				clearPreparedSelector();
				if(SubEditorData[SED_RCLICKED]) //RClick
				{
					open_data_pane(mod_indx, active);
					SubEditorData[SED_RCLICKED] = false;
				}
			}
			else if(SubEditorData[SED_LCLICKED] && !onGUI) //Clicked off
			{
				SubEditorData[SED_HIGHLIGHTED] = 0;
				return;
			}
			DrawSelector(layer, sx, sy, swid, shei, active, false, SEL_RECTANGLE, PAL[COL_HIGHLIGHT]);
		}
		else if(isHovering)
			DrawSelector(layer, sx, sy, swid, shei, active, true, SEL_RECTANGLE, PAL[COL_CURSOR]);
	}
	
	enum
	{
		PANE_T_ACTIVE, PANE_T_PASSIVE, PANE_T_SYSTEM
	};
	
	enum SystemPane
	{
		DLG_LOAD = 1, DLG_SAVEAS, DLG_THEMES, DLG_OPTIONS, DLG_NEWOBJ, DLG_SYSTEM
	};
	
	void open_data_pane(int indx, bool active)
	{
		open_data_pane(indx, active ? PANE_T_ACTIVE : PANE_T_PASSIVE);
	}
	
	void open_data_pane(int indx, int panetype)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return;
		SubEditorData[SED_ACTIVE_PANE] = indx;
		SubEditorData[SED_PANE_MENU_TYPE] = panetype;
	}
	
	void close_data_pane()
	{
		SubEditorData[SED_ACTIVE_PANE] = NULL;
		SubEditorData[SED_PANE_MENU_TYPE] = false;
	}
	
	bool handle_data_pane(bool active)
	{
		int pane = SubEditorData[SED_ACTIVE_PANE];
		unless(pane) return false;
		int panetype = SubEditorData[SED_PANE_MENU_TYPE];
		untyped module_arr[MODULE_BUF_SIZE];
		close_data_pane(); //here, so that the pane can open another from inside.
		switch(panetype)
		{
			case PANE_T_ACTIVE:
				saveModule(module_arr, pane, true);
				DIALOG::editObj(module_arr, pane, true);
				break;
			
			case PANE_T_PASSIVE:
				saveModule(module_arr, pane, false);
				DIALOG::editObj(module_arr, pane, false);
				break;
			
			case PANE_T_SYSTEM:
				switch(pane)
				{
					//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! UNFINISHED DIALOGUES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
					case DLG_LOAD:
						DIALOG::load();
						break;
					case DLG_SAVEAS:
						DIALOG::save();
						break;
						
					case DLG_NEWOBJ:
						DIALOG::new_obj(active);
						break;
					case DLG_SYSTEM:
						DIALOG::sys_dlg();
						break;
					case DLG_OPTIONS:
						DIALOG::opt_dlg(active);
						break;
					case DLG_THEMES:
						DIALOG::editThemes();
						break;
						
					default:
						if(DEBUG) error("Bad SYSTEM type pane opened!");
						break;
				}
				break;
		}
		//close_data_pane();
		return true;
	}
	
	void subscr_Waitframe()
	{
		handleEndFrame();
		Waitframe();
		handleStartFrame();
	}
	
	void handleStartFrame()
	{
		++SubEditorData[SED_GLOBAL_TIMER];
		SubEditorData[SED_GLOBAL_TIMER]%=3600;
		SubEditorData[SED_LCLICKED] = Input->Mouse[MOUSE_LEFT] && !SubEditorData[SED_LCLICKING];
		SubEditorData[SED_RCLICKED] = Input->Mouse[MOUSE_RIGHT] && !SubEditorData[SED_RCLICKING];
		SubEditorData[SED_MCLICKED] = Input->Mouse[MOUSE_MIDDLE] && !SubEditorData[SED_MCLICKING];
		SubEditorData[SED_LCLICKING] = Input->Mouse[MOUSE_LEFT];
		SubEditorData[SED_RCLICKING] = Input->Mouse[MOUSE_RIGHT];
		SubEditorData[SED_MCLICKING] = Input->Mouse[MOUSE_MIDDLE];
		unless(Input->Mouse[MOUSE_LEFT]) SubEditorData[SED_DRAGGING] = 0;
		pollKeys();
	}
	
	void handleEndFrame()
	{
		SubEditorData[SED_LASTMOUSE_X] = Input->Mouse[MOUSE_X];
		SubEditorData[SED_LASTMOUSE_Y] = Input->Mouse[MOUSE_Y];
		if(sys_settings[SSET_CURSORTILE] > 0)
		{
			Screen->FastTile(7, Input->Mouse[MOUSE_X], Input->Mouse[MOUSE_Y], sys_settings[SSET_CURSORTILE], 0, OP_OPAQUE);
		}
		else
		{
			DrawCursor(sys_settings[SSET_CURSOR_VER], Input->Mouse[MOUSE_X], Input->Mouse[MOUSE_Y]);
		}
		
		if(Input->Key[KEY_G])
		{
			if(PressShift())
			{
				for(int x = 0; x <= 256; x += 16)
				{
					Screen->Line(7, x, -56, x, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
					Screen->Line(7, x-1, -56, x-1, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				}
				for(int y = -56; y <= 168; y += 16)
				{
					Screen->Line(7, 0, y, 256, y, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
					Screen->Line(7, 0, y-1, 256, y-1, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				}
			}
			else
			{
				Screen->Line(7, 127, -56, 127, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 128, -56, 128, 176, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 0, 56, 256, 56, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, 0, 55, 256, 55, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, OP_OPAQUE);
			}
		}
	}
	enum CursorType
	{
		CT_BASIC, CT_STICK
	};
	void DrawCursor(CursorType type, int x, int y)
	{
		switch(type)
		{
			case CT_STICK:
				Screen->Line(7, x, y, x+3, y, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, x, y, x, y+3, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				Screen->Line(7, x, y, x+4, y+4, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				break;
			case CT_BASIC:
			default:
				Screen->Triangle(7, x, y, x+4, y, x, y+4, 0, 0, PAL[COL_CURSOR], 0, 0, 0);
				Screen->Line(7, x, y, x+5, y+5, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				break;
		}
	}
	
	void KillClicks()
	{
		SubEditorData[SED_LCLICKED] = false;
		SubEditorData[SED_RCLICKED] = false;
		SubEditorData[SED_MCLICKED] = false;
		SubEditorData[SED_LCLICKING] = false;
		SubEditorData[SED_RCLICKING] = false;
		SubEditorData[SED_MCLICKING] = false;
		Input->Mouse[MOUSE_LEFT] = false;
		Input->Mouse[MOUSE_RIGHT] = false;
		Input->Mouse[MOUSE_MIDDLE] = false;
	}
	
	//start module_limits
	int max_x(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 256-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitWidth) id->HitWidth = 16;
				unless(id->TileWidth) id->TileWidth = 1;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset),
					twid = (hit ? id->HitWidth : id->TileWidth*16);
				return 256 - xoffs - twid;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 0;
			case MODULE_TYPE_BGCOLOR:
				return 0;
			case MODULE_TYPE_MINIMAP:
				return 256 - (16 * 5);
			case MODULE_TYPE_TILEBLOCK:
				return 256 - (16 * module_arr[P3]);
			case MODULE_TYPE_HEART:
				return 256 - 8;
			case MODULE_TYPE_HEARTROW:
				return 256 - ((module_arr[P4]) * (7 + module_arr[P5])+8-module_arr[P5]);
		}
		return 256-16;
	}
	
	int min_x(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset);
				return 0 - xoffs;
		}
		return 0;
	}
	
	int max_y(untyped module_arr, bool active)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return (active ? 224 : 56)-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitHeight) id->HitHeight = 16;
				unless(id->TileHeight) id->TileHeight = 1;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset),
					thei = (hit ? id->HitHeight : id->TileHeight*16);
				return (active ? 224 : 56) - yoffs - thei;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 224-56;
			case MODULE_TYPE_BGCOLOR:
				return 0;
			case MODULE_TYPE_MINIMAP:
				return 256 - (16 * 3);
			case MODULE_TYPE_TILEBLOCK:
				return 256 - (16 * module_arr[P4]);
			case MODULE_TYPE_HEARTROW:
			case MODULE_TYPE_HEART:
				return 256 - 8;
		}
		return (active ? 224 : 56)-16;
	}
	
	int min_y(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_ABUTTONITEM:
			case MODULE_TYPE_BBUTTONITEM:
			case MODULE_TYPE_SELECTABLE_ITEM_ID:
			case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_ABUTTONITEM?I_SWORD1:(module_arr[M_TYPE]==MODULE_TYPE_BBUTTONITEM?I_CANDLE1:(module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset);
				return 0 - yoffs;
		}
		return 0;
	}
	//end module_limits

	bitmap getGUIBitmap()
	{
		unless((<bitmap>SubEditorData[SED_GUI_BMP])->isAllocated()) SubEditorData[SED_GUI_BMP] = Game->AllocateBitmap();
		unless((<bitmap>SubEditorData[SED_GUI_BMP])->isValid()) generate((<bitmap>SubEditorData[SED_GUI_BMP]), DIALOG::MAIN_GUI_WIDTH, DIALOG::MAIN_GUI_HEIGHT);
		return (<bitmap>SubEditorData[SED_GUI_BMP]);
	}
	//end Misc
	
	//start FileIO
	enum file_type_id
	{
		FTID_NULL,
		FTID_INDIV_ACTIVE,
		FTID_INDIV_PASSIVE,
		FTID_PROJECT,
		FTID_CLOSING_SIG,
		FTID_SYS_SETTING,
		FTID_MAX
	};
	//start Signature
	/**
	 * Validates a file is signed with a given string and type ID.
	 */
	bool validate_file_signature(file f, char32 encoding, int type_id)
	{
		char32 buf[256];
		int len = strlen(encoding)+1;
		f->ReadChars(buf, len, 0); //Read encoding string
		unless(strcmp(encoding,buf)) //Valid encoding
		{
			int id[1];
			reposFile(f);
			f->ReadInts(id, 1, 0);
			if(type_id == id[0]) //Valid type
				return true;
			printf("Valid encoding; invalid type '%d'\n", id[0]);
			return false; //Invalid type
		}
		else //Invalid encoding
		{
			printf("Invalid encoding: '%s'\n", buf);
			return false;
		}
	}
	/**
	 * Signs a file with a given string and type ID.
	 */
	void sign_file(file f, char32 encoding, int type_id)
	{
		f->WriteString(encoding);
		f->WriteInts({type_id}, 1, 0);
	}
	//end Signature
	//start Indiv Subscreens
	void get_filename(char32 buf, int indx, bool passive) //start
	{
		sprintf(buf, "SubEditor/tmpfiles/%03d.z_%csub", indx, passive ? 'p' : 'a');
	} //end
	bool load_active_file(int indx) //start
	{
		printf("Attempted to load afile %d\n", indx);
		if(indx <= 0 || indx > 999) return false;
		char32 path[256];
		get_filename(path, indx, false);
		file f;
		if(f->Open(path))
		{
			bool b = load_active_file(f);
			f->Free();
			return b;
		}
		f->Free();
		return false;
	} //end
	bool load_active_file(file f) //start
	{
		unless(validate_file_signature(f, FileEncoding, FTID_INDIV_ACTIVE))
		{
			DIALOG::err_dlg("Invalid file signature found! Attempted to open invalid/corrupt file!");
			return false;
		}
		int v[2];
		reposFile(f);
		f->ReadInts(v, 2, 0);
		switch(v[0])
		{
			case 1:
			{
				clearActive();
				for(int q = 0; q < v[1]; ++q)
				{
					untyped buf[MODULE_BUF_SIZE];
					int cnt;
					cnt += f->ReadInts(buf, 1, 0);
					if(f->EOF) break;
					cnt += f->ReadInts(buf, buf[0]-1, 1);
					add_active_module(buf);
					if(f->EOF) break;
				}
				return true;
			}
			default:
				DIALOG::err_dlg("The file attempted to be loaded has invalid/corrupt data.\n"
				        "It may have been saved in a newer version of the subscreen header,"
						" in which case you must update to load it.");
				return false;
		}
	} //end
	bool load_passive_file(int indx) //start
	{
		printf("Attempted to load pfile %d\n", indx);
		if(indx <= 0 || indx > 999) return false;
		char32 path[256];
		get_filename(path, indx, true);
		file f;
		if(f->Open(path))
		{
			bool b = load_passive_file(f);
			f->Free();
			return b;
		}
		f->Free();
		return false;
	} //end
	bool load_passive_file(file f) //start
	{
		unless(validate_file_signature(f, FileEncoding, FTID_INDIV_PASSIVE))
		{
			DIALOG::err_dlg("Invalid file signature found! Attempted to open invalid/corrupt file!");
			return false;
		}
		int v[2];
		reposFile(f);
		f->ReadInts(v, 2, 0);
		switch(v[0])
		{
			case 1:
			{
				clearPassive();
				for(int q = 0; q < v[1]; ++q)
				{
					untyped buf[MODULE_BUF_SIZE];
					f->ReadInts(buf, 1, 0);
					if(f->EOF) break;
					f->ReadInts(buf, buf[0]-1, 1);
					add_passive_module(buf);
					if(f->EOF) break;
				}
				return true;
			}
			default:
				DIALOG::err_dlg("The file attempted to be loaded has invalid/corrupt data.\n"
				        "It may have been saved in a newer version of the subscreen header,"
						" in which case you must update to load it.");
				return false;
		}
	} //end
	void save_active_file(int indx) //start
	{
		if(indx <= 0 || indx > 999) return;
		char32 path[256];
		get_filename(path, indx, false);
		file f;
		if(f->Create(path))
		{
			save_active_file(f);
		}
		f->Free();
	} //end
	void save_active_file(file f) //start
	{
		sign_file(f, FileEncoding, FTID_INDIV_ACTIVE);
		f->WriteInts({VERSION_ASUB, g_arr[NUM_ACTIVE_MODULES]},2,0);
		f->WriteInts(activeData,g_arr[SZ_ACTIVE_DATA],0);
	} //end
	void save_passive_file(int indx) //start
	{
		if(indx <= 0 || indx > 999) return;
		char32 path[256];
		get_filename(path, indx, true);
		file f;
		if(f->Create(path))
		{
			save_passive_file(f);
		}
		f->Free();
	} //end
	void save_passive_file(file f) //start
	{
		sign_file(f, FileEncoding, FTID_INDIV_PASSIVE);
		f->WriteInts({VERSION_PSUB, g_arr[NUM_PASSIVE_MODULES]},2,0);
		f->WriteInts(passiveData,g_arr[SZ_PASSIVE_DATA],0);
	} //end
	bool delete_active_file(int indx) //start
	{
		if(indx <= 0 || indx > 999) return false;
		int cnt = count_subs(false);
		if(indx > cnt) return false;
		for(int q = indx+1; q <= cnt; ++q)
		{
			load_active_file(q);
			save_active_file(q-1);
		}
		char32 path[256];
		get_filename(path, indx, false);
		file f;
		if(f->Open(path))
		{
			f->Remove();
			f->Free();
			return true;
		}
		f->Free();
		return false;
	} //end
	bool delete_passive_file(int indx) //start
	{
		if(indx <= 0 || indx > 999) return false;
		int cnt = count_subs(true);
		if(indx > cnt) return false;
		for(int q = indx+1; q <= cnt; ++q)
		{
			load_passive_file(q);
			save_passive_file(q-1);
		}
		char32 path[256];
		get_filename(path, indx, true);
		file f;
		if(f->Open(path))
		{
			f->Remove();
			f->Free();
			return true;
		}
		f->Free();
		return false;
	} //end
	//end Indiv Subscreens
	//start Nuke Indiv Subscreens
	void nuke_files()
	{
		nuke_active_files();
		nuke_passive_files();
	}
	void nuke_active_files()
	{
		for(int q = 1; q < 1000; ++q)
		{
			char32 buf[256];
			get_filename(buf, q, false);
			file f;
			if(f->Open(buf))
				f->Remove();
			f->Free();
		}
	}
	void nuke_passive_files()
	{
		for(int q = 1; q < 1000; ++q)
		{
			char32 buf[256];
			get_filename(buf, q, true);
			file f;
			if(f->Open(buf))
				f->Remove();
			f->Free();
		}
	}
	//end Nuke Indiv Subscreens
	//start Project Files
	bool save_project_file(file proj)
	{
		int num_active = count_subs(false), num_passive = count_subs(true);
		bool erred = false;
		sign_file(proj, FileEncoding, FTID_PROJECT);
		proj->WriteInts({VERSION_PROJ, num_active, num_passive},3,0);
		for(int q = 1; q <= num_active; ++q)
		{
			unless(load_active_file(q))
			{
				char32 buf[256];
				sprintf(buf, "Error occurred loading Active file %i",q);
				DIALOG::err_dlg(buf);
				erred = true;
				continue;
			}
			save_active_file(proj);
		}
		for(int q = 1; q <= num_passive; ++q)
		{
			unless(load_passive_file(q))
			{
				char32 buf[256];
				sprintf(buf, "Error occurred loading Passive file %i",q);
				DIALOG::err_dlg(buf);
				erred = true;
				continue;
			}
			save_passive_file(proj);
		}
		sign_file(proj, FileEncoding, FTID_CLOSING_SIG);
		if(erred)
		{
			DIALOG::err_dlg("One or more errors occurred; project file output failed.");
			proj->Remove();
			return false;
		}
		return true;
	}
	bool load_project_file(file proj)
	{
		bool erred = false;
		if(validate_file_signature(proj, FileEncoding, FTID_PROJECT))
		{
			int v[3];
			reposFile(proj);
			proj->ReadInts(v, 3, 0);
			switch(v[0])
			{
				case 1:
				{
					nuke_files(); //Delete all pre-existing temp files; to overwrite with loaded ones
					for(int q = 1; q <= v[1]; ++q)
					{
						unless(load_active_file(proj))
						{
							char32 buf[256];
							sprintf(buf, "Error occurred loading Active subscreen %i",q);
							DIALOG::err_dlg(buf);
							erred = true;
							continue;
						}
						save_active_file(q);
					}
					for(int q = 1; q <= v[2]; ++q)
					{
						unless(load_passive_file(proj))
						{
							char32 buf[256];
							sprintf(buf, "Error occurred loading Passive subscreen %i",q);
							DIALOG::err_dlg(buf);
							erred = true;
							continue;
						}
						save_passive_file(q);
					}
					if(erred)
					{
						DIALOG::err_dlg("One or more errors occurred; project file load failed.");
						return false;
					}
					return true;
				}
				default:
					DIALOG::err_dlg("The file attempted to be loaded has invalid/corrupt data.\n"
							"It may have been saved in a newer version of the subscreen header,"
							" in which case you must update to load it.");
					return false;
			}
		}
		else return false;
	}
	//end Project Files
	//start System Settings
	void saveSysSettings()
	{
		file f;
		if(f->Create("SubEditor/SysSettings"))
		{
			sign_file(f, FileEncoding, FTID_SYS_SETTING);
			f->WriteInts({VERSION_SSET, SSET_MAX, PAL_SIZE}, 3, 0);
			f->WriteInts(sys_settings, SSET_MAX, 0);
			f->WriteInts(PAL, PAL_SIZE, 0);
		}
	}
	
	void loadSysSettings()
	{
		file f;
		if(f->Open("SubEditor/SysSettings"))
		{
			if(validate_file_signature(f, FileEncoding, FTID_SYS_SETTING))
			{
				reposFile(f);
				int v[3];
				f->ReadInts(v, 3, 0);
				switch(v[0])
				{
					case 1:
						if(f->EOF) break;
						f->ReadInts(sys_settings, v[1], 0);
						if(f->EOF) break;
						f->ReadInts(PAL, v[2], 0);
						return;
				}
			}
			if(DEBUG) error("Failed to load system settings...");
		}
		else //Default settings
		{
			loadClassicPal(PAL);
			sys_settings[SSET_DELWARN] = true;
		}
		f->Free();
	}
	//end System Settings
	void reposFile(file f)
	{
		f->Seek(f->Pos, false);
	}
	//end FileIO
}