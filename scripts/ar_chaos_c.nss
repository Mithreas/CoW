/*
  Wild Mage Chaos Shield Effect OnHeartBeat
*/

#include "ar_spellmatrix"
#include "inc_effect"

void doFeedbackMessage(object oCaster, object oTarget, string sMessage);
void doFeedbackMessage(object oCaster, object oTarget, string sMessage) {
    _arNeagativeSpellText(oTarget, sMessage);
    SendMessageToPC(oCaster, GetName(oTarget) + " <cþÀ >affected by</c> <cþ þ>" + sMessage + "</c>");
}

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject();

    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    int nDC             = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_ABJURATION, 7) + (nCasterLevel/3);

    //::  Loop AoE
    while ( GetIsObjectValid(oTarget) )
    {
        //::  Only apply to hostile targets
        if( GetIsEnemy(oTarget, oCaster) && GetCurrentHitPoints(oTarget) > 0 ) {
            //::  There is a 20% chance for this to go through.  This does not increase chance for each HB, only for OnEnter targets
            int nSub    = GetLocalInt(oCaster, "AR_CHAOS_ADDON");
            int nChance = 80-nSub;
            if (nChance < 20) nChance = 20;
            int bIsPC = GetIsPC(oTarget);

            //::  Chaos Chance Success
            if ( d100() > nChance) {
                SetLocalInt(oCaster, "AR_CHAOS_ADDON", 0);  //::  Always reset Bonus Addon chance if success

                //::  Check if Target is Immune
                if ( ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {

                    //::  PCs can Save against the Heartbeat Chaos Shield
                    if (bIsPC) SendMessageToPC(oTarget, "You're trying to avoid a Chaos Shield effect");
                    if ( bIsPC && WillSave(oTarget, nDC, SAVING_THROW_TYPE_CHAOS, oCaster) != 0 ) {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), oTarget);
                    }
                    //::  Apply Chaos Shield Effect
                    else {
                        ar_ApplyChaosShieldEffect(oCaster, oTarget);
                    }

                } else {
                    //SendMessageToPC(oCaster, GetName(oTarget) + " was immune to Chaos Shield effect");
                    if (bIsPC) SendMessageToPC(oTarget, "You managed to avoid a Chaos Shield effect");
                }
            }
            //::  Chaos Shield Chance fail, just play a VFX to show something happened
            else {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_ODD), oTarget);
            }
        }

        oTarget = GetNextInPersistentObject();
    }
}
