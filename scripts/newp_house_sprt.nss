void main()
{
  SetSubRace(GetPCSpeaker(), "House Erenia");
  CreateItemOnObject("spiritoutfit", GetPCSpeaker());
  CreateItemOnObject("key_erenia", GetPCSpeaker());
  CreateItemOnObject("erenia_dye_1", GetPCSpeaker());
  CreateItemOnObject("erenia_dye_2", GetPCSpeaker());
  CreateItemOnObject("erenia_dye_3", GetPCSpeaker());

  ExecuteScript("goto_conv", OBJECT_SELF);
}
