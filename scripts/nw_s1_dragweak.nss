//::///////////////////////////////////////////////
//:: Dragon Breath Weaken
//:: NW_S1_DragWeak
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Anemoi: Replaced with a dispel effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Updated On: Oct 21, 2003
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nCasterLevel;
    float fDelay;
    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
    //Determine save DC and ability damage
    if (nAge <= 6) //Wyrmling
    {
        nCasterLevel = 1;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nCasterLevel = 2;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nCasterLevel = 3;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nCasterLevel = 6;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nCasterLevel = 9;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nCasterLevel = 12;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nCasterLevel = 15;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nCasterLevel = 18;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nCasterLevel = 21;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nCasterLevel = 24;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nCasterLevel = 27;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nCasterLevel = 30;
    }
    PlayDragonBattleCry();
    effect eBreath = EffectDispelMagicAll(nCasterLevel);
    eBreath = ExtraordinaryEffect(eBreath);
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_WEAKEN));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

            //Apply the VFX impact and effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

            //--------------------------------------------------------------
            //GZ: Bug fix
            //--------------------------------------------------------------
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBreath, oTarget));
        }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}


