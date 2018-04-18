void main()
{
  SetSubRace(GetPCSpeaker(), "");
  GiveGoldToCreature(GetPCSpeaker(), 150);

  ExecuteScript("goto_conv", OBJECT_SELF);
}
