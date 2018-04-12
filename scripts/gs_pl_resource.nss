#include "inc_common"
#include "inc_time"
#include "inc_poison"

const int GS_TIMEOUT = 10800; //3 hours
const int GS_LIMIT   =     5;

void main()
{
    // Wolfsbane only spawns at night.
    if (GetResRef(OBJECT_SELF) == "ar_pl_herb007" && !GetIsNight()) return;

    // withering plants never spawn resources
    if (GetLocalInt(OBJECT_SELF, "GVD_WITHERED") == 1) return;

    string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
    if (sTemplate == "") return;
    int nChance      = GetLocalInt(OBJECT_SELF, "GS_CHANCE");
    if (nChance < 1)     return;
    string sTemplate2 = GetLocalString(OBJECT_SELF, "GS_TEMPLATE_2");
    int nChance2      =  GetLocalInt(OBJECT_SELF, "GS_CHANCE_2");
    if(nChance2 <= 0)
        nChance2 = nChance;
    int nTimestamp   = gsTIGetActualTimestamp();
    int nTimeout     = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened      = ! GetIsObjectValid(GetLastKiller());

    if (nTimeout < nTimestamp)
    {
        if (! GetIsObjectValid(GetFirstItemInInventory()))
        {
            // add 25% chance for plants that have been tended to
            if (GetLocalInt(OBJECT_SELF, "TENDED_TO") == 1) {
              nChance = nChance + 25;
              nChance2 += 25;
            }

            object oItem = OBJECT_INVALID;
            int nNth     = 0;

            for (; nNth < GS_LIMIT; nNth++)
            {
                if (nChance + Random(100) >= 100)
                {
                    oItem = CreateItemOnObject(sTemplate);
                    SetIdentified(oItem, TRUE);
                    SetStolenFlag(oItem, FALSE);
                }
            }

            if(sTemplate2 != "")
            {
                for (nNth=0; nNth < GS_LIMIT; nNth++)
                {
                    if (nChance2 + Random(100) >= 100)
                    {
                        oItem = CreateItemOnObject(sTemplate2);
                        SetIdentified(oItem, TRUE);
                        SetStolenFlag(oItem, FALSE);
                    }
                }
            }
            // Apply poison.
            int nPoison = GetLocalInt(OBJECT_SELF, VAR_POISON_TYPE);
            if (nPoison)
            {
              DeleteLocalInt(OBJECT_SELF, VAR_POISON_TYPE);
              object oPoisonedFood = CreateItemOnObject(GetResRef(oItem),
                                     OBJECT_SELF,
                                     GetNumStackedItems(oItem),
                                     GetTag(oItem) + "p" + IntToString(nPoison));
              SetLocalInt(oPoisonedFood, VAR_POISON_TYPE, nPoison);
              DestroyObject(oItem);
            }
        }

        if (nOpened)
        {
            nTimestamp += GS_TIMEOUT;
            SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
            DeleteLocalInt(OBJECT_SELF, "TENDED_TO");
            return;
        }
    }

    if (! nOpened) gsCMCreateRecreator(nTimeout);
}
