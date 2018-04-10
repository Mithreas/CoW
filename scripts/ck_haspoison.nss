int StartingConditional()
{
  // check if the PC is carrying any digestable poison (tag starts with mi_poison)
  object oSpeaker = GetPCSpeaker();
  object oItem    = GetFirstItemInInventory(oSpeaker);

  while (GetIsObjectValid(oItem)) {
    if (GetStringLeft(GetTag(oItem),9) == "mi_poison") {
      return TRUE;
    }

    oItem   = GetNextItemInInventory(oSpeaker);
  }

  return FALSE;

}
