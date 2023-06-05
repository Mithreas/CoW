/**
 * ai_ladynightwish.nss
 * Author: Mithreas
 * Date: 25 Aug 2019
 *
 * This is the user defined script for Lady Nightwish (aka Nocturne).   As with other
 * plot NPCs, she responds to what players type - picking out key words and responding. 
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 * This file includes plot secrets.  Don't read it if you want to explore the game
 * the way it's meant to be experienced :)  (This file is in .gitignore to avoid
 * being published to the repository). 
 * 
 */
#include "inc_backgrounds"
#include "inc_combat"
#include "inc_database"
#include "inc_event"
#include "inc_log"
#include "inc_worship"
#include "inc_zdlg"
#include "nw_i0_plot"
#include "zzdlg_color_inc"

const string NOCTURNE = "NOCTURNE"; // for tracing.

/**
 * Methods to handle warning Lawful PCs. 
 */
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
    // Turn all acolytes hostile.
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
    SendMessageToPC(oPC, IntToString(nCount));
    SetLocalInt(oSelf, "COUNT", nCount);
    DelayCommand(1.0, _Count(oPC));
  } 
}

void _DoWarning(object oPC)
{
  object oSelf = OBJECT_SELF;
  
  if (!GetLocalInt(oSelf, "WARNED"))
  {
    DelayCommand(2.0, SpeakString("You are determined to take the path of war?  That is a pity.  Regrettably, we must ensure you do not succeed."));
	SetLocalInt(oSelf, "WARNED", TRUE);
	SetLocalInt(oSelf, "COUNT", 10);
	DelayCommand(1.0, _Count(oPC));
  }
  else
  {
    // This is a second Lawful PC in the same party.  Hostile them in 30s. 
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
  // Upgrade our convo tracker - the PC has hit a "real" reply.
  SetLocalInt(OBJECT_SELF, "IN_DIALOG", 2);
  DelayCommand(1.0, SpeakString(sText));
}

string Address(object oSpeaker)
{
  string sAddress = GetPersistentString(oSpeaker, "NOCTURNE_ADDRESS");
  
  if (sAddress == "") sAddress = "stranger";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "NOCTURNE_ADDRESS", sAddress);
} 

void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(NOCTURNE, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    // Paradise
    if (Contains(sText, "paradise"))
    {
      Say("*she chuckles* Well, in time, maybe we'll make a true paradise.  But for now I'm content to have a place where the war doesn't exist.");
    }
	// the war
	else if (Contains(sText, "war ") || Contains (sText, " war"))
	{
	  Say("The war has claimed too many lives, and faces stalemate now.  What you see around you is the start of a new way, where Humans and Elves live in peace.");
	}
	else if (Contains(sText, "peace"))
	{
	  Say("Peace isn't easy.  There are many true grievances, in both the recent and distant past.  And little enough trust, on either side.  But that is why it takes a goddess to change things."); 
	}
	else if (Contains(sText, "trust"))
	{
	  Say("Both sides have broken many agreements over the years... or been perceived to.  How could any formal peace be declared if neither side believes it will be honoured?  No, all we can do is start anew."); 
	}
	else if (Contains (sText, "power"))
	{
	  Say("I will rule as long as I am needed, until peace is lasting and trust has been restored.");
	}
	else if (Contains(sText, "grievance"))
	{
	  Say("A polite word, given the sheer volume of slaughter and destruction that has taken place.  Nobody can change the past, but we can change the future together.");
	}
	else if (Contains (sText, "future"))
	{
	  Say("I believe the future will hold peace.  Join us, and help make it happen.");
	  if (GetDeity(oSpeaker) != "Nocturne") SetLocalInt(oSelf, "RECRUIT", TRUE);
	}
	else if (Contains(sText, "nocturne"))
	{
	  Say("Yes, I am also known as Nocturne.  When we ascended, my fellows and I decided that we should take on new names to set us apart from our old lives.  I have done the same again here; Nocturne was a figher in the war.  Nightwish is a being of peace."); 
	}
	else if (Contains(sText, "greetings") || Contains(sText, "hello"))
	{
	  Say("Greetings and well met."); 
	}
	else if (Contains(sText, GetStringLowerCase(gsCMGetFirstName(oSpeaker))))
	{
	  UpdateAddress(oSpeaker, gsCMGetFirstName(oSpeaker));
	  Say("A pleasure to make your acquaintance, " + Address(oSpeaker) + ".  I hope you will remain among us and help build a new world."); 
	}
	else if (Contains(sText, "goddess"))
	{
	  Say("Yes, I am among the Ascended.  I choose to use my powers to make the world a better place."); 
	}
	else if (Contains(sText, "better place") || Contains(sText, "new world") || Contains (sText, "new way"))
	{
	  Say("I would be pleased for you to join us.  Hearts must change away from war and towards peace for us to renew the world."); 
	  if (GetDeity(oSpeaker) != "Nocturne") SetLocalInt(oSelf, "RECRUIT", TRUE);
	}
	else if (GetLocalInt(oSelf, "ASCENSION"))
	{
	  if (Contains(sText, "oceanus") || Contains(sText, "pact"))
	  {
	    Say("You are persistent.  What you seem to have heard is true.  But it is in the past, and I am not tied to use my powers in senseless conflict.  Instead, I use them for good.");
	  }
	  else if (Contains(sText, "good"))
	  {
	    Say("It is Good to preserve life rather than promote death.  To promote peace rather than engender war.  To engender understanding rather than spread suspicion.  All these things you will find here.");
	  }
	  else if (Contains(sText, "understanding"))
	  {
	    Say("We all have more in common than divides us.  Of course, one of the things that we have in common is that we are not very good at seeing others' points of view... which helps divide us.  A paradox I have had much time to consider.");
	  }
	  else if (Contains(sText, "paradox"))
	  {
	     Say("Yes, a paradox.  If everyone is free to follow their own path, many of those paths will come into conflict, and rumour and supposition will spread further division.  Once it gets bad enough, freedom just creates a vicious circle of suspicion.  And this is why I use my power to rule, until trust can be healed.");
	  }
	  else
	  {
	    Say("I'm sorry, what was that? I was distracted a moment."); 
	    DeleteLocalInt(oSelf, "ASCENSION");
	  }
	}
	else if (GetLocalInt(oSelf, "RECRUIT"))
	{
	  if (Contains(sText, "join you") || Contains(sText, "serve you") || Contains (sText, "join us"))
	  {
	    Say("Joining our cause requires three things.  Firstly, you will protect Airevorn against threats, including keeping it secret from those who would bring us harm.  Secondly, you will work to further the cause of peace and understanding, bringing those who are sympathetic to follow the same path.");
	  }
	  else if (Contains(sText, "three") || Contains (sText, "third"))
	  {
	    Say("The third thing is that you will lend me your worship.  Trust is maintained here only by all agreeing that I have the final word on any dispute; you must take that leap of faith as well."); 
	  }
	  else if (Contains(sText, "refuse"))
	  {
	    Say("I do not wish you to be an enemy, " + Address(oSpeaker) + ". But what we have here is fragile; there are many, many more still fighting the war.  I'm afraid you must leave here convinced, one way or the other.");
	  }
      else if (Contains(sText, "how") || Contains (sText, "will join") || Contains (sText, "will serve") || Contains (sText, "to join"))
	  {
	    Say("I am pleased to have you join us, " + Address(oSpeaker) + ". Hold my gaze, and your past deeds in this war will be forgiven and forgotten, and you will become one of us.  *Meeting her gaze, you find yourself falling into her eyes, a wellspring of compassion and love like nothing you have ever known before.*");
		AddGift(oSpeaker, GIFT_OF_UNIQUE_FAVOR);  // In case needed.
		SetDeity(oSpeaker, gsWOGetNameByDeity(4)); // Worship Nocturne.	
		SendMessageToPC(oSpeaker, "You now worship Nocturne / Nightwish.  It's up to you to role play accordingly!");
		
	    DeleteLocalInt(oSelf, "RECRUIT");
	  }
	  else
	  {
	    Say("*The Lady catches your gaze, and you find yourself falling into her eyes*");
		
		if (WillSave(oSpeaker, 40, SAVING_THROW_TYPE_NONE, oSelf))
		{
		  SendMessageToPC(oSpeaker, "By an immense act of will, you avert your eyes, evading the goddess' influence.  Now would be a good time to run away.");  
		  _DoWarning(oSpeaker);
		}
		else
		{
		  SendMessageToPC(oSpeaker, "You find your heart convinced of the righteousness of her cause, of the need to serve her in bringing peace to the world.  She is now your North Star, and peace is your mission.");
		  AddGift(oSpeaker, GIFT_OF_UNIQUE_FAVOR);  // In case needed.
		  SetDeity(oSpeaker, gsWOGetNameByDeity(4)); // Worship Nocturne.	
		  SendMessageToPC(oSpeaker, "You now worship Nocturne / Nightwish.  It's up to you to role play accordingly!");
		}
	  
	    DeleteLocalInt(oSelf, "RECRUIT");
	  }
	}
	// Touching on the origins of gods. 
	else if (Contains(sText, "ascension") || Contains(sText, "oceanus") || Contains(sText, "pact"))
	{
	  Say("So you know a little of how we came to power?  Interesting.  I am glad that at least one of the others yet lives, but I will not ask who.  Their business is their own, as is ours.");
	  SetLocalInt(oSelf, "ASCENSION", TRUE);
	}
	else if (GetDeity(oSpeaker) == "Nocturne" && Contains(sText, "cleric") || Contains(sText, "priest") || Contains (sText, "disciple"))
	{
	  Say("I would be honoured to have you serve as one of my clerics.  Follow this path with my blessing.");
	  if (GetRacialType(oSpeaker) != RACIAL_TYPE_HUMAN) CreateItemOnObject("permission_cler", oSpeaker);
	}
	else if (GetDeity(oSpeaker) != "Nocturne" && GetLocalInt(OBJECT_SELF, "IN_DIALOG") == 2)
	{
	  Say("You have found us, and seen our project.  I ask now for you to join us, and serve the cause of peace as we do."); 
	  SetLocalInt(oSelf, "RECRUIT", TRUE);
	}
	else
	{
	  Say("I'm not sure what you're talking about, but it sounds interesting.");
	  SendMessageToPC(oSpeaker, "She didn't understand you.  Try to reply to the thread of her conversation, or ask her about something you want to know about.  Maybe she'll reply.");
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
		  
		  
	    if (GetLocalInt(oPC, "AVVT_DAIS"))
	    {
		  DelayCommand(0.5f, SpeakString("Please step down from the dais."));	    
		  SendMessageToPC(oPC, "Talk to her like you would talk to another PC.  Short responses will work best."); 		  
	    }		  
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC)) && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
		{
		  // Triggered by someone saying something nearby. 
		  string sText = GetMatchedSubstring(0);
		  
		  if (GetLocalInt(oSelf, "VERY_ANNOYED"))
		  {
		    SpeakString("I told you to leave.  If you are still here in thirty seconds, it will go badly for you.");
	        SetLocalInt(oSelf, "WARNED", TRUE);
	        SetLocalInt(oSelf, "COUNT", 30);
	        DelayCommand(1.0, _Count(oPC));			
		  }
		  else if (GetLocalInt(oSelf, "ANNOYED"))
		  {
		    // Oh dear, someone has said something to annoy her, and kept talking.			
			SpeakString("I am done talking with you, " + Address(oPC) + ".  Leave, now.");
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
        ExecuteScript("gs_run_ai", OBJECT_SELF);
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................
    {
	  object oPC   = GetLastPerceived();
	  SetLocalInt(gsPCGetCreatureHide(oPC), "FOUND_NOCTURNE", TRUE); // Turns off Nocturne's dream-summons (m_rest).
	  	  
	  if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {			
		if (Address(oPC) == "stranger" && GetDeity(oPC) == "Nocturne")
		{
		  DelayCommand(5.0f, SpeakString("Welcome, disciple, you have found me.  Now you may take your place in my earthly paradise."));
		}
		else if (Address(oPC) == "stranger" && GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
		{
		  DelayCommand(5.0f, SpeakString("Welcome home.  But I sense your heart is conflicted."));
		}
		else if (Address(oPC) == "stranger")
		{
		  DelayCommand(5.0f, SpeakString("Greetings, stranger.   Be welcome among us, and bring no harm here."));
		}
		else if (Address(oPC) == gsCMGetFirstName(oPC))
		{
		  DelayCommand(5.0f, SpeakString("Welcome back.  I have time to speak, if you wish to hear."));
		}
        else
        {
		  DelayCommand(5.0f, SpeakString("So, you're back.  Quickly please, I have things to do today."));
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
