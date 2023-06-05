/**
 * ai_maliavera.nss
 * Author: Mithreas
 * Date: 20 April 2019
 *
 * This is the user defined script for Maliavera, leader of Merivale.  It contains her 
 * conversation and behaviour.  
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 * This file includes plot secrets.  Don't read it if you want to explore the game
 * the way it's meant to be experienced :)  (This file is in .gitignore to avoid
 * being published to the repository). 
 *
 * For humans who agree to join the Elves, she can hand out a token (elf_safe_passage)
 * to allow the human (or halfling) to live within Elven lands. 
 */
#include "inc_event"
#include "inc_log"
#include "inc_reputation"
#include "inc_worship"
#include "zzdlg_color_inc"
#include "nw_i0_plot"

const string MALIAVERA = "MALIAVERA"; // for tracing.

/**
 * Utility methods
 */
 
void _Cleanup()
{
  object oSelf = OBJECT_SELF;

  DeleteLocalInt(oSelf, "WARNED");
  DeleteLocalInt(oSelf, "COUNT");
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
  if (GetRacialType(oSpeaker) == RACIAL_TYPE_ELF) return gsCMGetFirstName(oSpeaker);
  else if (GetIsObjectValid(GetItemPossessedBy(oSpeaker, "elf_safe_passage"))) return gsCMGetFirstName(oSpeaker);
  
  return "stranger";
}
 
void _ProcessChat(string sText)
{
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(MALIAVERA, "Processing PC speech (outsider branch): " + sText);
	
	// This is the conversation branch for non Elves.
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
	int bLawful     = GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_LAWFUL;
	
    // Filter out Lawful PCs.
	if (bLawful)
	{
	  Say("I can see your heart, stranger.  You have no desire to shed your old ways, and hence, you are not welcome here.");
	}
	else if (Contains(sText, "?") || Contains(sText, "why"))
	{
	  Say("You will find that manners are very important here.  Rudeness is not tolerated among our guests.  Perhaps you can work on your phrasing.");
	}
	else if (Contains(sText, "hello") || Contains (sText, "greet") || Contains(sText, "well met") || Contains(sText, "hospitality"))
	{
	  Say("Well met and welcome to you, stranger.  I hope your presence here means that you wish to join with us, and end this senseless conflict.");
	}
    else if (Contains(sText, "join") || Contains(sText, "defect") || Contains(sText, "switch sides"))
    {
      Say("We will accept you here, if you swear the following oath.  'I will follow your ways, and never cause harm to one of your people again.  I will turn away from false gods, and follow a path of nature.'");
    }
	else if (Contains(sText, "war") || Contains(sText, "peace") || Contains(sText, "conflict"))
	{
	  Say("The human gods led your people down the path of destruction, beginning when they were just mortals.  Ascension has not made them wiser.  It would be good to find that more of your people are wise enough to turn from such paths.");
	}
	else if (Contains(sText, "I will follow your ways, and never cause harm to one of your people again.") && Contains(sText, "I will turn away from false gods, and follow a path of nature."))
	{
	  Say("Be welcome among us, then.  We do not require you to fight your kin, but you should not show readied weapons around our towns.  May you find a life of peace among us.  *she offers you a brooch in the shape of a tree, a token of safe passage*");
	  object oBrooch = CreateItemOnObject("elf_safe_passage", oSpeaker);
	  if (gsWOGetCategory(gsWOGetDeityByName(GetDeity(oSpeaker))) == FB_WO_CATEGORY_SEVEN_DIVINES && gsWOGetDeityByName(GetDeity(oSpeaker)) != 4) // Nocturne
	  {
        SetDeity(oSpeaker, "");
        SendMessageToPC(oSpeaker, GS_T_16777297);	   
	  }
	  
	  if (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SHAPECHANGER)
	  {
	    // They will drop the brooch as it's made of silver.
		DelayCommand(8.0f, SpeakString("Oh, it appears our little silver brooch causes you some trouble.  Perhaps it would be best if you returned where you came from... quickly."));
		DelayCommand(8.0f, ActionPickUpItem(oBrooch));
	  }
	  else if (GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_NEUTRAL)
	  {
	    AdjustAlignment(oSpeaker, ALIGNMENT_CHAOTIC, 35, FALSE);
	  }
	}
}
 
void _ProcessElfChat(string sText)
{
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(MALIAVERA, "Processing PC speech (Elf branch): " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    if (Contains(sText, "?") || Contains(sText, "why"))
	{
	  Say("Battle manners are not necessary here, " + Address(oSpeaker) + ".");
	}
	else if (GetLocalInt(oSelf, "LAWFUL_NON_ELF_SEEN"))
	{
	  Say("One who truly believes in the ways of their people cannot be trusted to remain here.  We will speak no more of this now.");
	}
	else if (Contains(sText, "hello") || Contains (sText, "greetings") || Contains(sText, "well met"))
	{
	  Say("You are welcome here, " + Address(oSpeaker) + ".  But we have interesting company today, so should see to our guest.");
	}
	else
	{
	  Say("We will speak another time; we have a guest to see to.");
	}

}

void _ProcessSecretChat(string sText)
{
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(MALIAVERA, "Processing PC speech (Secret branch): " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    if (Contains(sText, "?") || Contains(sText, "why"))
	{
	  Say("Battle manners are not necessary here, " + Address(oSpeaker) + ".");
	}
	else if (Contains(sText, "hello") || Contains (sText, "greetings") || Contains(sText, "well met"))
	{
	  Say("Well met and welcome, " + Address(oSpeaker) + ". A conversation would be pleasant, and there is also work to do.");
	}
	else if (Contains(sText, "work"))
	{
	  if (GetRepScore(oSpeaker, FACTION_FERNVALE, FALSE) < 10)
	  {
	    Say("My work is of quite a sensitive nature.  Build your reputation among our people further, and show you can be trusted for the tasks ahead.");
	  }
	  else
	  {
	    Say("My work is to win the war, naturally.  The humans are well fortified, but I have a plan that they will not anticipate.");
		SetLocalInt(gsPCGetCreatureHide(oSpeaker), "MALIA_SECRET", TRUE);
	  }
	}
	else if (Contains(sText, "conversation"))
	{
	  Say("Perhaps we could speak of the weather, or of the latest recipes we have prepared.  It is pleasant to speak of matters of peace.");
	  SendMessageToPC(oSpeaker, "(Apologies, the rest of this conversation branch isn't implemented!)");
	}
	else if (GetLocalInt(gsPCGetCreatureHide(oSpeaker), "MALIA_SECRET"))
	{
	  if (Contains(sText, "plan"))
	  {
	    Say("The Wall is well fortified, and they are pumping seawater into it which somehow is making our magic unreliable.  And we can't go around the Wall, since the sea swallows us.  But humans and halflings can pass over the sea.  Perhaps you have given thought to this matter.");
	  }
	  else if (Contains(sText, "recruit humans") || Contains (sText, "use humans") || Contains (sText, "recruit halflings") || Contains(sText, "use halflings"))
	  {
	    Say("It would be good were we to persuade some humans or halflings to our side, and have them encircle the Wall and take it. But we could not trust them, nor likely recruit them in sufficient numbers.  Hence, we need to raise an army that can pass over the sea.");
	  }
	  else if (Contains(sText, "army") || Contains (sText, "partners"))
	  {
	    Say("There will always be some humans idealistic enough to wish peace.  If we bring them here, and breed them carefully with loyal Elves, then within a few generations we should have an army that are human enough to cross the water, while remaining loyal to our people.");
	  }
	  else if (Contains(sText, "time") || Contains (sText, "generations"))
	  {
	    Say("Time we have.  We can afford to be patient... the humans are not going anywhere.  One day we will strike from nowhere, and all that is good about them we will already have assimilated into our society.  Final victory.");
	  }
	  else if (Contains(sText, "to do") || Contains (sText, "how"))
	  {
	    Say("Find humans willing to turn aside from their path of violence and live among us.  Escort them to me, that I might judge their sincerity.  And ensure that they find suitable partners.");
	  }
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
		
		int bElf = GetRacialType(oPC) == RACIAL_TYPE_ELF;
		int bNearbyNonElves = GetLocalInt(OBJECT_SELF, "NON_ELF_SEEN");
				
        // Listen pattern -1 means we were clicked on.
		// Listen pattern 1/TRUE means someone said something nearby (see our spawn in condition below). 
        if (GetListenPatternNumber() == -1 && (GetIsPC(oPC) || GetIsDM(oPC)))
		{
		  // Clicked on by a PC.  Tell them to get their typing fingers on.		  
		  SendMessageToPC(oPC, "Talk to her like you would talk to another PC.  Short responses will work best."); 		  
		}
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC)))
		{
		  // Triggered by someone saying something nearby. 
		  string sText = GetMatchedSubstring(0);
		  
		  if (bElf && !bNearbyNonElves)
		  {
		    _ProcessSecretChat(sText);		
		  }
		  else if (bElf)
		  {
		    _ProcessElfChat(sText);
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
	  int bElf = TRUE;
	  
	  if (GetIsPC(oPC) && GetRacialType(oPC) != RACIAL_TYPE_ELF)
	  {
	    SetLocalInt(OBJECT_SELF, "NON_ELF_SEEN", TRUE);
		bElf = FALSE;
	  }
	  
	  if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {	
		if (bElf)
		{
		  DelayCommand(5.0f, SpeakString("Welcome, " + Address(oPC) + ".  It would be good to speak a while."));
		}
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
		{
		  DelayCommand(5.0f, SpeakString("You. *she points at " + gsCMGetFirstName(oPC) + "* You are not welcome here.  Leave."));
		  SetLocalInt(oSelf, "LAWFUL_NON_ELF_SEEN", TRUE);
		}
        else
        {
		  DelayCommand(5.0f, SpeakString("*She looks " + gsCMGetFirstName(oPC) + " over for a long minute, then nods in greeting* Be welcome in my house, stranger.  Should you have something on your mind, it would be good to hear it."));
        }		
		
		// Mark ourselves as in a conversation for the next 30 minutes.  
		SetLocalInt(oSelf, "IN_DIALOG", TRUE);
		DelayCommand(1800.0f, DeleteLocalInt(oSelf, "IN_DIALOG"));
		DelayCommand(1800.0f, DeleteLocalInt(oSelf, "NON_ELF_SEEN"));
		DelayCommand(1800.0f, DeleteLocalInt(oSelf, "LAWFUL_NON_ELF_SEEN"));
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
