#include "gs_inc_time"

const int GS_TIMEOUT = 7200; //2 hours

void main()
{
    //timeout
    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");

    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        if (nTimeout >= nTimestamp) return;

        string sResRef = "";
        int nCount     = 0;
        int nNth       = 0;

        //generate object creation flag list
        while (TRUE)
        {
            sResRef = GetLocalString(OBJECT_SELF, "GS_PL_SLOT_" + IntToString(++nNth));
            if (sResRef == "") break;

            nCount  = GetLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef) + 1;
            SetLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef, nCount);
        }

        if (nNth > 1)
        {
            //remove existing objects from flag list
            object oItem = GetFirstItemInInventory();

            while (GetIsObjectValid(oItem))
            {
                sResRef = GetResRef(oItem);
                nCount  = GetLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef);

                if (nCount > 1) SetLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef, nCount - 1);
                else            DeleteLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef);

                oItem   = GetNextItemInInventory();
            }

            //create remaining objects in flag list
            nNth         = 0;

            while (TRUE)
            {
                sResRef = GetLocalString(OBJECT_SELF, "GS_PL_SLOT_" + IntToString(++nNth));
                if (sResRef == "") break;

                nCount  = GetLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef);

                while (nCount-- > 0) CreateItemOnObject(sResRef);
                DeleteLocalInt(OBJECT_SELF, "GS_PL_FLAG_" + sResRef);
            }
        }
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

        //generate object list
        object oItem   = GetFirstItemInInventory();
        string sResRef = "";
        int nNth       = 0;

        while (GetIsObjectValid(oItem))
        {
            sResRef = GetResRef(oItem);

            if (sResRef != "")
            {
                SetLocalString(
                    OBJECT_SELF,
                    "GS_PL_SLOT_" + IntToString(++nNth),
                    sResRef);
            }

            oItem   = GetNextItemInInventory();
        }
    }

    nTimestamp += GS_TIMEOUT;
    SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
}
