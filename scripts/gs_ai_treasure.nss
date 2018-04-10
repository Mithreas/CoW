#include "gs_inc_common"
#include "gs_inc_event"
#include "inc_item"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);

        break;

    case GS_EV_ON_PERCEPTION:
//................................................................

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        if (Random(100) >= 90)
        {
            //create treasure
            string sTag       = GetTag(OBJECT_SELF);
            sTag              = "GS_INVENTORY_" + GetStringRight(sTag, GetStringLength(sTag) - 3);
            object oInventory = GetObjectByTag(sTag);

            if (GetIsObjectValid(oInventory))
            {
                object oItem = GetFirstItemInInventory(oInventory);
                int nValue   = 0;

                while (GetIsObjectValid(oItem))
                {
                    nValue = gsCMGetItemValue(oItem);

                    if (nValue <= 2500 && Random(100) >= 95)
                    {
                        object oCopy = gsCMCopyItem(oItem, OBJECT_SELF);
                        if(GetIsItemMundane(oItem)) SetIsItemMundane(oCopy, TRUE);

                        if (GetIsObjectValid(oCopy))
                        {
                            SetIdentified(oCopy, nValue <= 100);
                            SetStolenFlag(oCopy, FALSE);
                        }

                        break;
                    }

                    oItem = GetNextItemInInventory(oInventory);
                    if (! GetIsObjectValid(oItem)) oItem = GetFirstItemInInventory(oInventory);
                }
            }
        }

        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
