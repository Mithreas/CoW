/*
mi_inc_awia

A Wolf In Arelith - Library containing werewolf functions. It seemed easier to
have it all in one place - it's less in-grained into the module this way.

*/

#include "gs_inc_iprop"
#include "gs_inc_pc"
#include "mi_inc_database"
#include "mi_log"

const string AWIA = "AWIA"; // For tracing

// oTarget infects oPC with lycanthropy. Oh no!
void miAWInfect(object oPC, object oTarget);
// Transform into a werewolf! What fun!
void miAWTransform(object oPC);
// Apply werewolf effects.
void miAWApplyWolfEffects(object oPC, int bRefresh = FALSE);
// Remove werewolf effects.
void miAWRemoveWolfEffects(object oPC);
// Perform certain AI tasks.
void miAWWolfishAI(object oPC);
// Check to see if oAttacker is using a silver weapon against oWerewolf and if
// so, call miAWStutter.
void miAWSilverHit(object oAttacker, object oWerewolf);
// Lower immortality for a few seconds.
void miAWStutter(object oPC);
// Make a will save against wolfishness.
int miAWWillSave(object oPC);

int _miAWSilverHit(object oItem)
{
  if (GetIsObjectValid(oItem))
  {
    if (FindSubString(GetName(oItem, TRUE), "Silver") != -1)
    {
      return TRUE;
    }
    else if (gsIPGetMaterialType(oItem) == 13) // silver
    {
      return TRUE;
    }
  }
  return FALSE;
}
//----------------------------------------------------------------------------//
void miAWInfect(object oPC, object oTarget)
{
  // Only PCs get infected.
  if (!GetIsPC(oPC) || GetIsDM(oPC))
  {
    return;
  }

  // dunshine, monks are immune:
  if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0) return;

  // Either an infected PC or a creature with 'Were' in their name can infect
  // you. Dunshine, changed percentages from 5% and 2% to 0.5% for both
  if ((GetLocalInt(oTarget, "MI_AWIA_ACTIVE") && Random(200) > 198 ||
       FindSubString(GetName(oTarget), "Were") > -1 && Random(200) > 198)
      && !GetHasFeat(FEAT_DIVINE_HEALTH, oPC))
  {
    FloatingTextStringOnCreature("That was a nasty scratch!", oPC, FALSE);
    SetLocalInt(oPC, "MI_AWIA", TRUE);
    miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "awia", "1");
  }
}
//----------------------------------------------------------------------------//
void miAWTransform(object oPC)
{
  // Day 26, 27 and 28 are Danger Days!
  if (GetLocalInt(oPC, "MI_AWIA") && GetTimeHour() == 0 &&
           !GetIsDead(oPC) && 
           !GetLocalInt(oPC, "MI_AWIA_ACTIVE") && GetCalendarDay() > 25)
  {
    Log(AWIA, GetName(oPC) + " is turning into a werewolf!");
	
    miAWApplyWolfEffects(oPC);
  }
}
//----------------------------------------------------------------------------//
void miAWApplyWolfEffects(object oPC, int bRefresh = FALSE)
{
  SetLocalInt(oPC, "MI_TOTEM_OVERRIDE", 200); // MI_TO_WEREWOLF
  SetLocalInt(oPC, "MI_AWIA_ACTIVE", TRUE);
  
  effect eWerewolf = EffectRegenerate(1, 3.0);
  eWerewolf = SupernaturalEffect(eWerewolf);

  if (!bRefresh)
  {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, 6.0);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWerewolf, oPC);  
  }

  AssignCommand(oPC, ClearAllActions(TRUE));
  ExecuteScript ("nw_s2_wildshape", oPC);
  
  // Log when the effect starts.
  int nTime = GetLocalInt(oPC, "MI_AWIA_START");
  if (!nTime) SetLocalInt(oPC, "MI_AWIA_START", gsTIGetActualTimestamp());
}
//----------------------------------------------------------------------------//
void miAWRemoveWolfEffects(object oPC)
{
  effect eFX = GetFirstEffect(oPC);
  int nType;
  int nSubType;
  DeleteLocalInt(oPC, "MI_TOTEM_OVERRIDE");

  while (GetIsEffectValid(eFX))
  {
    nType    = GetEffectType(eFX);
    nSubType = GetEffectSubType(eFX);
    if (nType == EFFECT_TYPE_REGENERATE && nSubType == SUBTYPE_SUPERNATURAL)
    {
      RemoveEffect(oPC, eFX);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, 6.0);
    }

    if (nType == EFFECT_TYPE_POLYMORPH)
    {
      RemoveEffect(oPC, eFX);
    }

    eFX = GetNextEffect(oPC);
  }

  SetCommandable(TRUE, oPC);
  DeleteLocalInt(oPC, "MI_AWIA_BERSERK");
  DeleteLocalInt(oPC, "MI_AWIA_ACTIVE");
}
//----------------------------------------------------------------------------//
void miAWWolfishAI(object oPC)
{
  if (!GetLocalInt(oPC, "MI_AWIA_ACTIVE") || GetIsDead(oPC))
  {
    return;
  }

  // Check whether we are still in wolf form.  If we're not (e.g. someone manually
  // unshifted), shift them back.
  if (GetCreatureTailType(oPC) != 485) // werewolf
  {
    SetCommandable(TRUE, oPC);

	if (miAWWillSave(oPC))  
	{
	  miAWRemoveWolfEffects(oPC);
	  return;
	}  	
	else 
	{
	  miAWApplyWolfEffects(oPC, TRUE);
	}  
  }
  
  int nNth = 1;
  object oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nNth);

  while (GetIsObjectValid(oNearest) && GetDistanceBetween(oPC, oNearest) < 20.0)
  {
    // Ensure target is not immortal or a werewolf, and can be seen by oPC
    if (!GetImmortal(oNearest) && !GetLocalInt(oNearest, "MI_AWIA_ACTIVE") &&
        GetObjectSeen(oNearest, oPC))
    {	  
	  if (!miAWWillSave(oPC))
	  {
	    FloatingTextStringOnCreature("Rrrraaargh!!", oPC); 
	
        // Make berserk
        if (!GetLocalInt(oPC, "MI_AWIA_BERSERK"))
        {
          SetLocalInt(oPC, "MI_AWIA_BERSERK", TRUE);
        } 

        // Get a new target if necessary
		// Edit: Always issue the attack command.  There are
		// cases where it can be broken.
        SetCommandable(TRUE, oPC);
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionAttack(oNearest));
        AssignCommand(oPC, SetCommandable(FALSE, oPC));
	  }	
	  else if (GetLocalInt(oPC, "MI_AWIA_BERSERK"))
	  {
	    // Recovered from berserk rage.
        SetCommandable(TRUE, oPC);	
	  }

      return;
    }
	
    oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, ++nNth);
  }

  if (GetLocalInt(oPC, "MI_AWIA_BERSERK"))
  {
    SetCommandable(TRUE, oPC);
    // Only after battle has ended can the PC become immortal once more.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, 6.0);
    DeleteLocalInt(oPC, "MI_AWIA_BERSERK");
  }
}
//----------------------------------------------------------------------------//
void miAWSilverHit(object oAttacker, object oWerewolf)
{
  // Right now, oWerewolf could be anything. Make sure it's an immortal werewolf.
  if (!GetLocalInt(oWerewolf, "MI_AWIA_ACTIVE") || !GetImmortal(oWerewolf))
  {
    return;
  }

  // Special case: attacker is a werewolf too. Either can rip the other to shreds.
  if (GetLocalInt(oAttacker, "MI_AWIA_ACTIVE"))
  {
    miAWStutter(oWerewolf);
    miAWStutter(oAttacker);
    return;
  }

  // Check right hand
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
  if (_miAWSilverHit(oItem))
  {
    miAWStutter(oWerewolf);
    return;
  }

  // Check projectiles
  int nType = GetBaseItemType(oItem);
  if (nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
  {
    oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oAttacker);
    if (_miAWSilverHit(oItem))
    {
      miAWStutter(oWerewolf);
      return;
    }
  }
  else if (nType == BASE_ITEM_HEAVYCROSSBOW || nType == BASE_ITEM_LIGHTCROSSBOW)
  {
    oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oAttacker);
    if (_miAWSilverHit(oItem))
    {
      miAWStutter(oWerewolf);
      return;
    }
  }
  else if (nType == BASE_ITEM_SLING)
  {
    oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oAttacker);
    if (_miAWSilverHit(oItem))
    {
      miAWStutter(oWerewolf);
      return;
    }
  }

  // Check left hand
  oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
  if (_miAWSilverHit(oItem))
  {
    miAWStutter(oWerewolf);
    return;
  }
}
//----------------------------------------------------------------------------//
void miAWStutter(object oPC)
{
  if (GetImmortal(oPC))
  {
    SetImmortal(oPC, FALSE);
  }
}
//----------------------------------------------------------------------------//
int miAWWillSave(object oPC)
{
  // Make a will save.  DC lowers by 2 each hour since shifting.
  // If already berserk, DC increases by 5.
  int nTime  = GetLocalInt(oPC, "MI_AWIA_START");
  int nHours = gsTIGetHour(gsTIGetActualTimestamp() - nTime);
    
  int nDC = GetHitDice(oPC) + 10 - 2 * nHours;	
  if (GetLocalInt(oPC, "MI_AWIA_BERSERK")) nDC += 5;
  
  if (nDC < 5) nDC = 5;
	  
  if (WillSave(oPC, nDC, SAVING_THROW_TYPE_NONE))
  { 
    SendMessageToPC(oPC, "You master your violent urges... barely.");
    return TRUE;
  }
  
  return FALSE;
}

