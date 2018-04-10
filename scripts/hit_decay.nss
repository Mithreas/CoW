//::///////////////////////////////////////////////
//:: On Hit: Decay
//:: hit_decay
//:://////////////////////////////////////////////
/*
    Handles the decay weapon effect: enemies struck
    twice by the weapon within six seconds take
    an additional 1d6+6 points of negative energy
    damage and the wielder is healed for 5
    points.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

#include "inc_time"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    effect eImpact = EffectVisualEffect(VFX_IMP_DISEASE_S);
    string sTargetId = ObjectToString(oTarget);
    int nCurrentTime = GetModuleTime();
    int nLastTime = GetLocalInt(oCaster, "DecayTriggered" + sTargetId);

    if(nCurrentTime - nLastTime <= 6)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(1) + 6, DAMAGE_TYPE_NEGATIVE), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(5), oCaster);
        DeleteLocalInt(oCaster, "DecayTriggered" + sTargetId);
    }
    else
    {
        SetLocalInt(oCaster, "DecayTriggered" + sTargetId, nCurrentTime);
    }
}
