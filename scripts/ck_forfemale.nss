int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    return GetIsPC(oSpeaker) &&
           GetGender(oSpeaker) == GENDER_FEMALE;
}
