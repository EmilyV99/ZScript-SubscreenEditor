#option SHORT_CIRCUIT on
#option HEADER_GUARD on
#include "TypeAString.zh"
#include "VenrobKeyboardManager.zh"

namespace Venrob::SubscreenEditor
{
	//start Palette
	enum Color
	{
		TRANS = 0x00,
		//System UI colors; these don't change
		WHITE = 0xEF,
		BLACK = 0xE0,
		DGRAY = 0xEC,
		GRAY = 0xED,
		LGRAY = 0xEE,
		PURPLE = 0xE6,
		BLUE = 0xE7,
		MBLUE = 0xE8,
		LBLUE = 0xE9,
		SYS_BLACK = 0xF1,
		SYS_DGRAY = 0xF2,
		SYS_GRAY = 0xF3,
		SYS_LGRAY = 0xF4,
		SYS_WHITE = 0xF5,
		SYS_BLUE = 0xF0
	};
	DEFINE PAL_SIZE = 0x10;
	const Color PAL[PAL_SIZE];
	enum PalIndex
	{
		//0x00
		COL_NULL, //The color to use for blank area. *NOT* Color 0! Should probably be black?
		COL_DISABLED, //Disabled objects/text ("greyed out")
		COL_TEXT_MAIN, //Text against main backgrounds
		COL_TEXT_TITLE_BAR, //The color for the text in the bar of dialogue windows
		//0x04
		COL_TITLE_BAR, //The color for the bar of dialogue windows
		COL_BODY_MAIN_LIGHT, //The main GUI body color, light.
		COL_BODY_MAIN_MED, //The main GUI body color, medium.
		COL_BODY_MAIN_DARK, //The main GUI body color, dark.
		//0x08
		COL_TEXT_FIELD, //Text against fields (X's in checkboxes, text in type fields)
		COL_FIELD_BG, //The color for fields, such as text entry and checkboxes.
		COL_HIGHLIGHT, //The color used to highlight your cursor (i.e. selected object)
		COL_CURSOR, //The color of the provided cursor
		//
		COL_MAX = PAL_SIZE
	};
	
	bool getPalName(char32 buf, int palIndex)
	{
		switch(palIndex)
		{
			case COL_TEXT_MAIN:
				strcat(buf, "Text(Main)");
				break;
			case COL_DISABLED:
				strcat(buf, "Disabled(Grey)");
				break;
			case COL_TEXT_FIELD:
				strcat(buf, "Text(Field)");
				break;
			case COL_BODY_MAIN_LIGHT:
				strcat(buf, "Body(Light)");
				break;
			case COL_BODY_MAIN_MED:
				strcat(buf, "Body(Med)");
				break;
			case COL_BODY_MAIN_DARK:
				strcat(buf, "Body(Dark)");
				break;
			case COL_FIELD_BG:
				strcat(buf, "BG(Field)");
				break;
			case COL_CURSOR:
				strcat(buf, "Cursor");
				break;
			case COL_HIGHLIGHT:
				strcat(buf, "Highlighted");
				break;
			case COL_TITLE_BAR:
				strcat(buf, "Title Bar");
				break;
			case COL_NULL:
				strcat(buf, "Emptiness");
				break;
			case COL_TEXT_TITLE_BAR:
				strcat(buf, "Text(Title)");
				break;
			default:
				strcat(buf, "--");
				return false;
		}
		return true;
	}
	
	//start Default Palettes
	void loadClassicPal(Color Palette)
	{
		Palette[COL_TEXT_MAIN] = BLACK;
		Palette[COL_DISABLED] = GRAY;
		Palette[COL_TEXT_FIELD] = BLACK;
		Palette[COL_BODY_MAIN_LIGHT] = WHITE;
		Palette[COL_BODY_MAIN_MED] = LGRAY;
		Palette[COL_BODY_MAIN_DARK] = DGRAY;
		Palette[COL_FIELD_BG] = WHITE;
		Palette[COL_CURSOR] = GRAY;
		Palette[COL_HIGHLIGHT] = BLUE;
		Palette[COL_TITLE_BAR] = GRAY;
		Palette[COL_NULL] = BLACK;
		Palette[COL_TEXT_TITLE_BAR] = WHITE;
	}
	void loadClassicDarkPal(Color Palette)
	{
		Palette[COL_TEXT_MAIN] = LBLUE;
		Palette[COL_DISABLED] = GRAY;
		Palette[COL_TEXT_FIELD] = LBLUE;
		Palette[COL_BODY_MAIN_LIGHT] = GRAY;
		Palette[COL_BODY_MAIN_MED] = DGRAY;
		Palette[COL_BODY_MAIN_DARK] = BLACK;
		Palette[COL_FIELD_BG] = BLACK;
		Palette[COL_CURSOR] = WHITE;
		Palette[COL_HIGHLIGHT] = BLUE;
		Palette[COL_TITLE_BAR] = DGRAY;
		Palette[COL_NULL] = BLACK;
		Palette[COL_TEXT_TITLE_BAR] = LBLUE;
	}
	void loadBasicPal(Color Palette)
	{
		Palette[COL_TEXT_MAIN] = SYS_BLACK;
		Palette[COL_DISABLED] = SYS_GRAY;
		Palette[COL_TEXT_FIELD] = SYS_BLACK;
		Palette[COL_BODY_MAIN_LIGHT] = SYS_WHITE;
		Palette[COL_BODY_MAIN_MED] = SYS_LGRAY;
		Palette[COL_BODY_MAIN_DARK] = SYS_DGRAY;
		Palette[COL_FIELD_BG] = SYS_WHITE;
		Palette[COL_CURSOR] = SYS_GRAY;
		Palette[COL_HIGHLIGHT] = SYS_BLUE;
		Palette[COL_TITLE_BAR] = SYS_GRAY;
		Palette[COL_NULL] = SYS_BLACK;
		Palette[COL_TEXT_TITLE_BAR] = SYS_WHITE;
	}
	void loadBasicDarkPal(Color Palette)
	{
		Palette[COL_TEXT_MAIN] = SYS_WHITE;
		Palette[COL_DISABLED] = SYS_GRAY;
		Palette[COL_TEXT_FIELD] = SYS_WHITE;
		Palette[COL_BODY_MAIN_LIGHT] = SYS_LGRAY;
		Palette[COL_BODY_MAIN_MED] = SYS_DGRAY;
		Palette[COL_BODY_MAIN_DARK] = SYS_BLACK;
		Palette[COL_FIELD_BG] = SYS_BLACK;
		Palette[COL_CURSOR] = SYS_WHITE;
		Palette[COL_HIGHLIGHT] = SYS_BLUE;
		Palette[COL_TITLE_BAR] = SYS_GRAY;
		Palette[COL_NULL] = SYS_BLACK;
		Palette[COL_TEXT_TITLE_BAR] = SYS_BLACK;
	} //end
	//end 
	//start Key procs
	bool keyproc(int key)
	{
		return KeyInput(key);
		//printf("KeyProc'ing key %d (%s?): %s\n", key, {key-KEY_A+'A', 0}, ret?"true":"false");
	}
	bool keyprocp(int key)
	{
		return KeyPressed(key);
	}
	void killkey(int key)
	{
		KeyPressed(key, false);
		KeyInput(key, false);
	}
	bool DefaultButton()
	{
		return KeyInput(SubEditorData[SED_DEFAULTBTN]) || KeyInput(SubEditorData[SED_DEFAULTBTN2]);
	}
	bool DefaultButtonP()
	{
		return KeyPressed(SubEditorData[SED_DEFAULTBTN]) || KeyPressed(SubEditorData[SED_DEFAULTBTN2]);
	}
	bool CancelButton()
	{
		return KeyInput(SubEditorData[SED_CANCELBTN]);
	}
	bool CancelButtonP()
	{
		return KeyPressed(SubEditorData[SED_CANCELBTN]);
	}
	bool HelpButton()
	{
		return Input->ReadKey[KEY_F1];
	}
	void KillDLGButtons()
	{
		KillAllKeyboard();
	}
	//end
	namespace DIALOG
	{
		DEFINE DIA_FONT = FONT_Z3SMALL;
		DEFINE DIA_CLOSING_DELAY = 4;
		DEFINE GEN_BUTTON_WIDTH = 48, GEN_BUTTON_HEIGHT = 12;
		namespace PARTS //start Individual procs
		{
			//Deco type procs: purely visual
			//start Deco: Generic
			void rect(bitmap bit, int x1, int y1, int x2, int y2, int color) //start
			{
				bit->Rectangle(0, x1, y1, x2, y2, color, 1, 0, 0, 0, true, OP_OPAQUE);
			} //end
			void h_rect(bitmap bit, int x1, int y1, int x2, int y2, int color) //start
			{
				bit->Rectangle(0, x1, y1, x2, y2, color, 1, 0, 0, 0, false, OP_OPAQUE);
			} //end
			void circ(bitmap bit, int x, int y, int rad, int color) //start
			{
				bit->Circle(0, x, y, rad, color, 1, 0, 0, 0, true, OP_OPAQUE);
			} //end
			void tri(bitmap bit, int x1, int y1, int x2, int y2, int x3, int y3, int color) //start
			{
				bit->Triangle(0, x1, y1, x2, y2, x3, y3, 0, 0, color, 0, 0, 0, NULL);
			} //end
			void text(bitmap bit, int x, int y, int tf, char32 str, int color)  //start No width; straight draw
			{
				bit->DrawString(0, x, y, DIA_FONT, color, -1, tf, str, OP_OPAQUE);
			} //end
			void text(bitmap bit, int x, int y, int tf, char32 str, int color, int width) //start Width; will wrap to next line
			{
				DrawStringsBitmap(bit, 0, x, y, DIA_FONT, color, -1, tf, str, OP_OPAQUE, Text->FontHeight(DIA_FONT)/2, width);
			} //end
			void text(bitmap bit, int x, int y, int tf, char32 str, int color, int width, int height) //start
			{
				bitmap sub = create(width, height);
				DrawStringsBitmap(sub, 0, 0, 0, DIA_FONT, color, -1, tf, str, OP_OPAQUE, Text->FontHeight(DIA_FONT)/2, width);
				sub->Blit(0, bit, 0, 0, width, height, x, y, width, height, 0, 0, 0, 0, 0, true);
				sub->Free();
			} //end
			int shortcuttext_width(char32 str, int font) //start
			{
				int pos = _strchr(str, 0, '%');
				if(pos<0) return Text->StringWidth(str, font);
				char32 buf[256];
				strcpy(buf, str);
				int remlen = 1;
				if(buf[pos+1]=='%')
				{
					++remlen;
					int end = _strchr(buf, pos+2, '%');
					if(end>-1)
					{
						remlen += (end-pos);
					}
				}
				remnchr(buf, pos, remlen);
				for(int pos = _strchr(buf, 0, '%'); pos>-1; pos = _strchr(buf, 0, '%'))
				{
					remnchr(buf, pos, 1);
				}
				return Text->StringWidth(buf, font);
			} //end
			int shortcut_text(bitmap bit, int x, int y, char32 str, int color) //start Character following a % will be underlined
			{
				int pos = _strchr(str, 0, '%');
				if(pos<0)
				{
					text(bit, x, y, TF_NORMAL, str, color);
					return NULL;
				}
				char32 c;
				int key;
				char32 buf[256];
				strcpy(buf, str);
				int remlen = 1;
				if(buf[pos+1]=='%')
				{
					int end = _strchr(buf, pos+2, '%');
					if(end>-1)
					{
						remlen += (end-pos);
						char32 ibuf[16];
						strncpy(ibuf, 0, buf, pos+2, end-(pos+2));
						key = atoi(ibuf);
					}
				}
				remnchr(buf, pos, remlen);
				if(key)
				{
					pos = _strchr(buf, 0, '%');
					unless(pos<0)
					{
						remnchr(buf, pos, 1);
						int pos2 = _strchr(buf, pos, '%');
						unless(pos2<0)
						{
							remnchr(buf, pos2, 1);
							char32 t_buf[256];
							strncpy(t_buf, buf, pos);
							bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, t_buf, OP_OPAQUE);
							int wid1 = Text->StringWidth(t_buf, DIA_FONT);
							remchr(t_buf, 0);
							strncpy(t_buf, 0, buf, pos, pos2-pos);
							bit->DrawString(0, x+wid1, y, DIA_FONT, color, -1, TF_NORMAL, t_buf, OP_OPAQUE);
							int wid2 = Text->StringWidth(t_buf, DIA_FONT);
							remchr(t_buf, 0);
							strncpy(t_buf, 0, buf, pos2, strlen(buf)-pos2);
							bit->DrawString(0, x+wid1+wid2, y, DIA_FONT, color, -1, TF_NORMAL, t_buf, OP_OPAQUE);
							int strhei = Text->FontHeight(DIA_FONT);
							line(bit, x+wid1, y+strhei, x+wid1+wid2-2, y+strhei, color);
							return key;
						}
					}
					bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, buf, OP_OPAQUE);
					return key;
				}
				else
				{
					char32 t_buf[256];
					strncpy(t_buf, buf, pos);
					int strwid = Text->StringWidth(t_buf, DIA_FONT), strhei = Text->FontHeight(DIA_FONT);
					bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, buf, OP_OPAQUE);
					c = buf[pos];
					line(bit, x+strwid, y+strhei, x+strwid+Text->CharWidth(c, DIA_FONT)-2, y+strhei, color);
					return isAlphabetic(c) ? (LowerToUpper(c)-'A'+KEY_A) : (isNumber(c) ? (c-'0'+KEY_0) : NULL);
				}
				return NULL;
			} //end
			void line(bitmap bit, int x, int y, int x2, int y2, int color) //start
			{
				bit->Line(0, x, y, x2, y2, color, 1, 0, 0, 0, OP_OPAQUE);
			}
			void x(bitmap bit, int x, int y, int len, int color)
			{
				int x2 = x+len-1, y2 = y+len-1;
				line(bit, x, y, x2, y2, color);
				line(bit, x, y2, x2, y, color);
			} //end
			void pix(bitmap bit, int x, int y, int color) //start
			{
				bit->PutPixel(0, x, y, color, 0, 0, 0, OP_OPAQUE);
			} //end
			void tile(bitmap bit, int x, int y, int tile, int cset) //start
			{
				bit->FastTile(0, x, y, tile, cset, OP_OPAQUE);
			} //end
			void tilebl(bitmap bit, int x, int y, int tile, int cset, int wid, int hei) //start
			{
				bit->DrawTile(0, x, y, tile, wid, hei, cset, -1, -1, 0, 0, 0, FLIP_NONE, true, OP_OPAQUE);
			} //end
			void combo(bitmap bit, int x, int y, int combo, int cset) //start
			{
				bit->FastCombo(0, x, y, combo, cset, OP_OPAQUE);
			} //end
			void minitile(bitmap bit, int x, int y, int tile, int cset, int corner) //start
			{
				unless(<bitmap>(g_arr[MINITILE_BITMAP])->isValid())
				{
					<bitmap>(g_arr[MINITILE_BITMAP])->Free();
					g_arr[MINITILE_BITMAP] = Game->CreateBitmap(16,16);
				}
				<bitmap>(g_arr[MINITILE_BITMAP])->Clear(0);
				tile(g_arr[MINITILE_BITMAP], 0, 0, tile, cset);
				<bitmap>(g_arr[MINITILE_BITMAP])->Blit(0, bit, (corner&01b)?8:0, (corner&10b)?8:0, 8, 8, x, y, 8, 8, 0, 0, 0, 0, 0, true);
			} //end
			void itm(bitmap bit, int x, int y, int id) //start
			{
				itemdata id = Game->LoadItemData(id);
				int aspeedtime = (Max(1,id->ASpeed*id->AFrames));
				int tmr = SubEditorData[SED_GLOBAL_TIMER] % (aspeedtime+id->Delay);
				int frm = (tmr - aspeedtime >= 0) ? 0 : Div(tmr, Max(1,id->ASpeed));
				bit->FastTile(0, x, y, id->Tile + frm, id->CSet, OP_OPAQUE);
			} //end
			//end
			//start Deco: Special
			void corner_border_effect(bitmap bit, int corner_x, int corner_y, int len, int corner_dir, int color) //start
			{	//A triangle, with a curve cut out of the hypotenuse. Right, Equilateral triangles only.
				int x1 = corner_x + (remY(corner_dir)==DIR_RIGHT ? -len : len),
				    y1 = corner_y,
					x2 = corner_x,
				    y2 = corner_y + (remX(corner_dir)==DIR_DOWN ? -len : len);
				bitmap sub = create(bit->Width, bit->Height);
				sub->Clear(0);
				tri(sub, corner_x, corner_y, x1, y1, x2, y2, color);
				circ(sub, x1, y2, len, 0x00);
				fullblit(0, bit, sub);
				sub->Free();
			} //end
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol, int ULCol, int DRCol) //start
			{
				rect(bit, x1, y1, x1+(margin-1), y2, ULCol);
				rect(bit, x2, y2, x1, y2-(margin-1), DRCol);
				rect(bit, x2, y2, x2-(margin-1), y1, DRCol);
				rect(bit, x1, y1, x2, y1+(margin-1), ULCol);
				
				rect(bit, x1+margin, y1+margin, x2-margin, y2-margin, FillCol);
			} //end
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol) //start
			{
				frame_rect(bit, x1, y1, x2, y2, margin, FillCol, PAL[COL_BODY_MAIN_LIGHT], PAL[COL_BODY_MAIN_DARK]);
			} //end
			void inv_frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol) //start
			{
				frame_rect(bit, x1, y1, x2, y2, margin, FillCol, PAL[COL_BODY_MAIN_DARK], PAL[COL_BODY_MAIN_LIGHT]);
			} //end
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin) //start
			{
				frame_rect(bit, x1, y1, x2, y2, margin, PAL[COL_BODY_MAIN_MED]);
			} //end
			void inv_frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin) //start
			{
				inv_frame_rect(bit, x1, y1, x2, y2, margin, PAL[COL_BODY_MAIN_MED]);
			} //end
			//end
			//Active type procs: functional
			//start components
			ProcRet x_out(bitmap bit, int x, int y, int len, untyped dlgdata) //start
			{
				ProcRet ret = PROC_NULL;
				int x2 = x+len-1, y2 = y+len-1;
				if(SubEditorData[SED_LCLICKED] && DLGCursorBox(x,y,x2,y2,dlgdata))
				{
					ret = PROC_CANCEL;
					inv_frame_rect(bit, x, y, x2, y2, 1);
				}
				else frame_rect(bit, x, y, x2, y2, 1);
				x(bit, x+1, y+1, len-2, PAL[COL_TEXT_MAIN]);
				return ret;
			} //end
			ProcRet checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata, long flags) //start
			{
				bool disabled = flags&FLAG_DISABLE;
				ProcRet ret = PROC_NULL;
				int x2 = x+len-1, y2 = y+len-1;
				if(!disabled && SubEditorData[SED_LCLICKED] && DLGCursorBox(x,y,x2,y2,dlgdata))
				{
					checked = !checked;
					ret = checked ? PROC_UPDATED_TRUE : PROC_UPDATED_FALSE;
				}
				
				frame_rect(bit, x, y, x2, y2, 1, (disabled ? PAL[COL_BODY_MAIN_MED] : PAL[COL_FIELD_BG]));
				if(checked) x(bit, x+1, y+1, len-2, (disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]));
				return ret;
			} //end
			ProcRet insta_button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata, long flags) //start
			{
				bool disabled = flags&FLAG_DISABLE;
				ProcRet ret = PROC_NULL;
				int x2 = x + wid - 1, y2 = y + hei - 1;
				if(!disabled && SubEditorData[SED_LCLICKED] && DLGCursorBox(x,y,x2,y2,dlgdata))
				{
					ret = PROC_CONFIRM;
				}
				
				frame_rect(bit, x, y, x2, y2, 1);
				
				text(bit, x+(wid/2), y+Ceiling((hei-Text->FontHeight(DIA_FONT))/2), TF_CENTERED, btnText, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				
				return ret;
			} //end
			ProcRet button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata, untyped proc_data, int proc_indx, long flags) //start
			{
				long was_held = proc_data[proc_indx];
				DEFINEL FLAG_HELD_MOUSE = 01bL;
				DEFINEL FLAG_HELD_KEY = 10bL;
				bool disabled = flags&FLAG_DISABLE;
				bool isDefault = flags&FLAG_DEFAULT;
				ProcRet ret = PROC_NULL;
				int x2 = x + wid - 1, y2 = y + hei - 1;
				bool indented = false;
				bitmap tbit = create(dlgdata[DLG_DATA_WID], dlgdata[DLG_DATA_HEI]);
				tbit->Clear(0);
				int key = shortcut_text(tbit, x+((wid-shortcuttext_width(btnText, DIA_FONT))/2), y+Ceiling((hei-Text->FontHeight(DIA_FONT))/2), btnText, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				if(!disabled)
				{
					bool cursor = DLGCursorBox(x,y,x2,y2,dlgdata);
					
					if(cursor&&SubEditorData[SED_LCLICKED])
					{
						was_held |= FLAG_HELD_MOUSE;
						indented = true;
					}
					else if((was_held & FLAG_HELD_MOUSE) && (cursor&&SubEditorData[SED_LCLICKING]))
					{
						indented = true;
					}
					else if(was_held & FLAG_HELD_MOUSE)
					{
						was_held = 0L;
						if(cursor) ret = PROC_CONFIRM; //If you slid the cursor off the button, don't register it as a click!
					}
					
					if(key&&keyprocp(key) || (isDefault&&DefaultButtonP()))
					{
						was_held |= FLAG_HELD_KEY;
						indented = true;
					}
					else if((was_held & FLAG_HELD_KEY) && ((key&&keyproc(key)) || (isDefault&&DefaultButton())))
					{
						indented = true;
					}
					else if(was_held & FLAG_HELD_KEY)
					{
						was_held = 0L;
						ret = PROC_CONFIRM;
					}
				}
				if(indented) inv_frame_rect(bit, x, y, x2, y2, isDefault ? 2 : 1);
				else frame_rect(bit, x, y, x2, y2, isDefault ? 2 : 1);
				
				fullblit(0, bit, tbit);
				tbit->Free();
				
				proc_data[proc_indx] = was_held;
				return ret;
			}
			ProcRet button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata, untyped proc_data, int proc_indx)
			{
				button(bit, x, y, wid, hei, btnText, dlgdata, proc_data, proc_indx, 0);
			} //end
			ProcRet radio(bitmap bit, int x, int y, int rad, untyped dlgdata, untyped proc_data, int proc_indx, int rad_indx, long flags) //start
			{
				bool disabled = flags&FLAG_DISABLE;
				ProcRet ret = PROC_NULL;
				//Dark BG circle
				circ(bit, x, y, rad, PAL[COL_BODY_MAIN_DARK]);
				//UL 3 sections
				circ(bit, x-1, y-1, rad-1, PAL[COL_BODY_MAIN_LIGHT]);
				circ(bit, x-1, y, rad-1, PAL[COL_BODY_MAIN_LIGHT]);
				circ(bit, x, y-1, rad-1, PAL[COL_BODY_MAIN_LIGHT]);
				//Main Circle
				circ(bit, x, y, rad-1, disabled ? PAL[COL_BODY_MAIN_MED] : PAL[COL_FIELD_BG]);
				if(SubEditorData[SED_LCLICKED] && DLGCursorRad(x, y, rad, dlgdata))
				{
					ret = PROC_CONFIRM;
					proc_data[proc_indx] = rad_indx;
				}
				if(proc_data[proc_indx] == rad_indx) //Selected
				{
					circ(bit, x, y, Div(rad,2), disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				}
			} //end
			Color pal_swatch(bitmap bit, int x, int y, int wid, int hei, Color swatch_color, untyped dlgdata) //start
			{
				int x2 = x+wid-1, y2 = y+hei-1;
				if(SubEditorData[SED_LCLICKED] && DLGCursorBox(x, y, x2, y2, dlgdata))
				{
					swatch_color = pick_color(swatch_color);
				}
				frame_rect(bit, x, y, x2, y2, 1, swatch_color);
				return swatch_color;
			}//end
			void minitile_swatch(bitmap bit, int x, int y, untyped arr, untyped dlgdata, bool show_t0) //start
			{
				tile_swatch(bit, x, y, arr, dlgdata, show_t0);
				if(SubEditorData[SED_RCLICKED] && DLGCursorBox(x+1, y+1, x+16, y+16, dlgdata))
				{
					int cx = DLGMouseX(dlgdata) - (x+1),
					    cy = DLGMouseY(dlgdata) - (y+1);
					long crn = 0L;
					if(cx >= 8) crn |= 01bL;
					if(cy >= 8) crn |= 10bL;
					arr[2] = crn;
				}
				if(arr[0] || show_t0) h_rect(bit, x + ((arr[2]&01bL)?9:1), y + ((arr[2]&10bL)?9:1), x + ((arr[2]&01bL)?16:8), y + ((arr[2]&10bL)?16:8), PAL[COL_HIGHLIGHT]);
			} //end
			void tile_swatch(bitmap bit, int x, int y, int arr, untyped dlgdata, bool show_t0) //start
			{
				int x2 = x+17, y2 = y+17;
				if(SubEditorData[SED_LCLICKED] && DLGCursorBox(x, y, x2, y2, dlgdata))
				{
					pick_tile(arr);
				}
				frame_rect(bit, x, y, x2, y2, 1);
				if(arr[0] || show_t0) tile(bit, x+1, y+1, arr[0], arr[1]);
			}//end
			int dropdown_proc(bitmap bit, int x, int y, int wid, int indx, untyped dlgdata, char32 strings, int num_opts, int NUM_VIS_OPTS, bitmap lastframe, long flags) //start
			{
				if(num_opts <= 0)
				{
					if(strings > 0) num_opts = SizeOfArray(strings);
					else unless(num_opts) num_opts = 1; //Error
					else num_opts = getSpecialStringCount(strings);
				}
				bool disabled = flags&FLAG_DISABLE;
				int hei = 2 + 2 + Text->FontHeight(DIA_FONT);
				frame_rect(bit, x, y, x+wid-1, y+hei-1, 1, disabled ? PAL[COL_BODY_MAIN_MED] : PAL[COL_FIELD_BG]);
				char32 buf[128];
				char32 ptr = buf;
				if(strings > 0)
					ptr = strings[indx];
				else unless(strings)
					itoa(buf,indx+1);
				else getSpecialString(buf, strings, indx);
				bitmap sub = create(wid, hei);
				text(sub, 2, 2, TF_NORMAL, ptr, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_FIELD]);
				sub->Blit(0, bit, 0, 0, wid, hei, x, y, wid, hei, 0, 0, 0, BITDX_NORMAL, 0, true);
				sub->Free();
				//
				DEFINE BTN_HEIGHT = hei, BTN_WIDTH = hei;
				int bx = x + (wid - BTN_WIDTH);
				frame_rect(bit, bx, y, bx+BTN_WIDTH-1, y+BTN_HEIGHT-1, 1);
				line(bit, bx + 2, y + 5, (bx + BTN_WIDTH/2)-1, y+(BTN_HEIGHT/2)+2, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				line(bit, bx + BTN_WIDTH - 2 - 1, y + 5, (bx + BTN_WIDTH/2), y+(BTN_HEIGHT/2)+2, (disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]));
				//
				if(DLGCursorBox(x, y, x+wid-1, y+hei-1, dlgdata))
				{
					if(SubEditorData[SED_LCLICKED])
					{
						indx = dropdown_open(lastframe, x, y+hei, wid, indx, dlgdata, strings, num_opts, NUM_VIS_OPTS);
					}
					else
					{
						if(SubEditorData[SED_MOUSE_Z] > SubEditorData[SED_LASTMOUSE_Z])
							indx = Max(indx-1, 0);
						else if(SubEditorData[SED_MOUSE_Z] < SubEditorData[SED_LASTMOUSE_Z])
							indx = Min(indx+1, num_opts-1);
					}
				}
				return indx;
			} //end
			//end
			//start compounds
			int dropdown_inc_text_combo(bitmap bit, int x, int y, int ddwid, int val, untyped dlgdata, char32 strings, int num_opts, int NUM_VIS_OPTS, bitmap lastframe, long flags, int tfwid, int maxchar, bool neg, int tf_indx, int min, int max, bool tf_left) //start
			{
				val = dropdown_proc(bit, tf_left ? x+tfwid : x, y, ddwid, val, dlgdata, strings, num_opts, NUM_VIS_OPTS, lastframe, flags);
				char32 buf[16];
				itoa(buf, val);
				inc_text_field(bit, tf_left ? x : x+ddwid, y, tfwid, buf, maxchar, neg, dlgdata, tf_indx, flags, min, max);
				if(max > min)
					return VBound(atoi(buf), max, min);
				return atoi(buf);
			} //end
			int itemsel_bundle(bitmap bit, int x, int y, int val, untyped dlgdata, bitmap lastframe, long flags, int tf_indx, char32 title, bool flip_preview) //start
			{
				text(bit, x, y, TF_NORMAL, title, (flags&FLAG_DISABLE) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				val = dropdown_inc_text_combo(bit, x, y+Text->FontHeight(DIA_FONT), 104, val, dlgdata, SSL_ITEM, -1, 10, lastframe, flags, 28, 3, false, tf_indx, MIN_ITEMDATA, MAX_ITEMDATA, true);
				y += Text->FontHeight(DIA_FONT)*2+4;
				DEFINE ITMNAME_WID = 110;
				frame_rect(bit, flip_preview ? x+ITMNAME_WID+4 : x, y, flip_preview ? x+ITMNAME_WID+21 : x+17, y+17, 1);
				itm(bit, flip_preview ? x+ITMNAME_WID+5 : x+1, y+1, val);
				char32 iname[64];
				Game->LoadItemData(val)->GetName(iname);
				if(Text->StringWidth(iname, DIA_FONT) < (104-10))
					return val; //Don't display the name again if it fits in the dropdown preview
				frame_rect(bit, flip_preview ? x : x+18, y, flip_preview ? x+ITMNAME_WID+3: x+18+ITMNAME_WID+3, y-2
				           + Min((Text->FontHeight(DIA_FONT)+4) * DrawStringsCount(DIA_FONT, iname, ITMNAME_WID), 19)
				           ,1);
				text(bit, flip_preview ? x+1 : x+20, y+2, TF_NORMAL, iname, PAL[COL_TEXT_MAIN], ITMNAME_WID, 17);
				return val;
			} //end
			ProcRet title_bar(bitmap bit, int margin, int barheight, char32 title, untyped dlgdata, char32 descstr, bool buttons) //start
			{
				--barheight;
				rect(bit, margin, margin, dlgdata[DLG_DATA_WID]-margin-margin, barheight, PAL[COL_TITLE_BAR]);
				text(bit, margin+margin, margin+((barheight - Text->FontHeight(DIA_FONT))/2), TF_NORMAL, title, PAL[COL_TEXT_TITLE_BAR]);
				line(bit, margin, barheight, dlgdata[DLG_DATA_WID]-margin, barheight, PAL[COL_BODY_MAIN_DARK]);
				line(bit, margin, barheight+1, dlgdata[DLG_DATA_WID]-margin, barheight+1, PAL[COL_BODY_MAIN_LIGHT]);
				if(buttons)
				{
					i_proc(bit, dlgdata[DLG_DATA_WID]-19, 2, descstr, dlgdata, true);
					return x_out(bit, dlgdata[DLG_DATA_WID]-margin-1-(barheight-2), margin+1, barheight-3, dlgdata);
				}
				else return PROC_NULL;
			} //end
			ProcRet title_bar(bitmap bit, int margin, int barheight, char32 title, untyped dlgdata, char32 descstr) //start
			{
				return title_bar(bit, margin, barheight, title, dlgdata, descstr, true);
			} //end
			ProcRet title_bar(bitmap bit, int margin, int barheight, char32 title, untyped dlgdata) //start
			{
				title_bar(bit, margin, barheight, title, dlgdata, "");
			} //end
			Color colorgrid(bitmap bit, int x, int y, Color clr, int len, untyped dlgdata, untyped proc_data, int proc_indx) //start
			{
				DEFINE MAX_COLOR = 0xFF, MAX_CSET = MAX_COLOR>>4, NUM_CSET = MAX_CSET+1, MAX_C_IN_CSET = 0xF, NUM_C_PER_CSET = MAX_C_IN_CSET+1, START_LAST_CSET = MAX_CSET<<4;
				int did_clicked = -1;
				int active_swatch = clr;
				if(SubEditorData[SED_LCLICKED])
				{
					if(DLGCursorBox(x, y, x+(NUM_C_PER_CSET*len)-1, y+(NUM_CSET*len), dlgdata))
					{
						proc_data[proc_indx] = 1;
						int clicked_on = ((DLGMouseX(dlgdata)-x)/len) | (((DLGMouseY(dlgdata)-y)/len)<<4);
						if(clicked_on <= MAX_COLOR) active_swatch = clicked_on;
					}
					else
					{
						proc_data[proc_indx] = 0;
					}
				}
				int wid = NUM_C_PER_CSET*len, hei = NUM_CSET*len;
				frame_rect(bit, x-1, y-1, x+wid+1, y+hei+1, 1);
				for(int q = 0x00; q <= MAX_COLOR; ++q)
				{
					int tx1 = x+((q&0xF)*len), ty1 = y+((q>>4)*len),
					    tx2 = tx1+len-1, ty2 = ty1+len-1;
					rect(bit, tx1, ty1, tx2, ty2, q);
				}
				if(proc_data[proc_indx])
				{
					if(Input->Press[CB_UP])
					{
						if(active_swatch>MAX_C_IN_CSET) active_swatch-=0x10;
					}
					else if(Input->Press[CB_DOWN])
					{
						if(active_swatch<START_LAST_CSET) active_swatch+=0x10;
					}
					if(Input->Press[CB_LEFT])
					{
						if((active_swatch&MAX_C_IN_CSET)>0) --active_swatch;
					}
					else if(Input->Press[CB_RIGHT])
					{
						if((active_swatch&MAX_C_IN_CSET)<MAX_C_IN_CSET) ++active_swatch;
					}
				}
				
				int tx1 = x+((active_swatch&MAX_C_IN_CSET)*len), ty1 = y+((active_swatch>>4)*len),
					tx2 = tx1+len-1, ty2 = ty1+len-1;
				h_rect(bit, tx1, ty1, tx2, ty2, PAL[COL_HIGHLIGHT]);
				return <Color>active_swatch;
			} //end
			ProcRet titled_checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata, long flags, char32 title) //start
			{
				text(bit, x+len+2, y+((len-1-Text->FontHeight(DIA_FONT))/2)+1, TF_NORMAL, title, (flags&FLAG_DISABLE ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]));
				return checkbox(bit, x, y, len, checked, dlgdata, flags);
			} //end
			ProcRet desc_titled_checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata, long flags, char32 title, char32 desc_str) //start
			{
				i_proc(bit, x + Text->StringWidth(title, DIA_FONT) + len + 3, y, (flags&FLAG_DISABLE ? "" : desc_str), dlgdata);
				return titled_checkbox(bit, x, y, len, checked, dlgdata, flags, title);
			} //end
			ProcRet r_titled_checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata, long flags, char32 title) //start
			{
				text(bit, x, y+((len-1-Text->FontHeight(DIA_FONT))/2)+1, TF_NORMAL, title, (flags&FLAG_DISABLE ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]));
				return checkbox(bit, x+Text->StringWidth(title,DIA_FONT), y, len, checked, dlgdata, flags);
			} //end
			ProcRet r_desc_titled_checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata, long flags, char32 title, char32 desc_str) //start
			{
				i_proc(bit, x + Text->StringWidth(title, DIA_FONT) + len + 3, y, (flags&FLAG_DISABLE ? "" : desc_str), dlgdata);
				return r_titled_checkbox(bit, x, y, len, checked, dlgdata, flags, title);
			} //end
			void titled_text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar, TypeAString::TMode tm, untyped dlgdata, int tf_indx, long flags, char32 title) //start
			{
				text(bit, x-2, y+2, TF_RIGHT, title, (flags&FLAG_DISABLE) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				text_field(bit, x, y, wid, buf, maxchar, tm, dlgdata, tf_indx, flags);
			} //end
			void titled_inc_text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar, bool can_neg, untyped dlgdata, int tf_indx, long flags, char32 title) //start
			{
				text(bit, x-2, y+2, TF_RIGHT, title, (flags&FLAG_DISABLE) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				inc_text_field(bit, x, y, wid, buf, maxchar, can_neg, dlgdata, tf_indx, flags);
			} //end
			void titled_inc_text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar, bool can_neg, untyped dlgdata, int tf_indx, long flags, int min, int max, char32 title) //start
			{
				text(bit, x-2, y+2, TF_RIGHT, title, (flags&FLAG_DISABLE) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				inc_text_field(bit, x, y, wid, buf, maxchar, can_neg, dlgdata, tf_indx, flags, min, max);
			} //end
			void inc_text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar, bool can_neg, untyped dlgdata, int tf_indx, long flags) //start
			{
				inc_text_field(bit, x, y, wid, buf, maxchar, can_neg, dlgdata, tf_indx, flags, 0, 0); //Since min==max, no bounding occurs
			} //end
			void inc_text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar,  bool can_neg, untyped dlgdata, int tf_indx, long flags, int min, int max) //start
			{
				TypeAString::TMode tm = can_neg ? TypeAString::TMODE_NUMERIC : TypeAString::TMODE_NUMERIC_POSITIVE;
				bool doBound = min < max;
				text_field(bit, x, y, wid, buf, maxchar, tm, dlgdata, tf_indx, flags);
				bool disabled = flags & FLAG_DISABLE;
				DEFINE HEIGHT = 2+2+Text->FontHeight(DIA_FONT), WIDTH = 12;
				int ux1 = x+wid-WIDTH, ux2 = x+wid-1, uy1 = y, uy2 = y+(HEIGHT/2)-1,
				    dx1 = ux1, dx2 = ux2, dy1 = y+(HEIGHT/2), dy2 = y+HEIGHT-1;
				int clicked;
				if(!disabled && DLGCursorBox(x, y, x+wid-1, y+HEIGHT-1, dlgdata))
				{
					if(SubEditorData[SED_LCLICKED])
					{
						if(DLGCursorBox(ux1, uy1, ux2, uy2, dlgdata))
						{
							clicked = 1;
						}
						else if(DLGCursorBox(dx1, dy1, dx2, dy2, dlgdata))
						{
							clicked = 2;
						}
					}
					if(clicked == 1 || SubEditorData[SED_MOUSE_Z] > SubEditorData[SED_LASTMOUSE_Z])
					{
						int a = atoi(buf)+1;
						remchr(buf, 0);
						itoa(buf, doBound ? VBound(a,max,min) : a);
					}
					else if(clicked == 2 || SubEditorData[SED_MOUSE_Z] < SubEditorData[SED_LASTMOUSE_Z])
					{
						int a = atoi(buf)-1;
						remchr(buf, 0);
						itoa(buf, doBound ? VBound(a,max,min) : a);
					}
				}
				if(clicked==1) inv_frame_rect(bit, ux1, uy1, ux2, uy2, 1);
				else frame_rect(bit, ux1, uy1, ux2, uy2, 1);
				if(clicked==2) inv_frame_rect(bit, dx1, dy1, dx2, dy2, 1);
				else frame_rect(bit, dx1, dy1, dx2, dy2, 1);	
				line(bit, x+wid-WIDTH+2, y+(HEIGHT/2)-1-1, x+wid-(WIDTH/2)-1, y+1, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				line(bit, x+wid-WIDTH+2, y+(HEIGHT/2)+1, x+wid-(WIDTH/2)-1, y+HEIGHT-1-1, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				line(bit, x+wid-1-2, y+(HEIGHT/2)-1-1, x+wid-(WIDTH/2), y+1, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				line(bit, x+wid-1-2, y+(HEIGHT/2)+1, x+wid-(WIDTH/2), y+HEIGHT-1-1, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				if(clicked) dlgdata[DLG_DATA_ACTIVE_TEXTFIELD] = 0;
			} //end
			void text_field(bitmap bit, int x, int y, int wid, char32 buf, int maxchar, TypeAString::TMode tm, untyped dlgdata, int tf_indx, long flags) //start
			{
				bool disabled = flags & FLAG_DISABLE;
				DEFINE HEIGHT = 2+2+Text->FontHeight(DIA_FONT);
				int x2 = x+wid-1, y2 = y+HEIGHT-1;
				frame_rect(bit, x, y, x2, y2, 1, disabled ? PAL[COL_BODY_MAIN_MED] :PAL[COL_FIELD_BG]);
				int txt_x = x+2, txt_y = y+2;
				bool typing = dlgdata[DLG_DATA_ACTIVE_TEXTFIELD]==tf_indx;
				if(typing && !disabled)
				{
					grabType(buf, maxchar, tm); //Grab this frame's keyboard typing, by the set rules.
				}
				
				if(SubEditorData[SED_LCLICKED] && !disabled)
				{
					if(DLGCursorBox(x, y, x2, y2, dlgdata))
					{
						dlgdata[DLG_DATA_ACTIVE_TEXTFIELD]=tf_indx;
					}
					else if(dlgdata[DLG_DATA_ACTIVE_TEXTFIELD]==tf_indx)
					{
						dlgdata[DLG_DATA_ACTIVE_TEXTFIELD]=0;
					}
				}
				
				text(bit, txt_x, txt_y, TF_NORMAL, buf, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_FIELD]);
				if(typing && !disabled)
				{
					unless((SubEditorData[SED_GLOBAL_TIMER]%32)&16)
					{
						text(bit, txt_x+Text->StringWidth(buf, DIA_FONT), txt_y, TF_NORMAL, "|", PAL[COL_TEXT_FIELD]);
					}
				}
			} //end
			void i_proc(bitmap bit, int x, int y, char32 info, untyped dlgdata) //start
			{
				i_proc(bit, x, y, info, dlgdata, false);
			} //end
			void i_proc(bitmap bit, int x, int y, char32 info, untyped dlgdata, bool help) //start
			{
				bool disabled = !strlen(info);
				int col = disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN];
				ProcRet p = insta_button(bit, x, y, 7, 7, "", dlgdata, 0);
				pix(bit, x+3, y+1, col);
				pix(bit, x+2, y+3, col);
				line(bit, x+3, y+3, x+3, y+5, col);
				line(bit, x+2, y+5, x+4, y+5, col);
				if(!disabled && (PROC_CONFIRM==p || (help&&HelpButton())))
				{
					msg_dlg("Information", info);
				}
			} //end
			ProcRet titled_radio(bitmap bit, int x, int y, int rad, untyped dlgdata, untyped proc_data, int proc_indx, int rad_indx, long flags, char32 title) //start
			{
				text(bit, x+rad+3, y - Div(Text->FontHeight(DIA_FONT), 2), TF_NORMAL, title, (flags&FLAG_DISABLE ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]));
				return radio(bit, x, y, rad, dlgdata, proc_data, proc_indx, rad_indx, flags);
			} //end
			void flag_tab(bitmap bit, int x, int y, int wid, int num_per_page, long arr, long use_arr, char32 strings, char32 desc_strings, untyped data, untyped proc_data, int proc_indx /*uses 3*/) //start
			{
				DEFINE FLAGS_HEIGHT = 7;
				int bts = count_bits(use_arr);
				int max = Div(bts-1,num_per_page);
				DEFINE FLAG_TOTAL_HEIGHT = (FLAGS_HEIGHT+2)*num_per_page + 1 + (max < 1 ? 0 : (1 + Text->FontHeight(DIA_FONT)));
				char32 flagsbuf[256];
				sprintf(flagsbuf, "%i/%i", proc_data[proc_indx]+1, max+1);
				frame_rect(bit, x, y, x + wid - 1, y + FLAG_TOTAL_HEIGHT, 1);
				
				int flags_x = x + 2, flags_y = y + 2;
				
				unless(max < 1)
				{
					text(bit, x + (wid/2), flags_y, TF_CENTERED, flagsbuf, PAL[COL_TEXT_MAIN]);
					flags_y += Text->FontHeight(DIA_FONT) + 1;
				}
				
				int overall_indx = 0;
				int indx = 0;
				int offs = 0;
				for(int q = -num_per_page*proc_data[proc_indx]; q < num_per_page; ++overall_indx) //start checkboxes
				{
					if(use_arr[indx] & (FLAG1 << offs))
					{
						if(q >= 0)
						{
							char32 flagbuf[128], descbuf[256];
							char32 flgptr = flagbuf;
							char32 dscptr = descbuf;
							
							if(strings < 0)
								getSpecialString(flagbuf, strings, overall_indx);
							else unless(strings) itoa(flagbuf, overall_indx);
							else if(overall_indx >= SizeOfArray(strings)) strcpy(flagbuf, "---");
							else flgptr = strings[overall_indx];
							unless(flgptr)
							{
								flgptr = flagbuf;
								itoa(flagbuf, overall_indx);
							}
							
							if(desc_strings < 0)
								getSpecialString(descbuf, desc_strings, overall_indx);
							else unless(desc_strings) /*nothing*/;
							else unless(overall_indx >= SizeOfArray(desc_strings)) dscptr = desc_strings[overall_indx];
							unless(dscptr)
							{
								dscptr = descbuf;
								remchr(descbuf, 0);
							}
							
							switch(desc_titled_checkbox(bit, flags_x, flags_y, FLAGS_HEIGHT, arr[indx] & (FLAG1 << offs), data, 0, flgptr, dscptr))
							{
								case PROC_UPDATED_FALSE:
									arr[indx] &= ~(FLAG1 << offs);
									break;
								case PROC_UPDATED_TRUE:
									arr[indx] |= (FLAG1 << offs);
									break;
							}
							flags_y += (FLAGS_HEIGHT+2);
						}
						++q;
					}
					if(++offs >= 32)
					{
						offs %= 32;
						if(++indx >= SizeOfArray(arr))
						{
							if(q <= 0)
							{
								titled_checkbox(bit, flags_x, flags_y, FLAGS_HEIGHT, 0, data, FLAG_DISABLE, "---");
							}
							break;
						}
					}
				} //end checkboxes
				if(max < 1) return;
				DEFINE BUTTON_WIDTH = GEN_BUTTON_HEIGHT, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				//Swap flag tabs
				{
					if(PROC_CONFIRM==button(bit, x, y + FLAG_TOTAL_HEIGHT + 1, BUTTON_WIDTH, BUTTON_HEIGHT, "<", data, proc_data, proc_indx+1, (proc_data[proc_indx] <= 0 ? FLAG_DISABLE : 0)))
					{
						--proc_data[proc_indx];
					}
					if(PROC_CONFIRM==button(bit, x + wid - BUTTON_WIDTH, y + FLAG_TOTAL_HEIGHT + 1, BUTTON_WIDTH, BUTTON_HEIGHT, ">", data, proc_data, proc_indx+2, (proc_data[proc_indx] >= max ? FLAG_DISABLE : 0)))
					{
						++proc_data[proc_indx];
					}
				}
			} //end
			//end
		} //end
		//Flagsets
		DEFINEL FLAG_DISABLE = FLAG1;
		DEFINEL FLAG_DEFAULT = FLAG2;
		//DLG Data Organization
		enum
		{
			DLG_DATA_XOFFS, DLG_DATA_YOFFS, //ints; positional data
			DLG_DATA_WID, DLG_DATA_HEI,
			DLG_DATA_ACTIVE_TEXTFIELD,
			
			DLG_DATA_SZ
		};
		//ProcData s- for global misc storage for the main GUI screen.
		untyped main_proc_data[MAX_INT];
		
		bool delwarn() //start
		{
			return !(sys_settings[SSET_FLAGS1] & SSET_FLAG_DELWARN) || yesno_dlg("Are you sure you want to delete this?") == PROC_CONFIRM;
		} //end
		void gen_startup() //start
		{
			KillClicks();
			KillDLGButtons();
			KillButtons();
		} //end
		void gen_final() //start
		{
			null_screen();
			KillDLGButtons();
		} //end
		//Full DLGs
		//start Edit Object
		void editObj(untyped arr, int mod_indx, bool active) //start
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 256//-32
			     , HEIGHT = 224//-32
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			int old_indx = mod_indx;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			bitmap lastframe = create(WIDTH, HEIGHT);
			lastframe->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "Edit Object #%d - %s";
			char32 module_name[64];
			get_module_name(module_name, arr[M_TYPE]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			
			char32 buf_x[4];
			itoa(buf_x, arr[M_X]);
			char32 buf_y[4];
			itoa(buf_y, arr[M_Y]);
			char32 buf_lyr[2];
			itoa(buf_lyr, arr[M_LAYER]);
			char32 buf_pos[3];
			itoa(buf_pos, mod_indx);
			
			
			char32 argbuf1[16];
			char32 argbuf2[16];
			char32 argbuf3[16];
			char32 argbuf4[16];
			char32 argbuf5[16];
			char32 argbuf6[16];
			char32 argbuf7[16];
			char32 argbuf8[16];
			char32 argbuf9[16];
			char32 argbuf10[16];
			char32 argbuf[11] = {argbuf1, argbuf2, argbuf3, argbuf4, argbuf5, argbuf6, argbuf7, argbuf8, argbuf9, argbuf10, -1};
			for(int q = MODULE_META_SIZE; q < arr[M_SIZE] && argbuf[q-MODULE_META_SIZE] != -1; ++q)
			{
				itoa(argbuf[q-MODULE_META_SIZE], arr[q]);
			}
			
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			untyped proc_data[MAX_INT];
			int curlvl = Game->GetCurLevel();
			int LItem = Game->LItems[curlvl];
			Game->LItems[curlvl] = LI_COMPASS | LI_MAP;
			int prev = 0;
			untyped d[1]; //Dummy vals
			while(running)
			{
				lastframe->Clear(0);
				fullblit(0, lastframe, bit);
				++g_arr[active ? ACTIVE_TIMER : PASSIVE_TIMER];
				g_arr[active ? ACTIVE_TIMER : PASSIVE_TIMER] %= 100000000000000000b;
				
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				char32 TITLEBUF[1024];
				sprintf(TITLEBUF, title, mod_indx, module_name);
				char32 DESCBUF[1024];
				get_module_desc(DESCBUF, arr[M_TYPE]);
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, TITLEBUF, data, DESCBUF)==PROC_CANCEL || CancelButtonP())
					running = false;
				
				if(DEBUG && PROC_CONFIRM==button(bit, WIDTH-(9*3)-1, 2, 7, 7, "D", data, proc_data, 1)) //start
				{
					printf("Debug Printout (%d)\n", mod_indx);
					for(int q = 0; q < arr[M_SIZE]; ++q)
					{
						switch(q)
						{
							case MODULE_META_SIZE:
								TraceNL();
								printf("%d: %d\n", q, arr[q]);
								break;
							
							case M_META_SIZE:
								if(arr[M_META_SIZE] == MODULE_META_SIZE)
									printf("%d: %d\n", q, arr[q]);
								else printf("%d: %d (Bad Size! Should be %d)\n", q, arr[q], MODULE_META_SIZE);
								break;
							
							case M_TYPE:
								char32 buf[64];
								get_module_name(buf, arr[M_TYPE]);
								printf("%d: %d (%s)\n", q, arr[q], buf);
								break;
								
							default:
								printf("%d: %d\n", q, arr[q]);
						}
					}
					printf("/Debug Printout (%d)\n", mod_indx);
				} //end
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				DEFINE ABOVE_BOTTOM_Y = HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT-4;
				//start For all objects
				if(PROC_CONFIRM==button(bit, FRAME_X+BUTTON_WIDTH+3, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 2))
				{
					running = false;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Confirm", data, proc_data, 3, FLAG_DEFAULT))
				{
					running = false;
					do_save_changes = true;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X+(2*(BUTTON_WIDTH+3)), HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "%%77%%Del%ete", data, proc_data, 4, arr[M_TYPE]==MODULE_TYPE_BGCOLOR?FLAG_DISABLE:0))
				{
					if(delwarn())
					{
						running = false;
						SubEditorData[SED_QUEUED_DELETION] = active ? mod_indx : -mod_indx;
						SubEditorData[SED_SELECTED] = 0; //This had to be highlighted to open this menu!
						mod_flags[mod_indx] = 0;
						for(int q = (active ? g_arr[NUM_ACTIVE_MODULES] : g_arr[NUM_PASSIVE_MODULES])-1; q > 0; --q)
						{
							if(mod_flags[q] & MODFLAG_SELECTED)
							{
								SubEditorData[SED_SELECTED] = q;
								break;
							}
						}
						bit->Free();
						gen_final();
						return;
					}
				}
				if(PROC_CONFIRM==button(bit, WIDTH-FRAME_X-BUTTON_WIDTH-10, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH+10, BUTTON_HEIGHT, "Conditionals", data, proc_data, 5, arr[M_TYPE]==MODULE_TYPE_BGCOLOR?FLAG_DISABLE:0))
				{
					do_condsettings(arr);
				}
				
				DEFINE TXTBX_LEFTMARG = 3, TXTBOX_SPACING = 4;
				int tfx = FRAME_X + TXTBX_LEFTMARG + Text->StringWidth("X:",DIA_FONT);
				DEFINE XYBOX_WID = 20;
				int flag = 0;
				switch(arr[M_TYPE])
				{
					case MODULE_TYPE_PASSIVESUBSCREEN:
					case MODULE_TYPE_BGCOLOR:
						flag = FLAG_DISABLE;
					default:
						titled_inc_text_field(bit, tfx, FRAME_Y, XYBOX_WID, buf_x, 3, false, data, 1, flag, min_x(arr), max_x(arr), "X:");
				}
				tfx += XYBOX_WID+TXTBOX_SPACING+Text->StringWidth("Y:",DIA_FONT);
				flag = 0;
				switch(arr[M_TYPE])
				{
					case MODULE_TYPE_BGCOLOR:
						flag = FLAG_DISABLE;
					default:
						titled_inc_text_field(bit, tfx, FRAME_Y, XYBOX_WID, buf_y, 3, true, data, 2, flag, min_y(arr), max_y(arr, active), "Y:");
				}
				tfx += XYBOX_WID+TXTBOX_SPACING+Text->StringWidth("Layer:",DIA_FONT);
				DEFINE LAYERBOX_WID = 24;
				flag = 0;
				switch(arr[M_TYPE])
				{
					case MODULE_TYPE_BGCOLOR:
						flag = FLAG_DISABLE;
					default:
						titled_inc_text_field(bit, tfx, FRAME_Y, LAYERBOX_WID, buf_lyr, 1, false, data, 3, flag, 0, 7, "Layer:");
				}
				tfx += LAYERBOX_WID+TXTBOX_SPACING+Text->StringWidth("Pos:",DIA_FONT);
				DEFINE POSBOX_WID = 24;
				flag = 0;
				switch(arr[M_TYPE])
				{
					case MODULE_TYPE_BGCOLOR:
						flag = FLAG_DISABLE;
					default:
						titled_inc_text_field(bit, tfx, FRAME_Y, POSBOX_WID, buf_pos, 2, false, data, 4, flag, 2, active?g_arr[NUM_ACTIVE_MODULES]-1:g_arr[NUM_PASSIVE_MODULES]-1, "Pos:");
				}
				//end
				DEFINE OBJ_SPEC_PROCDATA_START = 6;
				DEFINE OBJ_SPEC_TFINDX_START = 5;
				
				DEFINE FIELD_WID = 28, FIELD_X = WIDTH - MARGIN_WIDTH - 2 - FIELD_WID;
				switch(arr[M_TYPE]) //start
				{
					case MODULE_TYPE_BGCOLOR: //start
					{
						char32 buf[] = "Color:";
						text(bit, FRAME_X, FRAME_Y+12+5, TF_NORMAL, buf, PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, FRAME_X+Text->StringWidth(buf, DIA_FONT), FRAME_Y+12, 16, 16, arr[P1], data);
						break;
					} //end
					
					case MODULE_TYPE_SEL_ITEM_ID:
					case MODULE_TYPE_SEL_ITEM_CLASS: //start
					{
						titled_inc_text_field(bit, FIELD_X-(FIELD_WID*1), FRAME_Y+12+(10*0), FIELD_WID, argbuf2, 3, true, data, OBJ_SPEC_TFINDX_START+1, 0, -1, MAX_MODULES, "Pos:");
						inc_text_field(bit, FIELD_X-FIELD_WID, FRAME_Y+12+(10*1), FIELD_WID, argbuf3, 3, true, data, OBJ_SPEC_TFINDX_START+2, 0, -1, MAX_MODULES);
						inc_text_field(bit, FIELD_X-FIELD_WID, FRAME_Y+12+(10*3), FIELD_WID, argbuf4, 3, true, data, OBJ_SPEC_TFINDX_START+3, 0, -1, MAX_MODULES);
						inc_text_field(bit, FIELD_X-(FIELD_WID*2), FRAME_Y+12+(10*2), FIELD_WID, argbuf5, 3, true, data, OBJ_SPEC_TFINDX_START+4, 0, -1, MAX_MODULES);
						inc_text_field(bit, FIELD_X, FRAME_Y+12+(10*2), FIELD_WID, argbuf6, 3, true, data, OBJ_SPEC_TFINDX_START+5, 0, -1, MAX_MODULES);
						text(bit, FIELD_X-FIELD_WID/2, FRAME_Y+14+(10*2), TF_CENTERED, "Dirs", PAL[COL_TEXT_MAIN]);
					} //end
					//fallthrough
					case MODULE_TYPE_NONSEL_ITEM_ID:
					case MODULE_TYPE_NONSEL_ITEM_CLASS: //start
					{
						bool class = arr[M_TYPE] == MODULE_TYPE_SEL_ITEM_CLASS || arr[M_TYPE] == MODULE_TYPE_NONSEL_ITEM_CLASS;
						char32 buf[16];
						strcpy(buf, class ? "Class:" : "Item:");
						if(class)
						{
							titled_inc_text_field(bit, FRAME_X + Text->StringWidth(buf, DIA_FONT)+2, FRAME_Y+12, FIELD_WID, argbuf1, 3, false, data, OBJ_SPEC_TFINDX_START+0, 0, MIN_ITEMDATA, MAX_ITEMDATA, buf);
							arr[P1] = VBound(atoi(argbuf1), MAX_ITEMDATA, MIN_ITEMDATA);
							DEFINE ITMX = (FRAME_X + 2), ITMY = FRAME_Y+25;
							frame_rect(bit, ITMX-1, ITMY-1, ITMX+16, ITMY+16, 1);
							int itmid = get_item_of_class(arr[P1]);
							if(itmid < 0) itmid = get_item_of_class(arr[P1], true);
							if(itmid < 0) itmid = 0;
							itm(bit, ITMX, ITMY, itmid);
						}
						else
						{
							arr[P1] = itemsel_bundle(bit, FRAME_X+1, FRAME_Y+14, arr[P1], data, lastframe, 0, OBJ_SPEC_TFINDX_START+0, "Item:", false);
							//text(bit, FRAME_X, FRAME_Y+14, TF_NORMAL, buf, PAL[COL_TEXT_MAIN]);
							//arr[P1] = dropdown_inc_text_combo(bit, FRAME_X + Text->StringWidth(buf, DIA_FONT)+2, FRAME_Y+12, 112, arr[P1], data, SSL_ITEM, -1, 10, lastframe, 0, FIELD_WID, 3, false, 5, 0, MAX_ITEMDATA, true);
						}
						break;
					} //end
					
					case MODULE_TYPE_BUTTONITEM: //start
					{
						DEFINE RADIO_RAD = 5;
						DEFINE RAD_X = FRAME_X + RADIO_RAD;
						DEFINE RAD_Y = FRAME_Y + 12 + RADIO_RAD;
						DEFINE RAD_YDIFF = RADIO_RAD*2 + 3;
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*0), RADIO_RAD, data, arr, P1, CB_A, 0, "A");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*1), RADIO_RAD, data, arr, P1, CB_B, 0, "B");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*2), RADIO_RAD, data, arr, P1, CB_L, 0, "L");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*3), RADIO_RAD, data, arr, P1, CB_R, 0, "R");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*4), RADIO_RAD, data, arr, P1, CB_EX1, 0, "EX1");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*5), RADIO_RAD, data, arr, P1, CB_EX2, 0, "EX2");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*6), RADIO_RAD, data, arr, P1, CB_EX3, 0, "EX3");
						titled_radio(bit, RAD_X, RAD_Y + (RAD_YDIFF*7), RADIO_RAD, data, arr, P1, CB_EX4, 0, "EX4");
						break;
					} //end
					case MODULE_TYPE_PASSIVESUBSCREEN: //start
					{
						break;
					} //end
					
					case MODULE_TYPE_MINIMAP: //start
					{
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Current Color:", PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P1], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "Explored Color:", PAL[COL_TEXT_MAIN]);
						arr[P2] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P2], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Unexplored Color:", PAL[COL_TEXT_MAIN]);
						arr[P3] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P3], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*3), TF_RIGHT, "Compass Color:", PAL[COL_TEXT_MAIN]);
						arr[P4] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*3), 16, 16, arr[P4], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*4), TF_RIGHT, "Compass Dead Color:", PAL[COL_TEXT_MAIN]);
						arr[P5] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*4), 16, 16, arr[P5], data);
						
						char32 buf1[] = "Comp. Blink Rate:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12+3, 28, argbuf6, 2, false, data, OBJ_SPEC_TFINDX_START+0, 0, 1, 9, buf1);
						arr[P6] = VBound(atoi(argbuf6), 9, 1);
						
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 0), 7, arr[M_FLAGS1]&FLAG_MMP_COMP_ON_BOSS, data, 0, "Compass Points to Boss", "The compass will end once the boss is dead, instead of when the triforce is collected."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_COMP_ON_BOSS;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_COMP_ON_BOSS;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 1), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_OW, data, 0, "Show Explored - OW", "Shows explored rooms on Overworld dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_OW;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_OW;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 2), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW, data, 0, "Show Explored - BS-OW", "Shows explored rooms on BS Overworld dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 3), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON, data, 0, "Show Explored - DNG", "Shows explored rooms on Dungeon dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 4), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR, data, 0, "Show Explored - INT", "Shows explored rooms on Interior dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 5), 7, arr[M_FLAGS1]&FLAG_MMP_COMPASS_BLINK_DOESNT_STOP, data, 0, "Blink Continues", "The compass will continue blinking even after it changes color"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_COMPASS_BLINK_DOESNT_STOP;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_COMPASS_BLINK_DOESNT_STOP;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 6), 7, arr[M_FLAGS1]&FLAG_MMP_IGNORE_DMAP_BGTILE, data, 0, "Ignore DMap-specfic BG", "The MiniMap BG tile set in the DMap editor will be ignored"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_IGNORE_DMAP_BGTILE;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_IGNORE_DMAP_BGTILE;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 7), 7, arr[M_FLAGS1]&FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS, data, 0, "Larger Markers", "On 8x8 dmaps, the player position and compass markers will take the full 7x3, instead of the center 3x3."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS;
								break;
						}
						DEFINE MMY = ABOVE_BOTTOM_Y-48;
						DEFINE MMX = WIDTH - FRAME_X - 80 - 2;
						frame_rect(bit, MMX-1, MMY-1, MMX+81, MMY+49, 1);
						text(bit, MMX - 3, MMY, TF_RIGHT, "Preview:", PAL[COL_TEXT_MAIN]);
						char32 buf[] = "Defeated";
						switch(r_titled_checkbox(bit, MMX - 10 - Text->StringWidth(buf, DIA_FONT), MMY + 8, 7, prev&1b, data, 0, buf))
						{
							case PROC_UPDATED_FALSE:
								prev~=1b;
								break;
							case PROC_UPDATED_TRUE:
								prev|=1b;
								break;
						}
						char32 bufm16[] = "16x8 Tile";
						char32 bufm8[] = " 8x8 Tile";
						int tilearr[2] = {arr[P7], arr[P8]};
						text(bit, FRAME_X, FRAME_Y + 25 + (10 * 8) + 4, TF_NORMAL, bufm16, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X + Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8), tilearr, data, false);
						arr[P7] = tilearr[0];
						arr[P8] = tilearr[1];
						tilearr[0] = arr[P9];
						tilearr[1] = arr[P10];
						text(bit, FRAME_X+ Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8) + 20 + 4, TF_RIGHT, bufm8, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X + Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8) + 20, tilearr, data, false);
						arr[P9] = tilearr[0];
						arr[P10] = tilearr[1];
						if(prev&1b)
							Game->LItems[Game->GetCurLevel()] |= LI_BOSS | LI_TRIFORCE;
						minimap(arr, 0, bit, active, MMX, MMY);
						Game->LItems[Game->GetCurLevel()] ~= LI_BOSS | LI_TRIFORCE;
						break;
					} //end
					
					case MODULE_TYPE_BIGMAP: //start
					{
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Current Color:", PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P1], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "Explored Color:", PAL[COL_TEXT_MAIN]);
						arr[P2] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P2], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Unexplored Color:", PAL[COL_TEXT_MAIN]);
						arr[P3] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P3], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*3), TF_RIGHT, "Compass Color:", PAL[COL_TEXT_MAIN]);
						arr[P4] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*3), 16, 16, arr[P4], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*4), TF_RIGHT, "Compass Dead Color:", PAL[COL_TEXT_MAIN]);
						arr[P5] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*4), 16, 16, arr[P5], data);
						
						char32 buf1[] = "Comp. Blink Rate:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12+3, 28, argbuf6, 2, false, data, OBJ_SPEC_TFINDX_START+0, 0, 1, 9, buf1);
						arr[P6] = VBound(atoi(argbuf6), 9, 1);
						
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 0), 7, arr[M_FLAGS1]&FLAG_MMP_COMP_ON_BOSS, data, 0, "Compass Points to Boss", "The compass will end once the boss is dead, instead of when the triforce is collected."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_COMP_ON_BOSS;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_COMP_ON_BOSS;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 1), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_OW, data, 0, "Show Explored - OW", "Shows explored rooms on Overworld dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_OW;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_OW;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 2), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW, data, 0, "Show Explored - BS-OW", "Shows explored rooms on BS Overworld dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_BSOW;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 3), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON, data, 0, "Show Explored - DNG", "Shows explored rooms on Dungeon dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_DUNGEON;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 4), 7, arr[M_FLAGS1]&FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR, data, 0, "Show Explored - INT", "Shows explored rooms on Interior dmaps"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_SHOW_EXPLORED_ROOMS_INTERIOR;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 5), 7, arr[M_FLAGS1]&FLAG_MMP_COMPASS_BLINK_DOESNT_STOP, data, 0, "Blink Continues", "The compass will continue blinking even after it changes color"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_COMPASS_BLINK_DOESNT_STOP;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_COMPASS_BLINK_DOESNT_STOP;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 6), 7, arr[M_FLAGS1]&FLAG_MMP_IGNORE_DMAP_BGTILE, data, 0, "Ignore DMap-specfic BG", "The Large Map BG tile set in the DMap editor will be ignored"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_IGNORE_DMAP_BGTILE;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_IGNORE_DMAP_BGTILE;
								break;
						}
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 25 + (10 * 7), 7, arr[M_FLAGS1]&FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS, data, 0, "Larger Markers", "The player position and compass markers will cover the whole room, rather than just a rectangle in the center of it."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MMP_LARGE_PLAYER_COMPASS_MARKERS;
								break;
						}
						DEFINE MMY = ABOVE_BOTTOM_Y - BIGMAP_THEI * 16;
						DEFINE MMX = WIDTH - FRAME_X - BIGMAP_TWID * 16 - 2;
						frame_rect(bit, MMX-1, MMY-1, MMX + 1 + BIGMAP_TWID * 16, MMY+1+BIGMAP_THEI*16, 1);
						text(bit, MMX - 3, MMY, TF_RIGHT, "Preview:", PAL[COL_TEXT_MAIN]);
						char32 buf[] = "Defeated";
						switch(r_titled_checkbox(bit, MMX - 10 - Text->StringWidth(buf, DIA_FONT), MMY + 8, 7, prev&1b, data, 0, buf))
						{
							case PROC_UPDATED_FALSE:
								prev~=1b;
								break;
							case PROC_UPDATED_TRUE:
								prev|=1b;
								break;
						}
						char32 bufm16[] = "16x8 Tile";
						char32 bufm8[] = " 8x8 Tile";
						int tilearr[2] = {arr[P7], arr[P8]};
						text(bit, FRAME_X, FRAME_Y + 25 + (10 * 8) + 4, TF_NORMAL, bufm16, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X + Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8), tilearr, data, false);
						arr[P7] = tilearr[0];
						arr[P8] = tilearr[1];
						tilearr[0] = arr[P9];
						tilearr[1] = arr[P10];
						text(bit, FRAME_X+ Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8) + 20 + 4, TF_RIGHT, bufm8, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X + Text->StringWidth(bufm16, DIA_FONT), FRAME_Y + 25 + (10 * 8) + 20, tilearr, data, false);
						arr[P9] = tilearr[0];
						arr[P10] = tilearr[1];
						if(prev&1b)
							Game->LItems[Game->GetCurLevel()] |= LI_BOSS | LI_TRIFORCE;
						bigmap(arr, 0, bit, active, MMX, MMY);
						Game->LItems[Game->GetCurLevel()] ~= LI_BOSS | LI_TRIFORCE;
						break;
					} //end
					
					case MODULE_TYPE_TILEBLOCK: //start
					{
						char32 buftl[] = "Tile:";
						int tlarr[2] = {arr[P1], arr[P2]};
						text(bit, FRAME_X+3, FRAME_Y+21, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X+3+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						
						char32 buf1[] = "Wid:";
						titled_inc_text_field(bit, FRAME_X+27+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+19, 28, argbuf3, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 1, 16, buf1);
						arr[P3] = VBound(atoi(argbuf3), 16, 1);
						char32 buf2[] = "Hei:";
						titled_inc_text_field(bit, FRAME_X+59+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+19, 28, argbuf4, 2, false, data, OBJ_SPEC_TFINDX_START+2, 0, 1, 14, buf2);
						arr[P4] = VBound(atoi(argbuf4), 14, 1);
						
						DEFINE PREVWID = arr[P3] * 16;
						DEFINE PREVHEI = VBound(arr[P4] * 16, 16*9, 0);
						DEFINE PREVY = ABOVE_BOTTOM_Y-PREVHEI;
						frame_rect(bit, (WIDTH/2)-(PREVWID/2), PREVY-1, (WIDTH/2)+(PREVWID/2), PREVY+PREVHEI, 1);
						text(bit, WIDTH/2, PREVY-8, TF_CENTERED, "Preview (Shows max 16x9):", PAL[COL_TEXT_MAIN]);
						tilebl(bit, (WIDTH/2)-(PREVWID/2)+1, PREVY, arr[P1], arr[P2], PREVWID/16, PREVHEI/16);
						break;
					} //end
					
					case MODULE_TYPE_HEARTROW: //start
					{
						char32 buf1[] = "Heart Count:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+39, 28, argbuf4, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, MAX_INT, buf1);
						arr[P4] = VBound(atoi(argbuf4), 32, 1);
						char32 buf2[] = "Spacing:";
						titled_inc_text_field(bit, FRAME_X+35+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+39, 28, argbuf5, 2, false, data, OBJ_SPEC_TFINDX_START+2, 0, buf2);
						arr[P5] = atoi(argbuf5);
						
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 53, 7, arr[M_FLAGS1]&FLAG_HROW_RTOL, data, 0, "Right to Left", "This row of hearts fills from right to left, instead of left to right."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_HROW_RTOL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_HROW_RTOL;
								break;
						}
					} //end
					//fallthrough
					case MODULE_TYPE_HEART: //start
					{
						bool isSingle = arr[M_TYPE] == MODULE_TYPE_HEART;
						char32 buftl[] = "Tile:";
						int tlarr[2] = {arr[P1], arr[P2]};
						text(bit, FRAME_X+3, FRAME_Y+23, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X+3+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						
						char32 buf3[] = "Heart Num:";
						titled_inc_text_field(bit, FRAME_X+27+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+19, 28, argbuf3, 2, false, data, OBJ_SPEC_TFINDX_START+0, 0, 0, MAX_INT, buf3);
						arr[P3] = Max(atoi(argbuf3), 0);
						//start Preview
						DEFINE PREVIEW_WID = 16*8;
						DEFINE PREVIEW_X = (WIDTH/2) - (PREVIEW_WID/2) + 1;
						DEFINE PREVIEW_Y = ABOVE_BOTTOM_Y-16;
						frame_rect(bit, (WIDTH/2) - (PREVIEW_WID/2), PREVIEW_Y-1, (WIDTH/2) + (PREVIEW_WID/2)+1, ABOVE_BOTTOM_Y, 1);
						for(int tl = 0; tl < 4; ++tl)
						{
							for(int crn = 0; crn < 4; ++crn)
							{
								minitile(bit, PREVIEW_X + ((crn+(tl*4))*8), PREVIEW_Y, arr[P1]+tl+1, arr[P2], crn);
							}
						}
						minitile(bit, (WIDTH/2)-4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 0);
						unless(isSingle)
						{
							minitile(bit, (WIDTH/2)-12, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 2);
							minitile(bit, (WIDTH/2)+4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 3);
						}
						text(bit, WIDTH/2, PREVIEW_Y-8, TF_CENTERED, "Preview:", PAL[COL_TEXT_MAIN]);
						//end Preview
						break;
					} //end
					
					case MODULE_TYPE_MAGICROW: //start
					{
						char32 buf1[] = "Magic Count:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+39, 28, argbuf4, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, MAX_INT, buf1);
						arr[P4] = VBound(atoi(argbuf4), 32, 1);
						char32 buf2[] = "Spacing:";
						titled_inc_text_field(bit, FRAME_X+35+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+39, 28, argbuf5, 2, false, data, OBJ_SPEC_TFINDX_START+2, 0, buf2);
						arr[P5] = atoi(argbuf5);
						
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 53, 7, arr[M_FLAGS1]&FLAG_MROW_RTOL, data, 0, "Right to Left", "This row of magics fills from right to left, instead of left to right."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_MROW_RTOL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_MROW_RTOL;
								break;
						}
					} //end
					//fallthrough
					case MODULE_TYPE_MAGIC: //start
					{
						bool isSingle = arr[M_TYPE] == MODULE_TYPE_MAGIC;
						bool isHalf = isSingle && (arr[M_FLAGS1] & FLAG_MAG_ISHALF);
						char32 buftl[] = "Tile:";
						int tlarr[2] = {arr[P1], arr[P2]};
						text(bit, FRAME_X+3, FRAME_Y+23, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X+3+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						
						char32 buf3[] = "Magic Num:";
						titled_inc_text_field(bit, FRAME_X+27+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+19, 28, argbuf3, 2, false, data, OBJ_SPEC_TFINDX_START+0, isHalf ? FLAG_DISABLE : 0, 0, MAX_INT, buf3);
						arr[P3] = Max(atoi(argbuf3), 0);
						
						if(isSingle)
						{
							switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 39, 7, arr[M_FLAGS1]&FLAG_MAG_ISHALF, data, 0, "Is Half", "This magic unit is not a normal unit, but instead is the half magic icon."))
							{
								case PROC_UPDATED_FALSE:
									arr[M_FLAGS1]~=FLAG_MAG_ISHALF;
									break;
								case PROC_UPDATED_TRUE:
									arr[M_FLAGS1]|=FLAG_MAG_ISHALF;
									break;
							}
						}
						
						//start Preview
						DEFINE PREVIEW_WID = 16*8;
						DEFINE PREVIEW_HALF_WID = 1*8;
						DEFINE PREVIEW_X = (WIDTH/2) - (PREVIEW_WID/2) + 1;
						DEFINE PREVIEW_HALF_X = (WIDTH/2) - (PREVIEW_HALF_WID/2) + 1;
						DEFINE PREVIEW_Y = ABOVE_BOTTOM_Y-24;
						if(isHalf)
						{
							frame_rect(bit, (WIDTH/2) - (PREVIEW_HALF_WID/2), ABOVE_BOTTOM_Y-9, (WIDTH/2) + (PREVIEW_HALF_WID/2), ABOVE_BOTTOM_Y, 1);
							minitile(bit, PREVIEW_HALF_X, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 1);
						}
						else
						{
							frame_rect(bit, (WIDTH/2) - (PREVIEW_WID/2), PREVIEW_Y-1, (WIDTH/2) + (PREVIEW_WID/2)+1, ABOVE_BOTTOM_Y, 1);
							for(int row = 0; row < 2; ++row)
							{
								for(int tl = 0; tl < 4; ++tl)
								{
									for(int crn = 0; crn < 4; ++crn)
									{
										minitile(bit, PREVIEW_X + ((crn+(tl*4))*8), PREVIEW_Y+(row*8), arr[P1]+(tl+(row*4))+1, arr[P2], crn);
									}
								}
							}
							minitile(bit, (WIDTH/2)-4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 0);
							unless(isSingle)
							{
								minitile(bit, (WIDTH/2)-12, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 2);
								minitile(bit, (WIDTH/2)+4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 3);
							}
						}
						text(bit, WIDTH/2, PREVIEW_Y-8, TF_CENTERED, "Preview:", PAL[COL_TEXT_MAIN]);
						//end Preview
						break;
					} //end
					
					case MODULE_TYPE_CRROW: //start
					{
						char32 buf1[] = "Piece Count:";
						titled_inc_text_field(bit, FRAME_X+5+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+48+12, 28, argbuf6, 2, false, data, OBJ_SPEC_TFINDX_START+3, 0, 0, MAX_INT, buf1);
						arr[P6] = VBound(atoi(argbuf6), 32, 1);
						char32 buf2[] = "Spacing:";
						titled_inc_text_field(bit, FRAME_X+37+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+48+12, 28, argbuf7, 2, false, data, OBJ_SPEC_TFINDX_START+4, 0, buf2);
						arr[P7] = atoi(argbuf7);
						
						switch(desc_titled_checkbox(bit, FRAME_X+3, FRAME_Y + 48+24, 7, arr[M_FLAGS1]&FLAG_CRROW_RTOL, data, 0, "Right to Left", "This row of magics fills from right to left, instead of left to right."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_CRROW_RTOL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_CRROW_RTOL;
								break;
						}
					} //end
					//fallthrough
					case MODULE_TYPE_CRPIECE: //start
					{
						bool isSingle = arr[M_TYPE] == MODULE_TYPE_CRPIECE;
						
						char32 buftl[] = "Tile:";
						int tlarr[2] = {arr[P1], arr[P2]};
						text(bit, FRAME_X+3, FRAME_Y+23, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X+4+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						
						char32 buf3[] = "Piece Num:";
						titled_inc_text_field(bit, FRAME_X+27+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+19, 28, argbuf3, 2, false, data, OBJ_SPEC_TFINDX_START+0, 0, 0, MAX_INT, buf3);
						arr[P3] = Max(atoi(argbuf3), 0);
						
						char32 buf1[] = "Counter:";
						//titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+39, 28, argbuf4, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, MIN_COUNTER_INDX, MAX_COUNTER_INDX, buf1);
						//arr[P4] = VBound(atoi(argbuf4), 32, 1);
						text(bit, FRAME_X+3, FRAME_Y+39, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						arr[P4] = dropdown_proc(bit, FRAME_X+5+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+37, 96, arr[P4], data, SSL_COUNTER, -1, 10, lastframe, 0);
						char32 buf2[] = "Per Container:";
						titled_inc_text_field(bit, FRAME_X+5+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+48, 40, argbuf5, 5, false, data, OBJ_SPEC_TFINDX_START+2, 0, 1, MAX_COUNTER, buf2);
						arr[P5] = atoi(argbuf5);
						
						//start Preview
						DEFINE PREVIEW_WID = Min(arr[P5],16)*8;
						DEFINE PREVIEW_NUM_ROW = Ceiling(arr[P5]/16);
						DEFINE PREVIEW_X = (WIDTH/2) - (PREVIEW_WID/2) + 1;
						DEFINE PREVIEW_Y = ABOVE_BOTTOM_Y-((PREVIEW_NUM_ROW+1)*8);
						DEFINE PREV_RECT_WID = Max(PREVIEW_WID, 24);
						frame_rect(bit, (WIDTH/2) - (PREV_RECT_WID/2), PREVIEW_Y-1, (WIDTH/2) + (PREV_RECT_WID/2)+1, ABOVE_BOTTOM_Y, 1);
						for(int row = 0; row < PREVIEW_NUM_ROW; ++row)
						{
							if(row*16 > arr[P5]) break;
							for(int tl = 0; tl < 4; ++tl)
							{
								if(row*16 + tl*4 > arr[P5]) break;
								for(int crn = 0; crn < 4; ++crn)
								{
									if(row*16 + tl*4 + crn > arr[P5]) break;
									minitile(bit, PREVIEW_X + ((crn+(tl*4))*8), PREVIEW_Y+(row*8), arr[P1]+(tl+(row*4))+1, arr[P2], crn);
								}
							}
						}
						minitile(bit, (WIDTH/2)-4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 0);
						unless(isSingle)
						{
							minitile(bit, (WIDTH/2)-12, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 2);
							minitile(bit, (WIDTH/2)+4, ABOVE_BOTTOM_Y-8, arr[P1], arr[P2], 3);
						}
						text(bit, WIDTH/2, PREVIEW_Y-8, TF_CENTERED, "Preview:", PAL[COL_TEXT_MAIN]);
						//end Preview
						break;
					} //end
					
					case MODULE_TYPE_COUNTER: //start
					{
						char32 buf1[] = "Font:";
						text(bit, FRAME_X, FRAME_Y+12+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						arr[P1] = dropdown_proc(bit, FRAME_X+Text->StringWidth(buf1, DIA_FONT)+2, FRAME_Y+12, DDWN_WID_FONT, arr[P1], data, SSL_FONT, -1, 6, lastframe, 0);
						
						char32 buf2[] = "Align:";
						text(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12+2, TF_NORMAL, buf2, PAL[COL_TEXT_MAIN]);
						arr[M_FLAGS1] = (arr[M_FLAGS1] & ~MASK_CNTR_ALIGN)
						              | (1L * dropdown_proc(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+12, DDWN_WID_ALIGN, (arr[M_FLAGS1]&MASK_CNTR_ALIGN)/1L, data, SSL_ALIGNMENT, -1, 3, lastframe, 0));
						
						char32 buf3[] = "Counter:";
						if(arr[M_FLAGS1]&FLAG_CNTR_SPECIAL)
						{
							text(bit, FRAME_X, FRAME_Y+26, TF_NORMAL, buf3, PAL[COL_TEXT_MAIN]);
							arr[P2] = dropdown_proc(bit, FRAME_X+2+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+24, 64, arr[P2], data, SSL_SP_CNTR, -1, 10, lastframe, 0);
						}
						else
						{
							text(bit, FRAME_X, FRAME_Y+26, TF_NORMAL, buf3, PAL[COL_TEXT_MAIN]);
							arr[P2] = dropdown_proc(bit, FRAME_X+2+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+24, 96, arr[P2], data, SSL_COUNTER, -1, 10, lastframe, 0);
						}
						char32 buf4[] = "Min Digits:";
						titled_inc_text_field(bit, FRAME_X+102+Text->StringWidth(buf3, DIA_FONT)+Text->StringWidth(buf4, DIA_FONT), FRAME_Y+24, 20, argbuf5, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 5, buf4);
						arr[P5] = atoi(argbuf5);
						
						
						
						switch(titled_checkbox(bit, FRAME_X, FRAME_Y + 50 + (10 * 0), 7, arr[M_FLAGS1]&FLAG_CNTR_SPECIAL, data, 0, "Special Counter"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_CNTR_SPECIAL;
								remchr(argbuf2,0);
								argbuf2[0] = '0';
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_CNTR_SPECIAL;
								arr[P2] = 0;
								break;
						}
						arr[P9] = dropdown_proc(bit, FRAME_X, FRAME_Y + 37, 80, arr[P9], data, SSL_SHADOWTYPE, -1, 11, lastframe, 0);
						/*switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 37 + (10 * 1), 7, arr[M_FLAGS1]&FLAG_CNTR_SHADOWED, data, 0, "Shadow", "Counter text displays a shadow."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_CNTR_SHADOWED;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_CNTR_SHADOWED;
								break;
						}*/
						switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y + 50 + (10 * 1), 7, arr[M_FLAGS1]&FLAG_CNTR_SPACE_INSTEAD_LEAD_ZERO, data, 0, "Hide Leading Zeros", "Leading zeros will be replaced with spaces."))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_CNTR_SPACE_INSTEAD_LEAD_ZERO;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_CNTR_SPACE_INSTEAD_LEAD_ZERO;
								break;
						}
						
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Text:", PAL[COL_TEXT_MAIN]);
						arr[P6] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P6], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "BG:", PAL[COL_TEXT_MAIN]);
						arr[P7] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P7], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Shadow:", PAL[COL_TEXT_MAIN]);
						arr[P8] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P8], data);
						
						arr[P3] = itemsel_bundle(bit, WIDTH-FRAME_X-133, FRAME_Y+66-Text->FontHeight(DIA_FONT),
						                         arr[P3], data, lastframe, 0, 6, "Infinite Item:", true);
						char32 bf[2] = {arr[P4]};
						titled_text_field(bit, WIDTH-FRAME_X-11, FRAME_Y+88+Text->FontHeight(DIA_FONT), 10, bf, 1, TypeAString::TMODE_ALPHANUMERIC_SYMBOLS, data, OBJ_SPEC_TFINDX_START+2, 0, "Inf. Char:");
						arr[P4] = bf[0];
						
						//
						DEFINE P_C_X = WIDTH/2;
						DEFINE P_BMP_WID = 64;
						int p_hei = Text->FontHeight(arr[P1])+2;
						DEFINE P_Y = ABOVE_BOTTOM_Y - p_hei;
						line(bit, P_C_X, P_Y - 3, P_C_X, P_Y + p_hei + 2, PAL[COL_NULL]);
						bitmap sub = create(P_BMP_WID, p_hei+1);
						long al = arr[M_FLAGS1] & MASK_CNTR_ALIGN;
						arr[M_FLAGS1] ~= MASK_CNTR_ALIGN;
						int p_wid = 1+counter(arr, 0, sub, 1, 2, 2);
						arr[M_FLAGS1] |= al;
						frame_rect(sub, 0, 0, ++p_wid, p_hei++, 1);
						switch(al/1L)
						{
							case TF_NORMAL: default:
								sub->Blit(1,bit,0,0,P_BMP_WID,p_hei,P_C_X,P_Y,P_BMP_WID,p_hei, 0, 0, 0, 0, 0, true);
								break;
							case TF_RIGHT:
								sub->Blit(1,bit,0,0,P_BMP_WID,p_hei,P_C_X-p_wid,P_Y,P_BMP_WID,p_hei, 0, 0, 0, 0, 0, true);
								break;
							case TF_CENTERED:
								sub->Blit(1,bit,0,0,P_BMP_WID,p_hei,P_C_X-p_wid/2,P_Y,P_BMP_WID,p_hei, 0, 0, 0, 0, 0, true);
								break;
						}
						sub->Free();
						break;
					} //end
					case MODULE_TYPE_MINITILE: //start
					{
						char32 buftl[] = "Minitile:";
						untyped tlarr[3] = {arr[P1], arr[P2],arr[M_FLAGS1]&MASK_MINITL_CRN};
						text(bit, FRAME_X+3, FRAME_Y+21, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						minitile_swatch(bit, FRAME_X+3+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						arr[M_FLAGS1] = (arr[M_FLAGS1] & ~MASK_MINITL_CRN) | tlarr[2];
						
						DEFINE PREVY = ABOVE_BOTTOM_Y-8;
						frame_rect(bit, (WIDTH/2)-4, PREVY-1, (WIDTH/2)+4, PREVY+8, 1);
						text(bit, WIDTH/2, PREVY-8, TF_CENTERED, "Preview:", PAL[COL_TEXT_MAIN]);
						minitile(bit, (WIDTH/2)-3, PREVY, arr[P1], arr[P2], 10000*(arr[M_FLAGS1]&MASK_MINITL_CRN));
						break;
					} //end
					case MODULE_TYPE_CLOCK: //start
					{
						char32 buf1[] = "Font:";
						text(bit, FRAME_X, FRAME_Y+12+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						arr[P1] = dropdown_proc(bit, FRAME_X+Text->StringWidth(buf1, DIA_FONT)+2, FRAME_Y+12, DDWN_WID_FONT, arr[P1], data, SSL_FONT, -1, 6, lastframe, 0);
						
						arr[P5] = dropdown_proc(bit, FRAME_X, FRAME_Y + 25, 80, arr[P5], data, SSL_SHADOWTYPE, -1, 11, lastframe, 0);
						
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Text:", PAL[COL_TEXT_MAIN]);
						arr[P2] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P2], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "BG:", PAL[COL_TEXT_MAIN]);
						arr[P3] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P3], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Shadow:", PAL[COL_TEXT_MAIN]);
						arr[P4] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P4], data);
							
						//
						DEFINE P_C_X = WIDTH/2;
						int p_hei = Text->FontHeight(arr[P1])+1;
						DEFINE P_Y = ABOVE_BOTTOM_Y - p_hei;
						//
						char32 clkbuf[32];
						sprintf(clkbuf, "%02d:%02d:%02d",time::Hours(),time::Minutes(),time::Seconds());
						int p_wid = Text->StringWidth(clkbuf, arr[P1])+1;
						int bg = arr[P3];
						int shd = arr[P4];
						int shd_t = arr[P5];
						unless(bg) bg = -1;
						unless(shd) shd_t = SHD_NORMAL;
						frame_rect(bit, P_C_X-(p_wid/2)-1, P_Y-2, P_C_X+(p_wid/2)+1, P_Y+p_hei+1, 1);
						bit->DrawString(0, P_C_X-(p_wid/2)+1,P_Y, arr[P1], arr[P2], bg, TF_NORMAL, clkbuf, OP_OPAQUE, shd_t, shd);
						break;
					} //end
					case MODULE_TYPE_ITEMNAME: //start
					{
						char32 buf1[] = "Font:";
						text(bit, FRAME_X, FRAME_Y+12+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						arr[P1] = dropdown_proc(bit, FRAME_X+Text->StringWidth(buf1, DIA_FONT)+2, FRAME_Y+12, DDWN_WID_FONT, arr[P1], data, SSL_FONT, -1, 6, lastframe, 0);
						
						arr[P5] = dropdown_proc(bit, FRAME_X, FRAME_Y + 37, 80, arr[P5], data, SSL_SHADOWTYPE, -1, 11, lastframe, 0);
						
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Text:", PAL[COL_TEXT_MAIN]);
						arr[P2] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P2], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "BG:", PAL[COL_TEXT_MAIN]);
						arr[P3] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P3], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Shadow:", PAL[COL_TEXT_MAIN]);
						arr[P4] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P4], data);
						
						
						char32 buf2[] = "Align:";
						text(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12+2, TF_NORMAL, buf2, PAL[COL_TEXT_MAIN]);
						arr[M_FLAGS1] = (arr[M_FLAGS1] & ~MASK_ITEMNM_ALIGN)
						              | (1L * dropdown_proc(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+12, DDWN_WID_ALIGN, (arr[M_FLAGS1]&MASK_ITEMNM_ALIGN)/1L, data, SSL_ALIGNMENT, -1, 3, lastframe, 0));
						
						char32 buf3[] = "Width:";
						titled_inc_text_field(bit, FRAME_X+2+Text->StringWidth(buf3, DIA_FONT), FRAME_Y+24, 32, argbuf6, 3, false, data, OBJ_SPEC_TFINDX_START+0, 0, 0, 256, buf3);
						arr[P6] = VBound(atoi(argbuf6), 256, 0);
						char32 buf4[] = "VSpace:";
						titled_inc_text_field(bit, FRAME_X+38+Text->StringWidth(buf3, DIA_FONT)+Text->StringWidth(buf4, DIA_FONT), FRAME_Y+24, 32, argbuf7, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 16, buf4);
						arr[P7] = VBound(atoi(argbuf7), 16, 0);
						
						//
						int bg = arr[P3];
						int shd = arr[P4];
						int shd_t = arr[P5];
						unless(bg) bg = -1;
						unless(shd) shd_t = SHD_NORMAL;
						//
						
						text(bit, WIDTH-FRAME_X-133, FRAME_Y+12 + (18*3)-Text->FontHeight(DIA_FONT), TF_NORMAL, "Preview Item:", PAL[COL_TEXT_MAIN]);
						d[0] = dropdown_inc_text_combo(bit, WIDTH-FRAME_X-133, FRAME_Y+12 + (18*3), 104, d[0], data, SSL_ITEM, -1, 10, lastframe, 0, 28, 3, false, OBJ_SPEC_TFINDX_START+2, MIN_ITEMDATA, MAX_ITEMDATA, true);
						char32 testbuf[64];
						Game->LoadItemData(d[0])->GetName(testbuf);
						DEFINE P_C_X = WIDTH/2;
						int p_hei = (arr[P6] > 0)
						            ? (DrawStringsCount(arr[P1], testbuf, arr[P6]) * (Text->FontHeight(arr[P1])+arr[P7]) - arr[P7])
						            : (Text->FontHeight(arr[P1])+1);
						DEFINE P_Y = ABOVE_BOTTOM_Y - p_hei;
						line(bit, P_C_X, P_Y - 6, P_C_X, P_Y + p_hei + 3, PAL[COL_NULL]);
						//
						int p_wid = (arr[P6] > 0)
						            ? DrawStringsWid(arr[P1], testbuf, arr[P6])
						            : Text->StringWidth(testbuf, arr[P1])+1;
						int xoff;
						int tf = (arr[M_FLAGS1] & MASK_ITEMNM_ALIGN)/1L;
						switch(tf) //start Calculate offsets based on alignment
						{
							case TF_NORMAL: break;
							case TF_CENTERED:
								xoff = -p_wid/2;
								break;
							case TF_RIGHT:
								xoff = -p_wid;
								break;
						} //end
						frame_rect(bit, P_C_X+xoff-1, P_Y-2, P_C_X+2+p_wid+xoff, P_Y+p_hei+1, 1);
						if(arr[P6])
							DrawStringsBitmap(bit, 0, P_C_X+1+(tf==TF_NORMAL?1:0), P_Y, arr[P1], arr[P2], bg, tf, testbuf, OP_OPAQUE, shd_t, shd, arr[P7], arr[P6]);
						else bit->DrawString(0, P_C_X+1+(tf==TF_NORMAL?1:0), P_Y, arr[P1], arr[P2], bg, tf, testbuf, OP_OPAQUE, shd_t, shd);
						break;
					} //end
					case MODULE_TYPE_DMTITLE: //start
					{
						char32 buf1[] = "Font:";
						text(bit, FRAME_X, FRAME_Y+12+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						arr[P1] = dropdown_proc(bit, FRAME_X+Text->StringWidth(buf1, DIA_FONT)+2, FRAME_Y+12, DDWN_WID_FONT, arr[P1], data, SSL_FONT, -1, 6, lastframe, 0);
						
						arr[P5] = dropdown_proc(bit, FRAME_X, FRAME_Y + 25, 80, arr[P5], data, SSL_SHADOWTYPE, -1, 11, lastframe, 0);
						
						DEFINE TEXT_OFFSET = WIDTH - FRAME_X - 20;
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*0), TF_RIGHT, "Text:", PAL[COL_TEXT_MAIN]);
						arr[P2] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*0), 16, 16, arr[P2], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*1), TF_RIGHT, "BG:", PAL[COL_TEXT_MAIN]);
						arr[P3] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*1), 16, 16, arr[P3], data);
						text(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12+5 + (18*2), TF_RIGHT, "Shadow:", PAL[COL_TEXT_MAIN]);
						arr[P4] = pal_swatch(bit, FRAME_X+TEXT_OFFSET, FRAME_Y+12 + (18*2), 16, 16, arr[P4], data);
						
						
						char32 buf2[] = "Align:";
						text(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12+2, TF_NORMAL, buf2, PAL[COL_TEXT_MAIN]);
						arr[M_FLAGS1] = (arr[M_FLAGS1] & ~MASK_DMTITLE_ALIGN)
						              | (1L * dropdown_proc(bit, FRAME_X+DDWN_WID_FONT+4+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+12, DDWN_WID_ALIGN, (arr[M_FLAGS1]&MASK_DMTITLE_ALIGN)/1L, data, SSL_ALIGNMENT, -1, 3, lastframe, 0));
						
						//
						int bg = arr[P3];
						int shd = arr[P4];
						int shd_t = arr[P5];
						unless(bg) bg = -1;
						unless(shd) shd_t = SHD_NORMAL;
						//
						
						char32 testbuf[22];
						getDMapTitle(testbuf);
						int tstindx;
						for(tstindx = 0; tstindx < 22; ++tstindx)
						{
							switch(testbuf[tstindx])
							{
								case 0: case ' ': case '\n':
									break;
								default:
									tstindx = 50;
							}
						}
						if(tstindx < 50)
						{
							strcpy(testbuf, "  Test    \n    Name  ");
						}
						DEFINE P_C_X = WIDTH/2;
						int p_hei = DrawStringsCount(arr[P1], testbuf, 256) * Text->FontHeight(arr[P1]);
						DEFINE P_Y = ABOVE_BOTTOM_Y - p_hei;
						line(bit, P_C_X, P_Y - 6, P_C_X, P_Y + p_hei + 3, PAL[COL_NULL]);
						//
						int p_wid = DrawStringsWid(arr[P1], testbuf, 256);
						int xoff;
						int tf = (arr[M_FLAGS1] & MASK_DMTITLE_ALIGN)/1L;
						switch(tf) //start Calculate offsets based on alignment
						{
							case TF_NORMAL: break;
							case TF_CENTERED:
								xoff = -p_wid/2;
								break;
							case TF_RIGHT:
								xoff = -p_wid;
								break;
						} //end
						frame_rect(bit, P_C_X+xoff-1, P_Y-2, P_C_X+2+p_wid+xoff, P_Y+p_hei+1, 1);
						DrawStringsBitmap(bit, 0, P_C_X+1+(tf==TF_NORMAL?1:0), P_Y, arr[P1], arr[P2], bg, tf, testbuf, OP_OPAQUE, shd_t, shd, 0, 256);
						break;
					} //end
					case MODULE_TYPE_FRAME: //start
					{
						char32 buftl[] = "Tile:";
						int tlarr[2] = {arr[P1], arr[P2]};
						text(bit, FRAME_X+3, FRAME_Y+21, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						tile_swatch(bit, FRAME_X+3+Text->StringWidth(buftl, DIA_FONT), FRAME_Y+15, tlarr, data, false);
						arr[P1] = tlarr[0];
						arr[P2] = tlarr[1];
						
						char32 buf1[] = "Wid:";
						titled_inc_text_field(bit, FRAME_X+27+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+19, 28, argbuf3, 2, false, data, OBJ_SPEC_TFINDX_START+1, 0, 2, 32, buf1);
						arr[P3] = VBound(atoi(argbuf3), 32, 2);
						char32 buf2[] = "Hei:";
						titled_inc_text_field(bit, FRAME_X+59+Text->StringWidth(buftl, DIA_FONT)+Text->StringWidth(buf1, DIA_FONT)+Text->StringWidth(buf2, DIA_FONT), FRAME_Y+19, 28, argbuf4, 2, false, data, OBJ_SPEC_TFINDX_START+2, 0, 2, 28, buf2);
						arr[P4] = VBound(atoi(argbuf4), 28, 2);
						
						DEFINE PREVWID = arr[P3] * 8;
						DEFINE PREVHEI = VBound(arr[P4] * 8, 8*18, 0);
						DEFINE PREVY = ABOVE_BOTTOM_Y-PREVHEI;
						frame_rect(bit, (WIDTH/2)-(PREVWID/2), PREVY-1, (WIDTH/2)+(PREVWID/2), PREVY+PREVHEI, 1);
						text(bit, WIDTH/2, PREVY-8, TF_CENTERED, "Preview (Shows max 32x18):", PAL[COL_TEXT_MAIN]);
						if(arr[P1])
						{
							bit->DrawFrame(0, (WIDTH/2)-(PREVWID/2)+1, PREVY, arr[P1], arr[P2], PREVWID/8, PREVHEI/8, true, OP_OPAQUE);
						}
						break;
					} //end
					case MODULE_TYPE_RECT: //start
					{
						DEFINE C1_X = FRAME_X + 3;
						DEFINE C2_X = C1_X + 48;
						DEFINE R1_Y = FRAME_Y + 21;
						DEFINE R2_Y = R1_Y + 18;
						DEFINE R3_Y = R2_Y + 10;
						char32 buftl[] = "Color:";
						text(bit, C1_X, R1_Y, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, C1_X+Text->StringWidth(buftl, DIA_FONT), R1_Y-4, 16, 16, arr[P1], data);
						
						char32 buf1[] = "X2:";
						titled_inc_text_field(bit, C1_X+Text->StringWidth(buf1, DIA_FONT), R2_Y, 28, argbuf2, 3, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 255, buf1);
						arr[P2] = VBound(atoi(argbuf2), 255, 0);
						
						char32 buf2[] = "Y2:";
						titled_inc_text_field(bit, C2_X+Text->StringWidth(buf2, DIA_FONT), R2_Y, 28, argbuf3, 3, false, data, OBJ_SPEC_TFINDX_START+2, 0, 0, 223, buf2);
						arr[P3] = VBound(atoi(argbuf3), 223, 0);
						
						switch(titled_checkbox(bit, C2_X, R1_Y, 7, arr[M_FLAGS1]&FLAG_RECT_FILL, data, 0, "Filled?"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_RECT_FILL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_RECT_FILL;
								break;
						}
						break;
					} //end
					case MODULE_TYPE_LINE: //start
					{
						DEFINE C1_X = FRAME_X + 3;
						DEFINE C2_X = C1_X + 48;
						DEFINE R1_Y = FRAME_Y + 21;
						DEFINE R2_Y = R1_Y + 18;
						DEFINE R3_Y = R2_Y + 10;
						char32 buftl[] = "Color:";
						text(bit, C1_X, R1_Y, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, C1_X+Text->StringWidth(buftl, DIA_FONT), R1_Y-4, 16, 16, arr[P1], data);
						
						char32 buf1[] = "X2:";
						titled_inc_text_field(bit, C1_X+Text->StringWidth(buf1, DIA_FONT), R2_Y, 28, argbuf2, 3, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 255, buf1);
						arr[P2] = VBound(atoi(argbuf2), 255, 0);
						
						char32 buf2[] = "Y2:";
						titled_inc_text_field(bit, C2_X+Text->StringWidth(buf2, DIA_FONT), R2_Y, 28, argbuf3, 3, false, data, OBJ_SPEC_TFINDX_START+2, 0, 0, 223, buf2);
						arr[P3] = VBound(atoi(argbuf3), 223, 0);
						break;
					} //end
					case MODULE_TYPE_CIRC: //start
					{
						DEFINE C1_X = FRAME_X + 3;
						DEFINE C2_X = C1_X + 48;
						DEFINE R1_Y = FRAME_Y + 21;
						DEFINE R2_Y = R1_Y + 18;
						DEFINE R3_Y = R2_Y + 10;
						char32 buftl[] = "Color:";
						text(bit, C1_X, R1_Y, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, C1_X+Text->StringWidth(buftl, DIA_FONT), R1_Y-4, 16, 16, arr[P1], data);
						
						char32 buf1[] = "Radius:";
						titled_inc_text_field(bit, C1_X+Text->StringWidth(buf1, DIA_FONT), R2_Y, 28, argbuf2, 3, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 255, buf1);
						arr[P2] = VBound(atoi(argbuf2), 255, 0);
						
						switch(titled_checkbox(bit, C2_X, R1_Y, 7, arr[M_FLAGS1]&FLAG_RECT_FILL, data, 0, "Filled?"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_RECT_FILL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_RECT_FILL;
								break;
						}
						break;
					} //end
					case MODULE_TYPE_TRI: //start
					{
						DEFINE C1_X = FRAME_X + 3;
						DEFINE C2_X = C1_X + 48;
						DEFINE R1_Y = FRAME_Y + 21;
						DEFINE R2_Y = R1_Y + 18;
						DEFINE R3_Y = R2_Y + 10;
						char32 buftl[] = "Color:";
						text(bit, C1_X, R1_Y, TF_NORMAL, buftl, PAL[COL_TEXT_MAIN]);
						arr[P1] = pal_swatch(bit, C1_X+Text->StringWidth(buftl, DIA_FONT), R1_Y-4, 16, 16, arr[P1], data);
						
						char32 buf1[] = "X2:";
						titled_inc_text_field(bit, C1_X+Text->StringWidth(buf1, DIA_FONT), R2_Y, 28, argbuf2, 3, false, data, OBJ_SPEC_TFINDX_START+1, 0, 0, 255, buf1);
						arr[P2] = VBound(atoi(argbuf2), 255, 0);
						
						char32 buf2[] = "Y2:";
						titled_inc_text_field(bit, C2_X+Text->StringWidth(buf2, DIA_FONT), R2_Y, 28, argbuf3, 3, false, data, OBJ_SPEC_TFINDX_START+2, 0, 0, 223, buf2);
						arr[P3] = VBound(atoi(argbuf3), 223, 0);
						
						char32 buf3[] = "X3:";
						titled_inc_text_field(bit, C1_X+Text->StringWidth(buf3, DIA_FONT), R3_Y, 28, argbuf4, 3, false, data, OBJ_SPEC_TFINDX_START+3, 0, 0, 255, buf3);
						arr[P4] = VBound(atoi(argbuf4), 255, 0);
						
						char32 buf4[] = "Y3:";
						titled_inc_text_field(bit, C2_X+Text->StringWidth(buf4, DIA_FONT), R3_Y, 28, argbuf5, 3, false, data, OBJ_SPEC_TFINDX_START+4, 0, 0, 223, buf4);
						arr[P5] = VBound(atoi(argbuf5), 223, 0);
						
						switch(titled_checkbox(bit, C2_X, R1_Y, 7, arr[M_FLAGS1]&FLAG_RECT_FILL, data, 0, "Filled?"))
						{
							case PROC_UPDATED_FALSE:
								arr[M_FLAGS1]~=FLAG_RECT_FILL;
								break;
							case PROC_UPDATED_TRUE:
								arr[M_FLAGS1]|=FLAG_RECT_FILL;
								break;
						}
						break;
					} //end
					default:
					{
						text(bit, WIDTH/2, ((HEIGHT-(Text->FontHeight(DIA_FONT)*((1*3)+(0.5*2))))/2), TF_CENTERED, "WIP UNDER CONSTRUCTION", PAL[COL_TEXT_MAIN], 1);
						break;
					}
				} //end
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			//start Closing
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			Game->LItems[curlvl] = LItem;
			if(do_save_changes) //start
			{
				arr[M_X] = VBound(atoi(buf_x), max_x(arr), min_x(arr));
				arr[M_Y] = VBound(atoi(buf_y), max_y(arr, active), min_y(arr));
				arr[M_LAYER] = VBound(atoi(buf_lyr), 7, 0);
				switch(arr[M_TYPE])
				{
					case MODULE_TYPE_SEL_ITEM_CLASS:
					case MODULE_TYPE_SEL_ITEM_ID:
					{
						//arr[P1] = VBound(atoi(argbuf1), MAX_ITEMDATA, MIN_ITEMDATA);
						arr[P2] = VBound(atoi(argbuf2), MAX_MODULES, -1);
						arr[P3] = VBound(atoi(argbuf3), MAX_MODULES, -1);
						arr[P4] = VBound(atoi(argbuf4), MAX_MODULES, -1);
						arr[P5] = VBound(atoi(argbuf5), MAX_MODULES, -1);
						arr[P6] = VBound(atoi(argbuf6), MAX_MODULES, -1);
						break;
					}
				}
				if(active)
				{
					mod_indx = VBound(atoi(buf_pos), g_arr[NUM_ACTIVE_MODULES]-1, 1);
					remove_active_module(old_indx);
					add_active_module(arr, mod_indx);
				}
				else
				{
					mod_indx = VBound(atoi(buf_pos), g_arr[NUM_PASSIVE_MODULES]-1, 1);
					remove_passive_module(old_indx);
					add_passive_module(arr, mod_indx);
				}
				if(mod_indx!=old_indx)
				{
					int f = mod_flags[old_indx];
					mod_flags[old_indx] = mod_flags[mod_indx];
					mod_flags[mod_indx] = f | MODFLAG_SELECTED;
					SubEditorData[SED_SELECTED] = mod_indx;
				}
			} //end
			
			bit->Free();
			gen_final();
			//end
		} //end
		void do_condsettings(untyped old_arr) //start
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 224
			     , HEIGHT = 112
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			bitmap lastframe = create(WIDTH, HEIGHT);
			lastframe->ClearToColor(0, PAL[COL_NULL]);
			//
			untyped new_arr[MODULE_BUF_SIZE];
			memcpy(new_arr, old_arr, MODULE_BUF_SIZE);
			//
			char32 title[128] = "Conditional Settings";
			char32 desc_str[512] = "If a conditional is set, the module will only display under certain conditions.\n"
			                       "Click the 'i' next to the 'Type' dropdown for more info on each type.";
			char32 none_desc[] = "No conditional is set. The module will always display.";
			char32 li_desc[] = "The module will display only when a level item from a certain level is owned.\n"
			                   "A level value of '-1' will read the current level.";
			char32 script_desc[] = "The module will only display when a scripted condition is met. Script not provided.\n"
			                       "The function 'setScriptConditional' can be used to set a given conditional.";
			char32 item_desc[] = "The module will only display when the Player has the chosen item.";
			char32 counter_desc[] = "The module will only display when the selected counter has a value"
			                        " >= the selected value.\n Selecting '0' will require that the counter be *full*.";
			char32 counter_und_desc[] = "The module will only display when the selected counter has a value"
			                            " <= the selected value.";
			char32 desc_strs[] = {none_desc, script_desc, li_desc, item_desc, counter_desc, counter_und_desc};
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			char32 argbuf1[16];
			char32 argbuf2[16];
			itoa(argbuf1, new_arr[M_CND1]);
			itoa(argbuf2, new_arr[M_CND2]);
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			untyped proc_data[6];
			
			while(running)
			{
				lastframe->Clear(0);
				fullblit(0, lastframe, bit);
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, desc_str)==PROC_CANCEL || CancelButtonP())
					running = false;
				//
				i_proc(bit, FRAME_X, FRAME_Y - 1, desc_strs[new_arr[M_CNDTYPE]], data);
				text(bit, FRAME_X+9, FRAME_Y, TF_NORMAL, "Type:", PAL[COL_TEXT_MAIN]);
				int oldtype = new_arr[M_CNDTYPE];
				new_arr[M_CNDTYPE] = dropdown_proc(bit, FRAME_X, FRAME_Y + Text->FontHeight(DIA_FONT) + 1, 128, new_arr[M_CNDTYPE], data, SSL_CONDTYPE, -1, 8, lastframe, 0);
				if(new_arr[M_CNDTYPE] != oldtype) //start Bound values
				{
					switch(oldtype) //start Load values from argbufs
					{
						case COND_LITEM:
						{
							new_arr[M_CND1] = VBound(atoi(argbuf1), 512, -1);
							break;
						}
						case COND_SCRIPT:
						{
							new_arr[M_CND1] = VBound(atoi(argbuf1), MAX_INT, 0);
							new_arr[M_CND2] = VBound(atoi(argbuf2), 31, 0);
							break;
						}
						case COND_ITEM:
						{
							new_arr[M_CND1] = VBound(atoi(argbuf1), MAX_ITEMDATA, MIN_ITEMDATA);
							break;
						}
						case COND_COUNTER: case COND_COUNTER_UNDER:
						{
							new_arr[M_CND1] = VBound(atoi(argbuf1), MAX_COUNTER_INDX, MIN_COUNTER_INDX);
							new_arr[M_CND2] = VBound(atoi(argbuf2), MAX_COUNTER, MIN_COUNTER);
							break;
						}
					} //end
					switch(new_arr[M_CNDTYPE]) //start Bound to new required bounds
					{
						case COND_LITEM:
						{
							new_arr[M_CND1] = VBound(new_arr[M_CND1], 512, -1);
							new_arr[M_CND2] = VBound(new_arr[M_CND2], MAX_LICND-1, 0);
							break;
						}
						case COND_SCRIPT:
						{
							new_arr[M_CND1] = VBound(new_arr[M_CND1], MAX_INT, 0);
							new_arr[M_CND2] = VBound(new_arr[M_CND2], 31, 0);
							break;
						}
						case COND_ITEM:
						{
							new_arr[M_CND1] = VBound(new_arr[M_CND1], MAX_ITEMDATA, MIN_ITEMDATA);
							break;
						}
						case COND_COUNTER: case COND_COUNTER_UNDER:
						{
							new_arr[M_CND1] = VBound(new_arr[M_CND1], MAX_COUNTER_INDX, MIN_COUNTER_INDX);
							new_arr[M_CND2] = VBound(new_arr[M_CND2], MAX_COUNTER, MIN_COUNTER);
							break;
						}
					} //end
					//start Reset argbufs
					remchr(argbuf1);
					itoa(argbuf1, new_arr[M_CND1]);
					//
					remchr(argbuf2);
					itoa(argbuf2, new_arr[M_CND2]);
					//end
				} //end
				DEFINE V1_Y = FRAME_Y + 19;
				DEFINE V2_Y = V1_Y + 10;
				switch(new_arr[M_CNDTYPE]) //start Procs
				{
					case COND_NONE:
					{
						char32 buf1[] = "V1:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 64, argbuf1, 6, false, data, 1, FLAG_DISABLE, buf1);
						char32 buf2[] = "V2:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 32, argbuf2, 3, false, data, 2, FLAG_DISABLE, buf2);
						break;
					}
					case COND_LITEM:
					{
						char32 buf1[] = "Level:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 32, argbuf1, 3, true, data, 1, 0, -1, 512, buf1);
						char32 buf2[] = "Type:";
						text(bit, FRAME_X, V2_Y+2, TF_NORMAL, buf2, PAL[COL_TEXT_MAIN]);
						new_arr[M_CND2] = dropdown_proc(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 64, new_arr[M_CND2], data, SSL_LICND, -1, 8, lastframe, 0);
						break;
					}
					case COND_SCRIPT:
					{
						char32 buf1[] = "Indx:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 64, argbuf1, 6, false, data, 1, 0, 0, MAX_INT, buf1);
						char32 buf2[] = "Bit:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 32, argbuf2, 3, false, data, 2, 0, 0, 31, buf2);
						break;
					}
					case COND_ITEM:
					{
						char32 buf1[] = "Item:";
						text(bit, FRAME_X, V1_Y+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						new_arr[M_CND1] = dropdown_proc(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 128, new_arr[M_CND1], data, SSL_ITEM, -1, 8, lastframe, 0);
						char32 buf2[] = "V2:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 32, argbuf2, 3, false, data, 2, FLAG_DISABLE, buf2);
						break;
					}
					case COND_COUNTER:
					{
						char32 buf1[] = "Counter:";
						text(bit, FRAME_X, V1_Y+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						new_arr[M_CND1] = dropdown_proc(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 96, new_arr[M_CND1], data, SSL_COUNTER, -1, 8, lastframe, 0);
						char32 buf2[] = "Min Value:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 32, argbuf2, 3, false, data, 2, 0, 0, 31, buf2);
						break;
					}
					case COND_COUNTER_UNDER:
					{
						char32 buf1[] = "Counter:";
						text(bit, FRAME_X, V1_Y+2, TF_NORMAL, buf1, PAL[COL_TEXT_MAIN]);
						new_arr[M_CND1] = dropdown_proc(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), V1_Y, 96, new_arr[M_CND1], data, SSL_COUNTER, -1, 8, lastframe, 0);
						char32 buf2[] = "Max Value:";
						titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf2, DIA_FONT), V2_Y, 32, argbuf2, 3, false, data, 2, 0, 0, 31, buf2);
						break;
					}
				} //end Bounds
				
				//
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*0), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 2, FLAG_DEFAULT))
				{
					running = false;
					do_save_changes = true;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*1), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 1))
				{
					running = false;
				}
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				switch(new_arr[M_CNDTYPE]) //start Load values from argbufs
				{
					case COND_LITEM:
					{
						new_arr[M_CND1] = VBound(atoi(argbuf1), 512, -1);
						break;
					}
					case COND_SCRIPT:
					{
						new_arr[M_CND1] = VBound(atoi(argbuf1), MAX_INT, 0);
						new_arr[M_CND2] = VBound(atoi(argbuf2), 32, 0);
						break;
					}
				} //end
				memcpy(old_arr, new_arr, MODULE_BUF_SIZE);
			}
			
			bit->Free();
			gen_final();
		} //end
		//end Edit Object
		//start Main GUI
		enum GuiState
		{
			GUI_BOTTOM, GUI_TOP, GUI_HIDDEN,
			GUISTATE_MAX
		};
		DEFINE MAIN_GUI_WIDTH = 256;
		DEFINE MAIN_GUI_HEIGHT = 40;
		bool isHoveringGUI()
		{
			int yoffs = -56;
			switch(SubEditorData[SED_GUISTATE])
			{
				case GUI_HIDDEN:
					return false;
				case GUI_TOP:
					break;
				case GUI_BOTTOM:
					yoffs = 168-MAIN_GUI_HEIGHT;
					break;
			}
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = MAIN_GUI_WIDTH;
			data[DLG_DATA_HEI] = MAIN_GUI_HEIGHT;
			data[DLG_DATA_YOFFS] = yoffs;
			return isHovering(data);
		}
		enum
		{
			GUIRET_NULL,
			GUIRET_EXIT
		};
		int runGUI(bool active)
		{
			if(SubEditorData[SED_ACTIVE_PANE]) return GUIRET_NULL; //No main GUI during dialogs.
			if(Input->ReadKey[KEY_TAB])
			{
				SubEditorData[SED_GUISTATE] = ((SubEditorData[SED_GUISTATE]+1)%GUISTATE_MAX);
			}
			int yoffs = -56;
			switch(SubEditorData[SED_GUISTATE])
			{
				case GUI_HIDDEN:
					yoffs = MAX_INT;
					break;
				case GUI_TOP:
					break;
				case GUI_BOTTOM:
					yoffs = 168-MAIN_GUI_HEIGHT;
					break;
			}
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = MAIN_GUI_WIDTH;
			data[DLG_DATA_HEI] = MAIN_GUI_HEIGHT;
			data[DLG_DATA_YOFFS] = yoffs;
			int ret = GUIRET_NULL;
			int szindx = active ? NUM_ACTIVE_MODULES : NUM_PASSIVE_MODULES;
			bitmap bit = getGUIBitmap();
			{
				//Deco
				frame_rect(bit, 0, 0, MAIN_GUI_WIDTH-1, MAIN_GUI_HEIGHT-1, 1);
				//Text
				text(bit, 2, 2, TF_NORMAL, "MENU: Move with 'TAB'", PAL[COL_TEXT_MAIN]);
				//Func
				//start BUTTONS
				DEFINE FIRSTROW_HEIGHT = Text->FontHeight(DIA_FONT)+3;
				DEFINE BUTTON_HEIGHT = Text->FontHeight(DIA_FONT)+8;
				DEFINE BUTTON_WIDTH = 62;//58;
				DEFINE BUTTON_HSPACE = 0;//5;
				DEFINE BUTTON_VSPACE = 0;
				DEFINE LEFT_MARGIN = 4;
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "%New Obj", data, main_proc_data, 0))
				{
					open_data_pane(DLG_NEWOBJ, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*1), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "%Edit", data, main_proc_data, 1, SubEditorData[SED_SELECTED] ? FLAG_DEFAULT : FLAG_DISABLE))
				{
					open_data_pane(SubEditorData[SED_SELECTED], active);
				}
				bool can_clone;
				for(int q = 2; q < g_arr[szindx]; ++q)
				{
					if(mod_flags[q] & MODFLAG_SELECTED)
					{
						can_clone = true;
						break;
					}
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*2), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "%Clone", data, main_proc_data, 2, can_clone ? 0 : FLAG_DISABLE))
				{
					unless(SubEditorData[SED_JUST_CLONED]) //Don't clone every frame it's held, just the first frame pressed!
					{
						int old_cnt = g_arr[szindx];
						for(int q = 0; q < old_cnt; ++q)
						{
							unless(mod_flags[q] & MODFLAG_SELECTED) continue;
							if(q > 1) //Can't clone settings / bgcolor
							{
								cloneModule(q, active);
								if(SubEditorData[SED_SELECTED] == q) //Select clone of previously selected
									SubEditorData[SED_SELECTED] = g_arr[szindx]-1;
							}
							mod_flags[q] ~= MODFLAG_SELECTED;
						}
						for(int q = old_cnt; q < g_arr[szindx]; ++q)
							mod_flags[q] |= MODFLAG_SELECTED;
						/*
						cloneModule(SubEditorData[SED_SELECTED], active);
						SubEditorData[SED_SELECTED] = active ? g_arr[NUM_ACTIVE_MODULES]-1 : g_arr[NUM_PASSIVE_MODULES]-1;
						*/
						SubEditorData[SED_JUST_CLONED] = true;
					}
				}
				else SubEditorData[SED_JUST_CLONED] = false;
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*3), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "%Options", data, main_proc_data, 3))
				{
					open_data_pane(DLG_OPTIONS, PANE_T_SYSTEM);
				}
				Game->ClickToFreezeEnabled = SubEditorData[SED_ZCM_BTN];
				if(SubEditorData[SED_ZCM_BTN] && (Input->KeyRaw[KEY_ESC] || Input->Mouse[MOUSE_LEFT]))
				{
					SubEditorData[SED_LCLICKED] = false;
					pollKeys(); pollKeys(); //Poll twice to destroy any `Press` states
				}
				bool zcm_btn = DLGCursorBox(LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0)+BUTTON_WIDTH-1,FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE)+BUTTON_HEIGHT-1, data); 
				if(zcm_btn)
					SubEditorData[SED_ZCM_BTN] = 2;
				else if(SubEditorData[SED_ZCM_BTN])
					--SubEditorData[SED_ZCM_BTN];
				if(insta_button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "ZC Menu", data, 0))
				{}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*2), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "S%ystem", data, main_proc_data, 6))
				{
					open_data_pane(DLG_SYSTEM, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*1), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "%Themes", data, main_proc_data, 7))
				{
					open_data_pane(DLG_THEMES, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*3), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Exit", data, main_proc_data, 8))
				{
					Game->ClickToFreezeEnabled = false;
					ret = GUIRET_EXIT;
				}
				//end BUTTONS
			}
			draw_dlg(bit, data);
			if(isHovering(data)) clearPreparedSelector();
			return ret;
		} //end main GUI
		//start Themes
		void editThemes()
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 256
			     , HEIGHT = 224
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "Theme Editor";
			Color NEWPAL[PAL_SIZE];
			Color BCKUPPAL[PAL_SIZE];
			memcpy(NEWPAL, PAL, PAL_SIZE);
			memcpy(BCKUPPAL, PAL, PAL_SIZE);
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			int preview = 0;
			untyped proc_data[6];
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, "The Theme Editor allows you to customize the colors used by the editor windows. Use the presets to the left, or modify the color swatches individually to the right.")==PROC_CANCEL || CancelButtonP())
					running = false;
				
				switch(desc_titled_checkbox(bit, FRAME_X, FRAME_Y, 7, preview&1b, data, 0, "Preview", "If enabled, the palette will be live-updated. Else, changes will not take effect until you click 'Accept'."))
				{
					case PROC_UPDATED_FALSE:
						preview=10b;
						break;
					case PROC_UPDATED_TRUE:
						preview=11b;
						break;
				}
				//Palette Editing
				{
					DEFINE NUM_ROWS = 8, NUM_COLUMNS = Ceiling(COL_MAX/NUM_ROWS),
						   WID_COL = 64, HEI_ROW = 26;
					
					DEFINE START_Y = FRAME_Y+5, START_X = WIDTH-32-MARGIN_WIDTH-(WID_COL*(NUM_COLUMNS-1));
					int pal_node_x = START_X;
					for(int col = 0; col < NUM_COLUMNS; ++col)
					{
						int pal_node_y=START_Y;
						for(int row = 0; row < NUM_ROWS; ++row)
						{
							DEFINE COL_INDX = ((col*NUM_ROWS)+row);
							if(COL_INDX >= COL_MAX) break;
							char32 palbuf[32];
							if(getPalName(palbuf, COL_INDX))
							{
								NEWPAL[COL_INDX] = pal_swatch(bit, pal_node_x, pal_node_y, 16, 16, NEWPAL[COL_INDX], data);
							}
							else
							{
								frame_rect(bit, pal_node_x, pal_node_y, pal_node_x+15, pal_node_y+15, 1);
							}
							text(bit, pal_node_x-1, pal_node_y+5, TF_RIGHT, palbuf, PAL[COL_TEXT_MAIN]);
							pal_node_y+=HEI_ROW;
						}
						pal_node_x += WID_COL;
					}
				}
				
				//Buttons
				{
					DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
					//Themes
					{
						DEFINE BUTTON_SPACING = 6, BUTTON_START_Y = 12, LABEL_HEIGHT = Text->FontHeight(DIA_FONT)+2;
						DEFINE NUM_PRESET_THEMES = 4;
						DEFINE BOXOFFSET = MARGIN_WIDTH+2;
						int bx = FRAME_X+BOXOFFSET, by = FRAME_Y+BUTTON_START_Y;
						frame_rect(bit, bx-BOXOFFSET, by-BOXOFFSET, bx+BUTTON_WIDTH+BOXOFFSET-1, by-BOXOFFSET + ((BUTTON_HEIGHT+BOXOFFSET+BOXOFFSET	)*NUM_PRESET_THEMES) + LABEL_HEIGHT, 1);
						i_proc(bit, bx, by, "Activating a theme will copy it's colors over the current theme.\n\n\"Basic\" themes use ZC System Colors, so they should work in any tileset.\n\n\"Classic\" themes are designed for Classic, and might not work elsewhere.", data);
						text(bit, bx+(BUTTON_WIDTH/2), by, TF_CENTERED, "Themes:", PAL[COL_TEXT_MAIN]);
						by += LABEL_HEIGHT;
						if(PROC_CONFIRM==button(bit, bx, by, BUTTON_WIDTH, BUTTON_HEIGHT, "Basic", data, proc_data, 0))
						{
							loadBasicPal(NEWPAL);
						}
						by += BUTTON_HEIGHT+BUTTON_SPACING;
						if(PROC_CONFIRM==button(bit, bx, by, BUTTON_WIDTH, BUTTON_HEIGHT, "B. Dark", data, proc_data, 1))
						{
							loadBasicDarkPal(NEWPAL);
						}
						by += BUTTON_HEIGHT+BUTTON_SPACING;
						if(PROC_CONFIRM==button(bit, bx, by, BUTTON_WIDTH, BUTTON_HEIGHT, "Classic", data, proc_data, 2))
						{
							loadClassicPal(NEWPAL);
						}
						by += BUTTON_HEIGHT+BUTTON_SPACING;
						if(PROC_CONFIRM==button(bit, bx, by, BUTTON_WIDTH, BUTTON_HEIGHT, "C. Dark", data, proc_data, 3))
						{
							loadClassicDarkPal(NEWPAL);
						}
						//by += BUTTON_HEIGHT+BUTTON_SPACING;
					}
					
					//Confirm / Reset
					{
						if(PROC_CONFIRM==button(bit, FRAME_X+BUTTON_WIDTH+3, HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Reset", data, proc_data, 4))
						{
							memcpy(NEWPAL, BCKUPPAL, PAL_SIZE);
						}
						if(PROC_CONFIRM==button(bit, FRAME_X, HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 5, FLAG_DEFAULT))
						{
							running = false;
							do_save_changes = true;
						}
					}
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
				if(preview&1b)
				{
					memcpy(PAL, NEWPAL, PAL_SIZE);
				}
				else if(preview==10b)
				{
					memcpy(PAL, BCKUPPAL, PAL_SIZE);
					preview=0;
				}
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				memcpy(PAL, NEWPAL, PAL_SIZE);
			}
			else
			{
				memcpy(PAL, BCKUPPAL, PAL_SIZE);
			}
			
			bit->Free();
			gen_final();
		}
		//end
		//start System
		void sys_dlg() //start
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 256
			     , HEIGHT = 224
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "System Settings";
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			untyped old_sys_settings[SSET_MAX];
			memcpy(old_sys_settings, sys_settings, SSET_MAX);
			//end
			untyped proc_data[10];
			long flagbits[2], usebits[2];
			flagbits[0] = sys_settings[SSET_FLAGS1];
			flagbits[1] = sys_settings[SSET_FLAGS2];
			usebits[0] = 1bL;
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data)==PROC_CANCEL || CancelButtonP())
					running = false;
				
				flag_tab(bit, FRAME_X, FRAME_Y, 144, 8, flagbits, usebits,
					{"Recieve Deletion Warnings"},
					{"If checked, a confirmation prompt will appear when attempting to delete objects."},
					data, proc_data, 4);
				
				//Buttons
				{
					DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
					//Confirm / Reset
					{
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*0), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 1, FLAG_DEFAULT))
						{
							running = false;
							do_save_changes = true;
						}
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*1), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 2))
						{
							running = false;
						}
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*2), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cursor", data, proc_data, 3))
						{
							edit_syscursor_dlg();
						}
					}
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				sys_settings[SSET_FLAGS1] = flagbits[0];
				sys_settings[SSET_FLAGS2] = flagbits[1];
			}
			else
			{
				memcpy(sys_settings, old_sys_settings, SSET_MAX);
			}
			
			bit->Free();
			gen_final();
		} //end
		void edit_syscursor_dlg() //start
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 128
			     , HEIGHT = 80
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			bitmap lastframe = create(WIDTH, HEIGHT);
			lastframe->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "System: Cursor Settings";
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			untyped new_sys_settings[SSET_MAX];
			memcpy(new_sys_settings, sys_settings, SSET_MAX);
			//end
			untyped proc_data[6];
			DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
			DEFINE ABOVE_BOTTOM_Y = HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT-4;
			while(running)
			{
				lastframe->Clear(0);
				fullblit(0, lastframe, bit);
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data)==PROC_CANCEL || CancelButtonP())
					running = false;
				
				int tlarr[2] = {new_sys_settings[SSET_CURSORTILE], new_sys_settings[SSET_CURSORCSET]};
				tile_swatch(bit, FRAME_X, FRAME_Y, tlarr, data, false);
				new_sys_settings[SSET_CURSORTILE] = tlarr[0];
				new_sys_settings[SSET_CURSORCSET] = tlarr[1];
				
				new_sys_settings[SSET_CURSOR_VER] = dropdown_proc(bit, FRAME_X + 18, FRAME_Y, 64, new_sys_settings[SSET_CURSOR_VER], data, {"Basic", "Stick"}, -1, 10, lastframe, 0);
				
				frame_rect(bit, (WIDTH/2)-8, ABOVE_BOTTOM_Y-17, (WIDTH/2)+9, ABOVE_BOTTOM_Y, 1);
				if(new_sys_settings[SSET_CURSORTILE] > 0)
				{
					bit->FastTile(7, (WIDTH/2)-7, ABOVE_BOTTOM_Y-16, new_sys_settings[SSET_CURSORTILE], new_sys_settings[SSET_CURSORCSET], OP_OPAQUE);
				}
				else
				{
					DrawCursor(bit, (WIDTH/2)-7, ABOVE_BOTTOM_Y-16, new_sys_settings[SSET_CURSOR_VER]);
				}
				
				//Buttons
				{
					//Confirm / Reset
					{
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*0), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 1, FLAG_DEFAULT))
						{
							running = false;
							do_save_changes = true;
						}
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*1), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 2))
						{
							running = false;
						}
					}
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				memcpy(sys_settings, new_sys_settings, SSET_MAX);
			}
			
			bit->Free();
			gen_final();
		} //end
		//end
		//start Options
		void opt_dlg(bool active) //start
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 256
			     , HEIGHT = 224
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			//
			untyped settings_arr[SZ_SETTINGS];
			saveModule(settings_arr, 0, active);
			//
			char32 title[128];
			strcpy(title, active ? "Active Subscreen Settings" : "Passive Subscreen Settings");
			char32 desc_str[128];
			strcpy(desc_str, active ? "" : "");
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			DEFINE MISCFIELD_WID = 28;
			DEFINE MISCFIELD_NUMCHARS = 5;
			DEFINE MISCFIELD_SPACE = 2;
			char32 b1[MISCFIELD_NUMCHARS+1];
			char32 b2[MISCFIELD_NUMCHARS+1];
			char32 b3[MISCFIELD_NUMCHARS+1];
			char32 b4[MISCFIELD_NUMCHARS+1];
			char32 b5[MISCFIELD_NUMCHARS+1];
			char32 b6[MISCFIELD_NUMCHARS+1];
			char32 b7[MISCFIELD_NUMCHARS+1];
			char32 b8[MISCFIELD_NUMCHARS+1];
			char32 b9[MISCFIELD_NUMCHARS+1];
			char32 b10[MISCFIELD_NUMCHARS+1];
			//
			if(active)
			{
				itoa(b1, settings_arr[A_STTNG_FRAME_HOLD_DELAY]);
			}
			else
			{
			
			}
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			untyped proc_data[10];
			long flagbits[4];
			long usebits[4];
			for(int q = 0; q < 4; ++q)
			{
				flagbits[q] = settings_arr[STTNG_FLAGS1+q];
			}
			if(active)
			{
				usebits[0] = 1bL;
			}
			else
			{
				
			}
			
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, desc_str)==PROC_CANCEL || CancelButtonP())
					running = false;
				
				flag_tab(bit, FRAME_X, FRAME_Y, 112, 16, flagbits, usebits, active
					? {"Items Use Hitbox Size"}
					: {"---"}, active
					? {"The highlight around items, both in the editor and when selecting them in-game, are based on 'Hit' size if this is on, or 'Draw' size otherwise."}
					: NULL,	data, proc_data, 4);
				
				//Buttons
				{
					DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
					//Confirm / Reset
					{
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*0), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 2, FLAG_DEFAULT))
						{
							running = false;
							do_save_changes = true;
						}
						if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*1), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 1))
						{
							running = false;
						}
						if(active)
						{
							if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*2), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Btn Config", data, proc_data, 3))
							{
								do_btnsettings(settings_arr);
							}
						}
					}
				}
				
				int tfx = WIDTH-FRAME_X-MISCFIELD_WID, tfy = FRAME_Y;
				if(active)
				{
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b1, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 1, 0, "Input Repeat Rate:");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b2, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 2, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b3, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 3, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b4, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 4, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b5, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 5, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b6, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 6, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b7, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 7, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b8, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 8, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b9, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 9, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b10, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 10, FLAG_DISABLE, "--");
				}
				else
				{
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b1, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 1, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b2, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 2, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b3, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 3, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b4, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 4, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b5, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 5, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b6, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 6, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b7, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 7, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b8, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 8, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b9, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 9, FLAG_DISABLE, "--");
					tfy+=Text->FontHeight(DIA_FONT)+2+2+MISCFIELD_SPACE;
					titled_text_field(bit, tfx, tfy, MISCFIELD_WID, b10, MISCFIELD_NUMCHARS, TypeAString::TMODE_NUMERIC_POSITIVE, data, 10, FLAG_DISABLE, "--");
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				for(int q = 0; q < 4; ++q)
				{
					settings_arr[STTNG_FLAGS1+q] = flagbits[q];
				}
				if(active)
				{
					settings_arr[A_STTNG_FRAME_HOLD_DELAY] = VBound(atoi(b1), MAX_INT, 0);
					load_active_settings(settings_arr);
				}
				else
				{
					load_passive_settings(settings_arr);
				}
			}
			else
			{
			}
			
			bit->Free();
			gen_final();
		} //end
		
		void do_btnsettings(untyped old_settings_arr) //start (Active settings only)
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 112
			     , HEIGHT = 112
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			//
			untyped settings_arr[SZ_SETTINGS];
			memcpy(settings_arr, old_settings_arr, SZ_SETTINGS);
			//
			char32 title[128] = "Button Settings";
			char32 desc_str[512] = "If a button is 'enabled', it can have an item assigned which will be used when pressed.\n"
			                       "If a button is 'assignable', any item can be placed on the button in the active subscreen.\n"
								   "If the 'A' button is enabled, but not assignable, it will automatically assign to the current Sword.\n"
								   "If any other button is enabled, but not assignable, it can only be assigned to via a different script.";
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			untyped proc_data[6];
			DEFINE FLAGS_HEIGHT = 7;
			DEFINE ENABLED_X = (WIDTH/2) - (FLAGS_HEIGHT+1);
			DEFINE ASSIGNABLE_X = (WIDTH/2);
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, desc_str)==PROC_CANCEL || CancelButtonP())
					running = false;
				//
				text(bit, WIDTH/2, FRAME_Y, TF_CENTERED, "   Enabled | Assignable", PAL[COL_TEXT_MAIN]);
				//start Enabled
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*0), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_A), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_A);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_A);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*1), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_B), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_B);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_B);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*2), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_L), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_L);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_L);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*3), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_R), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_R);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_R);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*4), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_EX1), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_EX1);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_EX1);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*5), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_EX2), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_EX2);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_EX2);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*6), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_EX3), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_EX3);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_EX3);
						break;
				}
				switch(checkbox(bit, ENABLED_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*7), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] & (FLAG1<<CB_EX4), data, 0))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] &= ~(FLAG1<<CB_EX4);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ENABLED_BITS] |= (FLAG1<<CB_EX4);
						break;
				}
				//end Enabled
				//start Assignable
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*0), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_A), data, 0, "A"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_A);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_A);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*1), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_B), data, 0, "B"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_B);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_B);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*2), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_L), data, 0, "L"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_L);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_L);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*3), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_R), data, 0, "R"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_R);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_R);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*4), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_EX1), data, 0, "EX1"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_EX1);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_EX1);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*5), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_EX2), data, 0, "EX2"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_EX2);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_EX2);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*6), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_EX3), data, 0, "EX3"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_EX3);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_EX3);
						break;
				}
				switch(titled_checkbox(bit, ASSIGNABLE_X, FRAME_Y+2+Text->FontHeight(DIA_FONT)+((FLAGS_HEIGHT+2)*7), FLAGS_HEIGHT, settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] & (FLAG1<<CB_EX4), data, 0, "EX4"))
				{
					case PROC_UPDATED_FALSE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] &= ~(FLAG1<<CB_EX4);
						break;
					case PROC_UPDATED_TRUE:
						settings_arr[A_STTNG_BUTTON_ITEM_ASSIGNABLE_BITS] |= (FLAG1<<CB_EX4);
						break;
				}
				//end Assignable
				//
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*0), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Accept", data, proc_data, 2, FLAG_DEFAULT))
				{
					running = false;
					do_save_changes = true;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X+((BUTTON_WIDTH+3)*1), HEIGHT-MARGIN_WIDTH-2-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 1))
				{
					running = false;
				}
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			if(do_save_changes)
			{
				memcpy(old_settings_arr, settings_arr, SZ_SETTINGS);
			}
			
			bit->Free();
			gen_final();
		} //end
		//end
		//start New Object
		void new_obj(bool active)
		{
			gen_startup();
			
			//start setup
			DEFINE MARGIN_WIDTH = 1
			     , WIDTH = 162
				 , TXTWID = WIDTH - ((MARGIN_WIDTH+1)*2)
				 , BAR_HEIGHT = 11
			     , HEIGHT = BAR_HEIGHT+4+(Text->FontHeight(DIA_FONT)*2) + 14
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+(Text->FontHeight(DIA_FONT)/2)
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			bitmap lastframe = create(WIDTH, HEIGHT);
			lastframe->ClearToColor(0, PAL[COL_NULL]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			//end
			untyped proc_data[1];
			int indx;
			//start val/string setup
			int aval[] = {MODULE_TYPE_SEL_ITEM_ID, MODULE_TYPE_SEL_ITEM_CLASS, MODULE_TYPE_ITEMNAME,
				MODULE_TYPE_NONSEL_ITEM_ID, MODULE_TYPE_NONSEL_ITEM_CLASS, MODULE_TYPE_BUTTONITEM,
				MODULE_TYPE_PASSIVESUBSCREEN, MODULE_TYPE_MINIMAP, MODULE_TYPE_BIGMAP,
				MODULE_TYPE_TILEBLOCK, MODULE_TYPE_HEART, MODULE_TYPE_HEARTROW,
				MODULE_TYPE_MAGIC, MODULE_TYPE_MAGICROW, MODULE_TYPE_CRPIECE,
				MODULE_TYPE_CRROW,MODULE_TYPE_COUNTER, MODULE_TYPE_MINITILE,
				MODULE_TYPE_CLOCK, MODULE_TYPE_DMTITLE, MODULE_TYPE_FRAME,
				MODULE_TYPE_RECT, MODULE_TYPE_CIRC, MODULE_TYPE_LINE,
				MODULE_TYPE_TRI};
			char32 astrs[] = {"Sel. Item (ID)", "Sel. Item (Type)", "Item Name",
				"Item (ID)", "Item (Type)", "Button Item",
				"Passive Subscreen", "MiniMap", "Big Map",
				"Tile Block", "Heart", "Heart Row",
				"Magic", "Magic Row", "Counter Meter (Piece)",
				"Counter Meter (Row)", "Counter", "Minitile",
				"Clock", "DMap Title", "Frame",
				"Rectangle", "Circle", "Line",
				"Triangle"};
			int pval[] = {MODULE_TYPE_NONSEL_ITEM_ID, MODULE_TYPE_NONSEL_ITEM_CLASS, MODULE_TYPE_BUTTONITEM,
				MODULE_TYPE_MINIMAP, MODULE_TYPE_TILEBLOCK, MODULE_TYPE_HEART,
				MODULE_TYPE_HEARTROW, MODULE_TYPE_MAGIC, MODULE_TYPE_MAGICROW,
				MODULE_TYPE_CRPIECE, MODULE_TYPE_CRROW, MODULE_TYPE_COUNTER,
				MODULE_TYPE_MINITILE, MODULE_TYPE_CLOCK, MODULE_TYPE_DMTITLE,
				MODULE_TYPE_FRAME, MODULE_TYPE_RECT, MODULE_TYPE_CIRC,
				MODULE_TYPE_LINE, MODULE_TYPE_TRI};
			char32 pstrs[] = {"Item (ID)", "Item (Type)", "Button Item",
				"MiniMap", "Tile Block", "Heart",
				"Heart Row", "Magic", "Magic Row",
				"Counter Meter (Piece)", "Counter Meter (Row)", "Counter",
				"Minitile", "Clock", "DMap Title",
				"Frame", "Rectangle", "Circle",
				"Line", "Triangle"};
			//end
			int val = active ? aval : pval;
			char32 strs = active ? astrs : pstrs;
			while(running)
			{
				lastframe->Clear(0);
				fullblit(0, lastframe, bit);
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, "Create Object", data, "Create a new object of a given type, at it's default settings.\nAfter creating the object, it's editing window will open.")==PROC_CANCEL || CancelButtonP())
					running = false;
				
				indx = dropdown_proc(bit, FRAME_X, FRAME_Y, WIDTH - (FRAME_X*2), indx, data, strs, -1/*Auto*/, 10, lastframe, 0);
				
				DEFINE BUTTON_WIDTH = 32, BUTTON_HEIGHT = 10;
				if(PROC_CONFIRM==button(bit, (WIDTH/2)-(BUTTON_WIDTH/2), HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, "Create", data, proc_data, 0, FLAG_DEFAULT))
				{
					untyped module_arr[MODULE_BUF_SIZE];
					switch(val[indx])
					{
						case MODULE_TYPE_SEL_ITEM_ID:
						{
							MakeSelectableItemID(module_arr); break;
						}
						case MODULE_TYPE_SEL_ITEM_CLASS:
						{
							MakeSelectableItemClass(module_arr); break;
						}
						case MODULE_TYPE_BUTTONITEM:
						{
							MakeButtonItem(module_arr); break;
						}
						case MODULE_TYPE_MINIMAP:
						{
							MakeMinimap(module_arr); break;
						}
						case MODULE_TYPE_BIGMAP:
						{
							MakeBigMap(module_arr); break;
						}
						case MODULE_TYPE_TILEBLOCK:
						{
							MakeTileBlock(module_arr); break;
						}
						case MODULE_TYPE_HEART:
						{
							MakeHeart(module_arr); break;
						}
						case MODULE_TYPE_HEARTROW:
						{
							MakeHeartRow(module_arr); break;
						}
						case MODULE_TYPE_COUNTER:
						{
							MakeCounter(module_arr); break;
						}
						case MODULE_TYPE_MINITILE:
						{
							MakeMinitile(module_arr); break;
						}
						case MODULE_TYPE_NONSEL_ITEM_ID:
						{
							MakeNonSelectableItemID(module_arr); break;
						}
						case MODULE_TYPE_NONSEL_ITEM_CLASS:
						{
							MakeNonSelectableItemClass(module_arr); break;
						}
						case MODULE_TYPE_CLOCK:
						{
							MakeClock(module_arr); break;
						}
						case MODULE_TYPE_ITEMNAME:
						{
							MakeItemName(module_arr); break;
						}
						case MODULE_TYPE_DMTITLE:
						{
							MakeDMTitle(module_arr); break;
						}
						case MODULE_TYPE_MAGIC:
						{
							MakeMagic(module_arr); break;
						}
						case MODULE_TYPE_MAGICROW:
						{
							MakeMagicRow(module_arr); break;
						}
						case MODULE_TYPE_CRPIECE:
						{
							MakeCRPiece(module_arr); break;
						}
						case MODULE_TYPE_CRROW:
						{
							MakeCRRow(module_arr); break;
						}
						case MODULE_TYPE_FRAME:
						{
							MakeFrame(module_arr); break;
						}
						case MODULE_TYPE_RECT:
						{
							MakeRectangle(module_arr); break;
						}
						case MODULE_TYPE_CIRC:
						{
							MakeCircle(module_arr); break;
						}
						case MODULE_TYPE_LINE:
						{
							MakeLine(module_arr); break;
						}
						case MODULE_TYPE_TRI:
						{
							MakeTriangle(module_arr); break;
						}
						default:
						case MODULE_TYPE_PASSIVESUBSCREEN:
						{
							MakePassiveSubscreen(module_arr); break;
						}
					}
					if(active ? add_active_module(module_arr) : add_passive_module(module_arr))
					{
						int indx = (active ? g_arr[NUM_ACTIVE_MODULES] : g_arr[NUM_PASSIVE_MODULES])-1;
						open_data_pane(indx, active); //Go directly into the editObj dialogue from here!
						SubEditorData[SED_SELECTED] = indx; //And highlight it, too!
						
						for(int q = active ? g_arr[NUM_ACTIVE_MODULES]-1 : g_arr[NUM_PASSIVE_MODULES]-1; q >= 0; --q)
						{
							mod_flags[q] ~= MODFLAG_SELECTED;
						}
						mod_flags[indx] |= MODFLAG_SELECTED;
						SubEditorData[SED_TRY_SELECT] = 0;
					}
					running = false;
				}
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			lastframe->Free();
			gen_final();	
		}
		//end
		//start Main Menu
		void MainMenu() //start
		{
			Game->Cheat = 4;
			gen_startup();
			//start setup
			DEFINE WIDTH = 256
			     , HEIGHT = 224
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 , ACOL_X = FRAME_X
				 , PCOL_X = FRAME_X + (WIDTH/2 - (FRAME_X*2)) + 4
				 , COL_WID = (WIDTH/2 - (FRAME_X*2))
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			bitmap lastframe = create(WIDTH, HEIGHT);
			lastframe->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "Main Menu";
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			//end
			untyped proc_data[100];
			int active_indx, passive_indx;
			int num_active_sub = count_subs(false), num_passive_sub = count_subs(true);
			printf("Counts: %03d,%03d\n",num_active_sub,num_passive_sub);
			unless(num_active_sub)
			{
				resetActive();
				save_active_file(1);
				++num_active_sub;
			}
			unless(num_passive_sub)
			{
				resetPassive();
				save_passive_file(1);
				++num_passive_sub;
			}
			Input->DisableKey[KEY_ESC] = true;
			disableKeys(true);
			while(true)
			{
				dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
				dm->ASubScript = 0;
				dm->PSubScript = 0;
				lastframe->Clear(0);
				fullblit(0, lastframe, bit);
				bit->ClearToColor(0, PAL[COL_NULL]);
				
				handle_data_pane(true);
				
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, "", false);
				
				//Text
				{
					text(bit, ACOL_X + COL_WID/2, FRAME_Y, TF_CENTERED, "Active Subscreen", PAL[COL_TEXT_MAIN]);
					text(bit, PCOL_X + COL_WID/2, FRAME_Y, TF_CENTERED, "Passive Subscreen", PAL[COL_TEXT_MAIN]);
				}
				//Dropdowns
				{
					active_indx = dropdown_proc(bit, ACOL_X, FRAME_Y+8, COL_WID, active_indx, data, NULL, num_active_sub, 10, lastframe, 0);
					passive_indx = dropdown_proc(bit, PCOL_X, FRAME_Y+8, COL_WID, passive_indx, data, NULL, num_passive_sub, 10, lastframe, 0);
				}
				//Buttons
				{
					DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
					DEFINE BUTTON_XOFF = (COL_WID/2) - (BUTTON_WIDTH/2);
					DEFINE BUTTON_SPACING = 4;
					//SaveLoad
					{
						//UNFINISHED Save (open save dlg; same as MainGUI save)
						//UNFINISHED Load (open load dlg; same as MainGUI load)
					}
					//Choose Buttons
					{
						if(PROC_CONFIRM==button(bit, ACOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 1), BUTTON_WIDTH, BUTTON_HEIGHT, "New", data, proc_data, 2)) //start
						{
							resetActive();
							active_indx = num_active_sub;
							save_active_file(++num_active_sub);
						} //end
						if(PROC_CONFIRM==button(bit, PCOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 1), BUTTON_WIDTH, BUTTON_HEIGHT, "New", data, proc_data, 3)) //start
						{
							resetPassive();
							passive_indx = num_passive_sub;
							save_passive_file(++num_passive_sub);
						} //end
						if(PROC_CONFIRM==button(bit, ACOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 2), BUTTON_WIDTH, BUTTON_HEIGHT, "Dupe", data, proc_data, 4)) //start
						{
							load_active_file(active_indx+1);
							active_indx = num_active_sub;
							save_active_file(++num_active_sub);
						} //end
						if(PROC_CONFIRM==button(bit, PCOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 2), BUTTON_WIDTH, BUTTON_HEIGHT, "Dupe", data, proc_data, 5)) //start
						{
							load_passive_file(passive_indx+1);
							passive_indx = num_passive_sub;
							save_passive_file(++num_passive_sub);
						} //end
						if(PROC_CONFIRM==button(bit, ACOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 3), BUTTON_WIDTH, BUTTON_HEIGHT, "Delete", data, proc_data, 6)) //start
						{
							if(delwarn())
							{
								if(delete_active_file(active_indx+1))
								{
									char32 buf[] = "Active Subscreen #%i deleted successfully";
									sprintf(buf, buf, active_indx+1);
									active_indx = 0;
									unless(--num_active_sub)
									{
										resetActive();
										save_active_file(1);
										++num_active_sub;
									}
									else load_active_file(1);
									msg_dlg("Alert", buf);
								}
								else
								{
									char32 buf[] = "Active Subscreen #%i could not be deleted\nMenu data will be refreshed";
									sprintf(buf, buf, active_indx+1);
									err_dlg(buf);
									return; //Reset menu
								}
							}
						} //end
						if(PROC_CONFIRM==button(bit, PCOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 3), BUTTON_WIDTH, BUTTON_HEIGHT, "Delete", data, proc_data, 7)) //start
						{
							if(delwarn())
							{
								if(delete_passive_file(passive_indx+1))
								{
									char32 buf[] = "Passive Subscreen #%i deleted successfully";
									sprintf(buf, buf, passive_indx+1);
									passive_indx = 0;
									unless(--num_passive_sub)
									{
										resetPassive();
										save_passive_file(1);
										++num_passive_sub;
									}
									else load_passive_file(1);
									msg_dlg("Alert", buf);
								}
								else
								{
									char32 buf[] = "Passive Subscreen #%i could not be deleted\nMenu data will be refreshed";
									sprintf(buf, buf, passive_indx+1);
									err_dlg(buf);
									return; //Reset menu
								}
							}
						} //end
						if(PROC_CONFIRM==button(bit, ACOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 4), BUTTON_WIDTH, BUTTON_HEIGHT, "Edit", data, proc_data, 8)) //start
						{
							load_passive_file(passive_indx+1);
							load_active_file(active_indx+1);
							if(runEditor(1))
								save_active_file(active_indx+1);
							else load_active_file(active_indx+1);
						} //end
						if(PROC_CONFIRM==button(bit, PCOL_X+BUTTON_XOFF, FRAME_Y + 8 + ((BUTTON_HEIGHT + BUTTON_SPACING) * 4), BUTTON_WIDTH, BUTTON_HEIGHT, "Edit", data, proc_data, 9)) //start
						{
							load_passive_file(passive_indx+1);
							if(runEditor(2))
								save_passive_file(passive_indx+1);
							else load_passive_file(passive_indx+1);
						} //end
					}
					//Mode Buttons
					{
						if(PROC_CONFIRM==button(bit, FRAME_X + MARGIN_WIDTH + (BUTTON_WIDTH + 5)*0, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "S%ystem", data, proc_data, 10))
						{
							open_data_pane(DLG_SYSTEM, PANE_T_SYSTEM);
						}
						if(PROC_CONFIRM==button(bit, FRAME_X + MARGIN_WIDTH + (BUTTON_WIDTH + 5)*1, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "%Themes", data, proc_data, 11))
						{
							open_data_pane(DLG_THEMES, PANE_T_SYSTEM);
						}
						if(PROC_CONFIRM==button(bit, FRAME_X + MARGIN_WIDTH + (BUTTON_WIDTH + 5)*2, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "T%est", data, proc_data, 12))
						{
							load_active_file(active_indx+1);
							load_passive_file(passive_indx+1);
							runEditor(0);
						}
						//UNFINISHED TEXT- explain how to get back to this menu from another mode
					}
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				dm->ASubScript = 0;
				dm->PSubScript = 0;
				subscr_Waitframe();
			}
			/* Unreachable
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
			*/
		} //end
		bool runEditor(int mode) //start
		{
			switch(mode)
			{
				case 0:
					disableKeys(false);
					break;
				case 1:
					memset(mod_flags, 0, g_arr[NUM_ACTIVE_MODULES]);
					break;
				case 2:
					memset(mod_flags, 0, g_arr[NUM_PASSIVE_MODULES]);
					break;
			}
			int ex_active_script = Game->GetDMapScript("TestingActiveSub");
			int ex_passive_script = Game->GetDMapScript("TestingPassiveSub");
			while(true)
			{
				dmapdata dm = Game->LoadDMapData(Game->GetCurDMap());
				switch(mode)
				{
					case 0:
						dm->ASubScript = ex_active_script;
						dm->PSubScript = ex_passive_script;
						break;
					case 1:
						dm->ASubScript = 0;
						dm->PSubScript = 0;
						runFauxActiveSubscreen();
						KillButtons();
						break;
					case 2:
						dm->ASubScript = 0;
						dm->PSubScript = 0;
						runFauxPassiveSubscreen(true);
						runPreparedSelector(false);
						ColorScreen(7, PAL[COL_NULL], true);
						getSubscreenBitmap(false)->Blit(7, RT_SCREEN, 0, 0, 256, 56, 0, PASSIVE_EDITOR_TOP, 256, 56, 0, 0, 0, 0, 0, true);
						clearPassive1frame();
						KillButtons();
						break;
				}
				if(SubEditorData[SED_QUEUED_DELETION])
				{
					if(SubEditorData[SED_QUEUED_DELETION]<0) //passive
					{
						for(int q = -SubEditorData[SED_QUEUED_DELETION]; q < g_arr[NUM_PASSIVE_MODULES]-1; ++q)
						{
							mod_flags[q] = mod_flags[q+1];
						}
						mod_flags[g_arr[NUM_PASSIVE_MODULES]-1] = 0;
						remove_passive_module(-SubEditorData[SED_QUEUED_DELETION]);
					}
					else //active
					{
						for(int q = SubEditorData[SED_QUEUED_DELETION]; q < g_arr[NUM_ACTIVE_MODULES]-1; ++q)
						{
							mod_flags[q] = mod_flags[q+1];
						}
						mod_flags[g_arr[NUM_ACTIVE_MODULES]-1] = 0;
						remove_active_module(SubEditorData[SED_QUEUED_DELETION]);
					}
					SubEditorData[SED_QUEUED_DELETION]=0;
				}
				if(handle_data_pane(mode==1)) continue;
				int gret = GUIRET_NULL;
				if(mode) gret = DIALOG::runGUI(mode==1);
				if(keyprocp(KEY_ESC) || gret == GUIRET_EXIT)
				{
					Game->ClickToFreezeEnabled = false;
					if(mode)
					{
						ProcRet r = yesno_dlg("Exiting Edit Mode", "Would you like to save your changes?" ,"Save", "Revert");
						if(r == PROC_CONFIRM) return true;
						if(r == PROC_DENY) return false;
					}
					else
					{
						disableKeys(true);
						return true;
					}
				}
				if(mode) subscr_Waitframe();
				else
				{
					Waitframe();
					pollKeys();
				}
			}
		} //end
		void disableKeys(bool dis)
		{
			Input->DisableKey[KEY_ESC] = true;
			Input->DisableKey[KEY_F1] = dis;
			Game->FFRules[qr_NOFASTMODE] = dis;
			Game->ClickToFreezeEnabled = !dis;
		}
		//end Main Menu
		//start SaveLoad
		void save()
		{
			msg_dlg("WIP", "This feature is still under construction. Please wait for an update.");
			return;
		}
		void load()
		{
			msg_dlg("WIP", "This feature is still under construction. Please wait for an update.");
		}
		//end SaveLoad
		//Misc Mini-DLGs
		//start Select Color
		Color pick_color(Color default_color)
		{
			gen_startup();
			//start setup0
			DEFINE WIDTH = 128
				 , BAR_HEIGHT = 11
			     , HEIGHT = 128+BAR_HEIGHT
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "Color Picker";
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			Color active_swatch = default_color;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			bool do_save_changes = false;
			//end
			untyped proc_data[2] = {true, 0}; //Default TRUE for "is selected" on colorgrid.
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, "Choose a color from the palette selector.")==PROC_CANCEL || CancelButtonP())
					running = false;
				
				active_swatch = colorgrid(bit, 32, 32, active_swatch, 4, data, proc_data, 0);
				
				DEFINE BUTTON_WIDTH = 32, BUTTON_HEIGHT = 16;
				if(PROC_CONFIRM==button(bit, 64-(BUTTON_WIDTH/2), 32+(0xE*4)+16, BUTTON_WIDTH, BUTTON_HEIGHT, "Select", data, proc_data, 1, FLAG_DEFAULT))
				{
					running = false;
					do_save_changes = true;
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
			if(do_save_changes)
			{
				return active_swatch;
			}
			else
			{
				return default_color;
			}
		}
		//end
		//start Select Tile
		DEFINE TL_PER_ROW = 16;
		DEFINE TL_PER_COL = 13;
		DEFINE TL_PER_PAGE = TL_PER_ROW * TL_PER_COL;
		DEFINE E_TILE_PER_ROW = 20;
		DEFINE E_TILE_PER_COL = 13;
		DEFINE E_TILE_PER_PAGE = E_TILE_PER_ROW * E_TILE_PER_COL;
		void pick_tile(int arr) //start
		{
			gen_startup();
			//start Setup
			DEFINE WIDTH = 256, HEIGHT = 224;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			char32 titlefmt[] = "Tile Picker - Page %d (Engine Page %d) - Tile %d, CS %d";
			int tl = arr[0];
			int cs = arr[1];
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			//end Setup
			
			int clk, iclk;
			bool controls = true;
			bitmap blnk = create(256, 208);
			blnk->ClearToColor(0, COL_NULL);
			blnk->Rectangle(0, 1, 1, 14, 14, PAL[COL_CURSOR], 1, 0, 0, 0, false, OP_OPAQUE);
			blnk->Line(0, 1, 1, 14, 14, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
			blnk->Line(0, 1, 14, 14, 1, PAL[COL_CURSOR], 1, 0, 0, 0, OP_OPAQUE);
			for(int tx = 1; tx < 16; ++tx)
			{
				blnk->Blit(0, blnk, 0, 0, 16, 16, tx*16, 0, 16, 16, 0, 0, 0, BITDX_NORMAL, 0, false);
			}
			for(int ty = 1; ty < 13; ++ty)
			{
				blnk->Blit(0, blnk, 0, 0, 256, 16, 0, ty*16, 256, 16, 0, 0, 0, BITDX_NORMAL, 0, false);
			}
			
			while(running)
			{
				if(keyprocp(KEY_TAB)) controls = !controls;
				clk = (clk+1) % 3600;
				iclk = (iclk+1) % 3600;
				bit->ClearToColor(0, PAL[COL_NULL]);
				//
				if(keyprocp(KEY_EQUALS) || keyprocp(KEY_PLUS_PAD))
				{
					cs = (cs+1) % 12;
				}
				else if(keyprocp(KEY_MINUS) || keyprocp(KEY_MINUS_PAD))
				{
					if(--cs < 0) cs = 11;
				}
				bool ki = !(iclk%60);
				
				if(SubEditorData[SED_LCLICKING])
				{
					int mx = DLGMouseX(data), my = DLGMouseY(data);
					tl = (tl - (tl % TL_PER_PAGE)) + Div(mx,16) + Div(my-8,16) * TL_PER_ROW;
				}
				if(Input->Press[CB_DOWN] || (ki && Input->Button[CB_DOWN]))
					tl += TL_PER_ROW;
				else if(Input->Press[CB_UP] || (ki && Input->Button[CB_UP]))
					tl -= TL_PER_ROW;
				else if(Input->Press[CB_RIGHT] || (ki && Input->Button[CB_RIGHT]))
					++tl;
				else if(Input->Press[CB_LEFT] || (ki && Input->Button[CB_LEFT]))
					--tl;
				else if(keyprocp(KEY_PGDN) || SubEditorData[SED_MOUSE_Z] < SubEditorData[SED_LASTMOUSE_Z])
					tl += TL_PER_PAGE;
				else if(keyprocp(KEY_PGUP) || SubEditorData[SED_MOUSE_Z] > SubEditorData[SED_LASTMOUSE_Z])
					tl -= TL_PER_PAGE;
				else if(keyprocp(KEY_P))
				{
					tl = jumpPage(tl);
				}
				if(Input->Press[CB_UP] || Input->Press[CB_DOWN] || Input->Press[CB_RIGHT] || Input->Press[CB_LEFT])
					iclk = 0;
				if(tl < 0) tl += NUM_TILES;
				else tl %= NUM_TILES;
				
				if(DefaultButtonP())
				{
					arr[0] = tl;
					arr[1] = cs;
					running = false;
				}
				//
				int pg = Div(tl, TL_PER_PAGE);
				int pgtl = pg*TL_PER_PAGE;
				//
				char32 title[128];
				sprintf(title, titlefmt, pg, Div(tl, E_TILE_PER_PAGE), tl, cs);
				if(title_bar(bit, 0, 8, title, data, "", false)==PROC_CANCEL || CancelButtonP())
				{
					running = false;
				}
				//
				blnk->Blit(0, bit, 0, 0, 256, 208, 0, 8, 256, 208, 0, 0, 0, BITDX_NORMAL, 0, false);
				for(int q = 0; q < TL_PER_PAGE && q+pgtl < MAX_TILE; ++q)
				{
					unless(Graphics->IsBlankTile[q+pgtl])
						bit->DrawTile(0, (q % TL_PER_ROW) * 16, 8 + Div(q, TL_PER_ROW) * 16, pgtl+q, 1, 1, cs, -1, -1, 0, 0, 0, 0, false, OP_OPAQUE);
				}
				/*unless(pgtl + TL_PER_PAGE > MAX_TILE)
					bit->DrawTile(7, 0, 8, pgtl, TL_PER_ROW, TL_PER_COL, cs, -1, -1, 0, 0, 0, 0, false, OP_OPAQUE);
				else //Last page can't fit all the tiles
				{
					bit->Rectangle(7, 0, 8, 255, 224, PAL[COL_HIGHLIGHT], 1, 0, 0, 0, true, OP_OPAQUE);
					bit->DrawTile(7, 0, 8, pgtl, TL_PER_ROW, 3, cs, -1, -1, 0, 0, 0, 0, false, OP_OPAQUE);
					bit->DrawTile(7, 0, 8 + (3*16), pgtl + (3*TL_PER_ROW), 4, 1, cs, -1, -1, 0, 0, 0, 0, false, OP_OPAQUE);
				}*/
				//
				if(clk & 1100000b)
				{
					int pos = tl % TL_PER_PAGE;
					int x1 = (pos % TL_PER_ROW) * 16, y1 = 8 + Div(pos,TL_PER_ROW) * 16;
					bit->Rectangle(0, x1, y1, x1+15, y1+15, PAL[COL_CURSOR], 1, 0, 0, 0, false, OP_OPAQUE);
				}
				if(controls)
				{
					frame_rect(bit, 0, HEIGHT-49, WIDTH-1, HEIGHT-1, 1);
					text(bit, WIDTH/2, HEIGHT-46, TF_CENTERED,
					     "Controls:\nTab: Toggle Controls | P: Jump to Page\n"
					     "PGUP / PGDN and Mousewheel: Change Page\n"
					     "Dirs: Move Cursor | Click: Move Cursor\n"
					     "+/-: Change CSet | Enter: Confirm | ESC: Cancel"
					     , PAL[COL_TEXT_MAIN], 200);
				}
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
		} //end
		
		int jumpPage(int cur_tl) //start
		{
			gen_startup();
			//start setup
			DEFINE MARGIN_WIDTH = 1
			     , WIDTH = 162
				 , TXTWID = WIDTH - ((MARGIN_WIDTH+1)*2)
				 , BAR_HEIGHT = 11
			     , HEIGHT = BAR_HEIGHT+47
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			//end
			untyped proc_data[2];
			bool engine_page = false;
			char32 pgbuf[16] = "0";
			DEFINE MAX_PAGE = Div(MAX_TILE, TL_PER_PAGE);
			DEFINE MAX_E_PAGE = Div(MAX_TILE, E_TILE_PER_PAGE);
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, 0, BAR_HEIGHT, "Jump to Page", data, "")==PROC_CANCEL || CancelButtonP())
				{
					running = false;
				}
				//
				char32 buf[] = "Engine Page Number";
				switch(titled_checkbox(bit, FRAME_X, FRAME_Y, 7, engine_page, data, 0, buf))
				{
					case PROC_UPDATED_FALSE:
						engine_page = false;
						break;
					case PROC_UPDATED_TRUE:
						engine_page = true;
						break;
				}
				//
				char32 buf1[] = "Page:";
				titled_inc_text_field(bit, FRAME_X+3+Text->StringWidth(buf1, DIA_FONT), FRAME_Y+12, 28, pgbuf, 3, false, data, 0, 0, 0, engine_page ? MAX_E_PAGE : MAX_PAGE, buf1);
				//
				if(PROC_CONFIRM==button(bit, FRAME_X+BUTTON_WIDTH+3, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 0))
				{
					running = false;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Confirm", data, proc_data, 1, FLAG_DEFAULT))
				{
					running = false;
					int pg = atoi(pgbuf);
					if(engine_page)
					{
						int etl = pg*E_TILE_PER_PAGE;
						cur_tl = (cur_tl % TL_PER_PAGE) + (etl - (etl % TL_PER_PAGE));
					}
					else
					{
						cur_tl = (cur_tl % TL_PER_PAGE) + (pg*TL_PER_PAGE);
					}
					if(cur_tl > MAX_TILE)
						cur_tl = MAX_TILE;
				}
				
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
			return cur_tl;
		} //end
		//end Select Tile
		//start YesNo
		ProcRet yesno_dlg(char32 msg)
		{
			return yesno_dlg("", msg, "%Yes", "%No");
		}
		ProcRet yesno_dlg(char32 title, char32 msg)
		{
			return yesno_dlg(title, msg, "", "%Yes", "%No");
		}
		ProcRet yesno_dlg(char32 title, char32 msg, char32 descstr)
		{
			return yesno_dlg(title, msg, descstr, "%Yes", "%No");
		}
		ProcRet yesno_dlg(char32 title, char32 msg, char32 yestxt, char32 notxt)
		{
			return yesno_dlg(title, msg, "", yestxt, notxt);
		}
		ProcRet yesno_dlg(char32 title, char32 msg, char32 descstr, char32 yestxt, char32 notxt)
		{
			gen_startup();
			//start setup
			DEFINE MARGIN_WIDTH = 1
			     , WIDTH = 162
				 , TXTWID = WIDTH - ((MARGIN_WIDTH+1)*2)
				 , NUM_ROWS_TEXT = DrawStringsCount(DIA_FONT, msg, TXTWID)
				 , BAR_HEIGHT = 11
			     , HEIGHT = BAR_HEIGHT+10+(Text->FontHeight(DIA_FONT)*1.5*NUM_ROWS_TEXT)+5+3+2
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			ProcRet ret = PROC_NULL;
			//end
			untyped proc_data[2];
			until(ret)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, descstr)==PROC_CANCEL || CancelButtonP())
				{
					ret = PROC_CANCEL;
				}
				
				text(bit, WIDTH/2, BAR_HEIGHT + 5, TF_CENTERED, msg, PAL[COL_TEXT_MAIN], TXTWID);
				
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, (WIDTH/2)-6-BUTTON_WIDTH, HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, yestxt, data, proc_data, 0, FLAG_DEFAULT))
				{
					ret = PROC_CONFIRM;
				}
				if(PROC_CONFIRM==button(bit, (WIDTH/2)+6, HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, notxt, data, proc_data, 1))
				{
					ret = PROC_DENY;
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
			return ret;
		}
		//end 
		//start msg_dlg
		void msg_dlg(char32 msg)
		{
			msg_dlg("", msg, "", "O%k");
		}
		void msg_dlg(char32 title, char32 msg)
		{
			msg_dlg(title, msg, "", "O%k");
		}
		void msg_dlg(char32 title, char32 msg, char32 descstr)
		{
			msg_dlg(title, msg, descstr, "O%k");
		}
		void msg_dlg(char32 title, char32 msg, char32 descstr, char32 oktxt) //start
		{
			gen_startup();
			
			//start setup
			DEFINE MARGIN_WIDTH = 1
			     , WIDTH = 192
				 , TXTWID = WIDTH - ((MARGIN_WIDTH+1)*2)
				 , NUM_ROWS_TEXT = DrawStringsCount(DIA_FONT, msg, TXTWID)
				 , BAR_HEIGHT = 11
			     , HEIGHT = BAR_HEIGHT+10+(Text->FontHeight(DIA_FONT)*1.5*NUM_ROWS_TEXT)+5+3+2
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = create(WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			//
			null_screen();
			draw_dlg(bit, data);
			KillButtons();
			Waitframe();
			//
			center_dlg(bit, data);
			
			bool running = true;
			//end
			untyped proc_data[1];
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data, descstr)==PROC_CANCEL || CancelButtonP())
					running = false;
				
				text(bit, WIDTH/2, BAR_HEIGHT + 5, TF_CENTERED, msg, PAL[COL_TEXT_MAIN], TXTWID);
				
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, (WIDTH/2)-(BUTTON_WIDTH/2), HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, oktxt, data, proc_data, 0, FLAG_DEFAULT))
				{
					running = false;
				}
				
				//
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			for(int q = 0; q < DIA_CLOSING_DELAY; ++q) //Delay on closing
			{
				null_screen();
				draw_dlg(bit, data);
				KillButtons();
				subscr_Waitframe();
			}
			
			bit->Free();
			gen_final();
		} //end
		void err_dlg(char32 msg)
		{
			msg_dlg("Error", msg, "Something went wrong; maybe a file wasn't found, or an internal error occurred.");
		}
		//end
		//start Dropdown
		int dropdown_open(bitmap parentBit, const int x, int y, const int WIDTH, int selIndx, untyped parentDLGData, char32 strings, int NUM_OPTS, int NUM_VIS_OPTS)
		{
			DEFINE BKUP_INDX = selIndx;
			/* Notes:
			parentBit is not actually `bit`, but needs to be a new sub-bitmap (same size as `bit`). 
			`fullblit(0, sub, bit)` should be called before `ClearToColor`, so the sub stores the last frame's draw. (in the dlg that calls this)
			Also, a proc needs to call this. The proc handles the part that's always visible, this func only handles the list itself after opening.
			/
			strings is char32[][]; an array of char32[] pointers. Each index is a full string!
			/
			Make a subbitmap for the procs to draw to. Blit a portion of that (based on scroll) to the main bitmap of the dlg.
			Scroll: No bar, just buttons; a button for up/down, and top/bottom. Buttons should take the entire bar space.
			*/
			//start setup
			gen_startup();
			DEFINE MARGIN_WIDTH = 0;
			DEFINE TXT_VSPACE = 2;
			DEFINE UNIT_HEIGHT = TXT_VSPACE + Text->FontHeight(DIA_FONT);
			DEFINE NUM_OPTS_FLIP = 8;
			if(NUM_VIS_OPTS < 0) //Fit-to-screen
			{
				NUM_VIS_OPTS = Min(Div(224 - (2*MARGIN_WIDTH) - y, UNIT_HEIGHT), NUM_OPTS);
				if(NUM_VIS_OPTS < NUM_OPTS_FLIP && NUM_VIS_OPTS < NUM_OPTS)
				{
					y -= UNIT_HEIGHT*(NUM_OPTS_FLIP+1)+1;
					NUM_VIS_OPTS = NUM_OPTS_FLIP;
				}
			}
			else if(y+(UNIT_HEIGHT * Min(NUM_VIS_OPTS, NUM_OPTS_FLIP))>224)
			{
				NUM_VIS_OPTS = Min(Div(224 - (2*MARGIN_WIDTH) - y, UNIT_HEIGHT), NUM_OPTS);
				if(NUM_VIS_OPTS < NUM_OPTS_FLIP && NUM_VIS_OPTS < NUM_OPTS)
				{
					NUM_VIS_OPTS = Min(NUM_OPTS_FLIP, NUM_OPTS);
					y -= UNIT_HEIGHT*(NUM_VIS_OPTS+1)+1;
				}
			}
			NUM_VIS_OPTS = Min(NUM_VIS_OPTS, NUM_OPTS);
			const bool DO_BUTTONS = NUM_VIS_OPTS < NUM_OPTS;
			DEFINE MAX_SCROLL_INDX = NUM_OPTS-NUM_VIS_OPTS;
			DEFINE TXT_X = MARGIN_WIDTH+2;
			DEFINE BTN_WIDTH = DO_BUTTONS ? 10 : 0;
			DEFINE BMP_WIDTH = WIDTH - BTN_WIDTH;
			DEFINE BTN_X = BMP_WIDTH;
			DEFINE HEIGHT = Max((MARGIN_WIDTH * 2) + (UNIT_HEIGHT*NUM_VIS_OPTS)-1, DO_BUTTONS ? BTN_WIDTH*4 : 0);
			DEFINE BMP_HEIGHT = (MARGIN_WIDTH * 2) + (UNIT_HEIGHT*NUM_OPTS);
			DEFINE BTN_HEIGHT = HEIGHT/4;
			int scrollIndx = Min(selIndx, MAX_SCROLL_INDX);
			bitmap bit = create(WIDTH, HEIGHT),
			       listbit = create(BMP_WIDTH, BMP_HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			listbit->ClearToColor(0, PAL[COL_NULL]);
			
			untyped data[DLG_DATA_SZ];
			data[DLG_DATA_WID] = WIDTH;
			data[DLG_DATA_HEI] = HEIGHT;
			data[DLG_DATA_XOFFS] = x + parentDLGData[DLG_DATA_XOFFS];
			data[DLG_DATA_YOFFS] = y + parentDLGData[DLG_DATA_YOFFS];
			untyped ldata[DLG_DATA_SZ];
			ldata[DLG_DATA_WID] = BMP_WIDTH;
			ldata[DLG_DATA_HEI] = BMP_HEIGHT;
			ldata[DLG_DATA_XOFFS] = data[DLG_DATA_XOFFS];
			ldata[DLG_DATA_YOFFS] = data[DLG_DATA_YOFFS] - (scrollIndx*UNIT_HEIGHT);
			//
			null_screen();
			draw_dlg(parentBit, parentDLGData);
			KillButtons();
			Waitframe(); //NOT subscr_Waitframe.
			//
			bool running = true;
			//end
			untyped proc_data[4];
			bool was_clicking;
			while(running)
			{
				bit->Clear(0);
				listbit->Clear(0);
				ldata[DLG_DATA_YOFFS] = data[DLG_DATA_YOFFS] - (scrollIndx*UNIT_HEIGHT); //update to current scroll
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, 1, PAL[COL_FIELD_BG]);
				//h_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, PAL[COL_BODY_MAIN_DARK]);
				bool isHoveringList = DLGCursorBox(0, 0, BMP_WIDTH-1, HEIGHT-1, data);
				int cy = DLGMouseY(ldata);
				//List options
				{
					int ty = MARGIN_WIDTH + 2;
					for(int q = 0; q < NUM_OPTS; ++q)
					{
						if(q==selIndx) rect(listbit, 0, ty-2, 0+BMP_WIDTH-1, ty+UNIT_HEIGHT-2, PAL[COL_HIGHLIGHT]);
						char32 buf[128];
						char32 ptr = buf;
						if(strings > 0)
							ptr = strings[q];
						else unless(strings)
							itoa(buf,q+1);
						else getSpecialString(buf, strings, q);
						text(listbit, TXT_X, ty, TF_NORMAL, ptr, PAL[COL_TEXT_FIELD]);
						ty += Text->FontHeight(DIA_FONT) + TXT_VSPACE;
					}
				}
				//Directionals
				{
					if(keyprocp(KEY_UP) || SubEditorData[SED_MOUSE_Z] > SubEditorData[SED_LASTMOUSE_Z])
					{
						selIndx = Max(selIndx-1, 0);
						scrollIndx = VBound(scrollIndx, Min(MAX_SCROLL_INDX, selIndx), Max(0, selIndx-NUM_VIS_OPTS+1));
					}	
					else if(keyprocp(KEY_DOWN) || SubEditorData[SED_MOUSE_Z] < SubEditorData[SED_LASTMOUSE_Z])
					{
						selIndx = Min(selIndx+1, NUM_OPTS-1);
						scrollIndx = VBound(scrollIndx, Min(MAX_SCROLL_INDX, selIndx), Max(0, selIndx-NUM_VIS_OPTS+1));
					}
				}
				//Buttons
				if(DO_BUTTONS)
				{
					int by = 0;
					if(PROC_CONFIRM==button(bit, BTN_X, by, BTN_WIDTH, BTN_HEIGHT, "", data, proc_data, 0, (scrollIndx <= 0) ? FLAG_DISABLE : 0))
					{
						scrollIndx = 0;
					}
					line(bit, BTN_X + 2, by + (BTN_HEIGHT/2)-1, (BTN_X + BTN_WIDTH/2)-1, by+2, (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + (BTN_HEIGHT/2)-1, (BTN_X + BTN_WIDTH/2), by+2, (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + 2, by + BTN_HEIGHT - 2 - 1, (BTN_X + BTN_WIDTH/2)-1, by + (BTN_HEIGHT/2), (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + BTN_HEIGHT - 2 - 1, (BTN_X + BTN_WIDTH/2), by + (BTN_HEIGHT/2), (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					by += BTN_HEIGHT;
					if(PROC_CONFIRM==button(bit, BTN_X, by, BTN_WIDTH, BTN_HEIGHT, "", data, proc_data, 1, (scrollIndx <= 0) ? FLAG_DISABLE : 0))
					{
						scrollIndx = Max(scrollIndx-1, 0);
					}
					line(bit, BTN_X + 2, by + (BTN_HEIGHT/2)-1, (BTN_X + BTN_WIDTH/2)-1, by+2, (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + (BTN_HEIGHT/2)-1, (BTN_X + BTN_WIDTH/2), by+2, (scrollIndx <=0) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					by += BTN_HEIGHT;
					if(PROC_CONFIRM==button(bit, BTN_X, by, BTN_WIDTH, BTN_HEIGHT, "", data, proc_data, 2, (scrollIndx >= MAX_SCROLL_INDX) ? FLAG_DISABLE : 0))
					{
						scrollIndx = Min(scrollIndx+1, MAX_SCROLL_INDX);
					}
					line(bit, BTN_X + 2, by + 5, (BTN_X + BTN_WIDTH/2)-1, by+(BTN_HEIGHT/2)+2, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + 5, (BTN_X + BTN_WIDTH/2), by+(BTN_HEIGHT/2)+2, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					by += BTN_HEIGHT;
					if(PROC_CONFIRM==button(bit, BTN_X, by, BTN_WIDTH, BTN_HEIGHT, "", data, proc_data, 3, (scrollIndx >= MAX_SCROLL_INDX) ? FLAG_DISABLE : 0))
					{
						scrollIndx = MAX_SCROLL_INDX;
					}
					line(bit, BTN_X + 2, by + 2, (BTN_X + BTN_WIDTH/2)-1, by+(BTN_HEIGHT/2)-1, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + 2, (BTN_X + BTN_WIDTH/2), by+(BTN_HEIGHT/2)-1, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + 2, by + (BTN_HEIGHT/2), (BTN_X + BTN_WIDTH/2)-1, by + BTN_HEIGHT - 2 - 1, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
					line(bit, BTN_X + BTN_WIDTH - 2 - 1, by + (BTN_HEIGHT/2), (BTN_X + BTN_WIDTH/2), by + BTN_HEIGHT - 2 - 1, (scrollIndx >= MAX_SCROLL_INDX) ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]);
				}
				
				if(isHoveringList)
				{
					if(SubEditorData[SED_LCLICKING])
					{
						was_clicking = true;
						selIndx = VBound(Div(cy-MARGIN_WIDTH, UNIT_HEIGHT), NUM_OPTS, 0); //Select clicked option
					}
					else if(was_clicking)
					{
						running = false;
					}
				}
				else
				{
					was_clicking = false;
					if(SubEditorData[SED_LCLICKED] && !DLGCursorBox(0, 0, WIDTH-1, HEIGHT-1, data))
					{
						selIndx = BKUP_INDX;
						running = false;
					}
				}
				if(DefaultButtonP())
				{
					running = false;
				}
				if(CancelButtonP())
				{
					selIndx = BKUP_INDX;
					running = false;
				}
				
				listbit->Blit(7, bit, 0, MARGIN_WIDTH+(scrollIndx*UNIT_HEIGHT)+1, BMP_WIDTH, HEIGHT-(MARGIN_WIDTH*2), 0, MARGIN_WIDTH, BMP_WIDTH, HEIGHT-(MARGIN_WIDTH*2), 0, 0, 0, 0, 0, true);
				null_screen();
				draw_dlg(parentBit, parentDLGData);
				draw_dlg(bit, data);
				if(keyprocp(KEY_R))
				{
					bitmap out = create(parentDLGData[DLG_DATA_WID], parentDLGData[DLG_DATA_HEI]);
					out->ClearToColor(0, PAL[COL_NULL]);
					moveblit(7, out, parentBit, parentDLGData[DLG_DATA_WID], parentDLGData[DLG_DATA_HEI]);
					bit->Blit(7, out, 0, 0, WIDTH-1, HEIGHT-1, data[DLG_DATA_XOFFS] - parentDLGData[DLG_DATA_XOFFS], data[DLG_DATA_YOFFS] - parentDLGData[DLG_DATA_YOFFS], WIDTH-1, HEIGHT-1, 0, 0, 0, 0, 0, true);
					out->Free();
				}
				KillButtons();
				subscr_Waitframe();
			}
			
			listbit->Free();
			bit->Free();
			
			gen_final();
			return selIndx;
		} //end
		//Other
		//start Spacing
		DEFINE CENTER_VIS_X = 256/2;
		DEFINE CENTER_VIS_Y = (224/2)-56;
		void center_dlg(bitmap bit, untyped dlgdata)
		{
			dlgdata[DLG_DATA_XOFFS] = CENTER_VIS_X - (dlgdata[DLG_DATA_WID]/2);
			dlgdata[DLG_DATA_YOFFS] = CENTER_VIS_Y - (dlgdata[DLG_DATA_HEI]/2);
			/*Trace(dlgdata[DLG_DATA_XOFFS]);
			Trace(dlgdata[DLG_DATA_YOFFS]);*/
		}
		//end
		//start Drawing
		void null_screen()
		{
			Screen->Rectangle(7, 0, -56, 256, 176, PAL[COL_NULL], 1, 0, 0, 0, true, OP_OPAQUE); //Blank the screen
		}
		
		void draw_dlg(bitmap bit, untyped dlgdata)
		{
			bit->Blit(7, RT_SCREEN, 0, 0, dlgdata[DLG_DATA_WID], dlgdata[DLG_DATA_HEI], dlgdata[DLG_DATA_XOFFS], dlgdata[DLG_DATA_YOFFS]
			        , dlgdata[DLG_DATA_WID], dlgdata[DLG_DATA_HEI], 0, 0, 0, 0, 0, true);
		}
		//end
		//start Misc
		enum ProcRet
		{
			PROC_NULL,
			PROC_CANCEL,
			PROC_CONFIRM,
			PROC_DENY,
			PROC_UPDATED_TRUE,
			PROC_UPDATED_FALSE
		};
		
		void get_module_name(char32 buf, int moduleType) //start
		{
			switch(moduleType)
			{
				case MODULE_TYPE_SETTINGS:
				{
					strcat(buf, "Settings"); break;
				}
				case MODULE_TYPE_BGCOLOR:
				{
					strcat(buf, "Background Color"); break;
				}
				case MODULE_TYPE_SEL_ITEM_ID:
				{
					strcat(buf, "Selectable Item (ID)"); break;
				}
				case MODULE_TYPE_SEL_ITEM_CLASS:
				{
					strcat(buf, "Selectable Item (Type)"); break;
				}
				case MODULE_TYPE_BUTTONITEM:
				{
					strcat(buf, "Button Item"); break;
				}
				case MODULE_TYPE_PASSIVESUBSCREEN:
				{
					strcat(buf, "Passive Subscreen"); break;
				}
				case MODULE_TYPE_MINIMAP:
				{
					strcat(buf, "Minimap"); break;
				}
				case MODULE_TYPE_BIGMAP:
				{
					strcat(buf, "Large Map"); break;
				}
				case MODULE_TYPE_TILEBLOCK:
				{
					strcat(buf, "Tile Block"); break;
				}
				case MODULE_TYPE_HEART:
				{
					strcat(buf, "Heart"); break;
				}
				case MODULE_TYPE_HEARTROW:
				{
					strcat(buf, "Heart Row"); break;
				}
				case MODULE_TYPE_MAGIC:
				{
					strcat(buf, "Magic"); break;
				}
				case MODULE_TYPE_MAGICROW:
				{
					strcat(buf, "Magic Row"); break;
				}
				case MODULE_TYPE_CRPIECE:
				{
					strcat(buf, "Counter Meter (Piece)"); break;
				}
				case MODULE_TYPE_CRROW:
				{
					strcat(buf, "Counter Meter (Row)"); break;
				}
				case MODULE_TYPE_COUNTER:
				{
					strcat(buf, "Counter"); break;
				}
				case MODULE_TYPE_MINITILE:
				{
					strcat(buf, "MiniTile"); break;
				}
				case MODULE_TYPE_NONSEL_ITEM_ID:
				{
					strcat(buf, "Item (ID)"); break;
				}
				case MODULE_TYPE_NONSEL_ITEM_CLASS:
				{
					strcat(buf, "Item (Class)"); break;
				}
				case MODULE_TYPE_CLOCK:
				{
					strcat(buf, "Clock"); break;
				}
				case MODULE_TYPE_ITEMNAME:
				{
					strcat(buf, "Item Name"); break;
				}
				case MODULE_TYPE_DMTITLE:
				{
					strcat(buf, "DMap Title"); break;
				}
				case MODULE_TYPE_FRAME:
				{
					strcat(buf, "Frame"); break;
				}
				case MODULE_TYPE_RECT:
				{
					strcat(buf, "Rectangle"); break;
				}
				case MODULE_TYPE_CIRC:
				{
					strcat(buf, "Circle"); break;
				}
				case MODULE_TYPE_LINE:
				{
					strcat(buf, "Line"); break;
				}
				case MODULE_TYPE_TRI:
				{
					strcat(buf, "Triangle"); break;
				}
			}
		} //end
		
		void get_module_desc(char32 buf, int moduleType) //start
		{
			switch(moduleType)
			{
				case MODULE_TYPE_SETTINGS:
				{
					strcat(buf, ""); break;
				}
				case MODULE_TYPE_BGCOLOR:
				{
					strcat(buf, "The background color of the subscreeen."); break;
				}
				case MODULE_TYPE_SEL_ITEM_ID:
				{
					strcat(buf, "A selectable object representing a specific item ID.\n\nSelectable objects have an 'Index' value. They also have 4 'Direction' values. Setting these direction values to the 'Index' of another selectable indicates where to select when a direction is pressed."); break;
				}
				case MODULE_TYPE_SEL_ITEM_CLASS:
				{
					strcat(buf, "A selectable object representing the highest item in the inventory of a specific item class.\n\nSelectable objects have an 'Index' value. They also have 4 'Direction' values. Setting these direction values to the 'Index' of another selectable indicates where to select when a direction is pressed."); break;
				}
				case MODULE_TYPE_BUTTONITEM:
				{
					strcat(buf, "Displays the currently equipped item of a given button."); break;
				}
				case MODULE_TYPE_PASSIVESUBSCREEN:
				{
					strcat(buf, "This module will draw the current scripted passive subscreen to the active subscreen.\n\nNote that this does NOT include the engine subscreen graphics."); break;
				}
				case MODULE_TYPE_MINIMAP:
				{
					strcat(buf, "Displays the minimap of the current DMap, with various settings."); break;
				}
				case MODULE_TYPE_BIGMAP:
				{
					strcat(buf, "Displays the large map of the current DMap, with various settings."); break;
				}
				case MODULE_TYPE_TILEBLOCK:
				{
					strcat(buf, "Draws a block of tiles to the screen."); break;
				}
				case MODULE_TYPE_HEART:
				{
					strcat(buf, "A single heart container."); break;
				}
				case MODULE_TYPE_HEARTROW:
				{
					strcat(buf, "A row of heart containers."); break;
				}
				case MODULE_TYPE_MAGIC:
				{
					strcat(buf, "A single magic container."); break;
				}
				case MODULE_TYPE_MAGICROW:
				{
					strcat(buf, "A row of magic containers."); break;
				}
				case MODULE_TYPE_CRPIECE:
				{
					strcat(buf, "A single unit of a meter."); break;
				}
				case MODULE_TYPE_CRROW:
				{
					strcat(buf, "A row of a meter."); break;
				}
			
				case MODULE_TYPE_COUNTER:
				{
					strcat(buf, "Displays the value of a counter."); break;
				}
			
				case MODULE_TYPE_MINITILE:
				{
					strcat(buf, "Draws a quarter of a tile."); break;
				}
				case MODULE_TYPE_NONSEL_ITEM_ID:
				{
					strcat(buf, "Draws a specific item ID."); break;
				}
				case MODULE_TYPE_NONSEL_ITEM_CLASS:
				{
					strcat(buf, "Draws the highest item in the inventory of a specific item class."); break;
				}
				case MODULE_TYPE_CLOCK:
				{
					strcat(buf, "Displays the current playtime, in 'hh:mm:ss' format."); break;
				}
				case MODULE_TYPE_ITEMNAME:
				{
					strcat(buf, "Displays the name of the currently selected item."); break;
				}
				case MODULE_TYPE_DMTITLE:
				{
					strcat(buf, "Displays the name of the current DMap."); break;
				}
				case MODULE_TYPE_FRAME:
				{
					strcat(buf, "Draws a frame, as the engine subscreen uses."); break;
				}
				case MODULE_TYPE_RECT:
				{
					strcat(buf, "Draws a rectangle."); break;
				}
				case MODULE_TYPE_CIRC:
				{
					strcat(buf, "Draws a circle."); break;
				}
				case MODULE_TYPE_LINE:
				{
					strcat(buf, "Draws a line."); break;
				}
				case MODULE_TYPE_TRI:
				{
					strcat(buf, "Draws a triangle."); break;
				}
			}
		} //end
		
		void get_flag_name(char32 buf, bool active, long flag) //start
		{
			if(active)
			{
				switch(flag)
				{
					case FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR:
					{
						strcat(buf, "Items Use Hitbox Size"); break;
					}
					default: strcat(buf, "--"); break;
				}
			}
			else
			{
				switch(flag)
				{
					default: strcat(buf, "--"); break;
				}
			}
		} //end
		
		void get_flag_desc(char32 buf, bool active, long flag) //start
		{
			if(active)
			{
				switch(flag)
				{
					case FLAG_ASTTNG_ITEMS_USE_HITBOX_FOR_SELECTOR:
					{
						strcat(buf, "The highlight around items, both in the editor and when selecting them in-game, are based on 'Hit' size if this is on, or 'Draw' size otherwise."); break;
					}
					default: break;
				}
			}
			else
			{
				switch(flag)
				{
					default: break;
				}
			}
		} //end
		
		bool DLGCursorBox(int x, int y, int x2, int y2, int xoffs, int yoffs) //start Automatically handle dlg offsets when reading the cursor's position
		{
			return SubEditorData[SED_MOUSE_X] + xoffs >= x && SubEditorData[SED_MOUSE_X] + xoffs <= x2
				&& SubEditorData[SED_MOUSE_Y] + yoffs >= y && SubEditorData[SED_MOUSE_Y] + yoffs <= y2;
		} //end
		bool DLGCursorBox(int x, int y, int x2, int y2, untyped dlgdata) //start Automatically handle dlg offsets when reading the cursor's position
		{
			int xoffs = -dlgdata[DLG_DATA_XOFFS], yoffs = -dlgdata[DLG_DATA_YOFFS];
			return SubEditorData[SED_MOUSE_X] + xoffs >= x && SubEditorData[SED_MOUSE_X] + xoffs <= x2
				&& SubEditorData[SED_MOUSE_Y] + yoffs >= y && SubEditorData[SED_MOUSE_Y] + yoffs <= y2;
		} //end
		
		bool DLGCursorRad(int x, int y, int radius, int xoffs, int yoffs) //start Automatically handle dlg offsets when reading the cursor's position
		{
			float tx = (x-(SubEditorData[SED_MOUSE_X]+xoffs));
			float ty = (y-(SubEditorData[SED_MOUSE_Y]+yoffs));
			float factor = (tx*tx)+(ty*ty);
			if ( factor < 0 ) return true;
			else return Sqrt(factor) < radius;
		} //end
		bool DLGCursorRad(int x, int y, int radius, untyped dlgdata) //start Automatically handle dlg offsets when reading the cursor's position
		{
			int xoffs = -dlgdata[DLG_DATA_XOFFS], yoffs = -dlgdata[DLG_DATA_YOFFS];
			float tx = (x-(SubEditorData[SED_MOUSE_X]+xoffs));
			float ty = (y-(SubEditorData[SED_MOUSE_Y]+yoffs));
			float factor = (tx*tx)+(ty*ty);
			if ( factor < 0 ) return true;
			else return Sqrt(factor) < radius;
		} //end
		
		int DLGMouseX(untyped dlgdata) //start
		{
			return SubEditorData[SED_MOUSE_X] - dlgdata[DLG_DATA_XOFFS];
		} //end
		
		int DLGMouseY(untyped dlgdata) //start
		{
			return SubEditorData[SED_MOUSE_Y] - dlgdata[DLG_DATA_YOFFS];
		} //end
		
		bool isHovering(untyped dlgdata) //start
		{
			return DLGCursorBox(0, 0, dlgdata[DLG_DATA_WID]-1, dlgdata[DLG_DATA_HEI]-1, dlgdata);
		} //end

		void grabType(char32 buf, int maxchar, TypeAString::TMode tm) //start
		{
			using namespace TypeAString;
			startTypingMode(maxchar, tm);
			addStr(buf);
			remchr(buf, 0);
			handleTyping();
			getType(buf);
			endTypingMode();
		} //end
		
		int _strchr(char32 str, int pos, char32 chr) //start
		{	//Find the first NON-ESCAPED instance of a character
			int ret = strchr(str, pos, chr);
			until(ret<0 || (ret==0 || str[ret-1]!='\\'))
				ret = strchr(str, ret+1, chr);
			return ret;
		} //end
		
		int count_bits(long arr) //start
		{
			int cnt = 0;
			for(int q = SizeOfArray(arr)-1; q >= 0; --q)
			{
				int ocnt = cnt;
				//printf("Counting bits from '%d' ... ", arr[q]);
				for(int b = 0; b < 32; ++b)
				{
					if(arr[q] & (FLAG1 << b))
					{
						++cnt;
					}
				}
				//printf("Counted %d, total %d\n", cnt-ocnt, cnt);
			}
			return cnt;
		} //end
		//end 
		//start Special String Lists
		enum
		{
			SSL_FONT = -1,
			SSL_ALIGNMENT = -2,
			SSL_ITEM = -3,
			SSL_SHADOWTYPE = -4,
			SSL_SP_CNTR = -5,
			SSL_CONDTYPE = -6,
			SSL_LICND = -7,
			SSL_COUNTER = -8
		};
		DEFINE DDWN_WID_FONT = 107;
		DEFINE DDWN_WID_ALIGN = 39;
		void getSpecialString(char32 buf, int val, int indx)
		{
			switch(val)
			{
				case SSL_FONT:
					getFontName(buf, indx);
					return;
				case SSL_ALIGNMENT:
					switch(indx)
					{
						case TF_NORMAL:
							strcpy(buf, "Left"); return;
						case TF_RIGHT:
							strcpy(buf, "Right"); return;
						case TF_CENTERED:
							strcpy(buf, "Center"); return;
						default:
							strcpy(buf, "ERROR");
					}
					return;
				case SSL_ITEM:
					itemdata id = Game->LoadItemData(indx);
					id->GetName(buf);
					return;
				case SSL_SHADOWTYPE:
					switch(indx) //start
					{
						case SHD_NORMAL:
							strcpy(buf, "No Shadow"); break;
						//These draw ONLY a shadow: no actual text
						case SHD_SHADOW:
							strcpy(buf, "Shadow"); break;
						case SHD_SHADOWU:
							strcpy(buf, "Shadow - U"); break;
						case SHD_OUTLINE8:
							strcpy(buf, "Shadow - O"); break;
						case SHD_OUTLINEPLUS:
							strcpy(buf, "Shadow - +"); break;
						case SHD_OUTLINEX:
							strcpy(buf, "Shadow - X"); break;
						//These draw a shadow behind the actual text
						case SHD_SHADOWED:
							strcpy(buf, "Shadowed"); break;
						case SHD_SHADOWEDU:
							strcpy(buf, "Shadowed - U"); break;
						case SHD_OUTLINED8:
							strcpy(buf, "Shadowed - O"); break;
						case SHD_OUTLINEDPLUS:
							strcpy(buf, "Shadowed - +"); break;
						case SHD_OUTLINEDX:
							strcpy(buf, "Shadowed - X"); break;
					} //end
					return;
				case SSL_SP_CNTR:
					switch(indx) //start
					{
						case CNTR_ANYKEY:
							strcpy(buf, "Any Keys");
							break;
						case CNTR_LKEY:
							strcpy(buf, "Level Keys");
							break;
						case CNTR_ABTN:
							strcpy(buf, "A Btn Cost");
							break;
						case CNTR_BBTN:
							strcpy(buf, "B Btn Cost");
							break;
						case CNTR_LBTN:
							strcpy(buf, "L Btn Cost");
							break;
						case CNTR_RBTN:
							strcpy(buf, "R Btn Cost");
							break;
						case CNTR_EX1BTN:
							strcpy(buf, "Ex1 Btn Cost");
							break;
						case CNTR_EX2BTN:
							strcpy(buf, "Ex2 Btn Cost");
							break;
						case CNTR_EX3BTN:
							strcpy(buf, "Ex3 Btn Cost");
							break;
						case CNTR_EX4BTN:
							strcpy(buf, "Ex4 Btn Cost");
							break;
					} //end
					return;
				case SSL_CONDTYPE:
					switch(indx) //start
					{
						case COND_NONE:
							strcpy(buf, "None"); break;
						case COND_SCRIPT:
							strcpy(buf, "Scripted"); break;
						case COND_LITEM:
							strcpy(buf, "Level Item"); break;
						case COND_ITEM:
							strcpy(buf, "Item Owned"); break;
						case COND_COUNTER:
							strcpy(buf, "Counter"); break;
						case COND_COUNTER_UNDER:
							strcpy(buf, "Counter Under"); break;
					} //end
					return;
				case SSL_LICND:
					switch(indx) //start
					{
						case LICND_TRIFORCE:
							strcpy(buf, "Triforce"); break;
						case LICND_MAP:
							strcpy(buf, "Map"); break;
						case LICND_COMPASS:
							strcpy(buf, "Compass"); break;
						case LICND_BOSS_DEAD:
							strcpy(buf, "Killed Boss"); break;
						case LICND_BOSSKEY:
							strcpy(buf, "Boss Key"); break;
					} //end
					return;
				case SSL_COUNTER:
					switch(indx) //start
					{
						case CR_LIFE:
							strcpy(buf, "Life"); break;
						case CR_RUPEES:
							strcpy(buf, "Rupees"); break;
						case CR_BOMBS:
							strcpy(buf, "Bombs"); break;
						case CR_ARROWS:
							strcpy(buf, "Arrows"); break;
						case CR_MAGIC:
							strcpy(buf, "Magic"); break;
						case CR_KEYS:
							strcpy(buf, "Keys"); break;
						case CR_SBOMBS:
							strcpy(buf, "Super Bombs"); break;
						case CR_SCRIPT1...CR_SCRIPT25:
							sprintf(buf, "Script %d", 1 + indx - CR_SCRIPT1); break;
					} //end
					return;
				default:
					strcpy(buf, "UNKNOWN LIST ACCESS");
			}
		}
		int getSpecialStringCount(int val)
		{
			switch(val)
			{
				case SSL_FONT:
					return NUM_FONTS;
				case SSL_ALIGNMENT:
					return 3;
				case SSL_ITEM:
					return MAX_ITEMDATA+1;
				case SSL_SHADOWTYPE:
					return SHD_MAX;
				case SSL_SP_CNTR:
					return CNTR_MAX_SPECIAL;
				case SSL_CONDTYPE:
					return MAX_COND_TYPE;
				case SSL_LICND:
					return MAX_LICND;
				case SSL_COUNTER:
					return MAX_COUNTER_INDX+1;
			}
			return 1;
		}
		//end Special String Lists
	}
}
