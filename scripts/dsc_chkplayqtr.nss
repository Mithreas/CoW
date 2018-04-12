#include "inc_pc"
#include "inc_quarter"
#include "inc_favsoul"
#include "inc_warlock"
#include "inc_backgrounds"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // Play quarters restricted to bards (not warlocks of favored souls) / characters with gift of stardom with 20+ RPR.
    if(gsPCGetRolePlay(oPC) < 20 || !((GetLevelByClass(CLASS_TYPE_BARD, oPC) && !miFSGetIsFavoredSoul(oPC) && !miWAGetIsWarlock(oPC)) || GetHasGift(oPC, GIFT_OF_STARDOM)))
        return FALSE;
    if (gsQUGetIsAvailable(OBJECT_SELF))
    {
        SetCustomToken(100, IntToString(GetLocalInt(OBJECT_SELF, "GS_COST")));

        return TRUE;
    }
    return FALSE;
}
