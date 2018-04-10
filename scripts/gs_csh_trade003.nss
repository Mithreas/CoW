void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");

    DeleteLocalObject(oSpeaker, "GS_SH_ITEM");
    DeleteLocalInt(oItem, "GS_SH_FLAG");
}
