//::///////////////////////////////////////////////
//:: Blackstaff
//:: X2_S0_Blckstff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  OLD: Adds +4 enhancement bonus, On Hit: Dispel.
  Arelith Specific:  Blackstaff has been completely rewritten.
  For details, see im_w_blackstaff
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 07, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_itemprop"
#include "mi_inc_spells"

/* OLD CODE
void AddBlackStaffEffectOnWeapon (object oTarget, float fDuration)
{
   IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(4), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE, TRUE);
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_16), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
   return;
}
*/

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check mi_inc_spells.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

       if (!GetIsObjectValid(oMyWeapon) || GetWeaponRanged(oMyWeapon)) {
              SendMessageToPC(OBJECT_SELF, "You must be wielding a melee weapon.");
              return;
        }

       if (GetItemPossessor(oMyWeapon) != OBJECT_SELF) {
              SendMessageToPC(OBJECT_SELF, "Blackstaff may only be cast on yourself or a weapon in your inventory.");
              return;
        }

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
       eDur = SupernaturalEffect(eDur);
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
       // Apply visual effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));

       // Account for up to two other on-hit scripts.  Spellsword imbue compatibility.
       string sOnHitNum = "RUN_ON_HIT_1";
       if (GetLocalString(oMyWeapon, "RUN_ON_HIT_1") != "" && GetLocalString(oMyWeapon, "RUN_ON_HIT_1") != "im_w_blackstaff") {
           sOnHitNum = "RUN_ON_HIT_2";
           if (GetLocalString(oMyWeapon, "RUN_ON_HIT_2") != "" && GetLocalString(oMyWeapon, "RUN_ON_HIT_2") != "im_w_blackstaff")
                     sOnHitNum = "RUN_ON_HIT_3";
        }
       SetLocalString(oMyWeapon, sOnHitNum, "im_w_blackstaff");

       // Apply on-hit script
       itemproperty iBSHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nDuration);

       // If weapon imbues already exist on this weapon, piggyback by doing nothing.
       if (!GetItemHasItemProperty(oMyWeapon, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER)) {
              AddItemProperty(DURATION_TYPE_TEMPORARY, iBSHit, oMyWeapon, RoundsToSeconds(nDuration));
       }
       SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

}

    /* OLD CODE
    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (GetBaseItemType(oMyWeapon) == BASE_ITEM_QUARTERSTAFF ||
            GetBaseItemType(oMyWeapon) == BASE_ITEM_MAGICSTAFF ||
            GetBaseItemType(oMyWeapon) == BASE_ITEM_DIREMACE)
        {
            if (nDuration>0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
                AddBlackStaffEffectOnWeapon(oMyWeapon, RoundsToSeconds(nDuration));
            }
            return;
        }
        else
        {
           FloatingTextStrRefOnCreature(83620, OBJECT_SELF);  // not a qstaff
           return;
        }
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
    */
