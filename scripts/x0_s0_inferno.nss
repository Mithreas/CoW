//::///////////////////////////////////////////////
//:: Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 2d6 fire per round
    Duration: 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, 2003-Oct-19
//::            - VFX update
//::            - Spell no longer stacks with itself
//::            - Spell can now be dispelled
//::            - Spell is now much less cpu expensive


#include "X0_I0_SPELLS"
#include "mi_inc_spells"
#include "x2_i0_spells"

void RunImpact(object oTarget, object oCaster, int nMetamagic);

void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check mi_inc_spells.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_COMBUST,oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }

    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay      = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);
    effect eDur      = EffectVisualEffect(498);


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

    if(!MyResistSpell(OBJECT_SELF, oTarget))
    {
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f);


        //----------------------------------------------------------------------
        // Apply the VFX that is used to track the spells duration
        //----------------------------------------------------------------------
        DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration)));
        object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
        DelayCommand(fDelay+0.1f,RunImpact(oTarget, oSelf,nMetaMagic));
    }
    else
    {
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
    }

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(446,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        //::  With Transmutation Greater or Epic damage is changed as 1d6/4 Caster Level
        int nDices = 2;
        if ( GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCaster) || GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster) ) {
            int nCasterLevel = AR_GetCasterLevel(oCaster);
            nDices = nCasterLevel / 4;
        }

        int nDamage = MaximizeOrEmpower(6, nDices, nMetaMagic);

        //::  Save for Fire Damage
        //if ( MySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_FIRE, oCaster) ) {
        //    nDamage = nDamage * 0.5;
        //}

        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic));
    }
}

