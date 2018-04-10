/*
  Name: ar_sys_wildmagic
  Author: ActionReplay
  Date: 24 May 15
  Description:  Handles the Wild Magic feature used by "ar_sys_faerzress".
*/

//void main(){}


#include "ar_spellmatrix"
#include "ar_utils"
#include "gs_inc_state"
#include "inc_math"



const string AR_WM_CANCEL_NEXT  = "AR_WM_CANCEL_NEXT";       //::  So Spells created by the Wild Magic system does not trigger Wild Magic.
const string AR_DOUBLE_SURGE    = "AR_DOUBLE_SURGE";         //::  Flag so double surge can't happen again, and again and...

const string LOG_SURGE = "WMSURGE";   //:: For tracing


//::----------------------------------------------------------------------------
//:: DECLARATION
//::----------------------------------------------------------------------------

//:: Applies the appropriate Wild Magic effect based on a d100 roll.
//:: Not an internal function as it might want to be used externally from the system.
void ar_FaerzressWildMagicTable(object oPC, object oTarget, location lTarget, int nSpell, int nHarmful, int bCanReplenish = TRUE, int nFixedRoll = -1);

//::  Internal helper function for scaling of Gem Wild Surge (Too much logic to put in table!)
void _arCreateWMGems(object oPC, int nCasterLevel, int isWildMage);


//::----------------------------------------------------------------------------
//:: IMPLEMENTATION
//::----------------------------------------------------------------------------
void ar_FaerzressWildMagicTable(object oPC, object oTarget, location lTarget, int nSpell, int nHarmful, int bCanReplenish = TRUE, int nFixedRoll = -1) {
    //::  Spell cast by the Wild Magic system should not trigger Wild Magic
    if ( GetLocalInt(oPC, AR_WM_CANCEL_NEXT) == TRUE ) {
        DeleteLocalInt(oPC, AR_WM_CANCEL_NEXT);
        return;
    }

    //::  Table Roll
    int nRoll = d100();
    if ( nFixedRoll != -1 ) nRoll = nFixedRoll;

    effect eSpellVFX, eEff1, eEff2, eEff3, eEff4;

    int isFateActive    = GetLocalInt(oPC, "AR_FATE_ACTIVE");
    int nFateRoll       = GetLocalInt(oPC, "AR_FATE_USE");
    object oHide        = gsPCGetCreatureHide(oPC);
    int isWildMage      = GetLocalInt(oHide, "WILD_MAGE");
    int i, nDmg         = 0;
    int nCount          = 0;
    int nCasterLevel    = GetCasterLevel(oPC);
    if ( !isWildMage && nCasterLevel > 20 ) nCasterLevel = 20;  //::  Clamp Caster Level for Non-Wild Mages
    int nDC             = 10;
    float nDuration     = RoundsToSeconds(nCasterLevel);
    string sMessage     = "Surge vanished";
    string sResRef      = "";
    object oObject;     //::  Local var to be used in Switch-Case if needed.



    //::  Fate picks Roll from table
    if ( isFateActive && nFateRoll >= 1 && nFateRoll <= 100 ) {
        nRoll = nFateRoll;
        DeleteLocalInt (oPC, "AR_FATE_USE");
    } else if ( isFateActive ) {    //::  Fallback from Double Surges or reroll Table etc, so we dont get stuck in an endless loop
        DeleteLocalInt (oPC, "AR_FATE_ACTIVE");
        DeleteLocalInt (oPC, "AR_FATE_USE");
    }

    //::  Validate Target/Location
    string locationDebug = "Target/Location Data: ";
    if (!GetIsObjectValid(oTarget))                         locationDebug += "Target Invalid";
    else                                                    locationDebug += "Target Valid";

    if (!GetIsObjectValid(GetAreaFromLocation(lTarget)))    locationDebug += " | Location Invalid";
    else                                                    locationDebug += " | Location Valid";


    //::  DEBUG
    /*
    nRoll = GetLocalInt(oPC, "AR_SURGE_TEST");
    string sDebugMsg = "----------\nSpell Data\n";
    if ( GetIsObjectValid(oTarget) )                            sDebugMsg += "Target: " + GetName(oTarget) + "\n";
    else                                                        sDebugMsg += "Target is INVALID\n";
    if ( GetIsObjectValid( GetAreaFromLocation(lTarget)) )      sDebugMsg += "Location is Valid\n";
    else                                                        sDebugMsg += "Location is INVALID\n";
    sDebugMsg += "Spell Harmful: " + (nHarmful == TRUE ? "YES" : "NO") + "\n----------\n\n";
    SendMessageToPC(oPC, sDebugMsg);
    */

    switch(nRoll) {
    //--------------------------------------------------------------------------
    //
    //                              NEGATIVE EFFECTS
    //
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // Drunken Stupor (Caster) Will lower Sobriety
    //--------------------------------------------------------------------------
    case 1:
        sMessage    = "Hic Hic";
        nDuration   = RoundsToSeconds(nCasterLevel/2);
        eSpellVFX   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        eEff1       = EffectConfused();
        eEff2       = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
        eEff3       = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 2);
        eEff4       = EffectAbilityDecrease(ABILITY_WISDOM, 2);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 2);

        if ( WillSave(oPC, nDC) == 0) {
            PlayVoiceChat(VOICE_CHAT_LAUGH, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff2, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff3, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff4, oPC, nDuration);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oPC, nDuration);
            AssignCommand(oPC, gsSTAdjustState(GS_ST_SOBRIETY, -60.0) );
        }
    break;
    //--------------------------------------------------------------------------
    // Fireball on Caster
    //--------------------------------------------------------------------------
    case 2:
        sMessage    = "Fireball: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_FIREBALL);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 3);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectKnockdown(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, 3.0, nDmg, DAMAGE_TYPE_FIRE, SHAPE_SPHERE, RADIUS_SIZE_HUGE);
    break;
    //--------------------------------------------------------------------------
    // Status Effect: Hold  (Caster - 3 Rounds - No Save!)
    //--------------------------------------------------------------------------
    case 3:
    case 4:
        sMessage    = "Hold: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
        eEff1       = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PARALYZED), EffectParalyze());
        nDuration   = RoundsToSeconds(3);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), eEff1), oPC, nDuration));
    break;
    //--------------------------------------------------------------------------
    // Polymorphed into a Cow (Caster)- No Save!
    //--------------------------------------------------------------------------
    case 5:
        sMessage    = "Polymorphed: Cow (Caster)";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_POLYMORPH);
        eEff1       = EffectPolymorphEx(POLYMORPH_TYPE_COW, TRUE, oPC);
        nDuration   = RoundsToSeconds(2);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        if ( !ar_GetSpellImmune(oPC, oPC) )
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration));
    break;
    //--------------------------------------------------------------------------
    // Sunstrike (Caster)
    //--------------------------------------------------------------------------
    case 6:
        sMessage    = "Sunstrike: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUNBEAM);
        nDmg        = nCasterLevel > 20 ? d6(20) : d6(nCasterLevel);
        nDuration   = RoundsToSeconds(3);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 8);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectBlindness(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, nDuration, nDmg, DAMAGE_TYPE_DIVINE, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL);
    break;
    //--------------------------------------------------------------------------
    // Caster is on fire!
    //--------------------------------------------------------------------------
    case 7:
        sMessage    = "I'm on fire!";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_FLAME_M);
        nDuration   = RoundsToSeconds(4 + d4());
        nDmg        = d6(nCasterLevel/3);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
        _arDoSingleSpell(oPC, eSpellVFX, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 25), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, -1, nDuration, nDmg, DAMAGE_TYPE_FIRE, VFX_DUR_INFERNO);
    break;
    //--------------------------------------------------------------------------
    // Loud Noise (Caster)
    //--------------------------------------------------------------------------
    case 8:
        sMessage    = "Loud Noise: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SOUND_BURST);
        nDuration   = RoundsToSeconds(nCasterLevel/2);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ILLUSION, 2);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectDeaf(), SAVING_THROW_FORT, SAVING_THROW_TYPE_SONIC, nDC, nDuration, 0, DAMAGE_TYPE_NEGATIVE, SHAPE_SPHERE, RADIUS_SIZE_LARGE, TRUE, VFX_IMP_BLIND_DEAF_M);
    break;
    //--------------------------------------------------------------------------
    // Status Effect: Hold  (2 Rounds - No Save!)
    //--------------------------------------------------------------------------
    case 9:
        sMessage    = "Hold: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
        eEff1       = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PARALYZED), EffectParalyze());
        nDuration   = RoundsToSeconds(2);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), eEff1), oPC, nDuration));
    break;
    //--------------------------------------------------------------------------
    // Heal (Target)
    //--------------------------------------------------------------------------
    case 10:
        sMessage    = "Heal: Target";
        if ( !GetIsObjectValid(oTarget) ) oTarget = oPC;
        DelayCommand(1.0, ar_DoHealSpell(oTarget));
    break;
    //--------------------------------------------------------------------------
    // Haste (Target)
    //--------------------------------------------------------------------------
    case 11:
        sMessage    = "Haste: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HASTE);
        eEff1       = EffectHaste();

        if ( !GetIsObjectValid(oTarget) ) oTarget = oPC;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Gate
    //--------------------------------------------------------------------------
    case 12:
        sMessage    = "Gate - Run!!! ";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_GATE);

        if (d2() != 1 || nCasterLevel < 13)  sMessage = "Gate vanished";
        else {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget, nDuration);
            DelayCommand(4.0, _arSummonDemon("demon001", lTarget));
        }
    break;
    //--------------------------------------------------------------------------
    // Gate Rifts
    //--------------------------------------------------------------------------
    case 13:
        sMessage    = "Gate to the Rifts - Run!!! ";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
        eEff1       = EffectVisualEffect(VFX_FNF_WEIRD);

        if (d3() != 1)  sMessage = "Gate vanished";
        else {
            sResRef = "ar_ob_glabrezu";

            //::  Scale summon based on Caster Level
            if ( nCasterLevel < 5 )          sResRef = "ar_cr_manes";
            else if ( nCasterLevel < 10 )    sResRef = "ar_cr_ghour";
            else if ( nCasterLevel < 15 )    sResRef = "ar_ob_retriever";

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget, nDuration);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEff1, lTarget, nDuration);
            DelayCommand(4.0, _arSummonDemon(sResRef, lTarget));
        }
    break;
    //--------------------------------------------------------------------------
    // Sleep (Caster)
    //--------------------------------------------------------------------------
    case 14:
        sMessage    = "Sleep: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SLEEP);
        nDuration   = RoundsToSeconds(nCasterLevel/2);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ILLUSION, 2);

        _arDoSingleSpell(oPC, eSpellVFX, EffectSleep(), SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, nDC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Slip (Caster)
    //--------------------------------------------------------------------------
    case 15:
        sMessage    = "Oops!  I slipped!";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_ACID_L);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 6.0);
    break;
    //--------------------------------------------------------------------------
    // Lightning (Caster)
    //--------------------------------------------------------------------------
    case 16:
        sMessage    = "Lightning: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 3);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, 6.0, nDmg, DAMAGE_TYPE_ELECTRICAL, SHAPE_SPHERE, RADIUS_SIZE_LARGE);
    break;
    //--------------------------------------------------------------------------
    // Thunderclap (Caster)
    //--------------------------------------------------------------------------
    case 17:
        sMessage    = "Thunderclap: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 7);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, RoundsToSeconds(2), nDmg, DAMAGE_TYPE_SONIC, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL);
    break;
    //--------------------------------------------------------------------------
    // Spikes (Caster)
    //--------------------------------------------------------------------------
    case 18:
        sMessage    = "Spikes: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_CONJURATION, 2);
        nDmg        = d6(nCasterLevel/2);

        _arDoSingleSpell(oPC, eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, 3.0, nDmg, DAMAGE_TYPE_PIERCING);
    break;
    //--------------------------------------------------------------------------
    // Mass Elemental Shield (AoE - Affects everyone)
    //--------------------------------------------------------------------------
    case 19:
        sMessage    = "Mass Elemental Shield";

        if ( !GetIsObjectValid(oTarget) ) {
            oTarget  = oPC;
        }

        ar_SpellMassElementalShield(oPC, oTarget, TRUE, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Summon Rock (Not the creature but an actual rock...)
    //--------------------------------------------------------------------------
    case 20:
        sMessage    = "Summon: Rock";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget, nDuration);
        DelayCommand(4.0, _arSummonDemon("gs_placeable419", lTarget, OBJECT_TYPE_PLACEABLE));
    break;
    //--------------------------------------------------------------------------
    //  Useless Rocks!
    //--------------------------------------------------------------------------
    case 21:
        sMessage    = "Useless Rocks!";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_STONEHOLD);
        nCount      = nCasterLevel / 3;
        if (nCount > 8) nCount = 8;

        if ( !GetIsObjectValid(oTarget) ) oTarget = oPC;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oTarget, 6.0f);

        for (i = 0; i < nCount; i++) {
            CreateItemOnObject("ar_bad_rock", oTarget);
        }
    break;
    //--------------------------------------------------------------------------
    // Sparkles! (Target)
    //--------------------------------------------------------------------------
    case 22:
        sMessage    = "Make Pretty Sparkles!";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_IOUNSTONE_YELLOW);
        eEff1       = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);

        if ( !GetIsObjectValid(oTarget) ) oTarget = oPC;
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oTarget, nDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Polymorph Chicken AoE (Caster)
    //--------------------------------------------------------------------------
    case 23:
        sMessage    = "Polymorphed: Chicken (Caster - Area of Effect)";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        nDuration   = RoundsToSeconds(4 + d4());
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 4);

        _arDoAoeSpell(GetLocation(oPC), eSpellVFX, EffectPolymorph(POLYMORPH_TYPE_SUPER_CHICKEN, TRUE), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_ELECTRICAL, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN);
    break;
    //--------------------------------------------------------------------------
    // Deaf (Caster) - No Save!
    //--------------------------------------------------------------------------
    case 24:
        sMessage    = "Deaf: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
        eEff1       = EffectDeaf();
        eEff2       = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
        nDuration   = RoundsToSeconds(nCasterLevel/2);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff2, oPC);
    break;
    //--------------------------------------------------------------------------
    // Teleport (Caster) to target Location
    //--------------------------------------------------------------------------
    case 25:
        sMessage    = "Teleport: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_AC_BONUS);

        //::  As it can be abused.
        if (isFateActive) {
            sMessage = "Surge vanished";
            SendMessageToPC(oPC, "Teleportation can not be used by Fatidical Manipulation.");
        }
        else {
            SetLocalInt(oPC, AR_WM_CANCEL_NEXT, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
            DelayCommand(1.0, AssignCommand(oPC, ClearAllActions(TRUE)));
            DelayCommand(1.2, AssignCommand(oPC, JumpToLocation(lTarget)));
            DelayCommand(1.4, AssignCommand(oPC, ClearAllActions(TRUE)));
            DelayCommand(8.0, DeleteLocalInt(oPC, AR_WM_CANCEL_NEXT) );
        }
    break;
    //--------------------------------------------------------------------------
    // Imprisonment (Caster)
    //--------------------------------------------------------------------------
    case 26:
        sMessage    = "Imprisonment: Caster";
        eEff1       = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ABJURATION, 9);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oPC) );
        DelayCommand(1.5, ar_SpellImprisonment(oPC, oPC, nDC, FALSE, FALSE) );
    break;
    //--------------------------------------------------------------------------
    // Hungry (Caster)
    //--------------------------------------------------------------------------
    case 27:
        sMessage    = "I'm so Hungry!";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oPC) );
        AssignCommand(oPC, gsSTAdjustState(GS_ST_FOOD, -30.0) );
    break;
    //--------------------------------------------------------------------------
    // Thristy (Caster)
    //--------------------------------------------------------------------------
    case 28:
        sMessage    = "I'm so Thirsty!";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oPC) );
        AssignCommand(oPC, gsSTAdjustState(GS_ST_WATER, -30.0) );
    break;
    //--------------------------------------------------------------------------
    // Random Polymorph AoE Spell on Caster (Affects everyone!)
    //--------------------------------------------------------------------------
    case 29:
        sMessage    = "Oooh No!";
        eSpellVFX   = EffectAreaOfEffect(AOE_PER_FOGMIND, "ar_polyaoe_a", "ar_polyaoe_c", "****");
        nDuration   = RoundsToSeconds(2 + nCasterLevel/3);

        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSpellVFX, GetLocation(oPC), nDuration);
    break;
    //--------------------------------------------------------------------------
    // Destroy Gold (Caster)
    //--------------------------------------------------------------------------
    case 30:
        sMessage    = "Destroy Gold: Caster";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oPC) );
        AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC)/2, oPC, TRUE));
    break;
    //--------------------------------------------------------------------------
    // Rothe Horde
    //--------------------------------------------------------------------------
    case 31:
        sMessage    = "Rothe Horde";
        nCount      = 2 + nCasterLevel/4;
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget);
        for (i = 0; i < nCount; i++) {
            CreateObject(OBJECT_TYPE_CREATURE, "ar_cr_drowrot001", lTarget);
        }
    break;
    //--------------------------------------------------------------------------
    // Exploding Cow
    //--------------------------------------------------------------------------
    case 32:
        sMessage    = "Exploding Cow - Uh oh!";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget);
        oObject = CreateObject(OBJECT_TYPE_CREATURE, "ar_exploding_cow", lTarget);
        SetLocalObject(oObject, "AR_CASTER", oPC);
    break;
    //--------------------------------------------------------------------------
    // Invisible Target
    //--------------------------------------------------------------------------
    case 33:
        sMessage    = "Invisible: Target";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        eEff1       = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

        if ( !GetIsObjectValid(oTarget) ) oTarget = oPC;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Pretty Sparkles
    //--------------------------------------------------------------------------
    case 34:
        sMessage    = "Pretty Sparkles!";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
        eEff1       = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
        eEff2       = EffectVisualEffect(VFX_FNF_BLINDDEAF);
        eEff3       = EffectVisualEffect(VFX_FNF_DECK);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC));
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff2, oPC));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff3, oPC));
    break;
    //--------------------------------------------------------------------------
    // Glow caster
    //--------------------------------------------------------------------------
    case 35:
        sMessage    = "Am I...  glowing?";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_AURA_MAGENTA);
        nDuration   = TurnsToSeconds(nCasterLevel/2);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Butterflies
    //--------------------------------------------------------------------------
    case 36:
        sMessage    = "Aaah!  Butterflies!";
        if (d3() == 1) sMessage = "Yaaay!  Butterflies!";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        eEff1       = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
        DelayCommand(3.0, _arSummonDemon("plc_butterflies", GetLocation(oPC), OBJECT_TYPE_PLACEABLE));
    break;
    //--------------------------------------------------------------------------
    // Glow Target
    //--------------------------------------------------------------------------
    case 37:
        sMessage    = "Are you...  glowing?";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_GREEN);
        nDuration   = TurnsToSeconds(nCasterLevel/2);

        if ( !GetIsObjectValid(oTarget) ) {
            oTarget = oPC;
            sMessage = "Am I...  glowing?";
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Change Weather (Snowing)
    //--------------------------------------------------------------------------
    case 38:
        sMessage    = "Snowing";
        eEff1       = EffectVisualEffect(VFX_FNF_BLINDDEAF);

        if ( GetIsAreaInterior(GetArea(oPC)) ) {
            sMessage = "Surge vanished";
            SendMessageToPC(oPC, "Weather can not affect interior areas.");
        }
        else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
            SetWeather( GetArea(oPC), WEATHER_SNOW);
        }
    break;
    //--------------------------------------------------------------------------
    // Disease (Caster)
    //--------------------------------------------------------------------------
    case 39:
        sMessage    = "Disease: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_DISEASE_S);
        nDC         = d2() == 1 ? ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_NECROMANCY, 4) : -1;    //::  Safety Roll?  Sometimes :)

        if (d2() == 0)  _arDoSingleSpell(oPC, eSpellVFX, EffectDisease(DISEASE_MINDFIRE), SAVING_THROW_FORT, SAVING_THROW_TYPE_DISEASE, nDC, -1.0);
        else            _arDoSingleSpell(oPC, eSpellVFX, EffectDisease(DISEASE_RED_ACHE), SAVING_THROW_FORT, SAVING_THROW_TYPE_DISEASE, nDC, -1.0);
    break;
    //--------------------------------------------------------------------------
    // Slow (Caster)
    //--------------------------------------------------------------------------
    case 40:
        sMessage    = "Slow: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
        eEff1       = EffectVisualEffect(VFX_IMP_SLOW);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 3);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
        _arDoSingleSpell(oPC, eSpellVFX, EffectSlow(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Exploding Cows Horde
    //--------------------------------------------------------------------------
    case 41:
        sMessage    = "Exploding Cow Horde - Really?";
        nCount      = 2 + nCasterLevel/4;
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget);
        for (i = 0; i < nCount; i++) {
            oObject = CreateObject(OBJECT_TYPE_CREATURE, "ar_exploding_cow", lTarget);
            SetLocalObject(oObject, "AR_CASTER", oPC);
        }
    break;
    //--------------------------------------------------------------------------
    // Sleep (Caster) - 3 Rounds No Save!
    //--------------------------------------------------------------------------
    case 42:
        sMessage    = "Sleep: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SLEEP);
        nDuration   = RoundsToSeconds(3);

        _arDoSingleSpell(oPC, eSpellVFX, EffectSleep(), SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, -1, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Panic (Caster) - 3-6 Rounds No Save!
    //--------------------------------------------------------------------------
    case 43:
        sMessage    = "Panic!";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
        nDuration   = RoundsToSeconds(3 + d3());

        ApplyFear(oPC, 10, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Curse (Caster) - Random Turns No Save!
    //--------------------------------------------------------------------------
    case 44:
        sMessage    = "Curse: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        nDuration   = TurnsToSeconds(6 + d10());

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(), oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Silenced (Caster) - 10 Rounds No Save!
    //--------------------------------------------------------------------------
    case 45:
        sMessage    = "Silenced: Caster - Mmm-bm'ghh!";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SOUND_BURST);
        nDuration   = RoundsToSeconds(10);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSilence(), oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Caster forgets how to cast spells - 10 Rounds No Save!
    //--------------------------------------------------------------------------
    case 46:
        sMessage    = "How do I cast spells again?";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_PWKILL);
        nDuration   = RoundsToSeconds(10);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, MagicalEffect(EffectSpellFailure()), oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Maniac Laughing
    //--------------------------------------------------------------------------
    case 47:
        sMessage    = "Hahahaha!";

        ClearAllActions(TRUE);
        PlayVoiceChat(VOICE_CHAT_LAUGH, oPC);
        DelayCommand(3.0, ClearAllActions(TRUE));
        DelayCommand(3.5, PlayVoiceChat(VOICE_CHAT_LAUGH, oPC));
        DelayCommand(5.0, PlayVoiceChat(VOICE_CHAT_LAUGH, oPC));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, MagicalEffect(EffectSpellFailure()), oPC, 6.0);
    break;
    //--------------------------------------------------------------------------
    // Spell Turning:  Spel works as normal but the Target fires back the same spell
    //--------------------------------------------------------------------------
    case 48:
        sMessage    = "Spell Turning: Target";
        ar_CopySpellTurning(oPC, oTarget, lTarget, nSpell);
    break;
    //--------------------------------------------------------------------------
    // A Strange Noise can be heard
    //--------------------------------------------------------------------------
    case 49:
        sMessage    = "Strange Noise";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_BARD_SONG);

        i = d4();
        if (i == 1)         PlaySound("as_pl_whistle1");
        else if (i == 2)    PlaySound("as_pl_whistle2");
        else if (i == 3)    PlaySound("as_cv_belltower3");
        else                PlaySound("as_an_cows1");

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oPC, 6.0);
    break;


    //--------------------------------------------------------------------------
    //
    //                              POSITIVE EFFECTS
    //
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // Elemental Immunity (Caster) - Cold, Fire or Electrical
    //--------------------------------------------------------------------------
    case 50:
        sMessage    = "Elemental Immunity (Caster)";
        nDuration   = HoursToSeconds(nCasterLevel/3);
        i           = d3();
        eSpellVFX   = EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE);

        if (i == 1)         eEff1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
        else if (i == 2)    eEff1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
        else                eEff1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eSpellVFX, eEff1), oPC);
    break;
    //--------------------------------------------------------------------------
    // Fireball (Location)
    //--------------------------------------------------------------------------
    case 51:
        sMessage    = "Fireball: Location";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_FIREBALL);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 3);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectKnockdown(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, 3.0, nDmg, DAMAGE_TYPE_FIRE, SHAPE_SPHERE, RADIUS_SIZE_HUGE, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Slow (Location)
    //--------------------------------------------------------------------------
    case 52:
        sMessage    = "Slow: Location";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 3);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectSlow(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_FIRE, SHAPE_SPHERE, RADIUS_SIZE_LARGE, FALSE, VFX_IMP_SLOW, TRUE);
    break;
    //--------------------------------------------------------------------------
    // Polymorphed into a Wolf (With speed gain!)
    //--------------------------------------------------------------------------
    case 53:
        sMessage    = "Polymorphed: Wolf";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_POLYMORPH);
        eEff1       = EffectPolymorphEx(POLYMORPH_TYPE_WOLF, FALSE, oPC);
        eEff2       = EffectLinkEffects(eEff1, EffectMovementSpeedIncrease(70));
        eEff3       = EffectLinkEffects(EffectAttackIncrease(nCasterLevel/3), EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING));
        nDuration   = HoursToSeconds(nCasterLevel/2);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eEff2, eEff3), oPC, nDuration) );
    break;
    //--------------------------------------------------------------------------
    // Shockwave (Location)
    //--------------------------------------------------------------------------
    case 54:
        sMessage    = "Shockwave: Location";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 4);
        nDuration   = RoundsToSeconds(1);

        DelayCommand(1.0, _arDoAoeSpell(lTarget, eSpellVFX, EffectKnockdown(), SAVING_THROW_FORT, SAVING_THROW_TYPE_SONIC, nDC, nDuration, d3(nCasterLevel), DAMAGE_TYPE_SONIC, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, FALSE, VFX_DUR_MIND_AFFECTING_DISABLED));
    break;
    //--------------------------------------------------------------------------
    // Hindsight (True Seeing and Area Explored)
    //--------------------------------------------------------------------------
    case 55:
        sMessage    = "Hindsight";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        eSpellVFX   = EffectLinkEffects(EffectVisualEffect(VFX_IMP_MAGICAL_VISION),  EffectTrueSeeing());
        nDuration   = TurnsToSeconds(nCasterLevel);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oPC, nDuration);
        ExploreAreaForPlayer( GetArea(oPC), oPC, TRUE );
    break;
    //--------------------------------------------------------------------------
    // Invisible Caster  (Improved)
    //--------------------------------------------------------------------------
    case 56:
        sMessage    = "Invisible: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        eEff1       = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
        nDuration   = TurnsToSeconds(nCasterLevel);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Gems added to caster
    //--------------------------------------------------------------------------
    case 57:
        sMessage    = "Huh? Gems?!";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);

        if (isFateActive) {
            sMessage = "Surge vanished";
            SendMessageToPC(oPC, "Wealth can not be gained by Fatidical Manipulation.");
        }
        else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
            _arCreateWMGems(oPC, nCasterLevel, isWildMage);
        }
    break;
    //--------------------------------------------------------------------------
    // Combat Ready Bonus
    //--------------------------------------------------------------------------
    case 58:
        sMessage    = "Combat Ready";
        nDuration   = HoursToSeconds(nCasterLevel);
        eSpellVFX   = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
        eEff1       = EffectLinkEffects(EffectVisualEffect(VFX_DUR_IOUNSTONE_GREEN), EffectAbilityIncrease(ABILITY_STRENGTH, 6+d6()));
        eEff1       = EffectLinkEffects(eEff1, EffectDamageIncrease(DamageBonusConstant(nCasterLevel/2 + d4()), DAMAGE_TYPE_BLUDGEONING));
        eEff1       = EffectLinkEffects(eEff1, EffectAttackIncrease(nCasterLevel/2));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oPC);
    break;
    //--------------------------------------------------------------------------
    // Caster receives full Spell Resistance
    //--------------------------------------------------------------------------
    case 59:
        sMessage    = "Spell Immunity";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
        nDuration   = TurnsToSeconds(nCasterLevel);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(eSpellVFX, EffectSpellResistanceIncrease(80)), oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Heal caster
    //--------------------------------------------------------------------------
    case 60:
        sMessage    = "Heal: Caster";
        DelayCommand(1.0, ar_DoHealSpell(oPC));
    break;
    //--------------------------------------------------------------------------
    // Flesh to Stone (Target)
    //--------------------------------------------------------------------------
    case 61:
        sMessage    = "Flesh To Stone: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 6);
        nDuration   = TurnsToSeconds(nCasterLevel/2);

        //::  Fallback if Caster
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 59);
            return;
        }
        else    _arDoSingleSpell(oTarget, eSpellVFX, EffectPetrify(), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Sunstrike (Target)
    //--------------------------------------------------------------------------
    case 62:
        sMessage    = "Sunstrike: Target";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_SUNBEAM);
        nDmg        = nCasterLevel > 20 ? d6(20) : d6(nCasterLevel);
        nDuration   = RoundsToSeconds(3);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 8);

        if ( GetIsObjectValid(oTarget) ) lTarget = GetLocation(oTarget);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectBlindness(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, nDuration, nDmg, DAMAGE_TYPE_DIVINE, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Blindness (Target)
    //--------------------------------------------------------------------------
    case 63:
        sMessage    = "Blindness: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        eEff1       = EffectVisualEffect(VFX_FNF_BLINDDEAF);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ENCHANTMENT, 2);

        if ( GetIsObjectValid(oTarget) ) lTarget = GetLocation(oTarget);

        if ( oTarget == oPC )                   _arDoAoeSpell(lTarget, eEff1, EffectBlindness(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_DIVINE, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, FALSE, VFX_DUR_BLINDVISION);
        else if ( GetIsObjectValid(oTarget) )   _arDoSingleSpell(oTarget, eSpellVFX, EffectBlindness(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_FIRE, VFX_DUR_BLINDVISION);
    break;
    //--------------------------------------------------------------------------
    // Effulgent Epuration (Caster)
    //--------------------------------------------------------------------------
    case 64:
        sMessage    = "Effulgent Epuration: Caster";

        eSpellVFX   = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);

        DelayCommand(1.0, ar_SpellEffulgentEpuration(oPC, FALSE));
    break;
    //--------------------------------------------------------------------------
    // Movement Rate reduced (Target) - No Save!
    //--------------------------------------------------------------------------
    case 65:
        sMessage    = "Slowed: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SLOW);
        eEff1       = EffectMovementSpeedDecrease(80);

        //::  Fallback if Caster
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 71);
            return;
        }
        else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oTarget, nDuration);
        }
    break;
    //--------------------------------------------------------------------------
    // Polymorphed into a Cow (Target) - No Save!  Using Fate forces Save.
    //--------------------------------------------------------------------------
    case 66:
        sMessage    = "Polymorphed: Cow (Target)";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_POLYMORPH);
        eEff1       = EffectPolymorphEx(POLYMORPH_TYPE_COW, TRUE, oTarget);
        nDuration   = RoundsToSeconds(4 + d4());
        nDC         = isFateActive ? ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 5) : -1;

        //::  Fallback if Caster
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 69);
            return;
        }
        else {
            _arDoSingleSpell(oTarget, eSpellVFX, eEff1, SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration);
        }
    break;
    //--------------------------------------------------------------------------
    // Dizzy (AOE - Target)
    //--------------------------------------------------------------------------
    case 67:
        sMessage    = "Dizzy: Target (Area of Effect)";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ILLUSION, 5);

        if ( GetIsObjectValid(oTarget) ) lTarget = GetLocation(oTarget);

        DelayCommand(1.0, _arDoAoeSpell(lTarget, eSpellVFX, EffectConfused(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_DIVINE, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, FALSE, VFX_DUR_MIND_AFFECTING_NEGATIVE));
    break;
    //--------------------------------------------------------------------------
    // Polymorphed into a Zombie (Target) - No Save!  Using Fate forces Save.
    //--------------------------------------------------------------------------
    case 68:
        sMessage    = "Polymorphed: Zombie (Target)";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_POLYMORPH);
        eEff1       = EffectPolymorphEx(POLYMORPH_TYPE_ZOMBIE, TRUE, oTarget);
        nDuration   = RoundsToSeconds(4 + d4());
        nDC         = isFateActive ? ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 6) : -1;

        //::  Fallback if Caster
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 69);
            return;
        }
        else {
            _arDoSingleSpell(oTarget, eSpellVFX, eEff1, SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration);
        }
    break;
    //--------------------------------------------------------------------------
    // Haste (Caster)
    //--------------------------------------------------------------------------
    case 69:
        sMessage    = "Haste: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HASTE);
        eEff1       = EffectHaste();
        nDuration   = TurnsToSeconds(nCasterLevel/2);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Wish - Summons a Djinni
    //--------------------------------------------------------------------------
    case 70:
        sMessage    = "Wish";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        eEff1       = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellVFX, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEff1, lTarget);
        DelayCommand(4.0, _arSummonDemon("ar_djinni", lTarget));
    break;
    //--------------------------------------------------------------------------
    // Gold added to caster
    //--------------------------------------------------------------------------
    case 71:
        sMessage     = "Oooh!  Gold!";
        eSpellVFX    = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        nCasterLevel = !isWildMage ? nCasterLevel/2 : nCasterLevel;

        if (isFateActive) {
            sMessage = "Surge vanished";
            SendMessageToPC(oPC, "Wealth can not be gained by Fatidical Manipulation.");
        }
        else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
            GiveGoldToCreature(oPC, 100 * nCasterLevel);
        }
    break;
    //--------------------------------------------------------------------------
    // Stun (2 Rounds - AoE) (AoE Target) - No Save!  Using Fate forces Save.
    //--------------------------------------------------------------------------
    case 72:
        sMessage    = "Stun: Target (Area of Effect)";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_PWSTUN);
        nDuration   = RoundsToSeconds(2);
        nDC         = isFateActive ? ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_DIVINATION, 7) : -1;

        if ( GetIsObjectValid(oTarget) ) lTarget = GetLocation(oTarget);

        DelayCommand(1.0, _arDoAoeSpell(lTarget, eSpellVFX, EffectStunned(), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_DIVINE, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, FALSE, VFX_DUR_MIND_AFFECTING_DISABLED));
    break;
    //--------------------------------------------------------------------------
    // Web (Target)
    //--------------------------------------------------------------------------
    case 73:
        sMessage    = "Web: Target";
        eSpellVFX   = EffectAreaOfEffect(AOE_PER_WEB, "****", "nw_s0_webc", "nw_s0_webb");
        nDuration   = RoundsToSeconds(nCasterLevel/2);

        if ( GetIsObjectValid(oTarget) ) lTarget = GetLocation(oTarget);

        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSpellVFX, lTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Sleep (3 Rounds) (Target) - No Save!  Using Fate forces Save.
    //--------------------------------------------------------------------------
    case 74:
        sMessage    = "Sleep: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SLEEP);
        nDuration   = RoundsToSeconds(3);
        nDC         = isFateActive ? ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ENCHANTMENT, 1) + d6() : -1;

        //::  Roll on the Table again as fallback
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish );
            return;
        }
        else _arDoSingleSpell(oTarget, eSpellVFX, EffectSleep(), SAVING_THROW_WILL, SAVING_THROW_TYPE_MIND_SPELLS, nDC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Lightning (Target)
    //--------------------------------------------------------------------------
    case 75:
        sMessage    = "Lightning: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 3);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, 6.0, nDmg, DAMAGE_TYPE_ELECTRICAL, SHAPE_SPHERE, RADIUS_SIZE_LARGE, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Thunderclap (Target)
    //--------------------------------------------------------------------------
    case 76:
        sMessage    = "Thunderclap: Target";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        nDmg        = nCasterLevel > 10 ? d6(10) : d6(nCasterLevel);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_EVOCATION, 7);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, RoundsToSeconds(2), nDmg, DAMAGE_TYPE_SONIC, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Spikes (Target)
    //--------------------------------------------------------------------------
    case 77:
        sMessage    = "Spikes: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_CONJURATION, 2);
        nDmg        = d6(nCasterLevel/2);

        //::  Roll on the Table again as fallback
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish );
            return;
        }
        else _arDoSingleSpell(oTarget, eSpellVFX, EffectKnockdown(), SAVING_THROW_REFLEX, SAVING_THROW_TYPE_NONE, nDC, 3.0, nDmg, DAMAGE_TYPE_PIERCING);
    break;
    //--------------------------------------------------------------------------
    // Damage Shield (Caster) - Can vary element
    //--------------------------------------------------------------------------
    case 78:
        sMessage    = "Damage Shield: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
        nDuration   = TurnsToSeconds(nCasterLevel/2);
        nDmg        = 4 + d4(nCasterLevel/4);

        i = d3();
        if ( i == 1 )       eEff1 = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_FIRE);
        else if (i == 2)    eEff1 = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_COLD);
        else if (i == 3)    eEff1 = EffectDamageShield(nDmg, DAMAGE_BONUS_6, DAMAGE_TYPE_ELECTRICAL);

        eEff2 = EffectLinkEffects(eSpellVFX, eEff1);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff2, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Iceskin (Caster)
    //--------------------------------------------------------------------------
    case 79:
        sMessage    = "Iceskin: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_DUR_ICESKIN);
        eEff1       = EffectLinkEffects(EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO, nCasterLevel*10), EffectDamageResistance(DAMAGE_TYPE_COLD, 30));
        eEff2       = EffectLinkEffects(eSpellVFX, eEff1);
        nDuration   = HoursToSeconds(nCasterLevel/2);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff2, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Polymorph Chicken AoE (Target)
    //--------------------------------------------------------------------------
    case 80:
        sMessage    = "Polymorphed: Chicken (Target - Area of Effect)";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        nDuration   = RoundsToSeconds(4 + d4());
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_TRANSMUTATION, 4);

        _arDoAoeSpell(lTarget, eSpellVFX, EffectPolymorph(POLYMORPH_TYPE_SUPER_CHICKEN, TRUE), SAVING_THROW_WILL, SAVING_THROW_TYPE_NONE, nDC, nDuration, 0, DAMAGE_TYPE_ELECTRICAL, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Super Speed (Caster)
    //--------------------------------------------------------------------------
    case 81:
        nDmg        = !isWildMage ? 65 : 95;
        sMessage    = "Super Speed: Caster";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HASTE);
        eEff1       = EffectMovementSpeedIncrease(nDmg);
        nDuration   = RoundsToSeconds(4 + nCasterLevel);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff1, oPC, nDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
    break;
    //--------------------------------------------------------------------------
    // Mass Energy Buffer
    //--------------------------------------------------------------------------
    case 82:
        sMessage    = "Mass Energy Buffer";

        DelayCommand(1.0, ar_SpellMassEnergyBuffer(oPC, FALSE));
    break;
    //--------------------------------------------------------------------------
    // Depth Surge (Caster)
    //--------------------------------------------------------------------------
    case 83:
        sMessage    = "Depth Surge: Caster";

        DelayCommand(1.0, ar_SpellDepthSurge(oPC, FALSE));
    break;
    //--------------------------------------------------------------------------
    // Imprisonment (Target)
    //--------------------------------------------------------------------------
    case 84:
        sMessage    = "Imprisonment: Target";
        eEff1       = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_ABJURATION, 9);

        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {   //::  Fallback:  Freedom of Movement
            sMessage  = "Freedom of Movement: Target";
            eSpellVFX = EffectLinkEffects( EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), EffectImmunity(IMMUNITY_TYPE_ENTANGLE)),  EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_PARALYSIS), EffectImmunity(IMMUNITY_TYPE_SLOW)) );
            nDuration = TurnsToSeconds(nCasterLevel/2);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellVFX, oPC, nDuration);
        }
        else {
            ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oTarget) );
            ar_SpellImprisonment(oPC, oTarget, nDC, FALSE, FALSE);
        }
    break;
    //--------------------------------------------------------------------------
    // Disarm Nearest Trap
    //--------------------------------------------------------------------------
    case 85:
        sMessage    = "Disarm Trap";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
        eEff2       = EffectVisualEffect(VFX_IMP_KNOCK);

        oObject = GetNearestTrapToObject(oPC, FALSE);
        if ( GetIsObjectValid(oObject) ) {
            SetTrapDetectedBy(oObject, oPC, FALSE);
            SetTrapActive(oObject, FALSE);

            ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oPC) );
            ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff2, GetLocation(oPC) );
            ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff2, GetLocation(oObject) );
        }
    break;
    //--------------------------------------------------------------------------
    // Destroy Gold (Target) - Or give Gold if Caster is Target
    //--------------------------------------------------------------------------
    case 86:
        sMessage    = "Destroy Gold: Target";
        eSpellVFX   = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);

        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            sMessage = "Aaah! Gold!";
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
            GiveGoldToCreature(oPC, 100 * nCasterLevel);
        } else {
            ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, GetLocation(oTarget) );
            AssignCommand(oPC, TakeGoldFromCreature(GetGold(oTarget)/2, oTarget, TRUE));
        }
    break;
    //--------------------------------------------------------------------------
    // Lightning Storm at location
    //--------------------------------------------------------------------------
    case 87:
        sMessage    = "Lightning Storm";
        eEff1       = EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, lTarget );
        DelayCommand(1.0, ar_SpellLightningStorm(oPC, lTarget, FALSE) );
    break;

    //--------------------------------------------------------------------------
    // Grease (Target)
    //--------------------------------------------------------------------------
    case 88:
        sMessage    = "Grease: Target";
        eSpellVFX   = EffectAreaOfEffect(AOE_PER_GREASE, "****", "nw_s0_greasec", "");
        nDuration   = RoundsToSeconds(2 + nCasterLevel/3);

        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSpellVFX, lTarget, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Harm (Target) - If target is PC, Heal instead!
    //--------------------------------------------------------------------------
    case 89:
        sMessage    = "Harm: Target";
        eSpellVFX   = EffectVisualEffect(VFX_IMP_HARM);
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_NECROMANCY, 6);

        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            sMessage    = "Heal: Caster";
            DelayCommand(1.0, ar_DoHealSpell(oPC));
        } else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oTarget);
            nDmg = GetCurrentHitPoints(oTarget)-d10();
            if (nDmg <= 0) nDmg = d10();
            DelayCommand(1.0, _arDoSingleSpell(oTarget, eEff1, EffectDamage(nDmg, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY), SAVING_THROW_FORT, SAVING_THROW_TYPE_NONE, nDC, 0.0));
        }
    break;
    //--------------------------------------------------------------------------
    // Field Of Icy Razors (Target/Caster)
    //--------------------------------------------------------------------------
    case 90:
        sMessage    = "Field Of Icy Razors: Target";

        if ( !GetIsObjectValid(oTarget) ) {
            oTarget  = oPC;
            sMessage = "Field Of Icy Razors: Caster";
        }

        DelayCommand(1.0, ar_SpellFieldOfIcyRazors(oPC, oTarget, FALSE));
    break;
    //--------------------------------------------------------------------------
    // Ghostform
    //--------------------------------------------------------------------------
    case 91:
        sMessage    = "Ghostform";
        nDuration   = HoursToSeconds(nCasterLevel/3);
        eSpellVFX   = EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2);
        eEff1       = EffectLinkEffects( EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT) );
        eEff2       = EffectLinkEffects( EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWO, 0), EffectConcealment(60) );
        eEff3       = EffectLinkEffects( eSpellVFX, EffectCutsceneGhost() );
        eEff4       = EffectLinkEffects( eEff3, EffectLinkEffects(eEff1, eEff2) );

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetLocation(oPC));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff4, oPC, nDuration);
    break;
    //--------------------------------------------------------------------------
    // Elemental Monolith: Stone, Fire, Water or Air
    //--------------------------------------------------------------------------
    case 92:
        sMessage    = "Elemental Monolith";
        nDuration   = 1 + HoursToSeconds(nCasterLevel/2);
        i           = d4();

        if (i == 1)         eSpellVFX = EffectSummonCreature("s_earthmonolith", VFX_FNF_SUMMON_GATE, 3.0);
        else if (i == 2)    eSpellVFX = EffectSummonCreature("s_firemonolith", VFX_FNF_SUMMONDRAGON, 2.0);
        else if (i == 3)    eSpellVFX = EffectSummonCreature("s_watermonolith", VFX_FNF_SUMMON_CELESTIAL, 3.0);
        else                eSpellVFX = EffectSummonCreature("s_airmonolith", VFX_FNF_SUMMON_CELESTIAL, 3.0);

        //::  Non Wild Mages can enjoy a Badger instead :)
        if (!isWildMage) {
            sMessage  = "Summon: Badger";
            eSpellVFX = EffectSummonCreature("NW_S_BOARDIRE", VFX_FNF_SUMMON_GATE, 3.0);
        }

        DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSpellVFX, lTarget, nDuration));

        //::  Apply Scaling Buff to Monolith
        if ( isWildMage ) {
            DelayCommand(6.0, ar_ApplySummonBonuses(oPC));
        }
    break;
    //--------------------------------------------------------------------------
    // Wrathful Castigation
    //--------------------------------------------------------------------------
    case 93:
        sMessage    = "Wrathful Castigation: Target";
        nDC         = ar_GetCustomSpellDC(oPC, SPELL_SCHOOL_NECROMANCY, 8);

        //::  Roll on the table again if Player was target
        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish );
            return;
        }
        else ar_SpellWrathfulCastigation(oPC, oTarget, nDC, FALSE);
    break;
    //--------------------------------------------------------------------------
    // Spell is Cast again
    //--------------------------------------------------------------------------
    case 94:
        sMessage    = "Duplicate Spell";
        eEff1       = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);

        //::  Don't copy certain spells, because OP.
        if ( nSpell == SPELL_EPIC_HELLBALL || nSpell == SPELL_EPIC_RUIN || nSpell == SPELL_ISAACS_GREATER_MISSILE_STORM ) sMessage = "Surge Overpowered!";
        else {
            SetLocalInt(oPC, AR_WM_CANCEL_NEXT, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
            ar_CopySpell(oTarget, lTarget, nSpell, 1.0);
            DelayCommand(6.0, DeleteLocalInt(oPC, AR_WM_CANCEL_NEXT) );
        }
    break;
    //--------------------------------------------------------------------------
    // Double Surge
    //--------------------------------------------------------------------------
    case 95:
        sMessage    = "Double Surge";
        eEff1       = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);

        if ( GetLocalInt(oPC, AR_DOUBLE_SURGE) == TRUE || !isWildMage ) sMessage = "Surge vanished";
        else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEff1, oPC);
            SetLocalInt(oPC, AR_DOUBLE_SURGE, TRUE);

            DelayCommand(1.0, ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, FALSE) );
            DelayCommand(2.0, ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, FALSE) );
            DelayCommand(3.0, DeleteLocalInt(oPC, AR_DOUBLE_SURGE) );
        }
    break;
    //--------------------------------------------------------------------------
    // Epic Spell:  Volcano
    //--------------------------------------------------------------------------
    case 96:
        sMessage    = "Volcano - Time to Run!";
        eEff1       = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        eEff2       = EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE);

        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff1, lTarget );
        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eEff2, lTarget );
        DelayCommand(2.0, ar_SpellVolcano(oPC, lTarget, FALSE) );
    break;
    //--------------------------------------------------------------------------
    // Burst of Glacial Wrath
    //--------------------------------------------------------------------------
    case 97:
        sMessage    = "Burst of Glacial Wrath: Location";

        DelayCommand(1.0, ar_BurstOfGlacialWrath(oPC, lTarget, FALSE));
    break;
    //--------------------------------------------------------------------------
    // Disintegrate Spell
    //--------------------------------------------------------------------------
    case 98:
        sMessage    = "Disintegrate: Target";

        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 70);
            return;
        }
        ar_SpellDisintegrate(oPC, oTarget, FALSE);
    break;

    //--------------------------------------------------------------------------
    // Disintegrate Spell
    //--------------------------------------------------------------------------
    case 99:
        sMessage    = "Blasphemy: Location";

        eSpellVFX   = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "ar_blasphemy_a", "****", "****");
        nDuration   = RoundsToSeconds(nCasterLevel/2);

        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSpellVFX, lTarget, nDuration);
    break;

    //--------------------------------------------------------------------------
    // Avascular Mass Spell
    //--------------------------------------------------------------------------
    case 100:
        sMessage    = "Avascular Mass: Target";

        if ( !GetIsObjectValid(oTarget) || oTarget == oPC ) {
            ar_FaerzressWildMagicTable(oPC, oTarget, lTarget, nSpell, nHarmful, bCanReplenish, 92);
            return;
        }

        ar_SpellAvascularMass(oPC, oTarget, FALSE);
    break;

    }

    WriteTimestampedLogEntry(LOG_SURGE + " -- " + GetName(oPC) + " is surging with following data:\n" +
                             "Roll: " + IntToString(nRoll) + " | Is WM: " + IntToString(isWildMage) + " | Fate: " + IntToString(isFateActive) + " | Spell Id: " + IntToString(nSpell) + "\n" +
                             locationDebug + "\n" +
                             "Wild Surge was " + sMessage);

    //::  Wild Mage specific:  Replenish Spell Surge
    //::  Each time a Wild Surge happens for a Wild Mage they get their spell replenished.
    //int isChaosActive   = GetLocalInt(oPC, "AR_CHAOS_ACTIVE");
    if ( isWildMage && bCanReplenish && !isFateActive && ar_GetIsArcaneCaster() ) {
        int nSpellLevel = gsSPGetSpellLevel(nSpell, CLASS_TYPE_WIZARD);
        int nRefreshDC  = 0;

        //:: Circle 5-9 has DC for Replenish Spell
        //::  Level 5 Spell DC: 35  (Level 30 100% chance)
        //::  Level 6 Spell DC: 50  (Level 30 95% chance)
        //::  Level 7 Spell DC: 65  (Level 30 80% chance)
        //::  Level 8 Spell DC: 80  (Level 30 65% chance)
        //::  Level 9 Spell DC: 95  (Level 30 50% chance)
        //:: Every caster level decreases the DC by 1, additional every 6th caster level decreases DC by another 3
        if (nSpellLevel > 4) {
            int nWMBonus   = nCasterLevel / 6;
            int nHighSpell = (nSpellLevel - 4);
            nRefreshDC     = 20 + (5 * (nHighSpell*3));

            nRefreshDC -= nCasterLevel;
            nRefreshDC -= nWMBonus * 3;     //::  Max 15
        }

        if ( d100() >= nRefreshDC ) {
            eSpellVFX = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellVFX, oPC);
            ar_RestoreLastWizardSpell();
            SendMessageToPC(oPC, "<c € >Greater Wild Surge:</c> Spell Replenished");
        }
    }

    //::  Remove Fate Spell once used
    if ( isWildMage && isFateActive) {
        DeleteLocalInt (oPC, "AR_FATE_ACTIVE");
    }


    //::  Display some info on what happened.
    FloatingTextStringOnCreature("<cþ þ>Wild Surge:</c> " + sMessage, oPC);

    //::  Debug for Vanished Surge (Player Reporting)
    //if ( isWildMage && sMessage == "Surge vanished" ) {
    //    SendMessageToPC(oPC, "<cþ  >Surge Vanished Debug: </c> The Wild Surge roll was <cþ þ>" + IntToString(nRoll) + "</c>.\nReport to ActionReplay and what spell you used for the Surge and if it was on a Target Object or Location.");
    //}
}

location _arGetProperLocation(object oSource) {
    return GetRandomLocation(GetArea(oSource), oSource, GetRandomDelay(1.0, 2.0));
}

void _arCreateWMGems(object oPC, int nCasterLevel, int isWildMage) {
    int nECL    = 0;
    int i       = 0;
    int length  = 0;

    if ( !isWildMage ) nCasterLevel = nCasterLevel / 2;

    //:: Alexandrite
    nECL    = ClampInt(nCasterLevel / 2, 0, 6);
    length  = 1 + Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem013", oPC);
    }

    //:: Topaz
    nECL    = ClampInt( (nCasterLevel-3) / 2, 0, 5);
    length  = 1 + Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem010", oPC);
    }

    //:: Sapphire
    nECL    = ClampInt( (nCasterLevel-6) / 2, 0, 4);
    length  = Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem008", oPC);
    }

    //:: Fire Opal
    nECL    = ClampInt( (nCasterLevel-8) / 2, 0, 3);
    length  = Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem009", oPC);
    }

    //:: Diamond
    nECL    = ClampInt( (nCasterLevel-15) / 2, 0, 2);
    length  = Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem005", oPC);
    }

    //:: Ruby
    nECL    = ClampInt( (nCasterLevel-22) / 2, 0, 2);
    length  = Random(nECL+1);
    for (i = 0; i < length; i++) {
        CreateItemOnObject("nw_it_gem006", oPC);
    }
}
