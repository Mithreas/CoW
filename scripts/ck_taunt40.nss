int StartingConditional()
{
//testing
//return TRUE;

    int iResult;
    object oPC = GetPCSpeaker();

    iResult = GetSkillRank(SKILL_TAUNT, oPC) >= 40;
    return iResult;
}

