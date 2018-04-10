/*
  obj_setname
  Allows DMs to change the names of NPCs, placeables and items.
*/
void main()
{
  object oTarget = GetSpellTargetObject();
  object oItem   = GetSpellCastItem();
  object oDM     = GetItemPossessor(oItem);

  if (!GetIsObjectValid(oTarget))
  {
    oTarget = GetArea(oDM);

    SendMessageToPC(oDM, "No target specified, fallback to use this Area (" + GetName(oTarget) + ") as Target instead.");
  }

  // Set up variables for the chat code (gs_chat) to catch.
  SetLocalInt(oDM, "MI_NAMING", TRUE);
  SetLocalObject(oDM, "MI_NAME_TARGET", oTarget);

  SendMessageToPC(oDM, "<c þ >NEW AND IMPROVED. Speak the name you want in any "+
   "channel. You do not need to become visible, and what you say won't be " +
   "visible to any players.\n" +
   "Sometimes you have to change area before you see the updated name. To " +
   "work around this for creatures, limbo the creature after changing its name, "+
   "then call it back.");
}
