#include "fb_inc_chatutils"
#include "mi_inc_spells"
#include "mi_inc_pop"
#include "inc_examine"

const string HELP = "<cþôh>-balance</c><cþ£ ></c>\nAllows druids to cast a ritual that directly improves the balance of an area that is overrun.  The size of the effect scales with Druid levels.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  
  chatVerifyCommand(oSpeaker);

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-balance", HELP);
	return;
  }
  
  int nLevel = GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker);
  
  if (!nLevel)
  {
	  SendMessageToPC(oSpeaker, "You must be a druid to directly affect the Balance.");
	  return;
  }
  
  if (miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_BALANCE))
  {
    // -----------------------------------------------------------
    // Mark the spell as cast now - even if it does nothing.
    // Druids will need to use rangers to tell them where to work.
    // -----------------------------------------------------------	
 	miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_BALANCE);
    miDoCastingAnimation(oSpeaker);
    string sPop = miPOGetActivePopulation(GetArea(oSpeaker));
	
	if (sPop == "")
	{
	  SendMessageToPC(oSpeaker, "The area is already in balance!");
	  return;
	}
	else
	{
	  int nPopulation = miPOGetPopulation(sPop);
	  int nRate = miPOGetPopulationRate(sPop);
	  
	  if (nPopulation < nRate)
	  {
	    SendMessageToPC(oSpeaker, "The area is already in balance!");
		return;
	  }
	  else
	  {
	    miPOAdjustPopulation(sPop, -nLevel);
	    SendMessageToPC(oSpeaker, "You have helped, a little.");
	    return;
	  }
	}	
  }
  else
  {
    SendMessageToPC(oSpeaker, "You must rest before using this spell again.");
  }
}