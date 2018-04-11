//::///////////////////////////////////////////////
//:: CUSTOM Terrifying Rage Script
//:: ent_terrirage.nss
//:: Written for Arelith
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save.

    Save DC is 5 + intimidate ranks/6 + HitDice/2 + base CON
    Treated as a saving throw vs fear.

    Tiered effects based on Hit Dice comparisons removed.

    Effect:
    - Debuff: -1 to AB and Saves per 7 Barbarian levels
    - Debuff: +5% ASF per 7 Barbarian levels
    - Debuff duration is 1d3 + base CON mod
    - 1/2 round stun

    Mind protection defends against stun, but not debuff.
    Fear immunity applies to Terrifying Rage.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_i0_spells"

void main()
{
    // Get the creature entering the aura
    object oTarget = GetEnteringObject();
    object oBarb = GetAreaOfEffectCreator();

    // Not hostile
    if(!GetIsEnemy(oTarget, oBarb))
        return;

    // Get our barbarian and his Hit Dice
    int nHD = GetHitDice(oBarb);

    // Target avoids the debuff if Fear Immune
    if (GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oBarb))
        return;

    // DC is 5 + intimidate ranks/6 + HD/2 + CON modifier
    int nDC = 5 + (GetSkillRank(SKILL_INTIMIDATE, oBarb) / 5) + (nHD / 2) + ((GetAbilityScore(oBarb, ABILITY_CONSTITUTION, TRUE) - 10) / 2);

    // Make a saving throw check
    if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        return;

    // Unless the target is immune to mind-affecting, stun the target
	// Stun duration is 3 rounds if target is not a PC
	float fStunDur = 3.0;
	if (!GetIsPC(oTarget))
		fStunDur = 18.0;
	
    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oBarb))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, fStunDur);

    // The duration of the debuff is 1d3 + base CON mod
    int nDuration = d3() + ((GetAbilityScore(oBarb, ABILITY_CONSTITUTION, TRUE) - 10) / 2);
	
	// Triple debuff duration for NPCs
	if (!GetIsPC(oTarget))
		nDuration = nDuration * 3;	

    // Start building the linked effects for the debuff.
    effect eLink;

    // VFX
    eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    // Get barb levels for the debuff
    int nBarbLevels = GetLevelByClass(CLASS_TYPE_BARBARIAN, oBarb) / 7;
    if (nBarbLevels < 0)
        nBarbLevels = 1;

    // Attack decrease and saving throw decrease, -1 per 7 barb levels
    eLink = EffectLinkEffects(eLink, EffectAttackDecrease(nBarbLevels));
    eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nBarbLevels));

    // ASF Increase
    eLink = EffectLinkEffects(eLink, EffectSpellFailure(5 * nBarbLevels));

    // Make the linked effects extraordinary
    eLink = ExtraordinaryEffect(eLink);

    // Apply duration effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

    // Instant VFX & voice chat
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FEAR_S), oTarget);
    PlayVoiceChat(VOICE_CHAT_HELP,oTarget);
}
