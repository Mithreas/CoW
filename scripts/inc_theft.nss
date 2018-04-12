/* THEFT Library by Gigaschatten */

//void main() {}
#include "inc_common"
#include "inc_stacking"
//set oStolenFrom as previous owner of oItem
void gsTHSetStolenFrom(object oItem, object oStolenFrom);
//return previous owner of oItem
object gsTHGetStolenFrom(object oItem);
//return TRUE if oCreature possesses an item of oStolenFrom
int gsTHGetHasItemStolenFrom(object oCreature, object oStolenFrom);
//reset stolen state of oItem
void gsTHResetStolenItem(object oItem);
//return items from oCreature to oStolenFrom
void gsTHReturnStolenItems(object oCreature, object oStolenFrom);
// return TRUE if the item is stealable.
// Items that are larger than 1x2 (or 2x1) cannot be stolen.
int gsTHCanStealItem(object oItem);

void gsTHSetStolenFrom(object oItem, object oStolenFrom)
{
    if (! GetIsObjectValid(gsTHGetStolenFrom(oItem)) &&
        GetObjectType(oStolenFrom) == OBJECT_TYPE_CREATURE)
    {
        SetLocalObject(oItem, "GS_TH_STOLEN_FROM", oStolenFrom);
    }
}
//----------------------------------------------------------------
object gsTHGetStolenFrom(object oItem)
{
    return GetLocalObject(oItem, "GS_TH_STOLEN_FROM");
}
//----------------------------------------------------------------
int gsTHGetHasItemStolenFrom(object oCreature, object oStolenFrom)
{
    object oItem = GetFirstItemInInventory(oCreature);

    while (GetIsObjectValid(oItem))
    {
        if (gsTHGetStolenFrom(oItem) == oStolenFrom) return TRUE;

        oItem = GetNextItemInInventory(oCreature);
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsTHResetStolenItem(object oItem)
{
    DeleteLocalObject(oItem, "GS_TH_STOLEN_FROM");
    SetStolenFlag(oItem, FALSE);
}
//----------------------------------------------------------------
void gsTHReturnStolenItems(object oCreature, object oStolenFrom)
{
    object oItem = GetFirstItemInInventory(oCreature);
    object oCopy = OBJECT_INVALID;

    while (GetIsObjectValid(oItem))
    {
        if (gsTHGetStolenFrom(oItem) == oStolenFrom)
        {
            oCopy = gsCMCopyItem(oItem, oStolenFrom, TRUE);

            if (GetIsObjectValid(oCopy))
            {
                gsTHResetStolenItem(oCopy);
                DestroyObject(oItem);
            }
        }

        oItem = GetNextItemInInventory(oCreature);
    }
}

//----------------------------------------------------------------
int gsTHCanStealItem(object oItem)
{
  // Dunshine: keyring items should be excluded, since keys are as well
  if (ConvertedStackTag(oItem) == "gvd_keyring") {
    return FALSE;
  }

  int nBaseItemType = GetBaseItemType(oItem);

  switch (nBaseItemType)
  {
    case BASE_ITEM_AMULET:
    case BASE_ITEM_ARROW:
    case BASE_ITEM_BELT:
    case BASE_ITEM_BLANK_POTION:
    case BASE_ITEM_BLANK_SCROLL:
    case BASE_ITEM_BLANK_WAND:
    case BASE_ITEM_BOLT:
    case BASE_ITEM_BRACER:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_CRAFTMATERIALMED:
    case BASE_ITEM_CRAFTMATERIALSML:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_ENCHANTED_POTION:
    case BASE_ITEM_ENCHANTED_SCROLL:
    case BASE_ITEM_ENCHANTED_WAND:
    case BASE_ITEM_GEM:
    case BASE_ITEM_GLOVES:
    case BASE_ITEM_GOLD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_GRENADE:
    case BASE_ITEM_HEALERSKIT:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_MAGICWAND:
    case BASE_ITEM_MISCSMALL:
    case BASE_ITEM_MISCTHIN:
    case BASE_ITEM_MISCWIDE:
    case BASE_ITEM_POTIONS:
    case BASE_ITEM_RING:
    case BASE_ITEM_SCROLL:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SLING:
    case BASE_ITEM_SPELLSCROLL:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_SHORTSWORD:
      return TRUE;

    case BASE_ITEM_ARMOR:
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_BOOK:
    case BASE_ITEM_BOOTS:
    case BASE_ITEM_CBLUDGWEAPON:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_CPIERCWEAPON:
    case BASE_ITEM_CREATUREITEM:
    case BASE_ITEM_CSLASHWEAPON:
    case BASE_ITEM_CSLSHPRCWEAP:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_HELMET:
    case BASE_ITEM_INVALID:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_LARGEBOX:
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MAGICROD:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_MISCLARGE:
    case BASE_ITEM_MISCMEDIUM:
    case BASE_ITEM_MISCTALL:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_THIEVESTOOLS:
    case BASE_ITEM_TORCH:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_TRAPKIT:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
    case BASE_ITEM_WHIP:
      return FALSE;
    case BASE_ITEM_KEY:  // NPC only.
	  return 2;
  }

  return FALSE;
}
