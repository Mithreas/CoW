//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +12 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003

//::  UPDATE Mars 12. 2017, ActionReplay:
//::  Creatures immune to Mind Spells or Stun will be Immobilized instead

#include "x0_i0_spells"
#include "mi_inc_spells"
#include "x2_i0_spells"
#include "inc_spells"

int nSpellID = 462;

void RunHandImpact(object oTarget, object oCaster)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nCasterModifiers = GetCasterAbilityModifier(oCaster) + AR_GetCasterLevel(oCaster);
    int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
    int nTargetRoll = GetAC(oTarget);
    if (nCasterRoll >= nTargetRoll)
    {
       int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID));

       int nDam  = MaximizeOrEmpower(8, 1, AR_GetMetaMagicFeat(), 11);
       effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
       effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

       if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
       {
           effect eKnockdown = EffectStunned();

            //:: Creatures immune to mind spell are still prevented from moving
            //:: Will not affect targets immune to movement speed decrease
            //:: E.g Freedom of Movement spell
            if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE) &&
                (GetIsImmune(oTarget, IMMUNITY_TYPE_STUN) ||
                 GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)) )
           {
                eKnockdown = EffectCutsceneImmobilize();
           }

           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(1));
       }

      DelayCommand(6.0f,RunHandImpact(oTarget,oCaster));

   }
}



void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check mi_inc_spells.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));
        int nResult = MyResistSpell(OBJECT_SELF, oTarget);

        if(nResult  == 0)
        {
            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // GetSpellSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), AR_GetSpellSaveDC());
            object oSelf = OBJECT_SELF;
            RunHandImpact(oTarget,OBJECT_SELF );

        }
    }
}

