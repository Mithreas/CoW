// TODO: To be massively expanded to handle procedurally generated loot naming and descriptions.

// ----- PUBLIC API ------

void ApplyLootNamingScheme(object loot, object finder);

// ----- INTERNAL API ------

string INTERNAL_GetGenericNameFromItemType(int itemType);

//
// -----
//

void ApplyLootNamingScheme(object loot, object finder)
{
    string name = INTERNAL_GetGenericNameFromItemType(GetBaseItemType(loot));
    SetName(loot, name);

    string description = "A magical item";

    if (GetIsObjectValid(finder))
    {
        string areaName = GetSubString(GetName(GetArea(finder)), 0, FindSubString(GetName(GetArea(finder)), "(") -1);
        description += " which was discovered in the " + areaName;
    }

    description += " region.";
    SetDescription(loot, description);
}

string INTERNAL_GetGenericNameFromItemType(int itemType)
{
    switch (itemType)
    {
        case BASE_ITEM_AMULET:
            return "Magical Amulet";

        case BASE_ITEM_ARMOR:
            return "Magical Armour";

        case BASE_ITEM_BELT:
            return "Magical Belt";

        case BASE_ITEM_BOOTS:
            return "Magical Boots";

        case BASE_ITEM_BRACER:
            return "Magical Bracers";

        case BASE_ITEM_CLOAK:
            return "Magical Cloak";

        case BASE_ITEM_GLOVES:
            return "Magical Gloves";

        case BASE_ITEM_HELMET:
            return "Magical Helmet";

        case BASE_ITEM_RING:
            return "Magical Ring";

        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD:
            return "Magical Shield";

        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
            return "Magical Weapon";
    }

    return "Magical Item";
}
