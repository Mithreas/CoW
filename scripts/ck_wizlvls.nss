// Conversation conditional to check if PC has wizard or sorcerer levels.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2003 Artos            Initial release.
//

int StartingConditional()
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) )
        return TRUE;

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_BARD, oPC) >= 4)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) >= 4))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 4))
        iPassed = 1;
    if((iPassed == 0) && (GetIsObjectValid(GetItemPossessedBy(oPC, "AR_ITEM_TOWER_DIPLO"))))
        iPassed = 1;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
