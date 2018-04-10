//------------------------------------------------------------------------------
// Condition: Can Craft Weapons?
//------------------------------------------------------------------------------
//
// Return TRUE when
//   ... Has a valid weapon in the right hand  AND
//   ... Weapon is NOT plot                    AND  -- removed
//   ... Weapon is not intelligent             AND
//   ... Weapon is not a whip or sling (1 part item)
//------------------------------------------------------------------------------
// Last Updated: Oct 24, GZ: Can no longer modify an intelligent weapon
//------------------------------------------------------------------------------
#include "x2_inc_itemprop"
#include "x2_inc_craft"
int StartingConditional()
{
    int iResult;
    object oW = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,GetPCSpeaker());
    if (!GetIsObjectValid(oW))
    {
        return FALSE;
    }
    //else if (GetPlotFlag(oW))
    //{
    //    return FALSE;
    //}
    else if (!IPGetIsMeleeWeapon(oW)&& !IPGetIsRangedWeapon(oW))
    {
        return FALSE;
    }
    else if (IPGetIsIntelligentWeapon(oW))
    {
        return FALSE;
    }
    else
    {
        //if (!GetHasSkill(SKILL_CRAFT_WEAPON,GetPCSpeaker()))
        //{
        //   return FALSE;
        //}

        //----------------------------------------------------------------------
        // Can't Modify Slings or Whips
        //----------------------------------------------------------------------
        if( GetBaseItemType(oW) == BASE_ITEM_WHIP || GetBaseItemType(oW) == BASE_ITEM_SLING )
        {
            return FALSE;
        }

    }

    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,"0");
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,"0");
    CISetCurrentModBackup(GetPCSpeaker(), oW);
    CISetCurrentModItem(GetPCSpeaker(), oW);

    return TRUE;
}
