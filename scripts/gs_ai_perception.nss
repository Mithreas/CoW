#include "fb_inc_zombie"
#include "gs_inc_combat"
#include "gs_inc_event"
#include "gs_inc_subrace"
#include "mi_inc_disguise"
#include "mi_crimcommon"
#include "zzdlg_lists_inc"

void gsPlayVoiceChat()
{
    if (Random(100) >= 75)
    {
        switch (Random(7))
        {
        case 0: PlayVoiceChat(VOICE_CHAT_ATTACK);     break;
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
        case 4: PlayVoiceChat(VOICE_CHAT_ENEMIES);    break;
        case 5: PlayVoiceChat(VOICE_CHAT_TAUNT);      break;
        case 6: PlayVoiceChat(VOICE_CHAT_THREATEN);   break;
        }
    }
}
//----------------------------------------------------------------
int GetIsNastyWeapon(object oItem)
{
  int nType = GetBaseItemType(oItem);

  switch (nType)
  {
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
    case BASE_ITEM_WHIP:
      return TRUE;

  }

  return FALSE;
}
//----------------------------------------------------------------
void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_PERCEPTION));

    object oPerceived = GetLastPerceived();

    if (GetLastPerceptionVanished() ||
        GetLastPerceptionInaudible())
    {
        if (GetIsEnemy(oPerceived) &&
            ! gsCBGetHasAttackTarget())
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
        }
		else if (gsCBGetLastAttackTarget() == oPerceived && GetLastPerceptionVanished())
		{
		  // Our current target vanished. 		  
		  if (gsCBGetIsPerceived(oPerceived))
		  {
		    // We can still hear them! Keep chasing them. 
		  }
		  else
		  {
		    // Look for another target.  Since gsCBGetIsPerceived fails
			// we'll pick someone else.
		    gsCBDetermineCombatRound();
		  }
		}
        return;
    }

    int bZombie = fbZGetIsZombie(OBJECT_SELF);
    if (fbZGetIsZombie(oPerceived) != bZombie)
    {
      SetIsTemporaryEnemy(oPerceived);
    }
    else if (bZombie)
    {
      SetIsTemporaryFriend(oPerceived);
    }


    if (GetIsEnemy(oPerceived) )
    {
        // Summons etc shouldn't attack before their PC - breaks pvp rules.
        if (GetIsPC(oPerceived) && GetIsPC(GetMaster(OBJECT_SELF)) &&
             !GetIsInCombat(GetMaster(OBJECT_SELF))) return;

        if (gsCBGetHasAttackTarget())
        {
            object oTarget = gsCBGetLastAttackTarget();

			// If the creature we just spotted (or which just vanished) isn't our
			// current target, and the enemy we spotted is (much) closer than 
			// our current target, switch targets.
            if (oPerceived != oTarget &&
                GetDistanceToObject(oPerceived) + 5.0 <=
                GetDistanceToObject(oTarget))
            {
                gsCBDetermineCombatRound(oPerceived);
                gsPlayVoiceChat();
            }
        }
        else
        {
            gsCBDetermineCombatRound(oPerceived);
            gsPlayVoiceChat();
        }
    }
    else if (GetLastPerceptionSeen() && GetIsPC(oPerceived))
    {
      // NPCs remember the last 20 people they have seen and can be asked via
      // -investigate.
      object oNPC = OBJECT_SELF;

      string sNewSeen = "";

      string sGender = (GetGender(oPerceived) == GENDER_MALE) ? "male":"female";

      string sRace;
      int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPerceived));

      switch (nSubRace)
      {
        case GS_SU_PLANETOUCHED_AASIMAR:
        case GS_SU_PLANETOUCHED_GENASI_AIR:
        case GS_SU_PLANETOUCHED_GENASI_EARTH:
        case GS_SU_PLANETOUCHED_GENASI_FIRE:
        case GS_SU_PLANETOUCHED_GENASI_WATER:
        case GS_SU_PLANETOUCHED_TIEFLING:
          if (GetSkillRank(SKILL_LORE, oNPC) >= 10)
          {
            sRace = gsSUGetNameBySubRace(nSubRace);
          }
          else
          {
            sRace = gsSUGetRaceName(GetRacialType(oPerceived));
          }
          break;
        case GS_SU_NONE:
          sRace = gsSUGetRaceName(GetRacialType(oPerceived));
          break;
        default:
          sRace = gsSUGetNameBySubRace(nSubRace);
          break;
      }

      if (GetIsPCDisguised(oPerceived))
      {
        // See whether the NPC breaks the disguise.
        if (!SeeThroughDisguise(oPerceived, oNPC))
        {
           sNewSeen = "a " + sGender + " " + sRace + ", I didn't notice much about them";
           return;
        }
      }

      if (sNewSeen == "")
      {
        // Not disguised or disguise pierced.
        string sAdjective = "beefy";
        int nHighestAbility = ABILITY_STRENGTH;

        if (GetAbilityScore(oPerceived, ABILITY_DEXTERITY) >
            GetAbilityScore(oPerceived, nHighestAbility))
        {
          sAdjective = "wiry";
          nHighestAbility = ABILITY_DEXTERITY;
        }

        if (GetAbilityScore(oPerceived, ABILITY_CONSTITUTION) >
            GetAbilityScore(oPerceived, nHighestAbility))
        {
          sAdjective = "tough";
          nHighestAbility = ABILITY_CONSTITUTION;
        }

        if (GetAbilityScore(oPerceived, ABILITY_INTELLIGENCE) >
            GetAbilityScore(oPerceived, nHighestAbility))
        {
          sAdjective = "smart";
          nHighestAbility = ABILITY_INTELLIGENCE;
        }

        if (GetAbilityScore(oPerceived, ABILITY_WISDOM) >
            GetAbilityScore(oPerceived, nHighestAbility))
        {
          sAdjective = "smart";
          nHighestAbility = ABILITY_WISDOM;
        }

        if (GetAbilityScore(oPerceived, ABILITY_CHARISMA) >
            GetAbilityScore(oPerceived, nHighestAbility))
        {
          sAdjective = "attractive";
          nHighestAbility = ABILITY_CHARISMA;
        }

        string sJoiningText = "";
        switch (d3())
        {
          case 1:
            sJoiningText = "looked pretty";
            break;
          case 2:
            sJoiningText = "I'd say they were";
            break;
          case 3:
            sJoiningText = "obviously";
            break;
        }

        sNewSeen = "a " + sGender + " " + sRace + ", " + sJoiningText + " " + sAdjective;
      }

      // Maintain a rolling list of 20 items.
      // Don't use the ReplaceElement method since it's overkill & expensive.
      int nCurrentIndex = GetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX");
      int nCount = GetElementCount("MI_SEEN_LIST", oNPC);

      if (nCount < 20)
      {
        // Counts are 1-based, indices are 0-based.  So subtract 1.
        nCurrentIndex = AddStringElement(sNewSeen, "MI_SEEN_LIST", oNPC) - 1;
        SetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX", nCurrentIndex);
      }
      else
      {
        // 20+ items, so remove the oldest.
        if (nCurrentIndex == 19) nCurrentIndex = 0;
        else nCurrentIndex++;
        ReplaceStringElement(nCurrentIndex, sNewSeen, "MI_SEEN_LIST", oNPC);
        SetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX", nCurrentIndex);
      }
   }
   
  /*
  OnPerception addition for guards to check whether a PC is wanted by the
  guard's faction and react accordingly. Add to the module default OnPerception
  script - it checks whether the character is a guard or not.
  Author: Mithreas
  Date: 4 Sep 05
  Version: 1.1

  For PCs:
  Check that the PC was seen (not just heard)
  Check that perceiver is a guard from an appropriate nation.
  CheckWantedToken() on the person perceived.
  If no wanted token, ignore person.
  If wanted, check whether disguised.
  If disguised, bluff/spot to see if recognised. If not recognised, ignore person.
  If not disguised, or if disguised but recognised, check bounty value.
  If bounty value over threshold, attack.
  Otherwise, approach and start conversation.
  */

  if (GetIsPC(oPercep) && GetLastPerceptionSeen())
  {
    if (!GetIsInCombat(OBJECT_SELF) && GetIsDefender(OBJECT_SELF) &&
           (CheckFactionNation(OBJECT_SELF) == NATION_DEFAULT))
    {
      // If not in combat, check whether spotted person is carrying a weapon.
      // If so, tell them not to do it. If they've been warned 10 times, give
      // them a small bounty.
      object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPercep);
      object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPercep);

      if (GetIsNastyWeapon(oItem1) || GetIsNastyWeapon(oItem2))
      {

        int nNumTimesWarned = GetLocalInt(oPercep, "weapon_warnings");
        if (nNumTimesWarned > 9)
        {
          SpeakString("You've been warned to put that weapon away often enough.");
          AddToBounty(NATION_DEFAULT, FINE_DISOBEDIENCE, oPercep);
          DeleteLocalInt(oPercep, "weapon_warnings");
        }
        else
        {
          SpeakString("Hey, you. Put that weapon away, no need to have it out round here.");
          SetLocalInt(oPercep, "weapon_warnings", nNumTimesWarned + 1);
        }
      }
    }

    Trace(BOUNTY, "PC sighted by bounty code.");
    int nNation = CheckFactionNation(OBJECT_SELF);
    if ((nNation != NATION_INVALID) && GetIsDefender(OBJECT_SELF))
    {
      Trace(BOUNTY, "This is a defender. Check whether PC has wanted token.");
      int nHasWanted = CheckWantedToken(nNation, oPercep);

      if (nHasWanted)
      {
        // Is the PC disguised?
        int nDisguised = GetLocalInt(oPercep, DISGUISED);
        int nSeenThroughDisguise = 0;

        if (nDisguised)
        {
          Trace(BOUNTY, "Testing disguise");
          nSeenThroughDisguise = SeeThroughDisguise(oPercep,
                                                    OBJECT_SELF,
                           "You try and convince the guard you're not the " +
                           "person they're looking out for...",
                                                    1);
        }

        if (!nDisguised || nSeenThroughDisguise)
        {
          string sTag = "mi_wanted" + IntToString(nNation);
          int nBounty = GetBounty(nNation, oPercep);
          Trace(BOUNTY, "PC has bounty of: " + IntToString(nBounty));
          if (nBounty > BOUNTY_THRESHOLD)
          {
            if (GetGender(oPercep) == GENDER_FEMALE)
            {
              SpeakString("It's her! Get her!", TALKVOLUME_SHOUT);
            }
            else
            {
              SpeakString("It's him! Get him!", TALKVOLUME_SHOUT);
            }

            AdjustReputation(oPercep,OBJECT_SELF,-100);
            SetFacingPoint(GetPosition(oPercep));
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
            DetermineCombatRound();
          }
          else
          {
            /* Start a Z-Dialog conversation using the zdlg_arrest script. */
            SetLocalString(OBJECT_SELF, "dialog", "zdlg_arrest");
            ActionStartConversation(oPercep, "zdlg_converse");
          }
        }
      }
    }
  }
}
