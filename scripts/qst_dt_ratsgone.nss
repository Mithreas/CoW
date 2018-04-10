const string RAT_TAG = "NW_RAT001";

int StartingConditional()
{
  int nCount = 1;
  object oRat = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount);

  while (GetIsObjectValid(oRat))
  {
    if (GetTag(oRat) == RAT_TAG)
    {
      return 0;
    }
    nCount++;
    oRat = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCount);
  }

  return 1;
}
