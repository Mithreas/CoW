/**
 * ai_trixiveria.nss
 * Author: Mithreas
 * Date: 4 May 2018
 *
 * This is the user defined script for the Fairy Queen.  It contains her conversation
 * and behaviour.  
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 * This file includes plot secrets.  Don't read it if you want to explore the game
 * the way it's meant to be experienced :)  (This file is in .gitignore to avoid
 * being published to the repository). 
 *
 * Trixiveria asks players to bring her a bark of Ent. Once she has received one, she
 * will create mithril for them refining it from raw iron and raw silver.
 * cnrbarkent => cnrnuggetiro + cnrnuggetsil = cnringotmit
 */
#include "inc_backgrounds"
#include "inc_combat"
#include "inc_customspells"
#include "inc_database"
#include "inc_emotes"
#include "inc_event"
#include "inc_iprop"
#include "inc_log"
#include "inc_worship"
#include "zzdlg_color_inc"
#include "nw_i0_plot"

const string FAIRYQUEEN = "FAIRYQUEEN_2"; // for tracing.

/**
 * Utility methods
 */

int _WearsIron(object oPC)
{
  int nSlot = 0;
  object oItem;
  
  for (nSlot; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
  {
    oItem = GetItemInSlot(nSlot, oPC);
    if (gsIPGetMaterialType(oItem) == 9) // iron
	{
	  return TRUE;
	}
  }
  
  return FALSE;
} 
 
void _Cleanup()
{
  object oSelf = OBJECT_SELF;

  DeleteLocalInt(oSelf, "WARNED");
  DeleteLocalInt(oSelf, "COUNT");
}

void _Count(object oPC)
{
  object oSelf = OBJECT_SELF;
  int nCount = GetLocalInt(oSelf, "COUNT") - 1;
  
  if (GetIsInCombat(oSelf))
  {
    AdjustReputation(oPC, oSelf, -100);
	_Cleanup();
  }
  
  if (!nCount)
  {
    // Turn all courtiers and guards hostile.
	// They are in the Plot faction, so reputation effects will be 
	// negated next time the PC changes area.
    if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC)) AdjustFactionReputation(oPC, oSelf, -100);
	
	object oCreature = GetFirstFactionMember(oSelf);
	
	while (GetIsObjectValid(oCreature))
	{
	  if (GetArea(oCreature) == GetArea(oSelf)) AssignCommand(oCreature, gsCBDetermineCombatRound(oPC));
	  oCreature = GetNextFactionMember(oSelf);
	}
	
	_Cleanup();    
  }
  else
  {
    SpeakString(IntToString(nCount));
  
    SetLocalInt(oSelf, "COUNT", nCount);
    DelayCommand(1.0, _Count(oPC));
  }
}

void _DoWarning(object oPC)
{
  // If PC alignment is holding iron, warn them to leave or else.
  object oSelf = OBJECT_SELF;
  
  if (!GetLocalInt(oSelf, "WARNED"))
  {
    SpeakString("You dare bring wrought iron into my presence?!  I will give you thirty seconds to run, barbarian.  Use them wisely.");
	SetLocalInt(oSelf, "WARNED", TRUE);
	SetLocalInt(oSelf, "COUNT", 30);
	DelayCommand(1.0, _Count(oPC));
  }
  else
  {
    // This is a second iron bearing PC in the same party.  Hostile them in 30s. 
	DelayCommand(30.0f, AdjustReputation(oPC, oSelf, -100));
  }  
}

/**
 * Methods to handle dialog.
 */
int Contains(string sText, string sSubString)
{
  return (FindSubString(sText, sSubString) > -1);
} 

void Say(string sText)
{
  DelayCommand(1.0, SpeakString(sText));
}

string Address(object oSpeaker)
{
  string sAddress = GetPersistentString(oSpeaker, "FAIRYQUEEN2_ADDRESS");
  
  if (sAddress == "") sAddress = "barbarian";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "FAIRYQUEEN2_ADDRESS", sAddress);
}

void _SetQuestInt(object oSpeaker, string sName, int nValue)
{
  object oHide = gsPCGetCreatureHide(oSpeaker);
  
  SetLocalInt(oHide, "TRIXIE_" + sName, nValue);
}

int _GetQuestInt(object oSpeaker, string sName)
{
  object oHide = gsPCGetCreatureHide(oSpeaker);
  
  return (GetLocalInt(oHide, "TRIXIE_" + sName));
}

string GetFirstName(object oPC)
{
  string sName = GetName(oPC);
  int nSpace   = FindSubString(" ", sName);
  if (nSpace == -1) return sName;
  else return GetSubString(sName, 0, nSpace); 
}
 
void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(FAIRYQUEEN, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    // Could definitely use more content here.  Light on plot!
    if (Contains(sText, "help") || Contains(sText, "need") || Contains(sText, "bark"))
    {
	  if (GetIsObjectValid(GetItemPossessedBy(oSpeaker, "cnrbarkent")) && _GetQuestInt(oSpeaker, "BARK"))
	  {
	    Say("Oh, you have brought me a piece of bark.  Thank you.");
		_SetQuestInt(oSpeaker, "BARK", _GetQuestInt(oSpeaker, "BARK") + 1);
		gsCMReduceItem(GetItemPossessedBy(oSpeaker, "cnrbarkent"), 1);
	  }
      else
      {	  
        Say("I need a large number of barks of Ent.  If you can bring me one, I would appreciate it.");
	    if (!_GetQuestInt(oSpeaker, "BARK")) _SetQuestInt(oSpeaker, "BARK", TRUE);
	  }
    }
	else if (Contains(sText, "matters") || Contains(sText, "business"))
	{
	  Say("My business is none of yours, " + Address(oSpeaker));
	}
	else if (Contains(sText, "mithril") || Contains(sText, "mithral") || Contains(sText, "gromril"))
	{
	  object oIron = GetItemPossessedBy(oSpeaker, "cnrnuggetiro");
	  object oSilver = GetItemPossessedBy(oSpeaker, "cnrnuggetsil");
	  if (_GetQuestInt(oSpeaker, "BARK") >= 2 && GetIsObjectValid(oIron) && GetIsObjectValid(oSilver))
	  {
	    int nStackSize = GetItemStackSize(oIron) > GetItemStackSize(oSilver) ? GetItemStackSize(oIron) : GetItemStackSize(oSilver);
	  
	    miDoCastingAnimation(oSelf);
	  
	    gsCMReduceItem(oIron, nStackSize);
		gsCMReduceItem(oSilver, nStackSize);
		CreateItemOnObject("cnringotmit", oSpeaker, nStackSize);
		_SetQuestInt(oSpeaker, "BARK", _GetQuestInt(oSpeaker, "BARK") - 1);
		
		Say("I always enjoy doing this. Here you are, no more nasty iron, mithril instead.");
	  }	
	  else
	  {
	    Say("Ah yes, mithril... I know quite a lot about that.  It is made from raw iron and raw silver, and only a few know the secret of its making.");
	  }
	}
	else if (Contains(sText, "secret"))
	{
	  Say("Why yes, I do know the secret of mithril.  I might even use it for you, if you bring me what I need.");
	}
	else if (Contains(sText, "greetings") || Contains(sText, "hello") || Contains(sText, "well met"))
	{
	  if (Address(oSpeaker) == "barbarian") UpdateAddress(oSpeaker, "stranger");
	  Say("Well met and welcome.  Do no harm and you will not be harmed in return.");
	}
	else if (Contains(sText, GetFirstName(oSpeaker)))
	{
	  UpdateAddress(oSpeaker, GetFirstName(oSpeaker));
	  Say("A pleasure to meet you, " + Address(oSpeaker) + ". Be welcome in my court.  Let me know if you need anything.");
	}
	else if (Contains(sText, "gods") && Address(oSpeaker) == GetFirstName(oSpeaker))
	{
	  Say("You want to know about the gods?  Of what would you hear, ascension or power?");
	}
	else if (Contains(sText, "ascension") && Address(oSpeaker) == GetFirstName(oSpeaker))
	{
	  Say("Many ask me about how to follow in my path.  It is not something that can be taught.  It is a matter of perception... when one learns to perceive the flows of magic in the world, and to affect the world by touching them.  It is how we can be connected to our followers across great distances.");
	}
	else if (Contains(sText, "power") && Address(oSpeaker) == GetFirstName(oSpeaker))
	{
	  Say("The true power of ascension is the power to affect the world without being limited by physical distance.  If I choose to, I can be aware of you anywhere in the world.  And more than simple awareness, of course.");
	}
	else if ((Contains(sText, "more") || Contains(sText, "touch")) && Address(oSpeaker) == GetFirstName(oSpeaker))
	{
	  Say("There is magic in all living things.  Once you learn to perceive it, you can learn to manipulate it... and then you hold great power over others.");
	}
	else
	{
	  Say("I have more important things to deal with than visitors right now.  Come back later.");
	  SetLocalInt(oSelf, "ANNOYED", TRUE);
	  DelayCommand(900.0f, DeleteLocalInt(oSelf, "ANNOYED")); 
	}
 }

void main()
{
	object oSelf = OBJECT_SELF;
	
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................
	  {
	    // If in combat, don't banter.
	    if (GetIsInCombat()) return;
		
	    object oPC = GetLastSpeaker();
		  
        // Don't talk to iron-bearing PCs.
		// Listen pattern -1 means we were clicked on.
		// Listen pattern 1/TRUE means someone said something nearby (see our spawn in condition below). 
	    if (GetListenPatternNumber() == -1 && GetIsPC(oPC) && _WearsIron(oPC))
	    {
	      ClearAllActions();
		  SpeakString("Time is ticking."); 
	    }
		else if (GetListenPatternNumber() == -1 && (GetIsPC(oPC) || GetIsDM(oPC)))
		{
		  // Clicked on by a PC not carrying iron.  Tell them to get their typing fingers on.		  
		  SendMessageToPC(oPC, "Talk to her like you would talk to another PC.  Short responses will work best."); 		  
		}
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC)) && !_WearsIron(oPC))
		{
		  // Triggered by someone saying something nearby. 
		  string sText = GetMatchedSubstring(0);
		  
		  if (GetLocalInt(oSelf, "VERY_ANNOYED"))
		  {
		    // Sends the PC to a random destination.
		    SpeakString("I told you to leave.  Some people just can't take a hint.");
			miDoCastingAnimation(oSelf);
            object oWP = GetObjectByTag("WP_FAIRY_" + IntToString(Random(10)));
  
	        DelayCommand(1.0, gsCMTeleportToObject(oPC, oWP));			
		  }
		  else if (GetLocalInt(oSelf, "ANNOYED"))
		  {
		    // Oh dear, someone has said something to annoy her, and kept talking.			
			SpeakString("I am done talking with you, " + Address(oPC) + ".  You may leave me now.");
			SetLocalInt(oSelf, "VERY_ANNOYED", TRUE);
			DelayCommand(120.0f, DeleteLocalInt(oSelf, "VERY_ANNOYED"));
		  }
		  else
		  {
		    _ProcessChat(sText);
		  }	
		}
		// NPC speech or Lawful PC talking.  Ignore.
	  }
 
      break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................
    {
	  object oPC   = GetLastPerceived();
	  
	  if (GetIsPC(oPC) && _WearsIron(oPC))
	  {
	    _DoWarning(oPC);
	  }
	  else if (GetIsPC(oPC) && GetIsObjectValid(GetItemPossessedBy(oPC, "cnrbarkent")) && _GetQuestInt(oPC, "BARK"))
	  {
	    Say("Oh, you have brought me a piece of bark.  Thank you.  Did you need something?");
		gsCMReduceItem(GetItemPossessedBy(oPC, "cnrbarkent"), 1);
		_SetQuestInt(oPC, "BARK", _GetQuestInt(oPC, "BARK") + 1);
	  }
	  else if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {
	    SetFacingPoint(GetPosition(oPC));
        
        // Move closer and open conversation.
        AssignCommand(oSelf, ActionMoveToLocation(GetLocation(oPC)));
        DelayCommand(2.0f, ClearAllActions());		
		
		if (Address(oPC) == "barbarian")
		{
		  DelayCommand(5.0f, SpeakString("Welcome, barbarian.  Do no harm here and you will receive no harm.  Now forgive me, I am busy with important matters."));
		}
		else if (Address(oPC) == "stranger")
		{
		  DelayCommand(5.0f, SpeakString("So, you're back.  What do you want?"));
		}
        else
        {
		  DelayCommand(5.0f, SpeakString("Welcome back to my court.  Let me know if you need anything, " + Address(oPC) + "."));
        }		
		
		// Mark ourselves as in a conversation for the next 30 minutes.  
		SetLocalInt(oSelf, "IN_DIALOG", TRUE);
		DelayCommand(1800.0f, DeleteLocalInt(oSelf, "IN_DIALOG"));
	  }
	}

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        // Start listening - reply to anyone who talks to us.
        SetListening(oSelf,TRUE);
        SetListenPattern(oSelf, "**", TRUE);
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    case SEP_EV_ON_NIGHTPOST:
//................................................................

        break;
    case SEP_EV_ON_DAYPOST:
//................................................................

        break;
case SEP_EV_ON_SECURITY_HEARD:
//................................................................
        break;
case SEP_EV_ON_SECURITY_SPOT:
//................................................................
        break;
case SEP_EV_ON_SECURITY_RESOLVE:
//................................................................
        break;
case SEP_EV_ON_GUARD_ALERT:
//................................................................
        break;
case SEP_EV_ON_GUARD_RESOLVE:
//................................................................
        break;
    }
}
