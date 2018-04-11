//  ScarFace's Persistent Banking system  - Wothdraw Failed -
#include "bank_inc"
#include"inc_database"
int StartingConditional()
{
    object oPC = GetLastSpeaker();
    string sKey = GetName(oPC),
           sGold = GetLocalString(OBJECT_SELF, "GOLD");
    int iGold = StringToInt(sGold), iBanked;

    if (NWNX_APS_ENABLED)
    {
        iBanked = GetPersistentInt(OBJECT_INVALID, "bank"+sKey, INTEGER_TABLE);
    }
    else
    {
        iBanked = GetCampaignInt("bank", sKey);

    }
    return(iBanked < iGold);
}
