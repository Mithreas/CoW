int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    if (GetLocalObject(OBJECT_SELF, "GS_TATTOO_TARGET") == oSpeaker) return TRUE;

    if (GetGold(oSpeaker) >= 250)
    {
        TakeGoldFromCreature(250, oSpeaker, TRUE);
        SetLocalObject(OBJECT_SELF, "GS_TATTOO_TARGET", oSpeaker);
        return TRUE;
    }

    return FALSE;
}
