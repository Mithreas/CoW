#include "inc_text"
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "inc_customspells"

void main()
{
    if (! X2PreSpellCastCode())         return;

    int nCasterLevel  = AR_GetCasterLevel(OBJECT_SELF);
    int nBonus = 2 + (nCasterLevel - 11) / 5;
    int nDuration = nCasterLevel * 2;  // Purposeful change.  Ranger Blade Thirst duration doubled.
    int nMetaMagic = AR_GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    object oItem   = IPGetTargetedOrEquippedMeleeWeapon();

    if (GetIsObjectValid(oItem))
    {

        // Ignore magic staffs
        if (GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF) {
            FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
            return;
        }

        if (GetMeleeWeapon(oItem) &&
            GetStringLeft(GetStringUpperCase(GetTag(oItem)),6) != "CA_GEN" )
        {
            object oPossessor = GetItemPossessor(oItem);
            float fDuration   = TurnsToSeconds(nDuration);

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
                ItemPropertyEnhancementBonus(nBonus),
                fDuration,
                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
                FALSE,
                TRUE);
//            IPSafeAddItemProperty(
//                oItem,
//                ItemPropertyVampiricRegeneration(nBonus),
//                fDuration,
//                X2_IP_ADDPROP_POLICY_KEEP_EXISTING,
//                FALSE,
//                TRUE);
			SetLocalString(oItem, "RUN_ON_HIT_1", GetStringLowerCase("im_w_bldthst"));
			AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nCasterLevel), oItem, fDuration);
			AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), oItem, fDuration);
        }
        else
        {
            FloatingTextStrRefOnCreature(83621, OBJECT_SELF, FALSE);
        }
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
    }
}
