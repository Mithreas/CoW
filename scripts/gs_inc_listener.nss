#include "inc_chatutils"

// Depreciated: Use chatGetLastMessage instead
string gsLIGetLastMessage(object oPC = OBJECT_SELF);
// Depreciated: Use chatClearLastMessage instead
void gsLIClearLastMessage(object oPC = OBJECT_SELF);

string gsLIGetLastMessage(object oPC = OBJECT_SELF)
{
  return chatGetLastMessage(oPC);
}
//----------------------------------------------------------------
void gsLIClearLastMessage(object oPC = OBJECT_SELF)
{
  chatClearLastMessage(oPC);
}
