void main()
{
  object oPC = GetLastPerceived();
  int nSpoken = GetLocalInt(OBJECT_SELF, "Spoken");
  if (GetLastPerceptionSeen() && GetIsPC(oPC) && !nSpoken)
  {
    SpeakString("Hey! How did you get in here?!");
    SetLocalInt(OBJECT_SELF, "Spoken", 1);
  }

  // Play the standard onpercep.
  ExecuteScript("x2_def_percept", OBJECT_SELF);
}
