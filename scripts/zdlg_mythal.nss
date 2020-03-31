/*
  Name: zdlg_bat
  Author: Mithreas
  Date: Apr 30 2006
  Description: Bat bounty conversation script. Uses Z-Dialog.

*/
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string END = "end";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("[Leave]", MAIN_MENU);
  
  if (GetRacialType(GetPcDlgSpeaker()) == RACIAL_TYPE_ELF ||
      GetIsObjectValid(GetItemPossessedBy(GetPcDlgSpeaker(), "elf_safe_passage"))) 
  {
    AddStringElement("[Pass the Mythal]", MAIN_MENU);
  }  
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("[The hum of the mythal surrounds you, the air thickening as it tests you]");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:
        // End conv
        {
          EndDlg();
          break;
        }
      case 1:
        // Enter
        {
		  EndDlg();
          AssignCommand(oPC, ActionJumpToObject(GetObjectByTag("WP_meo_mew")));
          break;
        }
    }
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void main()
{
  int nEvent = GetDlgEventType();
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
