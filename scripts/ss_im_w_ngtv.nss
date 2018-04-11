/*
  Spellsword Imbue Weapon Ability - NEGATIVE
*/

#include "x2_I0_SPELLS"
#include "inc_customspells"
#include "inc_spells"

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
    int nSaveDC = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_DC_NGTV");
    int nSpellGroup = 1 + (nSaveDC - (10 + nWizard))/2;
	int nTimer = GetLocalInt(gsPCGetCreatureHide(oSpellOrigin), "SS_IM_W_TM_NGTV") + 2*10;

    if ((!WillSave(oSpellTarget, nSaveDC, SAVING_THROW_TYPE_NEGATIVE) && GetObjectType(oSpellTarget) == OBJECT_TYPE_CREATURE) && (gsTIGetActualTimestamp() > nTimer))
    {
		SetLocalInt(oSpellOrigin, "SS_IM_W_TM_NGTV", gsTIGetActualTimestamp());
        int nDamage = d4(nWizard/5 + nSpellGroup) / 2;
        float nTimestep = 6.0;
        effect eHeal =  EffectHeal(nDamage);
        effect eImbueEffect = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
        float nDuration = 18.0;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eImbueEffect), oSpellTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eHeal), oSpellOrigin);
    }
    return;
}
