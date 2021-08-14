/*
zz_co_sacrifice

Gigaschatten's Deity Selection Conversation (gs_wo_sacrifice) converted to
ZZ-Dialog by Mithreas, and substantially expanded in function.

Conversation map:
Page 1: Option list (sacrifice, pray, hold ceremony, consecrate, desecrate)
Page 2: sacrifice page - select gold amount and see presence impact
Page 3: Confirmation page for consecration/desecration

Prayer and ceremonies leave the dialog up, but don't have a different page.
The character starts emoting.

This uses the library inc_worship. It's not so much a library as a text dump
since it is where all the deities and their respective portfolios are stored. It
also serves as a wrapper for all the libraries required for this script.
*/
#include "zzdlg_main_inc"
#include "inc_activity"
#include "inc_favsoul"
#include "inc_shapechanger"
#include "inc_spell"
#include "inc_worship"

const string MM_RESPONSES  = "ZZS_MM_RESPONSES";
const string SAC_RESPONSES = "ZZS_SAC_RESPONSES";
const string CFM_RESPONSES = "ZZS_CFM_RESPONSES";

const string PAGE_MAIN_MENU = "ZZS_PAGE_MENU";
const string PAGE_SACRIFICE = "ZZS_PAGE_SACRIFICE";
const string PAGE_CONFIRM   = "ZZS_PAGE_CONFIRM";

float _GetAdjustedPiety(object oPC, int nADeity)
{
  float fPiety = 0.1;
  if (nADeity == GS_WO_NONE) return fPiety;

  int nPDeity = gsWOGetDeityByName(GetDeity(oPC));

  if (nADeity == nPDeity) fPiety = 0.4;
  else
  {
    if (gsWOGetAspect(nPDeity) == gsWOGetAspect(nADeity)) fPiety += 0.1;
    if (gsWOGetRacialType(nADeity) == gsWOGetRacialType(nPDeity)) fPiety += 0.1;
  }

  return fPiety;
}

// During a ritual:
// - The cleric gets the combined piety scores that the flock members would usually gets
// - The flock get the cleric's piety rating as a bonus
// - Anemoi change, the cleric gets the 1 HP from each flock member added to their HP pool. 
void _DoPrayer (object oPC, object oAltar, object oCleric)
{
  // Locations.
  if (GetLocalInt(oPC, "PRAYING") &&
      GetLocalLocation(oPC, "P_LOC") == GetLocation(oPC) &&
      GetLocalInt(oPC, "GS_ACTIVE"))
  {
    SendMessageToPC(oPC, "You are praying.");
  }
  else if (GetLocalInt(oPC, "PRAYING"))
  {
    SendMessageToPC(oPC, "You have stopped praying.");
    DeleteLocalInt(oPC, "PRAYING");
    DeleteLocalLocation(oPC, "P_LOC");
    return;
  }
  else
  {
    // Start praying.
    SendMessageToPC(oPC, "You have started praying.");
	ClearActivities(oPC);
    SetLocalInt(oPC, "PRAYING", TRUE);
    AssignCommand(oPC, SetFacingPoint(GetPosition(oAltar)));
    AssignCommand(oPC, SetLocalLocation(oPC, "P_LOC", GetLocation(oPC)));
    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
  }

  int nADeity = gsWOGetConsecratedDeity(oAltar);
  if (gsWOGetIsDesecrated(oAltar)) nADeity = GS_WO_NONE;

  float fPiety = _GetAdjustedPiety(oPC, nADeity);
  int nNth;
  int nCount = 0;
  object oFlock;

  if (GetIsObjectValid(oCleric) && oCleric != oPC) 
  {
    // Give the cleric their due.
    gsWOAdjustPiety(oCleric, fPiety);
    gsSTAdjustHPPool(oCleric, 1);
	
    fPiety += _GetAdjustedPiety(oCleric, nADeity);
  }
  
  gsWOAdjustPiety(oPC, fPiety);
  gsSTDoCasterDamage(oPC, 1);

  // If worshiping at an altar consecrated to our deity, restore a spell slot.
  if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && gsWOGetDeityByName(GetDeity(oPC)) == nADeity)
  {
    int nMaxLevel = (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) + 1 / 2);
	int nLevel = GetLocalInt(oPC, "GS_WO_LAST_SPELL_LEVEL_RESTORED") + 1;
	if (nLevel > nMaxLevel) nLevel = 0;
	
    ar_RestoreSpell(oPC, nLevel, CLASS_TYPE_CLERIC);
	SetLocalInt(oPC, "GS_WO_LAST_SPELL_LEVEL_RESTORED", nLevel);
  }
  
  // dunshine: check for corpses nearby (only on permanent altars)
  if (GetStringLeft(GetTag(oAltar),5) != "GS_FX") {
    string sCorpse;
    object oCorpse;
    nNth = 1;
    oFlock = GetNearestObjectByTag("GS_PLACEABLE", oAltar, nNth);

    while (GetIsObjectValid(oFlock) && GetDistanceBetween(oFlock, oAltar) <= 20.0f) {

      // corpse?
      sCorpse = GetLocalString(oFlock, "GS_TARGET");

      if (sCorpse != "") {
        oCorpse = gsPCGetPlayerByID(sCorpse);

        // player still around?
        if (oCorpse != OBJECT_INVALID) {
          // 25% chance on a raise each prayround
          if (d4(1) == 1) {
            SetLocalInt(oFlock, "GVD_ALTAR_RAISE", 1);
            SetLocalObject(oFlock, "GVD_ALTAR_USER", oPC);
            ExecuteScript("gs_pc_spell", oFlock);
          }

        }

      }

      nNth++;
      oFlock = GetNearestObjectByTag("GS_PLACEABLE", OBJECT_SELF, nNth);
    }

  }

  AssignCommand(oPC, DelayCommand(6.0f, _DoPrayer(oPC, oAltar, oCleric)));
}

void _DoRitual (object oCleric, object oAltar)
{
    // Get all members of flock nearby.
    int nNth = 1;
    object oFlock = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCleric, nNth);

    while (GetIsObjectValid(oFlock) &&
           GetDistanceBetween(oFlock, oCleric) <= 20.0f)
    {
       if (LineOfSightObject(oCleric, oFlock))
       {
	      SetLocalInt(oFlock, "GS_ACTIVE", TRUE);
          if (!GetLocalInt(oFlock, "PRAYING")) AssignCommand(oFlock,  _DoPrayer(oFlock, oAltar, oCleric));
       }

       nNth++;
       oFlock = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oCleric, nNth);
    }

	SetLocalInt(oCleric, "GS_ACTIVE", TRUE);
    // AssignCommand(oCleric,  _DoPrayer(oCleric, oAltar, oCleric));
}

// Cleanup function
void Cleanup();

void OnInit()
{
    dlgClearResponseList(SAC_RESPONSES);
    dlgClearResponseList(CFM_RESPONSES);

    dlgAddResponseTalk(SAC_RESPONSES, "[Pay 100 gold]", txtLime);
    dlgAddResponseTalk(SAC_RESPONSES, "[Pay 500 gold]", txtLime);
    dlgAddResponseTalk(SAC_RESPONSES, "[Pay 1000 gold]", txtLime);
    dlgAddResponseTalk(SAC_RESPONSES, "[Pay 5000 gold]", txtLime);
    dlgAddResponseTalk(SAC_RESPONSES, "[Pay 10000 gold]", txtLime);

    dlgAddResponseTalk(CFM_RESPONSES, "[Yes]", txtLime);

    gsWOSetup();
    dlgChangePage(PAGE_MAIN_MENU);
}
void OnPageInit(string sPage)
{
    object oSpeaker = dlgGetSpeakingPC();
    dlgDeactivateEndResponse();

    if (sPage == PAGE_MAIN_MENU)
    {
      dlgClearResponseList(MM_RESPONSES);
      dlgAddResponseTalk(MM_RESPONSES, "[Sacrifice]", txtLime);
      dlgAddResponseTalk(MM_RESPONSES, "[Pray]", txtLime);
	  
      //gift of holy now has full altar access.  On Anemoi, shapechangers, wizards and sorcerers do as well.
      if (gsCMGetHasClass(CLASS_TYPE_CLERIC, oSpeaker) || 
	      gsCMGetHasClass(CLASS_TYPE_FAVOURED_SOUL, oSpeaker) || 
	      gsCMGetHasClass(CLASS_TYPE_WIZARD, oSpeaker) || 
		  gsCMGetHasClass(CLASS_TYPE_SORCERER, oSpeaker) || 
		  gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SHAPECHANGER ||
	      GetLocalInt(gsPCGetCreatureHide(oSpeaker), "GIFT_OF_HOLY"))
      {
        int nConsecrate = (gsWOGetConsecratedDeity(OBJECT_SELF) == GS_WO_NONE ||
                           gsWOGetIsDesecrated(OBJECT_SELF));
        if (nConsecrate) dlgAddResponseTalk(MM_RESPONSES, "[Consecrate Altar]", txtLime);
        else dlgAddResponseTalk(MM_RESPONSES, "[Desecrate Altar]", txtLime);

        dlgAddResponseTalk(MM_RESPONSES, "[Hold Ceremony]", txtLime);
      }

      string sServing = GetDeity(oSpeaker);
      if (sServing == "") sServing = GS_T_16777332;
      string sPrompt = "You are serving "+sServing+". Your Piety is currently " + FloatToString(gsWOGetPiety(oSpeaker), 3, 1) + "%.";
      if (gsWOGetConsecratedDeity(OBJECT_SELF) != GS_WO_NONE &&
          gsWOGetConsecratedDeity(OBJECT_SELF) == gsWOGetDeityByName(sServing))
      {
        sPrompt += "\n\nAltar consecrated to: " + gsWOGetNameByDeity(gsWOGetConsecratedDeity(OBJECT_SELF));

        if (gsWOGetIsDesecrated(OBJECT_SELF)) sPrompt += txtRed + "\n\nAltar is desecrated!";
      }
      else if (gsWOGetConsecratedDeity(OBJECT_SELF) != GS_WO_NONE)
      {
        sPrompt += "\n\nAltar consecrated to another god.";
        if (gsWOGetIsDesecrated(OBJECT_SELF)) sPrompt += txtRed + "\n\nAltar is desecrated!";
      }

      dlgSetPrompt(sPrompt);
      dlgSetActiveResponseList(MM_RESPONSES);
      dlgActivateResetResponse("[Done]", txtRed);
    }
    else if (sPage == PAGE_SACRIFICE)
    {
      dlgSetPrompt("How much do you wish to sacrifice?  \n\nYou can raise your Piety to a maximum of 80% through sacrifice."
      + "\n\nYour piety is currently: " + FloatToString(gsWOGetPiety(oSpeaker), 3, 1) + "%.");
      dlgSetActiveResponseList(SAC_RESPONSES);
      dlgActivateResetResponse("[Back]", txtLime);
    }
    else if (sPage == PAGE_CONFIRM)
    {
      dlgSetPrompt("Are you sure?  You cannot undo this once done.");
      dlgSetActiveResponseList(CFM_RESPONSES);
      dlgActivateResetResponse("[No]", txtRed);
    }
}
void OnSelection(string sPage)
{
    object oSpeaker = dlgGetSpeakingPC();
    int nSelection  = dlgGetSelectionIndex();
    object oAltar   = OBJECT_SELF;

    if (sPage == PAGE_MAIN_MENU)
    {
       switch (nSelection)
       {
         case 0:  // Sacrifice
           dlgChangePage(PAGE_SACRIFICE);
           break;
         case 1:  // Pray
            SetLocalInt(oSpeaker, "GS_ACTIVE", TRUE);		 
            if (!GetLocalInt(oSpeaker, "PRAYING")) _DoPrayer(oSpeaker, oAltar, OBJECT_INVALID);
            dlgEndDialog();
            break;
         case 2:  // Consecrate/Desecrate
            dlgChangePage(PAGE_CONFIRM);
            break;
         case 3:  // Ritual
           if (!GetLocalInt(oSpeaker, "PRAYING")) _DoRitual(oSpeaker, oAltar);
           dlgEndDialog();
           break;
       }
    }
    else if (sPage == PAGE_SACRIFICE)
    {
       int nAmount = 100;

       switch (nSelection)
       {
         case 0:  // 100
           nAmount = 100;
           break;
         case 1:  // 500
           nAmount = 500;
           break;
         case 2:  // 1000
           nAmount = 1000;
           break;
         case 3:  // 5000
           nAmount = 5000;
           break;
         case 4:  // 10000
           nAmount = 10000;
           break;
       }

       int nPiety = FloatToInt(gsWOGetPiety(oSpeaker));
       if (nAmount/100 + nPiety > 80)
       {
         nAmount = (80 - nPiety) * 100;
         if (nAmount < 0) nAmount = 0;
       }

       if (nAmount > GetGold(oSpeaker))
       {
         SendMessageToPC(oSpeaker, "You don't have enough gold!");
       }
       else
       {
         TakeGoldFromCreature(nAmount, oSpeaker, TRUE);
         gsWOAdjustPiety(oSpeaker, IntToFloat(nAmount/100));
       }
    }
    else if (sPage == PAGE_CONFIRM)
    {
      int nConsecrate = (gsWOGetConsecratedDeity(oAltar) == GS_WO_NONE ||
                         gsWOGetIsDesecrated(oAltar));

      if (nConsecrate)
      {
        if (gsWOConsecrate(oSpeaker, oAltar))
		{
			// Shapechangers get bonus XP.
			if (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SHAPECHANGER &&
				gsWOGetCategory(gsWOGetDeityByName(GetDeity(oSpeaker))) == FB_WO_CATEGORY_BEAST_CULTS)
			{ 
			   object oHide = gsPCGetCreatureHide(oSpeaker);
			   int nTimeout = GetLocalInt(oHide, "SPC_TIMEOUT");
			   if (nTimeout > gsTIGetActualTimestamp()) return;
			   
			   gsXPGiveExperience(oSpeaker, 250);
			   
			   SetLocalInt(oHide, "SPC_TIMEOUT", gsTIGetActualTimestamp() + 60*60*20);  
			}
		}
      }
      else
      {
         gsWODesecrate(oSpeaker, oAltar);
      }

      dlgChangePage(PAGE_MAIN_MENU);
    }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
    if (sPage == PAGE_MAIN_MENU)
    {
      dlgEndDialog();
      return;
    }

    dlgChangePage(PAGE_MAIN_MENU);
}
void OnAbort(string sPage)
{
    Cleanup();
}
void OnEnd(string sPage)
{
    Cleanup();
}
void main()
{
    dlgOnMessage();
}
void Cleanup()
{

}
