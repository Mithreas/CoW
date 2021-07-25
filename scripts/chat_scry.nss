#include "__server_config"
#include "inc_chatutils"
#include "inc_rename"
#include "inc_customspells"
#include "inc_spell"
#include "inc_timelock"
#include "inc_worship"
#include "inc_examine"
#include "inc_relations"

const string HELP1 = "<c��h>-scry </c><c�� >[Text]</c>\nUse this to scry on the character named <c�� >Text</c>. <c�� >Text</c> Need only be the first few letters of a character, so 'Joh' will work on 'John Doe'. You can also send -scry as a tell to someone to scry on that person.";
const string HELP2 = "\n\nIf you are scrying on a disguised individual, you may use their disguised name to target, without the (Disguised) tag, or their real name if you know it.";

void main()
{
  // Command not valid
  if (!ALLOW_SCRYING) return;

  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  object oTarget = chatGetTarget(oSpeaker);

  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-scry", HELP1 + HELP2);
  }
  else
  {
    if (!GetCanScry(oSpeaker))
    {
      SendMessageToPC(oSpeaker, "<c�  >You must have "+
       "Epic Spell Focus in Divination to be able to scry.");
    }
    else if (sParams == "" && !GetIsObjectValid(oTarget))
    {
      SendMessageToPC(oSpeaker, "<c�� >You must specify a name. You only "+
       "need to type the first few letters, e.g. '-scry Joh' will match "+
       "a character with the name 'John Doe'. You may also send '-scry' as a " +
       "tell to scry on that person.");
    }
    else
    {
      if (!GetIsObjectValid(oTarget))
      {
        object oPC     = GetFirstPC();
        int nLength    = GetStringLength(sParams);
        while (GetIsObjectValid(oPC))
        {
          // Search for real name and disguised name, preferring real name.
          if (GetStringLeft(GetName(oPC), nLength) == sParams ||
           (!GetIsObjectValid(oTarget) &&
           GetStringLeft(svGetPCNameOverride(oPC), nLength) == sParams))
          {
            oTarget = oPC;
          }
          oPC = GetNextPC();
        }
      }

      if (!GetIsObjectValid(oTarget))
      {
        SendMessageToPC(oSpeaker, "<c�� >Could not find character: " + sParams);
      }	  
	  else if (gsTIGetActualTimestamp() < GetLocalInt(oSpeaker, "SCRY_TIMEOUT_" + gsPCGetPlayerID(oTarget)))
	  {
	    SendMessageToPC(oSpeaker, "You cannot scry " + GetName(oTarget) + " again so soon.  Allow 15 minutes between scrying attempts."); 
	  }	
	  else if (!miREHasRelationship(oSpeaker, oTarget))
	  {
        SendMessageToPC(oSpeaker, "<c�� >You may only scry on someone you have previously interacted with.");
	  }
      else
      {	    
        if ((GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) >= 17 ||
             GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) >= 17)
             && !gsWOAdjustPiety(oSpeaker, -5.0f, FALSE))
        {
          string sDeity = GetDeity(oSpeaker);
                FloatingTextStringOnCreature(
                    "You are not pious enough for " + sDeity + " to grant you that spell now.",
                    OBJECT_SELF,
                    FALSE);
        }
        else 
		{
		  if (GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) < 17 &&
                 GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) < 17)
          {
             gsSTDoCasterDamage(oSpeaker, 5);
		  }
		  
          if (Scrying(oSpeaker, oTarget)) SetLocalInt(oSpeaker, "SCRY_TIMEOUT_" + gsPCGetPlayerID(oTarget), gsTIGetActualTimestamp() + 15 * 60);		  
        }
      }
    }
  }

  chatVerifyCommand(oSpeaker);
}
