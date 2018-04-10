void main()
{
  AssignCommand(OBJECT_SELF, SummonAnimalCompanion());

  // Execute the standard onspawn script.
  ExecuteScript("x2_def_spawn", OBJECT_SELF);
}
