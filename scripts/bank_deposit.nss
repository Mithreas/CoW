//  ScarFace's Persistent Banking system  - Deposit Gold -
#include "bank_inc"
#include"aps_include"
void main()
{
    object oPC = GetPCSpeaker();
    string sKey = GetName(oPC),
           sAmount = GetLocalString(OBJECT_SELF, "GOLD");
    int nAmount = StringToInt(sAmount), iTotal, iBanked;

    // Anti-Cheat Check For Duping Gold
    if (GetGold(oPC) >= nAmount)
    {
        TakeGoldFromCreature(nAmount, oPC, TRUE);
        if (NWNX_APS_ENABLED)
        {
            iBanked = GetPersistentInt(OBJECT_INVALID, "bank"+sKey, INTEGER_TABLE);
            DeletePersistentVariable(OBJECT_INVALID,  "bank"+sKey, INTEGER_TABLE);
            iTotal = nAmount + iBanked;
            SetPersistentInt(OBJECT_INVALID, "bank"+sKey, iTotal, 0, INTEGER_TABLE);
        }
        else
        {
            iBanked = GetCampaignInt("bank", sKey);
            DeleteCampaignVariable("bank", sKey);
            iTotal = nAmount + iBanked;
            SetCampaignInt("bank", sKey, iTotal);
        }
    }
    else // Set Anti-Cheat Variable
    {
        SetLocalInt(OBJECT_SELF, "ANTI_CHEAT", TRUE);
        SendMessageToAllDMs(GetName(oPC) + " could possibly be trying to dupe gold from the Banker");
    }
    SetCustomToken(1000, IntToString(nAmount));
    SetCustomToken(1001, IntToString(iTotal));
}
