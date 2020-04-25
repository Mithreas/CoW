/**
 * NWNX Names - Dynamic name functions.
 *
 * Plugin by virusman, library by Fireboar.
 *
 * Typically to change someone's name without affecting anything else, use the
 * SetDynamicNameForAll or DeleteDynamicNameForAll functions, both of which
 * function in the obvious way. Call DiscoverNames OnClientEnter.
 *
 * Should a name need to be changed for just one person for some reason, that's
 * possible: use SetDynamicName or DeleteDynamicName.
 *
 * Note: retired as broken by EE migration, see inc_rename for replacement. 
 */

#include "nwnx_names"

// Name modifiers. Enumerated in the order in which they are to be applied.
const int FB_NA_MODIFIER_STEALTH  = 0;
const int FB_NA_MODIFIER_DISGUISE = 1;

// Set to the number of FB_NA_MODIFIER_* constants (last one + 1).
const int FB_NA_MODIFIERS = 2;

void fbNASetDynamicNameForAll(object oObject, string sName);
// Deletes oObject's dynamic name.
void fbNADeleteDynamicNameForAll(object oObject);
// Add a modifier to oObject's name. Modifiers are applied in order of nModifier
// (a FB_NA_MODIFIER_* constant) to whatever each player thinks oObject's name
// is.
void fbNAAddNameModifier(object oObject, int nModifier, string sPre = "", string sPost = "");
// Remove a modifier from oObject's name. See fbNAAddNameModifier.
void fbNARemoveNameModifier(object oObject, int nModifier);
// Sets oObject's name to sName, but only applying the changes the next time a
// modifier is added or removed.
void fbNADelaySetName(object oObject, string sName);
// Returns the name of oObject set by fbNASetDynamicNameForAll or by
// fbNADelaySetName.
string fbNAGetGlobalDynamicName(object oObject);

void _fbNASetDynamicName(object oPlayer, object oObject, string sName)
{
  NWNX_Names_SetName(oObject, sName, oPlayer);
}
//----------------------------------------------------------------------------//
string _fbNAModifyName(object oObject, string sName)
{
  int nI = 0;
  for (; nI < FB_NA_MODIFIERS; nI++)
  {
    sName = GetLocalString(oObject, "FB_NA_PRE_" + IntToString(nI)) + sName +
     GetLocalString(oObject, "FB_NA_POST_" + IntToString(nI));
  }

  return sName;
}
//----------------------------------------------------------------------------//
void fbNASetDynamicNameForAll(object oObject, string sName)
{
  SetLocalString(oObject, "FB_NA_OVERRIDE", sName);
  sName = _fbNAModifyName(oObject, sName);
  _fbNASetDynamicName(OBJECT_INVALID, oObject, sName);
}
//----------------------------------------------------------------------------//
void fbNADeleteDynamicNameForAll(object oObject)
{
  fbNASetDynamicNameForAll(oObject, GetName(oObject));
}
//----------------------------------------------------------------------------//
void fbNAAddNameModifier(object oObject, int nModifier, string sPre = "", string sPost = "")
{
  SetLocalString(oObject, "FB_NA_PRE_" + IntToString(nModifier), sPre);
  SetLocalString(oObject, "FB_NA_POST_" + IntToString(nModifier), sPost);

  // TODO: Support for different people with different names.
  fbNASetDynamicNameForAll(oObject, fbNAGetGlobalDynamicName(oObject));
}
//----------------------------------------------------------------------------//
void fbNARemoveNameModifier(object oObject, int nModifier)
{
  DeleteLocalString(oObject, "FB_NA_PRE_" + IntToString(nModifier));
  DeleteLocalString(oObject, "FB_NA_POST_" + IntToString(nModifier));

  // TODO: Support for different people with different names.
  fbNASetDynamicNameForAll(oObject, fbNAGetGlobalDynamicName(oObject));
}
//----------------------------------------------------------------------------//
void fbNADelaySetName(object oObject, string sName)
{
  SetLocalString(oObject, "FB_NA_OVERRIDE", sName);
}
//----------------------------------------------------------------------------//
string fbNAGetGlobalDynamicName(object oObject)
{
  string sName = GetLocalString(oObject, "FB_NA_OVERRIDE");
  if (sName == "")
  {
    sName = GetName(oObject);
  }
  return sName;
}
