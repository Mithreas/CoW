// Assigns the PC to the faction stored in this object's MI_FACTION variable.
// See mi_repcomm for a list of available factions.
#include "mi_repcomm"
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
