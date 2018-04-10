#include "gs_inc_state"
#include "gs_inc_text"
#include "mi_inc_poison"

void gsDrink(int nQuality, object oWell)
{
    gsSTAdjustState(GS_ST_WATER, 50.0);
    object oPC = OBJECT_SELF;

    if (Random(100) >= nQuality)
    {
        effect eEffect = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DISEASE_S),
                                           EffectDisease(DISEASE_FILTH_FEVER));

        AssignCommand(oWell,
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC));
    }

    // Poison!
    int nPoison = GetLocalInt(oWell, VAR_POISON_TYPE);
    if (nPoison)
    {
      int nQty = GetLocalInt(oWell, VAR_POISON_QTY);
      if (Random(100) < nQty)
      {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoison), oPC);
      }
    }
}
//----------------------------------------------------------------
void main()
{
    object oUser = GetLastUsedBy();
    object oWell = OBJECT_SELF;
    int nQuality = GetLocalInt(oWell, "GS_QUALITY");

    //AssignCommand(oUser, ActionSpeakString(GS_T_16777236));
    AssignCommand(oUser, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    AssignCommand(oUser, ActionDoCommand(gsDrink(nQuality, oWell)));
}
