#include "cow_checkclasses"
void main()
{
  object oPC = GetPCLevellingUp();

  if (HasInvalidClasses(oPC))
  {
    CheckClassesAndCorrect(oPC);
  }
}
