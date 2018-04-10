/*
  Name: zdlg_subrace
  Author: Mithreas, converted to Z-Dialog from Gigaschatten's legacy convo.
  Date: 8 June 2007
  Description: Subrace selection conversation script. Uses Z-Dialog.

  Z-Dialog methods:
    AddStringElement - used to build up replies as a list.
    SetDlgPrompt - sets the NPC text to use
    SetDlgResponseList - sets the responses up
    S/GetDlgPageString - gets the current page
    GetPcDlgSpeaker = GetPCSpeaker
    GetDlgSelection - gets user selection (index of the response list)
*/
#include "gs_inc_pc"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "mi_inc_spells"
#include "zdlg_include_i"
#include "__server_config"

//------------------------------------------------------------------------------
// Set up some constants to use for list and variable names.
//------------------------------------------------------------------------------
const string OPTIONS = "YOINK_OPTIONS";

//------------------------------------------------------------------------------
// Private utility methods.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// end utility methods - everything below here is part of the conversation.
//------------------------------------------------------------------------------

void Init()
{
  // This method is called once, at the start of the conversation.

  // Options for confirming or cancelling. These are static so we can set them
  // up once.
  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement("<c þ >[Yes]</c>", OPTIONS);
    AddStringElement("<cþ  >[No]</c>", OPTIONS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oYoinker = GetLocalObject(oPC, "MI_YOINKER");

  if (sPage == "")
  {
    SetDlgPrompt(GetName(oYoinker) + " is trying to summon you.  All you have to do is will it, and you will be taken to them."  
									+ "You have 1 Minute to decide. Accept?");
    SetDlgResponseList(OPTIONS, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  object oYoinker = GetLocalObject(oPC, "MI_YOINKER");

  if (sPage == "")
  {
    if (selection)
    {
      SendMessageToPC(oYoinker, GetName(oPC) + " resisted your summons.");
    }
    else
    {
      if (GetLocalObject(oYoinker, "YOINK_TARGET") == oPC) {
        miSPHasCastSpell(oYoinker, CUSTOM_SPELL_YOINK);

        AssignCommand(oPC, ClearAllActions());
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                              EffectVisualEffect(VFX_FNF_SUMMON_GATE),
                              GetLocation(oPC));
        AssignCommand(oPC, ActionJumpToObject(oYoinker));
        AssignCommand(oYoinker, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              EffectVisualEffect(VFX_FNF_SUMMON_GATE),
                              oYoinker));
        // added by miesny_jez - reduce piety/components only on succes Yoink
        if ((GetLevelByClass(CLASS_TYPE_CLERIC, oYoinker) >= 17 ||
               GetLevelByClass(CLASS_TYPE_DRUID, oYoinker) >= 17))   	
		{
			gsWOAdjustPiety(oYoinker, -5.0f, FALSE);	
		}
        else
        {
        	gsSPReduceCharges(oYoinker, 5);
		}
		DeleteLocalObject(oYoinker, "YOINK_TARGET");
      }
      else {
        SendMessageToPC(oPC, "You try to accept the summon, but the magic fizzles. It seems you are no longer being concentrated on.");      
      }
    }
    DeleteLocalObject(oPC, "MI_YOINKER");
    DeleteLocalInt(oYoinker, "YOINKING");
    EndDlg();
  }
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
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
