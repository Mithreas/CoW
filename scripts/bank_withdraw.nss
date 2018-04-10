//  ScarFace's Persistent Banking system  - Withdraw Gold -
#include "bank_inc"
#include"aps_include"
void main()
{
    object oPC = GetPCSpeaker();
    string sKey = GetName(oPC),
           sWithdraw = GetLocalString(OBJECT_SELF, "GOLD");
    int iWithdraw = StringToInt(sWithdraw), iBanked, iTotal;

    if (NWNX_APS_ENABLED)
    {
        iBanked = GetPersistentInt(OBJECT_INVALID, "bank"+sKey, INTEGER_TABLE);
        GiveGoldToCreature(oPC, iWithdraw);
        iTotal = iBanked - iWithdraw;
        DeletePersistentVariable(OBJECT_INVALID,  "bank"+sKey, INTEGER_TABLE);
        SetPersistentInt(OBJECT_INVALID, "bank"+sKey, iTotal, 0, INTEGER_TABLE);
    }
    else
    {
        iBanked = GetCampaignInt("bank", sKey);
        GiveGoldToCreature(oPC, iWithdraw);
        iTotal = iBanked - iWithdraw;
        DeleteCampaignVariable("bank", sKey);
        SetCampaignInt("bank", sKey, iTotal);
    }
    SetCustomToken(1000, IntToString(iTotal));
}
