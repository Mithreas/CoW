// mi_dorandomtraps
//
// This functionality pulled out of gs_a_enter because areas can't tell whether
// doors are trappable or not - the effect is that transitions like cave
// entrances get trapped (oops).
//
// Create traps on 20% of the doors in this area.  Set the difficulty of the
// traps by looking at the challenge rating of the first creature to spawn here.
//
// Aug 2015: Do the same for chests and gold piles. 
#include "gs_inc_encounter"
#include "mi_log"

const string TRAPS = "TRAPS"; // for logging
void main()
{
  object oDoor = GetFirstObjectInArea();
  object oPC   = OBJECT_SELF;
  int nRating = FloatToInt(gsENGetCreatureRating(1, GetArea(oPC)));

  Trace(TRAPS, "Random trap script called for area "+ GetName(GetArea(oPC)) +
   " by PC " + GetName(oPC) + ", rating: " + IntToString(nRating));

  while (GetIsObjectValid(oDoor))
  {
    if (GetObjectType(oDoor) == OBJECT_TYPE_DOOR || 
	    (GetObjectType(oDoor) == OBJECT_TYPE_PLACEABLE && GetStringLeft(GetTag(oDoor), 11) == "GS_TREASURE") ||
	    (GetObjectType(oDoor) == OBJECT_TYPE_PLACEABLE && GetStringLeft(GetTag(oDoor), 8) == "GS_ARMOR") ||
	    (GetObjectType(oDoor) == OBJECT_TYPE_PLACEABLE && GetStringLeft(GetTag(oDoor), 9) == "GS_WEAPON") ||
	    (GetObjectType(oDoor) == OBJECT_TYPE_PLACEABLE && GetStringLeft(GetTag(oDoor), 7) == "GS_GOLD"))		
    {
      // Remove any existing trap from the door.
      SetTrapDisabled(oDoor);
	  
	  // Set the chance based on the door type.
	  int nChance = GetObjectType(oDoor) == OBJECT_TYPE_DOOR ? 8 : 5 ;

      if (d10() > nChance) // 20% for doors, 50% for chests
      {
        // If this door is locked, unlock it for the test below.
        int bLocked = GetLocked(oDoor);
        SetLocked(oDoor, FALSE);

        if (GetObjectType(oDoor) == OBJECT_TYPE_PLACEABLE || 
		    GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN))
        {
          // Trap the door.
          // There are 10 types of trap, and 4 difficulties of each. Traps 0, 4,
          // 8, 12 etc are minor, 1,5 etc are average, 2,6 etc are strong and
          // 3, 7 etc are deadly.
          int nTrapType = d10();
          int nDifficulty = nRating / 6;
          Trace(TRAPS, "Difficulty: " + IntToString(nDifficulty));
          if (nDifficulty > 3) nDifficulty = 3; // epic creatures.
          int nTrapNumber = (4 * (nTrapType - 1)) + nDifficulty; // 0-40
          Trace(TRAPS, "Trap type: " + IntToString(nTrapNumber));
          CreateTrapOnObject(nTrapNumber,
                             oDoor,
                             STANDARD_FACTION_HOSTILE);

          // Set the detect DC of the trap based on PC level.
          SetTrapDisarmable(oDoor, TRUE); // Just in case
          SetTrapDetectable(oDoor, TRUE); // Ditto
          SetTrapDetectDC(oDoor, 15 + Random(nRating + 1)); // 16+ detect and disarm DC
          SetTrapDisarmDC(oDoor, 15 + Random(nRating + 1));

          // Make the trap one shot...
          SetTrapOneShot(oDoor, TRUE);

          // ...and recoverable.
          SetTrapRecoverable(oDoor, TRUE);
        }

        if (bLocked) SetLocked(oDoor, TRUE);
      }
      else
      {
        // Do nothing, this door will remain untrapped.
      }
    }
    oDoor = GetNextObjectInArea();
  }
}
