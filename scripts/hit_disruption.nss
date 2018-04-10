//::///////////////////////////////////////////////
//:: On Hit: Disruption
//:: hit_disruption
//:://////////////////////////////////////////////
/*
    Handles the disruption weapon effect:
    enemies struck twice by the weapon within
    six seconds must make a DC 22 Fortitude
    save or be stunned for 1d6 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 2, 2016
//:://////////////////////////////////////////////

#include "inc_time"
#include "x0_i0_spells"

void main()
{
    object oCaster = OBJECT_SELF;

    // This property imbues a lot of persistent overhead. Let's not allow it
    // to be used by players.
    if(GetIsPC(oCaster) && !GetIsDM(oCaster)) return;

    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    effect eStun = ExtraordinaryEffect(EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED)));
    string sTargetId = ObjectToString(oTarget);
    int nCurrentTime = GetModuleTime();
    int nLastTime = GetLocalInt(oCaster, "DisruptionTriggered" + sTargetId);

    if(nCurrentTime - nLastTime <= 6)
    {
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 22, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(d6()));
        }
        DeleteLocalInt(oCaster, "DisruptionTriggered" + sTargetId);
    }
    else
    {
        SetLocalInt(oCaster, "DisruptionTriggered" + sTargetId, nCurrentTime);
    }
}
