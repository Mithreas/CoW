#include "inc_iprop"
#include "inc_factions"
int StartingConditional()
{
    object oItem = GetFirstItemInInventory();
    object oPC   = GetPCSpeaker();

    if (gsIPGetOwner(oItem) == gsPCGetPlayerID(oPC) ||
        GetLocalInt(oItem, "GENERATED_LOOT_ITEM") ||
        // Migration code, and to allow transferring of ownership.
        FindSubString(GetName(oItem), "[" + GetName(oPC) + "]") > 0 ||
        md_GetHasPowerFixture(MD_PR_RNF, oPC, GetName(oItem)))
    {
      // the PC crafted the item, allow rename.
      return TRUE;
    }
    else return FALSE;
}
