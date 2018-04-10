int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetIsPC(oSpeaker) && GetAlignmentGoodEvil(oSpeaker) == ALIGNMENT_GOOD;
}
