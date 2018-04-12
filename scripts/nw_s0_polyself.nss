//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////

#include "inc_customspells"
#include "inc_common"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nDuration = AR_GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 387)
    {
        nPoly = POLYMORPH_TYPE_GIANT_SPIDER;
    }
    else if (nSpell == 388)
    {
        nPoly = POLYMORPH_TYPE_TROLL;
    }
    else if (nSpell == 389)
    {
        nPoly = POLYMORPH_TYPE_UMBER_HULK;
    }
    else if (nSpell == 390)
    {
        nPoly = POLYMORPH_TYPE_PIXIE;
    }
    else if (nSpell == 391)
    {
        nPoly = POLYMORPH_TYPE_ZOMBIE;
    }
    ePoly = EffectPolymorphEx(nPoly, FALSE, oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));

    //--------------------------------------------------------------------------
    // Arelith edit - save off the current creature skin so we can apply
    // properties across.
    //--------------------------------------------------------------------------
    object oSubraceHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration));

    //--------------------------------------------------------------------------
    // Arelith edit - transfer variables and properties from current hide.
    //--------------------------------------------------------------------------
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    gsCMCopyPropertiesAndVariables(oSubraceHide, oArmorNew);
}

