void main()
{
  object oPC = GetPCSpeaker();
  AssignCommand(oPC, ClearAllActions());
  DeleteLocalInt(OBJECT_SELF, "MI_ACTIVE");
  DestroyObject(OBJECT_SELF);
}
