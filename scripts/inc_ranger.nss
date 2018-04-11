// Ranger library.  For maintaining kill array.

#include "inc_array"
#include "gs_inc_pc"

//----------------------------------------------------------

const string RKILL = "RANGER_KILL_ARRAY";
const string RSTUDIED = "RANGER_STUDIED_ARRAY";

//----------------------------------------------------------
// Given a RACIAL_TYPE_* constant, returns the FEAT_* constant for the appropriate favored enemy.
int RaceToFEFeat(int nRacialType);

// Given a FEAT_* constant, returns a RACIAL_TYPE_* constant
int FeatToRacialType(int nFeat);

// Returns a String name for a given RACIAL_TYPE_*
string RaceToStringName(int nRacialType);

// Get race from string.  Return -1 in case of error.
int StringToRaceType(string sString);

// Creates new Ranger arrays
void CreateNewRangerArrays(object oPC);

// Resets the kill count for a specific race
void ResetRangerKillCount(object oPC, int nRacialType);

// Tallies a kill for purpose of the ranger command.
void TallyRangerKills(object oPC, object oKilled);

// Return the number of studied enemies.
int TotalStudiedEnemies(object oPC);

//----------------------------------------------------------
// Given a RACIAL_TYPE_* constant, returns the FEAT_* constant for the appropriate favored enemy.
int RaceToFEFeat(int nRacialType)
{
    // Go through the racial type constants manually and return the feat constant.
    if (nRacialType == RACIAL_TYPE_ABERRATION) return FEAT_FAVORED_ENEMY_ABERRATION;
    if (nRacialType == RACIAL_TYPE_ANIMAL) return FEAT_FAVORED_ENEMY_ANIMAL;
    if (nRacialType == RACIAL_TYPE_BEAST) return FEAT_FAVORED_ENEMY_BEAST;
    if (nRacialType == RACIAL_TYPE_CONSTRUCT) return FEAT_FAVORED_ENEMY_CONSTRUCT;
    if (nRacialType == RACIAL_TYPE_DRAGON) return FEAT_FAVORED_ENEMY_DRAGON;
    if (nRacialType == RACIAL_TYPE_DWARF) return FEAT_FAVORED_ENEMY_DWARF;
    if (nRacialType == RACIAL_TYPE_ELEMENTAL) return FEAT_FAVORED_ENEMY_ELEMENTAL;
    if (nRacialType == RACIAL_TYPE_ELF) return FEAT_FAVORED_ENEMY_ELF;
    if (nRacialType == RACIAL_TYPE_FEY) return FEAT_FAVORED_ENEMY_FEY;
    if (nRacialType == RACIAL_TYPE_GIANT) return FEAT_FAVORED_ENEMY_GIANT;
    if (nRacialType == RACIAL_TYPE_GNOME) return FEAT_FAVORED_ENEMY_GNOME;
    if (nRacialType == RACIAL_TYPE_HALFELF) return FEAT_FAVORED_ENEMY_HALFELF;
    if (nRacialType == RACIAL_TYPE_HALFLING) return FEAT_FAVORED_ENEMY_HALFLING;
    if (nRacialType == RACIAL_TYPE_HALFORC) return FEAT_FAVORED_ENEMY_HALFORC;
    if (nRacialType == RACIAL_TYPE_HUMAN) return FEAT_FAVORED_ENEMY_HUMAN;
    if (nRacialType == RACIAL_TYPE_HUMANOID_GOBLINOID) return FEAT_FAVORED_ENEMY_GOBLINOID;
    if (nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS) return FEAT_FAVORED_ENEMY_MONSTROUS;
    if (nRacialType == RACIAL_TYPE_HUMANOID_ORC) return FEAT_FAVORED_ENEMY_ORC;
    if (nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN) return FEAT_FAVORED_ENEMY_REPTILIAN;
    if (nRacialType == RACIAL_TYPE_MAGICAL_BEAST) return FEAT_FAVORED_ENEMY_MAGICAL_BEAST;
    if (nRacialType == RACIAL_TYPE_OUTSIDER) return FEAT_FAVORED_ENEMY_OUTSIDER;
    if (nRacialType == RACIAL_TYPE_SHAPECHANGER) return FEAT_FAVORED_ENEMY_SHAPECHANGER;
    if (nRacialType == RACIAL_TYPE_UNDEAD) return FEAT_FAVORED_ENEMY_UNDEAD;
    if (nRacialType == RACIAL_TYPE_VERMIN) return FEAT_FAVORED_ENEMY_VERMIN;

    // No feat found.
    return 0;
}

//----------------------------------------------------------
// Given a FEAT_* constant, returns a RACIAL_TYPE_* constant.  Error returns -1.
int FeatToRacialType(int nFeat)
{
    // Go through the racial type constants manually and return the feat constant.
    if (nFeat == FEAT_FAVORED_ENEMY_ABERRATION) return RACIAL_TYPE_ABERRATION;
    if (nFeat == FEAT_FAVORED_ENEMY_ANIMAL) return RACIAL_TYPE_ANIMAL;
    if (nFeat == FEAT_FAVORED_ENEMY_BEAST) return RACIAL_TYPE_BEAST;
    if (nFeat == FEAT_FAVORED_ENEMY_CONSTRUCT) return RACIAL_TYPE_CONSTRUCT;
    if (nFeat == FEAT_FAVORED_ENEMY_DRAGON) return RACIAL_TYPE_DRAGON;
    if (nFeat == FEAT_FAVORED_ENEMY_DWARF) return RACIAL_TYPE_DWARF;
    if (nFeat == FEAT_FAVORED_ENEMY_ELEMENTAL) return RACIAL_TYPE_ELEMENTAL;
    if (nFeat == FEAT_FAVORED_ENEMY_ELF) return RACIAL_TYPE_ELF;
    if (nFeat == FEAT_FAVORED_ENEMY_FEY) return RACIAL_TYPE_FEY;
    if (nFeat == FEAT_FAVORED_ENEMY_GIANT) return RACIAL_TYPE_GIANT;
    if (nFeat == FEAT_FAVORED_ENEMY_GNOME) return RACIAL_TYPE_GNOME;
    if (nFeat == FEAT_FAVORED_ENEMY_HALFELF) return RACIAL_TYPE_HALFELF;
    if (nFeat == FEAT_FAVORED_ENEMY_HALFLING) return RACIAL_TYPE_HALFLING;
    if (nFeat == FEAT_FAVORED_ENEMY_HALFORC) return RACIAL_TYPE_HALFORC;
    if (nFeat == FEAT_FAVORED_ENEMY_HUMAN) return RACIAL_TYPE_HUMAN;
    if (nFeat == FEAT_FAVORED_ENEMY_GOBLINOID) return RACIAL_TYPE_HUMANOID_GOBLINOID;
    if (nFeat == FEAT_FAVORED_ENEMY_MONSTROUS) return RACIAL_TYPE_HUMANOID_MONSTROUS;
    if (nFeat == FEAT_FAVORED_ENEMY_ORC) return RACIAL_TYPE_HUMANOID_ORC;
    if (nFeat == FEAT_FAVORED_ENEMY_REPTILIAN) return RACIAL_TYPE_HUMANOID_REPTILIAN;
    if (nFeat == FEAT_FAVORED_ENEMY_MAGICAL_BEAST) return RACIAL_TYPE_MAGICAL_BEAST;
    if (nFeat == FEAT_FAVORED_ENEMY_OUTSIDER) return RACIAL_TYPE_OUTSIDER;
    if (nFeat == FEAT_FAVORED_ENEMY_SHAPECHANGER) return RACIAL_TYPE_SHAPECHANGER;
    if (nFeat == FEAT_FAVORED_ENEMY_UNDEAD) return RACIAL_TYPE_UNDEAD;
    if (nFeat == FEAT_FAVORED_ENEMY_VERMIN) return RACIAL_TYPE_VERMIN;

    // No race found; return -1 because Dwarf is 0.
    return -1;
}

//----------------------------------------------------------
// Returns a String name for a given RACIAL_TYPE_*
string RaceToStringName(int nRacialType)
{

    // We're overriding the 2da look-up for certain races, because their 2da label is bad.
    if (nRacialType == 4) return "Half-Elf";
    if (nRacialType == 5) return "Half-Orc";
    if (nRacialType == 12) return "Goblinoid";
    if (nRacialType == 13) return "Monstrous Humanoid";
    if (nRacialType == 14) return "Orc";
    if (nRacialType == 15) return "Reptilian";
    if (nRacialType == 19) return "Magical Beast";

    // 2DA lookup
    return Get2DAString("Racialtypes", "Label", nRacialType);
}


//----------------------------------------------------------
// Get race from string.  Return -1 in case of error.
int StringToRaceType(string sString)
{

    sString = GetStringLowerCase(sString);

    if (FindSubString("aberration", sString) > -1) return RACIAL_TYPE_ABERRATION;
    if (FindSubString("animal", sString) > -1) return RACIAL_TYPE_ANIMAL;
    if (FindSubString("beast", sString) > -1) return RACIAL_TYPE_BEAST;
    if (FindSubString("construct", sString) > -1) return RACIAL_TYPE_CONSTRUCT;
    if (FindSubString("dragon", sString) > -1) return RACIAL_TYPE_DRAGON;
    if (FindSubString("dwarf", sString) > -1) return RACIAL_TYPE_DWARF;
    if (FindSubString("elemental", sString) > -1) return RACIAL_TYPE_ELEMENTAL;
    if (FindSubString("elf", sString) > -1) return RACIAL_TYPE_ELF;
    if (FindSubString("fey", sString) > -1) return RACIAL_TYPE_FEY;
    if (FindSubString("giant", sString) > -1) return RACIAL_TYPE_GIANT;
    if (FindSubString("gnome", sString) > -1) return RACIAL_TYPE_GNOME;
    if (FindSubString("half-elf", sString) > -1) return RACIAL_TYPE_HALFELF;
    if (FindSubString("halfling", sString) > -1) return RACIAL_TYPE_HALFLING;
    if (FindSubString("orc", sString) > -1) return RACIAL_TYPE_HUMANOID_ORC;
    if (FindSubString("human", sString) > -1) return RACIAL_TYPE_HUMAN;
    if (FindSubString("goblinoid", sString) > -1) return RACIAL_TYPE_HUMANOID_GOBLINOID;
    if (FindSubString("monstrous humanoid", sString) > -1) return RACIAL_TYPE_HUMANOID_MONSTROUS;
    if (FindSubString("half-orc", sString) > -1) return RACIAL_TYPE_HALFORC;
    if (FindSubString("reptilian", sString) > -1) return RACIAL_TYPE_HUMANOID_REPTILIAN;
    if (FindSubString("magical beast", sString) > -1) return RACIAL_TYPE_MAGICAL_BEAST;
    if (FindSubString("outsider", sString) > -1)return RACIAL_TYPE_OUTSIDER;
    if (FindSubString("shapechanger", sString) > -1) return RACIAL_TYPE_SHAPECHANGER;
    if (FindSubString("undead", sString) > -1 || FindSubString("undeath", sString) > -1) return RACIAL_TYPE_UNDEAD;
    if (FindSubString("vermin", sString) > -1) return RACIAL_TYPE_VERMIN;

    return -1;
}
//----------------------------------------------------------
// Creates new Ranger array
void CreateNewRangerArrays(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);

    // There are 30 entries in this array, corresponding to the number of entries in
    // Racialtypes.2da.  RACIAL_TYPE_* will correspond to the indices of this array.
    CreateIntArray(oHide, RKILL, 30);

    // This array is set to permit indices 1-6, corresponding to the extra Studied Enemy
    // slots a ranger can have.
    CreateIntArray(oHide, RSTUDIED, 7);

    SetLocalInt(oHide, "RANGER_ARRAYS_CREATED", 1);

}

//----------------------------------------------------------
// Resets the kill count for a specific race
void ResetRangerKillCount(object oPC, int nRacialType)
{
    object oHide = gsPCGetCreatureHide(oPC);
    DeleteArrayInt(oHide, RKILL, nRacialType);
}

//----------------------------------------------------------
// Tallies a kill for purpose of the ranger command.
// Hooked from gs_ai_death
void TallyRangerKills(object oPC, object oKilled)
{
    if (!GetIsObjectValid(oKilled) || !GetIsObjectValid(oPC))
        return;

    // Not high enough level for this to matter.
    if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) < 5)
        return;

    object oHide = gsPCGetCreatureHide(oPC);
    int nRacialType = GetRacialType(oKilled);
    int nFeat = RaceToFEFeat(nRacialType);

    // No corresponding FE feat found.
    if (!nFeat)
        return;

    // PC already has this feat, don't tally for it.
    if (GetHasFeat(nFeat, oPC))
        return;

    // Now we're at the tally part.  Create the arrays if they're not created already.
    if (!GetLocalInt(oHide, "RANGER_ARRAYS_CREATED"))
        CreateNewRangerArrays(oPC);

    int nTally = GetArrayInt(oHide, RKILL, nRacialType);

    if (nTally < 100)
        nTally++;

    SetArrayInt(oHide, RKILL, nRacialType, nTally);

}

//----------------------------------------------------------
// Return the number of studied enemies.
int TotalStudiedEnemies(object oPC)
{

    object oHide = gsPCGetCreatureHide(oPC);
    if (!GetLocalInt(oHide, "RANGER_ARRAYS_CREATED"))
    {
        CreateNewRangerArrays(oPC);
        return 0;
    }

    int i, nCount = 0;
    int nFeat;
    for (i = 1; i <=6; i++)
    {
        nFeat = GetArrayInt(oHide, RSTUDIED, i);
        if (FeatToRacialType(nFeat) != -1 && GetHasFeat(nFeat, oPC))
            nCount++;
    }

    return nCount;
}

