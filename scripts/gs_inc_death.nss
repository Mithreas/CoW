#include "inc_bloodstains"
#include "fb_inc_external"
#include "fb_inc_zombie"
#include "gs_inc_common"
#include "gs_inc_flag"
#include "gs_inc_pc"
#include "gs_inc_portal"
#include "gs_inc_strack"
#include "gs_inc_text"
#include "gs_inc_theft"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "gs_inc_xp"
#include "inc_healer"
#include "inc_spells"
#include "inc_vampire"
#include "inc_factions"
#include "gvd_inc_reward"

const int GS_PENALTY_PER_LEVEL  = 25;

// Original gsDeath function.
void gsDeath();
// Original main function. Moved to a separate function so it can be delayed.
void DoDeath(object oDied);

void DoDeath(object oDied)
{
    //spelltracker
    gsSPTReset(oDied);

    // always turn subdual mode off when someone dies
    DeleteLocalInt(oDied, "GVD_SUBDUAL_MODE");


    if (!GetLocalInt(GetModule(), "ZOMBIE_MODE")) {
      AssignCommand(oDied, gsDeath());
    } else {

      fbZDied(oDied);
      // Remove effects.
      effect eEffect = GetFirstEffect(oDied);
      while (GetIsEffectValid(eEffect))
      {
        RemoveEffect(oDied, eEffect);
        eEffect = GetNextEffect(oDied);
      }
      StopFade(oDied);
      return;
    }
}

void gsDeath()
{
  object oSelf    = OBJECT_SELF;
  int nPVP        = FALSE;
  int nSuicide    = FALSE;
  int nKiller_RPR = FALSE;

  //state
  gsSTSetInitialState(TRUE);

  // Remove effects.
  effect eEffect = GetFirstEffect(oSelf);
  while (GetIsEffectValid(eEffect))
  {
    RemoveEffect(oSelf, eEffect);
    eEffect = GetNextEffect(oSelf);
  }

  object oObject1 = GetLastKiller();

  // if last killer = pc itself, check for a bleed out attack, and grab the killer from a variable instead
  if (oObject1 == oSelf) {
    if (GetLocalObject(oSelf, "GVD_LAST_ATTACKER") != OBJECT_INVALID) {
      // bleed out death, so killer is someone else, use that one
      oObject1 = GetLocalObject(oSelf, "GVD_LAST_ATTACKER");
    }
  }

  // delete last attacker variable now, so it doesn't linger for future deaths
  DeleteLocalObject(oSelf, "GVD_LAST_ATTACKER");

  if (GetObjectType(oObject1) == OBJECT_TYPE_CREATURE)
  {
    object oObject2 = OBJECT_INVALID;

    //get master
    do
    {
        oObject2 = oObject1;
        oObject1 = GetMaster(oObject2);
    }
    while (GetIsObjectValid(oObject1));

    nSuicide        = oObject2 == oSelf;
    nPVP            = GetIsPC(oObject2) && !nSuicide;
    nKiller_RPR     = nPVP ? gsPCGetRolePlay(oObject2) : 0;

    if (! nSuicide)
    {
            if (VampireIsVamp(oSelf) && VampireCanEnterGaseousForm(oSelf))
            {
                VampireEnterGaseousForm(oSelf);
                return;
            }

            if (! nPVP)
            {
                //deity resurrection
                if (gsWOGrantResurrection()) return;
            }
          /*  else
            {
               // Check for war state.
                string sMyNation = GetLocalString(oSelf, VAR_NATION);
                string sTheirNation = GetLocalString(oObject2, VAR_NATION);
                if (miCZGetWar(sTheirNation, sMyNation))
                {
                  // Award bounty.
                  int nBounty = 100 * GetHitDice(oSelf);

                  int nBountyM = 1;
                  if (miCZGetIsLeader(oSelf, sMyNation)) nBountyM = 100;
                  else
                  {
                    nBountyM = md_BountyMultiplier(oSelf, sMyNation);
                  }

                  int nBalance = gsFIGetAccountBalance("N" + sMyNation);
                  nBounty *= nBountyM;

                  if (nBounty > nBalance) nBounty = nBalance;
                  gsFIDraw(oObject2, nBounty, "N" + sMyNation);

                  md_FactionsAtWar(oObject2, oSelf, sMyNation, TRUE);
                }
                else
                    md_FactionsAtWar(oObject2, oSelf, "0", TRUE); //pays out bounties for factions
            }   */

            //reward
            gsXPRewardKill();

            //stolen items
            gsTHReturnStolenItems(oSelf, oObject2);

            //dm notification
            string sPVP;
            if (nPVP) {
              sPVP = " (PVP)";
            } else {
              if (nSuicide) {
                sPVP = " (SUICIDE)";
              } else {
                sPVP = " (PVE)";
              }
            }
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777437,
                    GetName(oSelf),
                    GetName(oObject2) + sPVP));

            WriteTimestampedLogEntry(
                gsCMReplaceString(
                    GS_T_16777437,
                    GetName(oSelf),
                    GetName(oObject2) + sPVP));
    }

    if (nSuicide || ! nPVP)
    {
        //apply penalty
        gsXPApplyDeathPenalty(oSelf, GetHitDice(oSelf) * GS_PENALTY_PER_LEVEL, TRUE);
    }
    

    //drop corpses
    gsPODropAllCorpses(oSelf);

  }

  //teleport
  SetPlotFlag(oSelf, TRUE);
  ApplyResurrection(oSelf);
  object oSave = gsPCGetCreatureHide(oSelf);

  int DeathTotal = GetLocalInt(oSave, "SEP_DEATH_TOTAL");
  if (nPVP) {
    int PvPTotal = GetLocalInt(oSave, "SEP_DEATH_PVP_TOTAL");
    SetLocalInt(oSave, "SEP_DEATH_PVP_TOTAL", ++PvPTotal);
    SetLocalInt(oSave, "SEP_LAST_DEATH_IS_PVP", 1);
  }
  else {
    SetLocalInt(oSave, "SEP_LAST_DEATH_IS_PVP", 0);
  }
  SetLocalInt(oSave, "SEP_DEATH_TOTAL", ++DeathTotal);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() + 10), oSelf);
  ClearAllActions(TRUE);
  ActionJumpToObject(GetObjectByTag("GS_TARGET_DEATH"));
  ActionDoCommand(DelayCommand(6.0, SetPlotFlag(oSelf, FALSE)));
  ActionDoCommand(SetCommandable(TRUE));
  SetCommandable(FALSE);

  //timeout
  SetLocalInt(gsPCGetCreatureHide(oSelf), "GS_DEATH_TIMESTAMP", gsTIGetActualTimestamp());


  //create corpse
  oObject1 = CreateObject(OBJECT_TYPE_PLACEABLE,
                          GS_TEMPLATE_CORPSE,
                          GetLocation(oSelf));

  if (GetIsObjectValid(oObject1))
  {
        int nGold = GetGold();
        int nGender = GetGender(oSelf);

        SetName(oObject1, GetName(oSelf) +
         " (" + (nGender == GENDER_MALE ? "Male " : "Female ") +
                                              GetSubRace(oSelf) + ")");
        SetLocalString(oObject1, "GS_TARGET", gsPCGetPlayerID(oSelf));
        SetLocalInt(oObject1, "GS_GENDER", nGender);
        SetLocalInt(oObject1, "GS_SIZE", GetCreatureSize(oSelf));
        SetLocalObject(oSelf, "GS_CORPSE", oObject1);

        if (nGold)
        {
            TakeGoldFromCreature(nGold, oSelf, TRUE);
            SetLocalInt(oObject1, "GS_GOLD", nGold);
        }
  }

  // Addition by Mithreas - Mark of Despair
  object oMark = GetItemPossessedBy(oSelf, "mi_mark_despair");

  if (((nPVP && nKiller_RPR) || !GetLocalInt(GetModule(), "STATIC_LEVEL")) && GetIsObjectValid(oMark))
  {
    int nCount = GetLocalInt(oMark, "DEATH_COUNT");
    nCount++;

    if (nCount < 10)
    {
      SendMessageToPC(oSelf,
      "The Mark of Despair cackles. '" + IntToString(nCount) + "! Only " +
      IntToString(10 - nCount) + " to go!'");
      SetLocalInt(oMark, "DEATH_COUNT", nCount);
    }
    else
    {
      // Delete character.
      fbEXDeletePC(oSelf);
    }
  }

  // Addition by Mithreas - Mark of Destiny
  oMark = GetItemPossessedBy(oSelf, "mi_mark_destiny");

  if (((nPVP && nKiller_RPR) || !GetLocalInt(GetModule(), "STATIC_LEVEL")) && GetIsObjectValid(oMark))
  {
    int nCount = GetLocalInt(oMark, "DEATH_COUNT");
    nCount++;

    if (nCount < 10)
    {
      SendMessageToPC(oSelf,
       "The Mark of Destiny cackles. '" + IntToString(nCount) + "! Only " +
       IntToString(10 - nCount) + " to go!'");
      SetLocalInt(oMark, "DEATH_COUNT", nCount);
    }
    else
    {
      // rewards
      gvd_DoRewards(oSelf);

      // Delete character.
      fbEXDeletePC(oSelf);
    }
  }
}
