#include "inc_bloodstains"
#include "inc_crime"
#include "inc_challenge"
#include "inc_external"
#include "inc_zombie"
#include "inc_common"
#include "inc_flag"
#include "inc_pc"
#include "inc_portal"
#include "inc_strack"
#include "inc_text"
#include "inc_theft"
#include "inc_time"
#include "inc_worship"
#include "inc_xp"
#include "inc_healer"
#include "inc_spells"
#include "inc_vampire"
#include "inc_factions"
#include "inc_awards"

const int GS_PENALTY_PER_LEVEL  = 25;

// Original gsDeath function.
void gsDeath();
// Original main function. Moved to a separate function so it can be delayed.
void DoDeath(object oDied, object oKiller);
// Turns the PC into a ghost, drifting in the death plane until they can recover their corpse.
void MakeGhost(object oPC);
// Restores the PC to their normal self.
void MakeLiving(object oPC);

void MakeGhost(object oPC)
{
  object oCorpse = GetLocalObject(oPC, "GS_CORPSE");
  object oHide   = gsPCGetCreatureHide(oPC);
  
  SetLocalInt(oHide, "IS_GHOST", TRUE);
  
  // Apply the ghost polymorph effect (supernatural and locked so can't be removed).
  AssignCommand(oCorpse, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectPolymorph(133, TRUE)), oPC));
  SetPlotFlag(oPC, TRUE); 
  SetLocalInt(oPC, "AI_IGNORE", TRUE); // NPCs ignore ghosts passing by. 
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oPC);
  
  // All other effects removed by the main death script.
  
}

void MakeLiving(object oPC)
{
  // Destroy your own corpse object, even if you aren't currently a ghost.
  object oCorpse = GetLocalObject(oPC, "GS_CORPSE");
  GiveGoldToCreature(oPC, GetLocalInt(oCorpse, "GS_GOLD"));
  DestroyObject(oCorpse);
  
  // Ghost logic.
  object oHide = gsPCGetCreatureHide(oPC);
  
  if (GetLocalInt(oHide, "IS_GHOST"))
  {
    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
      RemoveEffect(oPC, eEffect);
      eEffect = GetNextEffect(oPC);
    }
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oPC);
  
    SetPlotFlag(oPC, FALSE); 
    DeleteLocalInt(oPC, "AI_IGNORE");
    DeleteLocalInt(oHide, "IS_GHOST");
  } 
}

void DoDeath(object oDied, object oKiller)
{
    //spelltracker
    gsSPTReset(oDied);

    // always turn subdual mode off when someone dies
    DeleteLocalInt(oDied, "GVD_SUBDUAL_MODE");

    // if last killer = pc itself, check for a bleed out attack, and grab the killer from a variable instead
    if (oKiller == oDied) 
	{
      if (GetLocalObject(oDied, "GVD_LAST_ATTACKER") != OBJECT_INVALID) 
	  {
        // bleed out death, so killer is someone else, use that one
        oKiller = GetLocalObject(oDied, "GVD_LAST_ATTACKER");
	  }	
    }
	
	// Bounty system code to clear a player's bounty if they were killed by
    // a guard.
	// Note: we apply this even if a god save or similar happens.  
    int nNation = CheckFactionNation(oKiller);

    if ((nNation != NATION_INVALID) &&
         GetIsDefender(oKiller) &&
         CheckWantedToken(nNation, oDied))
    {
      RemoveBountyToken(nNation, oDied);
      AdjustReputation(oDied, oKiller, 50);
	}	
	  
    if (!GetLocalInt(GetModule(), "ZOMBIE_MODE")) {
      AssignCommand(oDied, gsDeath());
	  SetCommandable(FALSE, oDied);
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
	
	// Plot death.
	if (GetLocalInt(oKiller, "PLOT_KILLER"))
	{
	  SetLocalInt(oDied, "PLOT_KILLED", TRUE);
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), GetLocation(oDied));
	}
	
	miCRResetRep(oDied);	
	
}

void gsDeath()
{
  object oSelf    = OBJECT_SELF;
  int nPVP        = FALSE;
  int nSuicide    = FALSE;
  int nKiller_RPR = FALSE;
  int bSafePvP    = gsFLGetAreaFlag("PVP", oSelf);
  
  // PC was set non-commandable above to avoid interruptions
  SetCommandable(TRUE, OBJECT_SELF);

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
  
  ClearAllActions(TRUE);
  
  if (GetTag(GetArea(oSelf)) != "FeywildBanquet" && 
      FindSubString(GetName(GetArea(oSelf)), "Feywilds") > -1) 
  {
    CHClearQuestCount(OBJECT_SELF, "CH_Q_FEY");
    ActionJumpToObject(GetObjectByTag("FWB_ENTER"));
  }	
  else if (GetLocalInt(GetArea(oSelf), "DEATH_PLANE"))
  {
    MakeGhost(oSelf);
    ActionJumpToObject(GetObjectByTag("GS_TARGET_GHOST"));
  }
  else 
  {
    ActionJumpToObject(GetObjectByTag("GS_TARGET_DEATH"));
  }
  
  ActionDoCommand(DelayCommand(6.0, SetPlotFlag(oSelf, FALSE)));
  ActionDoCommand(SetCommandable(TRUE));
  SetCommandable(FALSE);
  
  // City of Winds - plot death
  if (GetLocalInt(oSelf, "PLOT_KILLED"))
  {
    // The PC was killed by a plot NPC, so is permadead.
	
    // rewards
    gvd_DoRewards(oSelf);

    // Delete character.
    fbEXDeletePC(oSelf);
  }
  

  // Addition by Mithreas - Mark of Despair
  object oMark = GetItemPossessedBy(oSelf, "mi_mark_despair");

  if (!bSafePvP && ((nPVP && nKiller_RPR) || !GetLocalInt(GetModule(), "STATIC_LEVEL")) && GetIsObjectValid(oMark))
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

  if (!bSafePvP && ((nPVP && nKiller_RPR) || !GetLocalInt(GetModule(), "STATIC_LEVEL")) && GetIsObjectValid(oMark))
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
