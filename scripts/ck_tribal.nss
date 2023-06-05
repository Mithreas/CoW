#include "inc_pc"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  
  return GetLocalInt(gsPCGetCreatureHide(oPC), "TRIBESMAN");
}