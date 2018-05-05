/*
  Name: zdlg_quarter_doo
  Author: Mithreas
  Date: 5 May 2018
  Description: Locked chest script. Uses Z-Dialog.

  - try and pick lock.  If successful, get random loot (gems/gold).
  - try and bash door open.  If successful, get random loot (gems/gold).

*/
#include "inc_crime"
#include "inc_finance"
#include "inc_quarter"
#include "inc_zdlg"

const string MAIN_MENU = "main_menu";

void Init()
{
  Trace(QUARTER, "Initialising locked chest conversation.");
  // This method is called once, at the start of the conversation.
  object oPC = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  DeleteList(MAIN_MENU);
  AddStringElement("<cþ  >[Leave]</c>", MAIN_MENU);
  AddStringElement("<c þ >[Pick Lock]</c>", MAIN_MENU);
  AddStringElement("<c þ >[Bash Lock]</c>", MAIN_MENU);
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    SetDlgPrompt("This is a locked chest.  If you succeed in breaking the lock, you will steal some treasure.");
    SetDlgResponseList(MAIN_MENU);
  }
}

void DoReward(object oPC)
{
  // The PC successfully broke into the chest.  Give them some money.
  object oQuarter = OBJECT_SELF;
  string sOwner   = gsQUGetOwnerID(oQuarter);
  
  // Check that this PC has not stolen from this owner in the last RL day.
  int nTimeout = GetLocalInt(gsPCGetCreatureHide(oPC), "LAST_THEFT_" + sOwner);
  if (nTimeout < gsTIGetActualTimestamp())
  {
    SendMessageToPC(oPC, "You must wait before stealing again from this person.  No more than one theft per RL day!"); 
  }
  
  // Game time is 10x real time, so 10 x seconds x minutes x hours.
  nTimeout = gsTIGetActualTimestamp() + (10 * 60 * 60 * 24);
  SetLocalInt(gsPCGetCreatureHide(oPC), "LAST_THEFT_" + sOwner, nTimeout);
  
  int nBank = gsFIGetAccount(sOwner).nBalance;
  
  // Steal up to 1% of the PC's bank account.  
  int nAmount = Random(nBank / 100);
  
  // Todo - could do gems here to be more interesting.  
  
  gsFITransferFromTo(sOwner, "DUMMY", nAmount);
  GiveGoldToCreature(oPC, nAmount);
  
  // Always log this action.
  WriteTimestampedLogEntry(GetName(oPC) + " has just stolen " + IntToString(nAmount) + " gold from chest owned by " + sOwner);
}

void CheckGuards(object oPC) {

  // The PC tried to bypass the lock.  Spring into action, O forces
  // of law and order.  
  int nCount = 1;
  object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                   PLAYER_CHAR_NOT_PC,
                                   OBJECT_SELF,
                                   nCount);
  float fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);

  while (fDistance < 20.0 && GetIsObjectValid(oNPC))
  {
    int nNation = CheckFactionNation(oNPC);
    if (GetCanSeeParticularPC(oPC, oNPC) && (nNation != NATION_INVALID))
    {
	  AssignCommand(oNPC, ActionSpeakString("Stop, thief!"));
	  int nBounty = GetLocalInt(OBJECT_SELF, "BOUNTY");
      AddToBounty(nNation, nBounty ==0 ? FINE_THEFT : nBounty, oPC);
    }

    nCount++;
    oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                              PLAYER_CHAR_NOT_PC,
                              OBJECT_SELF,
                              nCount);
    fDistance = GetDistanceBetween(OBJECT_SELF, oNPC);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();
  object oQuarter = OBJECT_SELF;

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:  // Leave
        EndDlg();
        break;
      case 1:  // Pick Lock
      {
        int nOpenLock = GetSkillRank(SKILL_OPEN_LOCK, oPC, FALSE);
        int nDC = gsQUGetLockDC(oQuarter);
        if (d20() + nOpenLock >= nDC)
        {
          EndDlg();
		  DoReward(oPC);
          SendMessageToPC(oPC, "You succeed in picking the lock!");
        }
        else
        {
          SendMessageToPC(oPC, "You fail to pick the lock.");
          EndDlg();
        }

        CheckGuards(oPC);

        break;
      }
      case 2:  // Bash Door
      {
        int nStrength = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nDC = gsQUGetLockStrength(oQuarter);
        if (d20() + nStrength >= nDC)
        {
          EndDlg();
		  DoReward(oPC);
          SendMessageToPC(oPC, "You succeed in bashing the lock!");
        }
        else
        {
          SendMessageToPC(oPC, "You fail to force the door.");
          EndDlg();
        }

        CheckGuards(oPC);

        break;
      }
    }
  }
}

void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_quarter_door script");
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
