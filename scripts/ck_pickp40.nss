int StartingConditional()
{
    int iResult;
    object oPC = GetPCSpeaker();

    iResult = GetSkillRank(SKILL_PICK_POCKET, oPC) >= 40;
    return iResult;
}

