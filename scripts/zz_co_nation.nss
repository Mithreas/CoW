//::///////////////////////////////////////////////
//:: Name  zz_co_nation
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets up the prompts/responses for nation conversations
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "zz_factions_i"
void OnInit()
{
  if(_GetText(GIVE_POWERS) == GIVE_POWERS)
  {
    _SetText(GIVE_POWERS, "I want to give (or take) some additional powers.");
    _SetText(CHANGE_RANK, "I want to change this employee's division.");
    _SetText(REMOVE_MEMBER, "I need to have this invidiual removed from our employ.");
    _SetText(LEAVE_FACTION, "I want to leave the service of our nation.");
    _SetText(CREATE_RANK, "I need to create the <c þ >[...]</c> division.");
    _SetText(RENAME_RANK, "I want to rename this division to <c þ >[...]</c>.");
    _SetText(REMOVE_RANK, "I want to remove this division.");
    _SetText(ADD_MEMBER, "I want to employ <c þ >[...]</c>.");
    _SetText(VIEW_RANKS, "I would like to view our divisions.");
    _SetText(VIEW_MEMBERS, "I need to view those under our employ.");
    _SetText(SET_SALARY, "I want to set the salary to <c þ >[...]</c>.");
    _SetText(SET_DUE, "I want to change the due to <c þ >[...]</c>.");
    _SetText(SALARIES_DUES, "I would like to view salaries and dues of outsiders.");
    _SetText(VIEW_OUT_DUES, "I want to view the gold coming in from outsiders.");
    _SetText(VIEW_OUT_SAL, "I want to view the gold going out to outsiders.");
    _SetText(ADD_OUTSIDER, "I want to pay a salary to an outside source, <c þ >[...]</c>.");
  }
  Fac_OnInit();
  dlgSetPlayerDataString(VAR_FACTION, GetLocalString(GetModule(), "MD_FA_"+miCZGetName(miCZGetBestNationMatch(GetLocalString(OBJECT_SELF, VAR_NATION)))));
  dlgChangePage(PAGE_ACTION);
}

string GetPrompt(string sPage)
{
  // This is the function that sets up the prompts for each page.
  string sFaction = dlgGetPlayerDataString(VAR_FACTION);
  string sPrompt;
  if(sPage == PAGE_ACTION)
    sPrompt = "Would you like to manage employees or divisions?";
  else if(sPage == PAGE_VIEW_MEMBERS)
    sPrompt = "Here are the current employees. Which would you like to take actions for?" +
              "\n((Yellow: Salary. White: Due))" + FactionTotals(MD_PR_VMD, MD_PR_VMS);
  else if(sPage == PAGE_MEMBER_ACTIONS || sPage == PAGE_OUT_DUES_ACT || sPage == PAGE_OUT_SAL_ACT)
    sPrompt = "Which action would you like to make for " +
              fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) + "?";
  else if(sPage == PAGE_VIEW_RANKS)
  {
    if(onRanks())
    {
      string sID = dlgGetPlayerDataString(VAR_MEMBER);
      string sPlayer = fbFAGetNameFromID(sID);
      sPrompt = "Select which division you want " + sPlayer + " to be apart of. " +
                sPlayer + " currently belongs to division " + md_FAGetRankName(sFaction, IntToString(fbFAGetRankByID(sFaction, sID))) + ".";
    }
    else
    {

      sPrompt = "Here are the current ranks. Which would you like to take actions for?" +
                "\n((Yellow: Salary. White: Due))" + FactionTotals(MD_PR_VRD, MD_PR_VRS);
    }
  }
  else if(sPage == PAGE_GIVE_POWERS)
    sPrompt = "Which type of powers would you like to give or take?";
  else if(sPage == PAGE_RANK_ACTIONS)
    sPrompt = "Which action would you like to make for " +
               md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, dlgGetPlayerDataInt(VAR_RANK))) +
               "?";
  else if(sPage == SALARIES_DUES)
    sPrompt = "Do you want to view or employ an outsider?";
  else if(sPage == PAGE_OUT_DUES)
    sPrompt = "Here is a list of outsiders paying into our settlement: " +  "\n((Yellow: Salary. White: Due))" + FactionTotals(MD_PR2_VAD, MD_PR2_VAS, "2");
  else if(sPage == PAGE_OUT_SAL)
    sPrompt = "Here is a list of outsiders being paid by our settlement: " +  "\n((Yellow: Salary. White: Due))" + FactionTotals(MD_PR2_VAD, MD_PR2_VAS, "2");

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
  {
    string sName = fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER));
    return "Are you sure you want to remove " + sName +
           " from our settlement? This will not remove " + sName +
           " from any of our divisions.";
  }
  else if(sAction == CREATE_RANK)
     return "Are you sure you want to create division " +
            dlgGetPlayerDataString(VAR_RANK) + " in our settlement?";
  else if(sAction == LEAVE_FACTION)
    return "Are you sure you want to leave the service of our settlement?" +
           " You must leave the services of our divisions individually.";
  else if(sAction == ADD_MEMBER)
    return "Are you sure you want to add " + fbFAGetNameFromID(dlgGetPlayerDataString(VAR_MEMBER)) + " to our settlement?";
  else if(sAction == REMOVE_RANK)
    return "Are you sure you want to remove division " + md_FAGetRankName(sFaction, md_FAGetNthRankID(sFaction, dlgGetPlayerDataInt(VAR_RANK))) +
           " from our settlement? This will also remove the sub-faction.";
  else if(sAction == REMOVE_OUTSIDER_SAL)
    return "Do you want to stop paying this  employee a salary?";
  else if(sAction == REMOVE_OUTSIDER_DUE)
    return "Do you want to stop accepting dues from this individual?";
  else if(sAction == PAGE_SELF)
    return "You are currently being paid a salary, do you wish to stop being paid one?";
  else if(sAction == ADD_OUTSIDER)
    return "You have selected " + gsPCGetPlayerName(dlgGetPlayerDataString(VAR_MEMBER)) +
           " How much do you want to pay them? <c þ >[...]</c>.";
  else if(sAction == ADD_OUTSIDER_PAY)
    return "You want to pay " + gsPCGetPlayerName(dlgGetPlayerDataString(VAR_MEMBER)) +
           " " + IntToString(dlgGetPlayerDataInt(VAR_PAY)) + " gold each month?";

  return "Error in Confirmations";
}
