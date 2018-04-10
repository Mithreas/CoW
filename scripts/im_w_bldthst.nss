/*
  Blade Thrist Weapon Ability
*/

#include "x2_I0_SPELLS"
#include "mi_inc_spells"
#include "inc_spells"
#include "gs_inc_pc"

void main()
{
    int bFeedback = FALSE;

    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oSpellOrigin);
	
	int nHarperPath = GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), "MI_CL_HARPER_PATH");
	
	if (nHarperPath == 3) //paragon
	{
		nRanger += GetLevelByClass(CLASS_TYPE_HARPER, oSpellOrigin);
	}
	
	int nDamage = 2 + (nRanger - 11) / 5;
	
	effect eHeal =  EffectHeal(nDamage);
    effect eImbueEffect = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eImbueEffect), oSpellTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eHeal), oSpellOrigin);
    
    return;
}
