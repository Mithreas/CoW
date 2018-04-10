void main()
{
  object oCreature = GetEnteringObject();

  if (GetIsReactionTypeHostile(GetFirstPC(), oCreature))
  {
    AssignCommand(oCreature, ClearAllActions());
  }
}
