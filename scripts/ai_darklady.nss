/**
 * ai_darklady.nss
 * Author: Mithreas
 * Date: 22 Apr 2018
 *
 * This is the user defined script for the Dark Lady.  It handles her conversation, 
 * as well as policing who can talk to her (non Lawful). Most of the conversation is
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
  string sAddress = GetPersistentString(oSpeaker, "IZUNA_ADDRESS");
  
  if (sAddress == "") sAddress = "murderer";
  
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
 
    // Apology - sorry, spolog(y|ies)
    if (Contains(sText, "sorry") || Contains(sText, "apolog") || Contains(sText, "defending myself") || Contains(sText, "self-defence") || Contains(sText, "murderer"))
    {
      Say("You invaded their homes, and slaughtered any who opposed you. No doubt you thought you were being heroic.  And now you find yourself facing me.");
    }
	// who are you
	else if (Contains(sText, "who") && Contains(sText, "murdered"))
	{
	  Say("My servants and allies who live around me.  If it were not for the brainwashing of the Inquisition, I would not even give you the chance to defend yourself.");
	}
	else if (Contains(sText, "who are you"))
	{
	  Say("My name is Izuna. But if you've heard of me, it's unlikely to be by my name."); 
	}
	// Dark Lady / Dark One
	else if (Contains(sText, "dark lady") || Contains(sText, "dark one"))
	{
	  Say("Yes, I bear that title.  But I prefer the name Izuna.  You are welcome to use it."); 
	}
	else if (Contains(sText, GetStringLowerCase(gsCMGetFirstName(oSpeaker))))
	{
	  UpdateAddress(oSpeaker, gsCMGetFirstName(oSpeaker));
	  Say("Very well, " + Address(oSpeaker) + ".  Now that we have the formalities out of the way, why are you here?"); 
	}
    // Goodbye
    else if (Contains(sText, "bye") || Contains(sText, "farewell"))
    {
	  Say("Farewell, then.  May you return home safely, and without taking more innocent lives.");
	  
	  // Tidy up the dialog early.
	  DelayCommand(30.0f, DeleteLocalInt(OBJECT_SELF, "IN_DIALOG"));
    }	
    // threat(en) the city
    else if (Contains(sText, "threat") && Contains(sText, "city"))
    {
      Say("Those living down here pose little threat to the city.  They have their own concerns.  When have we ever attacked you?");
    }
	// inquisition, will/I'll speak
	else if (Contains(sText, "inquisition") || Contains (sText, "ll speak") || Contains(sText, "illusion") || Contains(sText, "truth"))
	{
	  Say("The Inquisition would have you believe that I am a corruptor, no?  That I seek the destruction of humanity?  Why would I wish the extinction of my own people?");
	}
	// don't know
	else if (Contains(sText, "don't know"))
	{
	  Say("Yes, well, there is much you don't know, " + Address(oSpeaker) + ".  I will share truths with you, if you care to hear them, but you may not thank me.  Ask, and I will do my best to answer.");
	}
	// extinction 
	else if (Contains(sText, "extinction") || Contains(sText, "elves") || Contains(sText, "war"))
	{
	  Say("I have no desire to see the Elves finish their genocide.  Indeed, that was why I took up magic in the first place... to learn the tools of our enemy, to fight back more effectively.");
	}
	// magic, tools 
	else if (Contains(sText, "magic") || Contains(sText, "tools"))
	{
	  Say("I could not tell you all I have learnt of magic in a day.  Maybe one day I will teach an apprentice again.  But the knowledge will do you no good, since no magician can leave this island.");
	}
	else if (Contains(sText, "trapped") || Contains(sText, "you leave") || Contains(sText, "exile"))
	{
	  Say("Yes, I am trapped here.  I would far rather be using my knowledge and talents to help defend Perenor, believe me.  It is ironic; the architect of our sanctuary, trapped within it.");
	}
    // Disbelief.
	else if (Contains(sText, "don't believe") || Contains(sText, "liar") || Contains(sText, "lies"))
	{
	  Say("I care not if you believe me, mortal.  You have no idea how irrelevant your concern is, nor how many falsehoods you believe unwittingly.");
	}
	else if (Contains(sText, "to talk") || Contains(sText, "to speak"))
	{
	  Say("Well, we are speaking.  I admit it livens up a boring day, " + Address(oSpeaker) + " but I hope you didn't come all the way here to tell me what the weather is doing above.");
	}
	else if (Contains(sText, "weather") || Contains(sText, "rain") || Contains(sText, "snow"))
	{
	  Say("Yes, well, the weather long since stopped being relevant to me.  One facet of being an exile from our people.");
	}
	else if (Contains(sText, "i love you"))
	{
	  Say("You do not even know me.  At best you are in love with the idea of love.  You will not manipulate me so easily.");
	}
    // Vanis - Izuna's house name
	else if (Contains(sText, " vanis ") || Contains(sText, " vanis."))
	{
	  Say("You have done your research, " + Address(oSpeaker) + ". Yes, House Vanis was my House.  Those mages among my kin were executed, the rest rendered houseless, or offered service elsewhere.");
	}
	else if (Contains(sText, "terrible") || Contains(sText, "awful"))
	{
	  Say("The world is not a nice place, " + Address(oSpeaker) + ".  Set aside your illusions and deal with it as it is, not as you would wish it to be.");
	}
	else if (Contains(sText, "houses"))
	{
	  Say("The Houses were formed by those who led their peoples here, retreating from the Elves during the war.  Luthien, Solkin, Morrian and myself brought our retinues.");
	}
	else if (Contains(sText, "fairies") || Contains(sText, "faeries") || Contains(sText, "fey"))
	{
	  Say("The fey?  What about them?  They live all over the place on the mainland, though I have seen none on this island.  Probably a good thing, or they would be as trapped as I.");
	}
    else if (GetLocalInt(oSelf, "APPRENTICE"))
    {
	  if (Contains(sText, "yes") || Contains(sText, "i understand"))
	  {
	    Say("So be it.  You are a fool, of course; that goes without saying.  But perhaps one day we will find a way to escape this isle and the Elves both.  *She murmurs a cantrip over some books, and hands them to you* These books are now bound to you.  They will help guide you along this path.");
		CreateItemOnObject("permission_wiz", oSpeaker);
		CreateItemOnObject("wizbook1", oSpeaker);
		SendMessageToPC(oSpeaker, "Congratulations, you can now take levels in Wizard.  You may (and should!) RP Izuna as your mentor where relevant, though she will need DM help to hold detailed theory discussions with you.  You can now click on her to access wizard training options.  Remember, being a mage is punishable by death, so you should treat everything you learn as top secret."); 
		
		DeleteLocalInt(oSelf, "APPRENTICE");
	  }
	  else
	  {
	    Say ("Wise.  To study magic brings much power, but at a very high cost.  I would not wish any to take up this path unless they are truly ready for it.");
		DeleteLocalInt(oSelf, "APPRENTICE");
	  }
	}
    else if (GetLocalInt(oSelf, "ASCENSION"))
    {
      if ((Contains (sText, "heresy") || Contains(sText, "heretic")) && Contains(sText, "you"))
	  {
	    // PC is persisting.  End the conversation.  
		Say("Narrow-minded fool.  I will waste my time with you no more.  Leave.");
		SetLocalInt(oSelf, "ANNOYED", TRUE);
		DelayCommand(900.0f, DeleteLocalInt(oSelf, "ANNOYED")); 
	  }
	  else if (Contains(sText, "luthien") || Contains(sText, "emperor") )
	  {
	    Say("Luthien is the name of your Emperor.  Once, we were lovers.  "+MakeTextColor(txtGreen, "[she laughs, dryly]")+"  Even gods make mistakes.  I did not see how ruthless he was.");
	  }
	  else if (Contains(sText, "lovers") )
	  {
	    Say("That is hardly your business.  But yes, we were close, once.  Not that it saved him condemning me.");
	  }
	  else if (Contains(sText, "ruthless") || Contains(sText, "condemn"))
	  {
	    Say("Dear child, you have no idea.  What we did, all of us, to save humanity.  What Luthien does, even now, to keep the truth secret.  And so much more.  But perhaps that is for the best.  You should be focused on our survival, should you not?");
	  }
	  else if (Contains(sText, "what did you do") || Contains(sText, "secret"))
	  {
	    Say("I am the only one of the gods who earned her power.  I am a mage, and I learnt the secrets of the Arcane through wit and study.  The others... I know how they ascended.  I expect you haven't thought about how they did it.  Few ever do.  The Inquisition discourages it.");
	  }
	  else if (Contains(sText, "ascend") || Contains(sText, "power"))
	  {
	    Say("They did not earn their power.  There are only two other ways to get power... to steal it or be gifted it.  Those without power can rarely steal it, no?  So what do you think is most likely?");
	  }
      else if (Contains(sText, "gifted"))
	  {
	    Say("Yes, they were gifted it.  A simple pact, with a being of unimaginable nature.  We called it Oceanus.");
	  }
	  else if (Contains(sText, "oceanus"))
	  {
	    Say("Even I cannot truly tell you what Oceanus is.  It exists in the ocean, it is conscious and can be spoken to through magical means, and it is hungry.  Very hungry.  But how it came by its power, or how it lives... I could not tell you.");
	  }
	  else if (Contains(sText, "hunger") || Contains(sText, "hungry"))
	  {
	    Say("Oceanus devours magic.  It is Oceanus that keeps this island safe from the Elves, and it does not do it for us.  It does it because it feeds on them.  Oceanus gives power to humanity, to our priests, because we serve it.");
	  }
	  else if (Contains(sText, "service") || Contains(sText, "serve"))
	  {
	    Say("We feed mages to the sea.  And we seek to spread Oceanus' influence over the land, so that it can feed on magical creatures in the mainland.  Go see the Great Wall, and you will understand.");
	  }
	  else if (Contains(sText, "survival"))
	  {
	    Say("On this at least Luthien and I still agree.  The Elves will finish what they have started, given the chance.  I do not regret my actions... merely the actions of others.");
	  }
	  else if (Contains(sText, "betrayal") || Contains(sText, "actions of others"))
	  {
	    Say("I discovered Oceanus.  I made our pact possible. But Oceanus is a greedy being, and sought my life from the others to seal our bargain.  I was old in my power, and they were new to theirs, so I escaped without difficulty... but have been in exile since.");
	  }
	  else
	  {
	    Say("We have spoken enough for now, " + Address(oSpeaker) + ".  You may return another day, but you will leave me now.");
	    DeleteLocalInt(oSelf, "ASCENSION");
	  }
    }
    // heretic - leads to Ascension branch.
    else if (Contains(sText, "heresy") || Contains(sText, "heretic"))
    {
      Say("Calling me a heretic is amusing.  I am one of your gods, did you know that?  The one they would all rather ignore.  'Dear' Luthien has his throne because of me.  So no, I do not worship him.");
	  // What the PC says next is interesting, so take into a separate branch.
	  SetLocalInt(oSelf, "ASCENSION", TRUE);
    }
	// gods, divines, seven - open up Ascension branch., 
	else if (Contains(sText, "gods") || Contains(sText, "divines"))
	{
	  Say("You want to ask -me- about the gods?  My, the Inquisition must love you.  Do try to stay out of their hands.  But yes, I will tell you of dear Emperor Luthien... if you wish to learn things that the Inquisition would kill you for in an eyeblink.");
	  SetLocalInt(oSelf, "ASCENSION", TRUE);
	}
	// Apprentice - opens up the Apprentice branch if the PC has been friendly enough. 
	else if (Contains(sText, "apprentice") || Contains(sText, "teach me"))
	{
	  if (Address(oSpeaker) == gsCMGetFirstName(oSpeaker) && !GetIsObjectValid(GetItemPossessedBy(oSpeaker, "GS_PERMISSION_CLASS_10")))		
	  {
	    Say("You wish to become my apprentice?  Are you sure you understand the implications of this?  You will never be able to leave the island, and you will be executed if any discover you.");
		
		// Enable apprentice branch. 
		SetLocalInt(OBJECT_SELF, "APPRENTICE", TRUE);
	  }
	  else
	  {
	    Say("I have been known to take apprentices, when I like someone enough.  And they are foolish enough to wish it.");
	  }
	}
	// Architect or Sanctuary open up the Ascension branch.
	else if (Contains(sText, "architect") || Contains(sText, "sanctuary"))
	{
	  Say("It was through my studies of magic that I discovered the way to make us safe.  It was my magic that made the ascension of Luthien and the others possible.  And I was the fool who did not anticipate betrayal.");
	  SetLocalInt(oSelf, "ASCENSION", TRUE);
	}
	// Put this at the bottom to avoid being triggered every time the PC addresses her by name.
	else if (Contains(sText, "izuna") || Contains(sText, "greetings") || Contains(sText, "hello"))
	{
	  Say("You have more manners than most.  Will you speak with me, or has the Inquisition stuffed your head full of nonsense?"); 
	  if (Address(oSpeaker) == "murderer") UpdateAddress(oSpeaker, "stranger");
	}
	else if (!GetIsObjectValid(GetItemPossessedBy(oSpeaker, "GS_PERMISSION_CLASS_10")) && GetLocalInt(OBJECT_SELF, "IN_DIALOG") == 2)
	{
	  Say("I do not get many visitors, but I tire of them quickly.  You may leave now."); 
	  SetLocalInt(oSelf, "ANNOYED", TRUE);
	  DelayCommand(900.0f, DeleteLocalInt(oSelf, "ANNOYED")); 
	}
	else
	{
	  DelayCommand(1.0, SpeakString("I was hoping for a more interesting conversation; I do get to hold them so rarely."));
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
	    if (GetListenPatternNumber() == -1 && GetIsPC(oPC) && GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
	    {
	      ClearAllActions();
		  SpeakString("Time is ticking."); 
	    }
		else if (GetListenPatternNumber() == -1 && GetIsObjectValid(GetItemPossessedBy(oPC, "GS_PERMISSION_CLASS_10")))
		{
		  // Training for wizards.
		  StartDlg(oPC, OBJECT_SELF, "zdlg_training", TRUE, FALSE);
		}
		else if (GetListenPatternNumber() == -1 && (GetIsPC(oPC) || GetIsDM(oPC)))
		{
		  // Clicked on by a non Lawful PC.  Tell them to get their typing fingers on.		  
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
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................
    {
	  object oPC   = GetLastPerceived();
	  
	  if (GetIsPC(oPC) && (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL || gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SHAPECHANGER))
	  {
	    _DoWarning(oPC);
	  }
	  else if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {
	    SetFacingPoint(GetPosition(oPC));
        
        // Move closer and open conversation.
        AssignCommand(oSelf, ActionMoveToLocation(GetLocation(oPC)));
        DelayCommand(2.0f, ClearAllActions());		
		
		if (Address(oPC) == "murderer")
		{
		  DelayCommand(5.0f, SpeakString("Well, murderer, what do you have to say for yourself?"));
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
