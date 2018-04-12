/*
    System to handle searching of digging spots in an area.

    Put down a placeable "System: Search Treasure" in an area
    Populate area with Waypoints "Digging Spots" and adjust their
    variables as needed.

    That's all.
*/

#include "inc_area"
#include "inc_log"

//----------------------------------------------------------------

const string INITIAL_SETUP      = "AR_INITIAL_SETUP";
const string ARRAY_TAG          = "AR_CHEST_DATA";
const string DIGGING_PREFIX     = "AR_DIG";
const string NO_TREASURE        = "AR_NO_TREASURE";

const string TREASURE_RADIUS        = "SearchRadius";
const string TREASURE_DC            = "SearchDC";
const string TREASURE_RESREF        = "TreasureResRef";
const string TREASURE_EXP           = "SearchExp";
const string TREASURE_JUNK_CHANCE   = "JunkChance";
const string DIGGING_RESREF         = "ar_digspot";

const string LOG_TREASURE  = "SEARCH_CHEST";   //  For Tracing


void RegisterDiggingSpots();
void SearchDiggingSpot(object oPC);
void CreateDiggingSpot(object oDiggingSpot, int nIndex);



void Run() {
    object oArea = GetArea(OBJECT_SELF);
    int bTreasureActive = GetLocalInt(oArea, NO_TREASURE);

    if (!gsARGetIsAreaActive(oArea) || bTreasureActive)
        return;

    //::  Probably faster to loop all PCs rather than all objects in the area
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
        if (!GetIsDM(oPC) && GetArea(oPC) == oArea) {
            SearchDiggingSpot(oPC);
        }

        oPC = GetNextPC();
    }

    //::  Repeat every Round
    DelayCommand(6.0, Run());
}

//::  Fix for GetDetectMode and DETECT_MODE_PASSIVE
//::  Contributed by: Slow Slosh  (NWN Lexicon 1.69)
int GetDetectModeBugFix(object oCreature)
{
    int iMode = GetDetectMode(oCreature);
    if(iMode == 2) {iMode = DETECT_MODE_PASSIVE;}
    return iMode;
}

void SearchDiggingSpot(object oPC) {
    //::  Get PC Search; Half it if not actively searching
    int nSearch = GetSkillRank(SKILL_SEARCH, oPC);
    if (GetDetectModeBugFix(oPC) == DETECT_MODE_PASSIVE)
        nSearch = nSearch / 2;

    int nExpToGive = GetLocalInt(OBJECT_SELF, TREASURE_EXP);
    float fDistance;
    int nArrSize = ObjectArray_Size(OBJECT_SELF, ARRAY_TAG);
    int i = 0;
    for (; i < nArrSize; i++) {
        object oDiggingSpot = ObjectArray_At(OBJECT_SELF, ARRAY_TAG, i);

        if (GetIsObjectValid(oDiggingSpot)) {
            //::  PC is within distance
            if (GetDistanceBetween(oDiggingSpot, oPC) < GetLocalFloat(oDiggingSpot, TREASURE_RADIUS)) {
                //::  Did we find the digging spot?
                if (nSearch + d20() >= GetLocalInt(oDiggingSpot, TREASURE_DC)) {
                    Log(LOG_TREASURE, GetName(oPC, TRUE) + " found a Digging Spot (Index: " + IntToString(i) + ") in " + GetName(GetArea(oPC)) + ".");
                    CreateDiggingSpot(oDiggingSpot, i);
                    FloatingTextStringOnCreature("*You found a digging spot*", oPC);
                    if (nExpToGive > 0) GiveXPToCreature(oPC, nExpToGive);
                }
            }
        }
    }
}

string GenerateJunkLoot() {
    string sResRef = "plc_pileskulls";

    switch(d6()) {
        case 1:
            sResRef = "bat_corpse003";      //:: Corpse
            break;
        case 2:
            sResRef = "x3_plc_skelwar2";    //::  Skeletal Remains
            break;
        case 3:
            sResRef = "nw_pl_skeleton";     //::  Skeletal Bones
            break;
        case 4:
            sResRef = "plc_stones";         //::  Stones
            break;
        case 5:
            sResRef = "x2_plc_mushrm_b";    //::  BIG MUSHROOM!
            break;
        case 6:
            sResRef = "plc_urn";            //::  Urn
            break;
    }

    return sResRef;
}

void CreateDiggingSpot(object oDiggingSpot, int nIndex) {
    object oArea        = GetArea(OBJECT_SELF);
    vector vPosition    = GetPosition(oDiggingSpot);
    location lSpawn     = Location(oArea, vPosition, IntToFloat(Random(360)));
    string sResRef      = GetLocalString(oDiggingSpot, TREASURE_RESREF);
    int nJunkChance     = GetLocalInt(OBJECT_SELF, TREASURE_JUNK_CHANCE);
    if (nJunkChance <= 0) nJunkChance = 5;  //::  At least 5% chance for Junk

    //::  Chance to generate "junk" or something different from the given ResRef
    if (d100() < nJunkChance) {
        sResRef = GenerateJunkLoot();
    }

    //::  Spawn digging spot with applied ResRef...
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lSpawn);
    object oDig = CreateObject(OBJECT_TYPE_PLACEABLE, DIGGING_RESREF, lSpawn);
    SetLocalString(oDig, TREASURE_RESREF, sResRef);

    //::  ... and remove from array.
    ObjectArray_Erase(OBJECT_SELF, ARRAY_TAG, nIndex);
    if (ObjectArray_Size(OBJECT_SELF, ARRAY_TAG) <= 0) {
        ObjectArray_Clear(OBJECT_SELF, ARRAY_TAG);  //::  Its empty though, so this does nothing but I dunno.
        SetLocalInt(oArea, NO_TREASURE, TRUE);      //::  No more treasure, deactivate this area.
        Log(LOG_TREASURE, "All Digging Spots found in " + GetName(oArea) + ".");
    }
}

void RegisterDiggingSpots() {
    object oArea = GetArea(OBJECT_SELF);
    object oObj  = GetFirstObjectInArea(oArea);
    int nCounter = 0;
    while (GetIsObjectValid(oObj)) {
        if (FindSubString(GetTag(oObj), DIGGING_PREFIX) != -1) {
            ObjectArray_PushBack(OBJECT_SELF, ARRAY_TAG, oObj);
        }
        oObj = GetNextObjectInArea(oArea);
    }
}

//----------------------------------------------------------------
void main()
{
    //::  Initial setup, gather all digging spots WPs and store them
    if (!GetLocalInt(OBJECT_SELF, INITIAL_SETUP)) {
        SetLocalInt(OBJECT_SELF, INITIAL_SETUP, TRUE);
        RegisterDiggingSpots();
    }

    Run();
}


