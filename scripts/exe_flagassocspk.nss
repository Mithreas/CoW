//::///////////////////////////////////////////////
//:: Executed Script: Flag Associate Speak
//:: exe_flagassocspk
//:://////////////////////////////////////////////
/*
    Flags the calling associate as one that can
    be spoken through by its master.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////

#include "inc_associates"

void main()
{
    SetCanMasterSpeakThroughAssociate(OBJECT_SELF);
}
