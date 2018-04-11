#include "gs_inc_portal"
#include "inc_effect"
#include "inc_spells"
#include "gs_inc_respawn"
#include "fb_inc_names"
#include "gs_inc_death"

/* *** subdual system ***

  PCs can toggle subdual mode by using chatcommand -subdual, activation will only work if they are unarmed or wield any of the allowed weapons
  Currently allowed weapons: Unarmed, Dagger, Club, Mace, Whip, Halberd, Magic Staff, Quarterstaff
  If a PC changes weapon while in subdual mode, subdual mode is automatically cancelled
  If a PC casts a harmful spell, subdual mode is automatically cancelled
  A PC with subdual mode active will have a -4 attack penalty
  A PC with the dirty fight feat will have no attack penalty
  (upcoming) A PC with the dirty fight feat will have a chance on several effects happening during subdual combat: blind, daze or knockdown (including some flavor texts)
  If a PC with subdual mode active, "kills" another PC, it doesn't die, but drops Unconscious for 15 to 25 seconds if both combatants are in subdual mode, and 40 to 60 seconds otherwise
  -> The above may be changed to a more advanced Unconscious "death" area, with an Unconscious body placeable remaining on the ground, later on)
  There is a 5% chance the target dies normally if the subdual mode if one-sided. If both combatants are in subdual mode there is no chance on deaths
  After the subdual time the PC revives, similar to how this works in PVP areas
  Revived PCs will have a stat penalty of -10 on all stats for 6 to 12 minutes, which will drop to -5 then for another 6 minutes and then wears off
  When still under the effect of revival penalties (or respawn penalties from a regular death) a PC cannot be subdued, it will die normally   
  It's possible for PCs to use a Lasso on subdued PCs to try and tie them up. Depending on the -unrelent mode of the target this results in:
  -unrelent active -> There is only a 5% chance on succes, on failure the victim dies. (Victims can use this, if they don't want to go along with subdual RP)
  -unrelent inactive -> The PC gets tied up succesfully. After 5 RL minutes the PC manages to break free, the time to break free might be shorter depending on Rope Use skill of the victim

  notes:
  - relogging while still being unconscious will result in a regular death

*/

// include file subdual mode functions

// function to (de)activate subdual mode for oPC
void gvd_SetSubdualMode(object oPC, int iActive);

// function that retrieves the subdual mode for oPC, returns 1 if active, 0 if inactive
int gvd_GetSubdualMode(object oPC);

// function to toggle subdual mode for oPC
void gvd_ToggleSubdualMode(object oPC);

// function to (de)activate unrelent mode for oPC
void gvd_SetUnrelentMode(object oPC, int iActive);

// function that retrieves the unrelent mode for oPC, returns 1 if active, 0 if inactive
int gvd_GetUnrelentMode(object oPC);

// function to toggle unrelent mode for oPC
void gvd_ToggleUnrelentMode(object oPC);

// check if oWeapon is allowed for subdual mode
int gvd_IsSubdualWeapon(object oWeapon);

// Checks subdual state for oPC, returns 0 if not subdued, 1 if currently subdued and 2 if recently subdued (within 12 RL minutes)
int gvd_GetSubdualState(object oPC);

// revives an Unconscious oPC
void gvd_ReviveUnconscious(object oPC);

// function to make a oPC Unconscious for iSubdualTimeout seconds
void gvd_ApplyUnconscious(object oPC, int iSubdualTimeout);
void _gvd_ApplyUnconscious();

// function to handle oPC tying up oTarget (corpse) with oLasso
void gvd_LassoSubdual(object oPC, object oTarget, object oLasso);

// function that handles the result of oPC trying oTarget up
void gvd_LassoSubdualResult(object oPC, object oTarget);

//////////////////////////////
// function implementations //
//////////////////////////////


void gvd_SetSubdualMode(object oPC, int iActive) {

  //WriteTimestampedLogEntry("SUBDUAL SYSTEM TEMP: " + GetName(oPC) + " attempting to set subdual mode to " + IntToString(iActive));  

  if (gvd_GetSubdualMode(oPC) == iActive) return;

  if (iActive) {

    // check for allowed weapons first
    if (gvd_IsSubdualWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND ,oPC)) == 1) {

      // check for dirty fight feat
      if (GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) == 0) {
        // default attack bonus
        int iABmodifier = 4;

        // apply the subdual effects
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(iABmodifier)), oPC, 0.0, EFFECT_TAG_SUBDUAL);

      }

      WriteTimestampedLogEntry("SUBDUAL SYSTEM: " + GetName(oPC) + " succesfully activated subdual mode.");  

      FloatingTextStringOnCreature("You are now fighting in subdual mode", oPC);

    } else {
      // not allowed for this weapon
      iActive = 0;

      WriteTimestampedLogEntry("SUBDUAL SYSTEM: " + GetName(oPC) + " failed to activate subdual mode, invalid weapon.");  

      FloatingTextStringOnCreature("Subdual mode is not possible wielding this weapon", oPC);
    }
    
  } else {
    
    // remove the subdual effects
    RemoveTaggedEffects(oPC, EFFECT_TAG_SUBDUAL);

    WriteTimestampedLogEntry("SUBDUAL SYSTEM: " + GetName(oPC) + " succesfully de-activated subdual mode.");  

    FloatingTextStringOnCreature("You are no longer fighting in subdual mode", oPC);

  }

  SetLocalInt(oPC, "GVD_SUBDUAL_MODE", iActive);

}

void gvd_SetUnrelentMode(object oPC, int iActive) {

  if (gvd_GetUnrelentMode(oPC) == iActive) return;

  if (iActive) {

    FloatingTextStringOnCreature("You will now forcibly resist anytime someone tries to tie you up", oPC);
    
  } else {
    
    FloatingTextStringOnCreature("You will not forcibly resist whenever someone tries to tie you up", oPC);

  }

  SetLocalInt(gsPCGetCreatureHide(oPC), "GVD_UNRELENT_MODE", iActive);

}

void gvd_ToggleSubdualMode(object oPC) {

  gvd_SetSubdualMode(oPC, !gvd_GetSubdualMode(oPC));

}

void gvd_ToggleUnrelentMode(object oPC) {

  gvd_SetUnrelentMode(oPC, !gvd_GetUnrelentMode(oPC));

}

int gvd_GetSubdualMode(object oPC) {

  return GetLocalInt(oPC, "GVD_SUBDUAL_MODE");

}

int gvd_GetUnrelentMode(object oPC) {

  return GetLocalInt(gsPCGetCreatureHide(oPC), "GVD_UNRELENT_MODE");

}

int gvd_IsSubdualWeapon(object oWeapon) {

  // Allowed: unarmed, club, quarterstaff, mage staff, whip, mace, halberd

  // unarmed?
  if (oWeapon == OBJECT_INVALID) return 1;
 
  int iBaseItemType = GetBaseItemType(oWeapon);

  switch (iBaseItemType) {
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_WHIP:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_HALBERD:
      return 1;
  }

  return 0;

}

int gvd_GetSubdualState(object oPC) {

  // 0 if not subdued
  // 1 if currently subdued
  // 2 if recently subdued (within 12 RL minutes)

  object oHide = gsPCGetCreatureHide(oPC);
  int iSubdualState = GetLocalInt(oHide, "GVD_SUBDUAL_STATE");

  // we'll count recovering from a regular death, also as being recovering from subdual state
  int iDrainPenalty = GetHasTaggedEffect(oPC, EFFECT_TAG_DEATH);

  if ((iSubdualState == 2) || (iDrainPenalty > 0)) {
    // check if time-out has passed (12 RL minutes)
    int nTimeout = gsTIGetGameTimestamp(720) + GetLocalInt(oHide, "GVD_SUBDUAL_TIMESTAMP") - gsTIGetActualTimestamp();

    if ((nTimeout <= 0) && (iDrainPenalty == 0)) {
      // timeout has passed, subdual state is cancelled
      DeleteLocalInt(oHide, "GVD_SUBDUAL_STATE");
      DeleteLocalInt(oHide, "GVD_SUBDUAL_TIMESTAMP");
      iSubdualState = 0;
    }

  }

  return iSubdualState;

}

void gvd_ApplyUnconscious(object oPC, int iSubdualTimeout) {

  // more advanced Unconscious area version, maybe later:
  // AssignCommand(oPC, _gvd_ApplyUnconscious());

  WriteTimestampedLogEntry("SUBDUAL SYSTEM: Applying Unconscious to " + GetName(oPC));

  // message to PC
  FloatingTextStringOnCreature("You drop unconscious", oPC);

  object oHide = gsPCGetCreatureHide(oPC);
  SetLocalInt(oHide, "GVD_SUBDUAL_STATE", 1);

  // simple version for now:
  DelayCommand(IntToFloat(iSubdualTimeout), gvd_ReviveUnconscious(oPC));  
  SetLocalInt(oHide, "GVD_SUBDUAL_TIMESTAMP", gsTIGetActualTimestamp());

}

void gvd_ReviveUnconscious(object oPC) {

    WriteTimestampedLogEntry("SUBDUAL SYSTEM: Reviving Unconscious: " + GetName(oPC));

    object oHide = gsPCGetCreatureHide(oPC);
  
    ApplyResurrection(oPC);
    SetLocalInt(oHide, "GVD_SUBDUAL_STATE", 2);

    // ability drains similar to death
    gvdREApplyNewSubdualPenalty(oPC);
}
  
