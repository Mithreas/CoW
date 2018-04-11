//::///////////////////////////////////////////////
//:: ent_respite
//:: On Enter: Respite
//:://////////////////////////////////////////////
/*
    Handler for creatures entering the area
    of a -respite AoE. Applies respite effects
    and immortality.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////

#include "inc_effect"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oEntering = GetEnteringObject();
    effect eRespite = GetIsEnemy(oEntering, oCaster) ? EffectVisualEffect(VFX_DUR_GLOW_WHITE) : EffectVisualEffect(VFX_DUR_GLOW_LIGHT_YELLOW);

    if(!GetHasTaggedEffect(oEntering, EFFECT_TAG_RESPITE))
    {
        SetLocalInt(oEntering, "DefaultImmortalFlag", GetImmortal(oEntering));
    }
    SetImmortal(oEntering, TRUE);

    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_DAZED));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_FEAR));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_SLEEP));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_SLOW));
    eRespite = EffectLinkEffects(eRespite, EffectImmunity(IMMUNITY_TYPE_STUN));

    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, eRespite, oEntering, 0.0, EFFECT_TAG_RESPITE | EFFECT_TAG_CROWD_CONTROL_IMMUNITY);
}
