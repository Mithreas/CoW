#include "__server_config"
#include "inc_chatutils"
#include "inc_flag"
#include "inc_customspells"
#include "inc_zdlg"
#include "inc_spell"
#include "inc_worship"
#include "inc_examine"
#include "inc_relations"
#include "inc_timelock"

const string HELP = "<cþôh>-yoink </c><cþ£ >[Text]</c>\nIf a character has Epic Spell Focus: Conjuration, they get a bonus spell once per day that allows them to summon another PC to their location (the summoned PC gets a chance to decline!). The character whose name starts with <cþ£ >[Text]</c> will be summoned, or alternatively you can send this command as a Tell to the target. Using Yoink will consume Piety/Spell Components only if the summoning is successful. If unsuccessful, there is a one-minute cooldown before you can try again.";

void main()
{
  // Command not valid
  if (!ALLOW_YOINKING) return;

  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  object oTarget = chatGetTarget(oSpeaker);

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-yoink", HELP);
  }
  else
  {
    if (!GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oSpeaker))
    {
      SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Conjuration to yoink.");
    }
    else if (sParams == "" && !GetIsObjectValid(oTarget))
    {
      SendMessageToPC(oSpeaker, "<cþ£ >You must specify a name. You only "+
       "need to type the first few letters, e.g. '-yoink Joh' will match "+
       "a character with the name 'John Doe'. You may also send '-yoink' as a " +
       "tell to yoink that person.");
    }
    else
    {
      if (!GetIsObjectValid(oTarget))
      {
        object oPC  = GetFirstPC();
        int nLength = GetStringLength(sParams);
        while (GetIsObjectValid(oPC))
        {
          if (GetStringLeft(GetName(oPC), nLength) == sParams)
          {
            oTarget = oPC;
          }
          oPC = GetNextPC();
        }
      }

      if (!GetIsObjectValid(oTarget))
      {
        SendMessageToPC(oSpeaker, "<cþ£ >Could not find character: " + sParams);
      }	
	  else if (!miREHasRelationship(oSpeaker, oTarget))
	  {
        SendMessageToPC(oSpeaker, "<cþ£ >You may only summon someone you have previously interacted with.");
	  }
      else
      {
        // Allow one SUCCESFUL Yoink per rest
        if (miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_YOINK))
        {
          miDoCastingAnimation(oSpeaker);

          if ((GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) >= 17 ||
               GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) >= 17)
               && gsWOGetPiety(oSpeaker) < 5.0f)
          {
            string sDeity = GetDeity(oSpeaker);
                FloatingTextStringOnCreature(
                    "You are not pious enough for " + sDeity + " to grant you that spell now.",
                    OBJECT_SELF,
                    FALSE);
          }
          else if (GetLocalInt(oSpeaker, "YOINKING"))
          {
            TimelockErrorMessage(OBJECT_SELF, "Yoink");
          }
          else if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oTarget) ||
              gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker))
          {
            FloatingTextStringOnCreature("A force is blocking the use of this ability.", oSpeaker, FALSE);
          }
          else if (!GetIsInCombat(oSpeaker) && !GetIsInCombat(oTarget))
          {
            SetLocalObject(oTarget, "MI_YOINKER", oSpeaker);
            SetLocalInt(oSpeaker, "YOINKING", TRUE);
            SetLocalObject(oSpeaker, "YOINK_TARGET", oTarget);
            
            SetTimelock(oSpeaker, 60, "Yoink Retry");
            AddEventTimelockExpired(oSpeaker, "Yoink Retry", "exe_yoinkrst");
            
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, ActionDoCommand(StartDlg(oTarget, oTarget, "zdlg_yoink", TRUE, FALSE)));
          }
          else if (GetIsInCombat(oTarget))
          {
            FloatingTextStringOnCreature(GetName(oTarget) + " is currently distracted.", oSpeaker, FALSE);
          }
          else
          {
            FloatingTextStringOnCreature("You cannot use this ability in combat.", oSpeaker, FALSE);
          }
        }
        else
        {
          SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability again until you next rest.");
        }
      }
    }
  }

  chatVerifyCommand(oSpeaker);
}
