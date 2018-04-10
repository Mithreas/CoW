#include "gs_inc_common"

void main()
{
    object oClosedBy = GetLastClosedBy();
    object oItem     = GetFirstItemInInventory();
    int nValue       = 0;

    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_GEM &&
            GetIdentified(oItem))
        {
            nValue = gsCMGetItemValue(oItem) * 50 / 100;

            gsCMCreateGold(nValue, oClosedBy);
            DestroyObject(oItem);
        }
        else if (GetBaseItemType(oItem) == BASE_ITEM_GOLD)
        {
          int nOldValue    = GetItemStackSize(oItem);
          int nNewValue    = FloatToInt(IntToFloat(nOldValue) * 0.9);
          int nStaterCount = 0;

          // Turn it into gems.
          while (nNewValue > 100)
          {
            CreateItemOnObject("ar_stater", oClosedBy);
            nNewValue -= 100;
            nStaterCount ++;
          }

          SetItemStackSize(oItem, nOldValue - nStaterCount * 111);
        }

        oItem = GetNextItemInInventory();
    }
}
