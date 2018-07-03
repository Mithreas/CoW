int StartingConditional()
{
  object oPC = GetPCSpeaker();
  
  return (GetRacialType(oPC) == RACIAL_TYPE_HUMAN);
}