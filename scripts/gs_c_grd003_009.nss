int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nLevel      = GetHitDice(oSpeaker);

    return nLevel < 5;
}
