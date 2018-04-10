#include "mi_inc_disguise"

// separate script file to be able to use the disguise functions in the NPCs investigate features for fixture remains

void main() {

  object oNPC = OBJECT_SELF;
  object oDamager = GetLocalObject(oNPC, "GVD_REMAINS_DAMAGER");
  string sName = GetLocalString(oNPC, "GVD_REMAINS_NAME");

  int iSubRace = gsSUGetSubRaceByName(GetSubRace(oDamager));
  string sGender = (GetGender(oDamager) == GENDER_MALE) ? "male":"female";

  // NPCs remember the last 20 people they have seen and can be asked via
  // -investigate.

  string sNewSeen = "";

  string sRace;

  switch (iSubRace) {
    case GS_SU_PLANETOUCHED_AASIMAR:
    case GS_SU_PLANETOUCHED_GENASI_AIR:
    case GS_SU_PLANETOUCHED_GENASI_EARTH:
    case GS_SU_PLANETOUCHED_GENASI_FIRE:
    case GS_SU_PLANETOUCHED_GENASI_WATER:
    case GS_SU_PLANETOUCHED_TIEFLING:
    if (GetSkillRank(SKILL_LORE, oNPC) >= 10) {
      sRace = gsSUGetNameBySubRace(iSubRace);
    } else {
      sRace = gsSUGetRaceName(GetRacialType(oDamager));
    }
    break;
    case GS_SU_NONE:
      sRace = gsSUGetRaceName(GetRacialType(oDamager));
      break;
    default:
      sRace = gsSUGetNameBySubRace(iSubRace);
      break;
  }

  if (GetIsPCDisguised(oDamager)) {
    // See whether the NPC breaks the disguise.
    if (!SeeThroughDisguise(oDamager, oNPC)) {
      sNewSeen = "a " + sGender + " " + sRace + " destroyed that " + sName + " over there";
    }
  }

  if (sNewSeen == "") {
    // Not disguised or disguise pierced.
    string sAdjective = "beefy";
    int nHighestAbility = ABILITY_STRENGTH;

    if (GetAbilityScore(oDamager, ABILITY_DEXTERITY) > GetAbilityScore(oDamager, nHighestAbility)) {
      sAdjective = "wiry";
      nHighestAbility = ABILITY_DEXTERITY;
    }

    if (GetAbilityScore(oDamager, ABILITY_CONSTITUTION) > GetAbilityScore(oDamager, nHighestAbility)) {
      sAdjective = "tough";
      nHighestAbility = ABILITY_CONSTITUTION;
    }

    if (GetAbilityScore(oDamager, ABILITY_INTELLIGENCE) > GetAbilityScore(oDamager, nHighestAbility)) {
      sAdjective = "smart";
      nHighestAbility = ABILITY_INTELLIGENCE;
    }

    if (GetAbilityScore(oDamager, ABILITY_WISDOM) > GetAbilityScore(oDamager, nHighestAbility)) {
      sAdjective = "smart";
      nHighestAbility = ABILITY_WISDOM;
    }

    if (GetAbilityScore(oDamager, ABILITY_CHARISMA) > GetAbilityScore(oDamager, nHighestAbility)) {
      sAdjective = "attractive";
      nHighestAbility = ABILITY_CHARISMA;
    }

    string sJoiningText = "";
    switch (d3()) {
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

    sNewSeen = "a " + sGender + " " + sRace + ", " + sJoiningText + " " + sAdjective + " destroyed that " + sName + " over there";

  }

  // Maintain a rolling list of 20 items.
  // Don't use the ReplaceElement method since it's overkill & expensive.
  int nCurrentIndex = GetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX");
  int nCount = GetElementCount("MI_SEEN_LIST", oNPC);

  if (nCount < 20) {
    // Counts are 1-based, indices are 0-based.  So subtract 1.
    nCurrentIndex = AddStringElement(sNewSeen, "MI_SEEN_LIST", oNPC) - 1;
    SetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX", nCurrentIndex);
  } else {
    // 20+ items, so remove the oldest.
    if (nCurrentIndex == 19) nCurrentIndex = 0;
    else nCurrentIndex++;
     
    ReplaceStringElement(nCurrentIndex, sNewSeen, "MI_SEEN_LIST", oNPC);
    SetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX", nCurrentIndex);
  }

  // variables no longer needed
  DeleteLocalObject(oNPC, "GVD_REMAINS_DAMAGER");
  DeleteLocalString(oNPC, "GVD_REMAINS_NAME");

}
