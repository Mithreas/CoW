/* ITEM PROPERTY Library by Gigaschatten */

//void main() {}

#include "inc_common"
#include "inc_pc"
#include "pg_lists_i"

const int GS_IP_LIMIT = 250;
const int GS_IP_STOP  = 200; // Mith edit for 1.69 - parts_shin has a huge gap.

//buffer tables from 2da
void gsIPInitialize();
//return id of sTable
int gsIPGetTableID(string sTable);
//register sTable and return index
int gsIPRegisterTable(string sTable);
//add nValue to nTableID at row sID/column sName and return new row id
int gsIPAddValue(int nTableID, string sName, int nValue);
//set nValue in nTableID at row sID/column sName
void gsIPSetValue(int nTableID, int nID, string sName, int nValue);
//return value from nTableID at row sID/column sName
int gsIPGetValue(int nTableID, int nID, string sName);
//set number of entries in nTableID
void gsIPSetCount(int nTableID, int nCount);
//return number of entries in nTableID
int gsIPGetCount(int nTableID);
//load item property cost table (split into 3 to avoid TMI)
void gsIPLoadCostTable1();
//load item property cost table (split into 3 to avoid TMI)
void gsIPLoadCostTable2();
//load item property cost table (split into 3 to avoid TMI)
void gsIPLoadCostTable3();
//load item property cost table
void gsIPLoadCostTable(int nStart = 0, int nEnd = GS_IP_LIMIT);
//internally used
int _gsIPLoadCostTable(string sTable);
//return table id of cost reference nResRef
int gsIPGetCostTableID(int nResRef);
//load item property param table
void gsIPLoadParamTable();
//internally used
int _gsIPLoadParamTable(string sTable);
//return table id of param reference nResRef
int gsIPGetParamTableID(int nResRef);
//load item property param
void gsIPLoadPropertyTable();
//internally used
int _gsIPLoadPropertyTable(string sTable);
//load item category table
void gsIPLoadItemCategoryTable();
//return item category of nBaseItemType
int gsIPGetItemCategory(int nBaseItemType);
//load item property validation table
void gsIPLoadValidationTable();
//return TRUE if nProperty can be added to oItem
int gsIPGetIsValid(object oItem, int nProperty);
//load appearance table sTable for nArmorPart
void gsIPLoadAppearanceTable(string sTable, int nArmorPart);
//internally used
int _gsIPLoadAppearanceTable(string sTable);
//return table id of nArmorPart
int gsIPGetAppearanceTableID(int nArmorPart);
//return armor class of appearance nValue from table nTableID
int gsIPGetAppearanceAC(int nTableID, int nValue);
//load sTable
void gsIPLoadTable(string sTable);
//create sTable containing nCount rows
void gsIPCreateDummyTable(string sTable, int nCount);
//return cost for adding ipProperty to oItem, return -1 on error
int gsIPGetCost(object oItem, itemproperty ipProperty);
//return itemproperty specified by nProperty, nSubType, nCostValue and nParam1Value
itemproperty gsIPGetItemProperty(int nProperty, int nSubType = 0, int nCostValue = 0, int nParam1Value = 0);
//add ipProperty to oItem for fDuration
void gsIPAddItemProperty(object oItem, itemproperty ipProperty, float fDuration = 0.0, int nSingleSubTypeOnly = FALSE);
//add ipProperty to oItem for fDuration, allows only one physical and one elemental damage type of same duration type
void gsIPAddDamageBonus(object oItem, itemproperty ipProperty, float fDuration = 0.0);
//remove all properties on oItem
void gsIPRemoveAllProperties(object oItem);
// Add nBonus to nSkill, stacking with any existing value.
void gsIPStackSkill(object oItem, int nSkill, int nBonus);
// Add nBonus to nAbility, stacking with any existing value.
void gsIPStackAbility(object oItem, int nAbility, int nBonus);
// Get the ID of the current PC owner.
string gsIPGetOwner(object oItem);
// Set the owner of the item.
void gsIPSetOwner(object oItem, object oPC);
// Return the material (from iprp_materials) for oItem.  0 if the item has
// no material property.
int gsIPGetMaterialType(object oItem);
// Return the bonus material type, if any.  If an item has a gem in it, 
// it will have the material: gem type bonus material property. 
int gsIPGetBonusMaterialType (object oItem);
// Return TRUE if the property is a 'mundane' one (AC bonus etc).  FALSE
// if the property is a magical one (stat bonus, skill bonus etc).
int gsIPGetIsMundaneProperty(int ip, int subtype);
// Return TRUE if oPC meets the conditions of any "Usable by" properties on 
// oItem (or if oItem has no usage limitations). 
int gsIPMeetsRestrictions(object oItem, object oPC);
// Does a UMD check for the user, with a helpful error message if they don't
// meet the requirements.
int gsIPDoUMDCheck(object oItem, object oPC);

void gsIPInitialize()
{
    gsIPLoadCostTable();
    gsIPLoadParamTable();
    gsIPLoadPropertyTable();
    gsIPLoadItemCategoryTable();
    gsIPLoadValidationTable();
}
//----------------------------------------------------------------
int gsIPGetTableID(string sTable)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_ID_" + sTable);
}
//----------------------------------------------------------------
int gsIPRegisterTable(string sTable)
{
    object oCacheItem = gsCMGetCacheItem("IPROP");
    int nTableID      = gsIPGetTableID(sTable);

    if (nTableID) return nTableID; //already registered

    nTableID       = GetLocalInt(oCacheItem, "GS_IP_ID_COUNT") + 1;

    SetLocalInt(oCacheItem, "GS_IP_ID_" + sTable, nTableID);
    SetLocalInt(oCacheItem, "GS_IP_ID_COUNT", nTableID);

    return nTableID;
}
//----------------------------------------------------------------
int gsIPAddValue(int nTableID, string sName, int nValue)
{
    int nCount = gsIPGetCount(nTableID);

    SetLocalInt(gsCMGetCacheItem("IPROP"),
                "GS_IP_" +
                IntToString(nTableID) + "_" +
                IntToString(nCount) + "_" +
                sName,
                nValue);

    gsIPSetCount(nTableID, nCount + 1);
    return nCount;
}
//----------------------------------------------------------------
void gsIPSetValue(int nTableID, int nID, string sName, int nValue)
{
    if (nID >= gsIPGetCount(nTableID)) return;

    SetLocalInt(gsCMGetCacheItem("IPROP"),
                "GS_IP_" +
                IntToString(nTableID) + "_" +
                IntToString(nID) + "_" +
                sName,
                nValue);
}
//----------------------------------------------------------------
int gsIPGetValue(int nTableID, int nID, string sName)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"),
                       "GS_IP_" +
                       IntToString(nTableID) + "_" +
                       IntToString(nID) + "_" +
                       sName);
}
//----------------------------------------------------------------
void gsIPSetCount(int nTableID, int nCount)
{
    SetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_" + IntToString(nTableID) + "_COUNT", nCount);
}
//----------------------------------------------------------------
int gsIPGetCount(int nTableID)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_" + IntToString(nTableID) + "_COUNT");
}
//----------------------------------------------------------------
//(split into 2 to avoid TMI)
void gsIPLoadCostTable1()
{
  gsIPLoadCostTable(0, 15);
}
//----------------------------------------------------------------
//(split into 2 to avoid TMI)
void gsIPLoadCostTable2()
{
  gsIPLoadCostTable(16, 25);
}
//----------------------------------------------------------------
//(split into 2 to avoid TMI)
void gsIPLoadCostTable3()
{
  gsIPLoadCostTable(26, GS_IP_LIMIT);
}
//----------------------------------------------------------------
void gsIPLoadCostTable(int nStart = 0, int nEnd = GS_IP_LIMIT)
{
    object oCacheItem = gsCMGetCacheItem("IPROP");
    string sString    = "";
    int nCount        = 0;
    int nNth          = 0;

    for (nNth = nStart; nNth <= nEnd; nNth++)
    {
        sString = Get2DAString("iprp_costtable", "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString("iprp_costtable", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            SetLocalInt(oCacheItem,
                        "GS_IP_C" + IntToString(nNth),
                        _gsIPLoadCostTable(sString));
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadCostTable(string sTable)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable);

    string sString   = "";
    int nID          = 0;
    int nCount       = 0;
    int nNth         = 0;
	string sDisabled = "";

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

			sDisabled = Get2DAString(sTable, "GS_IP_DISABLED", nNth);
            if (sDisabled == "TRUE") continue;

            nID    = gsIPAddValue(nTableID, "ID", nNth);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString));
            gsIPSetValue(nTableID, nID, "DISABLED", StringToInt(sDisabled));
            WriteTimestampedLogEntry("Table " + sTable + ", row " + IntToString(nNth) + ", value " + sString + ", disabled " + sDisabled);
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetCostTableID(int nResRef)
{
     return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_C" + IntToString(nResRef));
}
//----------------------------------------------------------------
void gsIPLoadParamTable()
{
    object oCacheItem = gsCMGetCacheItem("IPROP");
    string sString    = "";
    int nCount        = 0;
    int nNth          = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString("iprp_paramtable", "TableResRef", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString("iprp_paramtable", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            SetLocalInt(oCacheItem,
                        "GS_IP_P" + IntToString(nNth),
                        _gsIPLoadParamTable(sString));
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadParamTable(string sTable)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable);

    string sString = "";
    int nID        = 0;
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;

            if (Get2DAString(sTable, "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID    = gsIPAddValue(nTableID, "ID", nNth);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString));
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetParamTableID(int nResRef)
{
     return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_P" + IntToString(nResRef));
}
//----------------------------------------------------------------
void gsIPLoadPropertyTable()
{
    int nTableID   = gsIPGetTableID("itempropdef");

    if (nTableID) return;

    nTableID       = gsIPRegisterTable("itempropdef");

    string sString = "";
    int nID        = 0;
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString("itempropdef", "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount  = 0;

            if (Get2DAString("itempropdef", "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID     = gsIPAddValue(nTableID, "ID", nNth);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString));

            sString = Get2DAString("itempropdef", "SubTypeResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "SUBREF",
                             _gsIPLoadPropertyTable(sString));
            }

            sString = Get2DAString("itempropdef", "CostTableResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "COSREF",
                             gsIPGetCostTableID(StringToInt(sString)));
            }

            sString = Get2DAString("itempropdef", "Param1ResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "PARREF",
                             gsIPGetParamTableID(StringToInt(sString)));
            }
        }
    }
}
//----------------------------------------------------------------
int _gsIPLoadPropertyTable(string sTable)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable);

    string sString = "";
    int nCount     = 0;
    int nID        = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "Name", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount  = 0;

            if (Get2DAString(sTable, "GS_IP_DISABLED", nNth) == "TRUE") continue;

            nID     = gsIPAddValue(nTableID, "ID", nNth);
            gsIPSetValue(nTableID, nID, "STRREF", StringToInt(sString));

            sString = Get2DAString(sTable, "Param1ResRef", nNth);

            if (sString != "")
            {
                gsIPSetValue(nTableID,
                             nID,
                             "PARREF",
                             gsIPGetParamTableID(StringToInt(sString)));
            }
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
void gsIPLoadItemCategoryTable()
{
    object oCacheItem = gsCMGetCacheItem("IPROP");
    string sString    = "";
    int nID           = 0;
    int nCount        = 0;

    for (nID = 0; nID < GS_IP_LIMIT; nID++)
    {
        switch (nID)
        {
        case BASE_ITEM_ARMOR:
            sString = "3";
            break;

        case BASE_ITEM_MAGICSTAFF:
            sString = "100";
            break;

        case BASE_ITEM_MAGICROD:
            sString = "101";
            break;

        case BASE_ITEM_CREATUREITEM:
            sString = "102";
            break;

        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            sString = "103";
            break;

        case BASE_ITEM_LARGEBOX:
            sString = "104";
            break;

        case BASE_ITEM_GLOVES:
            sString = "105";
            break;

        default:
            sString = Get2DAString("baseitems", "Category", nID);
        }

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            SetLocalInt(oCacheItem,
                        "GS_IP_IC_" + IntToString(nID),
                        StringToInt(sString));

            nCount = 0;
        }
    }
}
//----------------------------------------------------------------
int gsIPGetItemCategory(int nBaseItemType)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_IC_" + IntToString(nBaseItemType));
}
//----------------------------------------------------------------
void gsIPLoadValidationTable()
{
    object oCacheItem = gsCMGetCacheItem("IPROP");
    string sTable     = "itemprops";
    string sName      = "";
    string sString    = "";
    int nNth          = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sName   = "GS_IP_V_" + IntToString(nNth) + "_";

        sString = Get2DAString(sTable, "0_Melee", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "1",   StringToInt(sString));
        sString = Get2DAString(sTable, "1_Ranged", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "2",   StringToInt(sString));
        sString = Get2DAString(sTable, "2_Thrown", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "7",   StringToInt(sString));
        sString = Get2DAString(sTable, "3_Staves", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "100", StringToInt(sString));
        sString = Get2DAString(sTable, "4_Rods", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "101", StringToInt(sString));
        sString = Get2DAString(sTable, "5_Ammo", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "6",   StringToInt(sString));
        sString = Get2DAString(sTable, "6_Arm_Shld", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "3",   StringToInt(sString));
        sString = Get2DAString(sTable, "7_Helm", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "5",   StringToInt(sString));
        sString = Get2DAString(sTable, "8_Potions", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "9",   StringToInt(sString));
        sString = Get2DAString(sTable, "9_Scrolls", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "10",  StringToInt(sString));
        sString = Get2DAString(sTable, "10_Wands", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "8",   StringToInt(sString));
        sString = Get2DAString(sTable, "11_Thieves", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "11",  StringToInt(sString));
        sString = Get2DAString(sTable, "12_TrapKits", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "15",  StringToInt(sString));
        sString = Get2DAString(sTable, "13_Hide", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "102", StringToInt(sString));
        sString = Get2DAString(sTable, "14_Claw", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "103", StringToInt(sString));
        sString = Get2DAString(sTable, "15_Misc_Uneq", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "16",  StringToInt(sString));
        sString = Get2DAString(sTable, "16_Misc", nNth);
        if (sString != "")
        {
            SetLocalInt(oCacheItem, sName + "4", StringToInt(sString));
            SetLocalInt(oCacheItem, sName + "12", StringToInt(sString));
        }
        sString = Get2DAString(sTable, "17_No_Props", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "17",  StringToInt(sString));
        sString = Get2DAString(sTable, "18_Containers", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "104", StringToInt(sString));
        sString = Get2DAString(sTable, "19_HealerKit", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "19",  StringToInt(sString));
        sString = Get2DAString(sTable, "20_Torch", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "20",  StringToInt(sString));
        sString = Get2DAString(sTable, "21_Glove", nNth);
        if (sString != "") SetLocalInt(oCacheItem, sName + "105", StringToInt(sString));
    }
}
//----------------------------------------------------------------
int gsIPGetIsValid(object oItem, int nProperty)
{
    int nBaseItemType = GetBaseItemType(oItem);
    int nItemCategory = gsIPGetItemCategory(nBaseItemType);

    return GetLocalInt(gsCMGetCacheItem("IPROP"),
                       "GS_IP_V_" +
                       IntToString(nProperty) + "_" +
                       IntToString(nItemCategory));
}
//----------------------------------------------------------------
void gsIPLoadAppearanceTable(string sTable, int nArmorPart)
{
    if (gsIPGetAppearanceTableID(nArmorPart)) return;

    SetLocalInt(gsCMGetCacheItem("IPROP"),
                "GS_IP_A" + IntToString(nArmorPart),
                _gsIPLoadAppearanceTable(sTable));
}
//----------------------------------------------------------------
int _gsIPLoadAppearanceTable(string sTable)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return nTableID;

    nTableID       = gsIPRegisterTable(sTable);

    object oCacheItem = gsCMGetCacheItem("IPROP");
    string sString    = "";
    int nCount        = 0;
    int nID           = 0;
    int nNth          = 0;
    int nAC           = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "ACBONUS", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;
            nID    = gsIPAddValue(nTableID, "ID", nNth);
            nAC    = StringToInt(sString);

            gsIPSetValue(nTableID, nID, "AC", nAC);
            SetLocalInt(oCacheItem,
                        "GS_IP_AC_" +
                        IntToString(nTableID) + "_" +
                        IntToString(nNth),
                        nAC);
        }
    }

    return nTableID;
}
//----------------------------------------------------------------
int gsIPGetAppearanceTableID(int nArmorPart)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"), "GS_IP_A" + IntToString(nArmorPart));
}
//----------------------------------------------------------------
int gsIPGetAppearanceAC(int nTableID, int nValue)
{
    return GetLocalInt(gsCMGetCacheItem("IPROP"),
                       "GS_IP_AC_" +
                       IntToString(nTableID) + "_" +
                       IntToString(nValue));
}
//----------------------------------------------------------------
void gsIPLoadTable(string sTable)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return;

    nTableID       = gsIPRegisterTable(sTable);

    string sString = "";
    int nCount     = 0;
    int nNth       = 0;

    for (nNth = 0; nNth < GS_IP_LIMIT; nNth++)
    {
        sString = Get2DAString(sTable, "LABEL", nNth);

        if (sString == "")
        {
            if (++nCount > GS_IP_STOP) break;
        }
        else
        {
            nCount = 0;
            gsIPAddValue(nTableID, "ID", nNth);
        }
    }
}
//----------------------------------------------------------------
void gsIPCreateDummyTable(string sTable, int nCount)
{
    sTable         = GetStringLowerCase(sTable);
    int nTableID   = gsIPGetTableID(sTable);

    if (nTableID) return;

    nTableID       = gsIPRegisterTable(sTable);

    int nNth       = 1;

    for (; nNth <= nCount; nNth++)
    {
        gsIPAddValue(nTableID, "ID", nNth);
    }
}
//----------------------------------------------------------------
int gsIPGetCost(object oItem, itemproperty ipProperty)
{
    object oCopy = CopyObject(oItem, GetLocation(oItem));

    if (GetIsObjectValid(oCopy))
    {
        SetPlotFlag(oCopy, FALSE);
        SetIdentified(oCopy, TRUE);
        SetStolenFlag(oCopy, FALSE);

        int nCost = GetGoldPieceValue(oCopy);
        gsIPAddItemProperty(oCopy, ipProperty);
        nCost     = GetGoldPieceValue(oCopy) - nCost;

        DestroyObject(oCopy);

        return nCost;
    }

    return -1;
}
//----------------------------------------------------------------
itemproperty gsIPGetItemProperty(int nProperty, int nSubType = 0, int nCostValue = 0, int nParam1Value = 0)
{
    itemproperty ipProperty;

    switch (nProperty)
    {
    case 0:
        ipProperty = ItemPropertyAbilityBonus(nSubType, nCostValue);
        break;

    case 1:
        ipProperty = ItemPropertyACBonus(nCostValue);
        break;

    case 2:
        ipProperty = ItemPropertyACBonusVsAlign(nSubType, nCostValue);
        break;

    case 3:
        ipProperty = ItemPropertyACBonusVsDmgType(nSubType, nCostValue);
        break;

    case 4:
        ipProperty = ItemPropertyACBonusVsRace(nSubType, nCostValue);
        break;

    case 5:
        ipProperty = ItemPropertyACBonusVsSAlign(nSubType, nCostValue);
        break;

    case 6:
        ipProperty = ItemPropertyEnhancementBonus(nCostValue);
        break;
    case 7:
        ipProperty = ItemPropertyEnhancementBonusVsAlign(nSubType, nCostValue);
        break;

    case 8:
        ipProperty = ItemPropertyEnhancementBonusVsRace(nSubType, nCostValue);
        break;

    case 9:
        ipProperty = ItemPropertyEnhancementBonusVsSAlign(nSubType, nCostValue);
        break;

    case 10:
        ipProperty = ItemPropertyAttackPenalty(nCostValue);
        break;

    case 11:
        ipProperty = ItemPropertyWeightReduction(nCostValue);
        break;

    case 12:
        ipProperty = ItemPropertyBonusFeat(nSubType);
        break;

    case 13:
        ipProperty = ItemPropertyBonusLevelSpell(nSubType, nCostValue);
        break;

    case 14:
        break;

    case 15:
        ipProperty = ItemPropertyCastSpell(nSubType, nCostValue);
        break;

    case 16:
        ipProperty = ItemPropertyDamageBonus(nSubType, nCostValue);
        break;

    case 17:
        ipProperty = ItemPropertyDamageBonusVsAlign(nSubType, nParam1Value, nCostValue);
        break;

    case 18:
        ipProperty = ItemPropertyDamageBonusVsRace(nSubType, nParam1Value, nCostValue);
        break;

    case 19:
        ipProperty = ItemPropertyDamageBonusVsSAlign(nSubType, nParam1Value, nCostValue);
        break;

    case 20:
        ipProperty = ItemPropertyDamageImmunity(nSubType, nCostValue);
        break;

    case 21:
        ipProperty = ItemPropertyDamagePenalty(nCostValue);
        break;

    case 22:
        ipProperty = ItemPropertyDamageReduction(nSubType, nCostValue);
        break;

    case 23:
        ipProperty = ItemPropertyDamageResistance(nSubType, nCostValue);
        break;

    case 24:
        ipProperty = ItemPropertyDamageVulnerability(nSubType, nCostValue);
        break;

    case 25:
        break;

    case 26:
        ipProperty = ItemPropertyDarkvision();
        break;

    case 27:
        ipProperty = ItemPropertyDecreaseAbility(nSubType, nCostValue);
        break;

    case 28:
        ipProperty = ItemPropertyDecreaseAC(nSubType, nCostValue);
        break;

    case 29:
        ipProperty = ItemPropertyDecreaseSkill(nSubType, nCostValue);
        break;

    case 30:
        break;

    case 31:
        break;

    case 32:
        ipProperty = ItemPropertyContainerReducedWeight(nCostValue);
        break;

    case 33:
        ipProperty = ItemPropertyExtraMeleeDamageType(nSubType);
        break;

    case 34:
        ipProperty = ItemPropertyExtraRangeDamageType(nSubType);
        break;

    case 35:
        ipProperty = ItemPropertyHaste();
        break;

    case 36:
        ipProperty = ItemPropertyHolyAvenger();
        break;

    case 37:
        ipProperty = ItemPropertyImmunityMisc(nSubType);
        break;

    case 38:
        ipProperty = ItemPropertyImprovedEvasion();
        break;

    case 39:
        ipProperty = ItemPropertyBonusSpellResistance(nCostValue);
        break;

    case 40:
        ipProperty = ItemPropertyBonusSavingThrowVsX(nSubType, nCostValue);
        break;

    case 41:
        ipProperty = ItemPropertyBonusSavingThrow(nSubType, nCostValue);
        break;

    case 42:
        break;

    case 43:
        ipProperty = ItemPropertyKeen();
        break;

    case 44:
        ipProperty = ItemPropertyLight(nCostValue, nParam1Value);
        break;

    case 45:
        ipProperty = ItemPropertyMaxRangeStrengthMod(nCostValue);
        break;

    case 46:
        break;

    case 47:
        ipProperty = ItemPropertyNoDamage();
        break;

    case 48:
        ipProperty = ItemPropertyOnHitProps(nSubType, nCostValue, nParam1Value);
        break;

    case 49:
        ipProperty = ItemPropertyReducedSavingThrowVsX(nSubType, nCostValue);
        break;

    case 50:
        ipProperty = ItemPropertyReducedSavingThrow(nSubType, nCostValue);
        break;

    case 51:
        ipProperty = ItemPropertyRegeneration(nCostValue);
        break;

    case 52:
        ipProperty = ItemPropertySkillBonus(nSubType, nCostValue);
        break;

    case 53:
        ipProperty = ItemPropertySpellImmunitySpecific(nCostValue);
        break;

    case 54:
        ipProperty = ItemPropertySpellImmunitySchool(nSubType);
        break;

    case 55:
        ipProperty = ItemPropertyThievesTools(nCostValue);
        break;

    case 56:
        ipProperty = ItemPropertyAttackBonus(nCostValue);
        break;

    case 57:
        ipProperty = ItemPropertyAttackBonusVsAlign(nSubType, nCostValue);
        break;

    case 58:
        ipProperty = ItemPropertyAttackBonusVsRace(nSubType, nCostValue);
        break;

    case 59:
        ipProperty = ItemPropertyAttackBonusVsSAlign(nSubType, nCostValue);
        break;

    case 60:
        ipProperty = ItemPropertyAttackPenalty(nCostValue);
        break;

    case 61:
        ipProperty = ItemPropertyUnlimitedAmmo(nCostValue);
        break;

    case 62:
        ipProperty = ItemPropertyLimitUseByAlign(nSubType);
        break;

    case 63:
        ipProperty = ItemPropertyLimitUseByClass(nSubType);
        break;

    case 64:
        ipProperty = ItemPropertyLimitUseByRace(nSubType);
        break;

    case 65:
        ipProperty = ItemPropertyLimitUseBySAlign(nSubType);
        break;

    case 66:
        break;

    case 67:
        ipProperty = ItemPropertyVampiricRegeneration(nCostValue);
        break;

    case 68:
        break;

    case 69:
        break;

    case 70:
        ipProperty = ItemPropertyTrap(nSubType, nCostValue);
        break;

    case 71:
        ipProperty = ItemPropertyTrueSeeing();
        break;

    case 72:
        ipProperty = ItemPropertyOnMonsterHitProperties(nSubType, nParam1Value);
        break;

    case 73:
        ipProperty = ItemPropertyTurnResistance(nCostValue);
        break;

    case 74:
        ipProperty = ItemPropertyMassiveCritical(nCostValue);
        break;

    case 75:
        ipProperty = ItemPropertyFreeAction();
        break;

    case 76:
        break;

    case 77:
        ipProperty = ItemPropertyMonsterDamage(nCostValue);
        break;

    case 78:
        ipProperty = ItemPropertyImmunityToSpellLevel(nCostValue + 1);
        break;

    case 79:
        ipProperty = ItemPropertySpecialWalk(nSubType);
        break;

    case 80:
        ipProperty = ItemPropertyHealersKit(nCostValue);
        break;

    case 81:
        ipProperty = ItemPropertyWeightIncrease(nParam1Value);
        break;

    case 82:
        ipProperty = ItemPropertyOnHitCastSpell(nSubType, nCostValue + 1);
        break;

    case 83:
        ipProperty = ItemPropertyVisualEffect(nSubType);
        break;

    case 84:
        ipProperty = ItemPropertyArcaneSpellFailure(nCostValue);
        break;
    }

    return ipProperty;
}
//----------------------------------------------------------------
void gsIPAddItemProperty(object oItem, itemproperty ipProperty, float fDuration = 0.0, int nSingleSubTypeOnly = FALSE)
{
    int nType         = GetItemPropertyType(ipProperty);
    int nSubType      = GetItemPropertySubType(ipProperty);
    int nDurationType = 0;

    itemproperty _ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(_ipProperty))
    {
        nDurationType = GetItemPropertyDurationType(_ipProperty);

        if (((nDurationType == DURATION_TYPE_PERMANENT && fDuration == 0.0) ||
             (nDurationType == DURATION_TYPE_TEMPORARY && fDuration > 0.0)) &&
             (GetItemPropertyType(_ipProperty) != ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N) &&
            GetItemPropertyType(_ipProperty) == nType &&
            (nSingleSubTypeOnly ||
             nSubType == -1 ||
             GetItemPropertySubType(_ipProperty) == nSubType))
        {
            RemoveItemProperty(oItem, _ipProperty);
        }

        _ipProperty = GetNextItemProperty(oItem);
    }

    AddItemProperty(
        fDuration == 0.0 ? DURATION_TYPE_PERMANENT : DURATION_TYPE_TEMPORARY,
        ipProperty,
        oItem,
        fDuration);
}
//----------------------------------------------------------------
void gsIPAddDamageBonus(object oItem, itemproperty ipProperty, float fDuration = 0.0)
{
    int nType1         = GetItemPropertyType(ipProperty);
    int nSubType1      = GetItemPropertySubType(ipProperty);
    int nDurationType1 = fDuration == 0.0 ? DURATION_TYPE_PERMANENT : DURATION_TYPE_TEMPORARY;
    int nPhysical1     = nSubType1 == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType1 == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType1 == IP_CONST_DAMAGETYPE_SLASHING;
    int nType2         = 0;
    int nSubType2      = 0;
    int nDurationType2 = 0;
    int nPhysical2     = 0;

    itemproperty _ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(_ipProperty))
    {
        nType2         = GetItemPropertyType(_ipProperty);
        nSubType2      = GetItemPropertySubType(_ipProperty);
        nDurationType2 = GetItemPropertyDurationType(_ipProperty);
        nPhysical2     = nSubType2 == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType2 == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType2 == IP_CONST_DAMAGETYPE_SLASHING;

        if (nType2 == nType1 &&
            nDurationType2 == nDurationType1 &&
            nPhysical2 == nPhysical1)
        {
            RemoveItemProperty(oItem, _ipProperty);
        }

        _ipProperty = GetNextItemProperty(oItem);
    }

    AddItemProperty(nDurationType1, ipProperty, oItem, fDuration);
}
//----------------------------------------------------------------
void gsIPRemoveAllProperties(object oItem)
{
    itemproperty ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ipProperty))
    {
        RemoveItemProperty(oItem, ipProperty);
        ipProperty = GetNextItemProperty(oItem);
    }
}
//----------------------------------------------------------------
void gsIPStackSkill(object oItem, int nSkill, int nBonus)
{
  int nSkillSoFar = 0;

  itemproperty iprp = GetFirstItemProperty(oItem);
  while (GetIsItemPropertyValid(iprp))
  {
    if (GetItemPropertyType(iprp) == ITEM_PROPERTY_SKILL_BONUS)
    {
      if (GetItemPropertySubType(iprp) == nSkill)
      {
        nSkillSoFar += GetItemPropertyCostTableValue(iprp);
        RemoveItemProperty(oItem, iprp);
      }
    }
    iprp = GetNextItemProperty(oItem);
  }

  AddItemProperty(DURATION_TYPE_PERMANENT,
                  ItemPropertySkillBonus(nSkill, nSkillSoFar + nBonus),
                  oItem);

}
//----------------------------------------------------------------
void gsIPStackAbility(object oItem, int nAbility, int nBonus)
{
  int nAbilitySoFar = 0;

  itemproperty iprp = GetFirstItemProperty(oItem);
  while (GetIsItemPropertyValid(iprp))
  {
    if (GetItemPropertyType(iprp) == ITEM_PROPERTY_ABILITY_BONUS)
    {
      if (GetItemPropertySubType(iprp) == nAbility)
      {
        nAbilitySoFar += GetItemPropertyCostTableValue(iprp);
        RemoveItemProperty(oItem, iprp);
      }
    }
    iprp = GetNextItemProperty(oItem);
  }

  AddItemProperty(DURATION_TYPE_PERMANENT,
                  ItemPropertyAbilityBonus(nAbility, nAbilitySoFar + nBonus),
                  oItem);
}
//----------------------------------------------------------------
string gsIPGetOwner(object oItem)
{
  return GetLocalString(oItem, "GS_OWNER");
}
//----------------------------------------------------------------
void gsIPSetOwner(object oItem, object oPC)
{
  if (GetLocalString(oItem, "GS_OWNER") == "")
  {
    AddStringElement("GS_OWNER", "VAR_LIST", oItem);
  }
  SetLocalString(oItem, "GS_OWNER", gsPCGetPlayerID(oPC));
}
//------------------------------------------------------------------------------
int gsIPGetMaterialType(object oItem)
{
  int nMaterial = 0;
  itemproperty ip = GetFirstItemProperty(oItem);

  while (GetIsItemPropertyValid(ip))
  {
    if (GetItemPropertyType(ip) == ITEM_PROPERTY_MATERIAL)
    {
      // NOTE - the property subtype is 0.  The material is indexed off the
      // cost table value.
	  if(GetItemPropertyCostTableValue(ip) <= 50)
	  {
	    // Do not return properties 51+ (gems).  These are treated as "bonus 
		// materials" in the system.  So a necklace might be "iron" and "garnet"
		// - we should return "iron" here and "garnet" in gsIPGetBonusMaterialType.
        nMaterial = GetItemPropertyCostTableValue(ip);
	  }	  
    }

    ip = GetNextItemProperty(oItem);
  }

  return nMaterial;
}
//------------------------------------------------------------------------------
int gsIPGetBonusMaterialType(object oItem)
{
  int nMaterial = 0;
  itemproperty ip = GetFirstItemProperty(oItem);

  while (GetIsItemPropertyValid(ip))
  {
    if (GetItemPropertyType(ip) == ITEM_PROPERTY_MATERIAL)
    {
      // NOTE - the property subtype is 0.  The material is indexed off the
      // cost table value.
	  // Bonus materials are gems - properties 51+ - that can exist alongside
	  // the main material on the item. 
	  if(GetItemPropertyCostTableValue(ip) > 50)
	  {
        nMaterial = GetItemPropertyCostTableValue(ip);
	  }	
    }

    ip = GetNextItemProperty(oItem);
  }

  return nMaterial;
}
//------------------------------------------------------------------------------
int gsIPGetQuality(object oItem)
{
  int nQuality = 0;
  itemproperty ip = GetFirstItemProperty(oItem);

  while (GetIsItemPropertyValid(ip))
  {
    if (GetItemPropertyType(ip) == ITEM_PROPERTY_QUALITY)
    {
      // NOTE - the property subtype is 0.  The quality is indexed off the
      // cost table value (iprp_qualcost.2da).
	  if(GetItemPropertyCostTableValue(ip) > 50)
	  {
        nQuality = GetItemPropertyCostTableValue(ip);
	  }	
    }

    ip = GetNextItemProperty(oItem);
  }

  return nQuality;
}
//------------------------------------------------------------------------------
int gsIPGetIsMundaneProperty(int ip, int subtype)
{
  switch (ip)
  {
    case ITEM_PROPERTY_AC_BONUS:
    case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
    case ITEM_PROPERTY_ATTACK_BONUS:
    case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
    case ITEM_PROPERTY_ENHANCEMENT_BONUS:
    case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
    case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
    case ITEM_PROPERTY_KEEN:
    case ITEM_PROPERTY_MASSIVE_CRITICALS:
    case ITEM_PROPERTY_MIGHTY:
      return TRUE;

    case ITEM_PROPERTY_DAMAGE_BONUS:
    case ITEM_PROPERTY_DAMAGE_REDUCTION:
    case ITEM_PROPERTY_DAMAGE_RESISTANCE:
    case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
    case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
    {
      switch (subtype)
      {
        case 0: // bludgeoning
        case 1: // piercing
        case 2: // slashing
           return TRUE;
      }
    }
  }

  return FALSE;
}
//------------------------------------------------------------------------------
int gsIPMeetsRestrictions(object oItem, object oPC)
{
  itemproperty ip = GetFirstItemProperty(oItem);
  int nSubType    = 0;
  int bAlignGOK   = -1;
  int bAlignSOK   = -1;
  int bClassOK    = -1;
  int bRaceOK     = -1;

  while (GetIsItemPropertyValid(ip))
  {
    if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP && bAlignGOK != 1)
    {
      // Subtype is an index into IPRP_ALIGNGRP
      nSubType = GetItemPropertySubType(ip);
	  
	  switch (nSubType)
	  {
	    case 1:  // Neutral
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL ||
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL))
			bAlignGOK = FALSE;
		  break;
		case 2:  // Lawful
		  if (!GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) bAlignGOK = FALSE;
		  break;
		case 3:  // Chaotic
		  if (!GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC) bAlignGOK = FALSE;
		  break;
		case 4:  // Good
		  if (!GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD) bAlignGOK = FALSE;
		  break;
		case 5:  // Evil
		  if (!GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL) bAlignGOK = FALSE;
		  break;
	  }
	  
      //------------------------------------------------------------------------
	  // If we get here, we match the alignment property.  Mark our alignment as
	  // OK and skip any further checks of alignment group property.
      //------------------------------------------------------------------------
	  bAlignGOK = 1;
    }
	else if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS && bClassOK != 1)
    {
      // Subtype is class type.
      nSubType = GetItemPropertySubType(ip);
	  
	  if (GetLevelByClass(nSubType, oPC) == 0) bClassOK = FALSE;
	  else bClassOK = 1;
    }
	else if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE && bRaceOK != 1)
    {
      // Subtype is racial type.
      nSubType = GetItemPropertySubType(ip);
	  
	  if (GetRacialType(oPC) != nSubType) bRaceOK = FALSE;
	  else bRaceOK = 1;
	  
    }
	else if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT && bAlignSOK != 1)
    {
      // Subtype is an index into IPRP_ALIGNMENT
      nSubType = GetItemPropertySubType(ip);
	  
	  switch (nSubType)
	  {
	    case 0:  // LG
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
			bAlignSOK = FALSE;
		case 1:  // LN
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
			bAlignSOK = FALSE;
		case 2:  // LE
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
			bAlignSOK = FALSE;
		case 3:  // NG
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL))
			bAlignSOK = FALSE;
		case 4:  // NN
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL))
			bAlignSOK = FALSE;
		case 5:  // NE
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL))
			bAlignSOK = FALSE;
		case 6:  // CG
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
			bAlignSOK = FALSE;
		case 7:  // CN
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
			bAlignSOK = FALSE;
		case 8:  // CE
		  if (! (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL &&
		         GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
			bAlignSOK = FALSE;
	  }
	  
	  bAlignSOK = 1;
    }

    ip = GetNextItemProperty(oItem);
  }
  
  //----------------------------------------------------------------------------
  // Values of -1 (uninitialised, no property of that type) and 1 (OK) both
  // evaluate to TRUE, so fail only if we have a property set to FALSE
  //----------------------------------------------------------------------------
  if (!bAlignSOK || !bAlignGOK || !bClassOK || !bRaceOK) return FALSE;
  
  return TRUE;
}
//------------------------------------------------------------------------------
int gsIPDoUMDCheck(object oItem, object oPC)
{
	int nUMDOverride = GetLocalInt(oItem, "UMD_REQUIREMENT");
	if (!nUMDOverride || GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC) >= nUMDOverride) return TRUE;
	
	// Check whether the PC can equip the item naturally.
    if (!gsIPMeetsRestrictions(oItem, oPC))
    {	
        FloatingTextStringOnCreature("You need " + IntToString(nUMDOverride) + " ranks in Use Magic Device to use that item.", oPC);
		return FALSE;
	}	
	
	return TRUE;
}