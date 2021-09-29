//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 AC bonus to armor touched per 3 caster
  levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "inc_customspells"



void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   return;
}

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check inc_customspells.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nDuration  = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nAmount = AR_GetCasterLevel(OBJECT_SELF)/3;
    if (nAmount <0)
    {
        nAmount =1;
    }
    else if (nAmount>5)
    {
        nAmount =5;
    }

    object oMyArmor   =  IPGetTargetedOrEquippedArmor(TRUE);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }


    if(GetIsObjectValid(oMyArmor) )
    {
        SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {

            location lLoc = GetLocation(GetSpellTargetObject());
            DelayCommand(1.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), HoursToSeconds(nDuration));
			
			if (GetBaseItemType(oMyArmor) == BASE_ITEM_ARMOR && GetArmorBaseACValue(oMyArmor) >= 4)
			{
                IPSafeAddItemProperty(oMyArmor,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), HoursToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE, "mag_vest");
                IPSafeAddItemProperty(oMyArmor,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), HoursToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE, "mag_vest");
                IPSafeAddItemProperty(oMyArmor,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), HoursToSeconds(nDuration), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,FALSE, "mag_vest");
				gsCMReapplyDamageImmunityCap(GetItemPossessor(oMyArmor));
			}
			else
			{
				AddACBonusToArmor(oMyArmor, HoursToSeconds(nDuration),nAmount);
			}
		}
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
           return;
    }
}
