/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_hook_helper
//
//  Desc:  This collection of functions manages simplifies
//         builder access to pertinent data from within
//         hook scripts.
//
//  Author: David Bobeck 06May03
//
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// Returns the tradeskill type CNR_TRADESKILL_* that
// oPC is crafting in at the time the hook script executes.
/////////////////////////////////////////////////////////
int CnrHookHelperGetTradeskillType(object oPC);
/////////////////////////////////////////////////////////
int CnrHookHelperGetTradeskillType(object oPC)
{
  return GetLocalInt(oPC, "CnrHookHelperTradeskillType");
}

/////////////////////////////////////////////////////////
// Returns the tradeskill type CNR_TRADESKILL_* that
// oPC is crafting in at the time the hook script executes.
/////////////////////////////////////////////////////////
int CnrHookHelperGetNextLevel(object oPC);
/////////////////////////////////////////////////////////
int CnrHookHelperGetNextLevel(object oPC)
{
  return GetLocalInt(oPC, "CnrHookHelperNextLevel");
}

/////////////////////////////////////////////////////////
// Tell CNR whether to allow the PC to level up or not.
/////////////////////////////////////////////////////////
void CnrHookHelperSetLevelUpDenied(object oPC, int bDenied);
/////////////////////////////////////////////////////////
void CnrHookHelperSetLevelUpDenied(object oPC, int bDenied)
{
  SetLocalInt(oPC, "CnrHookHelperLevelUpDenied", bDenied);
}

/////////////////////////////////////////////////////////
// Optional. Set the text to display in the crafting
// convo when the PC is denied making a level. You may use
// this to explain to the player why the PC did not level,
// or what they need to do before leveling is allowed.
/////////////////////////////////////////////////////////
void CnrHookHelperSetLevelUpDeniedText(object oPC, string sText);
/////////////////////////////////////////////////////////
void CnrHookHelperSetLevelUpDeniedText(object oPC, string sText)
{
  SetLocalString(oPC, "CnrHookHelperLevelUpDeniedText", sText);
}

/////////////////////////////////////////////////////////
// Returns the key to the recipe that oPC is attempting
// to craft.
/////////////////////////////////////////////////////////
string CnrHookHelperGetKeyToRecipeInProgress(object oPC);
/////////////////////////////////////////////////////////
string CnrHookHelperGetKeyToRecipeInProgress(object oPC)
{
  return GetLocalString (oPC, "CnrHookHelperKeyToRecipeInProgress");
}

/////////////////////////////////////////////////////////
// Apply an adjustment to CNR's calculated recipe DC.
/////////////////////////////////////////////////////////
void CnrHookHelperSetAdjustmentToRecipeDC(object oPC, int nAdjustment);
/////////////////////////////////////////////////////////
void CnrHookHelperSetAdjustmentToRecipeDC(object oPC, int nAdjustment)
{
  SetLocalInt(oPC, "CnrHookHelperAdjustmentToRecipeDC", nAdjustment);
}