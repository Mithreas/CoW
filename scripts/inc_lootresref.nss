#include "inc_baseitem"
#include "inc_lootgen"

// ------ PUBLIC API ------

// Adds a resref into the pool of allowed resrefs for the provided base item type.
// NOTE: Uses the expanded list of base item types from inc_baseitem.
void AddBaseItemResRef(int baseItemType, string resref);

// Gets a random resref from the pool of allowed resrefs for the provided ITEM_TYPE_* constant.
string GetRandomResRefFromItemType(int itemType);

// Gets a random resref from the pool of allowed resrefs for the provided BASE_ITEM_* constant.
string GetFirstResRefFromBaseItemType(int baseItemType);

// ------ INTERNAL API ------

const string INTERNAL_RESREF_ARRAY_TAG = "LOOTGEN_RESREF_ARRAY";

// Returns a base item type from the provide ITEM_TYPE_* constant.
// NOTE: May return an expanded base item type from inc_baseitem.
int INTERNAL_GetRandomBaseItemTypeFromItemType(int itemType);

void AddBaseItemResRef(int baseItemType, string resref)
{
    StringArray_PushBack(GetModule(), INTERNAL_RESREF_ARRAY_TAG + IntToString(baseItemType), resref);
}

string GetFirstResRefFromBaseItemType(int baseItemType)
{
    string tag = INTERNAL_RESREF_ARRAY_TAG + IntToString(baseItemType);
    int count = StringArray_Size(GetModule(), tag);
    return count > 0 ? StringArray_At(GetModule(), tag, 0) : "";
}

string GetRandomResRefFromBaseItemType(int baseItemType)
{
    string tag = INTERNAL_RESREF_ARRAY_TAG + IntToString(baseItemType);
    int count = StringArray_Size(GetModule(), tag);
    return count > 0 ? StringArray_At(GetModule(), tag,  Random(count)) : "";
}

string GetRandomResRefFromItemType(int itemType)
{
    int baseItemType = INTERNAL_GetRandomBaseItemTypeFromItemType(itemType);
    string tag = INTERNAL_RESREF_ARRAY_TAG + IntToString(baseItemType);
    int count = StringArray_Size(GetModule(), tag);
    return count > 0 ? StringArray_At(GetModule(), tag, Random(count)) : "";
}

int INTERNAL_GetRandomBaseItemTypeFromItemType(int itemType)
{
    if (itemType == ITEM_TYPE_GEAR)
    {
        switch (Random(8))
        {
            case 0: return BASE_ITEM_AMULET;
            case 1: return BASE_ITEM_BELT;
            case 2: return BASE_ITEM_BRACER;
            case 3: return BASE_ITEM_CLOAK;
            case 4: return BASE_ITEM_GLOVES;
            case 5:
            case 6: return BASE_ITEM_RING;
            case 7: return BASE_ITEM_BOOTS;
        }
    }
    else if (itemType == ITEM_TYPE_ARMOUR)
    {
        switch (Random(13))
        {
            case 0: return BASE_ITEM_ARMOR_AC0;
            case 1: return BASE_ITEM_ARMOR_AC1;
            case 2: return BASE_ITEM_ARMOR_AC2;
            case 3: return BASE_ITEM_ARMOR_AC3;
            case 4: return BASE_ITEM_ARMOR_AC4;
            case 5: return BASE_ITEM_ARMOR_AC5;
            case 6: return BASE_ITEM_ARMOR_AC6;
            case 7: return BASE_ITEM_ARMOR_AC7;
            case 8: return BASE_ITEM_ARMOR_AC8;
            case 9: return BASE_ITEM_HELMET;
            case 10: return BASE_ITEM_SMALLSHIELD;
            case 11: return BASE_ITEM_LARGESHIELD;
            case 12: return BASE_ITEM_TOWERSHIELD;
        }
    }
    else if (itemType == ITEM_TYPE_WEAPON)
    {
        switch(Random(36))
        {
            case 0:  return BASE_ITEM_SHORTSWORD;
            case 1:  return BASE_ITEM_LONGSWORD;
            case 2:  return BASE_ITEM_BATTLEAXE;
            case 3:  return BASE_ITEM_DART;
            case 4:  return BASE_ITEM_LIGHTFLAIL;
            case 5:  return BASE_ITEM_WARHAMMER;
            case 6:  return BASE_ITEM_HEAVYCROSSBOW;
            case 7:  return BASE_ITEM_LIGHTCROSSBOW;
            case 8:  return BASE_ITEM_LONGBOW;
            case 9:  return BASE_ITEM_LIGHTMACE;
            case 10: return BASE_ITEM_HALBERD;
            case 11: return BASE_ITEM_SHORTBOW;
            case 12: return BASE_ITEM_TWOBLADEDSWORD;
            case 13: return BASE_ITEM_GREATSWORD;
            case 14: return BASE_ITEM_GREATAXE;
            case 15: return BASE_ITEM_DAGGER;
            case 16: return BASE_ITEM_CLUB;
            case 17: return BASE_ITEM_DIREMACE;
            case 18: return BASE_ITEM_DOUBLEAXE;
            case 19: return BASE_ITEM_HEAVYFLAIL;
            case 20: return BASE_ITEM_LIGHTHAMMER;
            case 21: return BASE_ITEM_HANDAXE;
            case 22: return BASE_ITEM_KAMA;
            case 23: return BASE_ITEM_KATANA;
            case 24: return BASE_ITEM_KUKRI;
            case 25: return BASE_ITEM_MORNINGSTAR;
            case 26: return BASE_ITEM_QUARTERSTAFF;
            case 27: return BASE_ITEM_RAPIER;
            case 28: return BASE_ITEM_SCIMITAR;
            case 29: return BASE_ITEM_THROWINGAXE;
            case 30: return BASE_ITEM_SHORTSPEAR;
            case 31: return BASE_ITEM_SICKLE;
            case 32: return BASE_ITEM_SLING;
            case 33: return BASE_ITEM_SHURIKEN;
            case 34: return BASE_ITEM_DWARVENWARAXE;
            case 35: return BASE_ITEM_WHIP;
        }
    }

    return -1;
}
