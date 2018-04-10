#include "fb_inc_zombie"
#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_encounter"
#include "gs_inc_event"
#include "gs_inc_flag"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "gs_inc_xp"
#include "gs_inc_treasure"
#include "inc_item"
#include "inc_loot"
#include "inc_math"
#include "mi_inc_divinatio"
#include "mi_inc_pop"
#include "gvd_inc_slave"
#include "gvd_inc_arena"
#include "bm_inc_blood"
#include "gvd_inc_adv_xp"
#include "inc_quest"
#include "inc_ranger"
#include "inc_stacking"

const string GS_TEMPLATE_CORPSE  = "gs_placeable016";
const string GS_BOSS_HEAD_MEGA   = "gs_item393";
const string GS_BOSS_HEAD_HIGH   = "gs_item386";
const string GS_BOSS_HEAD_MEDIUM = "gs_item390";
const string GS_BOSS_HEAD_LOW    = "gs_item391";
const string GS_BOSS_HEAD_MINI   = "gs_item392";
const int GS_TIMEOUT             = 21600; //6 hours
const int GS_LIMIT_VALUE         = 10000;

void _gsDropLoot()
{
    object oBones = OBJECT_SELF;
    SetPlotFlag(oBones, FALSE);

    // Always create a corpse object for gold spawns.
    //if (!GetIsObjectValid(GetFirstItemInInventory()))
    //{
    //  DestroyObject(oBones);
    //  return;
    //}

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
    for (; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
    {
      oItem = GetItemInSlot(nSlot, oSource);
      if (GetIsObjectValid(oItem))
      {
        nValue = gsCMGetItemValue(oItem);

        // Do not drop items worth more than GS_LIMIT_VALUE or creature items
        // Also omit items marked as plot.
        if (!GetPlotFlag(oItem) && nValue <= GS_LIMIT_VALUE && nSlot < 14 && !bRestrict)
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
        // DestroyObject(oItem);

      }
    }
  }

  //inventory
  oItem = GetFirstItemInInventory(oSource);

  while (GetIsObjectValid(oItem))
  {
    nValue = gsCMGetItemValue(oItem);

    if ((nMortal || GetDroppableFlag(oItem)) && nValue < GS_LIMIT_VALUE &&
      ConvertedStackTag(oItem) != "FB_TREASURE" && !bRestrict)
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
  int nOverride  = gsFLGetAreaFlag("PVP") ||
                   gsFLGetAreaFlag("OVERRIDE_DEATH");
  int bHasLoot   = TRUE; //GetAbilityScore(oSelf, ABILITY_INTELLIGENCE) >= 6;

  // Log NPC death if they're not hostile.
  if (GetIsPC(oKiller))
  {
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC) && (GetIsDM(oPC) || oPC == oKiller)) oPC = GetNextPC();
    if (!GetIsReactionTypeHostile(oSelf, oPC))
    {
      SendMessageToAllDMs(GetName(oKiller) + " just killed " + GetName(oSelf) +
       " in " + GetName(GetArea(oSelf)));
      Log("DEATH", GetName(oKiller) + " just killed " + GetName(oSelf) +
       " in " + GetName(GetArea(oSelf)));
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
        // Hook for Quests
        TallyKillsForQuest(oKiller, oSelf);

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
        // Hook for Quests, treat the summoner as oKiller
        TallyKillsForQuest(oMaster, oSelf);

        // Hook for Ranger
        if (GetLevelByClass(CLASS_TYPE_RANGER, oMaster) > 4)
            TallyRangerKills(oMaster, oSelf);

      } else {
        // Safeguard in case the above hook doesn't do it for summoned creatures.
        object oNearest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (GetIsObjectValid(oNearest))
        {
            TallyKillsForQuest(oNearest, oSelf);
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

          if (fChallengeRating >= 20.0)      sTemplate = GS_BOSS_HEAD_MEGA;
          else if (fChallengeRating >= 15.0) sTemplate = GS_BOSS_HEAD_HIGH;
          else if (fChallengeRating >= 10.0) sTemplate = GS_BOSS_HEAD_MEDIUM;
          else if (fChallengeRating >= 5.0)  sTemplate = GS_BOSS_HEAD_LOW;
          else                               sTemplate = GS_BOSS_HEAD_MINI;

          // addition Dunshine, store head in object
          oLeaderHead = CreateItemOnObject(sTemplate);
        }

        // addition by Dunshine: create a Head of a Slaver item if the corpse is of any of the slaver NPCs AND if the NPC was killed by a Slave Guild PC
        if (gvd_SlaveGuildMember(oKiller) == TRUE) {

          // killer is guild member, now check target
          if (gvd_CheckIsSlaver(oSelf) == TRUE) {
            // corpse was a Slaver, create the head based on CR
            string sTemplate = "";

            if (fChallengeRating >= 20.0)      sTemplate = "gvd_slaver_head4";
            else if (fChallengeRating >= 15.0) sTemplate = "gvd_slaver_head3";
            else if (fChallengeRating >= 10.0) sTemplate = "gvd_slaver_head2";
            else                               sTemplate = "gvd_slaver_head1";

            oLeaderHead = CreateItemOnObject(sTemplate);
          }

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
        if (GetIsPC(oKiller) && fChallengeRating >= GetChallengeRating(oKiller) - 5.0f)
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

  if (gsFLGetFlag(GS_FL_MORTAL)) gsCMDestroyInventory();
}



