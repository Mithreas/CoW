/**
 * ai_verria.nss
 * Author: Mithreas
 * Date: 16 Mar 2022
 *
 * This is the user defined script for the Verria.  It handles her conversation, 
 * as well as policing who can talk to her (in this case, anyone). Most of the conversation is
 * open to PCs to say what they like.  The NPC will pick out key words and respond. 
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 * This file includes plot secrets.  Don't read it if you want to explore the game
 * the way it's meant to be experienced :)  (This file is in .gitignore to avoid
 * being published to the repository). 
 *
 * If she takes a PC as an apprentice, permission_wiz is the token to allow it. 
 */
#include "inc_combat"
#include "inc_database"
#include "inc_event"
#include "inc_log"
#include "inc_subrace"
#include "inc_zdlg"
#include "zzdlg_color_inc"

const string DARKLADY = "DARKLADY"; // for tracing.

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
  
  if (nCount <= 0)
  {
    AdjustReputation(oPC, oSelf, -100);
	if (GetObjectSeen(oPC, oSelf)) AssignCommand(oSelf, gsCBDetermineCombatRound(oPC));
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
  // If PC alignment is Lawful, warn them to leave or else.
  object oSelf = OBJECT_SELF;
  
  if (!GetLocalInt(oSelf, "WARNED"))
  {
    SpeakString("I will give you thirty seconds to leave and never return, murderer.  Use them wisely.");
	SendMessageToPC(oPC, "((Izuna perceives your nature and isn't going to waste her time with you.))");
	SetLocalInt(oSelf, "WARNED", TRUE);
	SetLocalInt(oSelf, "COUNT", 30);
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
  string sAddress = GetPersistentString(oSpeaker, "VERRIA_ADDRESS");
  
  if (sAddress == "") sAddress = "stranger";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "IZUNA_ADDRESS", sAddress);
}
 
void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(DARKLADY, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    if (Contains(sText, "who are you"))
	{
	  if (Address(oSpeaker) == gsCMGetFirstName(oSpeaker))
	  {
	    Say("I am Verria.  The priests call me Lady of the Void, perhaps because of the alliteration, and perhaps because Loss feels something like a void in your heart.");  
	  }
	  else
	  {
	    Say("If you don't know, then why should I tell you?  Do you interrogate every stranger you meet?");
	  }
	}
	else if (Contains(sText, GetStringLowerCase(gsCMGetFirstName(oSpeaker))))
	{
	  UpdateAddress(oSpeaker, gsCMGetFirstName(oSpeaker));
	  Say("Very well, " + Address(oSpeaker) + ".  Now that we have the formalities out of the way, why are you here?"); 
	}
    // Goodbye
    else if (Contains(sText, "bye") || Contains(sText, "farewell"))
    {
	  Say("Fare thee well.");
	  
	  // Tidy up the dialog early.
	  DelayCommand(30.0f, DeleteLocalInt(OBJECT_SELF, "IN_DIALOG"));
    }	
    else if (Contains(sText, "loss"))
    {
      Say("I have known many losses in my life, those close to me torn away by various causes.  And so I am well placed to offer solace to those who seek it.");
    }
	else if (Contains(sText, "your losses"))
	{
	  if (Address(oSpeaker) == gsCMGetFirstName(oSpeaker))
	  {
	    Say("The war parted me from my lover, and many of my acquaintance.  Then ascension is not exactly the most gregarious experience.  Can gods have friends?  It seems not.");
	  }
	  else
	  {
	    Say("I am in no mood to indulge your curiosity, I'm afraid.  Perhaps another time.");
	  }
	  
	}
	else if (Contains(sText, "other gods"))
	{
	  Say("I got on well with some of the other gods, yes.  But even among the gods, nothing lasts forever.");
	}
	else if (Contains(sText, "lover"))
	{
	  Say("I was partnered with an Elf.  Obviously, when the war broke out, we were separated.  One boon of ascension is that I was able to see him again, but of course his people did not take kindly to his relationship with a deity of their enemy.  It is not like we could be together in any reasonable way.");
	}
	else if (Contains(sText, "emperor") || Contains(sText, "luthien"))
	{
	  Say("Luthien rules, pushing the limits of the compact that binds us.  But he rarely leaves the Palace, and thus avoids interference.");
	}
	else if (Contains(sText, "solkin's fate") || Contains(sText, "serrian's fate"))
	{
	  Say("With seven of us, we thought ourselves invincible, and Solkin led us into battle at the Wall.  But after the battle Solkin was ambushed and slain by the Elven gods, and Serrian went missing, presumably suffering the same fate.  After that we agreed to observe the Compact.");
	}
	else if (Contains(sText, "solkin"))
	{
	  Say("Solkin was enamoured of his immortality, seeing in it the secret to winning the war.  His fate was a lesson to all of us in the purpose of the compact.");
	}
	else if (Contains(sText, "morrian"))
	{
	  Say("Morrian is perhaps the most disillusioned of all of us.  We thought ascension would allow us to end the slaughter.  All it did was create an eternal stalemate.");
	}
	else if (Contains(sText, "serrian"))
	{
	  Say("I have seen and heard nothing of Serrian since the matter of the compact.  I believe him to have perished, but his fate is not known to me for sure.");
	}
	else if (Contains(sText, "trannos"))
	{
	  Say("Trannos has been wandering the world for some time in search of answers.  Sometimes we get to see each other, he hopes to find a way to end the stand-off of the great powers.");
	}
	else if (Contains(sText, "nocturne"))
	{
	  Say("Nocturne has her own plans for the future.  She barely speaks to the rest of us now.  Like Luthien, she presses the bounds of the compact.");
	}
	else if (Contains(sText, "izuna") || Contains(sText, "dark lady") || Contains(sText, "dark one"))
	{
	  Say("Izuna has her lair below us, and rarely leaves it.  She is well protected there, but she is not strong enough alone to defeat the rest of us.  Her actions weaken our defenses, though, and risk Elven victory.");
	}
	else if (Contains(sText, "trapped") || Contains(sText, "you leave") || Contains(sText, "exile"))
	{
	  Say("Yes, I am trapped here.  I would far rather be using my knowledge and talents to help defend Perenor, believe me.  It is ironic; the architect of our sanctuary, trapped within it.");
	}
	else if (Contains(sText, "stalemate"))
	{
	  Say("The war has drifted into stalemate, and it now rests in the hands of mortals to break that stalemate, in accordance with the Compact.  Of course, we offer our guidance and gifts to the cause... but I will not speak more of that.  Such is Luthien's domain.");
	}
    // The Compact.
	else if (Contains(sText, "limits"))
	{
	  Say("The limits are pretty simple.  In essence, we don't hunt down mortal servants of other gods, nor seek out battles.  We are permitted to claim and defend a sanctum of sorts, and to communicate freely with and bestow gifts upon mortals, but not to act directly ourselves.");
	}
	else if (Contains(sText, "compact"))
	{
	  Say("The Compact is the code of the gods.  Since only gods can kill other gods, and gods generally do not wish to die, the compact places limits on how directly we can interfere with the affairs of mortals.  So long as no god breaks the Compact, we are free to live as long as we wish.");
	}
	else if (Contains(sText, "sanctum"))
	{
	  Say("The Imperial Palace is an example of a sanctum.  Luthien rules there, and is entitled to act directly as he wishes within its walls without fear of consequence from others.  But, for example, to claim the Wall as a sanctum would likely not be a decision respected by others: it would be deemed interference with mortal struggles.");
	}
	else if (Contains(sText, "consequence") || Contains(sText, "interference"))
	{
	  Say("As the fates of Solkin and Serrian show, the consequences of interfering with mortal affairs can be terminal.  But there is no tribunal or codified law.  The gods work together to enforce the Compact because the consequences of not doing so would be chaotic and dangerous to us all.");
	}
	// Great powers
	else if (Contains(sText, "great powers") || Contains(sText, "oceanus"))
	{
	  Say("The Great Powers are the driving forces of our world.  Most are hostile to humanity: only the one known as Oceanus supports us.  The others would see us wiped out.  Oceanus has no love for Elves, or even halflings, but also supports the sea-folk Sahuagin.  Elves and halflings have their patrons among the other Powers.  And yet, these patron relationships are not eternal.");  
	}
	else if (Contains(sText, "norori") || Contains(sText, "suori") || Contains(sText, "austri") || Contains(sText, "vestri"))
	{
	  Say("An old name, I am surprised you know of it.  Norori, Suori, Austri and Vestri are the names an ancient race gave to the Great Powers.  Trannos knows more of such things.");
	}
	else if (Contains(sText, "stand-off") || Contains(sText, "standoff"))
	{
	  Say("The great powers are ancient enemies.  But their natures are only partly physical; they are beings of power.  Each seeks to break the standoff by dominating the flows of power in the world.");
	}
	else if (Contains(sText, "flows of power") || Contains(sText, "flow of power"))
	{
	  Say("This is a complicated subject, and Trannos would be able to speak on it better than I.  But in essence there is power in all things, a web throughout the world.  Some learn to make use of the raw power they hold, but gods, with the aid of the Great Powers, can produce much more refined effects.  So it is in the interests of mortals to worship gods and exchange their raw power for powerful abilities of refined power.  Gods benefit from a greater pool of raw power to work with.");
	}
	else if (Contains(sText, "patron relationships"))
	{
	  Say("Mortals may in general worship any patron that will accept them, but most cultures are built around a particular patron, creating a pattern of allies and enemies with the Great Powers and making it harder for those raised in that culture to show proper observance to other traditions.");
	}
	// Other
	else if (Contains(sText, "weather") || Contains(sText, "rain") || Contains(sText, "snow"))
	{
	  Say("One advantage of ascension is that I need not suffer the weather if I do not wish it. It is easy enough to be somewhere else.");
	}
	else if (Contains(sText, "i love you"))
	{
	  Say("My heart was spoken for long ago, I am afraid.");
	}
	else if (Contains(sText, "houses"))
	{
	  Say("The Houses are the fabric of our society.  House hierarchies allow each of us to find our place and ensure support from others.  Where there are no Houses, many slip through the gaps and into poverty.");
	}
	else if (Contains(sText, "fairies") || Contains(sText, "faeries") || Contains(sText, "fey"))
	{
	  Say("Fey are not to be trusted.  Their agendas and motivations are rarely obvious, and they are old and wise in the ways of power.");
	} 
	else if (Contains(sText, "gods") || Contains(sText, "divines"))
	{
	  Say("The Divines serve and guide humanity.  We turned a slaughter into a stalemate with our actions, and we will yet guide humanity to a future of prosperity.");
	}
	// Put this at the bottom to avoid being triggered every time the PC addresses her by name.
	else if (Contains(sText, "verria") || Contains(sText, "greetings") || Contains(sText, "hello"))
	{
	  Say("Greetings, " + Address(oSpeaker)); 
	}
	else
	{
	  DelayCommand(1.0, SpeakString("*she does not respond, staring off into the middle distance at something only she can see*"));
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
		  
        // Don't talk to Lawful PCs.
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
		  
		  _ProcessChat(sText);
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
	  
	  if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {
	    SetFacingPoint(GetPosition(oPC));
        
        // Move closer and open conversation.
        AssignCommand(oSelf, ActionMoveToLocation(GetLocation(oPC)));
        DelayCommand(2.0f, ClearAllActions());		
		
		if (Address(oPC) == "stranger" && GetRacialType(oPC) == RACIAL_TYPE_HUMAN)
		{
		  DelayCommand(5.0f, SpeakString("Hello there, stranger."));
		}
		else if (Address(oPC) == "stranger")
		{
		  DelayCommand(5.0f, SpeakString("Hello there, stranger.  I don't see many of your people down here."));
		}
		else if (Address(oPC) == gsCMGetFirstName(oPC))
		{
		  DelayCommand(5.0f, SpeakString("Welcome back.  Did you want something from me?"));
		}
        else
        {
		  DelayCommand(5.0f, SpeakString("So, you're back.  What do you want?"));
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
