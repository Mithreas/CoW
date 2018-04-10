#include "gs_inc_common"

const int GS_LIMIT_ITEM_VALUE            = 12000; //maximum item value
const int GS_ITEM_REPLACEMENT_PERCENTAGE =    10; //item replacement in percent
const int GS_LIMIT_GOLD                  = 50000; //maximum gold

int gsGetIsItemEquippable(object oItem)
{
    switch (GetBaseItemType(oItem))
    {
    case BASE_ITEM_AMULET:
    case BASE_ITEM_ARMOR:
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_BELT:
    case BASE_ITEM_BOOTS:
    case BASE_ITEM_BRACER:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GLOVES:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_HELMET:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_RING:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TORCH:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
    case BASE_ITEM_WHIP:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsLimitItem(object oItem)
{
    // Don't destroy subrace items.
    if (GetResRef(oItem) == "gs_item317" || GetResRef(oItem) == "gs_item318")
    {
      return FALSE;
    }

    if (gsGetIsItemEquippable(oItem))
    {
        int nValue = gsCMGetItemValue(oItem);

        if (nValue > GS_LIMIT_ITEM_VALUE)
        {
            DestroyObject(oItem);
            return nValue * 10 / 100;
        }
    }
    else
    {
        DestroyObject(oItem);
    }

    return FALSE;
}
//----------------------------------------------------------------
void main()
{
    object oItem = OBJECT_INVALID;
    int nGold1   = GetGold();
    int nGold2   = nGold1;
    int bStaticLevel   = GetLocalInt(GetModule(), "STATIC_LEVEL");

    if (bStaticLevel) return;  // don't strip items on the FL server.

    //limit gold
    if (nGold1 > GS_LIMIT_GOLD) nGold2 = nGold1 - GS_LIMIT_GOLD;

    //limit item value
    oItem        = GetItemInSlot(INVENTORY_SLOT_ARMS);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_ARROWS);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BELT);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BOLTS);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BOOTS);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BULLETS);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CLOAK);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_HEAD);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_LEFTRING);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_NECK);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTRING);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CARMOUR);
    if (GetIsObjectValid(oItem)) nGold2 += gsLimitItem(oItem);

    oItem        = GetFirstItemInInventory();

    while (GetIsObjectValid(oItem))
    {
        nGold2 += gsLimitItem(oItem);
        oItem   = GetNextItemInInventory();
    }

    //adjust gold
    if (nGold1 > nGold2)      TakeGoldFromCreature(nGold1 - nGold2, OBJECT_SELF, TRUE);
    else if (nGold2 > nGold1) gsCMCreateGold(nGold2 - nGold1);
}
