//::///////////////////////////////////////////////
//:: Starting Conditional: Associate Guard (True)
//:: dsc_assocguardt
//:://////////////////////////////////////////////
/*
    Returns TRUE if the speaker's associate guard
    flag is enabled.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 25, 2017
//:://////////////////////////////////////////////

#include "inc_combat"

int StartingConditional()
{
    return GetIsAssociateGuardEnabled(GetPCSpeaker());
}
