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
const string TAILS       = "cust_tails";
const string FORMS       = "cust_forms";

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
  object oSpeaker = GetPcDlgSpeaker();
  // Main menu options.
  DeleteList(MAIN_MENU);

  AddStringElement("Change Head",  MAIN_MENU);	
	
  if (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SHAPECHANGER &&
	  GetLocalInt(gsPCGetCreatureHide(oSpeaker), VAR_CURRENT_FORM) == 1 && 
      GetLocalInt(GetArea(oSpeaker), "MI_RENAME"))
  {
	AddStringElement("VFX Ears", MAIN_MENU);
	AddStringElement("Tail", MAIN_MENU);
	AddStringElement("Animal Form", MAIN_MENU);
	AddStringElement("Toggle beast legs", MAIN_MENU);
	AddStringElement("Toggle beast claws", MAIN_MENU);
	AddStringElement("Toggle phenotype", MAIN_MENU);
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
  
  if (GetElementCount(TAILS) == 0)
  {
    AddStringElement("Whip", TAILS);
    AddStringElement("Cat", TAILS);
    AddStringElement("Fox (Palette)", TAILS);
    AddStringElement("Jaguar", TAILS);
    AddStringElement("Leopard", TAILS);
    AddStringElement("Snow Leopard", TAILS);
    AddStringElement("Tiger", TAILS);
    AddStringElement("White Tiger", TAILS);
    AddStringElement("Wolf", TAILS);
	AddStringElement("No tail", TAILS);
	AddStringElement("Back to menu", TAILS);
  }
  
  if (GetElementCount(FORMS) == 0)
  {
    AddStringElement("Cougar", FORMS);
    AddStringElement("Crag Cat", FORMS);
    AddStringElement("Tiger", FORMS);
    AddStringElement("Jaguar", FORMS);
    AddStringElement("Leopard", FORMS);
    AddStringElement("Lioness", FORMS);
    AddStringElement("Panther", FORMS);
    AddStringElement("Blink Dog", FORMS);
    AddStringElement("Dire Wolf", FORMS);
    AddStringElement("Dog", FORMS);
    AddStringElement("Fenhound", FORMS);
    AddStringElement("Shadow Mastiff", FORMS);
    AddStringElement("Wolf", FORMS);
    AddStringElement("Winter Wolf", FORMS);
    AddStringElement("Worg", FORMS);
    AddStringElement("Fox", FORMS);
    AddStringElement("Fennec", FORMS);
    AddStringElement("Lion", FORMS);
    AddStringElement("Snow Leopard", FORMS);
	AddStringElement("Back to menu", FORMS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (GetAppearanceType(oPC) > 7 && GetAppearanceType(oPC) != 2081 && GetAppearanceType(oPC) != 2082 && GetAppearanceType(oPC) != 2083)
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
  else if (sPage == TAILS)
  {
    SetDlgPrompt("Pick the tail to use for your hybrid form.");
	SetDlgResponseList(TAILS);
  }
  else if (sPage == FORMS)
  {
    SetDlgPrompt("Pick the animal form you wish to use.");
	SetDlgResponseList(FORMS);
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
  
  if (GetAppearanceType(oPC) > 7  && GetAppearanceType(oPC) != 2081 && GetAppearanceType(oPC) != 2082 && GetAppearanceType(oPC) != 2083)
  {
    EndDlg();
  }  
  else if (sPage == "")
  {
    switch (selection)
    {	
	  case 0:
	    SetDlgPageString(HEADS);
        break;	
      case 1:
	    SetDlgPageString(VFX_EARS);
        break;	
	  case 2: 
	    SetDlgPageString(TAILS);
		break;
	  case 3:
	    SetDlgPageString(FORMS);
		break;
	  case 4: // Toggle beast legs
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
	  case 5: // Toggle beast claws.
	    if (GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oPC) == 216)
		{
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 1, oPC));
		  SetLocalInt(oHide, VAR_HYBRID_CLAWS, TRUE);
		}
		else
		{
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 216, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 216, oPC));
		  SetLocalInt(oHide, VAR_HYBRID_CLAWS, FALSE);
		}
		break;
	  case 6: // Toggle phenotype
	    if (GetAppearanceType(oPC) == 3 || GetAppearanceType(oPC) == 2082) 
		{
		  SetCreatureAppearanceType(oPC, 2083);
		  DelayCommand(0.2f, gsPCRefreshCreatureScale(oPC));
		}
		else 
		{
		  SetCreatureAppearanceType(oPC, 2082);
		  DelayCommand(0.2f, gsPCRefreshCreatureScale(oPC));
		}
		SetLocalInt(oHide, VAR_HYBRID_FORM, GetAppearanceType(oPC));
		break;
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
	int bHybrid = (GetLocalInt(gsPCGetCreatureHide(oPC), VAR_CURRENT_FORM) == 1);
	
	int bGender = GetGender(oPC);
	int nLimit; 
	switch (GetAppearanceType(oPC))
	{
	  case 1: // elf
	    nLimit = (bGender ? EFHEADMAX : EMHEADMAX);
		break;
	  case 5: // halforc
	    nLimit = (bGender ? OFHEADMAX : OMHEADMAX);
		break;
	  case 6: // human
	    nLimit = (bGender ? HFHEADMAX : HMHEADMAX);
		break;
	  default: // other, mainly halfling
	    nLimit = (bGender ? AFHEADMAX : AMHEADMAX);
		break;
	}
  
    switch (selection)
	{
	  // @@@ Note - this code will need updating if we add lots more head appearances.
	  case 0: // next
        nHead = GetCreatureBodyPart(CREATURE_PART_HEAD)+1;
		if (nHead > nLimit) nHead = 0;
        SetCreatureBodyPart(CREATURE_PART_HEAD, nHead, oPC);
		if (bHybrid) SetLocalInt(oHide, VAR_HYBRID_HEAD, nHead);
		break;
	  case 1: // previous
        nHead = GetCreatureBodyPart(CREATURE_PART_HEAD)-1;
		if (nHead < 0) nHead = nLimit;
        SetCreatureBodyPart(CREATURE_PART_HEAD, nHead, oPC);
		if (bHybrid) SetLocalInt(oHide, VAR_HYBRID_HEAD, nHead);
		break;
	  case 2: // back
	    SetDlgPageString("");
        break;		
	}
  }  
  else if (sPage == TAILS)
  {
    switch (selection)
	{
		case 0:
		  SetCreatureTailType(622);
		  break;
		case 1:
		  SetCreatureTailType(625);
		  break;
		case 2:
		  SetCreatureTailType(626);
		  break;
		case 3:
		  SetCreatureTailType(627);
		  break;
		case 4:
		  SetCreatureTailType(628);
		  break;
		case 5:
		  SetCreatureTailType(629);
		  break;
		case 6:
		  SetCreatureTailType(630);
		  break;
		case 7:
		  SetCreatureTailType(631);
		  break;
		case 8:
		  SetCreatureTailType(632);
		  break;
		case 9:
		  SetCreatureTailType(14);
		  break;
		case 10:
		  SetDlgPageString("");
		  break;
	}
	
    SetLocalInt(oHide, VAR_HYBRID_TAIL, GetCreatureTailType());
  }
  else if (sPage == FORMS)
  {
    switch (selection)
	{
		case 0:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 366);
		  break;
		case 1:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 367);
		  break;
		case 2:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 368);
		  break;
		case 3:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 369);
		  break;
		case 4:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 371);
		  break;
		case 5:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 372);
		  break;
		case 6:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 373);
		  break;
		case 7:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 386);
		  break;
		case 8:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 387);
		  break;
		case 9:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 388);
		  break;
		case 10:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 389);
		  break;
		case 11:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 391);
		  break;
		case 12:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 392);
		  break;
		case 13:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 393);
		  break;
		case 14:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 394);
		  break;
		case 15:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 491);
		  break;
		case 16:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 492);
		  break;
		case 17:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 493);
		  break;
		case 18:
		  SetLocalInt(oHide, VAR_ANIMAL_FORM, 494);
		  break;
		case 19:
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
