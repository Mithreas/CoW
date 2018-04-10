void main()
{
  object oBasin = OBJECT_SELF;
  AssignCommand(GetPCSpeaker(), ActionStartConversation(oBasin, "gs_ip_add", TRUE, FALSE));
}
