//  ScarFace's Persistent Banking system - Account Balance -
#include "inc_database"
#include "bank_inc"
void main()
{
    object oPC = GetLastSpeaker();
    string sKey = GetName(oPC);
    int iBanked;

    if (NWNX_APS_ENABLED)
    {
        iBanked = GetPersistentInt(OBJECT_INVALID, "bank" + sKey, INTEGER_TABLE);
    }
    else
    {
        iBanked = GetCampaignInt("bank", sKey);
    }
    SetCustomToken(1000, IntToString(iBanked));
}
