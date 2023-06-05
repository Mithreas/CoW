/**
 * ai_nymphtalk.nss
 * Author: Mithreas
 * Date: 24 June 2018
 *
 * This is the user defined script for the nymph encounter in the Feywilds.  It 
 * handles her conversation, as well as policing who can talk to her (druid/ranger). 
 * Most of the conversation is open to PCs to say what they like.  The NPC will 
 * pick out key words and respond. 
 *
 * The conversation is a riddle - she will pick one of the riddles she knows, and 
 * the PC (or their party) has to guess the answer in three attempts.  
 * 
 * No dialog file - the conversation should be like chatting to another PC - you 
 * type, they respond.  (Just more quickly, no typing lag).
 *
 */
#include "inc_log"
#include "inc_loot"
#include "x0_i0_position"


const string NYMPHO = "NYMPHO"; // for tracing.

const string ANSWER  = "NYMPH_ANSWER";
const string GUESSES = "NYMPH_GUESSES";

/**
 * Method to handle fleeing
 */
void _Flee()
{
  object oWaypoint = GetNearestObjectByTag("WP_NYMPHPOOL");
  
  ActionMoveToObject(oWaypoint, TRUE, 0.0f);
  DelayCommand(3.0f, SpeakString("Splash!"));
  DelayCommand(3.1f, DestroyObject(OBJECT_SELF));
  SetCommandable(FALSE); 
}
 
/**
 * Methods to handle dialog.
 */
void _Riddle()
{
  string sQuestion;
  string sAnswer;
  string sHint;

  // Sets up a random riddle.
  switch (d10())
  {
    case 1:
	  sQuestion = "Poor people have it.  Rich people need it.  If you eat it, you'll die.  What is it?";
	  sAnswer   = "nothing";
	  sHint     = "Nothing";
	  break;
    case 2:
	  sQuestion = "I have a head but no body, a heart but no blood.  Just leaves and no branches, I grow without wood.  What am I?";
	  sAnswer   = "lettuce";
	  sHint     = "A lettuce.";
	  break;
    case 3:
	  sQuestion = "I can throw a ball so hard that it will stop, change direction and come back to me.  How?";
	  sAnswer   = "straight up";
	  sHint     = "You throw it straight up in the air.";
	  break;
    case 4:
	  sQuestion = "I am an odd number.  If you take away one of the letters in my name, I become even.  What am I?";
	  sAnswer   = "seven";
	  sHint     = "The number seven - take away the S.";
	  break;
    case 5:
	  sQuestion = "This word I know.  Six letters it contains.  Take away the last, and only twelve remains.  What is the word?";
	  sAnswer   = "dozens";
	  sHint     = "Dozens - lose the S and you still have a dozen.";
	  break;
    case 6:
	  sQuestion = "What has one head and one foot, but four legs?";
	  sAnswer   = "bed";
	  sHint     = "A bed.";
	  break;
    case 7:
	  sQuestion = "How far can a fox run into a grove?";
	  sAnswer   = "halfway";
	  sHint     = "Halfway - after that it is running out.";
	  break;
    case 8:
	  sQuestion = "What do you break before you use it?";
	  sAnswer   = "egg";
	  sHint     = "An egg.";
	  break;
    case 9:
	  sQuestion = "A child fell out of a thirty foot tree without getting hurt.  How?";
	  sAnswer   = "bottom";
	  sHint     = "She fell off the bottom branch.";
	  break;
    case 10:
	  sQuestion = "A box without hinges, key or lid.  Yet golden treasure inside is hid.  What am I?";
	  sAnswer   = "egg";
	  sHint     = "An egg.";
	  break;	  
  }
  
  // Comedy override.
  if (d100() == 1)
  {
    sQuestion = "What have I got in my pockets?";
	sAnswer   = "one ring";
	sHint     = "Clearly, the nymph is breaking the fourth wall on this one.";
  }
  
  SpeakString(sQuestion);
  SetLocalString(OBJECT_SELF, ANSWER, sAnswer); 
  
  int nNth   = 1;
  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
  while (GetIsObjectValid(oPC) && GetDistanceBetween(oPC, OBJECT_SELF) != 0.0f)
  {
    if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE) >= 16)
	{
	  SendMessageToPC(oPC, "You've heard this one before. " + sHint);
	}
	
    nNth++;
	oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nNth);
  }
}
 
int _Contains(string sText, string sSubString)
{
  return (FindSubString(sText, sSubString) > -1);
} 

void _Say(string sText)
{
  DelayCommand(1.0, SpeakString(sText));
}

void _ProcessChat(string sText)
  {
    // Trace out what was said, so we can review logs and improve behaviour.
	Trace(NYMPHO, "Processing PC speech: " + sText);
	
    object oSelf    = OBJECT_SELF;
	object oSpeaker = GetLastSpeaker();
    sText           = GetStringLowerCase(sText);
    int nCount      = GetLocalInt(OBJECT_SELF, GUESSES);
 
    if (GetLocalInt(oSelf, "ANSWERED")) return;
 
    if (_Contains(sText, GetLocalString(OBJECT_SELF, ANSWER)))
	{
	  _Say("Yes, that's it!  Very good.  Have a reward.");
	  CreateProceduralLoot(LOOT_TEMPLATE_TIER_1, LOOT_CONTEXT_BOSS_LOW, oSpeaker, oSpeaker, TRUE);
	  SetLocalInt(oSelf, "ANSWERED", TRUE);
	  _Flee();
	}
    else if (!nCount)
	{
	  _Say("That's not it.  You have two more guesses.");
	  SetLocalInt(OBJECT_SELF, GUESSES, 1);
	}
	else if (nCount == 1)
	{
	  _Say("Ooh, good try. But still wrong.");
	  SetLocalInt(OBJECT_SELF, GUESSES, 2);
	}
	else if (nCount == 2)
	{
	  _Say("Nope, that's not it either!  Goodbye.");
	  _Flee();
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
		  SpeakString("Not so close, please."); 
		  
		  // Back away one meter.
		  ActionMoveToLocation(GenerateNewLocationFromLocation(GetLocation(OBJECT_SELF), 1.0f, GetFacing(OBJECT_SELF) + 180.0f, GetFacing(OBJECT_SELF)));
		  SendMessageToPC(oPC, "Talk to her like you would talk to another PC.  Short responses will work best."); 	
	    }
		else if (GetListenPatternNumber() && (GetIsPC(oPC) || GetIsDM(oPC)) && (GetLevelByClass(CLASS_TYPE_DRUID, oPC) || GetLevelByClass(CLASS_TYPE_RANGER, oPC)))
		{
		  // Triggered by someone saying something nearby. 
		  string sText = GetMatchedSubstring(0);
		  
		  _ProcessChat(sText);	
		}
		// NPC speech or non ranger/druid PC talking.  Ignore.
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
	  
	  if (GetIsPC(oPC) && !(GetLevelByClass(CLASS_TYPE_DRUID, oPC) || GetLevelByClass(CLASS_TYPE_RANGER, oPC)))
	  {
        SpeakString("*On seeing you, the nymph flees*");
	    _Flee();
	  }
	  else if (GetIsPC(oPC) && !GetLocalInt(oSelf, "IN_DIALOG"))
	  {
	    SetFacingPoint(GetPosition(oPC));
        
        // Move closer and open conversation.
        AssignCommand(oSelf, ActionMoveToLocation(GetLocation(oPC)));
        DelayCommand(2.0f, ClearAllActions());		

	    DelayCommand(5.0f, SpeakString("Hello, stranger.  Do you like riddles?  If so, try and answer this one."));
        DelayCommand(7.0f, _Riddle());		
		
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
