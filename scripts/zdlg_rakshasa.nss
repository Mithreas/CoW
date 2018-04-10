/*
  Name: zdlg_rakshasa
  Author: Mithreas
  Date: 2013 ish
  Description: Rakshasa shapeshifter ability. 

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "gs_inc_pc"
#include "mi_log"
#include "zdlg_include_i"
//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------

const string SHAPES              = "rakshasa_shapes";

void Init()
{
  // This method is called once, at the start of the conversation.
  if (GetElementCount(SHAPES) == 0)
  {
    AddStringElement("Dwarf", SHAPES);
    AddStringElement("Elf", SHAPES);
    AddStringElement("Gnome", SHAPES);
    AddStringElement("Halfling", SHAPES);
    AddStringElement("Half-Elf", SHAPES);
    AddStringElement("Half-Orc", SHAPES);
    AddStringElement("Human", SHAPES);
    AddStringElement("Goblin", SHAPES);
    AddStringElement("Kobold", SHAPES);
    AddStringElement("Gnoll", SHAPES);
    AddStringElement("Rakshasa", SHAPES);
    AddStringElement("<cþ  >[Cancel]</c>", SHAPES);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  object oPC   = GetPcDlgSpeaker();

  SetDlgPrompt("Pick the shape you want to change into when you next use -polymorph.  \n\n" +
               "Using -polymorph again without using this ability will toggle you between your most recent shapes.");
  SetDlgResponseList(SHAPES, OBJECT_SELF);
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection    = GetDlgSelection();
  object oPC       = GetPcDlgSpeaker();
 
  int shape = 0;
  
  switch (selection)
  {
    case 0:  // Dwarf
    case 1:  // Elf
    case 2:  // Gnome
    case 3:  // Halfling
    case 4:  // Half-elf
    case 5:  // Half-orc
    case 6:  // Human
	  shape = selection;
	  break;
	case 7: // goblin
	  shape = 84;
	  break;
	case 8: // kobold
	  shape = 300;
	  break;
	case 9: // gnoll
	  shape = 389;
	  break;
	case 10: // rakshasa
	  shape = GetGender(oPC) ? 290 : 293 ;
	  break;	  
  }

  SetLocalInt(gsPCGetCreatureHide(oPC), "MI_SHAPE", shape + 1);   // Offset by 1 because Dwarf = 0.
	
  EndDlg();
}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
