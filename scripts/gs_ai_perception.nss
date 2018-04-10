#include "fb_inc_zombie"
#include "gs_inc_combat"
#include "gs_inc_event"
#include "gs_inc_subrace"
#include "mi_inc_disguise"
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
}
