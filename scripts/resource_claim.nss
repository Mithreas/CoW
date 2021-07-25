/*
  Claims a resource for the using PC, if there's nobody from the owning faction
  present.
*/
#include "inc_resource"
void main()
{
  object oPC = GetLastUsedBy();
  object oArea = GetArea(OBJECT_SELF);
  int nOwner = GetPersistentInt(OBJECT_INVALID, GetTag(oArea)+OWNER);
  
  if (!GetIsPC(oPC)) return;
  Trace(RESOURCE, "Checking claim for area "+GetName(oArea)+" for PC "+GetName(oPC));

  if (CheckNoOwnersPresent(oArea))
  {
    ClaimResource(oPC, oArea);
    Trace(RESOURCE, "PC " + GetName(oPC) + " claimed area " + GetName(oArea));

    // Give all members of the PC's party a rep point with their faction.
    // 4th July 06 - removed. Replaced with rep bonus when buying mercs.
    // GiveRepPoints(oPC, 1, GetFactionFromName(GetSubRace(oPC)), TRUE);

    SendMessageToPC(oPC, "You claimed this area for your faction.");
	SetName(OBJECT_SELF, "Claimed by " + GetFactionName(GetPCFaction(oPC)));
  }
  else if (nOwner == miBAGetBackground(oPC))
  {
    SendMessageToPC(oPC, "Your faction already controls this area.");
	SetName(OBJECT_SELF, "Claimed by " + GetFactionName(GetPCFaction(oPC)));
  }
  else
  {
    string sOwner = GetFactionName(nOwner);
    SendMessageToPC(oPC, "A member of "+sOwner+" is still present. "+
          "You can't claim this area while they're still here.");
  }
}
