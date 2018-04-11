// Assigns the PC to the faction stored in this object's MI_FACTION variable.
// See inc_reputation for a list of available factions.
#include "inc_reputation"
void main()
{
  int nFaction = GetLocalInt(OBJECT_SELF, "MI_FACTION");

  if (!nFaction)
  {
    SpeakString("I am not set up correctly. Please report me!");
    return;
  }

  object oPC = GetLastUsedBy();
  if (!GetIsPC(oPC)) return;

  SetPCFaction(oPC, nFaction);
  SendMessageToPC(oPC, "You are now working for " + GetFactionName(nFaction));
}
