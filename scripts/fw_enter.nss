/* 
  See inc_feywilds for details.
*/
#include "inc_feywilds"

void main()
{
  Trace(FEYWILDS, "Current transition target: " + GetTag(GetTransitionTarget(OBJECT_SELF)));

  if (!GetIsObjectValid(GetTransitionTarget(OBJECT_SELF)))
  {
    FW_GeneratePath(OBJECT_SELF);
  }
  
  ExecuteScript("nw_g0_transition", OBJECT_SELF); 
}