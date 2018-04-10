void main()
{
  object oPC = GetClickingObject();
  object oDoor = OBJECT_SELF;
  AssignCommand(oPC, ActionStartConversation(oDoor, "", TRUE, FALSE));
}
