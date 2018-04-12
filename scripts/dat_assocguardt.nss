//::///////////////////////////////////////////////
//:: Actions Taken: Associate Guard (True)
//:: dat_assocguardt
//:://////////////////////////////////////////////
/*
    Sets the associate guard flag for the speaker
    to TRUE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////

#include "inc_combat"

void main()
{
    SetIsAssociateGuardEnabled(GetPCSpeaker(), TRUE);
}
