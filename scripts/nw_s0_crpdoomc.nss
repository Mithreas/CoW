//::///////////////////////////////////////////////
//:: Creeping Doom: Heartbeat
//:: nw_s0_crpdoomc.nss
//:://////////////////////////////////////////////
/*
    Reworked properly to fit Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: Mars 25, 2017
//:://////////////////////////////////////////////

#include "mi_inc_spells"
#include "inc_generic"

void main()
{
    object oCaster    = GetAreaOfEffectCreator();
    object oTarget    = GetFirstInPersistentObject();
    effect eEffect;
    int nSpell        = gsSPGetSpellID();
    int nCasterLevel  = AR_GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nValue        = 0;
    string sString    = "GS_SP_" + IntToString(nSpell) + "_";
    int nDamage       = GetLocalInt(OBJECT_SELF, sString + "DAMAGE");
    int nCount        = GetLocalInt(OBJECT_SELF, sString + "COUNT");
    int bIncreaseOnce = FALSE;

    //::  At least 1 Dice
    if (nCount <= 0) nCount = 1;

    while (GetIsObjectValid(oTarget))
    {
        //raise event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

        //affection check
        if (!GetIsCorpse(oTarget) && gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget))
        {
            //damage
            nValue   = d6(nCount);
            nDamage += nValue;

            if (nDamage > 1000) nValue = nDamage - 1000;

            //apply
            eEffect  = EffectDamage(nValue, DAMAGE_TYPE_PIERCING);
            DelayCommand(gsSPGetRandomDelay(), gsSPApplyEffect(oTarget, eEffect, nSpell));

            if (nDamage >= 1000)
            {
                DestroyObject(OBJECT_SELF);
                return;
            }

            //::  Increase Damage if there is a creature in the AoE
            if (!bIncreaseOnce) {
                bIncreaseOnce = TRUE;
                nCount++;
            }
        }

        oTarget = GetNextInPersistentObject();
    }

    SetLocalInt(OBJECT_SELF, sString + "DAMAGE", nDamage);
    SetLocalInt(OBJECT_SELF, sString + "COUNT",  nCount);
}
