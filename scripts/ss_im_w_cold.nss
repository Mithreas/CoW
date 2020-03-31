/*
  Spellsword Imbue Weapon Ability - COLD
*/

#include "inc_spellsword"

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
    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_COLD");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_COLD") + 2;
	
    if ((!FortitudeSave(oSpellTarget, nSaveDC, SAVING_THROW_TYPE_COLD)) && (gsTIGetActualTimestamp() > nTimer))
    {
		SetLocalInt(oSpellOrigin, "SS_IM_W_TM_COLD", gsTIGetActualTimestamp());
		//remove previous effect
		effect eEffect = GetFirstEffect(oSpellTarget);
		while (GetIsEffectValid(eEffect))
		{
			if (GetIsTaggedEffect(eEffect, EFFECT_TAG_SPELLSWORD) && GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
			// if (GetEffectType(eEffect) == EFFECT_TYPE_REGENERATE) // use if NWNX not installed
			{
				RemoveEffect(oSpellTarget, eEffect);
			}

			eEffect = GetNextEffect(oSpellTarget);
		}

		//add new effect

		effect eSlow = EffectModifyAttacks(-1);
        effect eVFX = EffectVisualEffect(VFX_DUR_ICESKIN);
		effect eMove = EffectMovementSpeedDecrease(50);

        effect eImbueEffect = EffectLinkEffects(eSlow, eVFX);
		eImbueEffect = EffectLinkEffects(eImbueEffect, eMove);
        float nDuration = 12.0 * nSpellGroup;
        ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eImbueEffect), oSpellTarget, nDuration, EFFECT_TAG_SPELLSWORD);
    }
    return;
}
