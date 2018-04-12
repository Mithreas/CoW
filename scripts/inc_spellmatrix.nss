/*
  Name: inc_spellmatrix
  Author: ActionReplay
  Date: 13 Feb 16
  Modified: 03 April 16
  Description:  Custom spell logic to be used by NPC monsters.
*/

//void main() {}

#include "inc_spell"
#include "nw_i0_spells"
#include "inc_effect"
#include "inc_statuseffect"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_data_arr"
#include "inc_tempvars"

const string txtFail = "<cÿcG>";

//::----------------------------------------------------------------------------
//:: DECLARATION
//::----------------------------------------------------------------------------
//::  HELPER FUNCTIONS
//::----------------------------------------------------------------------------

//:: Pretty formated popup text for displaying what spell was cast
void _arDoSpellText(object oCaster, string sSpell, int nCircle);

//:: Pretty formated popup text for displaying negative effect on oTarget
void _arNeagativeSpellText(object oTarget, string sSpell);

//:: Pretty formated popup text for displaying chaos effect on oTarget
void _arChaosSpellText(object oTarget, string sSpell);

//:: Internal helper function for creating AOE Spells, bunch of parameters to set.
//:: - lLoc: Target location of spell
//:: - eVisual: Visual Effect at Target location
//:: - eNegEffect: negative effect to apply to objects that fail nDC
//:: - nSave: Saving throw against eNegEffect
//:: - nSaveType: Specific Save type against eNegEffect (For immunities and the like)
//:: - nDC: DC for eNegEffect, also applied if damage is used where Reflex save is viable. Set to -1 to skip DC check.
//:: - nDuration: Duration of eNegEffect, set to 0 (zero) to make it instant.
//:: - nDmg: The Damage amount
//:: - nDamageType: Damage type to apply
//:: - nShape: Shape of AOE spell
//:: - fSize: Size/Radius of AOE spell
//:: - bAffectCaster: If the AoE should affect the caster
//:: - eNegVisual: The negative visual to use as a subeffect of eNegEffect
void _arDoAoeSpell(location lLoc, effect eVisual, effect eNegEffect, int nSave = SAVING_THROW_WILL, int nSaveType = SAVING_THROW_TYPE_NONE, int nDC = 10, float nDuration = 0.0, int nDmg = 0, int nDamageType = DAMAGE_TYPE_FIRE, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int bAffectCaster = TRUE, int eNegVisual = EFFECT_TYPE_INVALIDEFFECT, int bInstantNegVisual = FALSE);

//:: Internal helper function for creating single target Spells, bunch of parameters to set.
//:: - oTarget: Target object of spell
//:: - eVisual: Visual Effect at Target location
//:: - eNegEffect: negative effect to apply to objects that fail nDC
//:: - nSave: Saving throw against eNegEffect
//:: - nSaveType: Specific Save type against eNegEffect (For immunities and the like)
//:: - nDC: DC for eNegEffect, also applied if damage is used where Reflex save is viable. Set to -1 to skip DC check.
//:: - nDuration: Duration of eNegEffect, set to 0 (zero) to make it instant.  Zet to negative to make it permanent.
//:: - nDmg: The Damage amount
//:: - nDamageType: Damage type to apply
//:: - eNegVisual: The negative visual to use as a subeffect of eNegEffect
void _arDoSingleSpell(object oTarget, effect eVisual, effect eNegEffect, int nSave = SAVING_THROW_WILL, int nSaveType = SAVING_THROW_TYPE_NONE, int nDC = 10, float nDuration = 0.0, int nDmg = 0, int nDamageType = DAMAGE_TYPE_FIRE, int eNegVisual = EFFECT_TYPE_INVALIDEFFECT);

//:: Internal helper function for getting the first best creature in a given shape and radius.
//:: Can never return the caller of the function, use only to get some other PC/NPC.
//:: - lLoc: Location to check from
//:: - nShape: The shape to check from lLoc
//:: - fSize: The size of the shape
//:: - bOnlyPlayers: Set to TRUE to filter only to players as valid targets
object _arGetObjectFromShape(location lLoc, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int bOnlyPlayers = FALSE);

//::  Just a wrapper to delay call summons
void _arSummonDemon(string sResRef, location lLoc, int nObjectType = OBJECT_TYPE_CREATURE);

//::  Used in ar_RestoreLastWizardSpell() to get correct spell ID from grouped spells.
//::  E.g Shadow Conjuration, Protection from Alignment etc.  Wiz/Sorc Only.
int _arGetCorrectSpellId(int nSpellId);

//::  Used internally to display a feedback message from Chaos Shield.
void _arDoChaosMessage(object oCaster, object oTarget, string sMessage);


//::----------------------------------------------------------------------------
//::  GENERIC FUNCTIONS
//::----------------------------------------------------------------------------

//:: Called from Spellhooks, will restore the last spell cast for nForClass.  
//:: nForClass can be CLASS_TYPE_WIZARD, CLASS_TYPE_CLERIC, CLASS_TYPE_DRUID, 
//:: CLASS_TYPE_PALADIN or CLASS_TYPE_RANGER.
void ar_RestoreLastSpell(int nForClass);

//:: Called from Spellhooks, will restore the spell cast by Wizards only.
void ar_RestoreLastWizardSpell();

//:: Called from spellhooks, handles favoured soul spell refreshes.
void ar_RestoreFavouredSoulSpell();

//::  Will Buff oCaster's summon with bonuses the same as regular summons.
//::  This is just a work-around function for Wild Mage summoning.
//::  Only applies for Conjuration-type summons, e.g the Monoliths.
void ar_ApplySummonBonuses(object oCaster);

//::  Returns a calculated DC for oCaster when casting a spell of nSpellSchool of nSpellLevel
//::  used for Custom Spells and Wild Surge Effects
int ar_GetCustomSpellDC(object oCaster, int nSpellSchool, int nSpellLevel);

//::  Returns Spell Penetration modifiers for oCaster
int ar_GetSpellPenetrationModifiers(object oCaster);

//::  Checks to see if oTarget has immunities to resist a spell (SR, Immunities, Shields and Mantles).
//::  Returns TRUE if oTarget is Immune in any way, otherwise FALSE.
//:: - oCaster: Caster of the spell, used for Spell Resistence DC
//:: - oTarget: Subject to the Spell Effect
//:: - nSavingThrowType: The type of Spell Type, e.g it checks if oTarget has immunities against nSavingThrowType.
int ar_GetSpellImmune(object oCaster, object oTarget, int nSavingThrowType = SAVING_THROW_TYPE_NONE);

//::  Simple wrapper for duplicating the last cast spell. Mainly used as a Wild Surge.
void ar_CopySpell(object oTarget, location lTarget, int nSpell, float fDelay = 0.0);

//::  Wrapper for Spell Turning Effects.  The spell cast by oCaster will be turned back to her by oTarget.
//::  If it was an AoE spell it takes the nearest enemy taget to oCaster in lTarget.
void ar_CopySpellTurning(object oCaster, object oTarget, location lTarget, int nSpell);

//::  Returns oCaster's highest Casting Class level, to be used where GetClassLevel can't be a viable option.
//::  Copied from x0_i0_spells because linker errors.
int ar_GetHighestSpellCastingClassLevel(object oCaster);

//::  Returns TRUE if the spell caster is Arcane.
int ar_GetIsArcaneCaster();

//::----------------------------------------------------------------------------
//::  CUSTOM SPELLS
//::----------------------------------------------------------------------------


//:: Epic Spells

//::  Casts maxSteps amount of Great Thunderclaps in the caster's direction with a set DC of 28 and deals electrical 4d6 damage.
void ar_SpellMassiveThunderclap(object oCaster, float stepDistance, float angle, int maxSteps, int currentStep = 1, int nDC = 28);

//::  Casts Tolodine's Killing Wind, in a fixed radius at random points, FORT save against diease and a 20d6 Acid damage.
void ar_SpellTolodineKillingWind(object oCaster, int nDC = 25);
void _arSpellTolodineKillingWind(location lLoc, int nDC);    //::  Internal delayed func.

//::  Creates a deadly Volcano that spits Fireballs and Firestorm around an AoE.  See ar_volcano_spell for more info.
//::  Volcano only works Outdoors, cave areas and not in artifical areas (Cities).
//:: - oCaster: The caster of the spell
//:: - lTarget: Target location of spell, if target is invalid oCaster's location will be used instead.
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_SpellVolcano(object oCaster, location lTarget, int bFlavorText = TRUE);

//::  Wild Mage Special Spell: Creates a Chaos Shield around the Caster for 1 Round / Level.
//::  There is a 20% chance for each hostile target entering the AOE to be randomly affected by a Surge.
//::  See 'ar_chaos_a'  for more info.
void ar_DoChaosShield(object oCaster, float nFixedDuration = -1f);

//::  Creates a Spell Mantle effect around oCaster that can absorb up to "d12 + random Caster Level" number of spells.
//::  Will also apply up to one ally per 4 caster levels.
//::  Each applied Spell Mantle rolls individually for the number of spells to absorb.
//::  A Level 30 Caster could get a total absorb of 2 - 42
//::  Lasts 1 Turn / 3 Caster Levels, maximum of 10 Turns.
void ar_SpellEffulgentEpuration(object oCaster, int bFlavorText = TRUE);


//::  9th Circle Spells

//:: Casts Icebergs at random points in a fixed radius. Deals 20d6 Ice damage and has a chance to "Freeze" the targets.
void ar_SpellIceberg(object oCaster, int nDC = 25);
void _arSpellIceberg(location lLoc, int nDC);       //::  Internal delayed func.

//::  oCaster will imprison oTarget in a maze-like area for a short duration (4 Rounds).
//:: - oCaster: The caster of the spell
//:: - oTarget: The target of the spell, if oTarget is OBJECT_INVALID a random hostile target will be used in a fixed radius.
//:: - nDC: DC against a Will Check
//:: - bOnlyPlayers: If set to TRUE only players are available targets (Good for Monster NPCs so they don't cast on their own!)
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_SpellImprisonment(object oCaster, object oTarget = OBJECT_INVALID, int nDC = 25, int bOnlyPlayers = TRUE, int bFlavorText = TRUE);
void _arSpellImprisonment (object oTarget);        //::  Internal delayed func.

//::  oCaster casts the Burst of Glacial Weath spell at lTarget location.  Spell from NWN2.
//::  Will deal CasterLevel * d6 damage (Max 25) to all hostile targets in a medium AOE.
//::  Targets with less than 10% of their max HP remaining will be Frozen for 1 round/two caster levels.
//:: - oCaster: The Caster of the Spell.
//:: - lTarget: The location of the spell
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_BurstOfGlacialWrath(object oCaster, location lTarget, int bFlavorText = TRUE);

//::  Creates a Lightning Storm around lTarget location that randomly strikes down Lightnings
//::  in the AoE.  Duration is 2 + CasterLevel/3.  Will only work in Outdoor areas.
//:: - oCaster: The caster of the spell
//:: - lTarget: Target location of spell, if target is invalid oCaster's location will be used instead.
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_SpellLightningStorm(object oCaster, location lTarget, int bFlavorText = TRUE);

//::  Creates a Mass Energy Buffer AoE effect that affects caster and her allies.
//::  The caster & allies gains damage resistance 40/- against all elemental forms of damage.
//::  The spell ends after absorbing 10/Caster Level points of damage from any single elemental type.
//::  Lats 1 Hour / 2 Caster Levels.
void ar_SpellMassEnergyBuffer(object oCaster, int bFlavorText = TRUE);

//::  All creatures in a 10m AoE will Elemental Shield buff in a random element.
//::  Lasts 1 Turn / 3 Caster Levels and Elemental Shields scale with oCaster Level.
//::  Set a valid oOrigin, set to same as oCaster to let the AoE originate from the Caster or a specified Target object.
void ar_SpellMassElementalShield(object oCaster, object oOrigin, int bAffectEnemies = FALSE, int bFlavorText = TRUE);


//::  8th Circle Spells

//::  Casts Wrathful Castigation, a deadly death spell against oTarget. If the target succeeds the Saving Throw
//::  nCasterLevel (Max 20) d4 damage of Magical damage will be taken instead and a chance to be dazed!
//:: - oCaster: The caster of the spell
//:: - oTarget: The target of the spell
//:: - nDC: DC against Fortitude (Death) check
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_SpellWrathfulCastigation(object oCaster, object oTarget, int nDC, int bFlavorText = TRUE);

//::  Casts Avascular Mass on oTarget.
//::  Reduce foe to half hp and stun foe for 1 round by purging blood vessels, which can trap creatures in 20-ft. radius from victim
void ar_SpellAvascularMass(object oCaster, object oTarget, int bFlavorText = TRUE);

//::  Applies Iceskin spell on oCaster.
void ar_IceSkin(object oCaster);

//::  Water slam deals 2d6 + 2/level damage to all within 20-ft. radius, knockdowns targets for 4 seconds
void ar_SpellDepthSurge(object oCaster, int bFlavorText = TRUE);

//::  Deals 1d6 Damage (Max 20) to targets caught in the AoE.  Half the damage is
//::  slashing and the other half is cold damage.
//::  Targets failing a Reflex Save is slowed for 1 Round / Caster Level.
void ar_SpellFieldOfIcyRazors(object oCaster, object oTarget, int bFlavorText = TRUE);


//::  6th Ciricle Spells

//::  Casts Disintegrate spell on oTarget.  Will create a beam from oCaster on oTarget
//::  and if oCaster makes a successful Ranged Touch Attack CasterLevel*2d6 Magical Damage (Max 40d6)
//::  will be applied.  Fortitude Save to negate damage.
//::  TODO:  If oTarget is a player and player dies, remove corpse?
//:: - oCaster: The caster of the spell
//:: - oTarget: The target of the spell
//:: - bFlavorText: If set to TRUE flavour text of the spell will be displayed.
void ar_SpellDisintegrate(object oCaster, object oTarget, int bFlavorText = TRUE);

//::  Custom Heal spell.  Works exactly like a regular heal just wrapped fur custom behavior for Wild Surges mainly.
//:: - oTarget: The target of the spell
void ar_DoHealSpell(object oTarget);

//::  Chaos Shield Table
void ar_ApplyChaosShieldEffect(object oCaster, object oTarget);

//::----------------------------------------------------------------------------
//:: IMPLEMENTATION
//::----------------------------------------------------------------------------
//::----------------------------------------------------------------------------
//:: CUSTOM SPELLS
//::----------------------------------------------------------------------------
void ar_DoChaosShield(object oCaster, float nFixedDuration = -1f) {
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    effect eSpellVFX    = EffectAreaOfEffect(AOE_MOB_MENACE, "ar_chaos_a", "ar_chaos_c", "****");
    float nDuration     = RoundsToSeconds(nCasterLevel);
    int nDurationType   = DURATION_TYPE_TEMPORARY;

    if ( nFixedDuration != -1f ) {
        if (nFixedDuration == 0f) nDurationType = DURATION_TYPE_PERMANENT;
        nDuration = nFixedDuration;
    }

    ApplyEffectToObject(nDurationType, eSpellVFX, oCaster, nDuration);
}

void ar_SpellMassiveThunderclap(object oCaster, float stepDistance, float angle, int maxSteps, int currentStep = 1, int nDC = 28) {
    if (currentStep == 1) _arDoSpellText(oCaster, "Massive Thunderclap", 10);
    vector origin = GetPosition(oCaster);

    float x = origin.x + ( cos(angle) * (currentStep * stepDistance) );
    float y = origin.y + ( sin(angle) * (currentStep * stepDistance) );
    vector target = Vector(x, y, origin.z + 0.5);

    location lLoc = Location(GetArea(oCaster), target, 0.0);

    //:: Apply Effect
    effect eVis = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
    _arDoAoeSpell(lLoc, eVis, EffectKnockdown(), SAVING_THROW_FORT, SAVING_THROW_TYPE_MIND_SPELLS, nDC, 6.0, d6(4), DAMAGE_TYPE_ELECTRICAL, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN);

    //::  Recursive out
    if (currentStep >= maxSteps) return;

    DelayCommand (1.0, ar_SpellMassiveThunderclap(oCaster, stepDistance, angle, maxSteps, currentStep+1) );
}

void ar_SpellTolodineKillingWind(object oCaster, int nDC = 25) {
    _arDoSpellText(oCaster, "Tolodine's Killing Wind", 10);

    int i = 0;
    int amount = 6;
    float angStep = 360.0 / amount;
    for (; i < amount; i++) {
        vector target = GetPosition(oCaster);
        float ang  = angStep * i;
        float dist = (RADIUS_SIZE_COLOSSAL);
        target.x += cos(ang) * dist;
        target.y += sin(ang) * dist;

        location lLoc = Location(GetArea(oCaster), target, 0.0);

        effect eVis = EffectVisualEffect(VFX_FNF_HORRID_WILTING);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
        DelayCommand (2.0, _arSpellTolodineKillingWind(lLoc, nDC) );
    }
}
void _arSpellTolodineKillingWind(location lLoc, int nDC) {
    effect eVis = EffectVisualEffect(VFX_FNF_IMPLOSION);
    _arDoAoeSpell(lLoc, eVis, EffectDisease(DISEASE_MUMMY_ROT), SAVING_THROW_FORT, SAVING_THROW_TYPE_DISEASE, nDC, 0.0, d6(20), DAMAGE_TYPE_ACID, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN);
}

void ar_SpellVolcano(object oCaster, location lTarget, int bFlavorText = TRUE) {
    if (  GetIsObjectValid( GetAreaFromLocation(lTarget) ) == FALSE ) {
        lTarget = GetLocation(oCaster);
    }

    //::  Check Area Properties
    object oArea = GetArea(oCaster);
    if ( ( GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND && GetIsAreaInterior(oArea) ) || GetIsAreaNatural(oArea) == AREA_ARTIFICIAL ) {;
        FloatingTextStringOnCreature(txtFail + "Volcano eruption failed</c>", oCaster);
        if( GetIsPC(oCaster) ) SendMessageToPC(oCaster, "Volcano eruption failed: Only works in Outdoors, Underground and Non-Artifical Areas.");
        return;
    }

    if (bFlavorText) _arDoSpellText(oCaster, "Volcano", 10);

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lTarget );
    object oVolcano = CreateObject ( OBJECT_TYPE_PLACEABLE, "ar_spell_volcano", lTarget, FALSE);
    SetLocalObject(oVolcano, "AR_CASTER", oCaster);
    ApplyEffectToObject ( DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PETRIFY), oVolcano );
}

void ar_SpellLightningStorm(object oCaster, location lTarget, int bFlavorText = TRUE) {
    if (  GetIsObjectValid( GetAreaFromLocation(lTarget) ) == FALSE ) {
        lTarget = GetLocation(oCaster);
    }

    //::  Check Area Properties
    object oArea = GetArea(oCaster);
    if ( GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND && GetIsAreaInterior(oArea) ) {;
        FloatingTextStringOnCreature(txtFail + "Lightning Storm failed</c>", oCaster);
        if( GetIsPC(oCaster) ) SendMessageToPC(oCaster, "Lightning Storm failed: Only works in Outdoor Areas or Underground.");
        return;
    }

    if (bFlavorText) _arDoSpellText(oCaster, "Lightning Storm", 9);

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lTarget );
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), lTarget );
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), lTarget );

    object oStorm = CreateObject ( OBJECT_TYPE_PLACEABLE, "ar_light_storm", lTarget, FALSE);
    SetLocalObject(oStorm, "AR_CASTER", oCaster);
}

void ar_SpellEffulgentEpuration(object oCaster, int bFlavorText = TRUE) {
    if (bFlavorText) _arDoSpellText(oCaster, "Effulgent Epuration", 10);

    effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eAbsob;
    effect eLink;

    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    float fDuration     = TurnsToSeconds(nCasterLevel/3);
    int nTargets        = nCasterLevel / 4;
    if (nTargets <= 0) {
        nTargets = 1;
    }

    int nAbsorb;
    float fDelay    = 0f;
    location lLoc   = GetLocation(oCaster);
    object oTarget  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc, FALSE);
    while( GetIsObjectValid(oTarget) )
    {
        if( nTargets > 0 && !GetIsEnemy(oTarget, oCaster) && oCaster != oTarget )
        {
            fDelay = GetRandomDelay();
            gsSPRemoveEffect(oTarget, SPELL_GREATER_SPELL_MANTLE);
            gsSPRemoveEffect(oTarget, SPELL_LESSER_SPELL_MANTLE);
            gsSPRemoveEffect(oTarget, SPELL_SPELL_MANTLE);
            nTargets--;

            //::  Apply Spell Mantle to Ally
            nAbsorb         = d12() + (1 + Random(nCasterLevel));
            eAbsob          = EffectSpellLevelAbsorption(9, nAbsorb);
            eLink           = EffectLinkEffects(eVis, eAbsob);
            eLink           = EffectLinkEffects(eLink, eDur);

            DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration) );
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc, FALSE);
    }

    //::  On Caster
    fDelay  = GetRandomDelay();
    nAbsorb = d12() + (1 + Random(nCasterLevel));
    eAbsob  = EffectSpellLevelAbsorption(9, nAbsorb);
    eLink   = EffectLinkEffects(eVis, eAbsob);
    eLink   = EffectLinkEffects(eLink, eDur);

    gsSPRemoveEffect(oCaster, SPELL_GREATER_SPELL_MANTLE);
    gsSPRemoveEffect(oCaster, SPELL_LESSER_SPELL_MANTLE);
    gsSPRemoveEffect(oCaster, SPELL_SPELL_MANTLE);

    DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration) );
}

void ar_SpellMassEnergyBuffer(object oCaster, int bFlavorText = TRUE) {
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    float nDuration     = HoursToSeconds(nCasterLevel/2);
    int nAbsorb         = nCasterLevel*10;

    effect eCold    = EffectDamageResistance(DAMAGE_TYPE_COLD, 40, nAbsorb);
    effect eFire    = EffectDamageResistance(DAMAGE_TYPE_FIRE, 40, nAbsorb);
    effect eAcid    = EffectDamageResistance(DAMAGE_TYPE_ACID, 40, nAbsorb);
    effect eSonic   = EffectDamageResistance(DAMAGE_TYPE_SONIC, 40, nAbsorb);
    effect eElec    = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 40, nAbsorb);

    effect eDur     = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis     = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2    = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //::  Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    if (bFlavorText) _arDoSpellText(oCaster, "Mass Energy Buffer", 9);

    float fDelay    = 0f;
    location lLoc   = GetLocation(oCaster);
    object oTarget  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, FALSE);
    while( GetIsObjectValid(oTarget) )
    {
        if( !GetIsEnemy(oTarget, oCaster) && oCaster != oTarget )
        {
            fDelay = GetRandomDelay();
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration));
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, FALSE);
    }

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, nDuration));
}

void ar_SpellMassElementalShield(object oCaster, object oOrigin, int bAffectEnemies = FALSE, int bFlavorText = TRUE) {
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    float nDuration     = TurnsToSeconds(nCasterLevel/3);
    int nDmg            = 4 + d6(nCasterLevel/3);
    int nRand           = 0;

    effect eCold    = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_COLD);
    effect eFire    = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_FIRE);
    effect eElec    = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_ELECTRICAL);
    effect eAcid    = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_ACID);

    effect eVis     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur     = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    effect eDur2    = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
    effect eDur3    = EffectVisualEffect(448);
    effect eLink;

    if (bFlavorText) _arDoSpellText(oCaster, "Mass Elemental Shield", 9);

    float fDelay    = 0f;
    location lLoc   = GetLocation(oOrigin);
    object oTarget  = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE);
    while( GetIsObjectValid(oTarget) )
    {
        int bCanPass = bAffectEnemies || !GetIsEnemy(oTarget, oCaster);
        if( bCanPass && oCaster != oTarget )
        {
            fDelay = GetRandomDelay();

            //::  No Stacking Damage Shields
            if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))          gsSPRemoveEffect(oTarget, SPELL_DEATH_ARMOR);
            if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))     gsSPRemoveEffect(oTarget, SPELL_ELEMENTAL_SHIELD);
            if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))  gsSPRemoveEffect(oTarget, SPELL_MESTILS_ACID_SHEATH);

            //::  Random Elemental Shield
            nRand = d4();
            if (nRand == 1)         eLink = EffectLinkEffects(eCold, eDur);
            else if (nRand == 2)    eLink = EffectLinkEffects(eFire, eDur);
            else if (nRand == 3)    eLink = EffectLinkEffects(eElec, eDur2);
            else if (nRand == 4)    eLink = EffectLinkEffects(eAcid, eDur3);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eVis, eLink), oTarget, nDuration));
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE);
    }

    //::  Caster
    //::  No Stacking Damage Shields
    if (GetHasSpellEffect(SPELL_DEATH_ARMOR, oTarget))          gsSPRemoveEffect(oCaster, SPELL_DEATH_ARMOR);
    if (GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oTarget))     gsSPRemoveEffect(oCaster, SPELL_ELEMENTAL_SHIELD);
    if (GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oTarget))  gsSPRemoveEffect(oCaster, SPELL_MESTILS_ACID_SHEATH);

    //::  Random Elemental Shield
    nRand = d4();
    if (nRand == 1)         eLink = EffectLinkEffects(eCold, eDur);
    else if (nRand == 2)    eLink = EffectLinkEffects(eFire, eDur);
    else if (nRand == 3)    eLink = EffectLinkEffects(eElec, eDur2);
    else if (nRand == 4)    eLink = EffectLinkEffects(eAcid, eDur3);

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eVis, eLink), oCaster, nDuration));
}

void ar_SpellIceberg(object oCaster, int nDC = 25) {
    _arDoSpellText(oCaster, "Iceberg", 9);

    int i = 0;
    int amount = 6;
    float angStep = 360.0 / amount;
    for (; i < amount; i++) {
        vector target = GetPosition(oCaster);
        float ang  = angStep * i;
        float dist = (RADIUS_SIZE_COLOSSAL) * d3();
        target.x += cos(ang) * dist;
        target.y += sin(ang) * dist;

        location lLoc = Location(GetArea(oCaster), target, 0.0);

        effect eVis = EffectVisualEffect(VFX_FNF_ICESTORM);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
        DelayCommand (1.5, _arSpellIceberg(lLoc, nDC) );
    }
}
void _arSpellIceberg(location lLoc, int nDC) {
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
    _arDoAoeSpell(lLoc, eVis, EffectStunned(), SAVING_THROW_FORT, SAVING_THROW_TYPE_COLD, nDC, 12.0, d6(20), DAMAGE_TYPE_COLD, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN);
}

void ar_SpellImprisonment(object oCaster, object oTarget = OBJECT_INVALID, int nDC = 25, int bOnlyPlayers = TRUE, int bFlavorText = TRUE) {
    if ( oTarget == OBJECT_INVALID ) {
        oTarget = _arGetObjectFromShape(GetLocation(oCaster), SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, bOnlyPlayers);
        //::  It failed
        if ( oTarget == OBJECT_INVALID )            return;
        if ( bOnlyPlayers && !GetIsPC(oTarget) )    return;
    }

    if ( GetIsObjectValid(oTarget) && !GetIsCrowdControlImmune(oTarget) ) {
        if (bFlavorText) _arDoSpellText(oCaster, "Imprisonment", 9);

        //::  Face Target
        SetFacingPoint( GetPosition(oTarget) );

        //::  Do the save
        if ( WillSave(oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == 0 ) {
            _arNeagativeSpellText(oTarget, "Imprisonment");

            effect eVis  = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            effect eGate = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eGate, oTarget);
            SetLocalLocation(oTarget, "AR_STORED_LOCATION", GetLocation(oTarget));      //::  For return journey
            DelayCommand (2.5, _arSpellImprisonment(oTarget) );
        }
    }
}
void _arSpellImprisonment (object oTarget) {
    effect eVis     = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    location lLoc   = GetLocation(GetObjectByTag("AR_IMPRISONMENT"));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    AssignCommand(oTarget, ClearAllActions());
    AssignCommand(oTarget, JumpToLocation(lLoc));
}

void ar_SpellWrathfulCastigation(object oCaster, object oTarget, int nDC, int bFlavorText = TRUE) {
    nDC += 3; //::  This spell receives an arbitrary +3 to the DC, because why not?

    effect eVis     = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    effect eVis2    = EffectVisualEffect(VFX_FNF_IMPLOSION);

    if (bFlavorText) _arDoSpellText(oCaster, "Wrathful Castigation", 8);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

    //::  Check immunities
    if ( ar_GetSpellImmune(oCaster, oTarget, SAVING_THROW_TYPE_DEATH) == FALSE ) {
        //::  Do the save!
        if ( MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH) == 0 ) {
            _arNeagativeSpellText(oTarget, "Wrathful Castigation");

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oTarget);
            DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
        }
    }
    //::  Death fails, deal damage and daze
    else {
        eVis = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
        int nCasterLevel = GetCasterLevel(oCaster);
        int nDamage = nCasterLevel < 20 ? d4(nCasterLevel) : d4(20);
        _arDoSingleSpell(oTarget, eVis, EffectDazed(), SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, nDC, RoundsToSeconds(nCasterLevel), nDamage, DAMAGE_TYPE_MAGICAL);
    }
}

void ar_BurstOfGlacialWrath(object oCaster, location lTarget, int bFlavorText = TRUE) {
    int nCasterLevel = ar_GetHighestSpellCastingClassLevel(oCaster);
    int nDC          = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 9);
    float nDuration  = nCasterLevel < 20 ? RoundsToSeconds(nCasterLevel/2) : RoundsToSeconds(10);

    effect eColdImp  = EffectVisualEffect(VFX_IMP_HEAD_COLD);
    effect eColdHit  = EffectVisualEffect(VFX_COM_HIT_FROST);
    effect eAoe      = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eAoe2     = EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE);
    effect eEff1     = EffectVisualEffect(VFX_IMP_FROST_L);
    effect eFreeze   = EffectLinkEffects(EffectCutsceneParalyze(), EffectDamageReduction(10, DAMAGE_POWER_NORMAL, 0));
    eFreeze          = EffectLinkEffects(eFreeze, EffectLinkEffects(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 100), EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100)));
    eFreeze          = EffectLinkEffects(eFreeze, EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100), EffectVisualEffect(VFX_DUR_ICESKIN)));

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eAoe, lTarget );
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eAoe2, lTarget );

    if (bFlavorText) _arDoSpellText(oCaster, "Burst Of Glacial Wrath", 9);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid(oTarget) )
    {
        //::  Do damage & Effect
        if ( oTarget != oCaster && GetIsReactionTypeHostile(oTarget, oCaster) && GetCurrentHitPoints(oTarget) > 0 && ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {
            //::  Fort. Save for half
            int nDmg = nCasterLevel < 25 ? d6(nCasterLevel) : d6(25);

            if ( MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD) ) nDmg = nDmg / 2;

            effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_COLD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eColdImp, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eColdHit, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);

            //::  Freeze Target as well if under 10% of Max HP
            int nBreachLimit = GetMaxHitPoints(oTarget) / 10;
            if (nBreachLimit < 10) nBreachLimit = 10;
            int nTargetHP    = GetCurrentHitPoints(oTarget);
            if ( nTargetHP > 0 && nTargetHP <= nBreachLimit && !GetIsCrowdControlImmune(oTarget) ) {
                _arNeagativeSpellText(oTarget, "Frozen");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, nDuration);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oTarget);
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void ar_SpellDisintegrate(object oCaster, object oTarget, int bFlavorText = TRUE) {
    effect eBeam     = EffectBeam(VFX_BEAM_DISINTEGRATE, oCaster, BODY_NODE_HAND, FALSE);
    int nCasterLevel = ar_GetHighestSpellCastingClassLevel(oCaster);
    int nDices       = nCasterLevel < 20 ? nCasterLevel*2 : 40;
    int nDC          = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_TRANSMUTATION, 6);
    float nMaxDist   = RADIUS_SIZE_COLOSSAL*2;

    if (bFlavorText) _arDoSpellText(oCaster, "Disintegrate", 6);

    if ( GetIsObjectValid(oTarget) ) {
        float dist = GetDistanceBetween(oCaster, oTarget);
        if ( dist <= nMaxDist) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 2.5f);

            if ( TouchAttackRanged(oTarget) != 0 ) {
                //::  Fort. save to negate damage
                if ( FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE) != 0 && nDices > 5) {
                    nDices = 5;
                }

                int nDmg    = d6(nDices);
                effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_MAGICAL);
                effect eHit = EffectVisualEffect(VFX_IMP_ACID_S);
                effect eImp = EffectVisualEffect(VFX_COM_HIT_ACID);

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);

                //::  Disintegrate stuff
                //::  TODO:  If player, should remove corpse?
                if ( GetCurrentHitPoints(oTarget) <= 0 ) {
                    _arNeagativeSpellText(oTarget, "Disintegrated");
                }
            }
        } else if ( GetIsPC(oCaster) ) {
            SendMessageToPC(oCaster, "Disintegrate: Target is too far away!");
        }
    }
}

void ar_SpellAvascularMass(object oCaster, object oTarget, int bFlavorText = TRUE) {
    effect eVFX         = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    float nDuration     = RoundsToSeconds(1);
    int nDC             = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_NECROMANCY, 8);
    int nDmg            = GetCurrentHitPoints(oTarget) / 2;
    if (nDmg < 12) nDmg = d6(2);

    if (bFlavorText) _arDoSpellText(oCaster, "Avascular Mass", 8);

    //::  First Apply to target
    _arDoSingleSpell(oTarget, eVFX, EffectStunned(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, nDuration, nDmg, DAMAGE_TYPE_MAGICAL, VFX_DUR_MIND_AFFECTING_DISABLED);

    //::  Then loop through victims in AoE around target
    location lTarget    = GetLocation(oTarget);
    object oVictim      = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oVictim))
    {
        //::  Stun victims
        if ( oVictim != oCaster && oVictim != oTarget && GetIsReactionTypeHostile(oVictim, oCaster) && ar_GetSpellImmune(oCaster, oVictim, SAVING_THROW_TYPE_MIND_SPELLS) == FALSE ) {
            _arDoSingleSpell(oVictim, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), EffectStunned(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_FIRE, VFX_DUR_MIND_AFFECTING_DISABLED);

            //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), oVictim);
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED), EffectStunned()), oVictim, nDuration);
        }

        oVictim = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void ar_SpellDepthSurge(object oCaster, int bFlavorText = TRUE) {
    int nDC             = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 8);
    location lTarget    = GetLocation(oCaster);
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);

    if (bFlavorText) _arDoSpellText(oCaster, "Depth Surge", 8);

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_COLD), lTarget );
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND), lTarget );

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid(oTarget) )
    {
        if ( oTarget != oCaster && GetIsReactionTypeHostile(oTarget, oCaster) && ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {
            int nDamage = d6(2) + (nCasterLevel * 2);
            _arDoSingleSpell(oTarget, EffectVisualEffect(VFX_IMP_FROST_S), EffectKnockdown(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, 4.0, nDamage, DAMAGE_TYPE_BLUDGEONING, VFX_IMP_HEAD_COLD);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void ar_SpellFieldOfIcyRazors(object oCaster, object oTarget, int bFlavorText = TRUE) {
    int nDC             = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 8);
    location lTarget    = GetLocation(oTarget);
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    int nDices          = (nCasterLevel > 20 ? 20 : nCasterLevel) / 2;  //::  Damage is split up into Slashing and Cold
    float fDuration     = RoundsToSeconds(nCasterLevel);
    effect eColdHit     = EffectLinkEffects(EffectVisualEffect(VFX_IMP_SPIKE_TRAP), EffectVisualEffect(VFX_IMP_FROST_L));
    effect eSlow        = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), EffectSlow());
    effect eSlowVis     = EffectVisualEffect(VFX_IMP_SLOW);
    object oArea        = GetArea(oCaster);

    if (bFlavorText) _arDoSpellText(oCaster, "Field Of Icy Razors", 8);

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_COLD), lTarget );

    float fDelay;
    object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid(oVictim) )
    {
        if ( oVictim != oCaster && GetIsReactionTypeHostile(oVictim, oCaster) && ar_GetSpellImmune(oCaster, oVictim) == FALSE ) {
            int bFailedSave = MySavingThrow(SAVING_THROW_REFLEX, oVictim, nDC, SAVING_THROW_TYPE_COLD) == 0;
            int bHasImprEvasion = GetHasFeat(FEAT_IMPROVED_EVASION, oVictim);
            int nColdDmg    = d6(nDices);
            int nSlashDmg   = d6(nDices);

            //::  Limit Damage
            if ( !bFailedSave ) {
                nColdDmg  = bHasImprEvasion ? 0 : nColdDmg  / 2;
                nSlashDmg = bHasImprEvasion ? 0 : nSlashDmg / 2;
            } else if (bHasImprEvasion) {
                nColdDmg  = nColdDmg  / 2;
                nSlashDmg = nSlashDmg / 2;
            }


            if ( nColdDmg > 0 || nSlashDmg > 0 ) {
                effect eColdDmg  = EffectDamage(nColdDmg, DAMAGE_TYPE_COLD);
                effect eSlashDmg = EffectDamage(nSlashDmg, DAMAGE_TYPE_SLASHING);
                effect eDamage   = EffectLinkEffects(eColdDmg, eSlashDmg);

                fDelay = GetRandomDelay(0.4, 1.1);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eColdHit, eDamage), oVictim));

                //::  Store objects in NWNX Array to spawn snow later
                ObjectArray_PushBack(OBJECT_INVALID, "ar_SpellFieldOfIcyRazors", oVictim);
            }

            //::  Apply Slow on Failed Save
            if ( bFailedSave ) {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oVictim, fDuration));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSlowVis, oVictim));
            }
        }

        oVictim = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }

    //::  Loop the NWNX array and spawn some snow
    int nArrSize = ObjectArray_Size(OBJECT_INVALID, "ar_SpellFieldOfIcyRazors");
    int i = 0;
    for (; i < nArrSize; i++) {
        object oVictim = ObjectArray_At(OBJECT_INVALID, "ar_SpellFieldOfIcyRazors", i);
        vector vPosition = GetPosition(oVictim);
        float fFacing = IntToFloat(Random(360));
        location lSpawn = Location(oArea, vPosition, fFacing);
        CreateObject(OBJECT_TYPE_PLACEABLE, "x0_snowdrift", lSpawn);
    }
    ObjectArray_Clear(OBJECT_INVALID, "ar_SpellFieldOfIcyRazors");  //::  Clear it
}

void ar_IceSkin(object oCaster) {
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    float nDuration     = HoursToSeconds(nCasterLevel/2);
    effect eEff1        = EffectLinkEffects(EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO, nCasterLevel*10), EffectDamageResistance(DAMAGE_TYPE_COLD, 30));
    effect eEff2        = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ICESKIN), eEff1);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff2, oCaster, nDuration);
}

void ar_DoHealSpell(object oTarget) {
    int bIsUndead = gsSPGetIsUndead(oTarget);
    int nHP       = GetMaxHitPoints(oTarget);
    int nDmg      = GetCurrentHitPoints(oTarget)-d6();
    if (nDmg <= 0) nDmg = d6();

    effect eVis  = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    effect eEff  = !bIsUndead ? EffectHeal(GetMaxHitPoints(oTarget)) : EffectDamage(nDmg, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff, oTarget);
}

//::----------------------------------------------------------------------------
//:: GENERIC
//::----------------------------------------------------------------------------
int _ar_GetLastSpellCastLevel(string s2daColName)
{
    int nSpell      = _arGetCorrectSpellId(GetSpellId());   //::  Get Correct Spell Id from Grouped spells
    int nSpellLevel = StringToInt(Get2DAString("spells", s2daColName, nSpell));
	
    //::  Apply Meta Magic to total Spell Level
    int nMetaMagic = GetMetaMagicFeat();
    switch ( nMetaMagic )
    {
        case METAMAGIC_NONE:
            nSpellLevel += 0;
            break;
        case METAMAGIC_EXTEND:
        case METAMAGIC_SILENT:
        case METAMAGIC_STILL:
            nSpellLevel += 1;
            break;
        case METAMAGIC_EMPOWER:
            nSpellLevel += 2;
            break;
        case METAMAGIC_MAXIMIZE:
            nSpellLevel += 3;
            break;
        case METAMAGIC_QUICKEN:
            nSpellLevel += 4;
            break;
    }
	
	return nSpellLevel;
}

void ar_RestoreLastSpell(int nForClass) {
    int nClass = GetLastSpellCastClass();

    //::  Check spell cast class.
    if ( nClass == CLASS_TYPE_INVALID || nClass != nForClass )    return;

	string s2daColName = "";
	switch (nClass)
	{
	  case CLASS_TYPE_WIZARD:
	    s2daColName = "Wiz_Sorc";
		break;
	  case CLASS_TYPE_CLERIC:
	    s2daColName = "Cleric";
		break;
	  case CLASS_TYPE_DRUID:
	    s2daColName = "Druid";
		break;
	  case CLASS_TYPE_PALADIN:
	    s2daColName = "Paladin";
		break;
	  case CLASS_TYPE_RANGER:
	    s2daColName = "Ranger";
		break;
	}
	
    //::  Get Spell Level
    string sColumn  = s2daColName;
    int nSpell      = _arGetCorrectSpellId(GetSpellId());   //::  Get Correct Spell Id from Grouped spells
    int nSpellLevel = _ar_GetLastSpellCastLevel(sColumn);
	
    //::  Loop Memorized Spells
    struct NWNX_Creature_MemorisedSpell mss;
    int nMaxSlots = NWNX_Creature_GetMaxSpellSlots(OBJECT_SELF, nClass, nSpellLevel);
    int x;
	
    for( x = 0; x <= nMaxSlots; x++ )
    {
        mss = NWNX_Creature_GetMemorisedSpell(OBJECT_SELF, nClass, nSpellLevel, x);

        //::  Found The spell that was used in the book, so replenish it.
        if( nSpell == mss.id && mss.ready == FALSE && GetMetaMagicFeat() == mss.meta) {
            mss.ready = TRUE;
            NWNX_Creature_SetMemorisedSpell(OBJECT_SELF, nClass, nSpellLevel, x, mss);
            break;
        }
    }
}

void ar_RestoreLastWizardSpell() {
  ar_RestoreLastSpell(CLASS_TYPE_WIZARD);
}

void ar_RestoreFavouredSoulSpell()
{
  if (GetLastSpellCastClass() != CLASS_TYPE_CLERIC) return;
  
  int nSpellLevel = _ar_GetLastSpellCastLevel("Cleric");
  
  // Get the number of spell slots the PC has at that level.
  int nMaxSpellsPerDay = NWNX_Creature_GetMaxSpellSlots(OBJECT_SELF, CLASS_TYPE_CLERIC, nSpellLevel);
  
  // Get the number of spells cast at that level.
  int nSpellsCast = GetLocalInt(OBJECT_SELF, "FS_CAST_COUNT_" + IntToString(nSpellLevel)) + 1;
  
  //SendMessageToPC(OBJECT_SELF, "Spell level: " + IntToString(nSpellLevel) + ", Max spells: " + IntToString(nMaxSpellsPerDay) + ", spells cast " + IntToString(nSpellsCast));
  
  if (nSpellsCast < nMaxSpellsPerDay)
  {
    // Restore and notify.
	ar_RestoreLastSpell(CLASS_TYPE_CLERIC);
	
	SendMessageToPC(OBJECT_SELF, IntToString(nSpellsCast) + " of " + IntToString(nMaxSpellsPerDay) + " cast today.");
	
    SetTempInt(OBJECT_SELF, "FS_CAST_COUNT_" + IntToString(nSpellLevel), nSpellsCast, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
  }
  else
  {
    // Wipe out all spells of that level. 
	int x;
    struct NWNX_Creature_MemorisedSpell mss;
    for( x = 0; x <= nMaxSpellsPerDay; x++ )
    {
      mss = NWNX_Creature_GetMemorisedSpell(OBJECT_SELF, CLASS_TYPE_CLERIC, nSpellLevel, x);
      mss.ready = FALSE;
      NWNX_Creature_SetMemorisedSpell(OBJECT_SELF, CLASS_TYPE_CLERIC, nSpellLevel, x, mss);
    }
  }
}

void ar_ApplySummonBonuses(object oCaster) {
    int nFocusAmount = 0;
    object oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);

    if( !GetIsObjectValid(oAssociate) || GetAssociateType(oAssociate) != ASSOCIATE_TYPE_SUMMONED || !GetIsObjectValid(oCaster) ) return;

    if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))           nFocusAmount = 3;
    else if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))   nFocusAmount = 2;
    else if(GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCaster))           nFocusAmount = 1;

    //::  Focus Buff
    if ( nFocusAmount > 0 ) {
        effect eBuff;
        eBuff = EffectAttackIncrease(nFocusAmount);
        eBuff = EffectLinkEffects(eBuff, EffectDamageIncrease(DamageBonusConstant(nFocusAmount), DAMAGE_TYPE_BLUDGEONING));
        eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, nFocusAmount));
        eBuff = SupernaturalEffect(eBuff);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuff, oAssociate);

        IncreaseKnownSkillRanks(oAssociate, nFocusAmount);
        IncreaseMaximumHitPoints(oAssociate, GetClassHitDie(GetPrimaryClass(oAssociate)) * nFocusAmount + GetBaseAbilityModifier(oAssociate, ABILITY_CONSTITUTION) * nFocusAmount);
        NWNX_Creature_SetBaseAC(oAssociate, GetACNaturalBase(oAssociate) + nFocusAmount);
    }

    //::  Epic Buff
    int nEpicCasterLevel = ar_GetHighestSpellCastingClassLevel(oCaster) - 20;
    if(nEpicCasterLevel <= 0) return;

    int nAbility = GetAbilityScore(oAssociate, ABILITY_STRENGTH, TRUE) > GetAbilityScore(oAssociate, ABILITY_DEXTERITY, TRUE) ? ABILITY_STRENGTH : ABILITY_DEXTERITY;
    effect eEpicBuff;
    eEpicBuff = EffectAttackIncrease((nEpicCasterLevel + 1) / 2);
    eEpicBuff = EffectLinkEffects(eEpicBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, nEpicCasterLevel / 2));
    eEpicBuff = SupernaturalEffect(eEpicBuff);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEpicBuff, oAssociate);

    ModifyAbilityScore(oAssociate, nAbility, (nEpicCasterLevel + 1) / 2);
    IncreaseKnownSkillRanks(oAssociate, nEpicCasterLevel);
    IncreaseMaximumHitPoints(oAssociate, GetClassHitDie(GetPrimaryClass(oAssociate)) * nEpicCasterLevel + GetBaseAbilityModifier(oAssociate, ABILITY_CONSTITUTION) * nEpicCasterLevel);
    NWNX_Creature_SetBaseAC(oAssociate, GetACNaturalBase(oAssociate) + nEpicCasterLevel / 2);
    SetBonusHitDice(oAssociate, nEpicCasterLevel);
    //::  This is SetTemporaryCasterLevelBonus
    SetLocalInt(oAssociate, "Lib_Spells_CasterLevelBonus", nEpicCasterLevel);
}

int ar_GetCustomSpellDC(object oCaster, int nSpellSchool, int nSpellLevel) {
    int nResult = 10 + nSpellLevel;

    if ( GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster) > GetAbilityModifier(ABILITY_CHARISMA, oCaster) )
        nResult += GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    else
        nResult += GetAbilityModifier(ABILITY_CHARISMA, oCaster);


    switch (nSpellSchool)
    {
        case SPELL_SCHOOL_ABJURATION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_CONJURATION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_DIVINATION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_ENCHANTMENT:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_EVOCATION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_GENERAL:
        {
          // Do nothing.
          break;
        }
        case SPELL_SCHOOL_ILLUSION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_NECROMANCY:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster))
          {
            nResult += 2;
          }
          break;
        }
        case SPELL_SCHOOL_TRANSMUTATION:
        {
          if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster))
          {
            nResult += 6;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCaster))
          {
            nResult += 4;
          }
          else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCaster))
          {
            nResult += 2;
          }
          break;
        }
    }

    return nResult;
}

int ar_GetSpellImmune(object oCaster, object oTarget, int nSavingThrowType = SAVING_THROW_TYPE_NONE)
{
    int nSpellDC =  d20() + ar_GetHighestSpellCastingClassLevel(oCaster) + ar_GetSpellPenetrationModifiers(oCaster);
    int nReturn  = FALSE;
    effect eVis;

    int bIsHostile = oCaster != oTarget; /*&& !GetIsReactionTypeFriendly(oTarget, oCaster);*/

    //::  Spell Mantles
    if (GetHasSpellEffect(SPELL_LESSER_SPELL_MANTLE, oTarget) ||
             GetHasSpellEffect(SPELL_SPELL_MANTLE, oTarget) ||
             GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oTarget))
    {
        eVis = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        RemoveProtections(SPELL_LESSER_SPELL_MANTLE, oTarget, 0);
        RemoveProtections(SPELL_SPELL_MANTLE, oTarget, 0);
        RemoveProtections(SPELL_GREATER_SPELL_MANTLE, oTarget, 0);
        nReturn = TRUE;
    }
    //::  Spell Resistance Check
    else if ( bIsHostile && GetSpellResistance(oTarget) >= nSpellDC )
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        if ( GetIsPC(oTarget) ) SendMessageToPC(oTarget, "*Spell Resisted*");
        if ( GetIsPC(oCaster) ) SendMessageToPC(oCaster, "*" + GetName(oTarget) + ": Spell Resisted*");
        nReturn = TRUE;
    }
    //::  Immunities
    else if ( nSavingThrowType != SAVING_THROW_TYPE_NONE )
    {
        int bSuccess = FALSE;
        switch (nSavingThrowType) {
            case SAVING_THROW_TYPE_DEATH:
                if ( GetHasSpellEffect(SPELL_SHADOW_SHIELD, oTarget) ||
                     GetHasSpellEffect(SPELL_DEATH_WARD, oTarget))
                        bSuccess = TRUE;
            break;

            case SAVING_THROW_TYPE_MIND_SPELLS:
                if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget) ||
                     GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oTarget) ||
                     GetHasSpellEffect(SPELL_CLARITY, oTarget) ||
                     GetHasSpellEffect(SPELL_MIND_BLANK, oTarget))
                        bSuccess = TRUE;
            break;
        }

        if ( bSuccess ) {
            eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            nReturn = TRUE;
        }
    }

    return nReturn;
}

int ar_GetSpellPenetrationModifiers(object oCaster)
{
  int nResult = 0;

  if (GetHasFeat(FEAT_SPELL_PENETRATION, oCaster))                  nResult += 2;
  else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))     nResult += 4;
  else if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))        nResult += 6;

  return nResult;
}

void ar_CopySpell(object oTarget, location lTarget, int nSpell, float fDelay = 0.0) {
    int nMetaMagic = GetMetaMagicFeat();

    ClearAllActions();
    if ( GetIsObjectValid(oTarget) ) {
        DelayCommand( fDelay, ActionCastSpellAtObject(nSpell, oTarget, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
    } else {
        DelayCommand( fDelay, ActionCastSpellAtLocation(nSpell, lTarget, nMetaMagic, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
    }
}

void ar_CopySpellTurning(object oCaster, object oTarget, location lTarget, int nSpell) {
    int nMetaMagic = GetMetaMagicFeat();

    if ( GetIsObjectValid(oTarget) && GetIsDead(oTarget) == FALSE ) {
        _arNeagativeSpellText(oTarget, "Spell Turning");
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, ActionCastSpellAtObject(nSpell, oCaster, nMetaMagic, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
    } else {
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, 1);
        if ( GetIsObjectValid(oTarget) && oTarget != oCaster && GetIsDead(oTarget) == FALSE ) {
            AssignCommand(oTarget, ClearAllActions());
            AssignCommand(oTarget, ActionCastSpellAtLocation(nSpell, GetLocation(oCaster), nMetaMagic, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
            _arNeagativeSpellText(oTarget, "Spell Turning");
        }
    }
}

int ar_GetHighestSpellCastingClassLevel(object oCaster)
{
    int nMax;
    if ( GetIsPC(oCaster) )
    {
        int i;
        int nClass;
        int nLevel;
        for ( i = 1; i <= 3; i++ )
        {
            nClass = GetClassByPosition(i, oCaster);
            if (nClass != CLASS_TYPE_INVALID)
            {
                if (nClass ==  CLASS_TYPE_SORCERER || nClass ==  CLASS_TYPE_WIZARD ||
                    nClass ==  CLASS_TYPE_PALEMASTER || nClass == CLASS_TYPE_CLERIC ||
                    nClass == CLASS_TYPE_DRUID || nClass == CLASS_TYPE_BARD ||
                    nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
                {
                    nLevel = GetLevelByClass(nClass, oCaster);

                    if (nLevel > nMax)
                    {
                        nMax = nLevel;
                    }
                }
            }
        }
    }
    else
    {
        //::  Cheat for Creatures, just give max Level
        nMax = GetHitDice(oCaster);
    }

    return nMax;
}

int ar_GetIsArcaneCaster() {
    int nClass = GetLastSpellCastClass();

    return (nClass == CLASS_TYPE_WIZARD ||
            nClass == CLASS_TYPE_SORCERER ||
            nClass == CLASS_TYPE_BARD);
}

//::----------------------------------------------------------------------------
//:: HELPERS
//::----------------------------------------------------------------------------
void _arDoAoeSpell(location lLoc, effect eVisual, effect eNegEffect, int nSave = SAVING_THROW_WILL, int nSaveType = SAVING_THROW_TYPE_NONE, int nDC = 10, float nDuration = 0.0, int nDmg = 0, int nDamageType = DAMAGE_TYPE_FIRE, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int bAffectCaster = TRUE, int eNegVisual = EFFECT_TYPE_INVALIDEFFECT, int bInstantNegVisual = FALSE) {

    effect eDmg;
    int bPass = TRUE;
    object oTarget = GetFirstObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid(oTarget) )
    {
        //::  Do not affect Caster?
        if (!bAffectCaster && oTarget == OBJECT_SELF)   bPass = FALSE;
        else bPass = TRUE;

        if( ar_GetSpellImmune(OBJECT_SELF, oTarget, nSaveType) == FALSE && bPass ) {
            //::  Apply Damage and Rules
            if ( nDmg != 0 ) {
                //::  Reflex Save for Half Damage
                int bHalfDmgChance = nDamageType == DAMAGE_TYPE_FIRE || nDamageType == DAMAGE_TYPE_ELECTRICAL;
                int nDmgSaveType = nDamageType == DAMAGE_TYPE_FIRE ? SAVING_THROW_TYPE_FIRE : SAVING_THROW_TYPE_ELECTRICITY;
                if (bHalfDmgChance) {
                    int bHasImprEvasion = GetHasFeat(FEAT_IMPROVED_EVASION, oTarget);
                    if ( nDC > -1 && ReflexSave(oTarget, nDC, nDmgSaveType) != 0 ) {
                        nDmg = bHasImprEvasion ? 0 : nDmg / 2;
                    } else if (bHasImprEvasion) nDmg = nDmg / 2;
                }

                eDmg = EffectDamage(nDmg, nDamageType);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            }

            //::  Apply The Actual Effect
            int bFailed = FALSE;
            if (nDC != -1) {
                if (nSave == SAVING_THROW_WILL && WillSave(oTarget, nDC, nSaveType) == 0)            bFailed = TRUE;
                else if (nSave == SAVING_THROW_REFLEX && ReflexSave(oTarget, nDC, nSaveType) == 0)   bFailed = TRUE;
                else if (nSave == SAVING_THROW_FORT && FortitudeSave(oTarget, nDC, nSaveType) == 0)  bFailed = TRUE;
            } else bFailed = TRUE;


            if (bFailed) {
                if ( nDuration != 0.0 ) {
                    if ( eNegVisual != EFFECT_TYPE_INVALIDEFFECT )  {
                        if ( bInstantNegVisual == TRUE ) {
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegEffect, oTarget, nDuration);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(eNegVisual), oTarget);
                        }
                        else {
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(eNegVisual), eNegEffect), oTarget, nDuration);
                        }
                    }
                    else {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegEffect, oTarget, nDuration);
                    }
                }
                else {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegEffect, oTarget);
                    if ( eNegVisual != EFFECT_TYPE_INVALIDEFFECT ) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(eNegVisual), oTarget);
                }
            }
        }

        oTarget = GetNextObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual, lLoc);
}

void _arDoSingleSpell(object oTarget, effect eVisual, effect eNegEffect, int nSave = SAVING_THROW_WILL, int nSaveType = SAVING_THROW_TYPE_NONE, int nDC = 10, float nDuration = 0.0, int nDmg = 0, int nDamageType = DAMAGE_TYPE_FIRE, int eNegVisual = EFFECT_TYPE_INVALIDEFFECT) {

    if ( !GetIsObjectValid(oTarget) || ar_GetSpellImmune(OBJECT_SELF, oTarget, nSaveType) == TRUE ) {
        return;
    }

    effect eDmg;
    if ( nDmg != 0 ) {
        //::  Reflex Save for Half Damage
        int bHalfDmgChance = nDamageType == DAMAGE_TYPE_FIRE || nDamageType == DAMAGE_TYPE_ELECTRICAL;
        int nDmgSaveType = nDamageType == DAMAGE_TYPE_FIRE ? SAVING_THROW_TYPE_FIRE : SAVING_THROW_TYPE_ELECTRICITY;
        if (bHalfDmgChance) {
            int bHasImprEvasion = GetHasFeat(FEAT_IMPROVED_EVASION, oTarget);
            if ( nDC > -1 && ReflexSave(oTarget, nDC, nDmgSaveType) != 0 ) {
                nDmg = bHasImprEvasion ? 0 : nDmg / 2;
            } else if (bHasImprEvasion) nDmg = nDmg / 2;
        }

        eDmg = EffectDamage(nDmg, nDamageType);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
    }

    //::  Apply The Actual Effect
    int bFailed = FALSE;
    if (nDC != -1) {
        if (nSave == SAVING_THROW_WILL && WillSave(oTarget, nDC, nSaveType) == 0)            bFailed = TRUE;
        else if (nSave == SAVING_THROW_REFLEX && ReflexSave(oTarget, nDC, nSaveType) == 0)   bFailed = TRUE;
        else if (nSave == SAVING_THROW_FORT && FortitudeSave(oTarget, nDC, nSaveType) == 0)  bFailed = TRUE;
    } else bFailed = TRUE;

    if (bFailed) {
        if ( nDuration < 0.0 )          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegEffect, oTarget);
        else if ( nDuration != 0.0 ) {
            if ( eNegVisual != EFFECT_TYPE_INVALIDEFFECT ) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(eNegVisual), eNegEffect), oTarget, nDuration);
            }
            else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegEffect, oTarget, nDuration);
        }
        else                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegEffect, oTarget);
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

object _arGetObjectFromShape(location lLoc, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int bOnlyPlayers = FALSE) {
    object oTarget = GetFirstObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);

    while( GetIsObjectValid(oTarget) )
    {
        if( GetIsObjectValid(oTarget) && oTarget != OBJECT_SELF ) {
            if ( bOnlyPlayers == TRUE ) {
                if ( GetIsPC(oTarget) ) return oTarget; //::  Only PCs
            }
            else return oTarget;
        }

        oTarget = GetNextObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }

    return oTarget;
}

void _arSummonDemon(string sResRef, location lLoc, int nObjectType = OBJECT_TYPE_CREATURE) {
    CreateObject(nObjectType, sResRef, lLoc);
}

void _arDoSpellText(object oCaster, string sSpell, int nCircle) {
    string sPrefix = "Spell: ";
    if (nCircle > 9) sPrefix = "Epic Spell:" ;

    string sMsg = "<c€ €>" + sPrefix + "</c> " + sSpell;
    FloatingTextStringOnCreature(sMsg, oCaster);

    if ( !GetIsPC(oCaster) && GetCurrentHitPoints(oCaster) > 0 ) AssignCommand(oCaster, SpeakString(sMsg));
}

void _arNeagativeSpellText(object oTarget, string sSpell) {
    string sMsg = "<cþ  >*" + sSpell + "*</c> ";

    if ( GetIsPC(oTarget) ) SendMessageToPC(oTarget, sSpell);
    //::  NPC display
    else if ( GetCurrentHitPoints(oTarget) > 0 ) AssignCommand(oTarget, SpeakString(sMsg));

    if ( GetIsDead(oTarget) == FALSE )
        FloatingTextStringOnCreature(sMsg, oTarget);
}

void _arChaosSpellText(object oTarget, string sSpell) {
    string sMsg = "<c• •>Chaos:</c> " + sSpell;

    if ( GetIsPC(oTarget) ) SendMessageToPC(oTarget, "Affected by <c• •>Chaos:</c> " + sSpell);
    //::  NPC display
    else if ( GetCurrentHitPoints(oTarget) > 0 ) AssignCommand(oTarget, SpeakString(sMsg));

    if ( GetIsDead(oTarget) == FALSE )
        FloatingTextStringOnCreature(sMsg, oTarget);
}

void _arDoChaosMessage(object oCaster, object oTarget, string sMessage) {
    _arChaosSpellText(oTarget, sMessage);
    SendMessageToPC(oCaster, GetName(oTarget) + " <cþÀ >affected by</c> <c• •>Chaos: " + sMessage + "</c>");
}

int _arGetCorrectSpellId(int nSpellId) {

    switch (nSpellId) {
        //::  Shadow Conjuration
        case SPELL_SHADOW_CONJURATION_DARKNESS:
        case SPELL_SHADOW_CONJURATION_INIVSIBILITY:
        case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:
        case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:
        case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:
        nSpellId = 159;
        break;

        //::  Greater Shadow Conjuration
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:
        case SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE:
        case SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE:
        case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:
        case SPELL_GREATER_SHADOW_CONJURATION_WEB:
        nSpellId = 71;
        break;

        //::  Shades
        case SPELL_SHADES_CONE_OF_COLD:
        case SPELL_SHADES_FIREBALL:
        case SPELL_SHADES_STONESKIN:
        case SPELL_SHADES_SUMMON_SHADOW:
        case SPELL_SHADES_WALL_OF_FIRE:
        nSpellId = 158;
        break;

        //::  Protection from Alignment
        case SPELL_PROTECTION_FROM_EVIL:
        case SPELL_PROTECTION_FROM_GOOD:
        nSpellId = 321;
        break;

        //::  Magic Circle against Alignment
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:
        nSpellId = 322;
        break;

        //::  Polymorph Self
        case 387:
        case 388:
        case 389:
        case 390:
        case 391:
        nSpellId = 130;
        break;

        //::  Shapechange
        case 392:
        case 393:
        case 394:
        case 395:
        case 396:
        nSpellId = 161;
        break;
    }

    return nSpellId;
}



void ar_ApplyChaosShieldEffect(object oCaster, object oTarget) {
    int nCasterLevel    = ar_GetHighestSpellCastingClassLevel(oCaster);
    int nDmg;
    int nDC             = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_ABJURATION, 7) + (nCasterLevel/6);
    int nValue          = 0;
    float nDuration     = 0f;
    int bIsPC           = GetIsPC(oTarget);
    int bIsImmune       = FALSE;


    effect eVis;
    effect eDur;
    effect eEffect;
    effect eDur2;

    int nSurge = d10();
    switch (nSurge) {
    //--------------------------------------------------------------------------
    //
    //                             CHAOS EFFECTS
    //
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // Stun
    //--------------------------------------------------------------------------
    case 1:
        eEffect = EffectStunned();
        eDur    = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
        eVis    = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
        eDur    = EffectLinkEffects(eEffect, eDur);
        nDuration = bIsPC ? RoundsToSeconds(d2()) : RoundsToSeconds(nCasterLevel/2);

        bIsImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_STUN, oCaster) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster);
        if ( GetIsCrowdControlImmune(oTarget) ||  bIsImmune) {
            SendMessageToPC(oCaster, "Target immune to <c• •>Chaos:</c> Stun");
            return;
        }

        if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Stun");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    break;

    //--------------------------------------------------------------------------
    // Fire Damage
    //--------------------------------------------------------------------------
    case 2:
        nDmg    = d6(nCasterLevel/2) + 1;
        eEffect = EffectDamage(nDmg, DAMAGE_TYPE_FIRE);
        eVis    = EffectBeam(444, oCaster, BODY_NODE_CHEST);
        eDur    = EffectVisualEffect(VFX_DUR_INFERNO);

        if ( MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE) ) nDmg = nDmg / 2;

        _arDoChaosMessage(oCaster, oTarget, "Fire");

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.0f);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, 4.0f));
    break;

    //--------------------------------------------------------------------------
    // Electrical Damage
    //--------------------------------------------------------------------------
    case 3:
        nDmg    = d8(nCasterLevel/2) + 1;
        eEffect = EffectDamage(nDmg, DAMAGE_TYPE_ELECTRICAL);
        eVis    = EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_CHEST);
        eDur    = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

        if ( MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE) ) nDmg = nDmg / 2;

        _arDoChaosMessage(oCaster, oTarget, "Electrical");

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.0f);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget));
    break;

    //--------------------------------------------------------------------------
    // Blindness
    //--------------------------------------------------------------------------
    case 4:
        eEffect = EffectBlindness();
        eDur2   = EffectVisualEffect(VFX_DUR_BLIND);
        eVis    = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
        eDur    = EffectLinkEffects(eEffect, eDur2);
        nDuration = bIsPC ? RoundsToSeconds(d2()) : RoundsToSeconds(nCasterLevel/2);

        bIsImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, oCaster);
        if ( bIsImmune ) {
            SendMessageToPC(oCaster, "Target immune to <c• •>Chaos:</c> Blindness");
            return;
        }

        if ( MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Blindness");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    break;

    //--------------------------------------------------------------------------
    // Slow
    //--------------------------------------------------------------------------
    case 5:
        eEffect = EffectSlow();
        eVis    = EffectVisualEffect(VFX_IMP_SLOW);
        eDur    = EffectVisualEffect(VFX_DUR_ICESKIN);
        eDur    = EffectLinkEffects (eEffect,eDur);
        nDuration = bIsPC ? RoundsToSeconds(d4()) : RoundsToSeconds(nCasterLevel);

        bIsImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW, oCaster);
        if ( GetIsCrowdControlImmune(oTarget) ||  bIsImmune) {
            SendMessageToPC(oCaster, "Target immune to <c• •>Chaos:</c> Slow");
            return;
        }

        if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Slow");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, nDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    break;

    //--------------------------------------------------------------------------
    // Knockdown
    //--------------------------------------------------------------------------
    case 6:
        eEffect   = EffectKnockdown();
        eVis      = EffectVisualEffect(VFX_IMP_STUN);
        nDuration = bIsPC ? 3.0f + d4() : 7.0f + d3();

        bIsImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN, oCaster);
        if ( bIsImmune ) {
            SendMessageToPC(oCaster, "Target immune to <c• •>Chaos:</c> Knockdown");
            return;
        }

        if ( MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Knockdown");

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, nDuration);
        }
    break;

    //--------------------------------------------------------------------------
    // Miss Chance
    //--------------------------------------------------------------------------
    case 7:
        eEffect = EffectMissChance(30+nCasterLevel, MISS_CHANCE_TYPE_VS_MELEE);
        eDur    = EffectVisualEffect(VFX_DUR_STONEHOLD);
        eDur    = EffectLinkEffects(eDur, eEffect);
        //eDur    = EffectLinkEffects(EffectCutsceneImmobilize(), eDur); //::  WTF?
        nDuration = bIsPC ? RoundsToSeconds(d3()) : RoundsToSeconds(nCasterLevel/2);

        if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Miss");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, nDuration);
        }
    break;

    //--------------------------------------------------------------------------
    // Sleep
    //--------------------------------------------------------------------------
    case 8:
        eEffect = EffectSleep();
        eVis    = EffectVisualEffect(VFX_IMP_SLEEP);
        nDuration = bIsPC ? RoundsToSeconds(d2()) : RoundsToSeconds(nCasterLevel/2);

        bIsImmune = GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP, oCaster) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster);
        if ( GetIsCrowdControlImmune(oTarget) ||  bIsImmune) {
            SendMessageToPC(oCaster, "Target immune to <c• •>Chaos:</c> Sleep");
            return;
        }

        if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Sleep");

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, nDuration);
        }
    break;

    //--------------------------------------------------------------------------
    //  AB Decrease (Oblivious)
    //--------------------------------------------------------------------------
    case 9:
        eEffect = EffectAttackDecrease(10 + nCasterLevel/2);
        eDur    = EffectVisualEffect(VFX_DUR_PIXIEDUST);
        eDur    = EffectLinkEffects(eDur, eEffect);
        nDuration = bIsPC ? RoundsToSeconds(d3()) : RoundsToSeconds(nCasterLevel/2);

         if ( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS) == FALSE ) {
            _arDoChaosMessage(oCaster, oTarget, "Oblivious");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, nDuration);
        }
    break;

    //--------------------------------------------------------------------------
    //  Cold Damage & Slow
    //--------------------------------------------------------------------------
    case 10:
        nDmg    = d6(nCasterLevel/2) + d6(3);
        eEffect = EffectDamage(nDmg, DAMAGE_TYPE_COLD);
        eVis    = EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_CHEST);
        eDur    = EffectVisualEffect(VFX_IMP_FROST_L);

        _arDoChaosMessage(oCaster, oTarget, "Cold");

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.0f);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
        DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget));

        bIsImmune = GetIsCrowdControlImmune(oTarget) || GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW, oCaster);

        //::  Slowed from Cold
        if ( !bIsImmune && MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD) == FALSE ) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectMovementSpeedDecrease(80), EffectVisualEffect(VFX_DUR_ICESKIN)), oTarget, RoundsToSeconds(d2()));
        }
    break;
    }
}
