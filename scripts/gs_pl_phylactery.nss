#include "gs_inc_common"
#include "gs_inc_time"

void main()
{
    object oCreature = GetLocalObject(OBJECT_SELF, "GS_PHYLACTERY_CREATURE");

    if (GetIsObjectValid(oCreature))
    {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_HARM),
            oCreature);
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_PWKILL),
            OBJECT_SELF);
        SetImmortal(oCreature, FALSE);
    }

    gsCMCreateRecreator(gsTIGetActualTimestamp());
}
