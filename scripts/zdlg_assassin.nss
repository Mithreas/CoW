/*
  Name: zdlg_assassin
  Author: Mithreas
  Date: 11 Nov 2015
  Description:
    Assassin's Guild NPC.  Accepts and cancels contracts.
*/
#include "fb_inc_chat"
#include "inc_assassin"
#include "zdlg_include_i"

const string CONTINUE = "DLG_CONTINUE";
const string OPTIONS  = "DLG_OPTIONS";

const string PAGE_MAIN             = "DLG_PAGE_MAIN";
const string PAGE_ENTER_NAME       = "DLG_PAGE_NAME";
const string PAGE_ENTER_AMOUNT     = "DLG_PAGE_VALUE";
const string PAGE_CANCEL_CONTRACT  = "DLG_PAGE_CANCEL";
const string PAGE_CONFIRM_CONTRACT = "DLG_PAGE_CONFIRMCON";
const string PAGE_CONFIRM_CANCEL   = "DLG_PAGE_CONFIRMCAN";

const int MIN_CONTRACT_VALUE = 10000;

void Init()
{
  Trace(ZDIALOG, "Initialising Assassin Guildmaster.");
  // This method is called once, at the start of the conversation.
  
  object oPC = GetPcDlgSpeaker();

  // Is the PC a victim?
  struct miAZContract xContract = miAZGetContractByVictim(gsPCGetPlayerID(oPC));
  int nContract                 = StringToInt(xContract.sID);
  int nContractValue            = xContract.nValue;
  
  SetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT", nContract);
  SetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_VALUE", nContractValue);
  DeleteLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_NAME");
  
  DeleteList(OPTIONS);
  
  AddStringElement("<c þ >[Place Contract]</c>", OPTIONS);
  AddStringElement("<cþ  >[Leave]</c>", OPTIONS);
  if (nContract) AddStringElement("<cþ  >[Cancel Contract]</c>", OPTIONS);
    
  if (GetElementCount(CONTINUE) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", CONTINUE);
    AddStringElement("<cþ  >[Leave]</c>", CONTINUE);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page. 
  object oPC = GetPcDlgSpeaker();
  int bAssassin = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
  string sPage = GetDlgPageString();
  
  int nValue = GetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_VALUE");
  string sName = GetLocalString(OBJECT_SELF, "MI_AZ_CONTRACT_NAME");
  
  if (sPage == "" || sPage == PAGE_MAIN)
  {
    SetDlgPrompt("Welcome.  What can we do for you today?");
	SetDlgResponseList(OPTIONS);
  }
  else if (sPage == PAGE_ENTER_NAME)
  {
    SetDlgPrompt("And who is it who has become an irritation?");
	SetDlgResponseList(CONTINUE);
  }
  else if (sPage == PAGE_ENTER_AMOUNT)
  {
    SetDlgPrompt("I see. And how much is this problem worth to you?\n\nThe victim can cancel your contract by buying it out, so bid accordingly.");
	SetDlgResponseList(CONTINUE);
  }
  else if (sPage == PAGE_CONFIRM_CONTRACT)
  {
    SetDlgPrompt("So, you wish our assistance with " + sName + " for the sum of " 
	             + IntToString(nValue) + ". Yes?");
	
	SetDlgResponseList(CONTINUE);
  }
  else if (sPage == PAGE_CANCEL_CONTRACT)
  {
    SetDlgPrompt("So you wish to buy us off, hm?  It will cost you " + IntToString(nValue) + ".");
	SetDlgResponseList(CONTINUE);
  }
  else if (sPage == PAGE_CONFIRM_CANCEL)
  {
    SetDlgPrompt("Very well, once you have paid us, the contract will be annulled.");
	SetDlgResponseList(CONTINUE);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();
  
  if (sPage == "" || sPage == PAGE_MAIN)
  {
    switch (selection)
	{
	  case 0:
	    // If we are an assassin, don't allow this option.
		if (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC))
		{
		  SpeakString("I'm sorry, but members of the Guild are forbidden from placing contracts.");
		}
		else
		{
	      SetDlgPageString(PAGE_ENTER_NAME);
		}  
		break;
	  case 1:
	    EndDlg();
		break;
	  case 2:
	    SetDlgPageString(PAGE_CANCEL_CONTRACT);
		break;
	}
  }
  else if (sPage == PAGE_ENTER_NAME)
  {
    switch (selection)
	{
      case 0:
	  {
        // Find a player of this name.
        string sName = chatGetLastMessage(oPC);
        
        SQLExecStatement("SELECT id,name FROM gs_pc_data WHERE name LIKE ? ORDER BY MODIFIED DESC LIMIT 1", sName + "%");

        if (SQLFetch())
        {
          SetLocalString(OBJECT_SELF, "MI_AZ_CONTRACT_TARGET", SQLGetData(1));
          SetLocalString(OBJECT_SELF, "MI_AZ_CONTRACT_NAME", SQLGetData(2));
          SetDlgPageString(PAGE_ENTER_AMOUNT);
        }
        else
        {
          SendMessageToPC(oPC, "No target found.  Please say the name of your target.");
        }

        break;
      }
	  case 1:
	    SetDlgPageString(PAGE_MAIN);
		break;
	}		  
  }
  else if (sPage == PAGE_ENTER_AMOUNT)
  {
    switch (selection)
	{
      case 0:
	  {
        // Get the amount.
        int nValue = StringToInt(chatGetLastMessage(oPC));
        
        if (nValue && nValue >= MIN_CONTRACT_VALUE)
        {
          SetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_VALUE", nValue);
          SetDlgPageString(PAGE_CONFIRM_CONTRACT);
        }
        else
        {
          SendMessageToPC(oPC, "Please speak just a number.  Contracts must be worth 10k or more.");
        }

        break;
      }
	  case 1:
	    SetDlgPageString(PAGE_ENTER_NAME);
		break;
	}	
  }
  else if (sPage == PAGE_CONFIRM_CONTRACT)
  {
    switch (selection)
	{
      case 0:
	  {
	    int nValue = GetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_VALUE");
		
		if (GetGold(oPC) < nValue)
		{
		  SendMessageToPC(oPC, "You don't have enough gold!");
	      SetDlgPageString(PAGE_MAIN);
		}
		else
		{
		  TakeGoldFromCreature(nValue, oPC, TRUE);
		}
		
        // Place the contract.
        string sNewContract = miAZCreateContract(gsPCGetPlayerID(oPC), 
		                                         GetLocalString(OBJECT_SELF, "MI_AZ_CONTRACT_TARGET"),
												 nValue);
        
		if (sNewContract != "")
		{
		  SendMessageToPC(oPC, "Contract placed.");
		  WriteTimestampedLogEntry(GetName(oPC) + " just took out a contract for " + IntToString(nValue) + 
		    " on " + GetLocalString(OBJECT_SELF, "MI_AZ_CONTRACT_NAME"));
		}
		else
		{
          SendMessageToPC(oPC, "Your target already has a contract on them.  No more than one contract per mark.");	  
		}
		
        SetDlgPageString(PAGE_MAIN);

        break;
      }
	  case 1:
	    SetDlgPageString(PAGE_ENTER_NAME);
		break;
	}
  }
  else if (sPage == PAGE_CANCEL_CONTRACT)
  {
    switch (selection)
	{
      case 0:
        SetDlgPageString(PAGE_CONFIRM_CANCEL);
        break;
	  case 1:
	    SetDlgPageString(PAGE_MAIN);
		break;
	}
  }
  else if (sPage == PAGE_CONFIRM_CANCEL)
  {
    switch (selection)
	{
      case 0:
	  {
        // Cancel the contract, if the victim has enough gold.
		int nValue = GetLocalInt(OBJECT_SELF, "MI_AZ_CONTRACT_VALUE");
		
		if (GetGold(oPC) < nValue)
		{
		  SendMessageToPC(oPC, "You don't have enough gold!  You need " + IntToString(nValue) + "gp.");
		}
		else
		{
		  TakeGoldFromCreature(nValue, oPC, TRUE);
          miAZCancelContract(gsPCGetPlayerID(oPC));
          SendMessageToPC(oPC, "Contract annulled.");
		}
		
        SetDlgPageString(PAGE_MAIN);
        break;
      }
	  case 1:
	    SetDlgPageString(PAGE_MAIN);
		break;
	}
  }
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_assassin script");
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
