void main()
{
  SetSubRace(GetPCSpeaker(), "House Renerrin");
  CreateItemOnObject("voiceoutfit", GetPCSpeaker());
  CreateItemOnObject("key_renerrin", GetPCSpeaker());
  CreateItemOnObject("renerrin_dye_1", GetPCSpeaker());
  CreateItemOnObject("renerrin_dye_2", GetPCSpeaker());
  CreateItemOnObject("renerrin_dye_3", GetPCSpeaker());
  GiveGoldToCreature(GetPCSpeaker(), 1000);

  ExecuteScript("goto_conv", OBJECT_SELF);
}
