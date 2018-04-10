/*
  obj_setname
  Allows DMs to read the description of NPCs, placeables and items and put it in a variable for later use
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

  // Set up variables for the chat code (gs_chat) to catch.
  SetLocalString(oDM, "GVD_DM_DESCRIBE_TEXT", GetDescription(oTarget));

  SendMessageToPC(oDM, "<c þ >You've read the description of the targetted item, you can now use the WriteDescription widget to copy it to another object");
}
