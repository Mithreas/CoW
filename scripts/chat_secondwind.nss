#include "inc_chatutils"
#include "inc_examine"
#include "inc_state"
#include "inc_timelock"

const string HELP = "Second Wind is a fighter ability.  It restores 10hp per class level, at the cost of an equivalent amount of Stamina.  The Stamina cost is affected by the normal Fighter reduction.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  object oTarget  = chatGetTarget(oSpeaker);
  string sParams  = chatGetParams(oSpeaker);
  int    nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER);

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-secondwind", HELP);
  }
  else if (nFighter)
  {
    if(GetIsTimelocked(OBJECT_SELF, "Second Wind"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Second Wind");
        chatVerifyCommand(OBJECT_SELF);
        return;
    }
	
    int nHP = 10 * nFighter;
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectHeal(nHP), EffectVisualEffect(VFX_IMP_HEAD_HEAL)), oSpeaker);
	gsSTDoCasterDamage(oSpeaker, nHP);
    SetTimelock(OBJECT_SELF, 15 * 60, "Second Wind", 600, 60);
  }
  else
  {
    SendMessageToPC(oSpeaker, "Only Fighters may use Second Wind.");
  } 
  
  chatVerifyCommand(OBJECT_SELF);
}