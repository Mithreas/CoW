/**
 * ai_fairyqueen.nss
 * Author: Mithreas
 * Date: 28 July 2018
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
 * For those she likes, the Queen may give out a token of passage (feytokenofpassag)
 * to allow the traveller to avoid conflict with fey. 
 * If she grants a human permission to be a druid, permission_druid is the token to allow it. 
 */
#include "inc_backgrounds"
#include "inc_combat"
#include "inc_database"
#include "inc_emotes"
#include "inc_event"
#include "inc_iprop"
#include "inc_log"
#include "inc_worship"
#include "zzdlg_color_inc"
#include "nw_i0_plot"

const string FAIRYQUEEN = "FAIRYQUEEN"; // for tracing.

/**
 * Utility methods
 */
void _OpenDoor()
{ 
    object oDoor = GetObjectByTag("pfdfqc_portaldoor");
    SetLocked(oDoor, FALSE);
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
	AssignCommand(oDoor, ActionSpeakString("Creeeeaaaak"));
}

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
  
  if (nCount <= 0)
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
    SpeakString("You dare bring iron into my presence?!  I will give you thirty seconds to run, despoiler.  Use them wisely.");
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
  DelayCommand(1.0, SpeakString(sText));
}

string Address(object oSpeaker)
{
  string sAddress = GetPersistentString(oSpeaker, "FAIRYQUEEN_ADDRESS");
  
  if (sAddress == "") sAddress = "despoiler";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "FAIRYQUEEN_ADDRESS", sAddress);
}
 
void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(FAIRYQUEEN, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
 
    // Apology - sorry, spolog(y|ies)
    if (Contains(sText, "sorry") || Contains(sText, "apolog"))
    {
      Say("You are sorry?  Regret does not undo the damage that was done.  Your people are despoilers, and that makes us enemies.");
    }
	// who are you
	else if (Contains(sText, "who are you"))
	{
	  Say("My name is Elakadencia.  But there is none who dwell in these woods who would have needed to ask that question."); 
	}
	else if (Contains(sText, "well met") || Contains(sText, "greet") || Contains(sText, "hello"))
	{
	  Say("Hello to you too.  What brings you to my Court?"); 
	}
	else if (Contains(sText, "ask") || Contains(sText, "question"))
	{
	  Say("There is much that I know that you do not.  But I have better things to do with my time than to educate despoilers.  If you have nothing of substance to say to me, then you may leave."); 
	}
	else if (Contains(sText, "forest") || Contains(sText, "feywild") || Contains(sText, "this place"))
	{
	  Say("The Wilds are our home.  What of them?"); 
	}
	else if (Contains(sText, "emperor") || Contains(sText, "divines") )
	{
	  Say("The Emperor and his so-called Divines are of little interest to me, save that they send you here to despoil my lands."); 
	}
	else if (Contains(sText, "gods"))
	{
	  Say("I know much of the other gods, but it is hardly your business to know such things.  As a mortal there is much you can do to address wrongs committed by your kind, but the business of the gods is our own.");
	}
	else if (Contains(sText, "ascension"))
	{
	  Say("I have little interest in discussing ascension with you.  Another mortal seeking power is not going to improve matters.");
	}
	else if (Contains(sText, "meriadoc") || Contains (sText, "druidic oaths"))
	{
	  Say("The oaths of a druid, to serve the balance rather than upset it, are of prime importance.  Abandoning them can have greater consequences than you could possibly imagine.  And thus, the oaths are enforced.");
	}
	else if (Contains(sText, "consequences"))
	{
	  Say("I will not be questioned on such matters.  Believe me when I say that I know of which I speak.");
	}
	else if (Contains(sText, "seek power") || Contains(sText, "seeking power"))
	{
	  Say("Many mortals seek power, and a few find it.  But regardless of their reasons for doing so, the outcome is generally destructive.  The cycle does not need more power hungry mortals trying to change things.");
	}
    // Goodbye
    else if (Contains(sText, "bye") || Contains(sText, "farewell"))
    {
	  Say("Farewell, then.  You may have safe passage through this portal. *she waves a hand*");
      _OpenDoor();
	  
	  // Tidy up the dialog early.
	  DelayCommand(30.0f, DeleteLocalInt(OBJECT_SELF, "IN_DIALOG"));
    }	
    else if (GetLocalInt(oSelf, "FEALTY"))
	{
	  if (Contains (sText, "will kneel") || Contains (sText, "will serve") || Contains(sText, "will join"))
	  {
	    Say("Well, you show uncommon wisdom.  I am glad, though your path will lead you into conflict with your people.  Know that you will always be welcome here; this token will grant you passage.");
		PerformEmote(EMOTE_KNEEL, oSpeaker);
		// Give the gift of unique favour so that they can worship the Queen.
		AddGift(oSpeaker, GIFT_OF_UNIQUE_FAVOR);
		SetDeity(oSpeaker, gsWOGetNameByDeity(10)); // Worship Elakadencia.		
        gsWOAdjustPiety(oSpeaker, -(gsWOGetPiety(oSpeaker)));
		SendMessageToPC(oSpeaker, "You are now serving Elakadencia, and have her favour (gift of unique favour applied)");
		CreateItemOnObject("feytokenofpassag", oSpeaker);
		CreateItemOnObject("permission_druid", oSpeaker);
		UpdateAddress(oSpeaker, "disciple");
		
		DelayCommand(3.0f, Say("As my servant, I charge you with the following duty.  Travel to the Wall.  Do what you can to reverse the damage that is being done.  Return the water to the sea.  You are welcome to protect your people as best you can without disturbing the greater Balance."));
	  }
	  else if (Contains (sText, "no") || Contains (sText, "think about"))
	  {
	    Say("As expected.  You may leave unharmed... until you raise your hand against us directly.");
		DeleteLocalInt(oSelf, "FEALTY"); 
		SetLocalInt(oSelf, "ANNOYED", TRUE);
	  }
	  else if (Contains(sText, "thank") || Contains(sText, "will"))
	  {
	    Say("Good.  Prepare yourself as you need to; this place will be a haven to you as you need it.  Now you may leave.");
		DeleteLocalInt(oSelf, "FEALTY");
	  }
	  else
	  {
	    Say("We will speak more another time.  I have other matters to attend to now.");
		DeleteLocalInt(oSelf, "FEALTY");
	  }
	}
    else if (GetLocalInt(oSelf, "THE_WALL"))
    {
      if (Contains(sText, "kill the land") || Contains(sText, "crime") || Contains(sText, "what have we done"))
	  {
	    Say("You claim ignorance?  How fascinating.  Is it possible that you do not truly know the damage your people are doing?  Their efforts to turn land into sea?");
	  }
	  else if (Contains(sText, "land into sea") || Contains(sText, "land in to sea") || Contains(sText, "darker fate"))
	  {
	    Say("To the north, there is a huge wall of stone.  And beyond it, seawater pumping endlessly onto the land, moved by great machines.  Woods, streams and lakes, all vanishing under a tide of saltwater.  And with it, comes Hunger.");
	  }
	  else if (Contains(sText, "wall"))
	  {
	    Say("The wall itself is an eyesore, and blocks passage to many of my kin.  But it is not an abomination; it is the advance of Hunger that concerns my people."); 
	  }
	  else if (Contains(sText, "stop hunger") || Contains(sText, "kill hunger") || Contains(sText, "defeat hunger"))
	  {
	    Say("It is an elder power, " + Address(oSpeaker) + ".  It cannot be defeated.  But your people make it stronger, allowing it to reach onto land and devour all who live here.  That we cannot allow.");
	  }
	  else if (Contains(sText, "need to") || Contains (sText, "elves"))
	  {
	    Say("We know of your war with the Elves.  But in fleeing from them, you unleash a far darker fate upon us all.  The path you walk does not just lead to the destruction of the Elves, but of all... including yourselves.");
	  }
	  else if (Contains(sText, "hunger"))
	  {
	    Say("What do you know of the Great Powers, " + Address(oSpeaker) + "?  Hunger is one of the four.  All things must eat, and Hunger most of all.  Its appetite is insatiable, and it would devour all the world if it could.");
	  }
	  else if (Contains(sText, "great powers"))
	  {
	    Say("Truly, your people know little of the nature of the world.  I could teach you for a year about the Great Powers, and you would still have only the faintest glimmer of understanding.  Suffice to say that the world exists in the balance of the four powers, and to grant one of them dominance would mean the end of the world as we know it.");
	  }
	  else if (Contains(sText, "dominance") || Contains (sText, "end of the world"))
	  { 
	    if (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SHAPECHANGER ||
		    GetLevelByClass(CLASS_TYPE_SORCERER, oSpeaker) ||
			GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker) ||
			GetLevelByClass(CLASS_TYPE_SHIFTER, oSpeaker) ||
			GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oSpeaker) ||
			GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker))
		{
			Say("Yes.  The world depends on balance between the Powers.  Three of the Powers would consume the whole world to build their power, only one seeks it to stay whole.  And yet, you have committed yourself to service of one of the Three, and your every act hastens the world's doom.");
			SetLocalInt(oSelf, "SERVES_OTHER", TRUE);
			DeleteLocalInt(oSelf, "THE_WALL");
		}
		else
		{
			Say("Yes.  The world depends on balance between the Powers.  Three of the Powers would consume the whole world to build their power, only one seeks it to stay whole.  If you truly value your life, you should serve me, and through me, the one Power that would see you live.  So what will it be?  Will you turn away from me, and persist in your path of destruction?  Or will you kneel, and join me in protecting our world from destruction?");
			SetLocalInt(oSelf, "FEALTY", TRUE);
			DeleteLocalInt(oSelf, "THE_WALL");
		}
	  }
	  else
	  {
	    Say("I will indulge your ignorance no more at this time.  Though you may visit again, if you keep your manners.");
		DeleteLocalInt(oSelf, "THE_WALL");
	  }
    }
	else if (GetLocalInt(oSelf, "SERVES_OTHER"))
	{
	  if (Contains(sText, "powers") || Contains(sText, "doom"))
	  {
	    Say("Most of what your peoples call 'magic' is drawn from the Great Powers.  Those of us who attract your worship are intermediaries, if you will.  Your gods serve powers that would sunder the world if they could, in the name of their own power.");
	    DeleteLocalInt(oSelf, "SERVES_OTHER");
	  }
	}
    // Peacemaker
    else if (Contains(sText, "make peace") || Contains(sText, "make amends") || Contains(sText, "peaceful")|| Contains(sText, "enemies"))
    {
	  if (GetRacialType(oSpeaker) == RACIAL_TYPE_ELF)
	  {
		Say("Your people drive the Halflings and Human of this land to desperate acts, such that they despoil the land itself, in the name of a squabble between Powers of which you know little.  Pure foolishness.");
		SetLocalInt(oSelf, "SERVES_OTHER", TRUE);
	  }
	  else
	  {
		Say("Your people try to kill the land itself.  There can be no peace with such as you.");
	  
		// Let's talk about the real problem...
		SetLocalInt(oSelf, "THE_WALL", TRUE);
	  }
    }
	else if (Contains(sText, "despoil"))
	{
	  if (GetRacialType(oSpeaker) == RACIAL_TYPE_ELF)
	  {
		Say("Your people drive the Halflings and Human of this land to desperate acts, such that they despoil the land itself, in the name of a squabble between Powers of which you know little.  Pure foolishness.");
		SetLocalInt(oSelf, "SERVES_OTHER", TRUE);
	  }
	  else
	  {
		Say("Yes.  How many lives have you taken just reaching this place?  And yet that is not even the beginning of the crimes your people have committed.");
	  
		// Let's talk about the real problem...
		SetLocalInt(oSelf, "THE_WALL", TRUE);
	  }
	}
	else if (Address(oSpeaker) == "disciple")
	{
	  Say("You are welcome in my lands, disciple.  But remember the task you have been given; remember that Hunger must not be allowed to claim the land."); 
	}
	// Put at the bottom to avoid being triggered regularly.
    else if (Contains(sText, "highness") || Contains(sText, "majesty"))
    {
	  Say("You are a polite one, I will concede that.  What would you ask of me, visitor?");	  
	  UpdateAddress(oSpeaker, "visitor");
    }	
	// Put this at the bottom to avoid being triggered every time the PC addresses her by name.
	else if (Contains(sText, "elakadencia"))
	{
	  Say("A bold one, to address me so directly.  What is it that brought you here?"); 
	}
	else
	{
	  Say("Well, it has been unusual having you here.  But it is time for you to go now.  You may have safe passage through this portal. *she waves a hand*");
      _OpenDoor();	  
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
	  
	  if (GetIsPC(oPC) && _WearsIron(oPC))
	  {
	    _DoWarning(oPC);
	  }
	  else if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {
	    SetFacingPoint(GetPosition(oPC));
        
        // Move closer and open conversation.
        AssignCommand(oSelf, ActionMoveToLocation(GetLocation(oPC)));
        DelayCommand(2.0f, ClearAllActions());		
		
		if (Address(oPC) == "despoiler")
		{
		  DelayCommand(5.0f, SpeakString("So, one of the despoilers makes it all the way to my court.  What is it you seek here, despoiler?"));
		}
		else if (Address(oPC) == "disciple")
		{
		  DelayCommand(5.0f, SpeakString("Welcome back.  Was there something you wished to know?"));
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
