//void main() {}
#include "inc_common"
#include "__server_config"

// Returns vVector limited by the dimensions of oArea.
vector miCBEnsureVectorWithinArea(vector vVector, object oArea);
vector miCBEnsureVectorWithinArea(vector vVector, object oArea)
{
   float nAreaMaxX = IntToFloat(GetAreaSize(AREA_WIDTH, oArea) * 10);
   float nAreaMaxY = IntToFloat(GetAreaSize(AREA_HEIGHT, oArea) * 10);

   if (vVector.x < 0.0) vVector.x = 0.0;
   if (vVector.y < 0.0) vVector.y = 0.0;
   if (vVector.x > nAreaMaxX) vVector.x = nAreaMaxX;
   if (vVector.y > nAreaMaxY) vVector.y = nAreaMaxY;

   return vVector;

}

// Returns a location just in front of the PC - where they may climb to.
location miCBGetClimbTargetLocation(object oPC);
location miCBGetClimbTargetLocation(object oPC)
{
  location lLoc = GetLocation (oPC);
  object oArea = GetArea(oPC);

  // Get position of PC
  vector vPos   = GetPosition(oPC);
  float fX = vPos.x;
  float fY = vPos.y;
  float fZ = vPos.z;

  // Get their facing and convert to a vector
  float fFacing = GetFacing(oPC);
  vector vForwards = AngleToVector(fFacing);

  // Construct the location that's in front of the PC.
  vector vNewPos = Vector(fX + 2*vForwards.x, fY + 2*vForwards.y, fZ);
  //location lNewLoc = GetAheadLocation(oSpeaker);
  // check that location is inside the area.
  vector vTarget = miCBEnsureVectorWithinArea(vNewPos,
                                              oArea);

  location lNewLoc = Location(oArea, vNewPos, fFacing);
  return lNewLoc;
}

// Returns the PC's current armour check penalty.
int miCBGetArmorCheckPenalty(object oPC);
int miCBGetArmorCheckPenalty(object oPC)
{
  object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
  object oShield = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int nPenalty = 0;

  // Get AC penalty for item.
  if (GetIsObjectValid(oArmor))
  {
    switch (gsCMGetItemBaseAC(oArmor))
    {
      case 1:
        break;
      case 2:
        break;
      case 3:
        nPenalty -= 1;
        break;
      case 4:
        nPenalty -= 2;
        break;
      case 5:
        nPenalty -= 5;
        break;
      case 6:
      case 7:
        nPenalty -= 7;
        break;
      case 8:
        nPenalty -= 8;
        break;
      default:
    }
  }

  if (GetIsObjectValid(oShield))
  {
    switch (GetBaseItemType(oShield))
    {
      case BASE_ITEM_SMALLSHIELD:
        nPenalty -= 1;
        break;
      case BASE_ITEM_LARGESHIELD:
        nPenalty -= 2;
        break;
      case BASE_ITEM_TOWERSHIELD:
        nPenalty -= 10;
        break;
      default:
        break;
    }
  }

  return nPenalty;
}

// Returns the positive climb modifier for this PC (from stats + levels).
int miCBGetClimbBonus(object oPC);
int miCBGetClimbBonus(object oPC)
{
  int nLevel = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) +
               GetLevelByClass(CLASS_TYPE_ROGUE, oPC) +
               GetLevelByClass(CLASS_TYPE_RANGER, oPC) +
               GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) +
               GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) +
               GetLevelByClass(CLASS_TYPE_HARPER, oPC) +
               GetLevelByClass(CLASS_TYPE_MONK, oPC) +
               GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);

  int nStatBonus = GetAbilityModifier(ABILITY_STRENGTH, oPC) +
                   GetAbilityModifier(ABILITY_DEXTERITY, oPC);

  return nLevel + nStatBonus;
}

// Returns TRUE if this PC can attempt climbing.
int miCBGetCanClimb(object oPC);
int miCBGetCanClimb(object oPC)
{
  if (!ALLOW_CLIMBING) return FALSE;
  else return (miCBGetClimbBonus(oPC) >= CLIMBING_DC - 20);
}
