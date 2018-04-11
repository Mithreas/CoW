/*
  obj_setname
  Allows DMs to change the description of NPCs, placeables and items.
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
  SetLocalInt(oDM, "GVD_DM_DESCRIBE", TRUE);
  SetLocalObject(oDM, "GVD_DM_DESCRIBE_TARGET", oTarget);

  SendMessageToPC(oDM, "<c þ >NEW AND IMPROVED. Speak the description you want in any "+
   "channel. You do not need to become visible, and what you say won't be " +
   "visible to any players.\n" +
   "Sometimes you have to change area before you see the updated description. To " +
   "work around this for creatures, limbo the creature after changing its description, "+
   "then call it back.");
}
