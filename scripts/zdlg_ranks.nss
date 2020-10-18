/*
  Name: zdlg_ranks
  Author: Mithreas
  Date: Apr 9 2006
  Description: Allows players to see information about their faction members. Uses Z-Dialog.
  
  @@@ TODO - disburse keys etc to people of the right ranks.
*/
#include "inc_reputation"
#include "inc_zdlg"

const string MAIN_MENU   = "ranks_options";
const string DONE        = "ranks_done";
const string PAGE_ME     = "ranks_aboutme";
const string PAGE_OTH    = "ranks_aboutothers";

const string MEMBERS     = "ranks_members";
const string MEMBER_ID   = "ranks_mbr_id";
const string MEMBER_REPS = "ranks_mbr_reps";

void Init()
{
  if (GetElementCount(MAIN_MENU) == 0)
  {
    AddStringElement("I'd like to find out more about my own rank.", MAIN_MENU);
	AddStringElement("I'd like to learn more about the others serving with us.", MAIN_MENU);
	AddStringElement("Nothing right now, thank you.", MAIN_MENU);
  }
  
  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("Done", DONE);
  }
}

void PageInit()
{
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oNPC  = OBJECT_SELF;
  
  if (CheckFactionNation(oNPC) != GetPCFaction(oPC))
  {
    SetDlgPrompt("I don't think you belong here.  I suggest you leave.");
	SetDlgResponseList(DONE);
	return;
  }
  
  if (sPage == "")
  {
    SetDlgPrompt("Welcome.  I keep records about the people who live here, if you are interested.");
	SetDlgResponseList(MAIN_MENU);
  }
  else if (sPage == PAGE_ME)
  {
    struct repRank myRank = GetPCFactionRank(oPC);
	string sLevel;
	
	if (myRank.sName == "Outcast")
	{
	  SetDlgPrompt("Ah. You're -that- one. Go away please, I don't want to be associated with you.");
	  SetDlgResponseList(DONE);
	  return;
	}
	
	if (GetRacialType(oNPC) == RACIAL_TYPE_HUMAN)
	{
	  switch (myRank.nLevel)
	  {
		case 3: sLevel = "Noble"; break;
		case 2: sLevel = "Officer"; break;
	    default: sLevel = "Retainer"; break;
	  }
	}
	else
	{
	  switch (myRank.nLevel)
	  {
		case 3: sLevel = "Elder"; break;
		case 2: sLevel = "Champion"; break;		
	    default: sLevel = "Resident"; break;
	  }
	}
	
    SetDlgPrompt("Certainly.  You are currently a " + myRank.sName + ", which gives you the rights of " + sLevel + " among us.");
    SetDlgResponseList(DONE);	
  }
  else if (sPage == PAGE_OTH)
  {
    string sFaction = IntToString(GetPCFaction(oPC));
    SQLExecDirect("SELECT a.tag, a.val FROM rep_pcrep AS a INNER JOIN gs_pc_data AS b ON a.player = b.id WHERE DATE_SUB(CURDATE(), INTERVAL 30 DAY) < b.modified AND a.name LIKE '%" + sFaction + "' AND b.deleted = 0 ORDER BY CAST(a.val as unsigned) DESC"); 

    DeleteList(MEMBERS);
	DeleteList(MEMBER_REPS);

    while (SQLFetch())
    {
	  AddStringElement(SQLGetData(1), MEMBERS);
	  AddStringElement(SQLGetData(2), MEMBER_REPS);
    }	
	
	SetDlgPrompt("The following people are in active service at present.  Let me know if you wish to know more about any of them.");
	SetDlgResponseList(MEMBERS);
  }
  else if (sPage == MEMBERS)
  {
    string sFaction = GetFactionName(miBAGetBackground(oPC));
    int nMemberID   = GetLocalInt(OBJECT_SELF, MEMBER_ID);
	int nMemberRep  = StringToInt(GetStringElement(nMemberID, MEMBER_REPS));
	struct repRank rRank = GetPCRank(sFaction, nMemberRep);
	string sLevel;
	
	if (rRank.sName == "Outcast")
	{
	  sLevel = "Outcast";
	}		
	else if (GetRacialType(oNPC) == RACIAL_TYPE_HUMAN)
	{
	  switch (rRank.nLevel)
	  {
		case 3: sLevel = "Noble"; break;
		case 2: sLevel = "Officer"; break;
	    default: sLevel = "Retainer"; break;
	  }
	}
	else
	{
	  switch (rRank.nLevel)
	  {
		case 3: sLevel = "Elder"; break;
		case 2: sLevel = "Champion"; break;		
	    default: sLevel = "Resident"; break;
	  }
	}
	
	SetDlgPrompt(GetStringElement(nMemberID, MEMBERS) + " is a " + rRank.sName + " with all the rights and privileges of a " + sLevel + ".");
	SetDlgResponseList(DONE);
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  string sPage   = GetDlgPageString();
  object oPC     = GetPcDlgSpeaker();
  object oNPC    = OBJECT_SELF;
  string sResponseList   = GetDlgResponseList();
  
  if (CheckFactionNation(oNPC) != GetPCFaction(oPC))
  {
    EndDlg();
	return;
  }
  
  if (sPage == "")
  {
    switch (selection)
	{
	  case 0: 
	    SetDlgPageString(PAGE_ME);
		break;
	  case 1:
	    SetDlgPageString(PAGE_OTH);
		break;
	  default:
	    EndDlg();
		break;
	}
  }
  else if (sPage == PAGE_ME)
  {
    EndDlg();
  }
  else if (sPage == PAGE_OTH)
  {
    SetLocalInt(OBJECT_SELF, MEMBER_ID, selection);
	SetDlgPageString(MEMBERS);
  }
  else if (sPage == MEMBERS)
  {
    EndDlg();
  }
}


void main()
{
  int nEvent = GetDlgEventType();
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
