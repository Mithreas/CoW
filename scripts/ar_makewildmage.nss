/*
  Makes the Player Character into a Wild Mage (Path), but also lowers EXP down to Level 3.
*/

#include "ar_utils"

void main()
{
    object oPC = GetPCSpeaker();

    if ( !GetIsPC(oPC) )    return;

    object oItem = gsPCGetCreatureHide(oPC);

    //::  Abort if PC already has a path
    if ( ar_GetPCHavePath(oPC) ) {
        SendMessageToPC(oPC, "<cþ  >You already have a path, aborting Path change! Contact a DM.</c>");
        return;
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION), oPC);

    int nCurrentLevel = GetHitDice(oPC);

    //::  Set PC back to Level 5 and give them the Wild Mage Path
    if (nCurrentLevel > 5) SetXP(oPC, 10000);

    SendMessageToPC(oPC, "You have selected the Wild Mage School.");
    SetLocalInt(oItem, "WILD_MAGE", TRUE);

    object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
    string sPath     = "Wild Mage";
    SetDescription(oAbility, GetDescription(oAbility) + "\nPath: " + sPath);
    SetIdentified(oAbility, TRUE);
    SetLocalString(oItem, "MI_PATH", sPath);
}
