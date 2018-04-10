//::///////////////////////////////////////////////
//:: Heartbeat: Static VFX
//:: hrt_staticvfx
//:://////////////////////////////////////////////
/*
    Heartbeat for the static VFX placeable
    created with CreateNonStackingPersistentAoE
    in the inc_spells library. Destroys the
    placeable if the AoE no longer exists
    (e.g. was dispelled).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////

#include "inc_spells"

void main()
{
    if(!GetIsObjectValid(GetStaticVFXPartner(OBJECT_SELF)))
    {
        DestroyObject(OBJECT_SELF);
    }
}
