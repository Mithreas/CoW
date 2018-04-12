#include "inc_subrace"
#include "inc_backgrounds"
#include "inc_citizen"


//void main(){}

//::  Tileset constants for 1.67 and 1.69 patches
const string  TILESET_RESREF_BARROWS_INTERIOR           = "tbw01";
const string  TILESET_RESREF_CASTLE_EXTERIOR_RURAL      = "tno01";
const string  TILESET_RESREF_CASTLE_INTERIOR_2          = "tni02";
const string  TILESET_RESREF_CITY_INTERIOR_2            = "tni01";
const string  TILESET_RESREF_FORT_INTERIOR              = "twc03";
const string  TILESET_RESREF_SEA_CAVES                  = "tdt01";
const string  TILESET_RESREF_STEAMWORKS                 = "tsw01";
const string  TILESET_RESREF_TROPICAL                   = "ttz01";


//::----------------------------------------------------------------------------
//::  DELCARATION
//::----------------------------------------------------------------------------
//::  Returns TRUE if oPC is a UD character (including slave & outcast)
//::  Set bIncludeClampedSlaves to TRUE to include clamped slaves, e.g could be characters
//::  not starting with the Slave Background.
int ar_IsUDCharacter(object oPC, int bIncludeClampedSlaves = FALSE);

//::  Returns TRUE if oPC is a monster character (Not surface/slave/outcast)
int ar_IsMonsterCharacter(object oPC);

//::  Returns TRUE if oPC is a PURE monster character:
//::  Kobold, Goblin, Hobgoblin, Ogre, Orog, Imps and Gnolls
int ar_IsPureMonsterCharacter(object oPC);

//::  Returns TRUE if oPC is a Slave (Slave background)
int ar_IsUDSlave(object oPC);

//::  Returns TRUE if oPC is an Outcast (Outcast background)
int ar_IsUDOutcast(object oPC);

//::  Returns TRUE for characters that can vote in UD (All monster races, drow and Outcasts)
int ar_IsEligibleToUDVote(object oPC);

//::  Returns TRUE if oPC is a settlement leader of oArea
int ar_IsSettlementLeader(object oPC, object oArea);

//::  Returns TRUE if oPC is a Drow
int ar_IsDrow(object oPC);

//::  Returns TRUE if oPC have a drow in their party
int ar_GetDrowInParty(object oPC);

//::  Returns TRUE if oPC have a Monster PC in their party
//::  Optinal for Outcasts too
int ar_GetMonsterInParty(object oPC, int bOutcast = FALSE);

//::  Returns TRUE if oPC have a PC Monster in fRadius
//::  Optinal for Outcasts too
int ar_GetPCMonsterInRange(object oPC, float fRadius = 15.0, int bOutcast = FALSE);

//::  Returns TRUE if oPC has any sort of Path (Wild Mage, Kensai, Archer, Warlock etc...)
int ar_GetPCHavePath(object oPC);

//::  Helper function, probably exists in the NWNLexicon somewhere.
//:: - sTag      The tag of the object you want to find
//:: - oArea     The area to seach in
object GetObjectByTagInAreaEx(string sTag, object oArea);

//::  Notifies all players from oOrigin in a nRadius radius size with the given sMsg.
//:: - oOrigin          The origin object to check nearby PCs from
//:: - sPrefix          Color code, if any, to use to colorize the text.  Keep as empty string to use default text.
//:: - sMsg             The text to be shown for players
//:: - bFloatingText    Set to TRUE to make it a popup text for the player, FALSE to just be shown in console
//:: - fRadius          Size of the radius to loop over.
void ar_MessageAllPlayersInRadius(object oOrigin, string sPrefix, string sMsg, int bFloatingText = TRUE, float fRadius = RADIUS_SIZE_COLOSSAL);

//::----------------------------------------------------------------------------
//::  IMPLEMENTATION
//::----------------------------------------------------------------------------
int ar_IsUDCharacter(object oPC, int bIncludeClampedSlaves = FALSE)
{
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);
    int bOutcast    = miBAGetBackground(oPC) == MI_BA_OUTCAST;
    int bSlave      = miBAGetBackground(oPC) == MI_BA_SLAVE;

    if ( bIncludeClampedSlaves && !bSlave ) bSlave = ar_IsUDSlave(oPC);

    return nSubRace == GS_SU_ELF_DROW ||
           nSubRace == GS_SU_GNOME_DEEP ||
           nSubRace == GS_SU_DWARF_GRAY ||
           nSubRace == GS_SU_SPECIAL_BAATEZU ||
           nSubRace == GS_SU_SPECIAL_RAKSHASA ||
           nSubRace == GS_SU_SPECIAL_DRAGON ||
           nSubRace == GS_SU_SPECIAL_VAMPIRE ||
           nSubRace == GS_SU_SPECIAL_GOBLIN ||
           nSubRace == GS_SU_SPECIAL_KOBOLD ||
           nSubRace == GS_SU_HALFORC_OROG ||
           nSubRace == GS_SU_FR_OROG ||
           nSubRace == GS_SU_HALFORC_GNOLL ||
           nSubRace == GS_SU_SPECIAL_OGRE ||
           nSubRace == GS_SU_SPECIAL_IMP ||
           nSubRace == GS_SU_SPECIAL_HOBGOBLIN ||
           nSubRace == GS_SU_DEEP_IMASKARI ||
           bOutcast || bSlave;
}

int ar_IsMonsterCharacter(object oPC)
{
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return nSubRace == GS_SU_ELF_DROW ||
           nSubRace == GS_SU_GNOME_DEEP ||
           nSubRace == GS_SU_DWARF_GRAY ||
           nSubRace == GS_SU_SPECIAL_BAATEZU ||
           nSubRace == GS_SU_SPECIAL_RAKSHASA ||
           nSubRace == GS_SU_SPECIAL_DRAGON ||
           nSubRace == GS_SU_SPECIAL_VAMPIRE ||
           nSubRace == GS_SU_SPECIAL_GOBLIN ||
           nSubRace == GS_SU_SPECIAL_KOBOLD ||
           nSubRace == GS_SU_HALFORC_OROG ||
           nSubRace == GS_SU_FR_OROG ||
           nSubRace == GS_SU_HALFORC_GNOLL ||
           nSubRace == GS_SU_SPECIAL_OGRE ||
           nSubRace == GS_SU_SPECIAL_IMP ||
           nSubRace == GS_SU_DEEP_IMASKARI ||
           nSubRace == GS_SU_SPECIAL_HOBGOBLIN;
}

int ar_IsPureMonsterCharacter(object oPC) {
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return nSubRace == GS_SU_SPECIAL_GOBLIN ||
           nSubRace == GS_SU_SPECIAL_KOBOLD ||
           nSubRace == GS_SU_HALFORC_OROG ||
           nSubRace == GS_SU_FR_OROG ||
           nSubRace == GS_SU_HALFORC_GNOLL ||
           nSubRace == GS_SU_SPECIAL_OGRE ||
           nSubRace == GS_SU_SPECIAL_IMP ||
           nSubRace == GS_SU_SPECIAL_HOBGOBLIN;
}

int ar_IsUDSlave(object oPC)
{
    object oClamp = GetItemPossessedBy(oPC, "gvd_slave_clamp");
    return GetIsObjectValid(oClamp);
}

int ar_IsUDOutcast(object oPC)
{
    return miBAGetBackground(oPC) == MI_BA_OUTCAST;
}

int ar_IsEligibleToUDVote(object oPC) {
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);
    int bOutcast    = miBAGetBackground(oPC) == MI_BA_OUTCAST;

    if ( ar_IsUDSlave(oPC) )    return FALSE;

    return nSubRace == GS_SU_ELF_DROW ||
           nSubRace == GS_SU_GNOME_DEEP ||
           nSubRace == GS_SU_DWARF_GRAY ||
           nSubRace == GS_SU_SPECIAL_GOBLIN ||
           nSubRace == GS_SU_SPECIAL_KOBOLD ||
           nSubRace == GS_SU_HALFORC_OROG ||
           nSubRace == GS_SU_FR_OROG ||
           nSubRace == GS_SU_HALFORC_GNOLL ||
           nSubRace == GS_SU_SPECIAL_OGRE ||
           nSubRace == GS_SU_SPECIAL_IMP ||
           nSubRace == GS_SU_SPECIAL_HOBGOBLIN ||
           nSubRace == GS_SU_DEEP_IMASKARI ||
           bOutcast;
}

int ar_IsSettlementLeader(object oPC, object oArea) {
      string sNation = GetLocalString(oArea, "MI_NATION");
      string sBestMatch = miCZGetBestNationMatch(sNation);

      return miCZGetIsLeader(oPC, sBestMatch);
}

int ar_IsDrow(object oPC) {
    string sSubRace = GetSubRace(oPC);
    int nSubRace    = gsSUGetSubRaceByName(sSubRace);

    return nSubRace == GS_SU_ELF_DROW;
}

int ar_GetDrowInParty(object oPC) {
    object oCreature = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oCreature))
    {
        //::  Drow in party?
        int nSubRace = gsSUGetSubRaceByName(GetSubRace(oCreature));
        if ( gsSUGetIsUnderdarker(nSubRace) && nSubRace == GS_SU_ELF_DROW ) {
            return TRUE;
        }

        oCreature = GetNextFactionMember(oPC);
    }

    return FALSE;
}

int ar_GetMonsterInParty(object oPC, int bOutcast = FALSE) {
    object oCreature = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oCreature))
    {
        //::  Monster or Outcast in party?
        if ( ar_IsMonsterCharacter(oCreature) || (bOutcast && ar_IsUDOutcast(oCreature)) ) {
            return TRUE;
        }

        oCreature = GetNextFactionMember(oPC);
    }

    return FALSE;
}

int ar_GetPCMonsterInRange(object oPC, float fRadius = 15.0, int bOutcast = FALSE) {
    location lLoc = GetLocation(oPC);
    object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    while (GetIsObjectValid(oCreature))
    {
        //::  Monster or Outcast in party?
        if ( ar_IsMonsterCharacter(oCreature) || (bOutcast && ar_IsUDOutcast(oCreature)) ) {
            return TRUE;
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
    }

    return FALSE;
}

int ar_GetPCHavePath(object oPC) {
    object oItem = gsPCGetCreatureHide(oPC);
    string sPath = GetLocalString(oItem, "MI_PATH");    //::  Path Consts found in 'inc_class'

    //::  Check if Player already has a Path
    if (    GetLocalInt(oItem, "TRIBESMAN") ||
            GetLocalInt(oItem, "HEALER") ||
            GetLocalInt(oItem, "ARCHER") ||
            GetLocalInt(oItem, "MI_FS_IS_FAV_SOUL") ||
            GetLocalInt(oItem, "WEAVE_MASTER") ||
            GetLocalInt(oItem, "TRUE_FIRE") ||
            GetLocalInt(oItem, "KENSAI") ||
            GetLocalInt(oItem, "MI_WARLOCK") ||
            GetLocalInt(oItem, "MI_TOTEM") ||
            GetLocalInt(oItem, "SHADOW_MAGE") ||
            GetLocalInt(oItem, "WILD_MAGE") ||
			GetLocalInt(oItem, "SPELLSWORD") ||
            sPath == "Path of the Sniper"
            ) {
        return TRUE;
    }

    return FALSE;
}

object GetObjectByTagInAreaEx(string sTag, object oArea)
{
    object oObject = GetFirstObjectInArea(oArea);

    while ( GetIsObjectValid(oObject) )
    {
        if ( GetTag(oObject) == sTag)
        {
            return oObject;
        }

        oObject = GetNextObjectInArea(oArea);
    }

    return OBJECT_INVALID;
}

void ar_MessageAllPlayersInRadius(object oOrigin, string sPrefix, string sMsg, int bFloatingText = TRUE, float fRadius = RADIUS_SIZE_COLOSSAL) {
    string sSuffix = sPrefix != "" ? "</c>" : "";
    string sFullMsg = sPrefix + sMsg + sSuffix;

    location lTarget = GetLocation(oOrigin);

    object oPC = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while ( GetIsObjectValid(oPC) ) {

        if ( GetIsPC(oPC) || GetIsDM(oPC) ) {
            if (bFloatingText) FloatingTextStringOnCreature(sFullMsg, oPC, FALSE);
            else SendMessageToPC(oPC, sFullMsg);
        }

        oPC = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

