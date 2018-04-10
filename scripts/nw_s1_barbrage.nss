//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Rage has been completely rewritten for Arelith.
    See comments in inc_barbarian for class details.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "gs_inc_pc"
#include "gs_inc_iprop"
#include "x2_i0_spells"
#include "x2_inc_itemprop"
#include "inc_item"
#include "inc_timelock"
#include "inc_barbarian"


//------------------------------------------------------------------------------
void main()
{
    // Rage Override for tribesman path.
    if (GetLocalInt(gsPCGetCreatureHide(), "TRIBESMAN"))
    {
        btribeCreateTribesmen(OBJECT_SELF);
        btribeCreateTribesmen(OBJECT_SELF);

        // Event Signal
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));

        return;
    }

    // Restore feat use.
    IncrementRemainingFeatUses(OBJECT_SELF, FEAT_BARBARIAN_RAGE);

    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Barbarian Rage"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Barbarian Rage");
        return;
    }

    // Voice chat
    PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

    // Mighty Rage now clears negative effects.  Let's do that first.
    if (GetHasFeat(FEAT_MIGHTY_RAGE))
        barbMightyRageCleanse(OBJECT_SELF);

    // Duration of rage effects is 2d4 + con mod rounds.  Add 1 turn (10 rounds) with Mighty Rage.
    int nDuration = d4(2) + GetAbilityModifier(ABILITY_CONSTITUTION);
    if (GetHasFeat(FEAT_MIGHTY_RAGE))
        nDuration = nDuration + 10;

    // Apply Temporary Effects to Barbarian
    barbSelfRageEffects(nDuration, OBJECT_SELF);

    // Apply Temporary Damage to Barb's Weapon
    barbWeaponRageEffects(nDuration, OBJECT_SELF);


    // Do Epic Rage Feats, if any, and apply Cooldown
    // Cooldown: Rage Duration + 1 turn (10 rounds)
    if (nDuration > 0) {
        barbEpicRageFeats(nDuration, OBJECT_SELF);
        SetTimelock(OBJECT_SELF, FloatToInt(RoundsToSeconds(nDuration + 10)), "Barbarian Rage");
    }

    // Event Signal
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));
}

//------------------------------------------------------------------------------

// OLD BARBARIAN CODE REPOSITORY
// OUTDATED - Con mod and rage level scaling phased out.
// (OLD) Effects vary based on con mod and rage level (how many rage feats you have).
/*
        int nConMod = GetAbilityModifier(ABILITY_CONSTITUTION);
        int nRageLevel;

        if (GetHasFeat(331))      nRageLevel = 7;
        else if (GetHasFeat(330)) nRageLevel = 6;
        else if (GetHasFeat(329)) nRageLevel = 5;
        else if (GetHasFeat(328)) nRageLevel = 4;
        else if (GetHasFeat(327)) nRageLevel = 3;
        else if (GetHasFeat(326)) nRageLevel = 2;
        else                      nRageLevel = 1;

        if (GetHasFeat(FEAT_EPIC_TERRIFYING_RAGE)) nRageLevel ++;
        if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE)) nRageLevel ++;
        if (GetHasFeat(FEAT_MIGHTY_RAGE)) nRageLevel ++;
*/
// OUTDATED Item type check.
        // string sSubRace = GetSubRace(OBJECT_SELF);
        // int nSubRace    = gsSUGetSubRaceByName(sSubRace);
        // int nLarge      = nSubRace == GS_SU_SPECIAL_OGRE
        // if (nBonusLevel && ( GetWeaponSize(oWeapon) >= WEAPON_SIZE_TWO_HANDED || GetCreatureSize(OBJECT_SELF) >= CREATURE_SIZE_LARGE))
        //  {
        //   nBonusLevel += 3;
        //  }
// OUTDATED - Rage level based damage
        //int nBonusLevel = (IPGetIsMeleeWeapon(oWeapon) || GetBaseItemType(oWeapon) == BASE_ITEM_THROWINGAXE) ? nRageLevel : 0;
// OUTDATED - Biteback removed
        // effect eShield = EffectDamageShield(nConMod + 3 * nRageLevel, 0, DAMAGE_TYPE_BLUDGEONING);
// OUTDATED - old Will save formula
        // effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nConMod + nRageLevel);
// OUTDATED - No more AC drop during rage
        // Create the negative effect, which lasts for 10s longer.
        // effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
        // eAC = ExtraordinaryEffect(eAC);
