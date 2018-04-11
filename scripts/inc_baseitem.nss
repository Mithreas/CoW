// These start from the last base item present in the base game.
const int BASE_ITEM_ARMOR_AC0 = 112;
const int BASE_ITEM_ARMOR_AC1 = 113;
const int BASE_ITEM_ARMOR_AC2 = 114;
const int BASE_ITEM_ARMOR_AC3 = 115;
const int BASE_ITEM_ARMOR_AC4 = 116;
const int BASE_ITEM_ARMOR_AC5 = 117;
const int BASE_ITEM_ARMOR_AC6 = 118;
const int BASE_ITEM_ARMOR_AC7 = 119;
const int BASE_ITEM_ARMOR_AC8 = 120;

int GetBaseItemTypeExpanded(object item)
{
    int baseItemType = GetBaseItemType(item);

    if (baseItemType == BASE_ITEM_ARMOR)
    {
        int ac = GetItemACValue(item);
        switch (ac)
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
            default: return BASE_ITEM_ARMOR;
        }
    }

    return baseItemType;
}