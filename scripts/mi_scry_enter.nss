#include "inc_customspells"
void main()
{
  object oPC = GetEnteringObject();
  SendMessageToPC(oPC, "You are close enough that you can make out shapes in the glass of the ball.");
  SetScryOverride(oPC, TRUE);
}
