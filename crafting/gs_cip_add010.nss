#include "inc_craft"
#include "inc_token"

// Prevent ammo being used in the basin.  Various stacking bugs are exploitable.
int _RestrictedItem(object oItem)
{
  int nBaseType = GetBaseItemType(oItem);
  int nReturn = FALSE;

  switch (nBaseType)
  {
    case BASE_ITEM_ARROW:
    case BASE_ITEM_BOLT:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_DART:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_SHURIKEN:
      nReturn = TRUE;
      break;
    default:
      break;
  }
  if(GetLocalInt(oItem,"gvd_container_item"))
    nReturn = TRUE;
  return nReturn;
}


int StartingConditional()
{
    if (GetLocalInt(GetModule(), "GS_IP_ENABLED"))
    {
        object oItem = GetFirstItemInInventory();

        if (GetIsObjectValid(oItem))
        {
            string sString = "";
            int nStrRef    = 0;
            int nTableID   = gsIPGetTableID("itempropdef");
            int nSlot      = 0;
            int nID        = 0;
            int nNth       = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1");
            int nCount     = nNth + 5;

            for (; nNth < nCount; nNth++)
            {
                sString = "GS_SLOT_" + IntToString(++nSlot) + "_";
                nStrRef = gsIPGetValue(nTableID, nNth, "STRREF");

                if (nStrRef)
                {
                    gsTKSetToken(99 + nSlot, GetStringByStrRef(nStrRef));

                    nID = gsIPGetValue(nTableID, nNth, "ID");

                    SetLocalInt(OBJECT_SELF,
                                sString + "ID",
                                !_RestrictedItem(oItem) && gsCRGetIsValid(oItem, nID) ? nID : -1);
                    SetLocalInt(OBJECT_SELF, sString + "STRREF", nStrRef);
                }
                else
                {
                    SetLocalInt(OBJECT_SELF, sString + "STRREF", -1);
                }
            }

            return TRUE;
        }
    }

    return FALSE;
}
