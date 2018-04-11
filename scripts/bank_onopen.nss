//  ScarFace's Persistent Banking system  - OnOpen -
#include "inc_database"
#include "bank_inc"
void main()
{
    object oChest = OBJECT_SELF,
           oPC, oItem;
    string sKey, sCount, sResRef;
    int iCount = 1;
    location lLoc;

    if (!GetLocalInt(oChest, "IN_USE"))
    {
        oPC = GetLastOpenedBy();
        sKey = GetLocalString(OBJECT_SELF, "CHEST_ID");

        if (sKey == "")
        {
          sKey = GetName(oPC);
        }

        SetLocalString(oChest, "CD_KEY", sKey);
        SetLocalInt(oChest, "IN_USE", TRUE);
        SetLocalString(oChest, "USER", GetName(oPC));
        lLoc = GetLocation(oChest);
        while (iCount <= MAX_ITEMS)
        {
            sCount = IntToString(iCount);
            //if( NWNX_APS_ENABLED)
            if (FALSE)
            {
                oItem = GetPersistentObject(oPC, sKey+sCount, oChest, OBJECT_TABLE);
                DeletePersistentVariable(OBJECT_INVALID, sKey+sCount, OBJECT_TABLE);
            }
            else
            {
                oItem = RetrieveCampaignObject("STORAGE", sKey+sCount, lLoc, oChest, OBJECT_INVALID);
                DeleteCampaignVariable("STORAGE", sKey+sCount, OBJECT_INVALID);
            }
            if (GetName(oItem) == "") return;
            iCount++;
        }
    }
}
