/*
  Wild Mage Chaos Shield Effect OnEnter
*/

#include "inc_spellmatrix"
#include "inc_effect"

void doFeedbackMessage(object oCaster, object oTarget, string sMessage);
void doFeedbackMessage(object oCaster, object oTarget, string sMessage) {
    _arNeagativeSpellText(oTarget, sMessage);
    SendMessageToPC(oCaster, GetName(oTarget) + " <cþÀ >affected by</c> <cþ þ>" + sMessage + "</c>");
}

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    //::  Cancel out for Friendly and Caster Objects
    if ( !GetIsObjectValid(oTarget) || oCaster == oTarget || !GetIsReactionTypeHostile(oTarget, oCaster) || GetCurrentHitPoints(oTarget) <= 0 ) return;


    //::  There is a 20% chance for this to go through  but increases chance each time it fails
    int nSub    = GetLocalInt(oCaster, "AR_CHAOS_ADDON");
    int nChance = 80-nSub;
    if (nChance < 20) nChance = 20;
    if ( d100() < nChance ) {
        nSub += 5;
        SetLocalInt(oCaster, "AR_CHAOS_ADDON", nSub);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ODD), oTarget);
        return;
    }
    SetLocalInt(oCaster, "AR_CHAOS_ADDON", 0);

    //::  Check if Target is Immune
    if ( ar_GetSpellImmune(oCaster, oTarget) ) {
        SendMessageToPC(oCaster, GetName(oTarget) + " was immune to Chaos Shield effect");
        if (GetIsPC(oTarget)) SendMessageToPC(oTarget, "You managed to avoid a Chaos Shield effect");
        return;
    }

    //::  Apply Chaos Shield Effect
    ar_ApplyChaosShieldEffect(oCaster, oTarget);
}
