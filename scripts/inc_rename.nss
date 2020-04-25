///////////////////////////////////
//  Floaty Name Rename Library   //
//  Using NWNX Rename Plugin     //
//  By Silvard                   //
//  January 10th, 2019           //
///////////////////////////////////
//  Enables temporary name overrides and individual prefixes and suffixes

#include "nwnx_rename"
#include "nwnx_creature"
#include "inc_pc"

//Prefixes Constants

//passing a color tag as a prefix needs an appended character hence the leading space
//the override name will be trimmed of leading and trailing and leading spaces in plugin, so it's alright.
const string STEALTH_PREFIX_S = " <c€€€>"; 

//Suffixes Constants

const string DISGUISE_SUFFIX_S = " (Disguised)";
const string SLAVE_SUFFIX_S = " (Slave)";
const string DISGUISED_SLAVE_SUFFIX_S = " (Disguised Slave)";

//Local Variable Names

const string STEALTH_PREFIX = "SV_STEALTH_STATE";
const string DISGUISE_SUFFIX = "SV_DISGUISE_STATE";
const string SLAVE_SUFFIX = "SV_SLAVE_STATE";

const string NAME_OVERRIDE = "SV_NAMEOVERRIDE";

const string BAR_SUFFIX = "SV_BAR_STATE";
const string BAR_SUFFIX_S = "SV_BAR_SUFFIX";

//Internal functions
//returns the right prefixes and suffixes, according to priorities.
string _getPrefix(object oPC);
string _getSuffix(object oPC);

//Gets oPC's current name override. Returns the player's real name if one isn't set.
string svGetPCNameOverride(object oPC);

//Sets oPC's current name override.
void svSetPCNameOverride(object oPC, string sNameOverride);

//Sets an oPC's prefix/suffix on or off.
void svSetAffix(object oPC, string sAffixName, int bState);

//Refreshes oPC's name override, and sets a new one if specified
void svUpdatePCNameOverride(object oPC, string sNameOverride = "");

int svEnsurePCName(object oPC);
//--------------------------------------------------------------------------------------

string _getPrefix(object oPC)
{
    string sPrefix;

    sPrefix += (GetLocalInt(oPC,STEALTH_PREFIX)) ? STEALTH_PREFIX_S : "";

    return sPrefix;
}

string _getSuffix(object oPC)
{
    string sSuffix;
    if (GetLocalInt(oPC,BAR_SUFFIX))
    {
        sSuffix = " (" + GetLocalString(oPC,BAR_SUFFIX_S) + ")";
    }
    else
    {
        sSuffix = (GetLocalInt(oPC,SLAVE_SUFFIX) && GetLocalInt(oPC,DISGUISE_SUFFIX) && ((GetSkillRank(SKILL_PERFORM, oPC) <= 20) && (GetSkillRank(SKILL_BLUFF, oPC) <= 20))) ? DISGUISED_SLAVE_SUFFIX_S :
                                                      (GetLocalInt(oPC,DISGUISE_SUFFIX)) ? DISGUISE_SUFFIX_S:
                                                       (GetLocalInt(oPC,SLAVE_SUFFIX)) ? SLAVE_SUFFIX_S : "";
    }
    sSuffix += (GetLocalInt(oPC, STEALTH_PREFIX)) ? "</c>" : "";
    return sSuffix;
}

string svGetPCNameOverride(object oPC)
{
    return (GetLocalString(oPC,NAME_OVERRIDE) != "") ? GetLocalString(oPC,NAME_OVERRIDE) : GetName(oPC, TRUE);
}

void svSetPCNameOverride(object oPC, string sNameOverride)
{
    SetLocalString(oPC,NAME_OVERRIDE, sNameOverride);
}

void svSetAffix(object oPC, string sAffixName, int bState)
{
    SetLocalInt(oPC,sAffixName,bState);
    svUpdatePCNameOverride(oPC);
}

void svUpdatePCNameOverride(object oPC, string sNameOverride = "")
{
    string sName;
    if (sNameOverride == "")
    {
        sName += svGetPCNameOverride(oPC) ;
    }
    else
    {
        sName += sNameOverride ;
        svSetPCNameOverride(oPC,sNameOverride);
    }

    NWNX_Rename_SetPCNameOverride(oPC,  sName,_getPrefix(oPC),_getSuffix(oPC), NWNX_RENAME_PLAYERNAME_DEFAULT);
}

int svEnsurePCName(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);
    
    if (GetLocalString(oHide, "ORIGINAL_FIRST_NAME") == "")
    {
        SetLocalString(oHide, "ORIGINAL_FIRST_NAME", NWNX_Creature_GetOriginalName(oPC, FALSE));
        SetLocalString(oHide, "ORIGINAL_LAST_NAME", NWNX_Creature_GetOriginalName(oPC, TRUE));
    }
    else if (GetLocalString(oHide, "ORIGINAL_FIRST_NAME") != NWNX_Creature_GetOriginalName(oPC, FALSE) && GetLocalString(oHide, "ORIGINAL_LAST_NAME") != NWNX_Creature_GetOriginalName(oPC, TRUE))
    {   
        NWNX_Creature_SetOriginalName(oPC, GetLocalString(oHide, "ORIGINAL_FIRST_NAME"), FALSE);
        NWNX_Creature_SetOriginalName(oPC, GetLocalString(oHide, "ORIGINAL_LAST_NAME"), TRUE);
        BootPC(oPC, "Name mismatch detected. Character name has been restored.");
		return TRUE;
    }
    return FALSE;
}


