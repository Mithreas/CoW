int StartingConditional()
{
    return GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "GS_HEAD_EVIL_50")) ||
           GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "GS_HEAD_EVIL_100")) ||
           GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "GS_HEAD_EVIL_200")) ||
           GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "GS_HEAD_EVIL_400")) ||
           GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "GS_HEAD_EVIL_800"))
    ;
}
