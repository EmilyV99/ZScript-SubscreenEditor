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
	//start SubEditorData
	untyped SubEditorData[MAX_INT] = {0, 0, 0, 0, 0, false, false, false, false, false, false, KEY_ENTER, KEY_ENTER_PAD, KEY_ESC, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, false, false};
	enum
	{
		SED_SELECTED,
		SED_DRAGGING,
		SED_TRY_SELECT,
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
		SED_MOUSE_X,
		SED_MOUSE_Y,
		SED_MOUSE_Z,
		SED_LASTMOUSE_X,
		SED_LASTMOUSE_Y,
		SED_LASTMOUSE_Z,
		SED_GUISTATE,
		SED_GUI_BMP,
		SED_QUEUED_DELETION,
		SED_GLOBAL_TIMER,
		SED_JUST_CLONED,
		SED_ZCM_BTN,
		SED_ANCHOR_MODINDX,
		SED_ANCHOR_SUBINDX,
		SED_TRY_ANCHOR_1,
		SED_TRY_ANCHOR_2
	}; //end
	//start Module Edit Flags
	long mod_flags[MAX_INT];
	DEFINEL MODFLAG_SELECTED = FLAG1;
	//end
	//start System Settings
	untyped sys_settings[MAX_INT];
	enum sysSetting
	{
		SSET_CURSORTILE, //if >0, tile to draw for cursor
		SSET_CURSORCSET,
		SSET_CURSOR_VER, //if SED_CURSORTILE <= 0, then which packaged cursor style to draw
		SSET_FLAGS1,
		SSET_FLAGS2,
		SSET_ANCHOR_SZ,
		SSET_MAX
	};
	
	DEFINEL SSET_FLAG_DELWARN = FLAG1;
	//end
	
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
			MakeBGColorModule(buf);
			buf[P1] = DGRAY;
			add_passive_module(buf);
			MakeButtonItem(buf);
			buf[M_X] = 128;
			buf[M_Y] = 24;
			buf[P1] = CB_B;
			add_passive_module(buf);
			MakeButtonItem(buf);
			buf[M_X] = 144;
			buf[M_Y] = 24;
			buf[P1] = CB_A;
			add_passive_module(buf);
			f->Create("SubEditor/tmpfiles/001.z_psub");
			save_passive_file(f);
			f->Close();
		}
		//end
		loadSysSettings();
		f->Free();
		/*for(int q = 0; q < CR_SCRIPT1; ++q) Game->Counter[q] = Game->MCounter[q] = 60;
		Hero->MaxHP = HP_PER_HEART * 10;
		Hero->HP = Hero->MaxHP;
		Hero->MaxMP = MP_PER_BLOCK * 8;
		Hero->MP = Hero->MaxMP;*/
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
	global script Active //start Subscreen Editor
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
	} //end
	
	dmapdata script TestingPassiveSub
	{
		void run()
		{
			while(true)
			{
				if(Input->Press[CB_MAP])
				{
					Input->Press[CB_MAP] = false; Input->Button[CB_MAP] = false;
					for(int q = 0; q < CB_MAX; ++q)
					{
						switch(q) //start Filter out unused buttons
						{
							case CB_A: case CB_B: case CB_L: case CB_R: case CB_EX1: case CB_EX2: case CB_EX3: case CB_EX4:
							{
								unless(activeData[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<q))
									continue;
								break;
							}
							default: continue;
						} //end
						printf("Btn %d: pos %d, val %d (%d)\n",q,btn_data[BTNPOS+q],btn_data[BTNITMS+q],get_btn_itm(q));
					}
				}
				if(Input->Key[KEY_G]) setScriptConditional(0, 0, true);
				runPassiveSubscreen();
				Waitframe();
			}
		}
	}
	dmapdata script TestingActiveSub
	{
		void run()
		{
			runActiveSubscreen();
			runPassiveSubscreen();
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
			runFauxModule(q, activeData, activeModules[q], true, true);
		}
		handleDragging(true);
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
			runFauxModule(q, passiveData, passiveModules[q], false, interactive);
		}
		if(interactive) handleDragging(false);
		runPreparedSelector(false);
	}

	void runFauxModule(int mod_indx, untyped module_arr, int offs, bool active, bool interactive)
	{
		if(active) interactive = true;
		bitmap bit = getSubscreenBitmap(active);
		switch(module_arr[offs+M_TYPE])
		{
			case MODULE_TYPE_BGCOLOR: //start
			{
				//Cannot drag
				if(active)
				{
					bit->Rectangle(module_arr[offs+M_LAYER], 0, 0, 256, 224, module_arr[offs+P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[offs+M_LAYER], 0, 0, 255, 223, mod_indx, active, true);
				}
				else
				{
					bit->Rectangle(module_arr[offs+M_LAYER], 0, 0, 256, 56, module_arr[offs+P1], 1, 0, 0, 0, true, OP_OPAQUE);
					if(interactive)
						editorCursor(module_arr[offs+M_LAYER], 0, 0, 254, 55, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_BUTTONITEM: //start
			{
				int itmid = get_btn_itm(module_arr[offs+P1]);
				unless(itmid > -1) itmid = 0;
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[active ? ACTIVE_TIMER : PASSIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				bit->FastTile(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[offs+M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
						ty = module_arr[offs+M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[offs+M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			} //end
			
			case MODULE_TYPE_NONSEL_ITEM_ID:
			case MODULE_TYPE_NONSEL_ITEM_CLASS:
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS: //start
			{
				bool nonsel = module_arr[offs+M_TYPE] == MODULE_TYPE_NONSEL_ITEM_ID || module_arr[offs+M_TYPE] == MODULE_TYPE_NONSEL_ITEM_CLASS;
				unless(active || nonsel) break; //Not allowed on passive
				bool class = (module_arr[offs+M_TYPE]==MODULE_TYPE_SEL_ITEM_CLASS || module_arr[offs+M_TYPE]==MODULE_TYPE_NONSEL_ITEM_CLASS);
				int itmid = (class?(get_item_of_class(module_arr[offs+P1])):(module_arr[offs+P1]));
				if(itmid < 0) itmid = class ? get_item_of_class(module_arr[offs+P1], true) : 0;
				if(itmid < 0) itmid = 0;
				
				itemdata id = Game->LoadItemData(itmid);
				int frm = Div(g_arr[ACTIVE_TIMER] % (Max(1,id->ASpeed*id->AFrames)),Max(1,id->ASpeed));
				bit->FastTile(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], id->Tile + frm, id->CSet, OP_OPAQUE);
				if(interactive)
				{
					bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
					unless(id->HitWidth) id->HitWidth = 16;
					unless(id->HitHeight) id->HitHeight = 16;
					unless(id->TileWidth) id->TileWidth = 1;
					unless(id->TileHeight) id->TileHeight = 1;
					int tx = module_arr[offs+M_X] + (hit ? id->HitXOffset : id->DrawXOffset),
					    ty = module_arr[offs+M_Y] + (hit ? id->HitYOffset : id->DrawYOffset),
						twid = (hit ? id->HitWidth : id->TileWidth*16),
						thei = (hit ? id->HitHeight : id->TileHeight*16);
					editorCursor(module_arr[offs+M_LAYER], tx, ty, twid, thei, mod_indx, active);
				}
				break;
			} //end
			
			case MODULE_TYPE_PASSIVESUBSCREEN: //start
			{
				bit->BlitTo(module_arr[offs+M_LAYER], getSubscreenBitmap(false), 0, 0, 256, 56, module_arr[offs+M_X], module_arr[offs+M_Y], 256, 56, 0, 0, 0, 0, 0, true);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 255, 55, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_MINIMAP: //start
			{
				minimap(module_arr, offs, bit, active);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 5*16-1, 3*16-1, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_BIGMAP: //start
			{
				bigmap(module_arr, offs, bit, active);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], BIGMAP_TWID*16-1, BIGMAP_THEI*16-1, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_TILEBLOCK: //start
			{
				bit->DrawTile(0,  module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P3], module_arr[offs+P4], module_arr[offs+P2], -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3]*16-1, module_arr[offs+P4]*16-1, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_HEART: //start
			{
				heart(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 7, 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_HEARTROW: //start
			{
				if(module_arr[offs+M_FLAGS1] & FLAG_HROW_RTOL)
					invheartrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P4], module_arr[offs+P5]);
				else
					heartrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P4], module_arr[offs+P5]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], (module_arr[offs+P4]) * (7 + module_arr[offs+P5])+8-module_arr[offs+P5], 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_MAGIC: //start
			{
				if(module_arr[offs+M_FLAGS1] & FLAG_MAG_ISHALF)
					halfmagic(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2]);
				else
					magic(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 7, 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_MAGICROW: //start
			{
				if(module_arr[offs+M_FLAGS1] & FLAG_MROW_RTOL)
					invmagicrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P4], module_arr[offs+P5]);
				else
					magicrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P4], module_arr[offs+P5]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], (module_arr[offs+P4]) * (7 + module_arr[offs+P5])+8-module_arr[offs+P5], 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_CRPIECE: //start
			{
				crpiece(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P4], module_arr[offs+P5]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 7, 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_CRROW: //start
			{
				if(module_arr[offs+M_FLAGS1] & FLAG_CRROW_RTOL)
					invmiscrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P6], module_arr[offs+P7], module_arr[offs+P4], module_arr[offs+P5]);
				else
					miscrow(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P6], module_arr[offs+P7], module_arr[offs+P4], module_arr[offs+P5]);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], (module_arr[offs+P6]) * (7 + module_arr[offs+P7])+8-module_arr[offs+P7], 7, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_COUNTER: //start
			{
				int wid = counter(module_arr, offs, bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y]);
				if(wid < 8) //Ensure there's a hitbox to grab for repositioning
					wid = 8;
				int tf = (module_arr[offs+M_FLAGS1] & MASK_CNTR_ALIGN)/1L;
				int xoff;
				switch(tf) //start Calculate offsets based on alignment
				{
					case TF_NORMAL: break;
					case TF_CENTERED:
						xoff = -wid/2;
						break;
					case TF_RIGHT:
						xoff = -wid;
						break;
				} //end
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X]+xoff-1, module_arr[offs+M_Y]-1, wid, Text->FontHeight(module_arr[offs+P1]), mod_indx, active, true);
				}
				break;
			} //end
			case MODULE_TYPE_MINITILE: //start
			{
				minitile(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], 10000*(module_arr[offs+M_FLAGS1]&MASK_MINITL_CRN));
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], 7, 7, mod_indx, active, true);
				}
				break;
			} //end
			case MODULE_TYPE_CLOCK: //start
			{
				char32 buf[32];
				sprintf(buf, "%02d:%02d:%02d",time::Hours(),time::Minutes(),time::Seconds());
				int bg = module_arr[offs+P3];
				int shd = module_arr[offs+P4];
				unless(bg) bg = -1;
				int shd_t = module_arr[offs+P5];
				unless(shd) shd_t = SHD_NORMAL;
				bit->DrawString(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], bg, TF_NORMAL, buf, OP_OPAQUE, shd_t, shd);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X]-1, module_arr[offs+M_Y]-1, 1+Text->StringWidth(buf, module_arr[offs+P1]) - (shd_t ? 0 : 1), 1+Text->FontHeight(module_arr[offs+P1])-1, mod_indx, active, true);
				}
				break;
			} //end
			case MODULE_TYPE_ITEMNAME: //start
			{
				char32 buf[64];
				itemdata itm;
				if(SubEditorData[SED_SELECTED] > 0) //start Figure out temp item
				{
					untyped modbuf[MODULE_BUF_SIZE];
					saveModule(modbuf, SubEditorData[SED_SELECTED], active);
					switch(modbuf[M_TYPE])
					{
						case MODULE_TYPE_SEL_ITEM_ID:
						case MODULE_TYPE_NONSEL_ITEM_ID:
						{
							itm = Game->LoadItemData(modbuf[P1]);
							break;
						}
						case MODULE_TYPE_SEL_ITEM_CLASS:
						case MODULE_TYPE_NONSEL_ITEM_CLASS:
						{
							int id = get_item_of_class(modbuf[P1]);
							if(id < 0) id = get_item_of_class(module_arr[offs+P1], true);
							if(id >= 0)
							{
								itm = Game->LoadItemData(id);
								break;
							}
							//fallthrough
						}
						default:
							itm = Game->LoadItemData(0);
							break;
					}
				} //end
				itm->GetName(buf);
				int bg = module_arr[offs+P3];
				int shd = module_arr[offs+P4];
				unless(bg) bg = -1;
				int shd_t = module_arr[offs+P5];
				unless(shd) shd_t = SHD_NORMAL;
				int edwid, edhei;
				int tf = (module_arr[offs+M_FLAGS1] & MASK_ITEMNM_ALIGN)/1L;
				if(module_arr[offs+P6])
				{
					DrawStringsBitmap(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], bg, tf, buf, OP_OPAQUE, shd_t, shd, module_arr[offs+P7], module_arr[offs+P6]);
					edwid = module_arr[offs+P6];
					edhei = DrawStringsCount(module_arr[offs+P1], buf, module_arr[offs+P6]) * (Text->FontHeight(module_arr[offs+P1])+module_arr[offs+P7]) - module_arr[offs+P7];
				}
				else
				{
					bit->DrawString(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], bg, tf, buf, OP_OPAQUE, shd_t, shd);
					edwid = Text->StringWidth(buf, module_arr[offs+P1]);
					edhei = Text->FontHeight(module_arr[offs+P1]);
				}
				int xoff;
				switch(tf) //start Calculate offsets based on alignment
				{
					case TF_NORMAL: break;
					case TF_CENTERED:
						xoff = -edwid/2;
						break;
					case TF_RIGHT:
						xoff = -edwid;
						break;
				} //end
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X]-1+xoff, module_arr[offs+M_Y]-1, edwid + (shd_t ? 1 : 0), edhei, mod_indx, active, true);
				}
				break;
			} //end
			case MODULE_TYPE_DMTITLE: //start
			{
				char32 buf[22];
				getDMapTitle(buf);
				int tstindx;
				for(tstindx = 0; tstindx < 22; ++tstindx)
				{
					switch(buf[tstindx])
					{
						case 0: case ' ': case '\n':
							break;
						default:
							tstindx = 50;
					}
				}
				if(tstindx < 50)
				{
					strcpy(buf, "  Test    \n    Name  ");
				}
				int bg = module_arr[offs+P3];
				int shd = module_arr[offs+P4];
				unless(bg) bg = -1;
				int shd_t = module_arr[offs+P5];
				unless(shd) shd_t = SHD_NORMAL;
				int tf = (module_arr[offs+M_FLAGS1] & MASK_DMTITLE_ALIGN)/1L;
				DrawStringsBitmap(bit, module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], bg, tf, buf, OP_OPAQUE, shd_t, shd, 0, 256);
				int edwid = DrawStringsWid(module_arr[offs+P1], buf, 256);
				int edhei = DrawStringsCount(module_arr[offs+P1], buf, 256) * (Text->FontHeight(module_arr[offs+P1])+0) - 0;
				int xoff;
				switch(tf) //start Calculate offsets based on alignment
				{
					case TF_NORMAL: break;
					case TF_CENTERED:
						xoff = -edwid/2;
						break;
					case TF_RIGHT:
						xoff = -edwid;
						break;
				} //end
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X]-1+xoff, module_arr[offs+M_Y]-1, edwid + (shd_t ? 1 : 0), edhei, mod_indx, active, true);
				}
				break;
			} //end
			
			case MODULE_TYPE_FRAME: //start
			{
				if(module_arr[offs+P1])
					bit->DrawFrame(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P1], module_arr[offs+P2], module_arr[offs+P3], module_arr[offs+P4], true, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P3]*8-1, module_arr[offs+P4]*8-1, mod_indx, active, true);
					anchor(bit, active, module_arr[offs+M_X] + module_arr[offs+P3]*4, module_arr[offs+M_Y] + module_arr[offs+P4]*8 - 1, mod_indx, DIR_DOWN);
					anchor(bit, active, module_arr[offs+M_X] + module_arr[offs+P3]*8 - 1, module_arr[offs+M_Y] + module_arr[offs+P4]*4, mod_indx, DIR_RIGHT);
					anchor(bit, active, module_arr[offs+M_X] + module_arr[offs+P3]*8 - 1, module_arr[offs+M_Y] + module_arr[offs+P4]*8 - 1, mod_indx, DIR_DOWNRIGHT);
				}
				break;
			} //end
			case MODULE_TYPE_RECT: //start
			{
				if(module_arr[offs+P1])
					bit->Rectangle(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P2], module_arr[offs+P3], module_arr[offs+P1], 1, 0, 0, 0, module_arr[offs+M_FLAGS1] & FLAG_RECT_FILL, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], {module_arr[offs+M_X], module_arr[offs+P2]}, {module_arr[offs+M_Y], module_arr[offs+P3]}, mod_indx, active, true);
					anchor(bit, active, (module_arr[offs+M_X] + module_arr[offs+P2]) / 2, module_arr[offs+M_Y], mod_indx, DIR_UP);
					anchor(bit, active, (module_arr[offs+M_X] + module_arr[offs+P2]) / 2, module_arr[offs+P3], mod_indx, DIR_DOWN);
					anchor(bit, active, module_arr[offs+M_X], (module_arr[offs+M_Y] + module_arr[offs+P3]) / 2, mod_indx, DIR_LEFT);
					anchor(bit, active, module_arr[offs+P2], (module_arr[offs+M_Y] + module_arr[offs+P3]) / 2, mod_indx, DIR_RIGHT);
					anchor(bit, active, module_arr[offs+M_X], module_arr[offs+M_Y], mod_indx, DIR_UPLEFT);
					anchor(bit, active, module_arr[offs+P2], module_arr[offs+M_Y], mod_indx, DIR_UPRIGHT);
					anchor(bit, active, module_arr[offs+M_X], module_arr[offs+P3], mod_indx, DIR_DOWNLEFT);
					anchor(bit, active, module_arr[offs+P2], module_arr[offs+P3], mod_indx, DIR_DOWNRIGHT);
				}
				break;
			} //end
			case MODULE_TYPE_CIRC: //start
			{
				if(module_arr[offs+P1])
					bit->Circle(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P2], module_arr[offs+P1], 1, 0, 0, 0, module_arr[offs+M_FLAGS1] & FLAG_CIRC_FILL, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], module_arr[offs+M_X] - module_arr[offs+P2], module_arr[offs+M_Y] - module_arr[offs+P2], 2 * module_arr[offs+P2], 2 * module_arr[offs+P2], mod_indx, active, true);
				}
				break;
			} //end
			case MODULE_TYPE_LINE: //start
			{
				if(module_arr[offs+P1])
					bit->Line(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y],module_arr[offs+P2], module_arr[offs+P3], module_arr[offs+P1], 1, 0, 0, 0, OP_OPAQUE);
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], {module_arr[offs+M_X], module_arr[offs+P2]}, {module_arr[offs+M_Y], module_arr[offs+P3]}, mod_indx, active, true);
					anchor(bit, active, module_arr[offs+M_X], module_arr[offs+M_Y], mod_indx, 0);
					anchor(bit, active, module_arr[offs+P2], module_arr[offs+P3], mod_indx, 1);
				}
				break;
			} //end
			case MODULE_TYPE_TRI: //start
			{
				if(module_arr[offs+P1])
				{
					if(module_arr[offs+M_FLAGS1] & FLAG_TRI_FILL)
					{
						bit->Triangle(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y], module_arr[offs+P2], module_arr[offs+P3], module_arr[offs+P4], module_arr[offs+P5], 0, 0, module_arr[offs+P1], 0, 0, 0, NULL);
					}
					else
					{
						bit->Line(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y],module_arr[offs+P2], module_arr[offs+P3], module_arr[offs+P1], 1, 0, 0, 0, OP_OPAQUE);
						bit->Line(module_arr[offs+M_LAYER], module_arr[offs+M_X], module_arr[offs+M_Y],module_arr[offs+P4], module_arr[offs+P5], module_arr[offs+P1], 1, 0, 0, 0, OP_OPAQUE);
						bit->Line(module_arr[offs+M_LAYER], module_arr[offs+P2], module_arr[offs+P3],module_arr[offs+P4], module_arr[offs+P5], module_arr[offs+P1], 1, 0, 0, 0, OP_OPAQUE);
					}
				}
				if(interactive)
				{
					editorCursor(module_arr[offs+M_LAYER], {module_arr[offs+M_X], module_arr[offs+P2], module_arr[offs+P4]}, {module_arr[offs+M_Y], module_arr[offs+P3], module_arr[offs+P5]}, mod_indx, active, true);
					anchor(bit, active, module_arr[offs+M_X], module_arr[offs+M_Y], mod_indx, 0);
					anchor(bit, active, module_arr[offs+P2], module_arr[offs+P3], mod_indx, 1);
					anchor(bit, active, module_arr[offs+P4], module_arr[offs+P5], mod_indx, 2);
				}
				break;
			} //end
			//case :
		}
	}
	
	bool handleAnchors(bool active, int x, int y)
	{
		unless(SubEditorData[SED_LCLICKING])
		{
			SubEditorData[SED_ANCHOR_MODINDX] = 0;
			SubEditorData[SED_ANCHOR_SUBINDX] = 0;
			return false;
		}
		untyped data = active ? activeData : passiveData;
		int offs = active ? activeModules[SubEditorData[SED_ANCHOR_MODINDX]] : passiveModules[SubEditorData[SED_ANCHOR_MODINDX]];
		x = VBound(x, 255, 0);
		y = VBound(y, 223, 0);
		switch(data[offs+M_TYPE])
		{
			case MODULE_TYPE_FRAME: //start
			{
				//P3 = wid, P4 = hei
				switch(SubEditorData[SED_ANCHOR_SUBINDX])
				{
					case DIR_DOWN:
						data[offs+P4] = VBound(Div(y - data[offs+M_Y], 8), 28, 2);
						break;
					case DIR_RIGHT:
						data[offs+P3] = VBound(Div(x - data[offs+M_X], 8), 32, 2);
						break;
					case DIR_DOWNRIGHT:
						data[offs+P4] = VBound(Div(y - data[offs+M_Y], 8), 28, 2);
						data[offs+P3] = VBound(Div(x - data[offs+M_X], 8), 32, 2);
						break;
				}
				break;
			} //end
			case MODULE_TYPE_RECT: //start
			{
				switch(SubEditorData[SED_ANCHOR_SUBINDX])
				{
					case DIR_UP:
						data[offs+M_Y] = y;
						break;
					case DIR_DOWN:
						data[offs+P3] = y;
						break;
					case DIR_LEFT:
						data[offs+M_X] = x;
						break;
					case DIR_RIGHT:
						data[offs+P2] = x;
						break;
					case DIR_UPLEFT:
						data[offs+M_Y] = y;
						data[offs+M_X] = x;
						break;
					case DIR_UPRIGHT:
						data[offs+M_Y] = y;
						data[offs+P2] = x;
						break;
					case DIR_DOWNLEFT:
						data[offs+P3] = y;
						data[offs+M_X] = x;
						break;
					case DIR_DOWNRIGHT:
						data[offs+P3] = y;
						data[offs+P2] = x;
						break;
				}
				break;
			} //end
			case MODULE_TYPE_LINE: //start
			{
				switch(SubEditorData[SED_ANCHOR_SUBINDX])
				{
					case 0:
						data[offs+M_X] = x;
						data[offs+M_Y] = y;
						break;
					case 1:
						data[offs+P2] = x;
						data[offs+P3] = y;
						break;
				}
				break;
			} //end
			case MODULE_TYPE_TRI: //start
			{
				switch(SubEditorData[SED_ANCHOR_SUBINDX])
				{
					case 0:
						data[offs+M_X] = x;
						data[offs+M_Y] = y;
						break;
					case 1:
						data[offs+P2] = x;
						data[offs+P3] = y;
						break;
					case 2:
						data[offs+P4] = x;
						data[offs+P5] = y;
						break;
				}
				break;
			} //end
		}
		return true;
	}
	
	void handleDragging(bool active)
	{
		int dx, dy;
		if(SubEditorData[SED_ANCHOR_MODINDX] && handleAnchors(active, SubEditorData[SED_MOUSE_X], SubEditorData[SED_MOUSE_Y]+56))
		{
			return;
		}
		if(SubEditorData[SED_LCLICKING] && !SubEditorData[SED_LCLICKED]) //start
		{
			clearPreparedSelector();
			dx = SubEditorData[SED_MOUSE_X] - SubEditorData[SED_LASTMOUSE_X];
			dy = SubEditorData[SED_MOUSE_Y] - SubEditorData[SED_LASTMOUSE_Y];
			// module_arr[M_X] = VBound(module_arr[M_X]+dx, max_x(module_arr), min_x(module_arr));
			// module_arr[M_Y] = VBound(module_arr[M_Y]+dy, max_y(module_arr, active), min_y(module_arr));
			// setModX(mod_indx, active, module_arr[M_X]);
			// setModY(mod_indx, active, module_arr[M_Y]);
		} //end
		else //start Arrow keys
		{
			if(Input->Press[CB_UP])
			{
				dy = -1;
				// module_arr[M_Y] = VBound(module_arr[M_Y]-1, max_y(module_arr, active), min_y(module_arr));
				// setModY(mod_indx, active, module_arr[M_Y]);
			}
			else if(Input->Press[CB_DOWN])
			{
				dy = 1;
				// module_arr[M_Y] = VBound(module_arr[M_Y]+1, max_y(module_arr, active), min_y(module_arr));
				// setModY(mod_indx, active, module_arr[M_Y]);
			}
			if(Input->Press[CB_LEFT])
			{
				dx = -1;
				// module_arr[M_X] = VBound(module_arr[M_X]-1, max_x(module_arr), min_x(module_arr));
				// setModX(mod_indx, active, module_arr[M_X]);
			}
			else if(Input->Press[CB_RIGHT])
			{
				dx = 1;
				// module_arr[M_X] = VBound(module_arr[M_X]+1, max_x(module_arr), min_x(module_arr));
				// setModX(mod_indx, active, module_arr[M_X]);
			}
		} //end
		int sz_indx = active ? NUM_ACTIVE_MODULES : NUM_PASSIVE_MODULES;
		for(int q = 2; q < g_arr[sz_indx]; ++q) //start Limit drag on ALL selected
		{
			unless(mod_flags[q] & MODFLAG_SELECTED) continue;
			untyped arr[MODULE_BUF_SIZE];
			saveModule(arr, q, active);
			int tx = VBound(arr[M_X] + dx, max_x(arr), min_x(arr));
			int ty = VBound(arr[M_Y] + dy, max_y(arr, active), min_y(arr));
			if(tx != arr[M_X] + dx)
			{
				dx = tx - arr[M_X];
			}
			if(ty != arr[M_Y] + dy)
			{
				dy = ty - arr[M_Y];
			}
		} //end
		
		for(int q = 2; q < g_arr[sz_indx]; ++q) //start Actually move the modules
		{
			unless(mod_flags[q] & MODFLAG_SELECTED) continue;
			incModX(q, active, dx);
			incModY(q, active, dy);
		} //end
	}
	
	untyped min_arr(untyped arr)
	{
		untyped min = MAX_FLOAT;
		for(int q = SizeOfArray(arr)-1; q >= 0; --q)
			if(arr[q] < min) min = arr[q];
		return min;
	}
	untyped max_arr(untyped arr)
	{
		untyped max = MIN_FLOAT;
		for(int q = SizeOfArray(arr)-1; q >= 0; --q)
			if(arr[q] > max) max = arr[q];
		return max;
	}
	
	//start editorCursor
	//start overloads
	void editorCursor(int layer, int x_arr, int y_arr, int mod_indx, bool active)
	{
		int mx = min_arr(x_arr), my = min_arr(y_arr);
		editorCursor(layer, mx, my, max_arr(x_arr)-mx, max_arr(y_arr)-my, mod_indx, active, false);
	}
	void editorCursor(int layer, int x_arr, int y_arr, int mod_indx, bool active, bool overlapBorder)
	{
		int mx = min_arr(x_arr), my = min_arr(y_arr);
		editorCursor(layer, mx, my, max_arr(x_arr)-mx, max_arr(y_arr)-my, mod_indx, active, overlapBorder);
	}
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active)
	{
		editorCursor(layer, x, y, wid, hei, mod_indx, active, false);
	}
	//end overloads
	void editorCursor(int layer, int x, int y, int wid, int hei, int mod_indx, bool active, bool overlapBorder)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return; //A GUI pane is open, halt all other cursor action
		//bool overlapBorder = (wid >= 16*3 || hei >= 16*3); //Overlap the border on large (3 tile wide/tall or larger) objects
		int sx = overlapBorder ? x+1 : x, sy = overlapBorder ? y+1 : y, swid = overlapBorder ? wid-2 : wid, shei = overlapBorder ? hei-2 : hei;
		bool onGUI = DIALOG::isHoveringGUI();
		bool isHovering = !onGUI && (active ? DIALOG::DLGCursorBox(x, y, x+wid, y+hei, 0, 56) : DIALOG::DLGCursorBox(x, y, x+wid, y+hei, 0, PASSIVE_EDITOR_TOP - 56));
		if(SubEditorData[SED_ANCHOR_MODINDX] || SubEditorData[SED_TRY_ANCHOR_1])
			return;
		if(isHovering && SubEditorData[SED_LCLICKED]) //Clicking
		{
			SubEditorData[SED_TRY_SELECT] = mod_indx;
		}
		if(SubEditorData[SED_SELECTED] == mod_indx)
		{
			if(keyproc(KEY_DEL) || keyproc(KEY_DEL_PAD))
			{
				if(mod_indx>1 && DIALOG::delwarn())
				{
					SubEditorData[SED_QUEUED_DELETION] = active ? mod_indx : -mod_indx;
					SubEditorData[SED_SELECTED] = 0;
				}
			}
			if(!SubEditorData[SED_LCLICKING] && isHovering)
			{
				clearPreparedSelector();
				if(SubEditorData[SED_RCLICKED]) //RClick
				{
					open_data_pane(mod_indx, active);
					SubEditorData[SED_RCLICKED] = false;
				}
			}
			// else if(SubEditorData[SED_LCLICKED] && !onGUI) //Clicked off
			// {
				// SubEditorData[SED_SELECTED] = 0;
				// return;
			// }
			//DrawSelector(layer, sx, sy, swid, shei, active, false, SEL_RECTANGLE, PAL[COL_HIGHLIGHT]);
		}
		if(mod_flags[mod_indx] & MODFLAG_SELECTED)
			DrawSelector(layer, sx, sy, swid, shei, active, false, SEL_RECTANGLE, PAL[COL_HIGHLIGHT]);
		else if(isHovering)
			DrawSelector(layer, sx, sy, swid, shei, active, true, SEL_RECTANGLE, PAL[COL_CURSOR]);
	}
	//end
	
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
		Game->ClickToFreezeEnabled = false;
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
					case DLG_LOAD:
						DIALOG::load(); //UNFINISHED
						break;
					case DLG_SAVEAS:
						DIALOG::save(); //UNFINISHED
						break;
					//
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
		SubEditorData[SED_MOUSE_X] = Input->Mouse[MOUSE_X];
		SubEditorData[SED_MOUSE_Y] = Input->Mouse[MOUSE_Y];
		SubEditorData[SED_MOUSE_Z] = Input->Mouse[MOUSE_Z];
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
		SubEditorData[SED_LASTMOUSE_X] = SubEditorData[SED_MOUSE_X];
		SubEditorData[SED_LASTMOUSE_Y] = SubEditorData[SED_MOUSE_Y];
		SubEditorData[SED_LASTMOUSE_Z] = SubEditorData[SED_MOUSE_Z];
		if(SubEditorData[SED_TRY_ANCHOR_1])
		{
			SubEditorData[SED_ANCHOR_MODINDX] = SubEditorData[SED_TRY_ANCHOR_1];
			SubEditorData[SED_ANCHOR_SUBINDX] = SubEditorData[SED_TRY_ANCHOR_2];
			for(int q = Max(g_arr[NUM_ACTIVE_MODULES], g_arr[NUM_PASSIVE_MODULES])-1; q >= 0; --q)
				mod_flags[q] ~= MODFLAG_SELECTED;
			mod_flags[SubEditorData[SED_ANCHOR_MODINDX]] |= MODFLAG_SELECTED;
			SubEditorData[SED_SELECTED] = SubEditorData[SED_ANCHOR_MODINDX];
			
			SubEditorData[SED_TRY_SELECT] = 0;
			SubEditorData[SED_TRY_ANCHOR_1] = 0;
			SubEditorData[SED_TRY_ANCHOR_2] = 0;
		}
		else if(SubEditorData[SED_TRY_SELECT])
		{
			unless((mod_flags[SubEditorData[SED_TRY_SELECT]] & MODFLAG_SELECTED) || keyproc(KEY_LSHIFT) || keyproc(KEY_RSHIFT))
			{
				for(int q = Max(g_arr[NUM_ACTIVE_MODULES], g_arr[NUM_PASSIVE_MODULES])-1; q >= 0; --q)
					mod_flags[q] ~= MODFLAG_SELECTED;
			}
			mod_flags[SubEditorData[SED_TRY_SELECT]] |= MODFLAG_SELECTED;
			SubEditorData[SED_SELECTED] = SubEditorData[SED_TRY_SELECT];
			SubEditorData[SED_TRY_SELECT] = 0;
			SubEditorData[SED_ANCHOR_MODINDX] = 0;
			SubEditorData[SED_ANCHOR_SUBINDX] = 0;
		}
		else if(SubEditorData[SED_LCLICKED] && !DIALOG::isHoveringGUI())
		{
			for(int q = Max(g_arr[NUM_ACTIVE_MODULES], g_arr[NUM_PASSIVE_MODULES])-1; q >= 0; --q)
				mod_flags[q] ~= MODFLAG_SELECTED;
			SubEditorData[SED_SELECTED] = 0;
			SubEditorData[SED_TRY_SELECT] = 0;
			SubEditorData[SED_ANCHOR_MODINDX] = 0;
			SubEditorData[SED_ANCHOR_SUBINDX] = 0;
		}
		DrawCursor();
		
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
	void DrawCursor()
	{
		DrawCursor(SubEditorData[SED_MOUSE_X], SubEditorData[SED_MOUSE_Y]);
	}
	void DrawCursor(bitmap b, int x, int y)
	{
		if(sys_settings[SSET_CURSORTILE] > 0)
		{
			b->FastTile(7, x, y, sys_settings[SSET_CURSORTILE], sys_settings[SSET_CURSORCSET], OP_OPAQUE);
		}
		else
		{
			DrawCursor(b, x, y, sys_settings[SSET_CURSOR_VER]);
		}
	}
	void DrawCursor(int x, int y)
	{
		if(sys_settings[SSET_CURSORTILE] > 0)
		{
			Screen->FastTile(7, x, y, sys_settings[SSET_CURSORTILE], sys_settings[SSET_CURSORCSET], OP_OPAQUE);
		}
		else
		{
			DrawCursor(x, y, sys_settings[SSET_CURSOR_VER]);
		}
	}
	enum CursorType
	{
		CT_BASIC, CT_STICK
	};
	void DrawCursor(int x, int y, CursorType type)
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
	void DrawCursor(bitmap b, int x, int y, CursorType type)
	{
		switch(type)
		{
			case CT_STICK:
				b->Line(7, x, y, x+3, y, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				b->Line(7, x, y, x, y+3, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				b->Line(7, x, y, x+4, y+4, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
				break;
			case CT_BASIC:
			default:
				b->Triangle(7, x, y, x+4, y, x, y+4, 0, 0, PAL[COL_CURSOR], 0, 0, 0, NULL);
				b->Line(7, x, y, x+5, y+5, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
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
			case MODULE_TYPE_BUTTONITEM:
			case MODULE_TYPE_NONSEL_ITEM_ID:
			case MODULE_TYPE_NONSEL_ITEM_CLASS:
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_BUTTONITEM?get_btn_itm(module_arr[P1]):((module_arr[M_TYPE]==MODULE_TYPE_SEL_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 256-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitWidth) id->HitWidth = 16;
				unless(id->TileWidth) id->TileWidth = 1;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset),
					twid = (hit ? id->HitWidth : id->TileWidth*16);
				return 256 - xoffs - twid;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return 0;
			case MODULE_TYPE_BGCOLOR:
				return 0;
			case MODULE_TYPE_BIGMAP:
				return 256 - (16 * 7);
			case MODULE_TYPE_MINIMAP:
				return 256 - (16 * 5);
			case MODULE_TYPE_TILEBLOCK:
				return 256 - (16 * module_arr[P3]);
			case MODULE_TYPE_HEART:
			case MODULE_TYPE_MAGIC:
			case MODULE_TYPE_CRPIECE:
				return 256 - 8;
			case MODULE_TYPE_HEARTROW:
			case MODULE_TYPE_MAGICROW:
				return 256 - ((module_arr[P4]) * (7 + module_arr[P5])+8-module_arr[P5]);
			case MODULE_TYPE_CRROW:
				return 256 - ((module_arr[P6]) * (7 + module_arr[P7])+8-module_arr[P7]);
			case MODULE_TYPE_COUNTER:
				char32 buf[6];
				for(int q = module_arr[P5]-1; q>=0; --q)
					buf[q] = '0';
				int wid = Text->StringWidth(buf, module_arr[P1]);
				switch((module_arr[M_FLAGS1] & MASK_CNTR_ALIGN)/1L)
				{
					case TF_RIGHT:
						return 255;
					case TF_CENTERED:
						return 256-(wid/2);
				}
				return 256-wid;
			case MODULE_TYPE_MINITILE:
				return 256-8;
			case MODULE_TYPE_CLOCK:
				char32 buf[32];
				sprintf(buf, "%02d:%02d:%02d",time::Hours(),time::Minutes(),time::Seconds());
				return 256-Text->StringWidth(buf,module_arr[P1]);
			case MODULE_TYPE_ITEMNAME:
			case MODULE_TYPE_DMTITLE:
				return 255;
			case MODULE_TYPE_FRAME:
				return 256 - module_arr[P3]*8;
			case MODULE_TYPE_CIRC:
				return 256 - module_arr[P2];
			case MODULE_TYPE_RECT:
			case MODULE_TYPE_LINE:
				if(module_arr[P2] > module_arr[M_X])
					return 256 - (module_arr[P2] - module_arr[M_X]);
				else return 255;
			case MODULE_TYPE_TRI:
				int mx = Max(module_arr[P2], module_arr[P4]);
				if(mx > module_arr[M_X])
					return 256 - (mx - module_arr[M_X]);
				else return 255;
		}
		return 256-16;
	}
	
	int min_x(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_BUTTONITEM:
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_BUTTONITEM?get_btn_itm(module_arr[P1]):((module_arr[M_TYPE]==MODULE_TYPE_SEL_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int xoffs = (hit ? id->HitXOffset : id->DrawXOffset);
				return 0 - xoffs;
			case MODULE_TYPE_COUNTER:
				char32 buf[6];
				for(int q = module_arr[P5]-1; q>=0; --q)
					buf[q] = '0';
				int wid = Text->StringWidth(buf, module_arr[P1]);
				switch((module_arr[M_FLAGS1] & MASK_CNTR_ALIGN)/1L)
				{
					case TF_NORMAL:
						return 0;
					case TF_CENTERED:
						return (wid/2);
				}
				return wid;
			case MODULE_TYPE_CIRC:
				return module_arr[P2];
			case MODULE_TYPE_RECT:
			case MODULE_TYPE_LINE:
				if(module_arr[P2] < module_arr[M_X])
					return (module_arr[M_X] - module_arr[P2]);
				else return 0;
			case MODULE_TYPE_TRI:
				int mx = Min(module_arr[P2], module_arr[P4]);
				if(mx < module_arr[M_X])
					return (module_arr[M_X] - mx);
				else return 0;
		}
		return 0;
	}
	
	int max_y(untyped module_arr, bool active)
	{
		itemdata id;
		DEFINE _BOTTOM = (active ? 224 : 56);
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_BUTTONITEM:
			case MODULE_TYPE_NONSEL_ITEM_ID:
			case MODULE_TYPE_NONSEL_ITEM_CLASS:
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS:
			{
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_BUTTONITEM?get_btn_itm(module_arr[P1]):((module_arr[M_TYPE]==MODULE_TYPE_SEL_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return _BOTTOM-16;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				unless(id->HitHeight) id->HitHeight = 16;
				unless(id->TileHeight) id->TileHeight = 1;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset),
					thei = (hit ? id->HitHeight : id->TileHeight*16);
				return _BOTTOM - yoffs - thei;
			}
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return _BOTTOM-56;
			case MODULE_TYPE_BGCOLOR:
				return 0;
			case MODULE_TYPE_BIGMAP:
				return _BOTTOM - (16 * 5);
			case MODULE_TYPE_MINIMAP:
				return _BOTTOM - (16 * 3);
			case MODULE_TYPE_TILEBLOCK:
				return _BOTTOM - (16 * module_arr[P4]);
			case MODULE_TYPE_HEARTROW:
			case MODULE_TYPE_HEART:
			case MODULE_TYPE_MAGICROW:
			case MODULE_TYPE_MAGIC:
			case MODULE_TYPE_CRROW:
			case MODULE_TYPE_CRPIECE:
			case MODULE_TYPE_MINITILE:
				return _BOTTOM - 8;
			case MODULE_TYPE_COUNTER:
			case MODULE_TYPE_CLOCK:
			case MODULE_TYPE_ITEMNAME:
				return _BOTTOM - Text->FontHeight(module_arr[P1]);
			case MODULE_TYPE_DMTITLE:
				return _BOTTOM - (Text->FontHeight(module_arr[P1])*2);
			case MODULE_TYPE_FRAME:
				return _BOTTOM - module_arr[P4]*8;
			case MODULE_TYPE_CIRC:
				return _BOTTOM - module_arr[P2];
			case MODULE_TYPE_RECT:
			case MODULE_TYPE_LINE:
				if(module_arr[P3] > module_arr[M_Y])
					return _BOTTOM - (module_arr[P3] - module_arr[M_Y]);
				else return _BOTTOM - 1;
			case MODULE_TYPE_TRI:
				int my = Max(module_arr[P3], module_arr[P5]);
				if(my > module_arr[M_Y])
					return _BOTTOM - (my - module_arr[M_Y]);
				else return _BOTTOM - 1;
		}
		return _BOTTOM-16;
	}
	
	int min_y(untyped module_arr)
	{
		itemdata id;
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_BUTTONITEM:
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS:
				int itm = (module_arr[M_TYPE]==MODULE_TYPE_BUTTONITEM?get_btn_itm(module_arr[P1]):((module_arr[M_TYPE]==MODULE_TYPE_SEL_ITEM_ID?module_arr[P1]:get_item_of_class(module_arr[P1]))));
				unless(itm > 0) return 0;
				itemdata id = Game->LoadItemData(itm);
				//
				bool hit = activeData[STTNG_FLAGS1]&FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR;
				int yoffs = (hit ? id->HitYOffset : id->DrawYOffset);
				return 0 - yoffs;
			case MODULE_TYPE_CIRC:
				return module_arr[P2];
			case MODULE_TYPE_RECT:
			case MODULE_TYPE_LINE:
				if(module_arr[P3] < module_arr[M_Y])
					return (module_arr[M_Y] - module_arr[P3]);
				else return 0;
			case MODULE_TYPE_TRI:
				int my = Min(module_arr[P3], module_arr[P5]);
				if(my < module_arr[M_Y])
					return (module_arr[M_Y] - my);
				else return 0;
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
	//start Module Validation
	bool ver_check(untyped module_arr)
	{
		int cur_ver;
		int compat_ver;
		switch(module_arr[M_TYPE]) //start
		{
			case MODULE_TYPE_SETTINGS:
				cur_ver = MVER_SETTINGS;
				compat_ver = C_MVER_SETTINGS;
				break;
			case MODULE_TYPE_BGCOLOR:
				cur_ver = MVER_BGCOLOR;
				compat_ver = C_MVER_BGCOLOR;
				break;
			case MODULE_TYPE_SEL_ITEM_ID:
				cur_ver = MVER_SEL_ITEM_ID;
				compat_ver = C_MVER_SEL_ITEM_ID;
				break;
			case MODULE_TYPE_SEL_ITEM_CLASS:
				cur_ver = MVER_SEL_ITEM_CLASS;
				compat_ver = C_MVER_SEL_ITEM_CLASS;
				break;
			case DEPR_MODULE_TYPE_BBUTTONITEM:
				return false;
			case MODULE_TYPE_PASSIVESUBSCREEN:
				cur_ver = MVER_PASSIVESUBSCREEN;
				compat_ver = C_MVER_PASSIVESUBSCREEN;
				break;
			case MODULE_TYPE_MINIMAP:
				cur_ver = MVER_MINIMAP;
				compat_ver = C_MVER_MINIMAP;
				break;
			case MODULE_TYPE_BIGMAP:
				cur_ver = MVER_BIGMAP;
				compat_ver = C_MVER_BIGMAP;
				break;
			case MODULE_TYPE_TILEBLOCK:
				cur_ver = MVER_TILEBLOCK;
				compat_ver = C_MVER_TILEBLOCK;
				break;
			case MODULE_TYPE_HEART:
				cur_ver = MVER_HEART;
				compat_ver = C_MVER_HEART;
				break;
			case MODULE_TYPE_HEARTROW:
				cur_ver = MVER_HEARTROW;
				compat_ver = C_MVER_HEARTROW;
				break;
			case MODULE_TYPE_COUNTER:
				cur_ver = MVER_COUNTER;
				compat_ver = C_MVER_COUNTER;
				break;
			case MODULE_TYPE_MINITILE:
				cur_ver = MVER_MINITILE;
				compat_ver = C_MVER_MINITILE;
				break;
			case MODULE_TYPE_NONSEL_ITEM_ID:
				cur_ver = MVER_NONSEL_ITEM_ID;
				compat_ver = C_MVER_NONSEL_ITEM_ID;
				break;
			case MODULE_TYPE_NONSEL_ITEM_CLASS:
				cur_ver = MVER_NONSEL_ITEM_CLASS;
				compat_ver = C_MVER_NONSEL_ITEM_CLASS;
				break;
			case MODULE_TYPE_CLOCK:
				cur_ver = MVER_CLOCK;
				compat_ver = C_MVER_CLOCK;
				break;
			case MODULE_TYPE_ITEMNAME:
				cur_ver = MVER_ITEMNAME;
				compat_ver = C_MVER_ITEMNAME;
				break;
			case MODULE_TYPE_DMTITLE:
				cur_ver = MVER_DMTITLE;
				compat_ver = C_MVER_DMTITLE;
				break;
			case MODULE_TYPE_MAGIC:
				cur_ver = MVER_MAGIC;
				compat_ver = C_MVER_MAGIC;
				break;
			case MODULE_TYPE_MAGICROW:
				cur_ver = MVER_MAGICROW;
				compat_ver = C_MVER_MAGICROW;
				break;
			case MODULE_TYPE_CRPIECE:
				cur_ver = MVER_CRPIECE;
				compat_ver = C_MVER_CRPIECE;
				break;
			case MODULE_TYPE_CRROW:
				cur_ver = MVER_CRROW;
				compat_ver = C_MVER_CRROW;
				break;
			case MODULE_TYPE_FRAME:
				cur_ver = MVER_FRAME;
				compat_ver = C_MVER_FRAME;
				break;
			case MODULE_TYPE_RECT:
				cur_ver = MVER_RECT;
				compat_ver = C_MVER_RECT;
				break;
			case MODULE_TYPE_CIRC:
				cur_ver = MVER_CIRC;
				compat_ver = C_MVER_CIRC;
				break;
			case MODULE_TYPE_LINE:
				cur_ver = MVER_LINE;
				compat_ver = C_MVER_LINE;
				break;
			case MODULE_TYPE_TRI:
				cur_ver = MVER_TRI;
				compat_ver = C_MVER_TRI;
				break;
		} //end
		if(module_arr[M_VER] < compat_ver)
		{
			if(DEBUG)
			{
				error("Module type %d version incompatible; cannot be loaded. Version: Currently %d, Compatible back to %d, found %d\n", module_arr[M_TYPE], cur_ver, compat_ver, module_arr[M_VER]);
			}
			return false;
		}
		return true;
	}
	bool metaver_check(untyped module_arr) //start Check metadata version
	{
		if(module_arr[M_META_SIZE] < MODULE_META_SIZE)
		{
			switch(module_arr[M_META_SIZE])
			{
				case 8:
					for(int q = module_arr[M_SIZE]; q > M_VER; --q)
					{
						module_arr[q] = module_arr[q-1];
					}
					module_arr[M_VER] = 1;
					++module_arr[M_META_SIZE];
					++module_arr[M_SIZE];
					//fallthrough
				case 9:
					for(int q = module_arr[M_SIZE]+2; q > M_CNDTYPE; --q)
					{
						module_arr[q] = module_arr[q-3];
					}
					module_arr[M_CNDTYPE] = COND_NONE;
					module_arr[M_CND1] = 0;
					module_arr[M_CND2] = 0;
					module_arr[M_META_SIZE] += 3;
					module_arr[M_SIZE] += 3;
					//fallthrough
			}
			
			return true;
		}
		else if(module_arr[M_META_SIZE] > MODULE_META_SIZE)
		{
			if(DEBUG)
				error("Module meta size too large! Cannot load module from a future version!");
			return false;
		}
		return true;
	} //end
	/*
	 * Returns true if the passed module is valid for an active subscreen.
	 * This has separate handling per module type, ensuring that individual requirements are met.
	 */
	bool validate_active_module(untyped module_arr) //start
	{
		unless(metaver_check(module_arr))
		{
			if(DEBUG)
				error("Metaver check failed for module");
			return false;
		}
		unless(ver_check(module_arr))
		{
			if(DEBUG)
				error("Version check failed for module");
			return false;
		}
		moduleType type = module_arr[M_TYPE];
		switch(type)
		{
			case MODULE_TYPE_BGCOLOR: //start
			{
				if(module_arr[M_SIZE]!=P1+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_BGCOLOR (%d) must have argument size (1) in format {COLOR}; argument size %d found", MODULE_TYPE_BGCOLOR, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[M_LAYER]!=0)
				{
					if(DEBUG)
						error("MODULE_TYPE_BGCOLOR (%d) must use layer 0; %d found", MODULE_TYPE_BGCOLOR, module_arr[M_LAYER]);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 0xFF || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BGCOLOR (%d) argument 1 (COLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BGCOLOR, module_arr[P1]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_NONSEL_ITEM_ID: //start
			{
				if(module_arr[M_SIZE]!=P1+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_NONSEL_ITEM_ID (%d) must have argument size (2) in format {META..., ITEMID}; argument size %d found", MODULE_TYPE_NONSEL_ITEM_ID, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < MIN_ITEMDATA || module_arr[P1] > MAX_ITEMDATA || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_NONSEL_ITEM_ID (%d) argument 1 (ITEMID) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_NONSEL_ITEM_ID, MAX_ITEMDATA, module_arr[P1]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_NONSEL_ITEM_CLASS: //start
			{
				if(module_arr[M_SIZE]!=P1+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_NONSEL_ITEM_CLASS (%d) must have argument size (2) in format {META..., ITEMID}; argument size %d found", MODULE_TYPE_NONSEL_ITEM_CLASS, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_NONSEL_ITEM_CLASS (%d) argument 1 (ITEMCLASS) must be a positive integer; found %d", MODULE_TYPE_NONSEL_ITEM_CLASS, module_arr[P1]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_SEL_ITEM_ID: //start
			{
				if(module_arr[M_SIZE]!=P6+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_SEL_ITEM_ID (%d) must have argument size (6) in format {ITEMID, POS, UP, DOWN, LEFT, RIGHT}; argument size %d found", MODULE_TYPE_SEL_ITEM_ID, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < MIN_ITEMDATA || module_arr[P1] > MAX_ITEMDATA || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 1 (ITEMID) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_SEL_ITEM_ID, MAX_ITEMDATA, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < -1 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 2 (POS) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_ID, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < -1 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 3 (UP) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_ID, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < -1 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 4 (DOWN) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_ID, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < -1 || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 5 (LEFT) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_ID, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < -1 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_ID (%d) argument 6 (RIGHT) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_ID, module_arr[P6]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_SEL_ITEM_CLASS: //start
			{
				if(module_arr[M_SIZE]!=P6+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) must have argument size (6) in format {ITEMCLASS, POS, UP, DOWN, LEFT, RIGHT}; argument size %d found", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 1 (ITEMCLASS) must be a positive integer; found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < -1 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 2 (POS) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < -1 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 3 (UP) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < -1 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 4 (DOWN) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < -1 || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 5 (LEFT) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < -1 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_SEL_ITEM_CLASS (%d) argument 6 (RIGHT) must be an integer (>= -1); found %d", MODULE_TYPE_SEL_ITEM_CLASS, module_arr[P6]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_SETTINGS:
			{
				return module_arr[M_SIZE] >= MODULE_META_SIZE;
			}
			
			case MODULE_TYPE_PASSIVESUBSCREEN:
				return true;
			
			case MODULE_TYPE_MINIMAP: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						if(module_arr[M_FLAGS1] & FLAG_MMP_SHOW_EXPLORED_ROOMS_OW)
						{
							module_arr[M_FLAGS1] |= FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW;
						}
						//fallthrough
					} //end
					
					case 2: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P10+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_MINIMAP (%d) must have argument size (10) in format {META..., POSCOLOR, EXPLCOLOR, UNEXPLCOLOR, COMPCOLOR, COMP_DEFEATEDCOLOR, BLINKRATE, 16x8TILE, 16x8CSET, 8x8TILE, 8x8CSET}; argument size %d found", MODULE_TYPE_MINIMAP, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 0xFF || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 1 (POSCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 0xFF || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 2 (EXPLCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 0xFF || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 3 (UNEXPLCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 0xFF || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 4 (COMPCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 0xFF || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 5 (COMP_DEFEATEDCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < 1 || module_arr[P6] > 9 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 6 (BLINKRATE) must be an integer between (1) and (9), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P6]);
					}
					return false;
				}
				if(module_arr[P7] < 0 || module_arr[P7] > MAX_TILE || (module_arr[P7]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 7 (16x8TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_MINIMAP, MAX_TILE, module_arr[P7]);
					}
					return false;
				}
				if(module_arr[P8] < 0 || module_arr[P8] > 11 || (module_arr[P8]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 8 (16x8CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P8]);
					}
					return false;
				}
				if(module_arr[P9] < 0 || module_arr[P9] > MAX_TILE || (module_arr[P9]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 9 (8x8TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_MINIMAP, MAX_TILE, module_arr[P9]);
					}
					return false;
				}
				if(module_arr[P10] < 0 || module_arr[P10] > 11 || (module_arr[P10]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINIMAP (%d) argument 10 (8x8CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_MINIMAP, module_arr[P10]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_BIGMAP: //start
			{
				if(module_arr[M_SIZE]!=P10+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_BIGMAP (%d) must have argument size (10) in format {META..., POSCOLOR, EXPLCOLOR, UNEXPLCOLOR, COMPCOLOR, COMP_DEFEATEDCOLOR, BLINKRATE, 16x8TILE, 16x8CSET, 8x8TILE, 8x8CSET}; argument size %d found", MODULE_TYPE_BIGMAP, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 0xFF || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 1 (POSCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 0xFF || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 2 (EXPLCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 0xFF || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 3 (UNEXPLCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 0xFF || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 4 (COMPCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 0xFF || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 5 (COMP_DEFEATEDCOLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < 1 || module_arr[P6] > 9 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 6 (BLINKRATE) must be an integer between (1) and (9), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P6]);
					}
					return false;
				}
				if(module_arr[P7] < 0 || module_arr[P7] > MAX_TILE || (module_arr[P7]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 7 (16x8TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_BIGMAP, MAX_TILE, module_arr[P7]);
					}
					return false;
				}
				if(module_arr[P8] < 0 || module_arr[P8] > 11 || (module_arr[P8]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 8 (16x8CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P8]);
					}
					return false;
				}
				if(module_arr[P9] < 0 || module_arr[P9] > MAX_TILE || (module_arr[P9]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 9 (8x8TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_BIGMAP, MAX_TILE, module_arr[P9]);
					}
					return false;
				}
				if(module_arr[P10] < 0 || module_arr[P10] > 11 || (module_arr[P10]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_BIGMAP (%d) argument 10 (8x8CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_BIGMAP, module_arr[P10]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_TILEBLOCK: //start
			{
				if(module_arr[M_SIZE]!=P4+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_TILEBLOCK (%d) must have argument size (4) in format {META..., TILE, CSET, WID, HEI}; argument size %d found", MODULE_TYPE_TILEBLOCK, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_TILEBLOCK (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_TILEBLOCK, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_TILEBLOCK (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_TILEBLOCK, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 1 || module_arr[P3] > 16 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_TILEBLOCK (%d) argument 3 (WID) must be an integer between (1) and (16), inclusive; found %d", MODULE_TYPE_TILEBLOCK, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 1 || module_arr[P4] > 14 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_TILEBLOCK (%d) argument 4 (HEI) must be an integer between (1) and (14), inclusive; found %d", MODULE_TYPE_TILEBLOCK, module_arr[P4]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_HEART: //start
			{
				if(module_arr[M_SIZE]!=P3+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_HEART (%d) must have argument size (3) in format {META..., TILE, CSET, CONTAINER_NUM}; argument size %d found", MODULE_TYPE_HEART, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEART (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_HEART, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEART (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_HEART, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEART (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_HEART, module_arr[P3]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_HEARTROW: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_HEARTROW (%d) must have argument size (5) in format {META..., TILE, CSET, CONTAINER_NUM, COUNT, SPACING}; argument size %d found", MODULE_TYPE_HEARTROW, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEARTROW (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_HEARTROW, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEARTROW (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_HEARTROW, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEARTROW (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_HEARTROW, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 1 || module_arr[P4] > 32 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEARTROW (%d) argument 4 (COUNT) must be an integer between (1) and (32), inclusive; found %d", MODULE_TYPE_HEARTROW, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5]%1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_HEARTROW (%d) argument 5 (SPACING) must be an integer; found %d", MODULE_TYPE_HEARTROW, module_arr[P5]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_COUNTER: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_SIZE] = P9+1;
						if(module_arr[M_FLAGS1] & FLAG4)
						{
							module_arr[P9] = SHD_SHADOWED;
							module_arr[M_FLAGS1] ~= FLAG4;
						}
						//fallthrough
					} //end
					case 2: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P9+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_COUNTER (%d) must have argument size (9) in format: {META..., FONT, CNTR, INFITEM, INFCHAR, MINDIG, TXTCOL, BGCOL, SHADCOL, SHADTYPE}; argument size %d found", MODULE_TYPE_COUNTER, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 1 (FONT) must be a positive integer; found %d", MODULE_TYPE_COUNTER, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[M_FLAGS1] & FLAG_CNTR_SPECIAL)
				{
					if(module_arr[P2] < 0 || module_arr[P2] >= CNTR_MAX_SPECIAL || module_arr[P2] % 1)
					{
						if(DEBUG)
						{
							error("MODULE_TYPE_COUNTER (%d) argument 2 (CNTR), when FLAG_CNTR_SPECIAL is set, must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_COUNTER, CNTR_MAX_SPECIAL-1, module_arr[P2]);
						}
						return false;
					}
				}
				else
				{
					if(module_arr[P2] < 0 || module_arr[P2] % 1)
					{
						if(DEBUG)
						{
							error("MODULE_TYPE_COUNTER (%d) argument 2 (CNTR) must be a positive integer; found %d", MODULE_TYPE_COUNTER, module_arr[P2]);
						}
						return false;
					}
				}
				if(module_arr[P3] < MIN_ITEMDATA || module_arr[P3] > MAX_ITEMDATA || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 3 (INFITEM) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_COUNTER, MAX_ITEMDATA, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 255 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 4 (INFCHAR) must be a valid character; found %d ('%c')", MODULE_TYPE_COUNTER, module_arr[P4], module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 5 || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 5 (MINDIG) must be an integer between (0) and (5), inclusive; found %d", MODULE_TYPE_COUNTER, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < 0 || module_arr[P6] > 0xFF || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 6 (TXTCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_COUNTER, module_arr[P6]);
					}
					return false;
				}
				if(module_arr[P7] < 0 || module_arr[P7] > 0xFF || (module_arr[P7]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 7 (BGCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_COUNTER, module_arr[P7]);
					}
					return false;
				}
				if(module_arr[P8] < 0 || module_arr[P8] > 0xFF || (module_arr[P8]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 8 (SHADCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_COUNTER, module_arr[P8]);
					}
					return false;
				}
				if(module_arr[P9] < 0 || module_arr[P9] > 0xFF || (module_arr[P9]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_COUNTER (%d) argument 9 (SHADOWTYPE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_COUNTER, SHD_MAX, module_arr[P8]);
					}
					return false;
				}
				return true;
			} //end
			
			case MODULE_TYPE_MINITILE: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P2+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_MINITILE (%d) must have argument size (5) in format {META..., TILE, CSET, CONTAINER_NUM, COUNT, SPACING}; argument size %d found", MODULE_TYPE_MINITILE, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINITILE (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_MINITILE, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MINITILE (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_MINITILE, module_arr[P2]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_CLOCK: //start
			{
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_CLOCK (%d) must have argument size (5) in format: {META..., FONT, TXTCOL, BGCOL, SHADCOL, SHADOWTYPE}; argument size %d found", MODULE_TYPE_CLOCK, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CLOCK (%d) argument 1 (FONT) must be a positive integer; found %d", MODULE_TYPE_CLOCK, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 0xFF || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CLOCK (%d) argument 2 (TXTCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_CLOCK, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 0xFF || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CLOCK (%d) argument 3 (BGCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_CLOCK, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 0xFF || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CLOCK (%d) argument 4 (SHADCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_CLOCK, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 0xFF || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CLOCK (%d) argument 5 (SHADOWTYPE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_CLOCK, SHD_MAX, module_arr[P8]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_ITEMNAME: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P7+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_ITEMNAME (%d) must have argument size (7) in format: {META..., FONT, TXTCOL, BGCOL, SHADCOL, SHADOWTYPE, MAXWID, VSPACE}; argument size %d found", MODULE_TYPE_ITEMNAME, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 1 (FONT) must be a positive integer; found %d", MODULE_TYPE_ITEMNAME, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 0xFF || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 2 (TXTCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_ITEMNAME, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 0xFF || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 3 (BGCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_ITEMNAME, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 0xFF || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 4 (SHADCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_ITEMNAME, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 0xFF || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 5 (SHADOWTYPE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_ITEMNAME, SHD_MAX, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < 0 || module_arr[P6] > 256 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 6 (WIDTH) must be an integer between (0) and (256), inclusive; found %d", MODULE_TYPE_ITEMNAME, module_arr[P6]);
					}
					return false;
				}
				if(module_arr[P7] < 0 || module_arr[P7] > 16 || (module_arr[P7]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_ITEMNAME (%d) argument 7 (VSPACE) must be an integer between (0) and (16), inclusive; found %d", MODULE_TYPE_ITEMNAME, module_arr[P7]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_DMTITLE: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_DMTITLE (%d) must have argument size (5) in format: {META..., FONT, TXTCOL, BGCOL, SHADCOL, SHADOWTYPE}; argument size %d found", MODULE_TYPE_DMTITLE, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_DMTITLE (%d) argument 1 (FONT) must be a positive integer; found %d", MODULE_TYPE_DMTITLE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 0xFF || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_DMTITLE (%d) argument 2 (TXTCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_DMTITLE, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 0xFF || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_DMTITLE (%d) argument 3 (BGCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_DMTITLE, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 0xFF || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_DMTITLE (%d) argument 4 (SHADCOL) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_DMTITLE, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 0xFF || (module_arr[P5]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_DMTITLE (%d) argument 5 (SHADOWTYPE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_DMTITLE, SHD_MAX, module_arr[P5]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_MAGIC: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P3+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_MAGIC (%d) must have argument size (3) in format {META..., TILE, CSET, CONTAINER_NUM}; argument size %d found", MODULE_TYPE_MAGIC, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGIC (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_MAGIC, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGIC (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_MAGIC, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGIC (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_MAGIC, module_arr[P3]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_MAGICROW: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_MAGICROW (%d) must have argument size (5) in format {META..., TILE, CSET, CONTAINER_NUM, COUNT, SPACING}; argument size %d found", MODULE_TYPE_MAGICROW, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGICROW (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_MAGICROW, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGICROW (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_MAGICROW, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGICROW (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_MAGICROW, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 1 || module_arr[P4] > 32 || (module_arr[P4]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGICROW (%d) argument 4 (COUNT) must be an integer between (1) and (32), inclusive; found %d", MODULE_TYPE_MAGICROW, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5]%1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_MAGICROW (%d) argument 5 (SPACING) must be an integer; found %d", MODULE_TYPE_MAGICROW, module_arr[P5]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_CRPIECE: //start
			{
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_CRPIECE (%d) must have argument size (5) in format {META..., TILE, CSET, CONTAINER_NUM, COUNTER, PER_CONT, COUNTER, PER_CONT}; argument size %d found", MODULE_TYPE_CRPIECE, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRPIECE (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_CRPIECE, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRPIECE (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_CRPIECE, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRPIECE (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_CRPIECE, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRPIECE (%d) argument 4 (COUNTER) must be a positive integer; found %d", MODULE_TYPE_CRPIECE, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] <= 0 || module_arr[P5] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRPIECE (%d) argument 5 (PER_CONT) must be an integer above (0); found %d", MODULE_TYPE_CRPIECE, module_arr[P5]);
					}
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_CRROW: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_FLAGS1] * 1L; //Convert to 'long'
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P7+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_CRROW (%d) must have argument size (7) in format {META..., TILE, CSET, CONTAINER_NUM, COUNTER, PER_CONT, COUNT, SPACING}; argument size %d found", MODULE_TYPE_CRROW, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > MAX_TILE || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 1 (TILE) must be an integer between (0) and (%d), inclusive; found %d", MODULE_TYPE_CRROW, MAX_TILE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_CRROW, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 0 || (module_arr[P3]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 3 (CONTAINER_NUM) must be an integer above (0); found %d", MODULE_TYPE_CRROW, module_arr[P3]);
					}
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 4 (COUNTER) must be a positive integer; found %d", MODULE_TYPE_CRROW, module_arr[P4]);
					}
					return false;
				}
				if(module_arr[P5] <= 0 || module_arr[P5] % 1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 5 (PER_CONT) must be an integer above (0); found %d", MODULE_TYPE_CRROW, module_arr[P5]);
					}
					return false;
				}
				if(module_arr[P6] < 1 || module_arr[P6] > 32 || (module_arr[P6]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 6 (COUNT) must be an integer between (1) and (32), inclusive; found %d", MODULE_TYPE_CRROW, module_arr[P6]);
					}
					return false;
				}
				if(module_arr[P7]%1)
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CRROW (%d) argument 7 (SPACING) must be an integer; found %d", MODULE_TYPE_CRROW, module_arr[P7]);
					}
					return false;
				}
				return true;
			} //end
			
			case DEPR_MODULE_TYPE_BBUTTONITEM: //start
			{
				module_arr[M_TYPE] = MODULE_TYPE_BUTTONITEM;
				module_arr[M_VER] = 2;
				module_arr[M_SIZE] = P1+1;
				module_arr[P1] = CB_B;
			} //end
			//fallthrough
			case MODULE_TYPE_BUTTONITEM: //start
			{
				switch(module_arr[M_VER])
				{
					case 1: //start
					{
						++module_arr[M_VER];
						module_arr[M_SIZE] = P1+1;
						module_arr[P1] = CB_A;
						//fallthrough
					} //end
				}
				if(module_arr[M_SIZE]!=P1+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_BUTTONITEM (%d) must have argument size (1) in format {BUTTON}; argument size %d found", MODULE_TYPE_BUTTONITEM, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				switch(module_arr[P1])
				{
					case CB_A: case CB_B: case CB_L: case CB_R: case CB_EX1: case CB_EX2: case CB_EX3: case CB_EX4:
						break;
					default:
					{
						if(DEBUG)
						{
							error("MODULE_TYPE_BUTTONITEM (%d) argument 1 (BUTTON) must be from the list: {CB_A,CB_B,CB_L,CB_R,CB_EX1,CB_EX2,CB_EX3,CB_EX4}; found %d", MODULE_TYPE_BUTTONITEM, module_arr[P1]);
						}
						return false;
					}
				}
				return true;
			} //end
			case MODULE_TYPE_FRAME: //start
			{
				if(module_arr[M_SIZE]!=P4+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_FRAME (%d) must have argument size (4) in format {TILE, CSET, WID, HEI}; argument size %d found", MODULE_TYPE_FRAME, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 11 || (module_arr[P2]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_FRAME (%d) argument 2 (CSET) must be an integer between (0) and (11), inclusive; found %d", MODULE_TYPE_FRAME, module_arr[P2]);
					}
					return false;
				}
				if(module_arr[P3] < 2 || module_arr[P3] > 32 || (module_arr[P3]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_FRAME (%d) argument 3 (WID) must be an integer between (2) and (32), inclusive; found %d", MODULE_TYPE_FRAME, module_arr[P3]);
					return false;
				}
				if(module_arr[P4] < 2 || module_arr[P4] > 32 || (module_arr[P4]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_FRAME (%d) argument 4 (HEI) must be an integer between (2) and (28), inclusive; found %d", MODULE_TYPE_FRAME, module_arr[P4]);
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_RECT: //start
			{
				if(module_arr[M_SIZE]!=P3+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_RECT (%d) must have argument size (3) in format {COLOR, X2, Y2}; argument size %d found", MODULE_TYPE_RECT, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 255 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_RECT (%d) argument 1 (COLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_RECT, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 255 || (module_arr[P2]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_RECT (%d) argument 2 (X2) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_RECT, module_arr[P2]);
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 223 || (module_arr[P3]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_RECT (%d) argument 3 (Y2) must be an integer between (0) and (223), inclusive; found %d", MODULE_TYPE_RECT, module_arr[P3]);
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_CIRC: //start
			{
				if(module_arr[M_SIZE]!=P2+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_CIRC (%d) must have argument size (2) in format {COLOR, RADIUS}; argument size %d found", MODULE_TYPE_CIRC, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 255 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_CIRC (%d) argument 1 (COLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_CIRC, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 1 || module_arr[P2] > 400 || (module_arr[P2]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_CIRC (%d) argument 2 (RADIUS) must be an integer between (1) and (400), inclusive; found %d", MODULE_TYPE_CIRC, module_arr[P2]);
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_LINE: //start
			{
				if(module_arr[M_SIZE]!=P3+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_LINE (%d) must have argument size (3) in format {COLOR, X2, Y2}; argument size %d found", MODULE_TYPE_LINE, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 255 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_LINE (%d) argument 1 (COLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_LINE, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 255 || (module_arr[P2]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_LINE (%d) argument 2 (X2) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_LINE, module_arr[P2]);
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 223 || (module_arr[P3]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_LINE (%d) argument 3 (Y2) must be an integer between (0) and (223), inclusive; found %d", MODULE_TYPE_LINE, module_arr[P3]);
					return false;
				}
				return true;
			} //end
			case MODULE_TYPE_TRI: //start
			{
				if(module_arr[M_SIZE]!=P5+1)
				{
					if(DEBUG)
						error("MODULE_TYPE_TRI (%d) must have argument size (3) in format {COLOR, X2, Y2, X3, Y3}; argument size %d found", MODULE_TYPE_TRI, module_arr[M_SIZE]-MODULE_META_SIZE);
					return false;
				}
				if(module_arr[P1] < 0 || module_arr[P1] > 255 || (module_arr[P1]%1))
				{
					if(DEBUG)
					{
						error("MODULE_TYPE_TRI (%d) argument 1 (COLOR) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_TRI, module_arr[P1]);
					}
					return false;
				}
				if(module_arr[P2] < 0 || module_arr[P2] > 255 || (module_arr[P2]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_TRI (%d) argument 2 (X2) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_TRI, module_arr[P2]);
					return false;
				}
				if(module_arr[P3] < 0 || module_arr[P3] > 223 || (module_arr[P3]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_TRI (%d) argument 3 (Y2) must be an integer between (0) and (223), inclusive; found %d", MODULE_TYPE_TRI, module_arr[P3]);
					return false;
				}
				if(module_arr[P4] < 0 || module_arr[P4] > 255 || (module_arr[P4]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_TRI (%d) argument 4 (X3) must be an integer between (0) and (255), inclusive; found %d", MODULE_TYPE_TRI, module_arr[P4]);
					return false;
				}
				if(module_arr[P5] < 0 || module_arr[P5] > 223 || (module_arr[P5]%1))
				{
					if(DEBUG)
						error("MODULE_TYPE_TRI (%d) argument 5 (Y3) must be an integer between (0) and (223), inclusive; found %d", MODULE_TYPE_TRI, module_arr[P5]);
					return false;
				}
				return true;
			} //end
			default:
			{
				if(DEBUG)
				{
					error("validate_module() - Invalid module type encountered (%d)", type);
					//printarr(module_arr);
				}
				return false;
			}
		}
	} //end
	
	bool validate_passive_module(untyped module_arr) //start
	{
		metaver_check(module_arr);
		moduleType type = module_arr[M_TYPE];
		switch(type)
		{
			case MODULE_TYPE_SEL_ITEM_ID:
			case MODULE_TYPE_SEL_ITEM_CLASS:
			{
				if(DEBUG) error("Selectable items cannot be placed on the passive subscreen!");
				return false;
			}
			case MODULE_TYPE_ITEMNAME:
			{
				if(DEBUG) error("Selected Item Name cannot be placed on the passive subscreen!");
				return false;
			}
			
			case MODULE_TYPE_PASSIVESUBSCREEN:
			{
				if(DEBUG) error("You cannot place a Passive Subscreen on a Passive Subscreen!");
				return false;
			}
			
			default: //Fall-through to active cases
			{
				return validate_active_module(module_arr);
			}
		}
	} //end
	//end Module Validation
	//start Modules
	
	/*
	 * Add a module to the current subscreen.
	 * 'module_arr' should be of the form: {MODULE_TYPE_CONSTANT, (data/params)...}
	 * The 'MODULE_TYPE_' constants represent the valid module types, and each have comments for their data parameters.
	 */
	bool add_active_module(untyped module_arr, int indx) //start
	{
		unless(validate_active_module(module_arr)) return false;
		indx = VBound(indx, g_arr[NUM_ACTIVE_MODULES], 1);
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_SETTINGS:
			{
				load_active_settings(module_arr);
				if(g_arr[NUM_ACTIVE_MODULES]) return true; //If there is already a settings module, return here; overwrite it, instead of adding a new one.
				++g_arr[NUM_ACTIVE_MODULES];
				g_arr[SZ_ACTIVE_DATA] += activeData[0];
				return true;
			}
			
			default:
			{
				if(indx < g_arr[NUM_ACTIVE_MODULES])
				{
					int sz_shift = activeModules[g_arr[NUM_ACTIVE_MODULES]] - activeModules[indx];
					untyped buf[SUBSCR_STORAGE_SIZE];
					memcpy(buf, activeData, SUBSCR_STORAGE_SIZE);
					memcpy(activeData, activeModules[indx]+module_arr[M_SIZE], buf, activeModules[indx], sz_shift);
					memcpy(activeData, activeModules[indx], module_arr, 0, module_arr[M_SIZE]);
					g_arr[SZ_ACTIVE_DATA] += module_arr[M_SIZE];
					for(int q = g_arr[NUM_ACTIVE_MODULES]; q > indx; --q)
					{
						activeModules[q] = activeModules[q-1] + module_arr[M_SIZE];
					}
				}
				else
				{
					memcpy(activeData, activeModules[indx], module_arr, 0, module_arr[M_SIZE]);
					g_arr[SZ_ACTIVE_DATA] += module_arr[M_SIZE];
					activeModules[indx+1] = g_arr[SZ_ACTIVE_DATA];
				}
				++g_arr[NUM_ACTIVE_MODULES];
				activeModules[g_arr[NUM_ACTIVE_MODULES]] = g_arr[SZ_ACTIVE_DATA];
				break;
			}
		}
		return true;
	} //end
	bool add_active_module(untyped module_arr) //start
	{
		return add_active_module(module_arr, g_arr[NUM_ACTIVE_MODULES]);
	} //end
	
	void remove_active_module(int indx) //start
	{
		if(indx < 1) return;
		else if(indx > g_arr[NUM_ACTIVE_MODULES]) indx = g_arr[NUM_ACTIVE_MODULES];
		int sz = activeData[activeModules[indx]];
		if(indx < g_arr[NUM_ACTIVE_MODULES])
		{
			int sz_shift = activeModules[g_arr[NUM_ACTIVE_MODULES]] - (activeModules[indx]+sz);
			large_memmove(activeData, activeModules[indx], activeData, activeModules[indx]+sz, sz_shift);
			memset(activeData, activeModules[g_arr[NUM_ACTIVE_MODULES]]-sz, 0, g_arr[SZ_ACTIVE_DATA]-(activeModules[g_arr[NUM_ACTIVE_MODULES]]-sz));
			g_arr[SZ_ACTIVE_DATA] -= sz;
			for(int q = indx; q <= g_arr[NUM_ACTIVE_MODULES]; ++q)
			{
				activeModules[q] = activeModules[q+1] - sz;	
			}
		}
		else if(indx < 1) return;
		else
		{
			memset(activeData, activeModules[indx], 0, sz);
			g_arr[SZ_ACTIVE_DATA] -= sz;
			activeModules[g_arr[NUM_ACTIVE_MODULES]] = 0;
		}
		--g_arr[NUM_ACTIVE_MODULES];
	} //end
	bool replace_active_module(untyped module_arr, int indx) //start
	{
		remove_active_module(indx);
		add_active_module(module_arr, indx);
	} //end
	
	/*
	 * Add a module to the current subscreen.
	 * 'module_arr' should be of the form: {MODULE_TYPE_CONSTANT, (data/params)...}
	 * The 'MODULE_TYPE_' constants represent the valid module types, and each have comments for their data parameters.
	 */
	bool add_passive_module(untyped module_arr, int indx) //start
	{
		unless(validate_passive_module(module_arr)) return false;
		indx = VBound(indx, g_arr[NUM_PASSIVE_MODULES], 1);
		switch(module_arr[M_TYPE])
		{
			case MODULE_TYPE_SETTINGS:
			{
				load_passive_settings(module_arr);
				if(g_arr[NUM_PASSIVE_MODULES]) return true; //If there is already a settings module, return here; overwrite it, instead of adding a new one.
				++g_arr[NUM_PASSIVE_MODULES];
				g_arr[SZ_PASSIVE_DATA] += passiveData[0];
				return true;
			}
			
			default:
			{
				if(indx < g_arr[NUM_PASSIVE_MODULES])
				{
					int sz_shift = passiveModules[g_arr[NUM_PASSIVE_MODULES]] - passiveModules[indx];
					untyped buf[SUBSCR_STORAGE_SIZE];
					memcpy(buf, passiveData, SUBSCR_STORAGE_SIZE);
					memcpy(passiveData, passiveModules[indx]+module_arr[M_SIZE], buf, passiveModules[indx], sz_shift);
					memcpy(passiveData, passiveModules[indx], module_arr, 0, module_arr[M_SIZE]);
					g_arr[SZ_PASSIVE_DATA] += module_arr[M_SIZE];
					for(int q = g_arr[NUM_PASSIVE_MODULES]; q > indx; --q)
					{
						passiveModules[q] = passiveModules[q-1] + module_arr[M_SIZE];
					}
				}
				else
				{
					memcpy(passiveData, passiveModules[indx], module_arr, 0, module_arr[M_SIZE]);
					g_arr[SZ_PASSIVE_DATA] += module_arr[M_SIZE];
					passiveModules[indx+1] = g_arr[SZ_PASSIVE_DATA];
				}
				++g_arr[NUM_PASSIVE_MODULES];
				passiveModules[g_arr[NUM_PASSIVE_MODULES]] = g_arr[SZ_PASSIVE_DATA];
				break;
			}
		}
		return true;
	} //end
	bool add_passive_module(untyped module_arr) //start
	{
		return add_passive_module(module_arr, g_arr[NUM_PASSIVE_MODULES]);
	} //end
	
	void remove_passive_module(int indx) //start
	{
		if(indx < 1) return;
		else if(indx > g_arr[NUM_PASSIVE_MODULES]) indx = g_arr[NUM_PASSIVE_MODULES];
		int sz = passiveData[passiveModules[indx]];
		if(indx < g_arr[NUM_PASSIVE_MODULES])
		{
			int sz_shift = passiveModules[g_arr[NUM_PASSIVE_MODULES]] - (passiveModules[indx]+sz);
			large_memmove(passiveData, passiveModules[indx], passiveData, passiveModules[indx]+sz, sz_shift);
			memset(passiveData, passiveModules[g_arr[NUM_PASSIVE_MODULES]]-sz, 0, g_arr[SZ_PASSIVE_DATA]-(passiveModules[g_arr[NUM_PASSIVE_MODULES]]-sz));
			g_arr[SZ_PASSIVE_DATA] -= sz;
			for(int q = indx; q <= g_arr[NUM_PASSIVE_MODULES]; ++q)
			{
				passiveModules[q] = passiveModules[q+1] - sz;	
			}
		}
		else if(indx < 1) return;
		else
		{
			memset(passiveData, passiveModules[indx], 0, sz);
			g_arr[SZ_PASSIVE_DATA] -= sz;
			passiveModules[g_arr[NUM_PASSIVE_MODULES]] = 0;
		}
		--g_arr[NUM_PASSIVE_MODULES];
	} //end
	bool replace_passive_module(untyped module_arr, int indx) //start
	{
		remove_passive_module(indx);
		add_passive_module(module_arr, indx);
	} //end
	
	void saveModule(untyped buf_arr, int mod_indx, bool active) //start
	{
		memset(buf_arr, 0, MAX_MODULE_SIZE);
		if(active) memcpy(buf_arr, 0, activeData, activeModules[mod_indx], activeData[activeModules[mod_indx]]);
		else memcpy(buf_arr, 0, passiveData, passiveModules[mod_indx], passiveData[passiveModules[mod_indx]]);
	} //end
	
	void cloneModule(int mod_indx, bool active) //start
	{
		if(mod_indx<2) return; //No cloning settings/BGColor
		untyped buf_arr[MODULE_BUF_SIZE];
		saveModule(buf_arr, mod_indx, active);
		if(active)
			add_active_module(buf_arr);
		else
			add_passive_module(buf_arr);
	} //end
	
	void resetActive() //start
	{
		memset(activeData, 0, SUBSCR_STORAGE_SIZE);
		memset(activeModules, 0, MAX_MODULES);
		g_arr[NUM_ACTIVE_MODULES] = 1;
		g_arr[SZ_ACTIVE_DATA] = SZ_SETTINGS;
		activeModules[1] = g_arr[SZ_ACTIVE_DATA];
		load_active_settings(NULL);
		
		untyped buf[MODULE_BUF_SIZE];
		MakeBGColorModule(buf);
		add_active_module(buf);
		MakePassiveSubscreen(buf);
		add_active_module(buf);
	} //end
	void resetPassive() //start
	{
		memset(passiveData, 0, SUBSCR_STORAGE_SIZE);
		memset(passiveModules, 0, MAX_MODULES);
		g_arr[NUM_PASSIVE_MODULES] = 1;
		g_arr[SZ_PASSIVE_DATA] = SZ_SETTINGS;
		passiveModules[1] = g_arr[SZ_PASSIVE_DATA];
		load_passive_settings(NULL);
		
		untyped buf[MODULE_BUF_SIZE];
		MakeBGColorModule(buf);
		add_passive_module(buf);
	} //end
	//end Modules
	//start Constructors
	void MakeModule(untyped buf_arr)
	{
		memset(buf_arr, 0, SizeOfArray(buf_arr));
		buf_arr[M_META_SIZE] = MODULE_META_SIZE;
	}
	
	void MakeBGColorModule(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P1+1;
		buf_arr[M_X] = 0;
		buf_arr[M_Y] = 0;
		buf_arr[M_LAYER] = 0;
		buf_arr[M_TYPE] = MODULE_TYPE_BGCOLOR;
		buf_arr[M_VER] = MVER_BGCOLOR;
		
		buf_arr[P1] = 0x0F; //Default BG color
	}
	
	void MakeSelectableItemID(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P6+1;
		buf_arr[M_LAYER] = 0;
		buf_arr[M_TYPE] = MODULE_TYPE_SEL_ITEM_ID;
		buf_arr[M_VER] = MVER_SEL_ITEM_ID;
		
		buf_arr[P1] = I_RUPEE1;
		buf_arr[P2] = -1;
		buf_arr[P3] = -1;
		buf_arr[P4] = -1;
		buf_arr[P5] = -1;
		buf_arr[P6] = -1;
	}
	
	void MakeSelectableItemClass(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P6+1;
		buf_arr[M_LAYER] = 0;
		buf_arr[M_TYPE] = MODULE_TYPE_SEL_ITEM_CLASS;
		buf_arr[M_VER] = MVER_SEL_ITEM_CLASS;
		
		buf_arr[P1] = 0;
		buf_arr[P2] = -1;
		buf_arr[P3] = -1;
		buf_arr[P4] = -1;
		buf_arr[P5] = -1;
		buf_arr[P6] = -1;
	}
	
	void MakeNonSelectableItemID(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P1+1;
		buf_arr[M_LAYER] = 0;
		buf_arr[M_TYPE] = MODULE_TYPE_NONSEL_ITEM_ID;
		buf_arr[M_VER] = MVER_NONSEL_ITEM_ID;
		
		buf_arr[P1] = I_RUPEE1;
	}
	
	void MakeNonSelectableItemClass(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P1+1;
		buf_arr[M_LAYER] = 0;
		buf_arr[M_TYPE] = MODULE_TYPE_NONSEL_ITEM_CLASS;
		buf_arr[M_VER] = MVER_NONSEL_ITEM_CLASS;
		
		buf_arr[P1] = 0;
	}
	
	void MakeButtonItem(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P1+1;
		buf_arr[M_TYPE] = MODULE_TYPE_BUTTONITEM;
		buf_arr[M_VER] = MVER_BUTTONITEM;
		
		buf_arr[P1] = CB_B;
	}
	
	void MakePassiveSubscreen(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_X] = 0;
		buf_arr[M_SIZE] = MODULE_META_SIZE;
		buf_arr[M_TYPE] = MODULE_TYPE_PASSIVESUBSCREEN;
		buf_arr[M_VER] = MVER_PASSIVESUBSCREEN;
	}
	
	void MakeMinimap(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P10+1;
		buf_arr[M_TYPE] = MODULE_TYPE_MINIMAP;
		buf_arr[M_VER] = MVER_MINIMAP;
		
		buf_arr[M_FLAGS1] = FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON | FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR;
		buf_arr[P6] = 6;
	}
	
	void MakeBigMap(untyped buf_arr)
	{
		MakeMinimap(buf_arr);
		buf_arr[M_TYPE] = MODULE_TYPE_BIGMAP;
		buf_arr[M_VER] = MVER_BIGMAP;
	}
	
	void MakeTileBlock(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P4+1;
		buf_arr[M_TYPE] = MODULE_TYPE_TILEBLOCK;
		buf_arr[M_VER] = MVER_TILEBLOCK;
		
		buf_arr[P3] = 1;
		buf_arr[P4] = 1;
	}
	
	void MakeHeart(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P3+1;
		buf_arr[M_TYPE] = MODULE_TYPE_HEART;
		buf_arr[M_VER] = MVER_HEART;
	}
	
	void MakeHeartRow(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_HEARTROW;
		buf_arr[M_VER] = MVER_HEARTROW;
		
		buf_arr[P4] = 10;
	}
	
	void MakeCounter(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P9+1;
		buf_arr[M_TYPE] = MODULE_TYPE_COUNTER;
		buf_arr[M_VER] = MVER_COUNTER;
		
		buf_arr[P2] = CR_RUPEES;
		buf_arr[P4] = 'A';
		buf_arr[P5] = 2;
		buf_arr[P6] = 0x01;
		buf_arr[P8] = 0x0F;
		buf_arr[P9] = SHD_SHADOWED;
	}
	
	void MakeMinitile(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P2+1;
		buf_arr[M_TYPE] = MODULE_TYPE_MINITILE;
		buf_arr[M_VER] = MVER_MINITILE;
	}
	
	void MakeClock(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_CLOCK;
		buf_arr[M_VER] = MVER_CLOCK;
		
		buf_arr[P2] = 0x01;
		buf_arr[P4] = 0x0F;
		buf_arr[P5] = SHD_SHADOWED;
	}
	void MakeItemName(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P7+1;
		buf_arr[M_TYPE] = MODULE_TYPE_ITEMNAME;
		buf_arr[M_VER] = MVER_ITEMNAME;
		
		buf_arr[P2] = 0x01;
		buf_arr[P4] = 0x0F;
		buf_arr[P5] = SHD_SHADOWED;
		buf_arr[P6] = 256;
		buf_arr[P7] = 0;
	}
	void MakeDMTitle(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_DMTITLE;
		buf_arr[M_VER] = MVER_DMTITLE;
		
		buf_arr[P2] = 0x01;
		buf_arr[P4] = 0x0F;
		buf_arr[P5] = SHD_SHADOWED;
	}
	
	void MakeMagic(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P3+1;
		buf_arr[M_TYPE] = MODULE_TYPE_MAGIC;
		buf_arr[M_VER] = MVER_MAGIC;
	}
	
	void MakeMagicRow(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_MAGICROW;
		buf_arr[M_VER] = MVER_MAGICROW;
		
		buf_arr[P4] = 10;
	}
	void MakeCRPiece(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_CRPIECE;
		buf_arr[M_VER] = MVER_CRPIECE;
		
		buf_arr[P4] = CR_LIFE;
		buf_arr[P5] = HP_PER_HEART;
	}
	
	void MakeCRRow(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P7+1;
		buf_arr[M_TYPE] = MODULE_TYPE_CRROW;
		buf_arr[M_VER] = MVER_CRROW;
		
		buf_arr[P4] = CR_LIFE;
		buf_arr[P5] = HP_PER_HEART;
		buf_arr[P6] = 10;
	}
	
	void MakeFrame(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P4+1;
		buf_arr[M_TYPE] = MODULE_TYPE_FRAME;
		buf_arr[M_VER] = MVER_FRAME;
		
		buf_arr[P1] = 1;
		buf_arr[P3] = 4;
		buf_arr[P4] = 4;
	}
	
	void MakeRectangle(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P3+1;
		buf_arr[M_TYPE] = MODULE_TYPE_RECT;
		buf_arr[M_VER] = MVER_RECT;
		
		buf_arr[P1] = 0x01;
		buf_arr[P2] = 16;
		buf_arr[P3] = 16;
	}
	
	void MakeCircle(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P2+1;
		buf_arr[M_TYPE] = MODULE_TYPE_CIRC;
		buf_arr[M_VER] = MVER_CIRC;
		
		buf_arr[M_X] = 16;
		buf_arr[M_Y] = 16;
		buf_arr[P1] = 0x01;
		buf_arr[P2] = 16;
	}
	
	void MakeLine(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P3+1;
		buf_arr[M_TYPE] = MODULE_TYPE_LINE;
		buf_arr[M_VER] = MVER_LINE;
		
		buf_arr[P1] = 0x01;
		buf_arr[P2] = 16;
		buf_arr[P3] = 16;
	}
	
	void MakeTriangle(untyped buf_arr)
	{
		MakeModule(buf_arr);
		buf_arr[M_SIZE] = P5+1;
		buf_arr[M_TYPE] = MODULE_TYPE_TRI;
		buf_arr[M_VER] = MVER_TRI;
		
		buf_arr[P1] = 0x01;
		buf_arr[P2] = 16;
		buf_arr[P3] = 0;
		buf_arr[P4] = 0;
		buf_arr[P5] = 16;
	}
	//end Constructors
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
		//printf("Attempted to load afile %d\n", indx);
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
		//printf("Attempted to load pfile %d\n", indx);
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
			loadBasicPal(PAL);
			sys_settings[SSET_FLAGS1] |= SSET_FLAG_DELWARN;
			sys_settings[SSET_ANCHOR_SZ] = 3;
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