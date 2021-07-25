/*
  Name: zdlg_customise
  Author: Mithreas
  Date: May 8 2021
  Description: PC customise appearance.  Initially intended for shapechangers.

*/
#include "btlr__inc"
#include "inc_shapechanger"
#include "inc_zdlg"

const string MAIN_MENU   = "cust_main_options";
const string VFX_EARS    = "cust_vfx_ears";
const string HEADS       = "cust_heads";

// VFX utility functions.  The numbers are indices into (Anemoi's custom) visualeffects.2da. 
int _GetNextVFX()
{
  object oPC = GetPcDlgSpeaker();
  int nCurrentVFX = GetLocalInt(oPC, "CURR_VFX");  
  int nVFX;
  
  switch (nCurrentVFX)
  {
    case 0:
	  nVFX = 673;
	  SetLocalInt(oPC, "CURR_VFX", 1);
	  break;
	case 1:
	  nVFX = 675;
	  SetLocalInt(oPC, "CURR_VFX", 2);
	  break;
	case 2:
	  nVFX = 677;
	  SetLocalInt(oPC, "CURR_VFX", 3);
	  break;
	case 3:
	  nVFX = 679;
	  SetLocalInt(oPC, "CURR_VFX", 4);
	  break;
	case 4:
	  nVFX = 0;
	  SetLocalInt(oPC, "CURR_VFX", 0);
	  break;
  }
  
  if (nVFX && GetGender(oPC) == GENDER_MALE) nVFX += 1;
  return nVFX;
}

int _GetPrevVFX()
{
  object oPC = GetPcDlgSpeaker();
  int nCurrentVFX = GetLocalInt(oPC, "CURR_VFX");
  int  nVFX;
  
  switch (nCurrentVFX)
  {
    case 0:
	  nVFX = 679;
	  SetLocalInt(oPC, "CURR_VFX", 4);
	  break;
	case 1:
	  nVFX = 0;
	  SetLocalInt(oPC, "CURR_VFX", 0);
	  break;
	case 2:
	  nVFX = 673;
	  SetLocalInt(oPC, "CURR_VFX", 1);
	  break;
	case 3: 
	  nVFX = 675;
	  SetLocalInt(oPC, "CURR_VFX", 2);
	  break;
	case 4:
	  nVFX = 677;
	  SetLocalInt(oPC, "CURR_VFX", 3);
	  break;
  }
  
  if (nVFX && GetGender(oPC) == GENDER_MALE) nVFX += 1;
  return nVFX;
}

void Init()
{
  // Main menu options.
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("VFX Ears", MAIN_MENU);
    AddStringElement("Head",  MAIN_MENU);	
    AddStringElement("Toggle beast legs", MAIN_MENU);
  }

  if (GetElementCount(VFX_EARS) == 0)
  {
    AddStringElement("Next", VFX_EARS);
    AddStringElement("Previous", VFX_EARS);
    AddStringElement("Raise", VFX_EARS);
    AddStringElement("Lower", VFX_EARS);
	AddStringElement("Back to menu", VFX_EARS);
  }
  
  if (GetElementCount(HEADS) == 0)
  {
    AddStringElement("Next", HEADS);
    AddStringElement("Previous", HEADS);
	AddStringElement("Back to menu", HEADS);
  }  
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (GetAppearanceType(oPC) > 7)
  {
    SetDlgPrompt("Sorry, you cannot customise this hybrid form.  Only 'parts based' models can be customised.");	
  }  
  else if (sPage == "")
  {
    SetDlgPrompt("Hybrid form customisation menu.  You can change some aspects of your hybrid form; " +
	             "changes made will be saved so that they will be used each time you shift.");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == VFX_EARS)
  {
    SetDlgPrompt("Cycle through available ear models, and raise or lower their position to make them fit snugly " + 
	             "to your head model.");
	SetDlgResponseList(VFX_EARS);
  }
  else if (sPage == HEADS)
  {
    SetDlgPrompt("Cycle through possible head appearances for your hybrid form.");
	SetDlgResponseList(HEADS);
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
  int selection  = GetDlgSelection(); // 0/1/2
  object oPC     = GetPcDlgSpeaker();
  object oHide   = gsPCGetCreatureHide(oPC);
  string sPage   = GetDlgPageString();
  
  if (GetAppearanceType(oPC) > 7)
  {
    EndDlg();
  }  
  else if (sPage == "")
  {
    switch (selection)
    {
      case 0:
	    SetDlgPageString(VFX_EARS);
        break;		
	  case 1:
	    SetDlgPageString(HEADS);
        break;	
	  case 2: // Toggle beast legs
	  {
		if (GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPC) == 213)
		{
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 1, oPC));
		  SetLocalInt(oHide, VAR_HYBRID_LEGS, TRUE);
		}
		else
		{
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 213, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 213, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 213, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 213, oPC));
		  SetLocalInt(oHide, VAR_HYBRID_LEGS, FALSE);
		}
	    break;
	  }
	}  
  }
  else if (sPage == VFX_EARS)
  {
    int nEars;
    switch (selection)
	{
	  case 0: // next
	    nEars = _GetNextVFX();
	    SPC_ApplyEarVFX(oPC, nEars);
        SetLocalInt(oHide, VAR_HYBRID_EARS, nEars);
		break;
	  case 1: // previous
	    nEars = _GetPrevVFX();
	    SPC_ApplyEarVFX(oPC, nEars);
        SetLocalInt(oHide, VAR_HYBRID_EARS, nEars);
		break;
	  case 2: // raise
	  {
        float fZ = GetLocalFloat(oHide, VAR_HYBRID_EARZ);
		fZ += 0.01f;
		SetLocalFloat(oHide, VAR_HYBRID_EARZ, fZ);
		
	    SPC_ApplyEarVFX(oPC, GetLocalInt(oHide, VAR_HYBRID_EARS));
	    break;
      }	  
	  case 3: // lower
	  {
        float fZ = GetLocalFloat(oHide, VAR_HYBRID_EARZ);
		fZ -= 0.01f;
		SetLocalFloat(oHide, VAR_HYBRID_EARZ, fZ);
		
	    SPC_ApplyEarVFX(oPC, GetLocalInt(oHide, VAR_HYBRID_EARS));
	    break;
      }	  
	  case 4: // back
	    SetDlgPageString("");
        break;		
	}
  }
  else if (sPage == HEADS)
  {
    int nHead;
  
    switch (selection)
	{
	  // @@@ Note - this code will need updating if we add lots more head appearances.
	  case 0: // next
        nHead = GetCreatureBodyPart(CREATURE_PART_HEAD)+1;
		if (nHead > AFHEADMAX) nHead = 0;
        SetCreatureBodyPart(CREATURE_PART_HEAD, nHead, oPC);
		SetLocalInt(oHide, VAR_HYBRID_HEAD, nHead);
		break;
	  case 1: // previous
        nHead = GetCreatureBodyPart(CREATURE_PART_HEAD)-1;
		if (nHead < 0) nHead = AFHEADMAX;
        SetCreatureBodyPart(CREATURE_PART_HEAD, nHead, oPC);
		SetLocalInt(oHide, VAR_HYBRID_HEAD, nHead);
		break;
	  case 2: // back
	    SetDlgPageString("");
        break;		
	}
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
