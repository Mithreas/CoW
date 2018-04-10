//::///////////////////////////////////////////////
//:: Tailoring - Turning Listening On
//:: tlr_listenon.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////
void main()
{
    SetListenPattern(OBJECT_SELF, "**", 8888);
    SetListening(OBJECT_SELF, TRUE);
    SetLocalObject(OBJECT_SELF, "tlr_Client", GetPCSpeaker());
}
