#include "inc_zombie"
#include "inc_boss"
#include "inc_common"
#include "inc_effect"
#include "inc_encounter"
#include "inc_event"
#include "inc_flag"
#include "inc_time"
#include "inc_worship"
#include "inc_xp"
#include "inc_treasure"
#include "inc_item"
#include "inc_loot"
#include "inc_math"
#include "inc_crime"
#include "inc_divination"
#include "inc_pop"
#include "inc_bloodstains"
#include "inc_adv_xp"
#include "inc_quest"
#include "inc_randomquest"
#include "inc_ranger"
#include "inc_stacking"
#include "inc_theft"

const string GS_TEMPLATE_CORPSE  = "gs_placeable016";
const string GS_BOSS_HEAD_MEGA   = "mon_head_mega";
const string GS_BOSS_HEAD_HIGH   = "mon_head_high";
const string GS_BOSS_HEAD_MEDIUM = "mon_head_med";
const string GS_BOSS_HEAD_LOW    = "mon_head_low";
const string GS_BOSS_HEAD_MINI   = "mon_head_mini";
// Use the humanoid head appearance for player races.
const string GS_BOSS_HEAD_HHIGH  = "hum_head_high";
const string GS_BOSS_HEAD_HMED   = "hum_head_med";
const string GS_BOSS_HEAD_HLOW   = "hum_head_low";
const int GS_TIMEOUT             = 3600; //1 RL hour
const int GS_LIMIT_VALUE         = 10000;

void _gsDropLoot()
{
    object oBones = OBJECT_SELF;
    SetPlotFlag(oBones, FALSE);

    // Always create a corpse object for gold spawns.

    DelayCommand(120.0, ExecuteScript("gs_run_destroy", oBones));
}
//----------------------------------------------------------------

void gsDropLoot(object oCorpse)
{
    object oItem   = OBJECT_INVALID;
    object oLoot   = OBJECT_INVALID;
    object oSource = OBJECT_SELF;
    int nMortal    = gsFLGetFlag(GS_FL_MORTAL, oSource);
    int nValue     = 0;
    int bRestrict = FALSE;

    if (GetLocalInt(oSource, "NO_INVENTORY_DROPS")) bRestrict = TRUE;

  //gold - removed and replaced by stash coding.
  //nValue = GetGold(oSource);
  //AssignCommand(oCorpse, TakeGoldFromCreature(nValue, oSource));

  // loot slots
  if (nMortal)
  {
    int nSlot = 0;
    for (; nSlot < 14; nSlot++) // Note - slots 14-17 are creature weapon/armour slots, so exclude them.
    {
      oItem = GetItemInSlot(nSlot, oSource);
      if (GetIsObjectValid(oItem))
      {
        nValue = gsCMGetItemValue(oItem);

        // Do not drop items worth more than GS_LIMIT_VALUE or creature items
        // Also omit items marked as plot. 
		if (GetIsObjectValid(gsTHGetStolenFrom(oItem)))
		{
		  // This item was stolen from a PC.  Drop it.
          oLoot = CopyItem(oItem, oCorpse);
		  gsTHResetStolenItem(oLoot);
		}
		else if (!GetPlotFlag(oItem) && nValue <= GS_LIMIT_VALUE && nSlot < 14 && !bRestrict)
        {
          oLoot = CopyItem(oItem, oCorpse);
          if(GetIsItemMundane(oItem)) SetIsItemMundane(oLoot, TRUE);
          SetIdentified(oLoot, nValue <= 100);
        }
        // Addition by Septire. Don't unequip from NPC, instead leave a lootable version if applicable
        // --[
        if (nSlot == INVENTORY_SLOT_CHEST||INVENTORY_SLOT_CLOAK||INVENTORY_SLOT_RIGHTHAND||INVENTORY_SLOT_LEFTHAND||INVENTORY_SLOT_HEAD)
        {
            SetDroppableFlag(oItem, FALSE);
        }
        else
        {
            DestroyObject(oItem);
        }
        // ]--

      }
    }
  }

  //inventory
  oItem = GetFirstItemInInventory(oSource);

  while (GetIsObjectValid(oItem))
  {
    nValue = gsCMGetItemValue(oItem);

	if (GetIsObjectValid(gsTHGetStolenFrom(oItem)))
	{
	  // This item was stolen from a PC.  Drop it.
	  oLoot = CopyItem(oItem, oCorpse);
	  gsTHResetStolenItem(oLoot);
	}
    else if ((nMortal || GetDroppableFlag(oItem)) && nValue < GS_LIMIT_VALUE &&
      ConvertedStackTag(oItem) != "FB_TREASURE" && !bRestrict && !GetPlotFlag(oItem))
    {
      oLoot = CopyItem(oItem, oCorpse);
      if(GetIsItemMundane(oItem)) SetIsItemMundane(oLoot, TRUE);
      SetIdentified(oLoot, nValue <= 100);
    }

    if (nMortal)
    {
      DestroyObject(oItem);
    }

    oItem = GetNextItemInInventory(oSource);
  }

  AssignCommand(oCorpse, _gsDropLoot());
}
//----------------------------------------------------------------

void main()
{
  object oSelf = OBJECT_SELF;

  SignalEvent(oSelf, EventUserDefined(GS_EV_ON_DEATH));

  gsFXBleed();

  SetLocalInt(oSelf, "GS_TIMEOUT", gsTIGetActualTimestamp() + GS_TIMEOUT);

  object oKiller = GetLastKiller();
  int nKiller    = GetIsObjectValid(oKiller) &&
                   GetObjectType(oKiller) == OBJECT_TYPE_CREATURE &&
                   oKiller != oSelf;
  int nOverride  = gsFLGetAreaFlag("OVERRIDE_DEATH");
  int bHasLoot   = TRUE; //GetAbilityScore(oSelf, ABILITY_INTELLIGENCE) >= 6;

  // Log NPC death if they're not hostile.
  if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller)))
  {
    object oResponsiblePC = (GetIsObjectValid(GetMaster(oKiller)) ? GetMaster(oKiller) : oKiller);
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC) && (GetIsDM(oPC) || oPC == oResponsiblePC)) oPC = GetNextPC();
    if (!GetIsReactionTypeHostile(oSelf, oPC))
    {
      SendMessageToAllDMs(GetName(oResponsiblePC) + " just killed " + GetName(oSelf) +
       " in " + GetName(GetArea(oSelf)));
      Log("DEATH", GetName(oResponsiblePC) + " just killed " + GetName(oSelf) +
       " in " + GetName(GetArea(oSelf)));
    }
	
	// Random quests hook - have we completed an assassin or cull mission?
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 40.0f, GetLocation(OBJECT_SELF), TRUE);

    while (GetIsObjectValid(oCreature))
    {
	  if (GetIsPC(oCreature))
	  {
	    if (GetIsPlayerActive(oCreature, GetTag(oSelf)))
	    {
	      PlayerNoLongerActive(oCreature, GetTag(oSelf));
	    }
		
		if (GetLocalInt(gsPCGetCreatureHide(oCreature), KILL_COUNT) && 
		    GetTag(oSelf) == GetLocalString(gsPCGetCreatureHide(oCreature), CULL_TAG))
		{
		  int nCount = GetLocalInt(gsPCGetCreatureHide(oCreature), KILL_COUNT) - 1;
		  
		  SendMessageToPC(oCreature, GetName(oSelf) + " slain.  " + IntToString(nCount) + " remaining for quest.");
		  SetLocalInt(gsPCGetCreatureHide(oCreature), KILL_COUNT, nCount);
		}
	  }
	  
	  oCreature = GetNextObjectInShape(SHAPE_SPHERE, 40.0f, GetLocation(OBJECT_SELF), TRUE);
	}
  }

  if (!nOverride)
  {

    if (nKiller)
    {

      //reward
      if (!GetLocalInt(oSelf, "GS_STATIC") || gsENGetIsEncounterCreature() ||
       gsBOGetIsBossCreature())
      {
        gsXPRewardKill();
      }
      if (bHasLoot && !gsFLGetFlag(GS_FL_DISABLE_CALL))
       SpeakString("GS_AI_ATTACK_TARGET", TALKVOLUME_SILENT_TALK);

      // Assign divination points.
      if (GetIsPC(oKiller)) miDVGivePoints(oKiller, ELEMENT_DEATH, 1.0);

      // Assign piety points.
      if (GetIsPC(oKiller))
      {
        // Hook for Ranger
        if (GetLevelByClass(CLASS_TYPE_RANGER, oKiller) > 4)
            TallyRangerKills(oKiller, oSelf);

        int nAspect = gsWOGetAspect(gsWOGetDeityByName(GetDeity(oKiller)));
        if (nAspect & ASPECT_WAR_DESTRUCTION) gsWOAdjustPiety(oKiller, 0.5);

        // handle adventure xp for creature type
        if (!GetIsDM(oKiller)) {
          gvd_AdventuringXP_ForObject(oKiller, "CREATURE_TYPE", oSelf);
        }

        if (VampireIsVamp(oKiller) && gsSPGetIsLiving(oSelf))
        {
          float baseBlood = 0.2 * GetCreatureSize(oSelf);
          float modifiedBlood = baseBlood;

          float levelDiff = GetChallengeRating(oKiller) - GetChallengeRating(oSelf);

          // Scales up or down 50% in a 10 level range either way.
          if (levelDiff != 0.0)
          {
            float modifier = MaxFloat(-1.0, MinFloat(1.0, levelDiff / 10.0));
            modifiedBlood += baseBlood * -modifier;
          }

          gsSTAdjustState(GS_ST_BLOOD, modifiedBlood, oKiller);
        }
      } else if (GetIsObjectValid(GetMaster(oKiller))) {

        object oMaster = GetMaster(oKiller);

        // Hook for Ranger
        if (GetLevelByClass(CLASS_TYPE_RANGER, oMaster) > 4)
            TallyRangerKills(oMaster, oSelf);

      } else {
        // Safeguard in case the above hook doesn't do it for summoned creatures.
        object oNearest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (GetIsObjectValid(oNearest))
        {
            // Hook for Ranger
            if (GetLevelByClass(CLASS_TYPE_RANGER, oNearest) > 4)
                TallyRangerKills(oNearest, oSelf);
        }
      }

      // Adjust population
      string sTag = GetLocalString(GetArea(oSelf), VAR_POP);

      if (sTag != "") miPOAdjustPopulation(sTag, -1);
    }
    if (fbZGetZombieRace(oSelf) && GetLocalInt(GetModule(), "ZOMBIE_MODE"))
    {
      fbZDied(oSelf);
    }
    else if (!gsFLGetFlag(GS_FL_DISABLE_LOOT))
    {

      //create corpse
      object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                    GS_TEMPLATE_CORPSE,
                                    GetLocation(oSelf));

      if (GetIsObjectValid(oCorpse))
      {
        float fChallengeRating = GetChallengeRating(oSelf);

        // Store creature data
        SetLocalFloat(oCorpse, "MI_EN_CR", fChallengeRating);
        SetLocalInt(oCorpse, "CORPSE_RACIALTYPE", GetRacialType(oSelf));
        SetLocalInt(oCorpse, "FB_PP_COUNT", GetLocalInt(oSelf, "FB_PP_COUNT"));
        SetLocalInt(oCorpse, "FB_PP_GOLD", GetLocalInt(oSelf, "FB_PP_GOLD"));

        //set name
        SetName(oCorpse, GetName(oSelf));

        // addition Dunshine, create variable to store the head object in so we can rename it
        object oLeaderHead = OBJECT_INVALID;

        int isBoss = gsBOGetIsBossCreature();

        //create boss head
        if (isBoss)
        {
          string sTemplate       = "";
		  
		  if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HUMAN ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HALFLING ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GNOME ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELF ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DWARF ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HALFELF ||
		      GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HALFORC)
		  {
            if (fChallengeRating >= 15.0)      sTemplate = GS_BOSS_HEAD_HHIGH;
            else if (fChallengeRating >= 10.0) sTemplate = GS_BOSS_HEAD_HMED;
            else                               sTemplate = GS_BOSS_HEAD_HLOW;       
		  }
		  else
          {		  
            if (fChallengeRating >= 20.0)      sTemplate = GS_BOSS_HEAD_MEGA;
            else if (fChallengeRating >= 15.0) sTemplate = GS_BOSS_HEAD_HIGH;
            else if (fChallengeRating >= 10.0) sTemplate = GS_BOSS_HEAD_MEDIUM;
            else if (fChallengeRating >= 5.0)  sTemplate = GS_BOSS_HEAD_LOW;
            else                               sTemplate = GS_BOSS_HEAD_MINI;
          }
		   
          // addition Dunshine, store head in object
          oLeaderHead = CreateItemOnObject(sTemplate);
        }

        // change the name and description of the head
        if (oLeaderHead != OBJECT_INVALID) {

          SetName(oLeaderHead, GetName(oLeaderHead) + " (" + GetName(oSelf) + ")");

          // also add a local variable starting with _ to prevent stacking, use tagname for this
          SetLocalInt(oLeaderHead, "_" + GetTag(oSelf), 1);
        }

        //transfer inventory
        gsDropLoot(oCorpse);

        // We only want to spawn loot on players, and also, ensure that they are killing things near their level.
        // Spawn these directly on the corpse; we want this type of loot to bypass the other systems.
        if (GetIsPC(oKiller) && fChallengeRating >= gsXPGetPCChallengeRating(oKiller, 5.0f, OBJECT_SELF) - 5.0f)
        {
            if (fChallengeRating >= 20.0)
            {
                CreateLoot(isBoss ? LOOT_CONTEXT_BOSS_HIGH : LOOT_CONTEXT_MOB_HIGH, oCorpse, oKiller);
            }
            else if (fChallengeRating >= 10.0)
            {
                CreateLoot(isBoss ? LOOT_CONTEXT_BOSS_MEDIUM : LOOT_CONTEXT_MOB_MEDIUM, oCorpse, oKiller);
            }
            else
            {
                CreateLoot(isBoss ? LOOT_CONTEXT_BOSS_LOW : LOOT_CONTEXT_MOB_LOW, oCorpse, oKiller);
            }
        }

        if (bHasLoot)
        {
          gsTRCreateTreasure(oCorpse, GetRacialType(oSelf), fChallengeRating,
           GetLocalInt(oSelf, "FB_PP_COUNT"), GetLocalInt(oSelf, "FB_PP_GOLD"), OBJECT_INVALID);
        }
        return;
      }
    }
  }
  
  /*
  OnDeath addition to check faction and increase a PC's bounty if necessary.
  Author: Mithreas
  Date: 4 Sep 05
  Version: 1.1

  Rev 1.1 - add to bounty of master for associate's actions.
  */

  Trace(BOUNTY, "Calling bounty script");
  int nNation = CheckFactionNation(OBJECT_SELF);
  if (nNation != NATION_INVALID)
  {
    Trace (BOUNTY, "NPC is from a nation that gives bounties.");
    // Note - killing by traps will not give you a bounty.
    if (GetIsPC(GetLastKiller()))
    {
      Trace(BOUNTY, "Adding to PC's bounty");
      AddToBounty(nNation, FINE_MURDER, GetLastKiller());
    }
    else if ((GetAssociateType(GetLastKiller()) != ASSOCIATE_TYPE_NONE) &&
             GetIsPC(GetMaster(GetLastKiller())))
    {
      Trace(BOUNTY, "Adding to master's bounty");
      AddToBounty(nNation, FINE_MURDER, GetMaster(GetLastKiller()));
    }
  }

  if (gsFLGetFlag(GS_FL_MORTAL)) gsCMDestroyInventory();
}



