void main()
{
  SetSubRace(GetPCSpeaker(), "House Drannis");
  CreateItemOnObject("galeoutfit", GetPCSpeaker());
  CreateItemOnObject("key_drannis", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_1", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_2", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_3", GetPCSpeaker());
  GiveGoldToCreature(GetPCSpeaker(), 1000);
  
  ExecuteScript("goto_conv", OBJECT_SELF);
}
