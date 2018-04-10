//::///////////////////////////////////////////////
//:: Execute: Caster Level
//:: hrt_staticvfx
//:://////////////////////////////////////////////
/*
    Wrapper for AR_GetCasterLevel that can
    be called via an executed script. Used to
    bypass dependency issues with include files.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////

#include "mi_inc_spells"
#include "x2_inc_switches"

void main()
{
    SetExecutedScriptReturnValue(AR_GetCasterLevel());
}
