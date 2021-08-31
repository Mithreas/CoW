// Disables all encounters in an area.
// Used to make things quiet for a return journey. 
// Note: encounters that are set to respawn should start their timer when they are disabled.
// Note2: if an encounter is still resetting, this method will have no effect.
void main()
{
  object oEncounter = GetFirstObjectInArea(GetArea(OBJECT_SELF));
  
  while (GetIsObjectValid(oEncounter))
  {
    if (GetObjectType(oEncounter) == OBJECT_TYPE_ENCOUNTER)
	{
	  SetEncounterActive(FALSE, oEncounter);
	}
  }

}