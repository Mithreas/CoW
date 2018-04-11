//::///////////////////////////////////////////////
//:: Spell Cast At: Teach Stream
//:: sca_teachstream
//:://////////////////////////////////////////////
/*
    Teaches a summon stream to the caster if
    the correct spell was cast at this object.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2017
//:://////////////////////////////////////////////

#include "inc_sumstream"

void main()
{
    int nSpell = GetLastSpell();
    int nStreamElement = GetLocalInt(OBJECT_SELF, "TEACH_STREAM_ELEMENT");
    int nStreamType = GetLocalInt(OBJECT_SELF, "TEACH_STREAM_TYPE");
    int nTargetSpell = GetLocalInt(OBJECT_SELF, "TEACH_STREAM_KEY");
    int nVFX = GetLocalInt(OBJECT_SELF, "TEACH_STREAM_VFX");
    object oCaster = GetLastSpellCaster();

    if(nSpell == nTargetSpell)
    {
        AddKnownSummonStream(oCaster, nStreamType, nStreamElement);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), GetLocation(OBJECT_SELF));
    }
    else
    {
        FloatingTextStringOnCreature("Your spell has no effect.", oCaster, FALSE);
    }
}
