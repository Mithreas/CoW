#include "inc_checker"
#include "inc_favsoul"
#include "inc_log"
#include "inc_respawn"

// Returns TRUE if the PC is a completely legal first level character, false
// otherwise. Method _1 initialises variables and checks stats and hitpoints.
// Method _2 checks feats. Method _3 checks skills. (Broken up to avoid TMI
// errors).
void miCheckIfCharacterIsLegal_1(object oPC);

void miCheckIfCharacterIsLegal_1(object oPC)
{
  Trace(CHECKER, "Checking stats and hitpoints for " + GetName(oPC));
  int nClass = GetClassByPosition(1, oPC);
  int nRace  = GetRacialType(oPC);
  int nBaseHP;
  int nBaseSkillPoints;
  int nNumFeats = 1;

  int nFavouredAbilityScore = -1;
  int nBadAbilityScore1 = -1;
  int nBadAbilityScore2 = -1;

  switch (nClass)
  {
   case CLASS_TYPE_BARBARIAN:
     nBaseHP = 12;
     nBaseSkillPoints = 4;
     nNumFeats += 8;
     break;
   case CLASS_TYPE_BARD:
     nBaseHP = 6;
     nBaseSkillPoints = 4;
     nNumFeats += 7;
     break;
   case CLASS_TYPE_CLERIC:
     nBaseHP = 8;
     nBaseSkillPoints = 2;
     nNumFeats += 9; // Includes two domain feats
     break;
   case CLASS_TYPE_DRUID:
     nBaseHP = 8;
     nBaseSkillPoints = 4;
     nNumFeats += 7;
     break;
   case CLASS_TYPE_FAVOURED_SOUL:
     nBaseHP = 8;
	 nBaseSkillPoints = 2;
	 nNumFeats += 7;
	 break;
   case CLASS_TYPE_FIGHTER:
     nBaseHP = 10;
     nBaseSkillPoints = 2;
     nNumFeats += 8; // Including bonus feat at first level.
     break;
   case CLASS_TYPE_MONK:
     nBaseHP = 8;
     nBaseSkillPoints = 4;
     nNumFeats += 8;
     break;
   case CLASS_TYPE_PALADIN:
     nBaseHP = 10;
     nBaseSkillPoints = 2;
     nNumFeats += 10;
     break;
   case CLASS_TYPE_RANGER:
     nBaseHP = 10;
     nBaseSkillPoints = 4;
     nNumFeats += 11; // 7 plus one favoured enemy plus ambi and 2wf.
     break;
   case CLASS_TYPE_ROGUE:
     nBaseHP = 6;
     nBaseSkillPoints = 8;
     nNumFeats += 4;
     break;
   case CLASS_TYPE_SHIFTER:
     nBaseHP = 8;
     nBaseSkillPoints = 4;
     nNumFeats += 3;
     break;
   case CLASS_TYPE_SORCERER:
     nBaseHP = 4;
     nBaseSkillPoints = 2;
     nNumFeats += 3;
     break;
   case CLASS_TYPE_WIZARD:
     nBaseHP = 4;
     nBaseSkillPoints = 2;
     nNumFeats += 4;
     break;
   default:
     Error(CHECKER, GetName(oPC) + " had an illegal class: " + IntToString(nClass));
     miBootAndBanPC(oPC);
     return;
     break;
  }

  switch (nRace)
  {
    case RACIAL_TYPE_DWARF:
      nNumFeats += 8;
      nFavouredAbilityScore = ABILITY_CONSTITUTION;
      nBadAbilityScore1 = ABILITY_CHARISMA;
      break;
    case RACIAL_TYPE_ELF:
      nNumFeats += 8;
      nFavouredAbilityScore = ABILITY_DEXTERITY;
      nBadAbilityScore1 = ABILITY_CONSTITUTION;
      break;
    case RACIAL_TYPE_GNOME:
      nNumFeats += 9;
      nFavouredAbilityScore = ABILITY_CONSTITUTION;
      nBadAbilityScore1 = ABILITY_STRENGTH;
      break;
    case RACIAL_TYPE_HALFELF:
      nNumFeats += 6;
      break;
    case RACIAL_TYPE_HALFLING:
      nNumFeats += 6;
      nFavouredAbilityScore = ABILITY_DEXTERITY;
      nBadAbilityScore1 = ABILITY_STRENGTH;
      break;
    case RACIAL_TYPE_HALFORC:
      nNumFeats += 1;
      nFavouredAbilityScore = ABILITY_STRENGTH;
      nBadAbilityScore1 = ABILITY_CHARISMA;
      nBadAbilityScore2 = ABILITY_INTELLIGENCE;
      break;
    case RACIAL_TYPE_HUMAN:
      nNumFeats += 2; // Quick to Master + 1 bonus feat
      nBaseSkillPoints += 1;
      break;
    default:
       Error(CHECKER, GetName(oPC) + " had an illegal race: " + IntToString(nRace));
       miBootAndBanPC(oPC);
       return;
     break;
  }

  SendMessageToPC(oPC, "Got stats.");

  // Check stats first.
  int nTotalPoints = 0;
  int nScore;
  int nAbility;
  for (nAbility = 0; nAbility < 6; nAbility ++)
  {
     int nBase = 8;
     if (nAbility == nFavouredAbilityScore) nBase = 10;
     else if (nAbility == nBadAbilityScore1) nBase = 6;
     else if (nAbility == nBadAbilityScore2) nBase = 6;

     nScore = GetAbilityScore(oPC, nAbility, TRUE) - nBase;
     if (nScore <= 6)
     {
       nTotalPoints += nScore;
     }
     else if (nScore <= 8)
     {
       nTotalPoints += 6 + (nScore - 6) * 2;
     }
     else if (nScore <= 10)
     {
       nTotalPoints += 10 + (nScore - 8) * 3;
     }
     else
     {
       Error(CHECKER, GetName(oPC) + " has illegal ability score ("
                      + IntToString(nScore) + ") for " + IntToString(nAbility));
       miBootAndBanPC(oPC);
       return;
     }
  }

  if (nTotalPoints > 30)
  {
    Error(CHECKER, GetName(oPC) + " has illegal number of stat points ("
                   + IntToString(nTotalPoints) + ")");
    miBootAndBanPC(oPC);
    return;
  }

  SendMessageToPC(oPC, "Checked stats.");

  // Check hitpoints.
  int nHP = GetMaxHitPoints(oPC);
  if (nHP != nBaseHP + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) +
    (GetHasFeat(FEAT_TOUGHNESS, oPC)? 1:0 ))
  {
    Error(CHECKER, GetName(oPC) + " has illegal number of hit points ("
                                + IntToString(nHP) + ")");
    miBootAndBanPC(oPC);
    return;
  }

  SendMessageToPC(oPC, "Checked HPs.");
  nBaseSkillPoints =
           4*(nBaseSkillPoints + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC));

  if (nBaseSkillPoints == 0) nBaseSkillPoints = 4;

  SetLocalInt(oPC, "MI_CHECK_FEATS", nNumFeats);
  SetLocalInt(oPC, "MI_CHECK_SKILLS", nBaseSkillPoints);
  DelayCommand(0.5, ExecuteScript("mi_checker_2", oPC));
}

void main()
{
  // City of Winds - allowed races and classes.
  if (!CoW_HasAllowedClasses(OBJECT_SELF))
  {
       DelayCommand(3.0, JumpToLocation(GetLocation(GetObjectByTag("invalid_classes")) ));
	   DelayCommand(10.0, gsRESetRespawnLocation(OBJECT_SELF));
       return;
  }
  
  // End City of Winds custom check.

  miCheckIfCharacterIsLegal_1(OBJECT_SELF);
}
