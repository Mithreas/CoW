/* PORTAL Library by Gigaschatten */

//Edits By Space Pirate April 2011:
//Edited: gsPODropAllCorpses
//++Added LocalLocation Check (exiting players dont have a valid location)
//--Removed Corpse Target Check (now spawns a corpse object even if target is
//      not presently logged in.)

//void main() {}

#include "inc_pc"
#include "inc_text"
#include "inc_common"

//register oPortal
void gsPORegisterPortal(object oPortal);
//return portal by nIndex
object gsPOGetPortal(int nIndex);
//return first portal that is active for oPC at or after nIndex, return -1 if at end
int gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF);
//internally used
int _gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF, int nStep = 1);
//return portal that is active for oPC following nIndex, return -1 if at end
int gsPOGetNextActivePortal(int nIndex, object oPC = OBJECT_SELF);
//return portal that is active for oPC preceding nIndex, return -1 if at start
int gsPOGetPreviousActivePortal(int nIndex, object oPC = OBJECT_SELF);
//return name of oPortal
string gsPOGetPortalName(object oPortal);
//return number of portals
int gsPOGetPortalCount();
//activate oPortal for oPC
void gsPOActivatePortal(object oPortal, object oPC = OBJECT_SELF);
//return TRUE if oPortal is active for oPC
int gsPOGetIsPortalActive(object oPortal, object oPC = OBJECT_SELF);
// drops all corpses in a player's inventory and cancels any force following
// being done by nearby players.
void gsPODropAllCorpses(object oPC);

void gsPORegisterPortal(object oPortal)
{
    object oModule = GetModule();
    int nIndex     = gsPOGetPortalCount();

    SetLocalObject(oModule, "GS_PO_" + IntToString(nIndex), oPortal);
    SetLocalInt(oModule, "GS_PO_COUNT", nIndex + 1);
}
//----------------------------------------------------------------
object gsPOGetPortal(int nIndex)
{
    return GetLocalObject(GetModule(), "GS_PO_" + IntToString(nIndex));
}
//----------------------------------------------------------------
int gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex, oPC);
}
//----------------------------------------------------------------
int _gsPOGetFirstActivePortal(int nIndex, object oPC = OBJECT_SELF, int nStep = 1)
{
    object oPortal = OBJECT_INVALID;
    int nCount     = gsPOGetPortalCount();

    for (; nIndex >= 0 && nIndex < nCount; nIndex += nStep)
    {
        oPortal = gsPOGetPortal(nIndex);

        if (GetIsObjectValid(oPortal) &&
            oPortal != OBJECT_SELF &&
            gsPOGetIsPortalActive(oPortal, oPC))
        {
            return nIndex;
        }
    }

    return -1;
}
//----------------------------------------------------------------
int gsPOGetNextActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex + 1, oPC);
}
//----------------------------------------------------------------
int gsPOGetPreviousActivePortal(int nIndex, object oPC = OBJECT_SELF)
{
    return _gsPOGetFirstActivePortal(nIndex - 1, oPC, -1);
}
//----------------------------------------------------------------
string gsPOGetPortalName(object oPortal)
{
    return GetName(GetArea(oPortal));
}
//----------------------------------------------------------------
int gsPOGetPortalCount()
{
    return GetLocalInt(GetModule(), "GS_PO_COUNT");
}
//----------------------------------------------------------------
void gsPOActivatePortal(object oPortal, object oPC = OBJECT_SELF)
{
    string sTag      = GetTag(GetArea(oPortal));
    // Use legacy player ID for now, to avoid the need for migration.
    string sPlayerID = gsPCGetMigrationID(oPC);

    SetCampaignInt("GS_PO_" + sTag, sPlayerID, TRUE);
}
//----------------------------------------------------------------
int gsPOGetIsPortalActive(object oPortal, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return TRUE;

    string sTag      = GetTag(GetArea(oPortal));
    // Use legacy player ID for now, to avoid the need for migration.
    string sPlayerID = gsPCGetMigrationID(oPC);

    return GetCampaignInt("GS_PO_" + sTag, sPlayerID);
}
//----------------------------------------------------------------
const string GS_TEMPLATE_CORPSE_FEMALE = "gs_item016";
const string GS_TEMPLATE_CORPSE_MALE   = "gs_item017";
const string GS_TEMPLATE_CORPSE = "gs_placeable017";

void gsPODropAllCorpses(object oPC)
{
  object oCorpse = GetFirstItemInInventory(oPC);

  // Added By Space Pirate --[
  location lLoc  = GetLocation(oPC);

  if (!GetIsObjectValid(GetAreaFromLocation(lLoc)))
    lLoc = GetLocalLocation(oPC, "GS_LOCATION");

  //]--
  while (GetIsObjectValid(oCorpse))
  {
    if ((GetResRef(oCorpse) == GS_TEMPLATE_CORPSE_FEMALE) ||
        (GetResRef(oCorpse) == GS_TEMPLATE_CORPSE_MALE))
    {
      string sTarget = GetLocalString(oCorpse, "GS_TARGET");
      object oTarget = gsPCGetPlayerByID(sTarget);

// Removed Lines By Space Pirate
//-      if (GetIsObjectValid(oTarget))
//-      {
        object oCorpse2 = CreateObject(OBJECT_TYPE_PLACEABLE,
                                       GS_TEMPLATE_CORPSE,
                                       lLoc);

        if (GetIsObjectValid(oCorpse2))
        {
          FloatingTextStringOnCreature(GS_T_16777483, oTarget, FALSE);
          SetName(oCorpse2, GetName(oCorpse));

          SetLocalString(oCorpse2, "GS_TARGET", sTarget);
          SetLocalObject(oTarget, "GS_CORPSE", oCorpse2);
          SetLocalInt(oCorpse2, "GS_STATIC", TRUE);
          SetLocalInt(oCorpse2, "GS_GENDER", GetLocalInt(oCorpse, "GS_GENDER"));
          SetLocalInt(oCorpse2, "GS_SIZE", GetLocalInt(oCorpse, "GS_SIZE"));
          SetLocalInt(oCorpse2, "GS_GOLD", GetLocalInt(oCorpse, "GS_GOLD"));
          DestroyObject(oCorpse);
        }
//-      }

      gsCMStopFollowers(oPC);
    }

    oCorpse = GetNextItemInInventory(oPC);
  }

  return;
}
