//::///////////////////////////////////////////////
//:: Name    zz_co_crcat
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The conversation file for crafting catgories
*/
//:://////////////////////////////////////////////
//:: Created By: Mordeorn
//:: Created On: 2/5/2012
//:://////////////////////////////////////////////
#include "zzdlg_main_inc"
#include "inc_craft"
#include "inc_chat"


const string PAGE_MAIN = "CR_PAGE_MAIN";
const string PAGE_CAT = "CR_PAGE_CAT";
const string PAGE_CAT_TIER = "CR_PAGE_CTIER";
const string PAGE_TIER = "CR_PAGE_TIER";
const string PAGE_TIER_OPTIONS = "CR_PAGE_TI_OPT";
const string PAGE_SEARCH_OPTIONS = "CR_PAGE_SE_OPT";
const string PAGE_MAIN_OPT = "CR_PAGE_MN_OPT";


const string LIST_IDS = "CR_LIST_IDS";
const string LIST_OPTIONS = "CR_PAGE_OPT";

const string VAR_TIER = "CR_VAR_TIER";
const string VAR_ID = "CR_VAR_ID";

int _CatSelection(int nIndex, string sPage, object oSpeaker)
{
    string sColumn = "tier=";
    string sTier = dlgGetPlayerDataString(VAR_TIER);
    if(sPage == PAGE_CAT)
    {
        sColumn = "lower(name) LIKE ";
        sTier = "%"+sTier+"%";
    }
    switch(nIndex)
    {
    case 0:
    {
        string sMsg = chatGetLastMessage(oSpeaker);
        SQLExecStatement("UPDATE md_cr_category SET tier=? WHERE "+sColumn+"?", sMsg, sTier);
        if(sPage == PAGE_CAT_TIER)
            dlgSetPlayerDataString(VAR_TIER, sMsg);
        return 0;
    }
    case 1:
        SQLExecStatement("DELETE FROM md_cr_category WHERE "+sColumn+"? AND original IS NULL", sTier);
        return 0;
    default: dlgSetPlayerDataString(VAR_ID, GetStringElement(nIndex, LIST_IDS, oSpeaker)); break;
    }

    return 1;
}
void CleanUp()
{
  dlgClearPlayerDataString(VAR_TIER);
  dlgClearPlayerDataString(VAR_ID);
}

void OnInit()
{
  object oPC = dlgGetSpeakingPC();
  if(!GetElementCount(PAGE_MAIN, oPC))
  {
    dlgAddResponseAction(PAGE_MAIN, "LIST CATEGORIES [Speak Part of Name before selecting]");
    dlgAddResponseAction(PAGE_MAIN, "[LIST TIERS]");
    dlgAddResponseAction(PAGE_MAIN, "ADD CATEGORY [SPEAK NAME BEFORE SELECTING]");
  }

  if(!GetElementCount(LIST_OPTIONS, oPC))
  {
    dlgAddResponseAction(LIST_OPTIONS, "[REMOVE CATEGORY]");
    dlgAddResponseAction(LIST_OPTIONS, "SET TIER [SPEAK TIER # BEFORE SELECTING]");
    dlgAddResponseAction(LIST_OPTIONS, "CHANGE NAME [SPEAK NEW NAME BEFORE SELECTING]");
  }

  //other pages will be set dynamically.
  dlgChangePage(PAGE_MAIN);
  dlgActivateEndResponse("[Done]");
}
void OnPageInit(string sPage)
{
  string sPrompt;
  object oSpeaker = dlgGetSpeakingPC();
  if(!GetIsDM(oSpeaker)) return;


  dlgActivateResetResponse("[BACK]");
  if(sPage == PAGE_MAIN)
  {
    sPrompt = "If listing categories please try to be as specific as possible.";
    dlgDeactivateResetResponse();
  }
  else if(sPage == PAGE_TIER_OPTIONS || sPage == PAGE_SEARCH_OPTIONS || sPage == PAGE_MAIN_OPT)
  {
    sPrompt = "You cannot remove or change names of any default categories. Lower tiers are loaded first." +
        " New categories have a tier of 50. Default categories, unless changed, have a tier of 100.\n";

    SQLExecStatement("SELECT name,tier FROM md_cr_category WHERE id=?", dlgGetPlayerDataString(VAR_ID));
    SQLFetch();
    sPrompt += "Current Name: " + SQLGetData(1) + " Category Tier: " + SQLGetData(2);
    sPage = LIST_OPTIONS;

  }
  else if(sPage == PAGE_CAT)
  {
    sPrompt = "Selecting change all that match will change any that matched the search string, even if they're not listed. String to match: " + dlgGetPlayerDataString(VAR_TIER) +
                "\n You cannot remove categories that are default or have recipes within them.";

    dlgClearResponseList(LIST_IDS);
    dlgClearResponseList(sPage);

    SQLExecStatement("SELECT id,name FROM md_cr_category WHERE lower(name) LIKE ? LIMIT 5", "%" + dlgGetPlayerDataString(VAR_TIER) +"%");

    dlgAddResponse(sPage, "[CHANGE TIER OF ALL THAT MATCH]");
    dlgAddResponse(sPage, "[REMOVE ALL THAT MATCH]");
    dlgAddResponse(LIST_IDS, "-1");
    dlgAddResponse(LIST_IDS, "-2");
    while(SQLFetch())
    {
        dlgAddResponse(sPage, SQLGetData(2));
        dlgAddResponse(LIST_IDS, SQLGetData(1));
    }

  }
  else if(sPage == PAGE_TIER)
  {
    sPrompt = "List Tiers";
    dlgActivatePreservePageNumberOnSelection();

    SQLExecStatement("SELECT tier FROM md_cr_category GROUP BY tier ORDER BY tier ASC");

    dlgClearResponseList(sPage);
    while(SQLFetch())
    {
        dlgAddResponse(sPage, SQLGetData(1));
    }
    md_dlgRecoverPageNumber();
  }
  else if(sPage == PAGE_CAT_TIER)
  {
    sPrompt = "Listing categories of tier: " + dlgGetPlayerDataString(VAR_TIER);

    dlgClearResponseList(LIST_IDS);
    dlgClearResponseList(sPage);
    dlgActivatePreservePageNumberOnSelection();

    SQLExecStatement("SELECT id,name FROM md_cr_category WHERE tier=? ORDER BY name ASC", dlgGetPlayerDataString(VAR_TIER));

    dlgAddResponse(sPage, "[CHANGE TIER OF ALL THAT MATCH]");
    dlgAddResponse(sPage, "[REMOVE ALL THAT MATCH]");
    dlgAddResponse(LIST_IDS, "-1");
    dlgAddResponse(LIST_IDS, "-2");
    while(SQLFetch())
    {
        dlgAddResponse(sPage, SQLGetData(2));
        dlgAddResponse(LIST_IDS, SQLGetData(1));
    }
    md_dlgRecoverPageNumber();
  }


  dlgSetPrompt(sPrompt);
  dlgSetActiveResponseList(sPage);

}
void OnSelection(string sPage)
{
  object oSpeaker = dlgGetSpeakingPC();
  int nIndex = dlgGetSelectionIndex();

  if(sPage == PAGE_MAIN)
  {
    switch(nIndex)
    {
    case 0:
        dlgSetPlayerDataString(VAR_TIER, GetStringLowerCase(chatGetLastMessage(oSpeaker)));
        dlgChangePage(PAGE_CAT);
        break;
    case 1: dlgChangePage(PAGE_TIER); break;
    case 2:
        string sMsg = chatGetLastMessage(oSpeaker);
        SQLExecStatement("INSERT INTO md_cr_category(name) VALUES (?)", sMsg);
        dlgSetPlayerDataString(VAR_ID, miDAGetKeyedValue("md_cr_category", sMsg, "id", "name"));
        dlgChangePage(PAGE_MAIN_OPT);
        break;
    }
  }
  else if(sPage == PAGE_TIER_OPTIONS || sPage == PAGE_SEARCH_OPTIONS || sPage == PAGE_MAIN_OPT)
  {
    string sID = dlgGetPlayerDataString(VAR_ID);
    switch(nIndex)
    {
    case 0://only delete non-defaults
        SQLExecStatement("DELETE FROM md_cr_category WHERE id=? AND original IS NULL", sID);
        OnReset(sPage);
        break;
    case 1:
        SQLExecStatement("UPDATE md_cr_category SET tier=? WHERE id=?", chatGetLastMessage(oSpeaker), sID);
        break;
    case 2://only change name for non-defaults
        SQLExecStatement("UPDATE md_cr_category SET name=? WHERE id=? AND original IS NULL", chatGetLastMessage(oSpeaker), sID);
        break;
    }
  }
  else if(sPage == PAGE_CAT)
  {
    if(_CatSelection(nIndex, sPage, oSpeaker))
        dlgChangePage(PAGE_SEARCH_OPTIONS);
  }
  else if(sPage == PAGE_CAT_TIER)
  {
    if(_CatSelection(nIndex, sPage, oSpeaker))
        dlgChangePage(PAGE_TIER_OPTIONS);
  }
  else if(sPage == PAGE_TIER)
  {
    dlgSetPlayerDataString(VAR_TIER, dlgGetSelectionName());
    dlgChangePage(PAGE_CAT_TIER);
  }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
  dlgDeactivatePreservePageNumberOnSelection();
  if(sPage == PAGE_CAT_TIER)
    dlgChangePage(PAGE_TIER);
  else if(sPage == PAGE_TIER || sPage == PAGE_CAT|| sPage == PAGE_MAIN_OPT)
    dlgChangePage(PAGE_MAIN);
  else if(sPage == PAGE_SEARCH_OPTIONS)
    dlgChangePage(PAGE_CAT);
  else if(sPage == PAGE_TIER_OPTIONS)
    dlgChangePage(PAGE_CAT_TIER);
}
void OnAbort(string sPage)
{
  CleanUp();
}
void OnEnd(string sPage)
{
  CleanUp();
}
void main()
{
  dlgOnMessage();
}
