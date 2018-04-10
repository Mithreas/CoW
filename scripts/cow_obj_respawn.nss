#include "cow_createobject"
void main()
{
  string sResRef = GetResRef(OBJECT_SELF);
  location lLoc = GetLocation(OBJECT_SELF);
  DelayCommand(300.0, CreateObjectReturnsVoid(OBJECT_TYPE_PLACEABLE, sResRef, lLoc));
}
