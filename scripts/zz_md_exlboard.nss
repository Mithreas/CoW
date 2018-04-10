//::///////////////////////////////////////////////
//:: Name
//:: FileName zz_md_exlboard
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Uses zzdlg.
    See zzdlg_placeable for additional variables to be set
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: 08/10/2016
//:://////////////////////////////////////////////

#include "mi_inc_citizen"
#include "zzdlg_main_inc"
void OnInit()
{
    string sNation = miCZGetBestNationMatch(GetLocalString(OBJECT_SELF, VAR_NATION));
    SQLExecStatement("SELECT p.name FROM gs_pc_data AS p INNER JOIN " +
       "micz_banish AS b ON b.pc_id = p.id WHERE b.nation=?", sNation);


    string sList = miCZGetName(sNation) + "'s Exiles:";
    while(SQLFetch())
    {
        sList += "\n" + SQLGetData(1);

    }

    dlgSetPrompt(sList);

    dlgActivateEndResponse("[END]", txtRed);
    dlgChangePage("BLANK");
}

void OnPageInit( string sPage ){}
void OnSelection( string sPage ){}
void OnReset( string sPage ){}
void OnAbort( string sPage) {}
void OnEnd( string sPage ){}
void OnContinue( string sPage, int iContinuePage ){}

void main()
{
  dlgOnMessage();
}
