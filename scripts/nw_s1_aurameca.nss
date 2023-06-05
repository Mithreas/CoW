//::///////////////////////////////////////////////
//:: Aura of Menace On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all those that fail
    a will save are stricken with Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "inc_pc"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    int nDuration = 1 + GetHitDice(GetAreaOfEffectCreator())/3;
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
	int nHD = GetHitDice(GetAreaOfEffectCreator());
	
	int nBonus = GetLocalInt(gsPCGetCreatureHide(GetAreaOfEffectCreator()), "FL_LEVEL");
	if (nBonus > 0) nBonus -= nHD;
	if (nBonus > 60) nBonus = 60;
	
    int nDC = 10 + nHD/3 + nBonus / 3;

    effect eLink = CreateDoomEffectsLink();

    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_MENACE));
        //Spell Resistance and Saving throw
        if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nDuration));
        }
    }
}