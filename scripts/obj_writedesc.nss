/*
  obj_setname
  Allows DMs to write the description of NPCs, placeables and items with the description which was retrieved using the ReadDescription widget first
*/
void main()
{
  object oTarget = GetSpellTargetObject();
  object oItem   = GetSpellCastItem();
  object oDM     = GetItemPossessor(oItem);

  if (!GetIsObjectValid(oTarget))
  {
    SendMessageToPC(oDM, "<cþ  >You must target an object (creature, placeable "+
     "or item) with this widget.");
    return;
  }

  // get variable
  string sDesc = GetLocalString(oDM, "GVD_DM_DESCRIBE_TEXT");

  if (sDesc != "") {
    SetDescription(oTarget, sDesc);
    SendMessageToPC(oDM, "<c þ >Description of the target is changed succesfully");
  } else {
    SendMessageToPC(oDM, "<c þ >You must first use the ReadDescription widget on an object to store a description into memory");
  }

}
