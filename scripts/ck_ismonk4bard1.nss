int StartingConditional( )
{
    object oSpeaker = GetPCSpeaker( );

    return GetIsPC(oSpeaker) &&
           (GetIsDM(oSpeaker) ||
            GetLevelByClass(CLASS_TYPE_MONK, oSpeaker) >= 4 ||
            GetLevelByClass(CLASS_TYPE_BARD, oSpeaker) >= 1);
}
