//::///////////////////////////////////////////////
//:: Holy Aura
//:: NW_S0_HolyAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Aura versus Alignment is now an AoE spell with a Large radius.  Mind Immunity has been removed, replaced with +6
    Will versus opposed alignments and +3 Will versus neutrals.  An Aura versus Alignment spell offers +4 deflection AC
    against opposed alignments and neutral enemies, 5 + CL SR, and a damage shield of 6 + 1d8 damage.  The holy aura
    deals divine damage, while the unholy aura deals negative energy damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////
#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    object oTarget   = GetSpellTargetObject();
    int nSpell       = GetSpellId();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic   = AR_GetMetaMagicFeat();
    int nDuration    = nCasterLevel;
    float fDelay;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;


    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    // Defenses against Evil
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectACIncrease(4, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_EVIL));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 6), ALIGNMENT_ALL, ALIGNMENT_EVIL));
    // Defenses against Neutral
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectACIncrease(4, AC_DEFLECTION_BONUS), ALIGNMENT_ALL, ALIGNMENT_NEUTRAL));
    eLink = EffectLinkEffects(eLink, VersusAlignmentEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, 6), ALIGNMENT_ALL, ALIGNMENT_NEUTRAL));

    // SR
    eLink = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(5 + nCasterLevel));

    // Damage Shield
    eLink = EffectLinkEffects(eLink, EffectDamageShield(DAMAGE_BONUS_6, DAMAGE_BONUS_1d8, DAMAGE_TYPE_DIVINE));

    while (GetIsObjectValid(oTarget))
    {
        if(GetIsNeutral(oTarget) || GetIsFriend(oTarget)) {
            fDelay = GetRandomDelay();
            // Add safeguard against self-stacking.
            RemoveEffectsFromSpell(oTarget, nSpell);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
        }

        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE);
    }

    // doAura(ALIGNMENT_EVIL, VFX_DUR_PROTECTION_GOOD_MAJOR, VFX_DUR_PROTECTION_GOOD_MAJOR, DAMAGE_TYPE_DIVINE);
}

