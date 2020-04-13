#include "inc_pc"
void main()
{
  object oExiting = GetExitingObject();
  gsPCSaveMap(oExiting, OBJECT_SELF);
}
