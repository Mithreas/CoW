//::///////////////////////////////////////////////
//:: Vine Mind, Camouflage: On Exit
//:: X2_S0_VineMCamB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Friendly creatures entering the zone of Vine Mine,
    Camouflage have a +4 added to hide checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"

void main()
{

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(532, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_SKILL_INCREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == 532)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    IPRemoveMatchingItemProperties(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget), ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_PERMANENT, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT);
}
