/* CLASS Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_time"

//void main() {}

//return unique id from nInstance of class sID
string gsCLGetUniqueID(string sID, int nInstance);
//return unique id of player that owns nInstance of class sID
string gsCLGetOwnerID(string sID, int nInstance);
//make oPC own nInstance of class sID, also set name and actualize timestamp
void gsCLSetOwner(string sID, int nInstance, object oPC);
//return owner name from nInstance of class sID
string gsCLGetName(string sID, int nInstance);
//set owner sName for nInstance of class sID
void gsCLSetName(string sID, int nInstance, string sName);
//return timestamp from nInstance of class sID
int gsCLGetTimestamp(string sID, int nInstance);
//set nTimestamp for nInstance of class sID
void gsCLSetTimestamp(string sID, int nInstance, int nTimestamp);
//set timestamp for nInstance of class sID to actual time
void gsCLSetActualTimestamp(string sID, int nInstance);
//return timeout from nInstance of class sID
int gsCLGetTimeout(string sID, int nInstance);
//set nTimeout for nInstance of class sID
void gsCLSetTimeout(string sID, int nInstance, int nTimeout);
//return TRUE if oPC owns nInstance of class sID
int gsCLGetIsOwner(string sID, int nInstance, object oPC);
//return TRUE if nInstance of class sID is vacant
int gsCLGetIsVacant(string sID, int nInstance);
//return TRUE if nInstance of class sID is available
int gsCLGetIsAvailable(string sID, int nInstance);
//release nInstance of class sID
void gsCLRelease(string sID, int nInstance);
//release all instances of class sID (database will be deleted)
void gsCLReleaseAll(string sID);

string gsCLGetUniqueID(string sID, int nInstance)
{
    return GetCampaignString("GS_CL_" + sID, "UNIQUE_ID_" + IntToString(nInstance));
}
//----------------------------------------------------------------
string gsCLGetOwnerID(string sID, int nInstance)
{
    return GetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetOwner(string sID, int nInstance, object oPC)
{
    // PrintString used as opposed to Trace because this is a test to see if the
    // library is used at all in normal usage.
    PrintString("gsCLSetOwner called: class name " + sID);
    string sPlayerID = gsPCGetLegacyID(oPC);

    if (sPlayerID != "")
    {
        string sUniqueID = gsCMCreateRandomID(32);

        SetCampaignString("GS_CL_" + sID, "UNIQUE_ID_" + IntToString(nInstance), sUniqueID);
        SetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance), sPlayerID);
        gsCLSetName(sID, nInstance, GetName(oPC));
        gsCLSetActualTimestamp(sID, nInstance);
    }
}
//----------------------------------------------------------------
string gsCLGetName(string sID, int nInstance)
{
    return GetCampaignString("GS_CL_" + sID, "NAME_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetName(string sID, int nInstance, string sName)
{
    SetCampaignString("GS_CL_" + sID, "NAME_" + IntToString(nInstance), sName);
}
//----------------------------------------------------------------
int gsCLGetTimestamp(string sID, int nInstance)
{
    return GetCampaignInt("GS_CL_" + sID, "TIMESTAMP_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetTimestamp(string sID, int nInstance, int nTimestamp)
{
    SetCampaignInt("GS_CL_" + sID, "TIMESTAMP_" + IntToString(nInstance), nTimestamp);
}
//----------------------------------------------------------------
void gsCLSetActualTimestamp(string sID, int nInstance)
{
    gsCLSetTimestamp(sID, nInstance, gsTIGetActualTimestamp());
}
//----------------------------------------------------------------
int gsCLGetTimeout(string sID, int nInstance)
{
    return GetCampaignInt("GS_CL_" + sID, "TIMEOUT_" + IntToString(nInstance));
}
//----------------------------------------------------------------
void gsCLSetTimeout(string sID, int nInstance, int nTimeout)
{
    SetCampaignInt("GS_CL_" + sID, "TIMEOUT_" + IntToString(nInstance), nTimeout);
}
//----------------------------------------------------------------
int gsCLGetIsOwner(string sID, int nInstance, object oPC)
{
    string sPlayerID = gsPCGetLegacyID(oPC);

    if (sPlayerID != "" &&
        gsCLGetOwnerID(sID, nInstance) == sPlayerID)
    {
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsCLGetIsVacant(string sID, int nInstance)
{
    string sPlayerID = gsCLGetOwnerID(sID, nInstance);

    return sPlayerID == "";
}
//----------------------------------------------------------------
int gsCLGetIsAvailable(string sID, int nInstance)
{
    if (! gsCLGetIsVacant(sID, nInstance))
    {
        int nTimeout = gsCLGetTimeout(sID, nInstance);

        if (nTimeout)
        {
            int nTimestamp = gsTIGetActualTimestamp() - gsCLGetTimestamp(sID, nInstance);

            if (nTimestamp < nTimeout) return FALSE;
        }
    }

    return TRUE;
}
//----------------------------------------------------------------
void gsCLRelease(string sID, int nInstance)
{
    SetCampaignString("GS_CL_" + sID, "OWNER_" + IntToString(nInstance), "");
}
//----------------------------------------------------------------
void gsCLReleaseAll(string sID)
{
    DestroyCampaignDatabase("GS_CL_" + sID);
}
