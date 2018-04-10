// inc_assassinate
// Include file for assassination functions.
#include "inc_timelock"
#include "fb_inc_names"

// Check whether oPC and oTarget are valid
int asCanAssassinate(object oPC, object oTarget);

// Calculate bonus assassination damage.
int asAssassinationDamage(object oPC);

// Apply bonus assassination damage.
void asApplyDamage(object oPC, object oTarget);


//------------------------------------------------------------------------------
// Check whether oPC and oTarget are valid
int asCanAssassinate(object oPC, object oTarget)
{
	if (!GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC))
	{
        SendMessageToPC(oPC, "You are no assassin.");
        return FALSE;	
	}

    if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        SendMessageToPC(oPC, "Not a valid assassination target.");
        return FALSE;
    }

    if (oPC == oTarget)
    {
        SendMessageToPC(oPC, "Suicide is not assassination.");
        return FALSE;
    }

    if (GetIsTimelocked(OBJECT_SELF, "Assassination"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Assassination");
        return FALSE;
    }

    if (GetArea(oTarget) != GetArea(oPC))
    {
        SendMessageToPC(oPC, "Target must be in the general vicinity.");
        return FALSE;
    }

    if (GetDistanceBetween(oTarget, oPC) > 20.0)
    {
        SendMessageToPC(oPC, "You must be closer in order to study the target's weaknesses.");
        return FALSE;
    }

    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (!GetIsObjectValid(oWeapon)) oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);

    if (!GetIsObjectValid(oWeapon))
    {
        SendMessageToPC(oPC, "You must be wielding a weapon or wearing gauntlets.");
        return FALSE;
    }

    return TRUE;
}
//------------------------------------------------------------------------------
// Calculate bonus assassination damage.
int asAssassinationDamage(object oPC)
{
    // Assassin class levels plus INT bonus.  Int bonus limited to 1/2 class levels.
    int nClass = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    if (nInt > nClass / 2) nInt = nClass / 2;

    return nClass + nInt;
}

//------------------------------------------------------------------------------
// Apply bonus assassination damage.
void asApplyDamage(object oPC, object oTarget)
{

    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (!GetIsObjectValid(oWeapon)) oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);

    // Nothing to put the damage on.
    if (!GetIsObjectValid(oWeapon)) return;

    int nDamage = asAssassinationDamage(oPC);
    if (nDamage < 1) return;

    // Account for up to two other on-hit scripts.
    string sOnHitNum = "RUN_ON_HIT_1";
    if (GetLocalString(oWeapon, "RUN_ON_HIT_1") != "" && GetLocalString(oWeapon, "RUN_ON_HIT_1") != "im_w_assassinate") {
        sOnHitNum = "RUN_ON_HIT_2";
        if (GetLocalString(oWeapon, "RUN_ON_HIT_2") != "" && GetLocalString(oWeapon, "RUN_ON_HIT_2") != "im_w_assassinate")
            sOnHitNum = "RUN_ON_HIT_3";
    }

    // Apply on-hit script
    itemproperty iBSHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC));

    // If weapon imbues already exist on this weapon, piggyback by doing nothing.
    if (!GetItemHasItemProperty(oWeapon, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER)) {
        AddItemProperty(DURATION_TYPE_TEMPORARY, iBSHit, oWeapon, TurnsToSeconds(30));
    }

    SetLocalString(oWeapon, sOnHitNum, "im_w_assassinate");
    SetLocalInt(oWeapon, "ASSASSIN_DAMAGE", nDamage);
    SetLocalObject(oWeapon, "ASSASSIN_TARGET", oTarget);
    SendMessageToPC(oPC, "You prepare to assassinate " + fbNAGetGlobalDynamicName(oTarget) + ".");

    int nCooldown = 10;
    if (!GetIsPC(oTarget)) nCooldown = 2;

    SetTimelock(OBJECT_SELF, FloatToInt(TurnsToSeconds(nCooldown)), "Assassination", 60, 30);
}


