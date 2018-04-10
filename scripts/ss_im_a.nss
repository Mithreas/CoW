/*
  Spellsword Imbue Armour Ability
  Adds a one-time cast on hit spell to armour (defensive only)
*/
#include "nw_i0_spells"

#include "mi_inc_spells"

#include "mi_inc_spllswrd"

void main()
{
    int bFeedback = TRUE;

    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    object oHide = gsPCGetCreatureHide(oSpellOrigin);
    int SpellID = miSSGetIASpell(oHide); //oItem);

    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin);

    if (GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "MI_BLOCKEDSCHOOL2") == 7)
    {
        SendMessageToPC(oSpellOrigin, "SS_IM_A entered: " + IntToString(SpellID));
    }
    //Check Valid Spell and remove item property if not
    if (SpellID == -1)
    {
        //itemproperty ipLoop = GetFirstItemProperty(oItem);

        //while (GetIsItemPropertyValid(ipLoop))
        //{
        //    if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL)
        //    {
        //        RemoveItemProperty(oItem, ipLoop);
        //    }
        //    ipLoop=GetNextItemProperty(oItem);
        //}
        return;
    }

    string sSpell = "";
        //cast spell
    switch(SpellID)
    {
        case SPELL_SHIELD:
        {
            sSpell = "Shield";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

            effect eArmor = EffectACIncrease(4, AC_DEFLECTION_BONUS);
            effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
            effect eSpell2 = EffectSpellImmunity(SPELL_ISAACS_LESSER_MISSILE_STORM);
            effect eSpell3 = EffectSpellImmunity(SPELL_ISAACS_GREATER_MISSILE_STORM);
            effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

            effect eLink = EffectLinkEffects(eArmor, eDur);
            eLink = EffectLinkEffects(eLink, eSpell);

            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION) ||
                GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION))
            {
              eLink = EffectLinkEffects(eLink, eSpell2);
              eLink = EffectLinkEffects(eLink, eSpell3);
            }
            else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION))
            {
              eLink = EffectLinkEffects(eLink, eSpell2);
            }

            int nDuration = AR_GetCasterLevel(oSpellOrigin); // * Duration 1 turn
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, 417, FALSE));

            RemoveEffectsFromSpell(oSpellOrigin, GetSpellId());

            //Apply VFX impact and bonus effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
            break;
        }
        case SPELL_MAGE_ARMOR:
        {
            sSpell = "Mage Armour";
            //Declare major variables
            object oTarget = oSpellOrigin;
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            int nMetaMagic = AR_GetMetaMagicFeat();
            effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            effect eAC1, eAC2, eAC3, eAC4;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_MAGE_ARMOR, FALSE));
            //Check for metamagic extend
            if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
            {
                 nDuration = nDuration * 2;
            }

            int nAC = 1;
            if (miSSGetIsSpellsword(oSpellOrigin) && AR_GetCasterLevel(oSpellOrigin) >= 13)
            {
                nAC = 3;
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
            break;
        }

        case SPELL_MESTILS_ACID_SHEATH:
        {
            if (gsSPGetOverrideSpell()) return;
            sSpell = "Acid Sheath";
            object oTarget   = oSpellOrigin;
            effect eEffect;
            int nSpell       = GetSpellId();
            int nCasterLevel = AR_GetCasterLevel(oSpellOrigin);
            int nDamage      = nCasterLevel * 2;
            int nDuration    = nCasterLevel;

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, nSpell, FALSE));

            //affection check
            if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, oSpellOrigin, oTarget)) return;

            //remove damage shield
            if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_DEATH_ARMOR);
            }

            if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_ELEMENTAL_SHIELD);
            }

            if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_MESTILS_ACID_SHEATH);
            }

            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(448),
                        EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID)));

            gsSPApplyEffect(
                oTarget,
                eEffect,
                nSpell,
                RoundsToSeconds(nDuration));
            break;
        }
        case SPELL_ELEMENTAL_SHIELD:
        {
            if (gsSPGetOverrideSpell()) return;
            sSpell = "Elemental Shield";
            object oTarget   = oSpellOrigin;
            effect eEffect;
            int nSpell       = GetSpellId();
            int nCasterLevel = AR_GetCasterLevel(oSpellOrigin);
            int nDamage      = nCasterLevel;
            int nDuration    = nCasterLevel;

            //raise event
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, nSpell, FALSE));

            //affection check
            if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, oSpellOrigin, oTarget)) return;

            //remove damage shield
            if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_DEATH_ARMOR);
            }

            if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_ELEMENTAL_SHIELD);
            }

            if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))
            {
                gsSPRemoveEffect(oTarget, SPELL_MESTILS_ACID_SHEATH);
            }

            //apply
            eEffect =
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD),
                            EffectLinkEffects(
                                EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE),
                                EffectLinkEffects(
                                    EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50),
                                    EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50)))));

            gsSPApplyEffect(
                oTarget,
                eEffect,
                nSpell,
                RoundsToSeconds(nDuration));
            break;
        }
        case SPELL_STONESKIN:
        {
            sSpell = "Stoneskin";
            effect eStone;
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
            effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            effect eLink;
            int nAmount = AR_GetCasterLevel(oSpellOrigin) * 10;
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            object oTarget = oSpellOrigin;

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_STONESKIN, FALSE));
            //Limit the amount protection to 100 points of damage
            if (nAmount > 100)
            {
                nAmount = 100;
            }
            //Define the damage reduction effect
            eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
            //Link the effects
            eLink = EffectLinkEffects(eStone, eVis);
            eLink = EffectLinkEffects(eLink, eDur);

            RemoveEffectsFromSpell(oSpellOrigin, SPELL_STONESKIN);

            //Apply the linked effects.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));

            break;
        }
        case SPELL_GREATER_STONESKIN:
        {
            //Declare major variables
            sSpell = "Greater Stoneskin";
            int nAmount = AR_GetCasterLevel(oSpellOrigin);
            int nDuration = nAmount;
            object oTarget = oSpellOrigin;

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_GREATER_STONESKIN, FALSE));

            if (nAmount > 15)
            {
                nAmount = 15;
            }
            int nDamage = nAmount * 10;

            effect eVis2 = EffectVisualEffect(VFX_IMP_POLYMORPH);
            effect eStone = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, nDamage);
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            //Link the texture replacement and the damage reduction effect
            effect eLink = EffectLinkEffects(eVis, eStone);
            eLink = EffectLinkEffects(eLink, eDur);

            //Remove effects from target if they have Greater Stoneskin cast on them already.
            RemoveEffectsFromSpell(oTarget, SPELL_GREATER_STONESKIN);

            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
            break;
        }
        case SPELL_PREMONITION:
        {
            object oTarget = oSpellOrigin;
            sSpell = "Premonition";
            //Declare major variables
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            int nLimit = nDuration * 10;
            effect eStone = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
            effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
            //Link the visual and the damage reduction effect
            effect eLink = EffectLinkEffects(eStone, eVis);
            //Enter Metamagic conditions
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_PREMONITION, FALSE));

            RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
            //Apply the linked effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
            break;
        }
        case SPELL_GHOSTLY_VISAGE:
        {
            //Declare major variables
            sSpell = "Ghostly Visage";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
            effect eDam = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
            effect eSpell = EffectSpellLevelAbsorption(1);
            effect eConceal = EffectConcealment(10);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eLink = EffectLinkEffects(eDam, eVis);
            eLink = EffectLinkEffects(eLink, eSpell);
            eLink = EffectLinkEffects(eLink, eConceal);
            eLink = EffectLinkEffects(eLink, eDur);
            int nMetaMagic = AR_GetMetaMagicFeat();
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_GHOSTLY_VISAGE, FALSE));

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
            break;
        }
        case SPELL_ETHEREAL_VISAGE:
        {
            sSpell = "Ethereal Visage";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
            effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);
            effect eSpell = EffectSpellLevelAbsorption(2);
            effect eConceal = EffectConcealment(25);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            effect eLink = EffectLinkEffects(eDam, eVis);
            eLink = EffectLinkEffects(eLink, eSpell);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = EffectLinkEffects(eLink, eConceal);

            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            //Enter Metamagic conditions
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_ETHEREAL_VISAGE, FALSE));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            break;
        }
        case SPELL_LESSER_SPELL_MANTLE:
        {
            sSpell = "Lesser Spell Mantle";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            int nAbsorb = d4() + 6;

            //Link Effects
            effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
            effect eLink = EffectLinkEffects(eVis, eAbsob);
            eLink = EffectLinkEffects(eLink, eDur);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_LESSER_SPELL_MANTLE, FALSE));
            RemoveEffectsFromSpell(oTarget, GetSpellId());
            RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
            RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

            break;
        }
        case SPELL_SPELL_MANTLE:
        {
            sSpell = "Spell Mantle";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            int nAbsorb = d8() + 8;

            //Link Effects
            effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
            effect eLink = EffectLinkEffects(eVis, eAbsob);
            eLink = EffectLinkEffects(eLink, eDur);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_SPELL_MANTLE, FALSE));

            RemoveEffectsFromSpell(oTarget, GetSpellId());
            RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
            RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            break;
        }
        case SPELL_GREATER_SPELL_MANTLE:
        {
            sSpell = "Greater Spell Mantle";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            int nAbsorb = d12() + 10;

            //Link Effects
            effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
            effect eLink = EffectLinkEffects(eVis, eAbsob);
            eLink = EffectLinkEffects(eLink, eDur);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_GREATER_SPELL_MANTLE, FALSE));
            RemoveEffectsFromSpell(oTarget, GetSpellId());
            RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
            RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

            break;
        }
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY:
        {
            sSpell = "Minor Globe of Invulnerability";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eSpell = EffectSpellLevelAbsorption(3, 0);
            //Link Effects
            effect eLink = EffectLinkEffects(eVis, eSpell);
            eLink = EffectLinkEffects(eLink, eDur);
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_MINOR_GLOBE_OF_INVULNERABILITY, FALSE));

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            break;
        }
        case SPELL_GLOBE_OF_INVULNERABILITY:
        {
            sSpell = "Globe of Invulnerability";
            object oTarget = oSpellOrigin;
            effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eSpell = EffectSpellLevelAbsorption(4, 0);
            //Link Effects
            effect eLink = EffectLinkEffects(eVis, eSpell);
            eLink = EffectLinkEffects(eLink, eDur);
            int nDuration = AR_GetCasterLevel(oSpellOrigin);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oSpellOrigin, SPELL_GLOBE_OF_INVULNERABILITY, FALSE));

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

            break;
        }
        default:
        {
        break;
        }
    }

    if(bFeedback) SendMessageToPC(oSpellOrigin, "The armour discharges its spell: " + sSpell); //+ IntToString(SpellID));

    //remove item property
    SetLocalInt(oHide, "SS_IMBUE_ARMOUR_CH", -1);

    //itemproperty ipLoop = GetFirstItemProperty(oItem);

    //while (GetIsItemPropertyValid(ipLoop))
    //{
    //    if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL)
    //    {
    //        RemoveItemProperty(oItem, ipLoop);
    //    }
    //    ipLoop=GetNextItemProperty(oItem);
    //}
//    if(bFeedback) SendMessageToPC(oSpellOrigin, "Removed Spell Trigger: " + IntToString(SpellID));
    return;
}
