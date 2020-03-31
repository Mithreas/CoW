#include "inc_pc"
int StartingConditional()
{
  return (GetLocalInt(gsPCGetCreatureHide(GetPCSpeaker()), "MALIA_SECRET"));
}