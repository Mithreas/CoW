#include "inc_spells"
void main()
{
  object oEntering = GetEnteringObject();
  
  if (GetAssociateType(oEntering) == ASSOCIATE_TYPE_SUMMONED)
  {
    UnsummonCreature(oEntering);
  }
}