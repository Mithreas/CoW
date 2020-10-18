int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetIsPC(oSpeaker) && GetRacialType(oSpeaker) == RACIAL_TYPE_ELF;
}