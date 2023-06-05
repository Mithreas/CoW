void main()
{
	// Retired.
  object oPC = GetPCSpeaker();
  AssignCommand(oPC, ClearAllActions());

  DeleteLocalInt(OBJECT_SELF, "MI_ACTIVE");
}
