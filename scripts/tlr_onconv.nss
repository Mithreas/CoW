//::///////////////////////////////////////////////
//:: Tailoring - on Conversation
//:: tlr_onconv.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On:March 9, 2004
//:://////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{

    // See if what we just 'heard' matches any of our
    // predefined patterns
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();

    if (nMatch == -1) {
        if (GetCommandable(OBJECT_SELF))
        {
            ClearAllActions();
            ActionStartConversation(oShouter, "", TRUE);
        }
    } else if (nMatch == 8888) {
        if (GetLocalObject(OBJECT_SELF, "tlr_Client") == oShouter) {
            SetLocalString(OBJECT_SELF, "tlr_Spoken", GetMatchedSubstring(0));
        }
    }
}
