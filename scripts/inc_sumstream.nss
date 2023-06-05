//::///////////////////////////////////////////////
//:: Summon Stream Library
//:: inc_sumstream
//:://////////////////////////////////////////////
/*
    Contains functions for managing and summoning
    creatures from various streams (e.g. the
    air and earth streams for elementals).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////

#include "inc_pc"
#include "inc_favsoul"
#include "inc_generic"
#include "inc_math"
#include "inc_spells"
#include "inc_string"
#include "inc_time"
#include "inc_warlock"
#include "inc_log"
#include "nw_i0_generic"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x3_inc_string"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Feedback given when a summon resists the summoner's control and attacks them.
// %name = the name of the summon
const string FEEDBACK_SUMMON_CONTROL_FAILED = "*The %name resists your control!*";
// Error displayed when a valid summon blueprint could not be retrieved. Should never be seen in game (ideally)!
const string ERROR_SUMMON_BLUEPRINT_UNAVAILABLE = "Error: no valid summon found. Please report this bug on the forum at forum.arelith.com.";

// Variables set on stream scrolls to control which streams will be learned.
const string SCROLL_STREAM_ELEMENT_VARIABLE = "TEACH_STREAM_ELEMENT";
const string SCROLL_STREAM_TYPE_VARIABLE = "TEACH_STREAM_TYPE";

// Default VFX for planar summons.
const int GATE_VFX_GOOD =    VFX_FNF_SUMMON_CELESTIAL;
const int GATE_VFX_NEUTRAL = VFX_FNF_SUMMON_MONSTER_3;
const int GATE_VFX_EVIL =    VFX_FNF_SUMMON_GATE;

// These variables control the chance of successful summon control for non-compatible summons
// (e.g. devils summoned by goodly characters).
// Failure chance per alignment differences.
const int SUMMON_CONTROL_ALIGNMENT_DIFFERENTIAL_PERCENT_INCREMENT = 10;
// Minimum steps from base alignment at which there will be no chance of failure.
const int SUMMON_CONTROL_STANDARD_DIFFERENTIAL_DECREASE = 1;
// Percentage by which the appropriate Protection from Alignment spell decreases
// the chance of failure.
const int SUMMON_CONTROL_PFA_PERCENT_CHANCE_INCREASE = 10;
// Percentage by which the appropriate Magic Circle Against Alignment spell decreases
// the chance of failure.
const int SUMMON_CONTROL_MCAA_PERCENT_CHANCE_INCREASE = 20;
// Percentage by which the appropriate Aura vs. Alignment spell decreases the chance
// of failure.
const int SUMMON_CONTROL_AVA_PERCENT_CHANCE_INCREASE = 30;

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate summon stream variables from other libraries.
const string LIB_SUMSTREAM_PREFIX = "Lib_Summon_Stream_";

// Stream type constants.
const int STREAM_TYPE_DRAGON = 1;
const int STREAM_TYPE_ELEMENTAL = 2;
const int STREAM_TYPE_PLANAR = 3;
const int STREAM_TYPE_UNDEAD = 4;
const int STREAM_TYPE_TRIBESMAN = 5;

// Constants for specific elements within stream types. Note that there is value overlap in these,
// and the stream type must also be used to determine which exact summon is being referred to.
const int STREAM_DRAGON_DEFAULT = 0x0;
const int STREAM_DRAGON_SILVER = 0x01;
const int STREAM_DRAGON_PRISMATIC = 0x02;
const int STREAM_DRAGON_RED = 0x04;
const int STREAM_DRAGON_UNDEAD = 0x08;
const int STREAM_DRAGON_GOLD = 0x10;
const int STREAM_DRAGON_SHADOW = 0x20;
const int STREAM_DRAGON_ANY = 63; /* STREAM_DRAGON_SILVER | STREAM_DRAGON_PRISMATIC | STREAM_DRAGON_RED | STREAM_DRAGON_UNDEAD | STREAM_DRAGON_GOLD | STREAM_DRAGON_SHADOW */

const int STREAM_ELEMENTAL_DEFAULT = 0x0;
const int STREAM_ELEMENTAL_AIR = 0x01;
const int STREAM_ELEMENTAL_EARTH = 0x02;
const int STREAM_ELEMENTAL_FIRE = 0x04;
const int STREAM_ELEMENTAL_WATER = 0x08;
const int STREAM_ELEMENTAL_ANY = 15; /* STREAM_ELEMENTAL_AIR | STREAM_ELEMENTAL_EARTH | STREAM_ELEMENTAL_FIRE | STREAM_ELEMENTAL_WATER */

const int STREAM_PLANAR_DEFAULT = 0x0;
const int STREAM_PLANAR_CELESTIAL = 0x01;
const int STREAM_PLANAR_SLAAD = 0x02;
const int STREAM_PLANAR_DEVIL = 0x04;
const int STREAM_PLANAR_YUGOLOTH = 0x08;
const int STREAM_PLANAR_DEMON = 0x10;
const int STREAM_PLANAR_ANY = 31; /* STREAM_PLANAR_CELESTIAL | STREAM_PLANAR_SLAAD | STREAM_PLANAR_DEVIL | STREAM_PLANAR_YUGOLOTH | STREAM_PLANAR_DEMON */

const int STREAM_TRIBESMAN_RANDOM = 0x0;
const int STREAM_TRIBESMAN_MALE   = 0x01;
const int STREAM_TRIBESMAN_FEMALE = 0x02;

// Note - these duplicate/overwrite the names above for backwards compatibility.
const int STREAM_PLANAR_7DIVINES = 0x01;
const int STREAM_PLANAR_BALANCE  = 0x02;
const int STREAM_PLANAR_MAGIC    = 0x04;
const int STREAM_PLANAR_BEAST    = 0x08;

const int STREAM_UNDEAD_ZOMBIE = 0x0;
const int STREAM_UNDEAD_GHOUL = 0x01;
const int STREAM_UNDEAD_GHOST = 0x02;
const int STREAM_UNDEAD_ANY = 3; /* STREAM_UNDEAD_GHOST | STREAM_UNDEAD_GHOUL */

const int STREAM_DRAGON_TIER_WYRMLING = 0;
const int STREAM_DRAGON_TIER_DRAGON_KNIGHT = 1;

const int STREAM_ELEMENTAL_TIER_JUVENILE = 0;
const int STREAM_ELEMENTAL_TIER_HUGE = 1;
const int STREAM_ELEMENTAL_TIER_GREATER = 2;
const int STREAM_ELEMENTAL_TIER_ELDER = 3;
const int STREAM_ELEMENTAL_TIER_ANCIENT = 4;

// Parameter allows any element to be summoned from a stream (as dictated by
// the currently active stream).
const int STREAM_ELEMENT_ANY = 255;
// Specifies no stream element selected.
const int STREAM_ELEMENT_DEFAULT = 0;

// Stream tier constants (e.g. a dragon wyrmling vs. dragon knight summon).
const int STREAM_PLANAR_TIER_1 = 1;
const int STREAM_PLANAR_TIER_2 = 2;
const int STREAM_PLANAR_TIER_3 = 3;
const int STREAM_PLANAR_TIER_4 = 4;
const int STREAM_PLANAR_TIER_5 = 5;
const int STREAM_PLANAR_TIER_6 = 6;
const int STREAM_PLANAR_TIER_GATE = 7;

const int STREAM_UNDEAD_TIER_1 = 0;
const int STREAM_UNDEAD_TIER_2 = 1;
const int STREAM_UNDEAD_TIER_3 = 2;
const int STREAM_UNDEAD_TIER_4 = 3;
const int STREAM_UNDEAD_TIER_5 = 4;

// Return values for summon control attempts.
const int SUMMON_CONTROL_SUCCESSFUL = 1;
const int SUMMON_CONTROL_FAILED = 0;

// Custom token values pertaining to alignment-specific summons in dialogues.
const int CUSTOM_TOKEN_ALIGNMENT_DEFAULT         = 0999;
const int CUSTOM_TOKEN_ALIGNMENT_ANY             = 1000;
const int CUSTOM_TOKEN_ALIGNMENT_LAWFUL          = 1010;
const int CUSTOM_TOKEN_ALIGNMENT_TRUE            = 1020;
const int CUSTOM_TOKEN_ALIGNMENT_CHAOTIC         = 1030;
const int CUSTOM_TOKEN_ALIGNMENT_GOOD            = 1001;
const int CUSTOM_TOKEN_ALIGNMENT_NEUTRAL         = 1002;
const int CUSTOM_TOKEN_ALIGNMENT_EVIL            = 1003;
const int CUSTOM_TOKEN_ALIGNMENT_LAWFUL_GOOD     = 1011;
const int CUSTOM_TOKEN_ALIGNMENT_NEUTRAL_GOOD    = 1021;
const int CUSTOM_TOKEN_ALIGNMENT_CHAOTIC_GOOD    = 1031;
const int CUSTOM_TOKEN_ALIGNMENT_LAWFUL_NEUTRAL  = 1012;
const int CUSTOM_TOKEN_ALIGNMENT_TRUE_NEUTRAL    = 1022;
const int CUSTOM_TOKEN_ALIGNMENT_CHAOTIC_NEUTRAL = 1032;
const int CUSTOM_TOKEN_ALIGNMENT_LAWFUL_EVIL     = 1013;
const int CUSTOM_TOKEN_ALIGNMENT_NEUTRAL_EVIL    = 1023;
const int CUSTOM_TOKEN_ALIGNMENT_CHAOTIC_EVIL    = 1033;

// Color token values pertaining to alignment-specific summons in dialogues.
const string COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_0 = "<c ÿÌ>"; // Teal
const string COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_1 = "<c ÿÌ>"; // Teal
const string COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_2 = "<cÿÿ >"; // Yellow
const string COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_3 = "<cÿ™ >"; // Orange
const string COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_4 = "<cÿ  >"; // Red

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Grants the creature permanent access to the given stream.
//   nStreamType = STREAM_TYPE_*
//   nStream = STREAM_*
void AddKnownSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE);
// Makes a summon control attempt for the creature and returns the result (i.e. TRUE
// if the summoner succeeds in controlling it, FALSE otherwise).
int AttemptSummonControl(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the active summon stream for the given stream type (e.g.
// STREAM_PLANAR_DEMON).
int GetActiveSummonStream(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the good-evil value for the active stream of the given type (e.g. if the type
// is planar and the active planar stream is demons, then ALIGNMENT_EVIL will be returned).
int GetActiveSummonStreamAlignmentGoodEvil(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the law-chaos value for the active stream of the given type (e.g. if the type
// is planar and the active planar stream is demons, then ALIGNMENT_CHAOTIC will be returned).
int GetActiveSummonStreamAlignmentLawChaos(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the VFX associated with the active stream alignment (e.g. if
// demon is the active stream, GATE_VFX_EVIL will be returned).
int GetAlignmentBasedGateVFX(object oCreature = OBJECT_SELF, int nStreamType = STREAM_TYPE_PLANAR, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns a dragon stream blueprint of the given tier.
string GetDragonStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns an elemental stream blueprint of the given tier.
string GetElementalStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns all summon streams of the known type as a bit-wise integer.
int GetKnownSummonStreams(object oCreature, int nStreamType);
// Returns TRUE if the creature knows the given summon stream.
int GetKnowsSummonStream(object oCreature, int nStreamType, int nStream);
// Returns a planar stream blueprint of the given tier.
string GetPlanarStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the name of the given stream element (e.g. "STREAM_DRAGON_SILVER) will return
// "silver").
string GetStreamElementName(int nStreamType, int nStreamElement);
// Returns the element associated with the given stream scroll, which determines which stream
// element it will teach when used.
int GetStreamScrollElement(object oItem);
// Returns the type associated with the given stream scroll, which determines which type
// of stream it will teach when used.
int GetStreamScrollType(object oItem);
// Returns the name of the given stream type (e.g. STREAM_TYPE_DRAGON will return
// "Dragon").
string GetStreamTypeName(int nStreamType);
// Returns the good-evil value for the stream of the given type.
int GetSummonStreamAlignmentLawChaos(int nStreamType, int nStreamElement);
// Returns the law-chaos value for the stream of the given type.
int GetSummonStreamAlignmentGoodEvil(int nStreamType, int nStreamElement);
// Returns the delay between when the given summon VFX should fire and when the summon
// itself should be summoned.
float GetSummonVFXDelay(int nVFX);
// Returns an undead stream blueprint of the given tier.
string GetUndeadStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY);
// Returns the tier of undead the summoner will conjure.
int GetUndeadSummonerTier(object oCreature = OBJECT_SELF);
// Migrates data from the old summon stream system to the new one.
void MigrateStreamData(object oPC);
// Removes the given summon stream from the creature, barring them from selecting it
// again.
void RemoveKnownSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE);
// Sets the active summon stream for the creature.
void SetActiveSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE);
// Sets the known summon streams for the given creature, using a bit-wise integer.
void SetKnownSummonStreams(object oCreature, int nStreamType, int nStreams);
// Sets the colored alignment token in stream dialogue for the given stream alignment.
void SetStreamAlignmentToken(object oPC, int nAlignmentGoodEvil, int nAlignmentLawChaos);
// Sets the token value for the "(Default)" stream settings (i.e. token 999).
void SetStreamDefaultToken();
// Summons a creature from the given stream. Summon control will be attempted automatically
// if applicable (e.g. a summoned balor may turn on its master if the proper precautions are
// not taken).
void SummonFromStream(object oCreature, location lLocation, float fDuration, int nStreamType, int nTier,
    int nVisualEffectId=VFX_NONE, float fDelaySeconds = 0.0f, int nUseAppearAnimation = FALSE, int bExtraordinary = FALSE, int nAllowedStreams = STREAM_ELEMENT_ANY);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Creates a hostile summon that will turn on its master. Occurs when a summon control
    attempt is failed. */
void _CreateHostileSummon(object oSummoner, location lLocation, float fDuration, int nVisualEffectId, int bUseAppearAnimation, string sBlueprint);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: AddKnownSummonStream
//:://////////////////////////////////////////////
/*
    Grants the creature permanent access
    to the given stream.

    nStreamType = STREAM_TYPE_*
    nStream = STREAM_*
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
void AddKnownSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE)
{
    if(bFeedback && !GetKnowsSummonStream(oCreature, nStreamType, nStream))
    {
        SendMessageToPC(oCreature, "You have learned the " + GetStreamTypeName(nStreamType) + " - " + GetStreamElementName(nStreamType, nStream) + " summon stream. Use the -stream menu to activate it.");
    }
    SetKnownSummonStreams(oCreature, nStreamType, GetKnownSummonStreams(oCreature, nStreamType)|nStream);
}

//::///////////////////////////////////////////////
//:: AttemptSummonControl
//:://////////////////////////////////////////////
/*
    Makes a summon control attempt for the
    creature and returns the result (i.e. TRUE
    if the summoner succeeds in controlling it,
    FALSE otherwise).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int AttemptSummonControl(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nStreamGoodEvil = GetActiveSummonStreamAlignmentGoodEvil(oCreature, nStreamType, nAllowedStreams);
    int nFailPercent = SUMMON_CONTROL_ALIGNMENT_DIFFERENTIAL_PERCENT_INCREMENT *
        (GetAlignmentDifferential(GetAlignmentGoodEvil(oCreature), nStreamGoodEvil, GetAlignmentLawChaos(oCreature),
        GetActiveSummonStreamAlignmentLawChaos(oCreature, nStreamType, nAllowedStreams)) - SUMMON_CONTROL_STANDARD_DIFFERENTIAL_DECREASE);

    switch(nStreamGoodEvil)
    {
        case ALIGNMENT_GOOD:
        {
            if(GetHasSpellEffect(SPELL_UNHOLY_AURA, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_AVA_PERCENT_CHANCE_INCREASE;
            }
            else if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_MCAA_PERCENT_CHANCE_INCREASE;
            }
            else if(GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_PFA_PERCENT_CHANCE_INCREASE;
            }
            break;
        }
        case ALIGNMENT_EVIL:
        {
            if(GetHasSpellEffect(SPELL_HOLY_AURA, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_AVA_PERCENT_CHANCE_INCREASE;
            }
            else if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_MCAA_PERCENT_CHANCE_INCREASE;
            }
            else if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oCreature))
            {
                nFailPercent -= SUMMON_CONTROL_PFA_PERCENT_CHANCE_INCREASE;
            }
            break;
        }
    }

    nFailPercent = ClampInt(nFailPercent, 0, 100);
    return d100() > nFailPercent;
}

//::///////////////////////////////////////////////
//:: GetActiveSummonStream
//:://////////////////////////////////////////////
/*
    Returns the active summon stream for
    the given stream type (e.g.
    STREAM_PLANAR_DEMON).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
int GetActiveSummonStream(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nStream = GetLocalInt(gsPCGetCreatureHide(oCreature), LIB_SUMSTREAM_PREFIX + "ActiveSummonStream" + IntToString(nStreamType));

    if(!(nStream & nAllowedStreams)) nStream = STREAM_ELEMENT_DEFAULT;

    return nStream;
}

//::///////////////////////////////////////////////
//:: GetActiveSummonStreamAlignmentGoodEvil
//:://////////////////////////////////////////////
/*
    Returns the good-evil value for the active
    stream of the given type (e.g. if the type
    is planar and the active planar stream is
    demons, then ALIGNMENT_EVIL will be returned).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetActiveSummonStreamAlignmentGoodEvil(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nActiveStream = GetActiveSummonStream(oCreature, nStreamType);

    if(!(nActiveStream & nAllowedStreams)) nActiveStream = STREAM_ELEMENT_DEFAULT;

    if(!nActiveStream) return GetAlignmentGoodEvil(oCreature);
    return GetSummonStreamAlignmentGoodEvil(nStreamType, nActiveStream);
}

//::///////////////////////////////////////////////
//:: GetActiveSummonStreamAlignmentLawChaos
//:://////////////////////////////////////////////
/*
    Returns the law-chaos value for the active
    stream of the given type (e.g. if the type
    is planar and the active planar stream is
    demons, then ALIGNMENT_CHAOTIC will be returned).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2016
//:://////////////////////////////////////////////
int GetActiveSummonStreamAlignmentLawChaos(object oCreature, int nStreamType, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nActiveStream = GetActiveSummonStream(oCreature, nStreamType);

    if(!(nActiveStream & nAllowedStreams)) nActiveStream = STREAM_ELEMENT_DEFAULT;

    if(!nActiveStream) return GetAlignmentLawChaos(oCreature);
    return GetSummonStreamAlignmentLawChaos(nStreamType, nActiveStream);
}

//::///////////////////////////////////////////////
//:: GetAlignmentBasedGateVFX
//:://////////////////////////////////////////////
/*
    Returns the VFX associated with the
    active stream alignment (e.g. if
    demon is the active stream, GATE_VFX_EVIL
    will be returned).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////
int GetAlignmentBasedGateVFX(object oCreature = OBJECT_SELF, int nStreamType = STREAM_TYPE_PLANAR, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nAlignment = GetActiveSummonStreamAlignmentGoodEvil(oCreature, nStreamType, nAllowedStreams);

    switch(nAlignment)
    {
        case ALIGNMENT_GOOD:    return GATE_VFX_GOOD;
        case ALIGNMENT_NEUTRAL: return GATE_VFX_NEUTRAL;
        case ALIGNMENT_EVIL:    return GATE_VFX_EVIL;
    }
    return VFX_NONE;
}

//::///////////////////////////////////////////////
//:: GetDragonStreamBlueprint
//:://////////////////////////////////////////////
/*
    Returns a dragon stream blueprint of the
    given tier.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
string GetDragonStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nStream = GetActiveSummonStream(oCreature, STREAM_TYPE_DRAGON);
    string sBlueprint;

    if(!(nStream & nAllowedStreams)) nStream = STREAM_DRAGON_DEFAULT;

    if(nStream == STREAM_DRAGON_DEFAULT)
    {
        if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oCreature))
        {
            nStream = STREAM_DRAGON_UNDEAD;
        }
        else
        {
            switch(GetAlignmentGoodEvil(oCreature))
            {
                case ALIGNMENT_GOOD:    nStream = STREAM_DRAGON_SILVER;    break;
                case ALIGNMENT_NEUTRAL: nStream = STREAM_DRAGON_PRISMATIC; break;
                case ALIGNMENT_EVIL:    nStream = STREAM_DRAGON_RED;       break;
            }
        }
    }
    switch(nStream)
    {
        case STREAM_DRAGON_SILVER:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "sum_wyrmsilver";  break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "mi_sum_silv_drg"; break;
            }
            break;
        case STREAM_DRAGON_PRISMATIC:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "sum_wyrmprism";   break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "mi_sum_pris_drg"; break;
            }
            break;
        case STREAM_DRAGON_RED:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "sum_wyrmred"; break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "sum_red_drg"; break;
            }
            break;
        case STREAM_DRAGON_UNDEAD:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "";                 break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "mi_sum_dracolich"; break;
            }
            break;
        case STREAM_DRAGON_GOLD:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "";               break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "sum_golddragon"; break;
            }
            break;
        case STREAM_DRAGON_SHADOW:
            switch(nTier)
            {
                case STREAM_DRAGON_TIER_WYRMLING:      sBlueprint = "sum_wyrmshad";     break;
                case STREAM_DRAGON_TIER_DRAGON_KNIGHT: sBlueprint = "sum_shaddragon";   break;
            }
            break;
    }
    return sBlueprint;
}

//::///////////////////////////////////////////////
//:: GetElementalStreamBlueprint
//:://////////////////////////////////////////////
/*
    Returns an elemental stream blueprint of
    the given tier.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
string GetElementalStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nStream = GetActiveSummonStream(oCreature, STREAM_TYPE_ELEMENTAL);
    string sBlueprint;

    if(!(nStream & nAllowedStreams)) nStream = STREAM_ELEMENTAL_DEFAULT;

    if(nStream == STREAM_ELEMENTAL_DEFAULT)
    {
        switch(d4())
        {
            case 1: nStream = STREAM_ELEMENTAL_AIR;   break;
            case 2: nStream = STREAM_ELEMENTAL_EARTH; break;
            case 3: nStream = STREAM_ELEMENTAL_FIRE;  break;
            case 4: nStream = STREAM_ELEMENTAL_WATER; break;
        }
    }
    switch(nStream)
    {
        case STREAM_ELEMENTAL_AIR:
            switch(nTier)
            {
                case STREAM_ELEMENTAL_TIER_JUVENILE: sBlueprint = "";                break;
                case STREAM_ELEMENTAL_TIER_HUGE:     sBlueprint = "nw_s_airhuge";    break;
                case STREAM_ELEMENTAL_TIER_GREATER:  sBlueprint = "nw_s_airgreat";   break;
                case STREAM_ELEMENTAL_TIER_ELDER:    sBlueprint = "nw_s_airelder";   break;
                case STREAM_ELEMENTAL_TIER_ANCIENT:  sBlueprint = "s_airancient";    break;
            }
            break;
        case STREAM_ELEMENTAL_EARTH:
            switch(nTier)
            {
                case STREAM_ELEMENTAL_TIER_JUVENILE: sBlueprint = "sum_earth_ele";   break;
                case STREAM_ELEMENTAL_TIER_HUGE:     sBlueprint = "nw_s_earthhuge";  break;
                case STREAM_ELEMENTAL_TIER_GREATER:  sBlueprint = "nw_s_earthgreat"; break;
                case STREAM_ELEMENTAL_TIER_ELDER:    sBlueprint = "nw_s_earthelder"; break;
                case STREAM_ELEMENTAL_TIER_ANCIENT:  sBlueprint = "s_earthancient";  break;
            }
            break;
        case STREAM_ELEMENTAL_FIRE:
            switch(nTier)
            {
                case STREAM_ELEMENTAL_TIER_JUVENILE: sBlueprint = ""; break;
                case STREAM_ELEMENTAL_TIER_HUGE:     sBlueprint = "nw_s_firehuge";  break;
                case STREAM_ELEMENTAL_TIER_GREATER:  sBlueprint = "nw_s_firegreat"; break;
                case STREAM_ELEMENTAL_TIER_ELDER:    sBlueprint = "nw_s_fireelder"; break;
                case STREAM_ELEMENTAL_TIER_ANCIENT:  sBlueprint = "s_fireancient";  break;
            }
            break;
        case STREAM_ELEMENTAL_WATER:
            switch(nTier)
            {
                case STREAM_ELEMENTAL_TIER_JUVENILE: sBlueprint = "";                break;
                case STREAM_ELEMENTAL_TIER_HUGE:     sBlueprint = "nw_s_waterhuge";  break;
                case STREAM_ELEMENTAL_TIER_GREATER:  sBlueprint = "nw_s_watergreat"; break;
                case STREAM_ELEMENTAL_TIER_ELDER:    sBlueprint = "nw_s_waterelder"; break;
                case STREAM_ELEMENTAL_TIER_ANCIENT:  sBlueprint = "s_waterancient";  break;
            }
            break;
    }
    return sBlueprint;
}

//::///////////////////////////////////////////////
//:: GetKnownSummonStreams
//:://////////////////////////////////////////////
/*
    Returns all summon streams of the known
    type as a bit-wise integer.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
int GetKnownSummonStreams(object oCreature, int nStreamType)
{
    return GetLocalInt(gsPCGetCreatureHide(oCreature), LIB_SUMSTREAM_PREFIX + "SummonStreams" + IntToString(nStreamType));
}

//::///////////////////////////////////////////////
//:: GetKnowsSummonStream
//:://////////////////////////////////////////////
/*
    Returns TRUE if the creature knows the given
    summon stream.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
int GetKnowsSummonStream(object oCreature, int nStreamType, int nStream)
{
    return GetKnownSummonStreams(oCreature, nStreamType) & nStream;
}

//::///////////////////////////////////////////////
//:: GetPlanarStreamBlueprint
//:://////////////////////////////////////////////
/*
    Returns a planar stream blueprint of the
    given tier.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
string GetPlanarStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int bWarlock = miWAGetIsWarlock(oCreature);
    int nStream;
    string sBlueprint;

    if(bWarlock && GetCreatureLastSpellCastClass(oCreature) == CLASS_TYPE_BARD && !GetIsCreatureLastSpellCastItemValid(oCreature))
    {
        switch(bWarlock)
        {
            case PACT_ABYSSAL:
                nStream = STREAM_PLANAR_DEMON;
                break;
            case PACT_INFERNAL:
                nStream = STREAM_PLANAR_DEVIL;
                break;
        }
    }
    else
    {
	  if (nAllowedStreams & STREAM_PLANAR_7DIVINES) nStream = STREAM_PLANAR_7DIVINES;
	  else if (nAllowedStreams & STREAM_PLANAR_BALANCE) nStream = STREAM_PLANAR_BALANCE;
	  else if (nAllowedStreams & STREAM_PLANAR_MAGIC) nStream = STREAM_PLANAR_MAGIC;
	  else nStream = STREAM_PLANAR_BEAST;
    }

    if(nStream == STREAM_PLANAR_DEFAULT)
    {
        switch(GetAlignmentGoodEvil(oCreature))
        {
            case ALIGNMENT_GOOD:    nStream = STREAM_PLANAR_CELESTIAL; break;
            case ALIGNMENT_NEUTRAL: nStream = STREAM_PLANAR_SLAAD;     break;
            case ALIGNMENT_EVIL:
                switch(GetAlignmentLawChaos(oCreature))
                {
                    case ALIGNMENT_LAWFUL:  nStream = STREAM_PLANAR_DEVIL;    break;
                    case ALIGNMENT_NEUTRAL: nStream = STREAM_PLANAR_YUGOLOTH; break;
                    case ALIGNMENT_CHAOTIC: nStream = STREAM_PLANAR_DEMON;    break;
                }
                break;
        }
    }
    switch(nStream)
    {
        case STREAM_PLANAR_7DIVINES:
            switch(nTier)
            {
                case STREAM_PLANAR_TIER_1:    sBlueprint = "sum_stink_beet";  break;
                case STREAM_PLANAR_TIER_2:    sBlueprint = "sum_stink_beet";  break;
                case STREAM_PLANAR_TIER_3:    sBlueprint = "sum_l_plaguebrr"; break;
                case STREAM_PLANAR_TIER_4:    sBlueprint = "sum_m_plaguebrr"; break;
                case STREAM_PLANAR_TIER_5:    sBlueprint = "sum_g_plaguebrr"; break;
                case STREAM_PLANAR_TIER_6:    
                case STREAM_PLANAR_TIER_GATE: sBlueprint = "sum_angelofdecay"; break;
            }
            break;
        case STREAM_PLANAR_MAGIC:
            switch(nTier)
            {
                case STREAM_PLANAR_TIER_1:    sBlueprint = "sum_fire_mephit"; break;
                case STREAM_PLANAR_TIER_2:    sBlueprint = "sum_fire_mephit"; break;
                case STREAM_PLANAR_TIER_3:    sBlueprint = "sum_l_phoenix";   break;
                case STREAM_PLANAR_TIER_4:    sBlueprint = "sum_m_phoenix";   break;
                case STREAM_PLANAR_TIER_5:    sBlueprint = "sum_g_phoenix";   break;
                case STREAM_PLANAR_TIER_6:    
                case STREAM_PLANAR_TIER_GATE: sBlueprint = "sum_e_phoenix";   break;
            }
            break;
        case STREAM_PLANAR_BALANCE:
            switch(nTier)
            {
                case STREAM_PLANAR_TIER_1:    sBlueprint = "sum_earth_ele";   break;
                case STREAM_PLANAR_TIER_2:    sBlueprint = "sum_earth_ele";   break;
                case STREAM_PLANAR_TIER_3:    sBlueprint = "nw_s_earthhuge";  break;
                case STREAM_PLANAR_TIER_4:    sBlueprint = "nw_s_earthgreat"; break;
                case STREAM_PLANAR_TIER_5:    sBlueprint = "nw_s_earthelder"; break;
                case STREAM_PLANAR_TIER_6:    
                case STREAM_PLANAR_TIER_GATE: sBlueprint = "sum_earth_anim"; break;
            }
            break;
        case STREAM_PLANAR_BEAST:
            switch(nTier)
            {
                case STREAM_PLANAR_TIER_1:    sBlueprint = "ca_sum_u_5";      break;
                case STREAM_PLANAR_TIER_2:    sBlueprint = "ca_sum_u_5";      break;
                case STREAM_PLANAR_TIER_3:    sBlueprint = "sum_black_bear";  break;
                case STREAM_PLANAR_TIER_4:    sBlueprint = "sum_griz_bear";   break;
                case STREAM_PLANAR_TIER_5:    sBlueprint = "sum_polar_bear";  break;
                case STREAM_PLANAR_TIER_6:    
                case STREAM_PLANAR_TIER_GATE: sBlueprint = "sum_dire_bear";   break;
            }
            break;
        case STREAM_PLANAR_DEMON:
            switch(nTier)
            {
                case STREAM_PLANAR_TIER_1:    sBlueprint = "sum_mane";     break;
                case STREAM_PLANAR_TIER_2:    sBlueprint = "sum_quasit";   break;
                case STREAM_PLANAR_TIER_3:    sBlueprint = "sum_succubus"; break;
                case STREAM_PLANAR_TIER_4:    sBlueprint = "sum_vrock";    break;
                case STREAM_PLANAR_TIER_5:    sBlueprint = "sum_glabrezu"; break;
                case STREAM_PLANAR_TIER_6:    sBlueprint = "sum_balor";    break;
                case STREAM_PLANAR_TIER_GATE: sBlueprint = "gate_balor";   break;
            }
            break;
    }
    return sBlueprint;
}

//::///////////////////////////////////////////////
//: GetStreamElementName
//:://////////////////////////////////////////////
/*
    Returns the name of the given stream element
    (e.g. "STREAM_DRAGON_SILVER) will return
    "silver").
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 27, 2016
//:://////////////////////////////////////////////
string GetStreamElementName(int nStreamType, int nStreamElement)
{
    switch(nStreamType)
    {
        case STREAM_TYPE_DRAGON:
            switch(nStreamElement)
            {
                case STREAM_DRAGON_DEFAULT:   return "Default";
                case STREAM_DRAGON_SILVER:    return "Silver";
                case STREAM_DRAGON_PRISMATIC: return "Prismatic";
                case STREAM_DRAGON_RED:       return "Red";
                case STREAM_DRAGON_UNDEAD:    return "Dracolich";
                case STREAM_DRAGON_GOLD:      return "Gold";
                case STREAM_DRAGON_SHADOW:    return "Shadow";
            }
            break;
        case STREAM_TYPE_ELEMENTAL:
            switch(nStreamElement)
            {
                case STREAM_ELEMENTAL_DEFAULT: return "Default";
                case STREAM_ELEMENTAL_AIR:     return "Air";
                case STREAM_ELEMENTAL_EARTH:   return "Earth";
                case STREAM_ELEMENTAL_FIRE:    return "Fire";
                case STREAM_ELEMENTAL_WATER:   return "Water";
            }
            break;
        case STREAM_TYPE_PLANAR:
            switch(nStreamElement)
            {
                case STREAM_PLANAR_DEFAULT:    return "Default";
                case STREAM_PLANAR_CELESTIAL:  return "Celestial";
                case STREAM_PLANAR_SLAAD:      return "Slaad";
                case STREAM_PLANAR_DEVIL:      return "Devil";
                case STREAM_PLANAR_YUGOLOTH:   return "Yugoloth";
                case STREAM_PLANAR_DEMON:      return "Demon";
            }
            break;
        case STREAM_TYPE_UNDEAD:
            switch(nStreamElement)
            {
                case STREAM_UNDEAD_ZOMBIE: return "Mindless Corporeal";
                case STREAM_UNDEAD_GHOUL:  return "Intelligent Corporeal";
                case STREAM_UNDEAD_GHOST:  return "Incorporeal";
            }
            break;
		case STREAM_TYPE_TRIBESMAN:
			switch (nStreamElement)
			{
				case STREAM_TRIBESMAN_RANDOM: return "Random";
				case STREAM_TRIBESMAN_MALE:   return "Male";
				case STREAM_TRIBESMAN_FEMALE: return "Female";
			}
			break;
    }
    return "<Error: Undefined Stream Element>";
}

//::///////////////////////////////////////////////
//:: GetStreamScrollElement
//:://////////////////////////////////////////////
/*
    Returns the element associated with the given
    stream scroll, which determines which stream
    element it will teach when used.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////
int GetStreamScrollElement(object oItem)
{
    return GetLocalInt(oItem, SCROLL_STREAM_ELEMENT_VARIABLE);
}

//::///////////////////////////////////////////////
//:: GetStreamScrollType
//:://////////////////////////////////////////////
/*
    Returns the type associated with the given
    stream scroll, which determines which type
    of stream it will teach when used.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////
int GetStreamScrollType(object oItem)
{
    return GetLocalInt(oItem, SCROLL_STREAM_TYPE_VARIABLE);
}

//::///////////////////////////////////////////////
//:: GetStreamTypeName
//:://////////////////////////////////////////////
/*
    Returns the name of the given stream type
    (e.g. STREAM_TYPE_DRAGON will return
    "Dragon").
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 27, 2016
//:://////////////////////////////////////////////
string GetStreamTypeName(int nStreamType)
{
    switch(nStreamType)
    {
        case STREAM_TYPE_DRAGON:    return "Dragon";
        case STREAM_TYPE_ELEMENTAL: return "Elemental";
        case STREAM_TYPE_PLANAR:    return "Outsider";
        case STREAM_TYPE_UNDEAD:    return "Undead";
		case STREAM_TYPE_TRIBESMAN: return "Tribal Warrior";
    }
    return "<Error: Undefined Stream Type>";
}

//::///////////////////////////////////////////////
//:: GetSummonStreamAlignmentGoodEvil
//:://////////////////////////////////////////////
/*
    Returns the good-evil value for the stream of
    the given type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 31, 2017
//:://////////////////////////////////////////////
int GetSummonStreamAlignmentGoodEvil(int nStreamType, int nStreamElement)
{
    switch(nStreamType)
    {
        case STREAM_TYPE_DRAGON:
        {
            switch(nStreamElement)
            {
                case STREAM_DRAGON_SILVER:    return ALIGNMENT_GOOD;
                case STREAM_DRAGON_GOLD:      return ALIGNMENT_GOOD;
                case STREAM_DRAGON_PRISMATIC: return ALIGNMENT_NEUTRAL;
                case STREAM_DRAGON_RED:       return ALIGNMENT_EVIL;
                case STREAM_DRAGON_SHADOW:    return ALIGNMENT_EVIL;
            }
            break;
        }
        case STREAM_TYPE_ELEMENTAL:
        {
            switch(nStreamElement)
            {
            }
            break;
        }
        case STREAM_TYPE_PLANAR:
        {
            switch(nStreamElement)
            {
                case STREAM_PLANAR_CELESTIAL: return ALIGNMENT_GOOD;
                case STREAM_PLANAR_SLAAD:     return ALIGNMENT_NEUTRAL;
                case STREAM_PLANAR_DEVIL:     return ALIGNMENT_EVIL;
                case STREAM_PLANAR_YUGOLOTH:  return ALIGNMENT_EVIL;
                case STREAM_PLANAR_DEMON:     return ALIGNMENT_EVIL;
            }
            break;
        }
        case STREAM_TYPE_UNDEAD:
        {
            switch(nStreamElement)
            {
            }
            break;
        }
    }
    return ALIGNMENT_ALL;
}

//::///////////////////////////////////////////////
//:: GetSummonStreamAlignmentLawChaos
//:://////////////////////////////////////////////
/*
    Returns the law-chaos value for the stream of
    the given type.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 31, 2017
//:://////////////////////////////////////////////
int GetSummonStreamAlignmentLawChaos(int nStreamType, int nStreamElement)
{
    switch(nStreamType)
    {
        case STREAM_TYPE_DRAGON:
        {
            switch(nStreamElement)
            {
            }
            break;
        }
        case STREAM_TYPE_ELEMENTAL:
        {
            switch(nStreamElement)
            {
            }
            break;
        }
        case STREAM_TYPE_PLANAR:
        {
            switch(nStreamElement)
            {
                case STREAM_PLANAR_DEVIL:    return ALIGNMENT_LAWFUL;
                case STREAM_PLANAR_YUGOLOTH: return ALIGNMENT_NEUTRAL;
                case STREAM_PLANAR_DEMON:    return ALIGNMENT_CHAOTIC;
            }
            break;
        }
        case STREAM_TYPE_UNDEAD:
        {
            switch(nStreamElement)
            {
            }
            break;
        }
    }
    return ALIGNMENT_ALL;
}

//::///////////////////////////////////////////////
//:: GetSummonVFXDelay
//:://////////////////////////////////////////////
/*
    Returns the delay between when the given
    summon VFX should fire and when the summon
    itself should be summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////
float GetSummonVFXDelay(int nVFX)
{
    switch(nVFX)
    {
        case VFX_FNF_SUMMON_CELESTIAL: return 3.0;
        case VFX_FNF_SUMMON_GATE:      return 3.0;
    }
    return 1.0;
}

//::///////////////////////////////////////////////
//:: GetUndeadStreamBlueprint
//:://////////////////////////////////////////////
/*
    Returns an undead stream blueprint of the
    given tier.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
string GetUndeadStreamBlueprint(object oCreature, int nTier, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    int nStream = GetActiveSummonStream(oCreature, STREAM_TYPE_UNDEAD);
    string sBlueprint;

    if(!(nStream & nAllowedStreams)) nStream = STREAM_UNDEAD_ZOMBIE;

    switch(nStream)
    {
        case STREAM_UNDEAD_GHOUL:
            switch(nTier)
            {
                case STREAM_UNDEAD_TIER_1: sBlueprint = "nw_s_ghoul";       break;
                case STREAM_UNDEAD_TIER_2: sBlueprint = "nw_s_ghast";       break;
                case STREAM_UNDEAD_TIER_3: sBlueprint = "nw_s_wight";       break;
                case STREAM_UNDEAD_TIER_4: sBlueprint = "nw_s_vampire";     break;
                case STREAM_UNDEAD_TIER_5: sBlueprint = "sum_vampirecount"; break;
            }
            break;
        case STREAM_UNDEAD_ZOMBIE:
            switch(nTier)
            {
                case STREAM_UNDEAD_TIER_1: sBlueprint = "nw_s_zombie";     break;
                case STREAM_UNDEAD_TIER_2: sBlueprint = "sum_tfzombie";    break;
                case STREAM_UNDEAD_TIER_3: sBlueprint = "s_undeadwarrior"; break; // Skeleton Warrior
                case STREAM_UNDEAD_TIER_4: sBlueprint = "s_undeadofficer"; break; // Skeletal Champion
                case STREAM_UNDEAD_TIER_5: sBlueprint = "sum_dreadmummy";  break;
            }
            break;
        case STREAM_UNDEAD_GHOST:
            switch(nTier)
            {
                case STREAM_UNDEAD_TIER_1: sBlueprint = "s_allip";        break;
                case STREAM_UNDEAD_TIER_2: sBlueprint = "s_ghost";        break;
                case STREAM_UNDEAD_TIER_3: sBlueprint = "s_spectre";      break;
                case STREAM_UNDEAD_TIER_4: sBlueprint = "sum_voidwraith"; break;
                case STREAM_UNDEAD_TIER_5: sBlueprint = "s_dreadwraith";  break;
            }
            break;
    }
    return sBlueprint;
}

//::///////////////////////////////////////////////
//:: GetUndeadSummonerTier
//:://////////////////////////////////////////////
/*
    Returns the tier of undead the summoner
    will conjure.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
int GetUndeadSummonerTier(object oCreature = OBJECT_SELF)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oCreature) +
        GetLevelByClass(CLASS_TYPE_SORCERER, oCreature) +
        GetLevelByClass(CLASS_TYPE_CLERIC, oCreature) +
		GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oCreature) + 
        2 * GetLevelByClass(CLASS_TYPE_PALE_MASTER, oCreature) +
        AR_GetCasterLevelBonus(oCreature);

    if(GetKnowsFeat(FEAT_EPIC_SPELL_MUMMY_DUST, oCreature)) nLevel += 5;

    if (nLevel >= 30) return STREAM_UNDEAD_TIER_4;
    else if(nLevel >= 20) return STREAM_UNDEAD_TIER_3;
    else if (nLevel >= 10) return STREAM_UNDEAD_TIER_2;
    return STREAM_UNDEAD_TIER_1;
}

//::///////////////////////////////////////////////
//:: MigrateStreamData
//:://////////////////////////////////////////////
/*
    Migrates data from the old summon stream
    system to the new one.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 1, 2017
//:://////////////////////////////////////////////
void MigrateStreamData(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);

    if(GetLocalInt(oHide, "MI_SP_UNDEAD_STREAM") == 2)
    {
        AddKnownSummonStream(oPC, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOUL, FALSE);
        SetActiveSummonStream(oPC, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOUL, FALSE);
    }
    DeleteLocalInt(oHide, "MI_SP_UNDEAD_STREAM");
}

//::///////////////////////////////////////////////
//:: RemoveKnownSummonStream
//:://////////////////////////////////////////////
/*
    Removes the given summon stream from the
    creature, barring them from selecting it
    again.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
void RemoveKnownSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE)
{
    if(bFeedback && GetKnowsSummonStream(oCreature, nStreamType, nStream))
    {
        SendMessageToPC(oCreature, "You have forgotten the " + GetStreamTypeName(nStreamType) + " - " + GetStreamElementName(nStreamType, nStream) + " summon stream.");
    }
    if(GetActiveSummonStream(oCreature, nStreamType) == nStream)
    {
        SetActiveSummonStream(oCreature, nStreamType, 0, FALSE);
    }
    SetKnownSummonStreams(oCreature, nStreamType, GetKnownSummonStreams(oCreature, nStreamType) & ~nStream);
}

//::///////////////////////////////////////////////
//:: SetActiveSummonStream
//:://////////////////////////////////////////////
/*
    Sets the active summon stream for the
    creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
void SetActiveSummonStream(object oCreature, int nStreamType, int nStream, int bFeedback = TRUE)
{
    if(nStream && !GetKnowsSummonStream(oCreature, nStreamType, nStream)) return;

    if(bFeedback)
    {
        SendMessageToPC(oCreature, "You have activated the " + GetStreamTypeName(nStreamType) + " - " + GetStreamElementName(nStreamType, nStream) + " summon stream.");
    }
    SetLocalInt(gsPCGetCreatureHide(oCreature), LIB_SUMSTREAM_PREFIX + "ActiveSummonStream" + IntToString(nStreamType), nStream);
}

//::///////////////////////////////////////////////
//:: SetKnownSummonStreams
//:://////////////////////////////////////////////
/*
    Sets the known summon streams for the
    given creature, using a bit-wise integer.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 15, 2016
//:://////////////////////////////////////////////
void SetKnownSummonStreams(object oCreature, int nStreamType, int nStreams)
{
    SetLocalInt(gsPCGetCreatureHide(oCreature), LIB_SUMSTREAM_PREFIX + "SummonStreams" + IntToString(nStreamType), nStreams);
}

//::///////////////////////////////////////////////
//: SetStreamAlignmentToken
//:://////////////////////////////////////////////
/*
    Sets the colored alignment token in stream
    dialogue for the given stream.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 29, 2017
//:://////////////////////////////////////////////
void SetStreamAlignmentToken(object oPC, int nStreamType, int nStreamElement)
{
    int nAlignmentGoodEvil = GetSummonStreamAlignmentGoodEvil(nStreamType, nStreamElement);
    int nAlignmentLawChaos = GetSummonStreamAlignmentLawChaos(nStreamType, nStreamElement);
    int nDifferential = GetAlignmentDifferential(GetAlignmentGoodEvil(oPC), nAlignmentGoodEvil, GetAlignmentLawChaos(oPC), nAlignmentLawChaos);

    int nToken = 1000;
    string sAlignment;
    string sColorToken;
    string sText;

    switch(nDifferential)
    {
        case 0:
        {
            sColorToken = COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_0;
            break;
        }
        case 1:
        {
            sColorToken = COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_1;
            break;
        }
        case 2:
        {
            sColorToken = COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_2;
            break;
        }
        case 3:
        {
            sColorToken = COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_3;
            break;
        }
        case 4:
        {
            sColorToken = COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_4;
            break;
        }
    }

    switch(nAlignmentLawChaos)
    {
        case ALIGNMENT_LAWFUL:
        {
            nToken += 10;
            sText += "Lawful ";
            break;
        }
        case ALIGNMENT_NEUTRAL:
        {
            nToken += 20;
            sText += "Neutral ";
            break;
        }
        case ALIGNMENT_CHAOTIC:
        {
            nToken += 30;
            sText += "Chaotic ";
            break;
        }
        default:
        {
            sText += "Any ";
        }
    }
    switch(nAlignmentGoodEvil)
    {
        case ALIGNMENT_GOOD:
        {
            nToken += 1;
            sText += "Good";
            break;
        }
        case ALIGNMENT_NEUTRAL:
        {
            nToken += 2;
            sText += "Neutral";
            break;
        }
        case ALIGNMENT_EVIL:
        {
            nToken += 3;
            sText += "Evil";
            break;
        }
        default:
        {
            sText += "Any";
        }
    }
    if(sText == "Neutral Neutral")
    {
        sText = "True Neutral";
    }
    else if(sText == "Any Any")
    {
        sText = "Any";
    }
    sText = "(" + sText + ")";

    SetCustomToken(nToken, sColorToken + sText + "</c>");
}

//::///////////////////////////////////////////////
//:: SetStreamDefaultToken
//:://////////////////////////////////////////////
/*
    Sets the token value for the "(Default)"
    stream settings (i.e. token 999).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
void SetStreamDefaultToken()
{
    SetCustomToken(CUSTOM_TOKEN_ALIGNMENT_DEFAULT, COLOR_TOKEN_ALIGNMENT_DIFFERENTIAL_0 + "(Default)" + "</c>");
}

//::///////////////////////////////////////////////
//:: SummonFromStream
//:://////////////////////////////////////////////
/*
    Summons a creature from the given stream.
    Summon control will be attempted automatically
    if applicable (e.g. a summoned balor may turn
    on its master if the proper precautions are
    not taken).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 15, 2017
//:://////////////////////////////////////////////
void SummonFromStream(object oCreature, location lLocation, float fDuration, int nStreamType, int nTier,
    int nVisualEffectId=VFX_NONE, float fDelaySeconds = 0.0f, int nUseAppearAnimation = FALSE, int bExtraordinary = FALSE, int nAllowedStreams = STREAM_ELEMENT_ANY)
{
    effect eSummon;
    string sBlueprint;

    switch(nStreamType)
    {
        case STREAM_TYPE_DRAGON:
            sBlueprint = GetDragonStreamBlueprint(oCreature, nTier, nAllowedStreams);
            break;
        case STREAM_TYPE_ELEMENTAL:
            sBlueprint = GetElementalStreamBlueprint(oCreature, nTier, nAllowedStreams);
            break;
        case STREAM_TYPE_PLANAR:
            sBlueprint = GetPlanarStreamBlueprint(oCreature, nTier, nAllowedStreams);
            break;
        case STREAM_TYPE_UNDEAD:
            sBlueprint = GetUndeadStreamBlueprint(oCreature, nTier, nAllowedStreams);
            break;
    }

    if(sBlueprint == "")
    {
        Error("SummonFromStream", "Valid summon blueprint not found: oCreature("
            + GetName(oCreature) + "); nStreamType(" + IntToString(nStreamType) + "); nTier(" + IntToString(nTier) + ")");
        SendMessageToPC(oCreature, ERROR_SUMMON_BLUEPRINT_UNAVAILABLE);
        return;
    }

    if(!AttemptSummonControl(oCreature, nStreamType, nAllowedStreams))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffectId), lLocation);
        DelayCommand(fDelaySeconds, _CreateHostileSummon(oCreature, lLocation, fDuration, nVisualEffectId, nUseAppearAnimation, sBlueprint));
        return;
    }

    eSummon = EffectSummonCreature(sBlueprint, nVisualEffectId, fDelaySeconds, nUseAppearAnimation);
    if(bExtraordinary) eSummon = ExtraordinaryEffect(eSummon);
    AssignCommand(oCreature, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLocation, fDuration));
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _CreateHostileSummon
//:://////////////////////////////////////////////
/*
    Creates a hostile summon that will turn
    on its master. Occurs when a summon control
    attempt is failed.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 16, 2017
//:://////////////////////////////////////////////
void _CreateHostileSummon(object oSummoner, location lLocation, float fDuration, int nVisualEffectId, int bUseAppearAnimation, string sBlueprint)
{
    object oSummon;
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sBlueprint, lLocation, bUseAppearAnimation);
    int i;

    SendMessageToPCByStrRef(oSummoner, 68518); // "Summoned a creature"

    do
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oSummoner, i);
        UnsummonCreature(oSummon);
    } while(GetIsObjectValid(oSummon));

    SetDespawnTimer(oCreature, FloatToInt(fDuration), VFX_IMP_UNSUMMON);
    SetLocalInt(oCreature, "MI_PERSISTS", TRUE);
    FloatingTextStringOnCreature(ParseFormatStrings(FEEDBACK_SUMMON_CONTROL_FAILED, "%name", GetName(oCreature)), oSummoner, FALSE);
    AssignCommand(oCreature, DetermineCombatRound(oSummoner));
}
