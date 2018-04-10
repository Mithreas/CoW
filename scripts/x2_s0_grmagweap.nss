#include "gs_inc_text"
#include "mi_inc_spells"
#include "nw_i0_spells"
#include "x2_i0_spells"

// Changing it so that Magic Weapon simply aborts rather than replacing an existing property.

void main()
{
    if (! X2PreSpellCastCode())         return;

    int nDuration    = AR_GetCasterLevel(OBJECT_SELF);
    int nCasterLevel = nDuration / 3;
    int nMetaMagic   = AR_GetMetaMagicFeat();

    if(nCasterLevel > 5)                nCasterLevel  = 5;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration    *= 2;

    object oItem     = IPGetTargetedOrEquippedMeleeWeapon();
    int bFails = FALSE;

    if (GetIsObjectValid(oItem))
    {
        if (!gSPGetCanCastWeaponBuff(oItem))
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
        float fDuration   = HoursToSeconds(nDuration);

        SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
            oPossessor);
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            oPossessor,
            fDuration);

        IPSafeAddItemProperty(
            oItem,
            ItemPropertyEnhancementBonus(nCasterLevel),
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
