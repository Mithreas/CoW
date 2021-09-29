#include "inc_zombie"
#include "inc_combat"
#include "inc_event"
#include "inc_subrace"
#include "inc_disguise"
#include "inc_reputation"
#include "inc_shapechanger"
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
    object oPerceived = GetLastPerceived();
    if (GetLocalInt(oPerceived, "AI_IGNORE")) return; // Scrying / sent images.
	
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_PERCEPTION));

	int bDisguised = FALSE;
	if (GetIsPCDisguised(oPerceived) && !SeeThroughDisguise(oPerceived, OBJECT_SELF))
	{
		bDisguised = TRUE;
	}

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
	
	if (GetLastPerceptionSeen())
	{
		// Elf/human(/halfling) emnity.
		int bAppearsHostileToElves = ( 
			(GetRacialType(oPerceived) == RACIAL_TYPE_HALFLING || 
			 GetRacialType(oPerceived) == RACIAL_TYPE_HUMAN || 
			 (gsSUGetSubRaceByName(GetSubRace(oPerceived)) == GS_SU_SHAPECHANGER && GetLocalInt(gsPCGetCreatureHide(oPerceived), VAR_CURRENT_FORM) == 1)) &&
			!GetIsObjectValid(GetItemPossessedBy(oPerceived, "elf_safe_passage")));
		
		int bAppearsHostileToHumansHin = (
			(GetRacialType(oPerceived) == RACIAL_TYPE_ELF ||
			(gsSUGetSubRaceByName(GetSubRace(oPerceived)) == GS_SU_SHAPECHANGER && GetLocalInt(gsPCGetCreatureHide(oPerceived), VAR_CURRENT_FORM) == 1)) &&
			!GetIsObjectValid(GetItemPossessedBy(oPerceived, "hum_safe_passage")));
			
		if ( ((GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HUMAN || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_HALFLING) && !GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "elf_safe_passage")) && bAppearsHostileToHumansHin )
			 ||
			 (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELF && bAppearsHostileToElves))
		{
			object oPartyMember = GetFirstFactionMember(oPerceived, TRUE);
			int bHostile = TRUE;
			
			while (GetIsObjectValid(oPartyMember))
			{
				if (GetRacialType(oPartyMember) == GetRacialType(OBJECT_SELF))
				{
				  bHostile = FALSE;
				  break;
				}
				
				oPartyMember = GetNextFactionMember(oPerceived, TRUE);
			}
			
			if (bHostile)
			{
				SetIsTemporaryEnemy(oPerceived, OBJECT_SELF, TRUE, 300.0f);		  
			}
		}
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
        case GS_SU_NONE:
          sRace = gsSUGetRaceName(GetRacialType(oPerceived));
          break;
        default:
          sRace = gsSUGetNameBySubRace(nSubRace);
          break;
      }

      // See whether the NPC breaks the disguise.
      if (bDisguised)
      {
         sNewSeen = "a " + sGender + " " + sRace + ", I didn't notice much about them";
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
	  
	  // Not an enemy and seen - check for pickpocket.
	  if (GetIsPC(oPerceived) && GetHasFeat(FEAT_SKILL_FOCUS_PICK_POCKET) && d3() == 3)
	  {
	    ActionMoveToObject(oPerceived);
		ActionUseSkill(SKILL_PICK_POCKET, oPerceived);
	  }
	  else
	  {
	    // Maybe say hi. 
		if (d10() == 10) 
		{
		  // Faction check - 
		  if (!bDisguised && 
			  (GetRacialType(OBJECT_SELF) < 7  || GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEY) && // PC races plus fey
		      CheckFactionNation(OBJECT_SELF, TRUE) == GetPCFaction(oPerceived)) 
		  {
		    SpeakString("Hello again.");
		  }
		  else
		  {
		    SpeakOneLinerConversation();
		  }
		  
		}  
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
  int nNumTimesWarned;

  if (GetIsPC(oPerceived) && GetLastPerceptionSeen())
  {
    if (!GetIsInCombat(OBJECT_SELF) && GetIsDefender(OBJECT_SELF) &&
           (CheckFactionNation(OBJECT_SELF) == NATION_DEFAULT))
    {
      // If not in combat, check whether spotted person is carrying a weapon.
      // If so, tell them not to do it. If they've been warned 10 times, give
      // them a small bounty.
      object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPerceived);
      object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPerceived);

      if (GetIsNastyWeapon(oItem1) || GetIsNastyWeapon(oItem2))
      {

        nNumTimesWarned = GetLocalInt(oPerceived, "weapon_warnings");
        if (nNumTimesWarned > 9)
        {
          SpeakString("You've been warned to put that weapon away often enough.");
          AddToBounty(NATION_DEFAULT, FINE_DISOBEDIENCE, oPerceived);
          DeleteLocalInt(oPerceived, "weapon_warnings");
        }
        else
        {
          SpeakString("Hey, you. Put that weapon away, no need to have it out round here.");
          SetLocalInt(oPerceived, "weapon_warnings", nNumTimesWarned + 1);
        }
      }
    }
	else if (!GetIsInCombat(OBJECT_SELF) && GetIsDefender(OBJECT_SELF) && GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ELF && FindSubString(GetName(GetArea(OBJECT_SELF)), "Fernvale") >= 0 &&
			 !bDisguised && GetRacialType(oPerceived) != RACIAL_TYPE_ELF && GetRacialType(oPerceived) != RACIAL_TYPE_ANIMAL && GetRacialType(oPerceived) != RACIAL_TYPE_BEAST)
	{
		// Non Elves are not welcome in Fernvale.
		nNumTimesWarned = GetLocalInt(oPerceived, "elf_trespass_warnings");
		if (nNumTimesWarned > 4)
		{
			SpeakString("No trespassing!");
			AddToBounty(NATION_ELF, FINE_THEFT, oPerceived); // Tresspassing is close enough to theft :P
			DeleteLocalInt(oPerceived, "elf_trespass_warnings");
		}
		else
		{
			SpeakString("Guests in our lands are not welcome in Fernvale.  Leave the Vale at your earliest convenience.");
			SetLocalInt(oPerceived, "elf_trespass_warnings", nNumTimesWarned + 1);
		}
		
	}
	else if (!GetIsInCombat(OBJECT_SELF) && GetIsDefender(OBJECT_SELF) && GetRacialType(oPerceived) != RACIAL_TYPE_ELF &&
           (CheckFactionNation(OBJECT_SELF) == NATION_ELF) && !bDisguised)
	{
      object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPerceived);
      object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPerceived);

      if (GetIsNastyWeapon(oItem1) || GetIsNastyWeapon(oItem2))
      {

        nNumTimesWarned = GetLocalInt(oPerceived, "elf_weapon_warnings");
        if (nNumTimesWarned > 9)
        {
          SpeakString("You've been warned to put that weapon away often enough.");
          AddToBounty(NATION_ELF, FINE_DISOBEDIENCE, oPerceived);
          DeleteLocalInt(oPerceived, "elf_weapon_warnings");
        }
        else
        {
          SpeakString("Hey, you. You're not allowed to carry weapons in town.");
          SetLocalInt(oPerceived, "elf_weapon_warnings", nNumTimesWarned + 1);
        }
	  }	
	}

    Trace(BOUNTY, "PC sighted by bounty code.");
    int nNation = CheckFactionNation(OBJECT_SELF);
	int bHasDialog = (GetLocalString(OBJECT_SELF, "dialog") != "" && GetLocalString(OBJECT_SELF, "dialog")  != "zdlg_arrest");
    if ((nNation != NATION_INVALID) && GetIsDefender(OBJECT_SELF) && !bHasDialog)
    {
      Trace(BOUNTY, "This is a defender. Check whether PC has wanted token.");
      int nHasWanted = CheckWantedToken(nNation, oPerceived);

      if (nHasWanted)
      {
        if (!bDisguised)
        {
          string sTag = "mi_wanted" + IntToString(nNation);
          int nBounty = GetBounty(nNation, oPerceived);
          Trace(BOUNTY, "PC has bounty of: " + IntToString(nBounty));
          if (nBounty > BOUNTY_THRESHOLD)
          {
            if (GetGender(oPerceived) == GENDER_FEMALE)
            {
              SpeakString("It's her! Get her!", TALKVOLUME_SHOUT);
            }
            else
            {
              SpeakString("It's him! Get him!", TALKVOLUME_SHOUT);
            }

            AdjustReputation(oPerceived,OBJECT_SELF,-100);
            SetFacingPoint(GetPosition(oPerceived));
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
            DetermineCombatRound();
          }
          else
          {
            /* Start a Z-Dialog conversation using the zdlg_arrest script. */
			string sCurrentDialog = GetLocalString(OBJECT_SELF, "dialog");
			if (sCurrentDialog != "") DelayCommand (300.0f, SetLocalString(OBJECT_SELF, "dialog", sCurrentDialog));
            SetLocalString(OBJECT_SELF, "dialog", "zdlg_arrest");
            ActionStartConversation(oPerceived, "zdlg_converse");
          }
        }
      }
    }
  }
}
