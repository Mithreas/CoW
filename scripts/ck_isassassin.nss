int StartingConditional()
{
  int nMinLevels = GetLocalInt(OBJECT_SELF, "MIN_ASSASSIN_LEVELS");

  if(!nMinLevels) nMinLevels = 3;

  return (GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= nMinLevels);
}
