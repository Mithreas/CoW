#include "inc_craft"
#include "inc_text"
#include "inc_customspells"
#include "nw_i0_spells"
#include "x2_i0_spells"

// Changing it so that Darkfire simply aborts rather than replacing an existing property.


void main()
{
    if (! X2PreSpellCastCode())         return;

    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration    = nCasterLevel * 2;
    int nMetaMagic   = AR_GetMetaMagicFeat();

    if (nCasterLevel > 20)              nCasterLevel  = 20;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nCasterLevel += 2;
	
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration    *=  2;

    object oItem     = IPGetTargetedOrEquippedMeleeWeapon();
    int bFails = FALSE;

    if (GetIsObjectValid(oItem))
    {
        if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
        {
          if (!gsCRGetEssenceApplySuccess(oItem))
          {
            SendMessageToPC(OBJECT_SELF, "The item fails to hold the enchantment.");
            return;
          }
        }
        else if (!gSPGetCanCastWeaponBuff(oItem))
        {
          FloatingTextStringOnCreature(GS_T_16777330, OBJECT_SELF, FALSE);
          return;
        }

        int nValue              = 0;
        itemproperty ipProperty              = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipProperty))
        {
            if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_TEMPORARY)
            {
                switch (GetItemPropertyType(ipProperty))
                {
                case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                case ITEM_PROPERTY_HOLY_AVENGER:
                case ITEM_PROPERTY_KEEN:
                    bFails = TRUE;
                    break;

                case ITEM_PROPERTY_ONHITCASTSPELL:
                    nValue = GetItemPropertySubType(ipProperty);

                    if (nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE ||
                        nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE)
                    {
                        bFails = TRUE;
                    }

                    break;

                case ITEM_PROPERTY_VISUALEFFECT:
                    nValue = GetItemPropertySubType(ipProperty);

                    if (nValue == ITEM_VISUAL_FIRE)
                    {
                        bFails = TRUE;
                    }

                    break;
                }
            }

            ipProperty = GetNextItemProperty(oItem);
        }

        if (bFails) {
            FloatingTextStringOnCreature("Targeted weapon already has magical properties.", OBJECT_SELF, FALSE);
            return;
        }

        object oPossessor = GetItemPossessor(oItem);
        float fDuration   = TurnsToSeconds(nDuration);

        SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectVisualEffect(VFX_IMP_FLAME_M),
                EffectVisualEffect(VFX_IMP_PULSE_FIRE)),
            oPossessor);
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            oPossessor,
            fDuration);

        IPSafeAddItemProperty(
            oItem,
            ItemPropertyOnHitCastSpell(127, nCasterLevel),
            fDuration,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        IPSafeAddItemProperty(
            oItem,
            ItemPropertyVisualEffect(ITEM_VISUAL_FIRE),
            fDuration,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
            FALSE,
            TRUE);
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
    }
}
