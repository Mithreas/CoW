//::///////////////////////////////////////////////
//:: Name   zz_co_factions
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Sets up the prompts for the -factions conversation
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "zz_factions_i"
void OnInit()
{
  Fac_OnInit();
  if(GetLocalInt(dlgGetSpeakingPC(), "MD_FAC_MAIN"))
    dlgChangePage(PAGE_MAIN);
  else
    dlgChangePage(PAGE_PLEASE_WAIT);
}

string GetPrompt(string sPage)
{
  string sPrompt;
  if(sPage == PAGE_ACTION)
  {
    string sFaction = dlgGetPlayerDataString(VAR_FACTION);
    sPrompt = "You have selected faction " + fbFAGetFactionNameDatabaseID(sFaction) +
              ". Select an action.";

    int nTimestamp = md_GetFactionTime(sFaction);
    if(nTimestamp > 0)
    {
      sPrompt += "\n\nFaction owner needs to check on faction within: ";
      nTimestamp -=  gsTIGetActualTimestamp();
      nTimestamp = gsTIGetRealTimestamp(nTimestamp) / 86400; //amount of seconds within a day.
      sPrompt += IntToString(nTimestamp) + " day(s).";
    }
    //Display the most recent message on the first page
    int nCOption = dlgGetPlayerDataInt(VAR_CREATE);
    object oPC =  dlgGetSpeakingPC();
    if(GetElementCount(PAGE_MESSAGES, oPC) > nCOption)
    {
      sPrompt += "\n\nMost recent OOC message:\n\n" + GetStringElement(nCOption, PAGE_MESSAGES, oPC);
    }
  }
  else if(sPage == PAGE_VIEW_MEMBERS)
  {
    sPrompt = "Select a member. If you have the power to see ranks, "+
              "you will see the member's rank next to their name. " +
              "You can always see the owners rank. Member pay is white for dues and " +
              "yellow for salaries." + FactionTotals(MD_PR_VMD, MD_PR_VMS);;

  }
  else if(sPage == PAGE_MEMBER_ACTIONS || sPage == PAGE_OUT_DUES_ACT || sPage == PAGE_OUT_SAL_ACT)
    sPrompt = "Select an action. The member currently selected is: " +
              fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER));
  else if(sPage == PAGE_VIEW_RANKS)
  {
    if(onRanks())
    {
      string sID = dlgGetPlayerDataString(VAR_MEMBER);
      string sPlayer = fbFAGetNameFromID(sID);
      sPrompt = "Select which rank you want " + sPlayer + " to be apart of. " +
                  sPlayer + " currently belongs to rank " + md_FAGetRankName(dlgGetPlayerDataString(VAR_FACTION), IntToString(fbFAGetRankByID(dlgGetPlayerDataString(VAR_FACTION), sID)));
    }
    else
      sPrompt = "Select which rank you want to modify.";
  }
  else if(sPage == PAGE_GIVE_POWERS)
    sPrompt = "Select the division of power.";
  else if(sPage == PAGE_RANK_ACTIONS)
    sPrompt = "Select a power, if applicable. The rank currently selected is: " +
              md_FAGetRankName(dlgGetPlayerDataString(VAR_FACTION), md_FAGetNthRankID(dlgGetPlayerDataString(VAR_FACTION), dlgGetPlayerDataInt(VAR_RANK)));
  else if(sPage == SALARIES_DUES)
    sPrompt = "Do you want to view or add an outsider?";
  else if(sPage == PAGE_OUT_DUES)
    sPrompt = "Outsiders paying into our faction: " +  "Member pay is white for dues and " +
              "yellow for salaries." + FactionTotals(MD_PR2_VAD, MD_PR2_VAS, "2");
  else if(sPage == PAGE_OUT_SAL)
    sPrompt = "Outsiders being paid into our faction: " +  "Member pay is white for dues and " +
              "yellow for salaries." + FactionTotals(MD_PR2_VAD, MD_PR2_VAS, "2");

  return sPrompt;
}

void main()
{
  dlgOnMessage();
}

/////////////////////////////////////////////////////////////
string onConfirmation()
{
  string sAction = dlgGetPlayerDataString(VAR_ACTIONS);
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);

  if(sAction  == REMOVE_MEMBER)
    return "Are you sure you want to remove " +
           fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) +
           " from faction " + fbFAGetFactionNameDatabaseID(sFaction) + "?";
  else if(sAction == CREATE_RANK)
    return "Are you sure you want to create rank " +
           dlgGetPlayerDataString(VAR_RANK) +
           " in faction " + fbFAGetFactionNameDatabaseID(sFaction) + "?";
  else if(sAction == DISBAND_FACTION)
    return "Are you sure you want to disband faction " +
            fbFAGetFactionNameDatabaseID(sFaction) + "?";
  else if(sAction == LEAVE_FACTION)
    return "Are you sure you want to leave faction " +
            fbFAGetFactionNameDatabaseID(sFaction) + "?";
  else if(sAction == ADD_MEMBER)
    return "Are you sure you want to add " + fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) + " to the faction?";
  else if(sAction == REMOVE_RANK)
    return "Are you sure you want to remove rank " + md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, dlgGetPlayerDataInt(VAR_RANK))) +
           " from faction " + fbFAGetFactionNameDatabaseID(sFaction) + "?";
  else if(sAction == CREATE_MESSAGE)
    return "Do you want to create message " + dlgGetPlayerDataString(VAR_MESSAGE) + "?";
  else if(sAction == ACTION_REMOVE_MES)
    return "Do you want to remove message " + dlgGetPlayerDataString(VAR_MESSAGE) + "?";
  else if(sAction == REMOVE_OUTSIDER_SAL)
    return "Do you want to stop paying this member a salary?";
  else if(sAction == REMOVE_OUTSIDER_DUE)
    return "Do you want to stop accepting dues from this individual?";
  else if(sAction == PAGE_SELF)
    return "You are currently being paid a salary, do you wish to stop being paid one?";
  else if(sAction == ADD_OUTSIDER)
    return "You have selected " + fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) +
           " Enter the amount of pay and click yes.";
  else if(sAction == ADD_OUTSIDER_PAY)
    return "You want to pay " + fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) +
           " " + IntToString(dlgGetPlayerDataInt(VAR_PAY)) + " gold each month?";
  else if(sAction == PAGE_PAY_PER_LIST_S)
    return "You are currently receiving a salary, do you want to pay a due to " + fbFAGetFactionNameDatabaseID(sFaction) + " instead?";
  else if(sAction == PAGE_FACTION_LIST)
    return "You have selected faction " + fbFAGetFactionNameDatabaseID(sFaction) + ". How much do you wish to pay into it every month? (speak number before hitting yes)";
  else if(sAction == MD_FA_OWNER_RANK)
    return "Are you sure you want to give this person the owner rank? Factions of this nature can currently only have one (1) owner." +
           " Giving this person the owner rank will remove the owner rank from yourself. Any nobles granted noblity through this faction will have their status revoked."  ;

  return "Error in Confirmations";
}
