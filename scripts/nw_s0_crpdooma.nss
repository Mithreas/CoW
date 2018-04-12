//::///////////////////////////////////////////////
//:: Creeping Doom: OnEnter
//:: nw_s0_crpdooma.nss
//:://////////////////////////////////////////////
/*
    Reworked properly to fit Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: Mars 25, 2017
//:://////////////////////////////////////////////

#include "inc_spell"
#include "inc_generic"



void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();
    int nValue     = 0;
    string sString = "GS_SP_" + IntToString(nSpell) + "_";
    int nDamage    = GetLocalInt(OBJECT_SELF, sString + "DAMAGE");
    int nCount     = GetLocalInt(OBJECT_SELF, sString + "COUNT");

    //::  At least 1 Dice
    if (nCount <= 0) nCount = 1;

    //affection check
    if (GetIsCorpse(oTarget) || ! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;
    
    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //damage
    nValue   = d6(nCount);
    nDamage += nValue;

    if (nDamage > 1000) nValue = nDamage - 1000;

    //apply
    eEffect = EffectDamage(nValue, DAMAGE_TYPE_PIERCING);
    gsSPApplyEffect(oTarget, eEffect, nSpell);

    if (nDamage >= 1000)
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    SetLocalInt(OBJECT_SELF, sString + "DAMAGE", nDamage);
}
