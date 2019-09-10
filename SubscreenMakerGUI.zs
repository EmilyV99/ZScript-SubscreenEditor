#option SHORT_CIRCUIT on

namespace Venrob::SubscreenEditor
{
	//start Palette
	enum Color //Based on Classic set!
	{
		TRANS = 0x00,
		WHITE = 0xEF,
		BLACK = 0xE0,
		DGRAY = 0xEC,
		GRAY = 0xED,
		LGRAY = 0xEE,
		PURPLE = 0xE6,
		BLUE = 0xE7,
		MBLUE = 0xE8,
		LBLUE = 0xE9,
		//System UI colors; these don't change
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
		Palette[COL_CURSOR] = WHITE;
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
		Palette[COL_CURSOR] = SYS_WHITE;
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
		Palette[COL_CURSOR] = SYS_BLACK;
		Palette[COL_HIGHLIGHT] = SYS_BLUE;
		Palette[COL_TITLE_BAR] = SYS_GRAY;
		Palette[COL_NULL] = SYS_BLACK;
		Palette[COL_TEXT_TITLE_BAR] = SYS_BLACK;
	} //end
	//end 
	
	namespace DIALOG
	{
		DEFINE DIA_FONT = FONT_Z3SMALL;
		DEFINE DIA_CLOSING_DELAY = 4;
		DEFINE GEN_BUTTON_WIDTH = 48, GEN_BUTTON_HEIGHT = 12;
		using namespace Venrob::SubscreenEditor::DIALOG::PARTS;
		namespace PARTS //start Individual procs
		{
			//Deco type procs: purely visual
			//start Deco: Generic
			void rect(bitmap bit, int x1, int y1, int x2, int y2, int color)
			{
				bit->Rectangle(0, x1, y1, x2, y2, color, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			void h_rect(bitmap bit, int x1, int y1, int x2, int y2, int color)
			{
				bit->Rectangle(0, x1, y1, x2, y2, color, 1, 0, 0, 0, false, OP_OPAQUE);
			}
			void circ(bitmap bit, int x, int y, int rad, int color)
			{
				bit->Circle(0, x, y, rad, color, 1, 0, 0, 0, true, OP_OPAQUE);
			}
			void tri(bitmap bit, int x1, int y1, int x2, int y2, int x3, int y3, int color)
			{
				bit->Triangle(0, x1, y1, x2, y2, x3, y3, 0, 0, color, 0, 0, 0, NULL);
			}
			void text(bitmap bit, int x, int y, int tf, char32 str, int color) //No width; straight draw
			{
				bit->DrawString(0, x, y, DIA_FONT, color, -1, tf, str, OP_OPAQUE);
			}
			void text(bitmap bit, int x, int y, int tf, char32 str, int color, int width) //Width; will wrap to next line
			{
				DrawStringsBitmap(bit, 0, x, y, DIA_FONT, color, -1, tf, str, OP_OPAQUE, Text->FontHeight(DIA_FONT)/2, width);
			}
			int _strchr(char32 str, int pos, char32 chr)
			{	//Find the first NON-ESCAPED instance of a character
				int ret = strchr(str, pos, chr);
				until(ret<0 || str[ret-1]!='\\')
					ret = strchr(str, ret+1, chr);
				return ret;
			}
			int shortcuttext_width(char32 str, int font)
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
			}
			bool shortcut_text(bitmap bit, int x, int y, char32 str, int color) //Character following a % will be underlined
			{
				printf("str: %s\n", str);
				int pos = _strchr(str, 0, '%');
				if(pos<0)
				{
					text(bit, x, y, TF_NORMAL, str, color);
					return false;
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
				printf("buf: %s\n", buf);
				if(key)
				{
					while(true)
					{
						pos = _strchr(buf, 0, '%');
						if(pos>-1)
						{
							remnchr(buf, pos, 1);
							char32 t_buf[256];
							strncpy(t_buf, buf, pos);
							printf("t_buf: %s\n", t_buf);
							int strwid = Text->StringWidth(t_buf, DIA_FONT), strhei = Text->FontHeight(DIA_FONT);
							bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, t_buf, OP_OPAQUE);
							c = buf[pos];
							line(bit, x+strwid-1, y+strhei, x+strwid-1+Text->CharWidth(c, DIA_FONT), y+strhei, color);
							remnchr(buf, 0, pos);
							x+=strwid;
						}
						else
						{
							bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, buf, OP_OPAQUE);
							return keyproc(key);
						}
					}
				}
				else
				{
					char32 t_buf[256];
					strncpy(t_buf, buf, pos);
					printf("t_buf: %s\n", t_buf);
					int strwid = Text->StringWidth(t_buf, DIA_FONT), strhei = Text->FontHeight(DIA_FONT);
					bit->DrawString(0, x, y, DIA_FONT, color, -1, TF_NORMAL, buf, OP_OPAQUE);
					c = buf[pos];
					line(bit, x+strwid-1, y+strhei, x+strwid-1+Text->CharWidth(c, DIA_FONT), y+strhei, color);
					return ((isAlphabetic(c) && keyproc(LowerToUpper(c)-'A'+KEY_A))||(isNumber(c) && keyproc(c-'0'+KEY_0)));
				}
			}
			void line(bitmap bit, int x, int y, int x2, int y2, int color)
			{
				bit->Line(0, x, y, x2, y2, color, 1, 0, 0, 0, OP_OPAQUE);
			}
			void x(bitmap bit, int x, int y, int len, int color)
			{
				int x2 = x+len-1, y2 = y+len-1;
				line(bit, x, y, x2, y2, color);
				line(bit, x, y2, x2, y, color);
			} //end
			//start Deco: Special
			void corner_border_effect(bitmap bit, int corner_x, int corner_y, int len, int corner_dir, int color)
			{	//A triangle, with a curve cut out of the hypotenuse. Right, Equilateral triangles only.
				int x1 = corner_x + (remY(corner_dir)==DIR_RIGHT ? -len : len),
				    y1 = corner_y,
					x2 = corner_x,
				    y2 = corner_y + (remX(corner_dir)==DIR_DOWN ? -len : len);
				bitmap sub = rent_bitmap();
				generate(sub, bit->Width, bit->Height);
				sub->Clear(0);
				tri(sub, corner_x, corner_y, x1, y1, x2, y2, color);
				circ(sub, x1, y2, len, 0x00);
				fullblit(0, bit, sub);
				free_bitmap(sub);
			}
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol, int ULCol, int DRCol)
			{
				rect(bit, x1, y1, x1+(margin-1), y2, ULCol);
				rect(bit, x2, y2, x1, y2-(margin-1), DRCol);
				rect(bit, x2, y2, x2-(margin-1), y1, DRCol);
				rect(bit, x1, y1, x2, y1+(margin-1), ULCol);
				
				rect(bit, x1+margin, y1+margin, x2-margin, y2-margin, FillCol);
			}
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol)
			{
				frame_rect(bit, x1, y1, x2, y2, margin, FillCol, PAL[COL_BODY_MAIN_LIGHT], PAL[COL_BODY_MAIN_DARK]);
			}
			void inv_frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin, int FillCol)
			{
				frame_rect(bit, x1, y1, x2, y2, margin, FillCol, PAL[COL_BODY_MAIN_DARK], PAL[COL_BODY_MAIN_LIGHT]);
			}
			void frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin)
			{
				frame_rect(bit, x1, y1, x2, y2, margin, PAL[COL_BODY_MAIN_MED]);
			}
			void inv_frame_rect(bitmap bit, int x1, int y1, int x2, int y2, int margin)
			{
				inv_frame_rect(bit, x1, y1, x2, y2, margin, PAL[COL_BODY_MAIN_MED]);
			}
			//end
			//Active type procs: functional
			//start components
			ProcRet x_out(bitmap bit, int x, int y, int len, untyped dlgdata)
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
			}
			
			ProcRet checkbox(bitmap bit, int x, int y, int len, bool checked, untyped dlgdata) //start
			{
				ProcRet ret = PROC_NULL;
				int x2 = x+len-1, y2 = y+len-1;
				if(SubEditorData[SED_LCLICKED] && DLGCursorBox(x,y,x2,y2,dlgdata))
				{
					checked = !checked;
					ret = checked ? PROC_UPDATED_TRUE : PROC_UPDATED_FALSE;
				}
				
				frame_rect(bit, x, y, x2, y2, 1, PAL[COL_FIELD_BG]);
				if(checked) x(bit, x+1, y+1, len-2, PAL[COL_TEXT_MAIN]);
				return ret;
			} //end
			ProcRet insta_button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata) //start
			{
				ProcRet ret = PROC_NULL;
				int x2 = x + wid - 1, y2 = y + hei - 1;
				if(DLGCursorBox(x,y,x2,y2,dlgdata) && SubEditorData[SED_LCLICKED])
				{
					ret = PROC_CONFIRM;
				}
				
				frame_rect(bit, x, y, x2, y2, 1);
				
				text(bit, x+(wid/2), y+Ceiling((hei-Text->FontHeight(DIA_FONT))/2), TF_CENTERED, btnText, PAL[COL_TEXT_MAIN]);
				
				return ret;
			} //end
			ProcRet button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata, untyped proc_data, int proc_indx, int flags) //start
			{
				bool was_held = proc_data[proc_indx];
				bool disabled = flags&FLAG_DISABLE;
				bool isDefault = flags&FLAG_DEFAULT;
				ProcRet ret = PROC_NULL;
				int x2 = x + wid - 1, y2 = y + hei - 1;
				bool indented = false;
				if(!disabled && DLGCursorBox(x,y,x2,y2,dlgdata))
				{
					if(SubEditorData[SED_LCLICKED] || (SubEditorData[SED_LCLICKING] && was_held))
					{
						was_held = true;
						indented = true;
					}
					else if(was_held)
					{
						was_held = false;
						ret = PROC_CONFIRM;
					}
				}
				else was_held = false;
				
				if(indented) inv_frame_rect(bit, x, y, x2, y2, isDefault ? 2 : 1);
				else frame_rect(bit, x, y, x2, y2, isDefault ? 2 : 1);
				
				int txtwid = shortcuttext_width(btnText, DIA_FONT);
				if(shortcut_text(bit, x+((wid-txtwid)/2), y+Ceiling((hei-Text->FontHeight(DIA_FONT))/2), btnText, disabled ? PAL[COL_DISABLED] : PAL[COL_TEXT_MAIN]) || (isDefault && DefaultButton()))
				{
					KillDLGButtons();
					ret = PROC_CONFIRM;
				}
				
				proc_data[proc_indx] = was_held;
				return ret;
			}
			ProcRet button(bitmap bit, int x, int y, int wid, int hei, char32 btnText, untyped dlgdata, untyped proc_data, int proc_indx)
			{
				button(bit, x, y, wid, hei, btnText, dlgdata, proc_data, proc_indx, 0);
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
			//end
			//start compounds
			ProcRet title_bar(bitmap bit, int margin, int barheight, char32 title, untyped dlgdata)
			{
				--barheight;
				rect(bit, margin, margin, dlgdata[DLG_DATA_WID]-margin-margin, barheight, PAL[COL_TITLE_BAR]);
				text(bit, margin+margin, margin+((barheight - Text->FontHeight(DIA_FONT))/2), TF_NORMAL, title, PAL[COL_TEXT_TITLE_BAR]);
				line(bit, margin, barheight, dlgdata[DLG_DATA_WID]-margin, barheight, PAL[COL_BODY_MAIN_DARK]);
				line(bit, margin, barheight+1, dlgdata[DLG_DATA_WID]-margin, barheight+1, PAL[COL_BODY_MAIN_LIGHT]);
				return x_out(bit, dlgdata[DLG_DATA_WID]-margin-1-(barheight-2), margin+1, barheight-3, dlgdata);
			}
			//end
		} //end
		//start Key procs
		bool keyproc(int key)
		{
			return Input->ReadKey[key];
		}
		bool DefaultButton()
		{
			return SubEditorData[SED_DEFAULTBTN_PRESSED];
		}
		bool CancelButton()
		{
			return SubEditorData[SED_CANCELBTN_PRESSED];
		}
		void KillDLGButtons()
		{
			SubEditorData[SED_CANCELBTN_PRESSED] = false;
			SubEditorData[SED_DEFAULTBTN_PRESSED] = false;
		}
		//end 
		//Flagsets
		DEFINE FLAG_DISABLE = 00000001b;
		DEFINE FLAG_DEFAULT = 00000010b;
		//DLG Data Organization
		enum
		{
			DLG_DATA_XOFFS, DLG_DATA_YOFFS, //ints; positional data
			DLG_DATA_WID, DLG_DATA_HEI,
			
			DLG_DATA_SZ
		};
		//ProcData - for global misc storage for the main GUI screen.
		untyped main_proc_data[MAX_INT];
		
		
		void gen_startup() //start
		{
			KillClicks();
			KillDLGButtons();
			KillButtons();
		} //end
		//Full DLGs
		//start Edit Object
		void editObj(untyped module_arr, int mod_indx, bool active)
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 256-32
			     , HEIGHT = 224-32
				 , BAR_HEIGHT = 11
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			int old_indx = mod_indx;
			bitmap bit = rent_bitmap();
			generate(bit, WIDTH, HEIGHT);
			bit->ClearToColor(0, PAL[COL_NULL]);
			
			char32 title[128] = "Edit Object #%d - %s";
			char32 module_name[64];
			get_module_name(module_name, module_arr[M_TYPE]);
			
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
			untyped proc_data[MAX_INT];
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				char32 TITLEBUF[1024];
				sprintf(TITLEBUF, title, mod_indx, module_name);
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, TITLEBUF, data)==PROC_CANCEL || CancelButton())
					running = false;
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, FRAME_X+BUTTON_WIDTH+3, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Cancel", data, proc_data, 1))
				{
					running = false;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X, HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "Confirm", data, proc_data, 2, FLAG_DEFAULT))
				{
					running = false;
					do_save_changes = true;
				}
				if(PROC_CONFIRM==button(bit, FRAME_X+(2*(BUTTON_WIDTH+3)), HEIGHT-(MARGIN_WIDTH+2)-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, "%%77%%D%e%lete", data, proc_data, 3))
				{
					if(yesno_dlg("Are you sure you want to delete this?"))
					{
						running = false;
						SubEditorData[SED_QUEUED_DELETION] = mod_indx;
						SubEditorData[SED_HIGHLIGHTED] = 0; //This had to be highlighted to open this menu!
						free_bitmap(bit);
						return;
					}
				}
				
				switch(module_arr[M_TYPE])
				{
					case MODULE_TYPE_BGCOLOR:
					{
						char32 buf[] = "Color:";
						text(bit, FRAME_X, FRAME_Y+12+5, TF_NORMAL, buf, PAL[COL_TEXT_MAIN]);
						module_arr[P1] = pal_swatch(bit, FRAME_X+Text->StringWidth(buf, DIA_FONT), FRAME_Y+12, 16, 16, module_arr[P1], data);
						break;
					}
					
					default:
					{
						text(bit, WIDTH/2, ((HEIGHT-(Text->FontHeight(DIA_FONT)*((1*3)+(0.5*2))))/2), TF_CENTERED, "WIP UNDER CONSTRUCTION", PAL[COL_TEXT_MAIN], 1);
						break;
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
				bit->Write(7, "_DIALOGUE.png", true);
				if(active)
				{
					remove_active_module(old_indx);
					add_active_module(module_arr, mod_indx);
				}
				else
				{
					remove_passive_module(old_indx);
					add_passive_module(module_arr, mod_indx);
				}
			}
			
			free_bitmap(bit);
		} //end editObj
		//start Main GUI
		enum GuiState
		{
			GUI_BOTTOM, GUI_TOP, GUI_HIDDEN,
			GUISTATE_MAX
		};
		DEFINE MAIN_GUI_WIDTH = 256;
		DEFINE MAIN_GUI_HEIGHT = 32;
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
		void runGUI(bool active)
		{
			if(SubEditorData[SED_ACTIVE_PANE]) return; //No main GUI during dialogs.
			if(Input->ReadKey[KEY_TAB])
			{
				SubEditorData[SED_GUISTATE] = ((SubEditorData[SED_GUISTATE]+1)%GUISTATE_MAX);
			}
			int yoffs = -56;
			switch(SubEditorData[SED_GUISTATE])
			{
				case GUI_HIDDEN:
					return;
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
			bitmap bit = getGUIBitmap();
			{
				//Deco
				frame_rect(bit, 0, 0, MAIN_GUI_WIDTH-1, MAIN_GUI_HEIGHT-1, 1);
				//Text
				text(bit, 2, 2, TF_NORMAL, "MENU: Move with 'TAB'", PAL[COL_TEXT_MAIN]);
				//Func
				//start BUTTONS
				DEFINE FIRSTROW_HEIGHT = Text->FontHeight(DIA_FONT)+3;
				DEFINE BUTTON_HEIGHT = Text->FontHeight(DIA_FONT)+3;
				DEFINE BUTTON_WIDTH = 58;//38;
				DEFINE BUTTON_HSPACE = 5;//4;
				DEFINE BUTTON_VSPACE = 3;
				DEFINE LEFT_MARGIN = 4;
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "New Obj", data, main_proc_data, 0))
				{
					open_data_pane(DLG_NEWOBJ, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*1), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Edit", data, main_proc_data, 1, SubEditorData[SED_HIGHLIGHTED] ? FLAG_DEFAULT : FLAG_DISABLE))
				{
					open_data_pane(SubEditorData[SED_HIGHLIGHTED], active);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*2), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "", data, main_proc_data, 2))
				{
					
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*3), FIRSTROW_HEIGHT + 0*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Settings", data, main_proc_data, 3))
				{
					open_data_pane(DLG_SETTINGS, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*0), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Save", data, main_proc_data, 4))
				{
					open_data_pane(DLG_SAVEAS, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*1), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Load", data, main_proc_data, 5))
				{
					open_data_pane(DLG_LOAD, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*2), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "System", data, main_proc_data, 6))
				{
					open_data_pane(DLG_SYSTEM, PANE_T_SYSTEM);
				}
				if(PROC_CONFIRM==button(bit, LEFT_MARGIN+((BUTTON_WIDTH+BUTTON_HSPACE)*3), FIRSTROW_HEIGHT + 1*(BUTTON_HEIGHT+BUTTON_VSPACE), BUTTON_WIDTH, BUTTON_HEIGHT, "Themes", data, main_proc_data, 7))
				{
					open_data_pane(DLG_THEMES, PANE_T_SYSTEM);
				}
				//end BUTTONS
			}
			draw_dlg(bit, data);
			if(isHovering(data)) clearPreparedSelector();
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
			bitmap bit = rent_bitmap();
			generate(bit, WIDTH, HEIGHT);
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
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data)==PROC_CANCEL || CancelButton())
					running = false;
				
				char32 buf[] = "Preview:";
				text(bit, FRAME_X, FRAME_Y+1, TF_NORMAL, buf, PAL[COL_TEXT_MAIN]);
				switch(checkbox(bit, FRAME_X+Text->StringWidth(buf, DIA_FONT), FRAME_Y, 7, preview&1b, data))
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
				bit->Write(7, "_DIALOGUE.png", true);
				memcpy(PAL, NEWPAL, PAL_SIZE);
			}
			else
			{
				memcpy(PAL, BCKUPPAL, PAL_SIZE);
			}
			
			free_bitmap(bit);
		}
		//end
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
			bitmap bit = rent_bitmap();
			generate(bit, WIDTH, HEIGHT);
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
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data)==PROC_CANCEL || CancelButton())
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
			
			free_bitmap(bit);
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
		//start YesNo
		bool yesno_dlg(char32 msg)
		{
			yesno_dlg("", msg, "%Yes", "%No");
		}
		bool yesno_dlg(char32 title, char32 msg)
		{
			yesno_dlg(title, msg, "%Yes", "%No");
		}
		bool yesno_dlg(char32 title, char32 msg, char32 yestxt, char32 notxt)
		{
			gen_startup();
			//start setup
			DEFINE WIDTH = 114
				 , BAR_HEIGHT = 11
			     , HEIGHT = BAR_HEIGHT+10+33+5+3
				 , MARGIN_WIDTH = 1
				 , FRAME_X = MARGIN_WIDTH+2
				 , FRAME_Y = MARGIN_WIDTH+BAR_HEIGHT+2
				 ;
			bitmap bit = rent_bitmap();
			generate(bit, WIDTH, HEIGHT);
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
			bool ret = false;
			//end
			untyped proc_data[2];
			while(running)
			{
				bit->ClearToColor(0, PAL[COL_NULL]);
				//Deco
				frame_rect(bit, 0, 0, WIDTH-1, HEIGHT-1, MARGIN_WIDTH);
				//Func
				if(title_bar(bit, MARGIN_WIDTH, BAR_HEIGHT, title, data)==PROC_CANCEL || CancelButton())
					running = false;
				
				text(bit, WIDTH/2, BAR_HEIGHT + 5, TF_CENTERED, msg, PAL[COL_TEXT_MAIN], WIDTH-(FRAME_X*2));
				
				DEFINE BUTTON_WIDTH = GEN_BUTTON_WIDTH, BUTTON_HEIGHT = GEN_BUTTON_HEIGHT;
				if(PROC_CONFIRM==button(bit, (WIDTH/2)-6-BUTTON_WIDTH, HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, yestxt, data, proc_data, 0, FLAG_DEFAULT))
				{
					running = false;
					ret = true;
				}
				if(PROC_CONFIRM==button(bit, (WIDTH/2)+6, HEIGHT-BUTTON_HEIGHT-3, BUTTON_WIDTH, BUTTON_HEIGHT, notxt, data, proc_data, 1))
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
			
			free_bitmap(bit);
			return ret;
		}
		//end 
		//Other
		//start Spacing
		DEFINE CENTER_VIS_X = 256/2;
		DEFINE CENTER_VIS_Y = (224/2)-56;
		void center_dlg(bitmap bit, untyped dlgdata)
		{
			dlgdata[DLG_DATA_XOFFS] = CENTER_VIS_X - (dlgdata[DLG_DATA_WID]/2);
			dlgdata[DLG_DATA_YOFFS] = CENTER_VIS_Y - (dlgdata[DLG_DATA_HEI]/2);
			Trace(dlgdata[DLG_DATA_XOFFS]);
			Trace(dlgdata[DLG_DATA_YOFFS]);
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
			PROC_UPDATED_TRUE,
			PROC_UPDATED_FALSE
		};
		
		void get_module_name(char32 buf, int moduleType)
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
				case MODULE_TYPE_SELECTABLE_ITEM_ID:
				{
					strcat(buf, "Selectable Item (ID)"); break;
				}
				case MODULE_TYPE_SELECTABLE_ITEM_CLASS:
				{
					strcat(buf, "Selectable Item (Type)"); break;
				}
				case MODULE_TYPE_ABUTTONITEM:
				{
					strcat(buf, "A Item"); break;
				}
				case MODULE_TYPE_BBUTTONITEM:
				{
					strcat(buf, "B Item"); break;
				}
				case MODULE_TYPE_PASSIVESUBSCREEN:
				{
					strcat(buf, "Passive Subscreen"); break;
				}
			}
		}
		
		bool DLGCursorBox(int x, int y, int x2, int y2, untyped dlgdata) //Automatically handle dlg offsets when reading the cursor's position
		{
			return CursorBox(x, y, x2, y2, -dlgdata[DLG_DATA_XOFFS], -dlgdata[DLG_DATA_YOFFS]);
		}
		
		int DLGMouseX(untyped dlgdata)
		{
			return Input->Mouse[MOUSE_X] - dlgdata[DLG_DATA_XOFFS];
		}
		
		int DLGMouseY(untyped dlgdata)
		{
			return Input->Mouse[MOUSE_Y] - dlgdata[DLG_DATA_YOFFS];
		}
		
		bool isHovering(untyped dlgdata)
		{
			return DLGCursorBox(0, 0, dlgdata[DLG_DATA_WID]-1, dlgdata[DLG_DATA_HEI]-1, dlgdata);
		} //end 
	}
}
