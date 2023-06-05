/**
 * ai_watchcomm.nss
 * Author: Mithreas
 * Date: 13 April 2019
 *
 * This is the user defined script for the watch commander on the Wall. He will 
 * recruit PCs to the secret plague work of humanity if they convince him they
 * are up to it. 
 * 
 * Most of the conversation is open to PCs to say what they like.  The NPC will 
 * pick out key words and respond. 
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 */
#include "inc_log"
#include "inc_loot"
#include "x0_i0_position"

const string WATCHCOMM = "WATCHCOMM"; // for tracing.

 
/**
 * Methods to handle dialog.
 */
int _Contains(string sText, string sSubString)
{
  return (FindSubString(sText, sSubString) > -1);
} 

void _Say(string sText)
{
  DelayCommand(1.0, SpeakString(sText));
}

string Address(object oSpeaker)
{
  string sAddress = GetPersistentString(oSpeaker, "WATCHCOMM");
  
  if (sAddress == "") sAddress = "";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "WATCHCOMM", sAddress);
}

void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(WATCHCOMM, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    if (Address(oSpeaker) == "")
	{
      if (_Contains(sText, "salute"))
	  {
	    UpdateAddress(oSpeaker, "soldier");
		_Say("Very good, soldier, at ease.  I have some work an irregular such as yourself could see to.  Interested?");
	  }
	  else
	  {
	    // Ignore the PC.
		_Say("*disregards your presence entirely*");
		return;
	  }
    }
	else if (GetIsObjectValid(GetItemPossessedBy(oSpeaker, "permission_strathvorn")))
	{
	  _Say("You have your orders.  Now get to it and stop wasting my time.");
	}
	else if (_Contains(sText, "yes"))
	{
	  _Say("That's the attitude I like to see.  I'm not going to give you the details, there are too many ears about here.  Show these papers to the dockmaster and he'll take you where you need to go.");
	  CreateItemOnObject("permission_svorn", oSpeaker);
	}
	else
	{
	  _Say("Okay, stop wasting my time then and get lost.");
	  UpdateAddress(oSpeaker, "");
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
		  
        // Don't talk to Chaotic PCs.
		// Listen pattern -1 means we were clicked on.
		// Listen pattern 1/TRUE means someone said something nearby (see our spawn in condition below). 
	    if (GetListenPatternNumber() == -1 && (GetIsPC(oPC) || GetIsDM(oPC)))
	    {
		  SpeakString("*Stares at you for a moment, eyes narrowed, then turns back to the Wall*"); 
		 
          float nFacing = GetFacing(OBJECT_SELF);
		  SetFacingPoint(GetPosition(oPC));
		  DelayCommand(1.0, SetFacing(nFacing));
		 
		  // Make the PC back away one meter.
		  AssignCommand(oPC, ActionMoveToLocation(GenerateNewLocationFromLocation(GetLocation(OBJECT_SELF), 1.0f, GetFacing(oPC) + 180.0f, GetFacing(oPC))));
		  SendMessageToPC(oPC, "Talk to him like you would talk to another PC.  Short responses will work best."); 	
	    }
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC)) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
		{
		  // Triggered by someone saying something nearby. 
		  string sText = GetMatchedSubstring(0);
		  
		  _ProcessChat(sText);	
		}
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC))) // Chaotic people
		{
		  SpeakString("Stop wasting your time and mine, we both know this is just a game to you.");
		}
		// NPC speech or Chaotic PC talking.  Ignore.
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
