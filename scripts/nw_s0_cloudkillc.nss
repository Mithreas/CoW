#include "gs_inc_spell"
#include "X0_I0_SPELLS"
#include "inc_generic"

void ApplyConstitutionDamage(object oTarget, int nDamage);

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    effect eEffect;
    effect eVisual = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    float fDelay   = 0.0;
    int nSpell     = gsSPGetSpellID();
    int nMetaMagic = GetMetaMagicFeat();
    int nConDamage;

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if ((GetResRef(oTarget) != "gs_placeable016") && !GetIsCorpse(oTarget) && gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget))
        {
            fDelay = gsSPGetRandomDelay();

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

            //resistance check
            //if (! gsSPResistSpell(oCaster, oTarget, nSpell, fDelay))
            //{
                if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
                    gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                }
                else
                {
                    //apply
                    eEffect =
                        EffectLinkEffects(
                            eVisual,
                            EffectDamage(
                                gsSPGetDamage(1, 10, nMetaMagic),
                                DAMAGE_TYPE_ACID));

                    DelayCommand(fDelay, gsSPApplyEffect(oTarget, eEffect, nSpell));
                    nConDamage = d4() + 1;
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POISON, GetAreaOfEffectCreator(), fDelay))
                        nConDamage /= 2;
                    // Reassign this command to allow fortitude penalties to stack.
                    DelayCommand(fDelay, AssignCommand(oTarget, ApplyConstitutionDamage(oTarget, nConDamage)));
                }
            //}
        }

        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void ApplyConstitutionDamage(object oTarget, int nDamage)
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage), oTarget);
}
