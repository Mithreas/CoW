/**
 *  Fey Diner conversation script.  Fey diners will give PCs quest tasks, or give them small things of value.
 *
 *  A PC won't be able to leave the fey diner area until they complete all the quests they've been given.
 */
#include "inc_challenge"
#include "zdlg_include_i"

const string VAR_DESIRE = "FEY_DESIRE";
const string OPTIONS    = "FEY_OPTIONS";
const string FEY_QUEST  = "CH_Q_FEY";

string _GetDesireResRef(int nDesire)
{
  // Returns the resref of the item that the diner wants the PC to fetch.
  switch (nDesire)
  {
    case 1: return "ambrosia";  // done
    case 2: return "nectar";  // done
    case 3: return "floralwine"; // done
    case 4: return "apple";  // done
    case 5: return "peach";  // done
    case 6: return "songbird"; // done
    case 7: return "mzulftheart"; // Done
    case 8: return "rose";  // done
    case 9: return "sweetberry002";  // done
    case 10: return "it_thrift_022";  // done
  }

  return "";
}

string _GetDesireName(int nDesire)
{
  // Returns the name of the item to be fetched.
  switch(nDesire)
  {
    case 1: return "a bowl of ambrosia";
    case 2: return "a cup of nectar";
    case 3: return "a glass of floral wine";
    case 4: return "an apple";
    case 5: return "a peach";
    case 6: return "a songbird";
    case 7: return "the heart of a Mzulft";
    case 8: return "a long-stemmed rose";
    case 9: return "a sweetberry";
    case 10: return "an egg";
  }

  return "";
}

void _GiveGem(object oPC, int bReward = FALSE)
{
  // Give a gem to the PC.  If bReward is true, it will be a bigger gem.
  // Very small chance of giving out a rare gem.
  int nRandom  = d4();
  int bSpecial = (d20() == 20);
  string sGem  = "";

  if (bSpecial)
  {
    switch (nRandom)
    {
      case 1: sGem = "nw_it_gem009"; break; // Fire Opal
      case 2: sGem = "nw_it_gem005"; break; // Diamond
      case 3: sGem = "nw_it_gem010"; break; // Emerald
      case 4: sGem = "nw_it_gem006"; break; // Ruby
    }
  }
  else if (bReward)
  {
    switch (nRandom)
    {
      case 1: sGem = "nw_it_gem014"; break; // Aventurine
      case 2: sGem = "nw_it_gem015"; break; // Fluorspar
      case 3: sGem = "nw_it_gem003"; break; // Amethyst
      case 4: sGem = "nw_it_gem011"; break; // Garnet
    }
  }
  else
  {
    switch (nRandom)
    {
      case 1: sGem = "nw_it_gem001"; break; // Greenstone
      case 2: sGem = "nw_it_gem007"; break; // Malachite
      case 3: sGem = "nw_it_gem002"; break; // Fire Agate
      case 4: sGem = "nw_it_gem004"; break; // Phenalope
    }
  }

  CreateItemOnObject(sGem, oPC);
}

void Init()
{
  // Check whether this NPC has the default tag.  If so, change it.
  if (GetTag(OBJECT_SELF) == "FeyDiner") CHGiveUniqueTag(OBJECT_SELF);

  // Create a random quest for this diner.
  if (!GetLocalInt(OBJECT_SELF, VAR_DESIRE))
  {
    SetLocalInt(OBJECT_SELF, VAR_DESIRE, d10());
  }

  // Set up dialog options.  This is very simple - there is only one possible response to the glamorous fey.
  if (!GetElementCount(OPTIONS))
  {
    AddStringElement("Yes " + (GetGender(OBJECT_SELF) == GENDER_MALE ? "sir." : "ma'am."), OPTIONS);
  }
}

void PageInit()
{
  object oPC    = GetPcDlgSpeaker();
  object oDiner = OBJECT_SELF;
  int nDesire   = GetLocalInt(oDiner, VAR_DESIRE);

  // Check whether this diner has already dealt with this PC.
  if (GetLocalInt(oDiner, GetName(oPC)))
  {
    switch (d3())
    {
      case 1: SetDlgPrompt("Yes, you can leave me alone now."); break;
      case 2: SetDlgPrompt("I don't need anything more from you; leave me."); break;
      case 3: SetDlgPrompt("Off with you, now."); break;
    }
  }
  // Or check whether this diner has a quest in progress for the PC.
  else if (CHGetQuestState(oPC, oDiner))
  {
    int bComplete  = FALSE;
    string sResRef = _GetDesireResRef(nDesire);

    object oItem = GetFirstItemInInventory(oPC);

    // Note - we can't use tags here because food and drink items have
    // functional tags.
    while (GetIsObjectValid(oItem))
    {
      if (GetResRef(oItem) == sResRef)
      {
        gsCMReduceItem(oItem);
        bComplete = TRUE;
      }

      oItem = GetNextItemInInventory(oPC);
    }

    if (bComplete)
    {
      SetDlgPrompt("Yes, that's what I asked for.  A token for your service.");
      _GiveGem(oPC, TRUE);
      CHSetQuestState(oPC, oDiner, FALSE, FEY_QUEST);
      SetLocalInt(oDiner, GetName(oPC), TRUE);
    }
    else
    {
      SetDlgPrompt("Well?  I'm still waiting for " + _GetDesireName(nDesire) + ".");
    }
  }
  // Is the diner feeling nice?
  else if (d4() == 4)
  {
    if (d3() < 3) SetDlgPrompt("I don't need anything from you, off with you.");
    else
    {
      SetDlgPrompt("Oh, aren't you an interesting one.  Here, take this.");
      _GiveGem(oPC);
    }

    SetLocalInt(oDiner, GetName(oPC), TRUE);
  }
  // Task time.
  else
  {
    switch (d6())
    {
      case 1: SetDlgPrompt("Ah, good.  Fetch me " + _GetDesireName(nDesire) + ", quickly."); break;
      case 2: SetDlgPrompt("Servant!  Bring me " + _GetDesireName(nDesire) + "."); break;
      case 3: SetDlgPrompt("You're a strange one.  Bring me " + _GetDesireName(nDesire) + ", would you?"); break;
      case 4: SetDlgPrompt("Isn't this a beautiful place?  Nearly as beautiful as me.  It would be your pleasure to bring me " + _GetDesireName(nDesire) + ", wouldn't it?"); break;
      case 5: SetDlgPrompt("You must be new here.  Bring me " + _GetDesireName(nDesire) + ", and don't take too long."); break;
      case 6: SetDlgPrompt("Where did they find -you-?  Never mind.  Fetch me " + _GetDesireName(nDesire) + "."); break;
    }

    CHSetQuestState(oPC, oDiner, TRUE, FEY_QUEST);
  }

  SetDlgResponseList(OPTIONS); // OK, that's a bad list name for this particular convo!
}

void HandleSelection()
{
  // Simplest zdlg handler ever.
  EndDlg();
}

void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_feydiner script");
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