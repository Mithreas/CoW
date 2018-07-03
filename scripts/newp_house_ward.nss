void main()
{
  SetSubRace(GetPCSpeaker(), "Wardens");
  CreateItemOnObject("nw_cloth001", GetPCSpeaker());
  CreateItemOnObject("key_warden", GetPCSpeaker());
  GiveGoldToCreature(GetPCSpeaker(), 1000);
  
  ExecuteScript("goto_conv", OBJECT_SELF);
}
