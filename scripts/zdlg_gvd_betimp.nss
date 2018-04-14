/*
  zdlg_messengers

  Z-Dialog conversation script for betting imp (cage fight)

*/
#include "inc_chatutils"
#include "inc_zdlg"
#include "zzdlg_color_inc"

// time to wait between fights/bets (10 RL minutes)
const int CF_TIMEOUT = 6000;

const string SLAVEFIGHT_SELECTIONS = "SLAVEFIGHT_SELECTIONS";
const string NORMALFIGHT_SELECTIONS = "NORMALFIGHT_SELECTIONS";
const string BET_AMOUNT = "BET_AMOUNT";
const string BET_DONE    = "BET_DONE";
const string BET_FAILED  = "BET_FAILED";
const string BET_NOMONEY  = "BET_NOMONEY";
const string NO_BETTING  = "NO_BETTING";

void Init()
{
  if (GetElementCount(BET_AMOUNT) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", BET_AMOUNT);
    AddStringElement("<cþ  >[Cancel]</c>", BET_AMOUNT);
  }

  if (GetElementCount(BET_DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", BET_DONE);
  }

  if (GetElementCount(SLAVEFIGHT_SELECTIONS) == 0)
  {
    AddStringElement("The goblin will stab that weakling to death!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("That Worg looks hungry enough to eat a dozen of those slaves! The slave stands no chance to it!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("I'm thinking the slave will end up beaten to pulp by that Gnoll and it's club!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("I'm betting on the Hobgoblin to kill that slave!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("The slave looks kinda tough, no match for the Minotaur ofcourse! Let's see it ripped apart on it's horns!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("The first 5 cage monsters here? Sure, that slave might actually win those, but then it will die from a heartattack when the first real monster will charge out of that cave over there!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("The seventh fight, will be it's last!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("My money is on monster number eight!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("It's been a long time since a slave fought the nineth monster and died! I'm betting this cycle we'll have it happen again!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("I've heared rumors about this slave being something special ... It's master is a fool to think it stands a change against the all-time champion of the cage though! I will enjoy seeing that Beast devour it's entire body when you paying out the bets!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("I'm what you call a real gambler, my money is on the slave beating them all! Yes! All!", SLAVEFIGHT_SELECTIONS);
    AddStringElement("I don't want to place any bets on this fight.", SLAVEFIGHT_SELECTIONS);
  }

  if (GetElementCount(NORMALFIGHT_SELECTIONS) == 0)
  {
    AddStringElement("The cage monster!", NORMALFIGHT_SELECTIONS);
    AddStringElement("The challenger!", NORMALFIGHT_SELECTIONS);
    AddStringElement("I don't want to place any bets on this fight.", NORMALFIGHT_SELECTIONS);
  }

  SetDlgPageString("root");

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oLever = GetObjectByTag("gvd_cf_lever");
  string sRootText  = "*eyes you all over looking for coinbags* There is no fight to bet on right now, but come back later anytime!";
  string sNextPage  = BET_DONE;
  int iCF_BetLimit = GetLocalInt(oLever, "iCF_BetLimit");
  int iFightStatus = GetLocalInt(oLever,"iCF_FightBusy");
  int iSlaveFight = GetLocalInt(oLever,"iCF_SlaveFight");
  int iCurrentTime  = GetLocalInt(GetModule(), "GS_TIMESTAMP");

      // first check if the PC still has an old bet, which is no longer valid
      if (GetLocalInt(oPC, "iCF_BetTimer") != 0) {
        if ((iCurrentTime - GetLocalInt(oLever, "iCF_WaitTimer")) > CF_TIMEOUT) {
          if ((iCurrentTime - GetLocalInt(oPC, "iCF_BetTimer")) > CF_TIMEOUT) {
            //SendMessageToPC(oPC,"Cleaning...");
            // clean up old betting settings
            DeleteLocalInt(oPC, "iCF_BetAmount");
            DeleteLocalInt(oPC, "iCF_BetChoice");
            DeleteLocalInt(oPC, "iCF_BetTimer");
          }
        }
      }

  int iBetAmount = GetLocalInt(oPC, "iCF_BetAmount");

  if (sPage == "root") {
    // check the status of the cage fight
    if ((iFightStatus == 3) || (iFightStatus == 0)) {
      // fight is finished

      //did the PC place a bet?
      if (iBetAmount > 0) {
        // yes
        int iBetWon = 0;

        // slavefight or normal one?
        if (iSlaveFight == 1) {

          // slavefight, did PC place bet on right creature?
          int iMonsterBet = GetLocalInt(oPC,"iCF_BetChoice")-10;
          int iMonsterReached = GetLocalInt(oLever,"iCF_CageNr");

          if (iMonsterReached == 10) {
            // fought the all-time champion, then check if won or not, otherwise it's always lost
            if (GetLocalInt(oLever,"iCF_WinLose") == 1) {
              // slave beats them all
              if (iMonsterBet == 11) {
                // correct bet
                iBetWon = 1;
              }
            } else {
              // slave beaten by cage champion
              if (iMonsterBet == 7) {
                // correct bet
                iBetWon = 1;
              }
            }
          } else {
            if (iMonsterBet == iMonsterReached) {
              // correct bet
              iBetWon = 1;
            }
          }
        } else {
          // normal one, did PC place bet on the right creature?
          if (GetLocalInt(oLever,"iCF_WinLose") == GetLocalInt(oPC,"iCF_BetChoice")) {
            // yes
            iBetWon = 1;
          }
        }

        // bet won?
        if (iBetWon == 1) {
          // PC won bet

          // pay out
          GiveGoldToCreature(oPC, iBetAmount*2);

          sRootText = "*the imp hands over the betting amount with a snarl*";

        } else {
          // PC lost bet
          sRootText = "You lost the bet! *grins wickedly* Come back anytime!";

        }

        // clean up betting settings
        DeleteLocalInt(oPC, "iCF_BetAmount");
        DeleteLocalInt(oPC, "iCF_BetChoice");


      } else {
        // no bets, no gains
        //sRootText = "Don't bother me if you're not placing bets, I've got work to do here!";
      }

    }
    else if (iFightStatus == 2) {
      // fight is busy, no more bets
      sRootText = "*turns his head briefly from the cagefight* No more bets! Come back later!";
    }
    else if (iFightStatus == 1) {
      // fight is arranged, but hasn't started yet

      // PC already placed a bet?
      if (iBetAmount > 0) {
        // yes
        sRootText = "The fight hasn't started yet, patience, patience!";
      } else {
        // no, is a slavefight arranged?
        if (iSlaveFight == 1) {
          // slavefight
          sRootText = "*flap flap* Looking to earn some easy money eh? You found the right Imp! We have a slavefight this cycle! It will start fighting the Goblin and we'll see how long it lasts when the opponents get tougher! How long do you think this slave will last in the cage?";
          sNextPage = SLAVEFIGHT_SELECTIONS;
        } else {
          // normal fight

          // determine monstername for convo purpose
          int iMonster = GetLocalInt(oLever, "iCF_CageNr");
          string sMonsterName;
          if (iMonster == 1) sMonsterName = "Goblin";
          else if (iMonster == 2)  sMonsterName = "Worg";
          else if (iMonster == 3)  sMonsterName = "Gnoll";
          else if (iMonster == 4)  sMonsterName = "Hobgoblin";
          else if (iMonster == 5)  sMonsterName = "Minotaur";
          else if (iMonster == 6)  sMonsterName = "The first monster from inside that cave";
          else if (iMonster == 7)  sMonsterName = "The second monster from inside that cave";
          else if (iMonster == 8)  sMonsterName = "The third monster from inside that cave";
          else if (iMonster == 9)  sMonsterName = "The fourth monster from inside that cave";
          else sMonsterName = "The Ultimate Champion of the Cage";

          sRootText = "*flap flap* Looking to earn some easy money eh? You found the right Imp! Someone will be fighting the " + sMonsterName + " soon! Who do you think will win this fight?";
          sNextPage = NORMALFIGHT_SELECTIONS;
        }
      }
    }
    else {
      // no fights to bet on atm
    }

    SetDlgPrompt(sRootText);
    SetDlgPageString(sNextPage);
    SetDlgResponseList(sNextPage);

  }
  else if (sPage == BET_AMOUNT)
  {
    SetDlgPrompt("*just grins widely* How much money do you want to bet on that? The maximum bet on this fight is " + IntToString(iCF_BetLimit) + " gold. \n\n<c þ >((speak the amount), then press Next))");
    SetDlgResponseList(sPage);
  }
  else if (sPage == BET_DONE)
  {
    SetDlgPrompt("Good, good *evil grin* Enjoy the fight!");
    SetDlgResponseList(sPage);
  }
  else if (sPage == BET_FAILED)
  {
    SetDlgPrompt("I have no idea what your talking about, either you bet money, or you don't bet at all.");
    SetDlgResponseList(BET_DONE);
  }
  else if (sPage == BET_NOMONEY)
  {
    SetDlgPrompt("Bring enough money if you want to place a bet like that!");
    SetDlgResponseList(BET_DONE);
  }
  else if (sPage == NO_BETTING)
  {
    SetDlgPrompt("Don't bother me if you're not placing bets, I've got work to do here!");
    SetDlgResponseList(BET_DONE);  
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  object oLever = GetObjectByTag("gvd_cf_lever");
  int iCurrentTime  = GetLocalInt(GetModule(), "GS_TIMESTAMP");

  // debugging
  //SendMessageToPC(oPC,sPage);

  if (sPage == SLAVEFIGHT_SELECTIONS) {
    // slave fight bet

    if (selection != 11) {

      // store betting choice, 11 = goblin, 12 = worg, 13 = gnoll, 14 = hobgoblin,
      // 15 = minotaur, 16 = monster 6, 17 = monster 7, 18 = 8, 19 = 9, 20 is 10 and 21 is wins all
      SetLocalInt(oPC,"iCF_BetChoice",selection + 11);

      // ask for betting amount now
      SetDlgPageString(BET_AMOUNT);

    } else {
      SetDlgPageString(NO_BETTING);
    }

  } else if (sPage == NORMALFIGHT_SELECTIONS) {
    // normal fight bet

    if (selection != 2) {
      // store betting choice, 0 = monster, 1 = pc fighter
      SetLocalInt(oPC,"iCF_BetChoice",selection);

      // ask for betting amount now
      SetDlgPageString(BET_AMOUNT);

    } else {
      SetDlgPageString(NO_BETTING);
    }

  } else if (sPage == BET_AMOUNT) {

    if (selection == 0) {

      // determine the amount of gold the PC wants to bet
      string sBetAmount = chatGetLastMessage(oPC);
      int iBetAmount = StringToInt(sBetAmount);
      int iBetLimit = GetLocalInt(oLever,"iCF_BetLimit");

      // temp for testing
      //iBetAmount = 10;

      if (iBetAmount <= 0) {
        // no amount spoken
        SetDlgPageString(BET_FAILED);

      } else {
        if (iBetAmount > iBetLimit) {
          iBetAmount = iBetLimit;
        }

        // does the PC have enough money?
        if(GetGold(oPC) >= iBetAmount) {
          // arrange the bet
          SetLocalInt(oPC,"iCF_BetAmount",iBetAmount);

          // get the amount of gold from the PC
          TakeGoldFromCreature(iBetAmount, oPC);

          // store the time of the bet, to check if the PC gets back in time to collect it later
          // same timeout as between fights to prevent collecting bets on old fights
          SetLocalInt(oPC, "iCF_BetTimer", iCurrentTime);

          SetDlgPageString(BET_DONE);

        } else {
          // not enough money
          SetDlgPageString(BET_NOMONEY);

        }

      }
    } else {
      // PC cancelled convo
      SetDlgPageString(NO_BETTING);
    }


  } else {
    // The Done response list has only one option, to end the conversation.
    EndDlg();
  }

}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
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
