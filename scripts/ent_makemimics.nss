// Put on a trigger. When entered, all treasure drops in the area will be
// given a random % chance of becoming mimics.  See gs_pl_inventory.
void main()
{
  if (!GetIsPC(GetEnteringObject())) return;

  object oArea = GetArea(OBJECT_SELF);
  object oChest = GetFirstObjectInArea(oArea);
  
  while (GetIsObjectValid(oChest))
  {
    if (GetStringLeft(GetTag(oChest), 7) == "GS_TREA")
	{
	  SetLocalInt(oChest, "AR_MIMIC", d20());
	}
	
	oChest = GetNextObjectInArea();
  }
}