int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nPersuadeDC = GetLocalInt(OBJECT_SELF, "GS_PERSUADE_DC");

    if (! nPersuadeDC)
    {
        nPersuadeDC = Random(21) + 10;
        SetLocalInt(OBJECT_SELF, "GS_PERSUADE_DC", nPersuadeDC);
    }

    if (GetIsSkillSuccessful(oSpeaker, SKILL_PERSUADE, nPersuadeDC))
    {

        return TRUE;
    }

    return FALSE;
}
