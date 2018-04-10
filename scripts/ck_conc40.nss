int StartingConditional()
{


    int bSuccessful = d20() + GetSkillRank(SKILL_CONCENTRATION, GetPCSpeaker()) >= 40;

    if (!bSuccessful)
        return FALSE;

    return TRUE;
}
