#include "inc_iprop"
#include "inc_token"

int StartingConditional()
{
    if (GetLocalInt(GetModule(), "GS_IP_ENABLED"))
    {
        object oItem = GetFirstItemInInventory();

        if (GetIsObjectValid(oItem))
        {
            //property
            int nStrRef    = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_STRREF");
            string sString = GetStringByStrRef(nStrRef);

            SetCustomToken(105, sString + "\n");

            //subtype
            nStrRef        = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE_STRREF");
            sString        = GetStringByStrRef(nStrRef);

            SetCustomToken(106, sString + "\n");

            //cost
            nStrRef        = GetLocalInt(OBJECT_SELF, "GS_COST_STRREF");
            sString        = GetStringByStrRef(nStrRef);

            SetCustomToken(107, sString + "\n");

            int nTableID   = gsIPGetTableID("itempropdef");
            int nNth       = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
            nTableID       = gsIPGetValue(nTableID, nNth, "PARREF");
            int nCount     = gsIPGetCount(nTableID);

            if (nCount)
            {
                int nSlot = 0;
                int nID   = 0;
                nNth      = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4");
                nCount    = nNth + 5;

                for (; nNth < nCount; nNth++)
                {
                    sString = "GS_SLOT_" + IntToString(++nSlot) + "_";
                    nStrRef = gsIPGetValue(nTableID, nNth, "STRREF");

                    if (nStrRef)
                    {
                        gsTKSetToken(99 + nSlot, GetStringByStrRef(nStrRef));

                        nID = gsIPGetValue(nTableID, nNth, "ID");

                        SetLocalInt(OBJECT_SELF, sString + "ID", nID);
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
    }

    return FALSE;
}
