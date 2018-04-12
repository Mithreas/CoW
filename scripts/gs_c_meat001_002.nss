#include "inc_common"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    string sResRef  = "";
    int nGold       = 0;
    int nStackSize  = 0;

    while (GetIsObjectValid(oItem))
    {
        sResRef = GetResRef(oItem);
        nStackSize = GetNumStackedItems(oItem);

        if (sResRef == "gs_item897") //meat big
        {
            nGold += (15 * nStackSize);
            DestroyObject(oItem);
        }
        else if (sResRef == "gs_item898") //meat medium
        {
            nGold += (10 * nStackSize);
            DestroyObject(oItem);
        }
        else if (sResRef == "gs_item899") //meat small
        {
            nGold += (5 * nStackSize);
            DestroyObject(oItem);
        }

        oItem   = GetNextItemInInventory(oSpeaker);
    }

    gsCMCreateGold(nGold, oSpeaker);
}
