#include "gs_inc_state"
#include "inc_boon"

void main()
{
    object oPC          = GetPCSpeaker();
    object oHide        = gsPCGetCreatureHide(oPC);
    int isWildMage      = GetLocalInt(oHide, "WILD_MAGE");

    if ( !GetIsPC(oPC) || !isWildMage)    return;

    //::  Apply Boon
    if ( bnGetHasActiveBoon(oPC, BOON_WILD_MAGE) == FALSE ) {
        int nDuration = 29030400;   //:: One in-game year

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_10), oPC);

        Log(LOG_BOON, GetName(oPC) + " acquired a boon: Wild Mage Occurrence.");

        //::  Store the Boon variables
        bnCreateTimestampedBoonVar(oPC, BOON_WILD_MAGE, nDuration);
        //::  Actually apply the boon
        bnRefreshBoons(oPC);
    } else {
        SendMessageToPC(oPC, "You already have the Wild Mage Occurrence.");
    }
}
