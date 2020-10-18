// Takes 1 point of faction reputation from the PC, from their main faction.
#include "inc_reputation"

void main()
{
  TakeRepPoint(GetPCSpeaker(), GetPCFaction(GetPCSpeaker()));
}