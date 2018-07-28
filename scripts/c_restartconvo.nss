void main()
{
  object oCraftStation = OBJECT_SELF;
  AssignCommand(GetPCSpeaker(), ActionStartConversation(oCraftStation, "", TRUE, FALSE));
}
