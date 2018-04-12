/*
  Spellsword Imbue Weapon Ability - ACID
*/

#include "inc_spellsword"

//apply Spellsword Imbue effect acid damage function
void ApplySSDoT( object oTarget, int nDamage, float fTimestep );
//check for effect
int SS_GetHasEffect(int nVFX, object oCreature);

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
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpellOrigin);

    if(bFeedback) SendMessageToPC(oSpellOrigin, "SS_IM_W entered");

    //make save
    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_ACID");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_ACID") + 2*10;

    if ((!FortitudeSave(oSpellTarget, nSaveDC, SAVING_THROW_TYPE_ACID)) && (gsTIGetActualTimestamp() > nTimer))
    {
		SetLocalInt(oSpellOrigin, "SS_IM_W_TM_ACID", gsTIGetActualTimestamp());
	    //remove previous effect
//		effect eEffect = GetFirstEffect(oSpellTarget);
//		while (GetIsEffectValid(eEffect))
//		{
//			if ((GetEffectTag(eEffect) == EFFECT_TAG_SPELLSWORD) && (GetEffectType(eEffect) == EFFECT_TYPE_REGENERATE))
//			// if (GetEffectType(eEffect) == EFFECT_TYPE_REGENERATE) // use if NWNX not installed
//			{
//				RemoveEffect(oSpellTarget, eEffect);
//			}
//
//			eEffect = GetNextEffect(oSpellTarget);
//		}
		
		
		//add new effect
        int nDamage = nWizard/5 + nSpellGroup;
		int nRounds = 1 + nSpellGroup;
		int nCurrentRounds = GetLocalInt(oSpellTarget, "SS_ACID_DAMAGE");
		SetLocalInt(oSpellTarget, "SS_ACID_DAMAGE", nCurrentRounds + nRounds);
        float fTimestep = 6.0;

		//int bHasEffect = SS_GetHasEffect(VFX_DUR_MIRV_ACID, oSpellTarget);
		
		if (GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "MI_BLOCKEDSCHOOL2") == 7)
		{
			SendMessageToPC(oSpellOrigin, "nCurrentRounds: " + IntToString(nCurrentRounds));
			SendMessageToPC(oSpellOrigin, "nRounds: " + IntToString(nRounds));
			SendMessageToPC(oSpellOrigin, "nDamage: " + IntToString(nDamage));
		}

		if (nCurrentRounds <= 0 || GetLocalInt(oSpellTarget, "SS_ACID_DAMAGE_OFF") == 1)// || !bHasEffect) 
		// damage off flag produces is in gs_m_enter and protects against logging out whilst still under the effects of acid damage
		// otherwise this code prevents stacking of acid effect
		{	
			if (GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "MI_BLOCKEDSCHOOL2") == 7)
			{
				SendMessageToPC(oSpellOrigin, "ApplySSDoT");
			}
			DelayCommand( fTimestep, ApplySSDoT( oSpellTarget, nDamage, fTimestep ) );
		}
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIRV_ACID)), oSpellTarget, fTimestep * nRounds);
		
        // effect eImbueEffect = EffectRegenerate(-1 * nDamage, nTimestep);
        // float nDuration = 18.0 * nSpellGroup;
		
		
		
//        string sScript = "ss_acid" + IntToString(nDamage);
//        ApplyDoTToCreature(EffectSavingThrowDecrease(SAVING_THROW_FORT, 1), VFX_DUR_MIRV_ACID, sScript, oSpellTarget, nDuration, nTimestep, oSpellOrigin, EFFECT_TAG_DOT, -1);
//        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eImbueEffect), oSpellTarget, nDuration, EFFECT_TAG_SPELLSWORD);
    }
    return;
}

//apply Spellsword Imbue effect acid damage function
void ApplySSDoT( object oTarget, int nDamage, float fTimestep )
{
	
	int nCurrentRounds = GetLocalInt(oTarget, "SS_ACID_DAMAGE");
	if (nCurrentRounds > 0)
	{
		SetLocalInt(oTarget, "SS_ACID_DAMAGE_OFF", 0);
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(d4(nDamage), DAMAGE_TYPE_ACID)), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
		
		SetLocalInt(oTarget, "SS_ACID_DAMAGE", nCurrentRounds - 1);
		
		DelayCommand(fTimestep, ApplySSDoT(oTarget, nDamage, fTimestep));
	}
	else 
	{
		SetLocalInt(oTarget, "SS_ACID_DAMAGE_OFF", 1);
	}	
}

//check for effect
int SS_GetHasEffect(int nVFX, object oCreature)
{
    effect eEffect = GetFirstEffect(oCreature);

    while(GetIsEffectValid(eEffect))
    {
		if (GetLocalInt(gsPCGetCreatureHide(oCreature), "MI_BLOCKEDSCHOOL2") == 7)
		{
			SendMessageToPC(oCreature, IntToString(GetEffectType(eEffect)) + " == " + IntToString(EFFECT_TYPE_VISUALEFFECT));
			SendMessageToPC(oCreature, IntToString(GetEffectInteger(eEffect, EFFECT_INTEGER_VISUAL_EFFECT_TYPE)) + " == " + IntToString(nVFX));
		}
		
        if(GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT && GetEffectInteger(eEffect, EFFECT_INTEGER_VISUAL_EFFECT_TYPE) == nVFX)
        {
            return TRUE;
        }
        eEffect = GetNextEffect(oCreature);
    }
    return FALSE;
}