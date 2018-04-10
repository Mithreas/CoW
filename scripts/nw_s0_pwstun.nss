//::///////////////////////////////////////////////
//:: [Power Word Stun]
//:: [NW_S0_PWStun.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature is stunned for a certain number of
    rounds depending on its HP.  No save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.28
- =151HP stunned for 4d4 rounds
- >151HP sometimes stunned for indefinit duration
*/


#include "nw_i0_spells"
#include "mi_inc_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHP =  GetCurrentHitPoints(oTarget);
    effect eStun = EffectStunned();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eMind, eStun);
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eWord = EffectVisualEffect(VFX_FNF_PWSTUN);
    int nDuration;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDC = AR_GetSpellSaveDC();
    int nMeta, nWillResult;
    //Apply the VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, GetSpellTargetLocation());
    //Determine the number rounds the creature will be stunned
    // if (nHP >= 151)
    // {
    //     nDuration = 0;
    //     nMeta = 0;
    // }
    // else if (nHP >= 101 && nHP <= 150)
    if (nHP >= 101)
    {
        nDuration = d4(1);
        nMeta = 4;
    }
    else if (nHP >= 51  && nHP <= 100)
    {
        nDuration = d4(2);
        nMeta = 8;
    }
    else
    {
        nDuration = d4(4);
        nMeta = 16;
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDuration = nMeta;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_STUN));
        //Make an SR check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if (nHP >= 151) {
                if (nHP < 301)
                    nDC++;
                if (nHP < 251)
                    nDC++;
                if (nHP < 201)
                    nDC++;

                nWillResult =  WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS);
            } else
                nWillResult = 0;

            if (nWillResult == 0) {
                //Apply linked effect and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
}

