/*
  zdlg_deckstars

  Deck of Stars.  Two uses at present:
  - lay a field of cards
  - look through the deck and see what the people represented are.

*/

#include "inc_zdlg"
#include "inc_log"
#include "inc_divination"

const string OPTIONS = "DS_OPTIONS";
const string CARDLIST = "DS_CARDLIST";
const string ASPECTS = "DS_ASPECTS";

const string PAGE_CARDLIST = "DS_PAGE_CARDS";

const string VAR_CARD = "DS_VAR_CARD";

void Init()
{
  miDVShuffleDeck();

  if (GetElementCount(OPTIONS) == 0)
  {
    AddStringElement("<c � >[Lay a field]</c>", OPTIONS);
    AddStringElement("<c � >[Browse the cards]</c>", OPTIONS);	
    AddStringElement("<c�  >[Done]</c>", OPTIONS);
  }

  if (GetElementCount(CARDLIST) == 0)
  {
    AddStringElement("<c � >[Artist]</c>", CARDLIST);
    AddStringElement("<c � >[Changer of Ways]</c>", CARDLIST);
    AddStringElement("<c � >[Craftsman]</c>", CARDLIST);
    AddStringElement("<c � >[Deceiver]</c>", CARDLIST);
    AddStringElement("<c � >[Lifebringer]</c>", CARDLIST);
    AddStringElement("<c � >[Death's Hand]</c>", CARDLIST);
    AddStringElement("<c � >[Smith]</c>", CARDLIST);
    AddStringElement("<c � >[Slayer]</c>", CARDLIST);
    AddStringElement("<c � >[Battlemage]</c>", CARDLIST);
    AddStringElement("<c � >[Merchant]</c>", CARDLIST);
    AddStringElement("<c � >[Nurturer]</c>", CARDLIST);
    AddStringElement("<c � >[Trickster]</c>", CARDLIST);
    AddStringElement("<c � >[Provider]</c>", CARDLIST);
    AddStringElement("<c � >[Soulstealer]</c>", CARDLIST);
    AddStringElement("<c � >[Judge]</c>", CARDLIST);
    AddStringElement("<c � >[Artificer]</c>", CARDLIST);
    AddStringElement("<c � >[Sire]</c>", CARDLIST);
    AddStringElement("<c � >[Shaman]</c>", CARDLIST);
    AddStringElement("<c � >[Undertaker]</c>", CARDLIST);
    AddStringElement("<c  �>[Go back]</c>", CARDLIST);

    AddStringElement(ASPECT_ARTIST, ASPECTS);
    AddStringElement(ASPECT_CHANGER, ASPECTS);
    AddStringElement(ASPECT_CRAFTSMAN, ASPECTS);
    AddStringElement(ASPECT_DECEIVER, ASPECTS);
    AddStringElement(ASPECT_LIFEBRINGER, ASPECTS);
    AddStringElement(ASPECT_DEATHSHAND, ASPECTS);
    AddStringElement(ASPECT_SMITH, ASPECTS);
    AddStringElement(ASPECT_SLAYER, ASPECTS);
    AddStringElement(ASPECT_BATTLEMAGE, ASPECTS);
    AddStringElement(ASPECT_MERCHANT, ASPECTS);
    AddStringElement(ASPECT_NURTURER, ASPECTS);
    AddStringElement(ASPECT_TRICKSTER, ASPECTS);
    AddStringElement(ASPECT_PROVIDER, ASPECTS);
    AddStringElement(ASPECT_SOULSTEALER, ASPECTS);
    AddStringElement(ASPECT_JUDGE, ASPECTS);
    AddStringElement(ASPECT_ARTIFICER, ASPECTS);
    AddStringElement(ASPECT_SIRE, ASPECTS);
    AddStringElement(ASPECT_SHAMAN, ASPECTS);
    AddStringElement(ASPECT_UNDERTAKER, ASPECTS);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt("Do you want to lay a field, or look through the cards?");
    SetDlgResponseList(OPTIONS);
  }
  else if (sPage == PAGE_CARDLIST)
  {
    string sCard = GetLocalString(OBJECT_SELF, VAR_CARD);
    if (sCard == "") SetDlgPrompt("Select a card to look at.");
    else             SetDlgPrompt(miDVViewCard(oPC, sCard));

    SetDlgResponseList(CARDLIST);
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:  // Lay a field.
      {
        AssignCommand(oPC, miDVLayField(oPC));
        EndDlg();
        break;
      }
      case 1:  // Browse deck
        SetDlgPageString(PAGE_CARDLIST);
        break;
      case 2:  // Leave
        EndDlg();
        break;
    }
  }
  else if (sPage == PAGE_CARDLIST)
  {
    if (selection == GetElementCount(CARDLIST) - 1)
    {
      SetDlgPageString("");
    }
    else
    {
      SetLocalString(OBJECT_SELF, VAR_CARD, GetStringElement(selection, ASPECTS));
    }
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
