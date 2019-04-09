/*
  Name: inc_activity
  Author: Mithreas
  Date: 19/01/06
  Description:
  Include for "training scripts" - weapon training, researching and praying.
  
  22 Apr 18 - implemented research findings via external wiki.
  - Articles are put into a MediaWiki pointed at the same database as the server.
  - Articles are tagged with the category in RESEARCH_CATEGORY to be searched by
    this system.
  - Articles may be linked to the RESEARCH_CATEGORY_L10, RESEARCH_CATEGORY_L20 etc
    categories to restrict them to PCs with 10+ base lore from base skill, feats and
	base intelligence points (i.e. gear is excluded).

*/
#include "inc_log"
#include "inc_database"
#include "inc_spells"
#include "inc_stacking"
#include "inc_xp"

// Database configuration
const string WIKI_PREFIX             = "lorewiki";
const string RESEARCH_CATEGORY       = "Human_Research";
const string RESEARCH_CATEGORY_ELF   = "Elven_Research";
const string RESEARCH_CATEGORY_L10   = "Lore_10";
const string RESEARCH_CATEGORY_L20   = "Lore_20";

const string TRAINING      = "TRAINING";
const string IS_DOJO       = "is_dojo";
const string IS_LIB        = "is_library";
const string IS_TEMP       = "is_temple";
const string TEMPLATE_NOTE = "research_note";
//------------------------------------------------------------------------------
// Gives a small amount of XP to oPC. If InGoodArea for the task, give more xp.
//------------------------------------------------------------------------------
void GiveXP(object oPC, int InGoodArea = FALSE);

//------------------------------------------------------------------------------
// Give an appropriate training boost to the PC.
//------------------------------------------------------------------------------
void GiveTrainingBoost(object oPC);

//------------------------------------------------------------------------------
// Give a prayer point to oPC's god.
// Also has a chance of raising a nearby dead PC.
//------------------------------------------------------------------------------
void GivePrayerPoint(object oPC);

//------------------------------------------------------------------------------
// Give a titbit of information to the PC.
//------------------------------------------------------------------------------
void GiveResearchInformation(object oPC);

//------------------------------------------------------------------------------
// Floating text with a random training message.
//------------------------------------------------------------------------------
void TrainingDescription(object oPC);

//------------------------------------------------------------------------------
// Floating text with a random prayer message.
//------------------------------------------------------------------------------
void PrayerDescription(object oPC);

//------------------------------------------------------------------------------
// Floating text with a random research message.
//------------------------------------------------------------------------------
void ResearchDescription(object oPC);

// What you'd expect.
int d40();

int d40()
{
  return (( (d4() - 1) * 10 ) + d10());
}

// Internal method to clean up MediaWiki formatting.
// Replace "_" with " "
// Remove anything inside [[ ]]
// Options to do more (e.g. ''' etc.)
//
// This is a very expensive method, and would be better outsourced to Ruby. 
string _Cleanup(string sText)
{
  string sOutput = "";
  int nMax = GetStringLength(sText);
  int nCount = 0;
  int bSkip  = FALSE;
  
  for (nCount; nCount < nMax; nCount++)
  {
    string sChar = GetSubString(sText, nCount, 1);
	
	if (sChar == "_")
    {
      sChar = " ";
	}
	else if (sChar == "[")
	{
	  bSkip = TRUE;
	}  
	else if (sChar  == "]") 
	{
	  bSkip = FALSE;
	  continue;
	}
	
	if (!bSkip)
	{
	  sOutput += sChar;
	}
  }
  
  return sOutput;
}

void GiveResearchInformation(object oPC)
{
  Trace(TRAINING, "GiveResearchInformation called for PC: " + GetName(oPC));
  
  // TODO: support other races than humans.
  string sResearchCategory = RESEARCH_CATEGORY;
  
  if (GetRacialType(oPC) == RACIAL_TYPE_ELF) 
  {
    sResearchCategory = RESEARCH_CATEGORY_ELF;
	
	// Possibly give a spell instead if the PC is a Wizard.
	if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && d100() > 90)
	{
	  int nMaxLevel = (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) + 1) / 2;
	  int nSpell = GetRandomArcaneSpell(Random(nMaxLevel + 1));
	  
	  Log(TRAINING, "Creating scroll " + IntToString(nSpell) + " for " + GetName(oPC));
	  object oScroll = CreateItemOnObject("x2_it_cfm_bscrl", oPC, 1, "spell_" + IntToString(nSpell));
	  
	  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IPGetIPConstCastSpellFromSpellID(nSpell), IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE), oScroll);
	  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(CLASS_TYPE_WIZARD), oScroll);
	  
	  SetName(oScroll, "Researched Spell");
	  SendMessageToPC(oPC, "You researched a spell!");
	  return;
	}
  }
  
  // Query that queries the category links table to get a random article in the correct category. 
  SQLExecDirect("SELECT a.cl_from FROM " + WIKI_PREFIX + "categorylinks AS a WHERE a.cl_to = '" + sResearchCategory + 
  "' " + SQLRandom());
  string sPage = "";
  
  if (SQLFetch())
  {
    sPage = SQLGetData(1);
  }
  else
  {
    Trace(TRAINING, "No entries found in database.");
    return;
  }
  
  // Get the most recent revision of that page. 
  SQLExecDirect("SELECT a.page_title,c.old_text FROM " + WIKI_PREFIX + "page AS a INNER JOIN " + WIKI_PREFIX + "revision AS b ON " +
  "a.page_id=b.rev_page INNER JOIN " + WIKI_PREFIX + "text AS c ON b.rev_text_id=c.old_id WHERE a.page_id=" + sPage + " ORDER BY b.rev_id DESC LIMIT 1");	
	
  if (SQLFetch())
  {
	string sPageTitle   = _Cleanup(SQLGetData(1));
	string sPageContent = _Cleanup(SQLGetData(2));
	
	int nLore = gsCMGetBaseSkillRank(SKILL_LORE, ABILITY_INTELLIGENCE, oPC);
	
	int bLore10 = SQLExecAndFetchSingleInt("SELECT cl_from FROM " + WIKI_PREFIX + "categorylinks WHERE cl_to = '" +
	  RESEARCH_CATEGORY_L10 + "' AND cl_from = '" + sPage + "'");
	int bLore20 = SQLExecAndFetchSingleInt("SELECT cl_from FROM " + WIKI_PREFIX + "categorylinks WHERE cl_to = '" +
	  RESEARCH_CATEGORY_L20 + "' AND cl_from = '" + sPage + "'");
	
	if (nLore >= 20 ||
	    nLore >= 10 && !bLore20 ||
		!bLore10)
	{
	  // PC has enough lore to read this article.
	  object oNote = CreateItemOnObject(TEMPLATE_NOTE, oPC, 1, "research_note_" + sPage);
	  
	  // We use a different tag above to allow notes on the same topic to stack.  Store the "real" tag here so 
	  // e.g. quest scripts can find it. 
	   SetLocalString(oNote, NO_STACK_TAG, "research_note");
	  
	  SetName(oNote, sPageTitle);
	  SetDescription(oNote, sPageContent);
	  
	  SendMessageToPC(oPC, "You found an old document, called " + sPageTitle);
	}
	else
	{
	  SendMessageToPC(oPC, "You find an old document, but aren't able to interpret it.  A pity, it looked interesting.  More Lore might help in future.");
	}
  }
}

void GiveXP(object oPC, int InGoodArea = FALSE)
{
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC)
               + GetLevelByPosition(3, oPC);

  float fLevel = IntToFloat(nLevel);
  float fXP;

  // 1xp per level up to 10. 0.9 per level up to 20. 0.7 to 30 and 0.5 to 40.
  if (nLevel < 6)
  {
    fXP = 1.0 * fLevel;
  }
  else if (nLevel < 11)
  {
    fXP = 5 + 0.9 * (fLevel - 5.0);
  }
  else if (nLevel < 16)
  {
    fXP = 5 + 4.5 + 0.7 * (fLevel - 10.0);
  }
  else
  {
    fXP = 5 + 4.5 + 3.5 + 0.5 * (fLevel - 15.0);
  }

  // Module-wide XP scale control.
  float fMultiplier = GetLocalFloat(GetModule(), "XP_RATIO");

  if (fMultiplier == 0.0) fMultiplier = 1.0;

  fXP *= fMultiplier;

  int nXP = FloatToInt(fXP);

  if (GetHitDice(oPC) < 10) gsXPGiveExperience(oPC, nXP);
  else gvd_AdventuringXP_GiveXP(oPC, nXP, "Training");
}

void GiveTrainingBoost(object oPC)
{
  Trace(TRAINING, "GiveTrainingBoost called for PC: " + GetName(oPC));

  object oTrainBuffObject = GetItemPossessedBy(oPC, "obj_trainbuff");
  int nNumOfUses = 0;
  string sName = GetName(oPC);
  if (oTrainBuffObject == OBJECT_INVALID)
  {
    Trace(TRAINING, "Creating new widget");
    oTrainBuffObject = CreateItemOnObject("obj_trainbuff", oPC);
  }
  else
  {
    nNumOfUses = GetLocalInt(oTrainBuffObject, "train_uses_" + sName);
    Trace(TRAINING, "Widget already exists with " + IntToString(nNumOfUses) +
                     " uses.");
  }

  nNumOfUses++;
  SetLocalInt(oTrainBuffObject, "train_uses_" + sName, nNumOfUses);
}

void GivePrayerBoon(object oPC)
{
  Trace(TRAINING, "GivePrayerPoint called for PC: " + GetName(oPC));

  string sDeity = GetDeity(oPC);
  if (sDeity == "")
  {
    SendMessageToPC(oPC, "(( You don't have a deity to pray to! ))");
    return;
  }

  // 25% chance of raising a nearby dead PC.
  if (d4() -3)
  {
    Trace(TRAINING, "Raising nearby dead PC, if any.");
    int nCount = 1;
    object oCorpse = GetNearestObjectByTag("GS_PLACEABLE", oPC, nCount);
    float fDistance = GetDistanceBetween(oPC, oCorpse);
	string sCorpse;
	
    while ((fDistance < 20.0) && (GetIsObjectValid(oCorpse)))
    {
      sCorpse = GetLocalString(oCorpse, "GS_TARGET");

      if (sCorpse != "") 
	  {
        // player still around?
        if (gsPCGetPlayerByID(sCorpse) != OBJECT_INVALID) 
		{
          Trace(TRAINING, "Found dead PC to raise: "+GetName(oCorpse));
          SetLocalInt(oCorpse, "GVD_ALTAR_RAISE", 1);
          SetLocalObject(oCorpse, "GVD_ALTAR_USER", oPC);
          ExecuteScript("gs_pc_spell", oCorpse);
		}  
      }

      nCount ++;
      oCorpse = GetNearestObject(OBJECT_TYPE_CREATURE, oPC, nCount);
      fDistance = GetDistanceBetween(oPC, oCorpse);
    }
  }
}

void TrainingDescription(object oPC)
{
  Trace(TRAINING, "TrainingDescription called for PC: " + GetName(oPC));
  // Play a message half the time.
  if (d2() - 1) return;

  string sMessage = "";

  switch (d40())
  {
    case 1:
      sMessage = "You feel sweat beading on your brow.";
      break;
    case 2:
      sMessage = "This is hard work!";
      break;
    case 3:
      sMessage = "Your arms begin to tire, but you carry on anyway.";
      break;
    case 4:
      sMessage = "The dummy is shaken by a perfectly placed blow.";
      break;
    case 5:
      sMessage = "Your muscles protest as you swing a hard blow. You should warm up more!";
      break;
    case 6:
      sMessage = "You begin to realise why experienced warriors are so damn strong.";
      break;
    case 7:
      sMessage = "It hurts, but you know the pain is good for you.";
      break;
    case 8:
      sMessage = "Your body is telling you it's done more than enough work for today.";
      break;
    case 9:
      sMessage = "Your swings become a little more fluent as you shift your feet.";
      break;
    case 10:
      sMessage = "Ah! That's more like it!";
      break;
    case 11:
      sMessage = "Footwork, footwork, footwork...";
      break;
    case 12:
      sMessage = "This is easy! Good thing it's not trying to hit back!";
      break;
    case 13:
      sMessage = "Your hands start to ache.";
      break;
    case 14:
      sMessage = "One, two, one, two...";
      break;
    case 15:
      sMessage = "You open your shoulders, and deliver a strong blow to the dummy's breast.";
      break;
    case 16:
      sMessage = "Dodging and ducking, you pretend it's trying to hit you, parrying an invisible sword.";
      break;
    case 17:
      sMessage = "You loosen your wrists and roll with the strikes.";
      break;
    case 18:
      sMessage = "You aim for the dummy's arm, landing several blows close to each other.";
      break;
    case 19:
      sMessage = "You aim for the dummy's neck... a mortal blow to a human opponent, but the dummy doesn't seem to care.";
      break;
    case 20:
      sMessage = "The dummy seems to be standing up quite well.";
      break;
    case 21:
      sMessage = "You try something a bit more complicated, but mess it up. Good thing you weren't fighting a real opponent, really.";
      break;
    case 22:
      sMessage = "You deliver a quick feint towards the dummy's legs then strike its neck, perfectly executed. Well, you think so anyway.";
      break;
    case 23:
      sMessage = "Oops! You nearly broke it! Good show!";
      break;
    case 24:
      sMessage = "Do you have 'Favored Enemy: Training Dummies' or something?!";
      break;
    case 25:
      sMessage = "Ouch. That would really have hurt... if it hadn't been on a dummy.";
      break;
    case 26:
      sMessage = "You've certainly got the brawn... does that mean the dummy has the brains?";
      break;
    case 27:
      sMessage = "Train, train, train. Dull, but you get better.";
      break;
    case 28:
      sMessage = "DING! Oh, wait, am I ahead of myself again? Drat.";
      break;
    case 29:
      sMessage = "Well, the dummy certainly looks scary, but you're beating it good and hard.";
      break;
    case 30:
      sMessage = "Show that dummy who's boss!";
      break;
    case 31:
      sMessage = "Good hit!";
      break;
    case 32:
      sMessage = "You begin to feel a bit hungry.";
      break;
    case 33:
      sMessage = "You try a feint, but it looks clumsy even to you.";
      break;
    case 34:
      sMessage = "Practise makes perfect.";
      break;
    case 35:
      sMessage = "Nothing worthwhile was ever achieved easily.";
      break;
    case 36:
      sMessage = "Stare into your opponent's eyes... wait, it doesn't -have- eyes!";
      break;
    case 37:
      sMessage = "A is for Anatomy. B is for Behead...";
      break;
    case 38:
      sMessage = "You look good and move well, but a nagging thought at the back of your head reminds you that it's only a dummy.";
      break;
    case 39:
      sMessage = "Fighting is like dancing, it's all about the footwork.";
      break;
    case 40:
      sMessage = "Is it time for a rest yet?";
      break;
  }

  SendMessageToPC(oPC, sMessage);
}

void PrayerDescription(object oPC)
{
  Trace(TRAINING, "PrayerDescription called for PC: " + GetName(oPC));
  // Play a message half the time.
  if (d2() - 1) return;

  string sMessage = "";

  switch (d40())
  {
    case 1:
      sMessage = "You feel at peace with the world.";
      break;
    case 2:
      sMessage = "The world around you may as well not exist, your focus is so great.";
      break;
    case 3:
      sMessage = "You feel refreshed, content.";
      break;
    case 4:
      sMessage = "You are in that special place where you can feel the gods' closeness.";
      break;
    case 5:
      sMessage = "Your troubles flow from you in a stream.";
      break;
    case 6:
      sMessage = "Your burdens seem lighter.";
      break;
    case 7:
      sMessage = "Communion eases the spirit.";
      break;
    case 8:
      sMessage = "You feel a calmness wash over you.";
      break;
    case 9:
      sMessage = "You repeat a prayer, focusing your mind.";
      break;
    case 10:
      sMessage = "The world outside doesn't matter. Your body is a temple.";
      break;
    case 11:
      sMessage = "You feel glad to have made time in your day for prayer.";
      break;
    case 12:
      sMessage = "Despite the conflict in the world, you are at peace.";
      break;
    case 13:
      sMessage = "Though there is much work to be done, you are at peace.";
      break;
    case 14:
      sMessage = "The truly faithful are rewarded with certainty.";
      break;
    case 15:
      sMessage = "With trust and faith, you grow.";
      break;
    case 16:
      sMessage = "Reassurance and peace fill your soul.";
      break;
    case 17:
      sMessage = "You feel your soul strengthening for the challenges you will face.";
      break;
    case 18:
      sMessage = "The familiar words of your favourite prayer strengthen you.";
      break;
    case 19:
      sMessage = "Resolution settles in your heart.";
      break;
    case 20:
      sMessage = "Your own breathing is the loudest thing you can hear.";
      break;
    case 21:
      sMessage = "You feel a sudden urge to convert others...";
      break;
    case 22:
      sMessage = "You feel a momentary discomfort, as if your very soul were under scrutiny.";
      break;
    case 23:
      sMessage = "";
      break;
    case 24:
      sMessage = "";
      break;
    case 25:
      sMessage = "";
      break;
    case 26:
      sMessage = "";
      break;
    case 27:
      sMessage = "";
      break;
    case 28:
      sMessage = "";
      break;
    case 29:
      sMessage = "";
      break;
    case 30:
      sMessage = "";
      break;
    case 31:
      sMessage = "";
      break;
    case 32:
      sMessage = "";
      break;
    case 33:
      sMessage = "";
      break;
    case 34:
      sMessage = "";
      break;
    case 35:
      sMessage = "";
      break;
    case 36:
      sMessage = "";
      break;
    case 37:
      sMessage = "";
      break;
    case 38:
      sMessage = "";
      break;
    case 39:
      sMessage = "";
      break;
    case 40:
      sMessage = "";
      break;
  }

  SendMessageToPC(oPC, sMessage);
}

void ResearchDescription(object oPC)
{
  Trace(TRAINING, "ResearchDescription called for PC: " + GetName(oPC));
  // Play a message half the time.
  if (d2() - 1) return;

  string sMessage = "";

  switch (d40())
  {
    case 1:
      sMessage = "You find an old book on gardening, and skim through it.";
      break;
    case 2:
      sMessage = "An old map of the City of Winds from its founding.";
      break;
    case 3:
      sMessage = "At the back of a shelf, you find a book that probably hasn't been looked at it in many years.";
      break;
    case 4:
      sMessage = "";
      break;
    case 5:
      sMessage = "Several of these papers are very old, and speak of unfamiliar places.";
      break;
    case 6:
      sMessage = "";
      break;
    case 7:
      sMessage = "";
      break;
    case 8:
      sMessage = "";
      break;
    case 9:
      sMessage = "";
      break;
    case 10:
      sMessage = "";
      break;
    case 11:
      sMessage = "";
      break;
    case 12:
      sMessage = "";
      break;
    case 13:
      sMessage = "";
      break;
    case 14:
      sMessage = "";
      break;
    case 15:
      sMessage = "";
      break;
    case 16:
      sMessage = "";
      break;
    case 17:
      sMessage = "";
      break;
    case 18:
      sMessage = "Journals of William Blumvert, Human explorer and cartographer around 100CE.";
      break;
    case 19:
      sMessage = "";
      break;
    case 20:
      sMessage = "";
      break;
    case 21:
      sMessage = "";
      break;
    case 22:
      sMessage = "";
      break;
    case 23:
      sMessage = "";
      break;
    case 24:
      sMessage = "";
      break;
    case 25:
      sMessage = "";
      break;
    case 26:
      sMessage = "";
      break;
    case 27:
      sMessage = "";
      break;
    case 28:
      sMessage = "";
      break;
    case 29:
      sMessage = "";
      break;
    case 30:
      sMessage = "";
      break;
    case 31:
      sMessage = "";
      break;
    case 32:
      sMessage = "";
      break;
    case 33:
      sMessage = "";
      break;
    case 34:
      sMessage = "";
      break;
    case 35:
      sMessage = "";
      break;
    case 36:
      sMessage = "";
      break;
    case 37:
      sMessage = "";
      break;
    case 38:
      sMessage = "";
      break;
    case 39:
      sMessage = "";
      break;
    case 40:
      sMessage = "";
      break;
  }

  SendMessageToPC(oPC, sMessage);
}
