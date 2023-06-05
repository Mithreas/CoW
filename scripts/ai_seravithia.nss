/**
 * ai_seravithia.nss
 * Author: Mithreas
 * Date: 21 Feb 2021
 *
 * This is the user defined script for Seravithia, the Star-Eyed.  It contains her 
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
#include "inc_combat"
#include "inc_event"
#include "inc_log"
#include "inc_reputation"
#include "inc_worship"
#include "zzdlg_color_inc"
#include "nw_i0_plot"

const string SERAVITHIA = "SERAVITHIA"; // for tracing.

/**
 * Utility methods
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

void _DoWarning(object oPC, string sText)
{
  // Warn the PC to leave,
  object oSelf = OBJECT_SELF;
  
  if (!GetLocalInt(oSelf, "WARNED"))
  {
    SpeakString(sText);
	SetLocalInt(oSelf, "WARNED", TRUE);
	SetLocalInt(oSelf, "COUNT", 30);
	DelayCommand(1.0, _Count(oPC));
  }
  else
  {
    // This is a second warned PC in the same party.  Hostile them in 30s. 
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
  string sAddress = GetPersistentString(oSpeaker, "SERAVITHIA_ADDRESS");
  
  if (sAddress == "") sAddress = "child";
  
  return sAddress;
}

void UpdateAddress(object oSpeaker, string sAddress)
{
  SetPersistentString(oSpeaker, "SERAVITHIA_ADDRESS", sAddress);
}
 
void _ProcessChat(string sText)
{
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(SERAVITHIA, "Processing PC speech (outsider branch): " + sText);
	
	// Todo: spirits!
	
	// This is the conversation branch for non Elves.
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
	int bLawful     = GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_LAWFUL;
	
	if (Contains(sText, "?") || Contains(sText, "why"))
	{
	  Say("I do not appreciate being addressed with battle manners.");
	}
	else if (Contains(sText, "sorry") || Contains (sText, "apolog"))
	{
	  Say("*Your apology visibly softens her demeanour* I appreciate the apology.  I have removed myself from the world for good reason, though, and would rather you returned to whence you came.");
	}
	else if (Contains (sText, "removed") || Contains (sText, "reason"))
	{
	  Say("It may seem strange to you that I do not live among our people.  But there is much you do not understand... even those who have far more reason to understand than you, sometimes fail to do so.");
	}
	else if (Contains(sText, "airevorn"))
	{
	  Say("Yes, I am familiar with what is happening in Airevorn.  No, I will not intervene directly; you do not want to see a conflict between gods.  But bring to me any who fall under that creature's sway, and I can clear their minds.");
	}
	else if (Contains(sText, "war"))
	{
	  Say("You will need to find your own way to win the war.  The human gods will no longer stand in your way... at least until it's too late to make any difference.");
	}
	else if (Contains(sText, "human gods"))
	{
	  Say("The human gods are young, and came to godhood without truly understanding it.  They have learnt from their past mistakes, as has Akavos.  Even the gods must be bound by rules.");
	}
	else if (Contains(sText, "rules"))
	{
	  Say("*She chuckles, dryly* No, " + Address(oSpeaker) + ", I will not teach you what it is to be a god.  Not until the day that you yourself have ascended.  And no, I won't tell you how to do that either.  The world does not need more gods.");
	}
	else if (Contains(sText, "more gods") || Contains(sText, "ascension") || Contains(sText, "ascended"))
	{
	  Say("A small number of gods brings order to the world.  Too many bring chaos, and a world of chaos would be deeply unpleasant for everyone.");
	}
	else if (Contains(sText, gsCMGetFirstName(oSpeaker)))
	{
	  Say("Yes, I know who you are, " + gsCMGetFirstName(oSpeaker) + ". But you observe the niceties by introducing yourself, and I appreciate that.");
	  UpdateAddress(oSpeaker, gsCMGetFirstName(oSpeaker));
	}
	else if (Contains(sText, "north") || Contains(sText, "beastmen") || Contains(sText, "beastlords"))
	{
	  Say("The lands to the north have ever been a source of pain and strife.  I think you are wise to turn your attention that way, and prepare. There are circumstances under which we may lend you more direct aid, but those have not yet come to pass.");
	}
	else if (Contains(sText, "age") || Contains(sText, "young") || Contains(sText, "old"))
	{
	  Say("I have seen many generations of our people live out the span of their years.  The world is no longer as it was, but not all change is to be feared.");
	}
	else if (Contains(sText, "change") || Contains(sText, "human decree"))
	{
	  Say("Humans are coming of age as a people, and facing an inflection point that will determine whether they mature into responsible stewards or wither as children.  The actions of our people are a necessary discipline to them.  Maybe they will learn from it, and maybe not.");
	}
	else if (Contains(sText, "coming of age") || Contains(sText, "inflection") || Contains(sText, "child"))
	{
	  Say("Our people were once foolish, as humans are.  The elder races among the Fey taught us, and we learnt.  Now we perform the same service for others.");
	}
	else if (Contains(sText, "akavos") || Contains(sText, "sabatha") || Contains(sText, "elven gods"))
	{
	  Say("The others keep to their own pursuits, as I do to mine.  We get together as needed, but see each other rarely.  I have not seen Sabatha in many a year, but Akavos is still young, and close to the affairs of mortals.");
	}
	else if (Contains(sText, "plague"))
	{
	  Say("I have seen the spread of the plague... it seems to come from the western coast.  But the medicines of our people have the matter in hand.");
	}
	else if (Contains(sText, "parli") || Contains(sText, "corrupt") || Contains(sText, "ritual"))
	{
	  Say("Every great war brings about damage to the land. The Ritual of Restoration is why we are able to wield the magic we do without causing irreparable harm. But it is a great responsibility and one to be taken seriously.");
	}
	else if (Contains(sText, "magic"))
	{
	  Say("Magic is a great gift, and a terrible responsibility.  Overuse of it can corrupt the natural order of the land and angers the spirits.  But it is a powerful tool for our people.");
	}
	else if (Contains(sText, "spirits"))
	{
	  Say("The spirits are all about us, and magic draws on their power.  Deliberately drawing on a powerful spirit lends far more power to your spells.  To live in harmony with the spirits gives you the best support from them when you need it.");
	}
	else if (Contains(sText, "harmony"))
	{
	  Say("Spirits have different natures; Fire is drawn to creativity, for example, as Earth is drawn to toil.  Performing acts in sympathy with the spirits will draw them to you, but what pleases one spirit may anger another.  A wise mage balances their attunements to their needs, and works to be in harmony with the spirits they most often draw upon.");
	}
	else if (Contains(sText, "answa") || Contains(sText, "edra"))
	{
	  Say("Edra and Answa were but children, as the humans are now.  They were intelligent, of course, and loving and caring.  But also naive and inconsiderate, heedless of the effect their actions and words had on others.  We are wiser now as a people.");
	}
	else
	{
	  switch (d3(1))
	  {
	    case 1:
		  Say("I think we will not speak of that right now.  But perhaps another time.");
		  break;
	    case 2:
		  Say("I appreciate that there is much you wish to learn.  Patience is important, however.");
		  break;
	    case 3:
	      Say("I hope you have enjoyed your visit.  You may leave any time you like through the portal over there.");
		  break;
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
						
        // Listen pattern -1 means we were clicked on.
		// Listen pattern 1/TRUE means someone said something nearby (see our spawn in condition below). 
        if (GetListenPatternNumber() == -1 && (GetIsPC(oPC) || GetIsDM(oPC)))
		{
		  // Clicked on by a PC.  Tell them to get their typing fingers on.		  
		  SendMessageToPC(oPC, "Talk to her like you would talk to another PC.  Short responses will work best."); 		  
		}
		else if (GetLocalInt(oSelf, "WARNED"))
		{
		  SpeakString("Time is ticking."); 
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
	  int bElf = TRUE;
	  string sDeity = GetDeity(oPC);
	  
	  if (GetIsPC(oPC) && (GetRacialType(oPC) != RACIAL_TYPE_ELF || gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SHAPECHANGER))
	  {
		DelayCommand(5.0f, _DoWarning(oPC, "You. *she points at " + gsCMGetFirstName(oPC) + "* You are not welcome here.  Leave or die."));	  
		bElf = FALSE;		
	  }	  
	  else if (GetIsPC(oPC) && sDeity == "Nocturne" && GetLevelByClass(CLASS_TYPE_CLERIC, oPC))
	  {
		DelayCommand(5.0f, _DoWarning(oPC, "You. *she points at " + gsCMGetFirstName(oPC) + "* How dare you show your face here.  Go back to your mistress, before I make that impossible for you."));
		bElf = FALSE;			
	  }
	  else if (GetIsPC(oPC) && sDeity == "Nocturne")
	  {
	    DelayCommand(5.0f, SpeakString("*Seravithia stares at " + gsCMGetFirstName(oPC) + " for a long moment, narrowing her eyes.  Then speaks.* You bear the taint of another's meddling.  That, I can free you of, at least."));
		bElf = FALSE;
		DelayCommand(5.0f, ActionCastFakeSpellAtObject(SPELL_NEUTRALIZE_POISON, oPC));
		DelayCommand(10.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oPC));
		DelayCommand(10.0f, SetDeity(oPC, ""));
		DelayCommand(10.0f, SendMessageToPC(oPC, "You are free of any compulsion to follow Nightwish/Nocturne.  Of course, you may return to her of your own free will should you wish."));
		DelayCommand(13.0f, SpeakString("There, now your mind is your own once more.  I am glad you found your way here."));
	  }
	   
	  if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG") && bElf)
	  {	
	    if (Address(oPC) == "child")
		{
		  DelayCommand(5.0f, SpeakString("I assume you have a good reason for disturbing me.  Out with it."));
		}
		else
		{
		  DelayCommand(5.0f, SpeakString("You again... I hope you have good reason to disturb your Goddess today."));
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
