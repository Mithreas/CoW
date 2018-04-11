// Conversation conditional to check if PC has Rogue classes or any
// derivatives.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/24/2003 Artos            Initial release.
//
#include "inc_warlock"
#include "inc_favsoul"
int StartingConditional()
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) )
        return TRUE;

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_ROGUE, oPC) >= 6)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 2))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 3))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARD, oPC) >= 10) && !miWAGetIsWarlock(oPC) && !miFSGetIsFavoredSoul(oPC))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
