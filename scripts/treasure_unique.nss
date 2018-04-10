#include "x0_i0_treasure"
void main()
{
  int nOpened = GetLocalInt(OBJECT_SELF, "emptied");
  if (nOpened)
  {
    // Do nothing.
  }
  else
  {
    EmptyChest();
    CTG_CreateTreasure(TREASURE_TYPE_UNIQUE, GetLastOpener(), OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "emptied", 1);
    DelayCommand(300.0, DeleteLocalInt(OBJECT_SELF, "emptied"));
  }
}
