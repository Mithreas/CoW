#include "gs_inc_common"
#include "gs_inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    int nGold       = 0;
    int nXP         = 0;
    int nStackSize  = 0;

    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == "shiprattail")
        {
            nStackSize = GetNumStackedItems(oItem);
            nGold += (5 * nStackSize);
            nXP   += (5 * nStackSize);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oSpeaker);
    }

    gsCMCreateGold(nGold, oSpeaker);
    gsXPGiveExperience(oSpeaker, nXP);
}
