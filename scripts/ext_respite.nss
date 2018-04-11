//::///////////////////////////////////////////////
//:: ext_respite
//:: On Exit: Respite
//:://////////////////////////////////////////////
/*
    Handler for creatures exiting the area
    of a -respite AoE. Removes respite effects
    and procs healing for allies on expiration
    of the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////

#include "inc_effect"
#include "inc_healer"

// Handles healing for allies on expiration of the -respite AoE.
void EndRespite();

void main()
{
    float fTimeRemaining = GetAoEDurationRemaining();
    object oExiting = GetExitingObject();

    SetImmortal(oExiting, GetLocalInt(oExiting, "DefaultImmortalFlag"));
    RemoveTaggedEffects(oExiting, EFFECT_TAG_RESPITE);

    if(GetIsAoEExpiring())
    {
        EndRespite();
    }
}

//::///////////////////////////////////////////////
//:: EndRespite
//:://////////////////////////////////////////////
/*
    Handles healing for allies on expiration
    of the -respite AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////
void EndRespite()
{
    object oCaster = GetAreaOfEffectCreator();

    if(!GetIsObjectValid(oCaster)) return;

    object oTarget = GetFirstInPersistentObject();
    int nHeal = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) * 5;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsEnemy(oTarget, oCaster))
        {
            ApplyHealToObject(nHeal, oTarget, oCaster);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_G), oTarget);
        }
        oTarget = GetNextInPersistentObject();
    }
}
