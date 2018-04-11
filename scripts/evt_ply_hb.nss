#include "inc_bonuses"
void main()
{

  RemoveParryBonus(OBJECT_SELF); //always remove it.
  _AddParryBonus(OBJECT_SELF); //it's already delayed.. hopefully we don't have to delay it again.
}
