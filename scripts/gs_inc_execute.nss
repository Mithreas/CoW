/* EXECUTE Library by Gigaschatten */

//void main() {}

#include "gs_inc_sequencer"

const string GS_EX_ROUND_COUNT  = "GS_EX_RC";
const string GS_EX_ROUND_OBJECT = "GS_EX_RO_";
const string GS_EX_ROUND_SCRIPT = "GS_EX_RS_";
const string GS_EX_HOUR_COUNT   = "GS_EX_HC";
const string GS_EX_HOUR_OBJECT  = "GS_EX_HO_";
const string GS_EX_HOUR_SCRIPT  = "GS_EX_HS_";

//register sFunction to execute on oObject once per round
void gsEXRegisterRound(object oObject, string sScript);
//unregister functions of oObject from execution per round
void gsEXUnregisterRound(object oObject = OBJECT_INVALID);
//execute registered functions once per round
void gsEXExecuteRound();
//register sFunction to execute on oObject once per game hour
void gsEXRegisterHour(object oObject, string sScript);
//unregister functions of oObject from execution per game hour
void gsEXUnregisterHour(object oObject = OBJECT_INVALID);
//execute registered functions once per game hour
void gsEXExecuteHour();
//internally used
void gsEXRegister(object oObject, string sScript, string sCountName, string sObjectName, string sScriptName);
//internally used
void gsEXUnregister(object oObject, string sCountName, string sObjectName, string sScriptName);
//internally used
void gsEXExecute(string sCountName, string sObjectName, string sScriptName);

void gsEXRegisterRound(object oObject, string sScript)
{
    gsEXRegister(oObject, sScript, GS_EX_ROUND_COUNT, GS_EX_ROUND_OBJECT, GS_EX_ROUND_SCRIPT);
}
//----------------------------------------------------------------
void gsEXUnregisterRound(object oObject = OBJECT_INVALID)
{
    gsEXUnregister(oObject, GS_EX_ROUND_COUNT, GS_EX_ROUND_OBJECT, GS_EX_ROUND_SCRIPT);
}
//----------------------------------------------------------------
void gsEXExecuteRound()
{
    gsEXExecute(GS_EX_ROUND_COUNT, GS_EX_ROUND_OBJECT, GS_EX_ROUND_SCRIPT);
}
//----------------------------------------------------------------
void gsEXRegisterHour(object oObject, string sScript)
{
    gsEXRegister(oObject, sScript, GS_EX_HOUR_COUNT, GS_EX_HOUR_OBJECT, GS_EX_HOUR_SCRIPT);
}
//----------------------------------------------------------------
void gsEXUnregisterHour(object oObject = OBJECT_INVALID)
{
    gsEXUnregister(oObject, GS_EX_HOUR_COUNT, GS_EX_HOUR_OBJECT, GS_EX_HOUR_SCRIPT);
}
//----------------------------------------------------------------
void gsEXExecuteHour()
{
    gsEXExecute(GS_EX_HOUR_COUNT, GS_EX_HOUR_OBJECT, GS_EX_HOUR_SCRIPT);
}
//----------------------------------------------------------------
void gsEXRegister(object oObject, string sScript, string sCountName, string sObjectName, string sScriptName)
{
    object oModule = GetModule();
    int nCount     = GetLocalInt(oModule, sCountName);
    string sCount  = IntToString(nCount);

    SetLocalObject(oModule, sObjectName + sCount, oObject);
    SetLocalString(oModule, sScriptName + sCount, sScript);
    SetLocalInt(oModule, sCountName, nCount + 1);
}
//----------------------------------------------------------------
void gsEXUnregister(object oObject, string sCountName, string sObjectName, string sScriptName)
{
    object oModule  = GetModule();
    object oObject1 = OBJECT_INVALID;
    string sScript  = "";
    string sNth1    = "";
    string sNth2    = "";
    int nCount      = GetLocalInt(oModule, sCountName);
    int nNth1       = 0;
    int nNth2       = 1;

    for (; nNth1 < nCount; nNth1++)
    {
        sNth1    = IntToString(nNth1);
        oObject1 = GetLocalObject(oModule, sObjectName + sNth1);

        if (! GetIsObjectValid(oObject1) || oObject1 == oObject)
        {
            if (nNth2 <= nNth1) nNth2 = nNth1 + 1;

            for (; nNth2 < nCount; nNth2++)
            {
                sNth2    = IntToString(nNth2);
                oObject1 = GetLocalObject(oModule, sObjectName + sNth2);
                sScript  = GetLocalString(oModule, sScriptName + sNth2);
                DeleteLocalObject(oModule, sObjectName + sNth2);
                DeleteLocalString(oModule, sScriptName + sNth2);
                if (GetIsObjectValid(oObject1)) break;
            }

            SetLocalObject(oModule, sObjectName + sNth1, oObject1);
            SetLocalString(oModule, sScriptName + sNth1, sScript);
        }
    }

    if (GetIsObjectValid(oObject1)) SetLocalInt(oModule, sCountName, nNth1);
    else                            DeleteLocalInt(oModule, sCountName);
}
//----------------------------------------------------------------
void gsEXExecute(string sCountName, string sObjectName, string sScriptName)
{
    object oModule = GetModule();
    object oObject = OBJECT_INVALID;
    string sScript = "";
    string sNth    = "";
    int nCount     = GetLocalInt(oModule, sCountName);
    int nNth       = 0;

    for (; nNth < nCount; nNth++)
    {
        sNth    = IntToString(nNth);
        oObject = GetLocalObject(oModule, sObjectName + sNth);

        if (GetIsObjectValid(oObject))
        {
            sScript = GetLocalString(oModule, sScriptName + sNth);
            gsSEAdd(sScript, oObject);
        }
    }
}
