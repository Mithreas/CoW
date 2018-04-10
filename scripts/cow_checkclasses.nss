/*
  cow_checkclasses
  Checks that the PC has a valid build for CoW.

  * At least 5 levels of each class before level 20.
  * No druids
  * No wizards
  * No sorcerors
  * No Arcane Archers
  * No Blackguards
  * No Pale Masters
  * No Shifters
  * No Shadowdancers
  * No Red Dragon Disciples

  (Paladin replaced by Expert. Bard replaced by Knight Marshal).

  And no non-humans (for now at least).

*/
#include "aps_include"
int HasInvalidClasses(object oPC)
{
  int nInvalid = 0;

  int nFirstClassLevel  = GetLevelByPosition(1, oPC);
  int nSecondClassLevel = GetLevelByPosition(2, oPC);
  int nThirdClassLevel  = GetLevelByPosition(3, oPC);

  int nTotalLevel = nFirstClassLevel + nSecondClassLevel + nThirdClassLevel;

  // Check at least 5 levels of each class will be possible by level 20.
  // Dual class chars.
  if ((nFirstClassLevel > 15 && nSecondClassLevel > 0) || nSecondClassLevel > 15)
  {
    // Cannot be level 16 in one class and have a second class.
    nInvalid = 1;
  }
  // Triple-classed chars.
  else if (((nFirstClassLevel + nSecondClassLevel) > 15 && nThirdClassLevel > 0) ||
           ((nFirstClassLevel + nThirdClassLevel) > 15 && nSecondClassLevel > 0) ||
           ((nSecondClassLevel + nThirdClassLevel) > 15))
  {
    // Cannot have 16 levels between any two classes and have levels in the
    // third.
    nInvalid = 1;
  }
  // Banned classes.
  else if ((GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) > 0) ||
           (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC) > 0))
  {
    nInvalid = 1;
  }
  // Level 4+ and not approved.
  else if ((nTotalLevel == 4) && !GetPersistentInt(oPC, "APPROVED"))
  {
    nInvalid = 1;
    SendMessageToPC(oPC, "You must have a bio approved before advancing further. "+
     "Post on the forums at http://asako.zapto.org/forum, and once your bio is " +
     "approved find a staffer IG to unlock you.");
  }

  return nInvalid;
}

// Levels down the PC to 1 under what they need for their current level, and
// returns the XP lost.
int LevelDownPC (object oPC)
{
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) +
                           GetLevelByPosition(3, oPC);
  // y = x^2 - x/2 = xp needed for your level/1000. So x=1, y=0. x=2, y=1.
  // x=3, y=3.
  int nXPNeededForCurrentLevel = 1000 * ((nLevel * nLevel)/2 - nLevel/2);

  int nCurrentXP = GetXP(oPC);

  SetXP(oPC, nXPNeededForCurrentLevel - 1);
  return (nCurrentXP - nXPNeededForCurrentLevel + 1);
}


void CheckClassesAndCorrect(object oPC)
{
  location lCurrentLocation = GetLocation(oPC);
  AssignCommand(oPC,
                JumpToLocation(GetLocation(GetObjectByTag("bad_level_up"))));

  int nXPLost = LevelDownPC(oPC);
  SetLocalInt(oPC, "XP_LOST", nXPLost);
  SetLocalLocation(oPC, "OLD_LOCATION", lCurrentLocation);
}

int HasInvalidRaces(object oPC)
{
  int nRacialType = GetRacialType(oPC);

  return (nRacialType != RACIAL_TYPE_HUMAN);

}
