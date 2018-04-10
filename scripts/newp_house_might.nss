void main()
{
  SetSubRace(GetPCSpeaker(), "House Drannis");
  CreateItemOnObject("galeoutfit", GetPCSpeaker());
  CreateItemOnObject("key_drannis", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_1", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_2", GetPCSpeaker());
  CreateItemOnObject("drannis_dye_3", GetPCSpeaker());

  ExecuteScript("goto_conv", OBJECT_SELF);
}
