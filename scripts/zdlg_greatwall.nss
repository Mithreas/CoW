/*

*/
#include "inc_disguise"
#include "inc_xp"
#include "inc_zdlg"
#include "nw_i0_generic"

const string MAIN_MENU   = "gwg_main_options";
const string PAGE_2 = "page_2";
const string PAGE_3 = "page_3";
const string END = "end";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  AddStringElement("[Leave]", MAIN_MENU);
  
  if (GetRacialType(GetPcDlgSpeaker()) == RACIAL_TYPE_HUMAN ||
      GetRacialType(GetPcDlgSpeaker()) == RACIAL_TYPE_HALFLING)
  {
    AddStringElement("Returning from patrol!", MAIN_MENU);
  }
  else if (GetRacialType(GetPcDlgSpeaker()) == RACIAL_TYPE_HALFELF ||
		   GetRacialType(GetPcDlgSpeaker()) == 21) // Elfling
  {
	if (GetIsPCDisguised(GetPcDlgSpeaker())) AddStringElement(StringToRGBString("[Bluff/Perform]", STRING_COLOR_GREEN) + " Returning from patrol!", MAIN_MENU);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    if (gsTIGetActualTimestamp() < GetLocalInt(oPC, "WALL_TIMEOUT"))
	{
	  SendMessageToPC(oPC, "You'll need to wait some time before you can try to fool the guards again.");
	  EndDlg();
	}
	else
	{
      SetDlgPrompt("[A challenge is called out by the sentries] Declare yourself!");
      SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
	}
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
		  int bPass = TRUE;
		  
		  if (GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
			  GetRacialType(oPC) == 21) // Elfling
		  {
		    if (SeeThroughDisguise(oPC, GetObjectByTag("gww_caravis"), 1, "The guards look at you closely..."))
			{
			  // Ouch.
			  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(4), DAMAGE_TYPE_PIERCING), oPC);
			  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ARROW_IN_CHEST_LEFT), oPC, 6.0f);
			  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ARROW_IN_CHEST_RIGHT), oPC, 6.0f);
			  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ARROW_IN_FACE), oPC, 6.0f);
			  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM));	

			  SetLocalInt(oPC, "WALL_TIMEOUT", gsTIGetActualTimestamp() + 1800);
			  
			  bPass = FALSE;
			}
		  }
		  
		  EndDlg();
          if (bPass) AssignCommand(oPC, ActionJumpToObject(GetObjectByTag("gwww_ToWasteland")));
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
