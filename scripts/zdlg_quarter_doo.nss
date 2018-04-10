/*
  Name: zdlg_quarter_doo
  Author: Mithreas
  Date: 13 September 2008
  Description: Quarter door script. Uses Z-Dialog.

  - try and pick lock
  - try and bash door open
  - try and disable trap (if spotted)
  - knock

*/
#include "gs_inc_quarter"
#include "zdlg_include_i"

//::///////////////////////////////////////////////
//:: DoTrapSpike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a spike trap. Reflex save allowed.
    Copied from x0_i0_spells to save a large include.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// apply effects of spike trap on entering object
void DoTrapSpike(int nDamage, int nDC = 15)
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    int nRealDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP, OBJECT_SELF);
    if (nDamage > 0)
    {
        effect eDam = EffectDamage(nRealDamage, DAMAGE_TYPE_PIERCING);
        effect eVis = EffectVisualEffect(253);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}

const string MAIN_MENU = "main_menu";

void Init()
{
  Trace(QUARTER, "Initialising quarter door conversation.");
  // This method is called once, at the start of the conversation.
  object oPC = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  DeleteList(MAIN_MENU);
  AddStringElement("<cþ  >[Leave]</c>", MAIN_MENU);
  AddStringElement("<c þ >[Pick Lock]</c>", MAIN_MENU);
  AddStringElement("<c þ >[Bash Door]</c>", MAIN_MENU);
  AddStringElement("<c þ >[Knock on Door]</c>", MAIN_MENU);

  if(gsQUGetTrapStrength(oQuarter))
  {
    int nTrapDC = gsQUGetTrapDC(oQuarter);
    int nSearch = GetSkillRank(SKILL_SEARCH, oPC, FALSE);
    if (d20() + nSearch >= nTrapDC)
    {
      AddStringElement("<c þ >[Disable Trap]</c>", MAIN_MENU);
    }
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    SetDlgPrompt("This quarter is currently occupied.  To leave a message for the owner, use a message object on the door.");
    SetDlgResponseList(MAIN_MENU);
  }
}

// addition by Dunshine: function to throw PC out of the bank area when detected
void ThrowPCOut(object oVaultGuard, object oPC) {

  AssignCommand(oVaultGuard, ClearAllActions(TRUE));
  SendMessageToPC(oPC,"One of the Vault Guards saw what you did and forcefully removes you from the Bank and then knocks you down hard.");
  location locBankExit = GetLocation(GetObjectByTag("UDCITYDIST1_BANK"));
  AssignCommand(oPC, ClearAllActions(TRUE));
  AssignCommand(oPC, JumpToLocation(locBankExit));

  effect eDamage = EffectDamage(GetCurrentHitPoints(oPC)-1);
  effect eKnockdown = EffectKnockdown();
  DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
  DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oPC, 10.0f));

}

// addition by Dunshine: Vault Guard check
void CheckVaultGuard(object oPC, int iPickBash) {

  // check if there is a vault guard nearby that spots the picklock or bashing attempt
  // iPickBash = 1 = picklock / remove trap attempt
  // iPickBash = 2 = bash attempt

  // are we in the Bank Vault?
  if (GetTag(GetArea(oPC)) == "udcity_bank1") {
    // yes

    // check if one of the guards sees the attempt
    int iGuard = 1;
    int iSpotted = 0;
    object oVaultGuard;
    float fDirection;
    vector vTarget;
    location lTarget;
    object oObject;

    while ((iGuard < 5) && (iSpotted == 0)) {

      oVaultGuard = GetObjectByTag("UDBankGuard" + IntToString(iGuard));

      // are we checking picking or bashing?
      if (iPickBash == 1) {
        // picking, check if the Guard actually sees the attempt, don't use GetObjectSeen
        if ((GetDistanceBetween(oVaultGuard, oPC) < 40.0) && (GetSkillRank(SKILL_SPOT, oVaultGuard) >= GetSkillRank(SKILL_HIDE, oPC))) {
          // lockpicker is close enough and is spotted by the Guard
          iSpotted = 1;
        }
      } else {
        // bashing, just check if the Guard is close enough to hear the attempt
        if (GetDistanceBetween(oVaultGuard, oPC) < 40.0) {
          // close enough to hear the bashing of a door
          iSpotted = 1;
        }
      }

      // check next guard if this one didn't notice the attempt
      if (iSpotted == 0) {
        iGuard = iGuard + 1;
      }

    }

    // attempt spotted?
    if (iSpotted == 1) {
      // have the guard yell something and run up to the PC burglar
      AssignCommand(oVaultGuard, ClearAllActions(TRUE));
      AssignCommand(oVaultGuard, ActionSpeakString("HEY!!!", TALKVOLUME_SHOUT));
      AssignCommand(oVaultGuard, ActionForceMoveToObject(oPC, TRUE, 1.0f, 5.0f));

      // throw PC out
      DelayCommand(7.0f,ThrowPCOut(oVaultGuard, oPC));
    }

  }

}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:  // Leave
        EndDlg();
        break;
      case 1:  // Pick Lock
      {
        int nTrapStrength = gsQUGetTrapStrength(oQuarter);
        if (nTrapStrength)
        {
          // The door is trapped.  Damage the thief.
          DoTrapSpike(d6(nTrapStrength), gsQUGetTrapDC(oQuarter)/2);
          EndDlg();
          break;
        }

        int nOpenLock = GetSkillRank(SKILL_OPEN_LOCK, oPC, FALSE);
        int nDC = gsQUGetLockDC(oQuarter);
        if (d20() + nOpenLock >= nDC)
        {
          EndDlg();
          gsQUOpen(oQuarter, oPC);
        }
        else
        {
          SendMessageToPC(oPC, "You fail to pick the lock.");
          EndDlg();
        }

        // addition by Dunshine, check if a Vault Guard spots the attempt
        CheckVaultGuard(oPC, 1);

        break;
      }
      case 2:  // Bash Door
      {
        int nTrapStrength = gsQUGetTrapStrength(oQuarter);
        if (nTrapStrength)
        {
          // The door is trapped.  Damage the thief.
          DoTrapSpike(d6(nTrapStrength), gsQUGetTrapDC(oQuarter)/2);
          EndDlg();
          break;
        }

        int nStrength = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nDC = gsQUGetLockStrength(oQuarter);
        if (d20() + nStrength >= nDC)
        {
          EndDlg();
          gsQUOpen(oQuarter, oPC);
        }
        else
        {
          SendMessageToPC(oPC, "You fail to force the door.");
          EndDlg();
        }

        // addition by Dunshine, check if a Vault Guard spots the attempt
        CheckVaultGuard(oPC, 2);

        break;
      }
      case 3: // knock
      {
        AssignCommand(OBJECT_SELF, ActionSpeakString("Knock Knock!"));
        object oTarget = GetTransitionTarget(OBJECT_SELF);

        if (GetIsObjectValid(oTarget))
        {
          AssignCommand(oTarget, ActionSpeakString("Knock Knock!"));

          object oPC = GetFirstObjectInArea(GetArea(oTarget));

          while (GetIsObjectValid(oPC))
          {
            if (GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC))
            {
              FloatingTextStringOnCreature("There is a knocking without!", oPC);
            }

            //::  A Butler can open a door if flagged to do so by the owner
            if ( !GetIsPC(oPC) && FindSubString(GetTag(oPC), "AR_MANSION_SERV") != -1 && GetLocalInt(oPC, "AR_MANOR_AUDIENCE") && GetLocalInt(oTarget, "AR_BUTLER_USEABLE") ) {
                //if (GetCurrentHitPoints(oTarget) > 0) {
                    AssignCommand(oPC, ClearAllActions());
                    AssignCommand(oPC, ActionSpeakString("I'll get the door."));
                    AssignCommand(oPC, ActionMoveToLocation(GetLocation(GetNearestObjectByTag("AR_BUTLER_WP", oPC)), FALSE));

                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, ActionOpenDoor(oTarget));
                    //DelayCommand( 6.0, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)) );
                //}
            }

            oPC = GetNextObjectInArea(GetArea(oTarget));
          }
        }
        break;
      }
      case 4:  // Disable Trap
      {
        int nDisable = GetSkillRank(SKILL_DISABLE_TRAP, oPC, FALSE);
        int nDC = gsQUGetTrapDC(oQuarter);
        if (d20() + nDisable >= nDC)
        {
          gsQUSetTrapStrength(oQuarter, 0);
          RemoveElement(4, MAIN_MENU, OBJECT_SELF);
        }
        else
        {
          SendMessageToPC(oPC, "You fail to disable the trap.");
          EndDlg();
        }

        // addition by Dunshine, check if a Vault Guard spots the attempt
        CheckVaultGuard(oPC, 1);

        break;
      }
    }
  }
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_quarter_door script");
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
