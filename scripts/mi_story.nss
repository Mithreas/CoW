int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nBluff = GetSkillRank(SKILL_BLUFF, oPC);
  int nPerform = GetSkillRank(SKILL_PERFORM, oPC);
  int nPersuade = GetSkillRank(SKILL_PERSUADE, oPC);
  int nSuccess;

  if ((nBluff > nPerform + 5) && (nBluff + 5 > nPersuade))
  {
    nSuccess = GetIsSkillSuccessful(oPC, SKILL_BLUFF, 15);
  }
  else if ((nPersuade > nPerform + 10) && (nPersuade >= nBluff + 5))
  {
    nSuccess = GetIsSkillSuccessful(oPC, SKILL_PERSUADE, 20);
  }
  else
  {
    nSuccess = GetIsSkillSuccessful(oPC, SKILL_PERFORM, 10);
  }

  if (nSuccess)
  {
    // XP reward
    GiveXPToCreature(oPC, 500);
  }
  else
  {
    // Smaller XP reward.
    GiveXPToCreature(oPC, 250);
  }

  return nSuccess;
}
