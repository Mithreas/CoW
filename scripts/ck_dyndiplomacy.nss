int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // First we check the NPC for local variables corresponding to
    // the DC values for skill checks.
    int nCheckIntimidate = GetLocalInt(OBJECT_SELF, "CK_CONV_INTIMIDATE");
    int nCheckPersuade = GetLocalInt(OBJECT_SELF, "CK_CONV_PERSUADE");
    int nCheckBluff = GetLocalInt(OBJECT_SELF, "CK_CONV_BLUFF");
    int nCheckPerform = GetLocalInt(OBJECT_SELF, "CK_CONV_PERFORM");
    int nCheckAppraise = GetLocalInt(OBJECT_SELF, "CK_CONV_APPRAISE");
    int nCheckTaunt = GetLocalInt(OBJECT_SELF, "CK_CONV_TAUNT");

    // Then we gather PC base skill ranks in each.
    int nRankIntimidate = GetSkillRank(SKILL_INTIMIDATE, oPC);
    int nRankPersuade = GetSkillRank(SKILL_PERSUADE, oPC);
    int nRankBluff = GetSkillRank(SKILL_BLUFF, oPC);
    int nRankPerform = GetSkillRank(SKILL_PERFORM, oPC);
    int nRankAppraise = GetSkillRank(SKILL_APPRAISE, oPC);
    int nRankTaunt = GetSkillRank(SKILL_TAUNT, oPC);

    if(GetHasFeat(FEAT_EPIC_REPUTATION, oPC))
    {
        nRankIntimidate = nRankIntimidate + 10;
        nRankPersuade = nRankPersuade + 10;
        nRankBluff = nRankBluff + 10;
        nRankPerform = nRankPerform + 10;
        nRankAppraise = nRankAppraise + 10;
        nRankTaunt = nRankTaunt + 10;
    }

    int nResult = FALSE;

    // If any of these checks don't have the associated Vars on
    // their NPCs, we're not going to bother testing the skills.
    if(nCheckIntimidate != 0)
    {
        if(nRankIntimidate >= nCheckIntimidate) nResult = TRUE;
    }
    if(nCheckPersuade != 0)
    {
        if(nRankPersuade >= nCheckPersuade) nResult = TRUE;
    }
    if(nCheckBluff != 0)
    {
        if(nRankBluff >= nCheckBluff) nResult = TRUE;
    }
    if(nCheckPerform != 0)
    {
        if(nRankPerform >= nCheckPerform) nResult = TRUE;
    }
    if(nCheckAppraise != 0)
    {
        if(nRankAppraise >= nCheckAppraise) nResult = TRUE;
    }
    if(nCheckTaunt != 0)
    {
        if(nRankTaunt >= nCheckTaunt) nResult = TRUE;
    }
    return nResult;
}
