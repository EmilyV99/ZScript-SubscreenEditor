#option SHORT_CIRCUIT on
#option HEADER_GUARD on
#include "std.zh"
#include "VenrobSubscreen.zh"
#include "VenrobCursor.zh"

namespace Venrob::SubscreenEditor
{
	using namespace Venrob::Subscreen;
	using namespace Venrob::Subscreen::Internal;
	
	enum Color
	{
		WHITE = 0xEF,
		BLACK = 0xE0,
		GRAY = 0xED,
		BLUE = 0x03
	};
	
	untyped SubEditorData[MAX_INT] = {0};
	enum
	{
		SED_CURSORTILE,
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
		SED_LASTMOUSE_X,
		SED_LASTMOUSE_Y
	};
	
	global script Init //start
	{
		void run()
		{
			init();
			SubEditorData[SED_CURSORTILE] = 10;
			load_active_settings({0|FLAG_ITEMS_USE_HITBOX_FOR_SELECTOR,30,SEL_RECTANGLE,WHITE,0,SFX_CURSOR});
			untyped buf[MAX_MODULE_SIZE];
			MakeBGColorModule(buf);
			add_active_module(buf);
			buf[P1] = GRAY;
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
			//
			MakeBButtonItem(buf);
			buf[M_X] = 128;
			buf[M_Y] = 24;
			add_passive_module(buf);
			MakeAButtonItem(buf);
			buf[M_X] = 144;
			buf[M_Y] = 24;
			add_passive_module(buf);
			printf("NumActiveModules: %d\n", g_arr[NUM_ACTIVE_MODULES]);
			for(int q = 0; q < CR_SCRIPT1; ++q) Game->Counter[q] = Game->MCounter[q] = MAX_COUNTER;
		}
	} //end Init

	global script Active //Subscreen Editor
	{
		void run()
		{
			Game->DisableActiveSubscreen = true;
			int editing = 0;
			while(true)
			{
				switch(editing)
				{
					case 0:
						if(Input->ReadKey[KEY_M])
						{
							untyped buf[SUBSCR_STORAGE_SIZE];
							saveActive(buf);
							traceArr(buf, 0, activeModules[g_arr[NUM_ACTIVE_MODULES]]);
						}
						if(Input->ReadKey[KEY_Y])
						{
							untyped buf[MAX_MODULE_SIZE];
							saveModule(buf, 1, true);
							buf[P1] = (buf[P1]+1) % 0x100;
							replace_active_module(buf, 1);
						}
						if(Input->Press[CB_START])
						{
							runActiveSubscreen();
						}
						runPassiveSubscreen();
						break;
					case 1:
						runFauxActiveSubscreen();
						runGUI(true);
						KillButtons();
						break;
					case 2:
						runFauxPassiveSubscreen(true);
						getSubscreenBitmap(false)->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, ((224/2)-(56/2))-56, 256, 56, 0, 0, 0, 0, 0, true);
						runPreparedSelector(false);
						clearPassive1frame();
						runGUI(false);
						KillButtons();
						break;
				}
				handle_data_pane();
				if(Input->ReadKey[KEY_P])
				{
					++editing;
					editing %= 3;
				}
				handleMouseEnd();
				Waitframe();
				handleMouseStart();
			}
		}
	}
	
	void runGUI(bool active)
	{
		
	}

	void runFauxActiveSubscreen()
	{
		runFauxPassiveSubscreen(false);
		for(int q = 1; q < g_arr[NUM_ACTIVE_MODULES] ; ++q)
		{
			untyped buf[MAX_MODULE_SIZE];
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
			untyped buf[MAX_MODULE_SIZE];
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
						editorCursor(module_arr[M_LAYER], 0, 0, 254, 54, mod_indx, active, true);
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
				int itmid = ((module_arr[M_TYPE]==MODULE_TYPE_SELECTABLE_ITEM_CLASS)?(get_item_of_class(module_arr[P1])):(module_arr[P1]));
				if(itmid < 0 || !Hero->Item[itmid]) break;
				
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
			incModX(mod_indx, active, dx);
			incModY(mod_indx, active, dy);
			module_arr[M_X] += dx;
			module_arr[M_Y] += dy;
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
		bool isHovering = CursorBox(x, y, x+wid, y+hei, 0, 56);
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
			if(!isDragging && isHovering)
			{
				clearPreparedSelector();
				if(SubEditorData[SED_RCLICKED]) //RClick
				{
					open_data_pane(mod_indx, active);
				}
			}
			else if(SubEditorData[SED_LCLICKED]) //Clicked off
			{
				SubEditorData[SED_HIGHLIGHTED] = 0;
				return;
			}
			DrawSelector(layer, sx, sy, swid, shei, true, false, SEL_RECTANGLE, BLUE);
		}
		else if(isHovering)
			DrawSelector(layer, sx, sy, swid, shei, true, true, SEL_RECTANGLE, WHITE);
	}
	
	enum
	{
		PANE_T_ACTIVE, PANE_T_PASSIVE, PANE_T_SYSTEM
	};
	
	void open_data_pane(int indx, bool active)
	{
		open_data_pane(indx, active ? PANE_T_ACTIVE : PANE_T_PASSIVE);
	}
	
	void open_data_pane(int indx, int panetype)
	{
		if(SubEditorData[SED_ACTIVE_PANE]) return;
		printf("Opening Data Pane: Indx %d, type %d\n", indx, panetype);
		SubEditorData[SED_ACTIVE_PANE] = indx;
		SubEditorData[SED_PANE_MENU_TYPE] = panetype;
	}
	
	void close_data_pane()
	{
		SubEditorData[SED_ACTIVE_PANE] = NULL;
		SubEditorData[SED_PANE_MENU_TYPE] = false;
	}
	
	void handle_data_pane()
	{
		int pane = SubEditorData[SED_ACTIVE_PANE];
		unless(pane) return;
		int panetype = SubEditorData[SED_PANE_MENU_TYPE];
		untyped module_arr[MAX_MODULE_SIZE];
		switch(panetype)
		{
			case PANE_T_ACTIVE:
				saveModule(module_arr, pane, true);
				break;
			
			case PANE_T_PASSIVE:
				saveModule(module_arr, pane, false);
				break;
			
			case PANE_T_SYSTEM:
				break;
		}
		switch(module_arr[M_TYPE])
		{
			default: traceArr(module_arr, 0, module_arr[M_SIZE]);
		}
		close_data_pane();
	}
	
	void handleMouseStart()
	{
		SubEditorData[SED_LCLICKED] = Input->Mouse[MOUSE_LEFT] && !SubEditorData[SED_LCLICKING];
		SubEditorData[SED_RCLICKED] = Input->Mouse[MOUSE_RIGHT] && !SubEditorData[SED_RCLICKING];
		SubEditorData[SED_MCLICKED] = Input->Mouse[MOUSE_MIDDLE] && !SubEditorData[SED_MCLICKING];
		SubEditorData[SED_LCLICKING] = Input->Mouse[MOUSE_LEFT];
		SubEditorData[SED_RCLICKING] = Input->Mouse[MOUSE_RIGHT];
		SubEditorData[SED_MCLICKING] = Input->Mouse[MOUSE_MIDDLE];
		unless(Input->Mouse[MOUSE_LEFT]) SubEditorData[SED_DRAGGING] = 0;
	}
	
	void handleMouseEnd()
	{
		SubEditorData[SED_LASTMOUSE_X] = Input->Mouse[MOUSE_X];
		SubEditorData[SED_LASTMOUSE_Y] = Input->Mouse[MOUSE_Y];
		if(SubEditorData[SED_CURSORTILE])
		{
			Screen->FastTile(7, Input->Mouse[MOUSE_X], Input->Mouse[MOUSE_Y], SubEditorData[SED_CURSORTILE], 0, OP_OPAQUE);
		}
	}
}