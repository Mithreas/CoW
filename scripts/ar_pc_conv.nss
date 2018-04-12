#include "inc_pc"
void main()
{
  // Unfortunately, this event doesn't fire reliably.
  object oSpeaker = GetLastSpeaker();

  if (GetIsPC(oSpeaker) && oSpeaker != OBJECT_SELF)
  {
     // Moved to chat code.
  }
  else if (GetListenPatternNumber() != 100)
  {
    // This wasn't triggered by an NPC saying something, so start the conv
    BeginConversation();
  }
  else
  {
    // This was triggered by an NPC saying something in the vicinity. Ignore.
  }
}
