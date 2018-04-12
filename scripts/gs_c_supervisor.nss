#include "inc_factions"
#include "inc_quarter"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sNation = miCZGetBestNationMatch(GetLocalString(GetArea(OBJECT_SELF), VAR_NATION));
    string sNationName = miCZGetName(sNation);
    string sFactionID = md_GetDatabaseID(sNationName);

    int nOverride = md_GetHasPowerSettlement(MD_PR2_RVS, oPC, sFactionID, "2");
    if (GetIsDM(oPC) ||
        (sNation != "" && nOverride &&
         miCZGetHasAuthority(gsPCGetPlayerID(oPC),gsQUGetOwnerID(OBJECT_SELF), sNation, nOverride)))
    {
      LeaderLog(GetPCSpeaker(), "Checked shop owned by " + gsQUGetOwnerID(OBJECT_SELF));
      return TRUE;
    }

    return FALSE;
}
