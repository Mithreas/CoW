/*
  Name: mi_autoconv
  Author: Mithreas
  Date: 28 Sep O5
  Version: 1.0

  Variable list and types.
  speech1        str
  speech2        str
  speech3        str
  ...
  reply1         str
  reply2         str
  reply3         str
  ...
  talks_to       str (tag)
  always_talks   1/0 (yes/no)

*/
void main()
{
  /*
    Everything from here to the comment at the end should be pasted into the
    module's default OnPerception script, e.g. x2_def_percept, near the end.
  */

  //----------------------------------------------------------------------------
  // Get variables that determine whether we say anything.
  //----------------------------------------------------------------------------
  string sSays     = GetLocalString(OBJECT_SELF, "speech1");
  int nAlwaysTalks = GetLocalInt(OBJECT_SELF, "always_talks");
  int nJustTalked  = GetLocalInt(OBJECT_SELF, "just_talked");
  object oSeen     = GetLastPerceived();

  //----------------------------------------------------------------------------
  // Exit if we have nothing to say, have just said something, or if we decide
  // not to say anything this time. Of course, if this isn't a PC, don't say
  // anything :)
  //----------------------------------------------------------------------------
  if ((sSays == "") || nJustTalked || !GetIsPC(oSeen)) return;
  if (!nAlwaysTalks && (d4() < 2)) return;

  //----------------------------------------------------------------------------
  // Note that we've spoken, as we will do now. Don't say anything else for a
  // minute.
  //----------------------------------------------------------------------------
  SetLocalInt(OBJECT_SELF, "just_talked", 1);
  DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "just_talked"));

  //----------------------------------------------------------------------------
  // Set up the other person in the conversation, if there is one.
  //----------------------------------------------------------------------------
  string sTalksTo = GetLocalString(OBJECT_SELF, "talks_to");
  int nTalksToSomeone = (sTalksTo != "");
  object oTalksTo = OBJECT_INVALID;

  if (nTalksToSomeone)
  {
    oTalksTo = GetObjectByTag(sTalksTo);
  }

  //----------------------------------------------------------------------------
  // Main loop, that sets up the conversation.
  //----------------------------------------------------------------------------
  int ii = 1;
  float nDelay = 0.01;

  while (sSays != "")
  {
    DelayCommand(nDelay, AssignCommand(OBJECT_SELF, ActionSpeakString(sSays)));
    nDelay += 7.0;

    if (nTalksToSomeone)
    {
      sSays = GetLocalString(oTalksTo, "reply" + IntToString(ii));

      if (sSays != "")
      {
        DelayCommand(nDelay, AssignCommand(oTalksTo, ActionSpeakString(sSays)));
      }

      nDelay += 7.0;
    }

    sSays = GetLocalString(OBJECT_SELF, "speech" + IntToString(ii + 1));
    ii++;
  }

  /*
    Everything from the first comment to here should be pasted into the module's
    default OnPerception script, e.g. x2_def_percept.
  */
}
