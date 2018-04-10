int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    if (GetGold(oSpeaker) >= 100)
    {
        AssignCommand(oSpeaker, TakeGoldFromCreature(100, oSpeaker, TRUE));
        return TRUE;
    }

    return FALSE;
}
