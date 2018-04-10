//::///////////////////////////////////////////////
//:: Mage Armor
//:: [NW_S0_MageArm.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the target +1 AC Bonus to Deflection,
    Armor Enchantment, Natural Armor and Dodge.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/

#include "nw_i0_spells"

#include "mi_inc_spells"
#include "mi_inc_spllswrd"

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
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC1, eAC2, eAC3, eAC4;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR, FALSE));

    // Do nothing if the target is a Spellsword and the caster is not the target.
    if (oCaster != oTarget && miSSGetIsSpellsword(oTarget)) {
        if (GetHasSpellEffect(SPELL_MAGE_ARMOR, oTarget) ||  GetHasSpellEffect(SPELL_EPIC_MAGE_ARMOR, oTarget))
            return;
    }

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int nChar = GetCharacterLevel(oCaster);
    int nOther = nChar - nWizard;
    int nAC = 1;
    if (miSSGetIsSpellsword(oCaster) && (oCaster == oTarget) && (nWizard > nOther))
    {
        RemoveEffectsFromSpell(oTarget, SPELL_EPIC_MAGE_ARMOR);
        if ( nWizard >= 15 )
        {
            nAC = 3;
        }
        else if ( nWizard >= 8 )
        {
            nAC = 2;
        }
    }

    //Set the four unique armor bonuses
    eAC1 = EffectACIncrease(nAC, AC_ARMOUR_ENCHANTMENT_BONUS);
    eAC2 = EffectACIncrease(nAC, AC_DEFLECTION_BONUS);
    eAC3 = EffectACIncrease(nAC, AC_DODGE_BONUS);
    eAC4 = EffectACIncrease(nAC, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAC1, eAC2);
    eLink = EffectLinkEffects(eLink, eAC3);
    eLink = EffectLinkEffects(eLink, eAC4);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);
    RemoveEffectsFromSpell(oTarget, 347); // Shadow Conjured mage armor

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
