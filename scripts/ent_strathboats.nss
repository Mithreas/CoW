void main()
{
  object oPC = GetClickingObject();
  
  if (!GetIsPC(oPC)) return;
  
  if (!GetIsObjectValid(GetItemPossessedBy(oPC, "permission_strathvorn"))) return;
  
  ExecuteScript("nw_g0_transition", OBJECT_SELF);
}