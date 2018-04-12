#include "gs_inc_common"
#include "gs_inc_time"
#include "inc_generic"

const int GS_TIMEOUT    = 10800; //3 hours
const int GS_LIMIT_ITEM =     2;

void main()
{
    //timeout
    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened    = ! GetIsObjectValid(GetLastKiller());

    if (nTimeout < nTimestamp)
    {
        {
            //create inventory
            string sTag       = GetTag(OBJECT_SELF);
            sTag              = "GS_INVENTORY_" + GetStringRight(sTag, GetStringLength(sTag) - 3);
            object oInventory = GetObjectByTag(sTag);

            if (GetIsObjectValid(oInventory))
            {
                object oItem = GetFirstItemInInventory(oInventory);

                if (GetIsObjectValid(oItem))
                {
                    int nCount = 0;

                    //generate item list
                    do
                    {
                        SetLocalObject(
                            oInventory,
                            "GS_PL_INVENTORY_ITEM_" + IntToString(nCount++),
                            oItem);

                        oItem = GetNextItemInInventory(oInventory);
                    }
                    while (GetIsObjectValid(oItem));

                    //create item
                    if (nOpened)
                    {
                        object oCopy   = OBJECT_INVALID;
                        int nLimitItem = Random(GS_LIMIT_ITEM + 1);
                        int nNth       = 0;

                        for (; nNth < nLimitItem; nNth++)
                        {
                            oItem = GetLocalObject(
                                oInventory,
                                "GS_PL_INVENTORY_ITEM_" + IntToString(Random(nCount)));
                            oCopy = gsCMCopyItem(oItem, OBJECT_SELF);
                            CopyVariables(oItem, oCopy, "_");

                            if (GetIsObjectValid(oCopy))
                            {
                                SetIdentified(oCopy, gsCMGetItemValue(oCopy) <= 100);
                                SetStolenFlag(oCopy, FALSE);
                            }
                        }
                    }
                }
            }
        }

        if (nOpened)
        {
            nTimestamp += GS_TIMEOUT;
            SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
            return;
        }
    }

    if (! nOpened) gsCMCreateRecreator(nTimeout);
}
