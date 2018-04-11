//::///////////////////////////////////////////////
//:: Starting Conditional: Associate Guard (False)
//:: dsc_assocguardf
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker's associate guard
    flag is disabled.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////

#include "gs_inc_combat"

int StartingConditional()
{
    return !GetIsAssociateGuardEnabled(GetPCSpeaker());
}
