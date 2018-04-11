#include "inc_checker"
#include "inc_log"

// Returns TRUE if the PC is a completely legal first level character, false
// otherwise. Method _1 initialises variables and checks stats and hitpoints.
// Method _2 checks feats. Method _3 checks skills. (Broken up to avoid TMI
// errors).
void miCheckIfCharacterIsLegal_3(object oPC);

void miCheckIfCharacterIsLegal_3(object oPC)
{
  int nBaseSkillPoints = GetLocalInt(oPC, "MI_CHECK_SKILLS");

  int nSkill;
  int nCountSkillPoints = 0;
  for (nSkill = 0; nSkill <= MAX_SKILL; nSkill++)
  {
    if (GetSkillRank(nSkill, oPC, TRUE) > 4)
    {
      Error(CHECKER, GetName(oPC) + " has too many ranks ("
         + IntToString(GetSkillRank(nSkill, oPC, TRUE)) + ") - in skill " +
                                                           IntToString(nSkill));
      miBootAndBanPC(oPC);
      return;
    }

    nCountSkillPoints += GetSkillRank(nSkill, oPC, TRUE);
  }

  // characters don't have to use all their skill points, and may have cross
  // class skills (= fewer ranks).
  if (nCountSkillPoints > nBaseSkillPoints)
  {
    Error(CHECKER, GetName(oPC) + " has illegal number of skill points ("
     + IntToString(nCountSkillPoints) + ") - should have no more than " +
                                                 IntToString(nBaseSkillPoints));
    miBootAndBanPC(oPC);
    return;
  }

  // Add more checks here, if we think of any.
  SendMessageToPC(oPC, "Character is legal.");
}

void main()
{
  miCheckIfCharacterIsLegal_3(OBJECT_SELF);
}
