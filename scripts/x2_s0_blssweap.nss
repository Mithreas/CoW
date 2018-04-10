//::///////////////////////////////////////////////
//:: Bless Weapon
//:: X2_S0_BlssWeap
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

  If cast on a crossbow bolt, it adds the ability to
  slay rakshasa's on hit

  If cast on a melee weapon, it will add the
      grants a +1 enhancement bonus.
      grants a +2d6 damage divine to undead

  will add a holy vfx when command becomes available

  If cast on a creature it will pick the first
  melee weapon without these effects.

  ---

  Arelith Specific Changes:

  Bless Weapon's enhancement bonus now scales with the paladin's caster level,
  improving to +2 at level 11 with every 5 levels thereafter improving it by an additional +1.
  The maximum bonus is +5 at paladin level 26.

  At paladin level 13, Bless Weapon's divine damage bonus also applies to Outsiders.
  At paladin level 18, the divine damage bonus also applies to Dragons.

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "mi_inc_spells"


void AddBlessEffectToWeapon(object oTarget, float fDuration)
{
    // Scaling enhancement according to paladin level.
    int nEnhance = 1 + ((AR_GetCasterLevel(OBJECT_SELF) - 6) / 5);
    if (nEnhance < 1)
        nEnhance = 1;

    // If the spell is cast again, any previous enhancement boni are kept
    IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(nEnhance), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    // Replace existing temporary anti undead boni
    IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    // Add in temporary bonuses against Outsiders and Dragons
    if (AR_GetCasterLevel(OBJECT_SELF) > 12)
        IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    if (AR_GetCasterLevel(OBJECT_SELF) > 17)
        IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

    IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
    return;
}


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


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    int nDuration = 2 * (AR_GetCasterLevel(OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, OBJECT_SELF));
    int nMetaMagic = AR_GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2; //Duration is +100%
    }

    // ---------------- TARGETED ON BOLT  -------------------
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {
           SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), RoundsToSeconds(nDuration));
           return;
        }
    }

   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
   if(GetIsObjectValid(oMyWeapon) )
   {

        // Ignore magic staffs
        if (GetBaseItemType(oMyWeapon) == BASE_ITEM_MAGICSTAFF) {
            FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
            return;
        }

        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
           AddBlessEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
        }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}
