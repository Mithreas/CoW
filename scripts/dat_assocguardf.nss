//::///////////////////////////////////////////////
//:: Actions Taken: Associate Guard (False)
//:: dat_assocguardf
//:://////////////////////////////////////////////
/*
    Sets the associate guard flag for the speaker
    to FALSE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////

#include "gs_inc_combat"

void main()
{
    SetIsAssociateGuardEnabled(GetPCSpeaker(), FALSE);
}
