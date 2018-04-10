/*
  Mith's Crafting System v1.0
*/
#include "x2_inc_switches"
#include "mcrft_incl"
void Enhance(object oItem, int nEnhancement)
{
  Trace(CRAFTING, "Adding enhancement bonus to " + GetName(oItem) + " to +" + IntToString(nEnhancement));

  DestroyObject(GetItemActivated());
  Message2("The scroll glows bright blue and disintegrates. Your item feels warm to the touch.");
  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(nEnhancement), oItem);
}

int GetNextEnhancementLevel(itemproperty iprp)
{
  int nRow = GetItemPropertyCostTableValue(iprp);

  if ((nRow > 9) || (nRow < 0))
  {
   return(-1);
  }
  else
  {
    return (nRow + 1);
  }
}

void main()
{
  if (GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_ACTIVATE)
  {
    object oItem = GetItemActivatedTarget();
    object oPC   = GetItemActivator();
    int    nType = GetBaseItemType(oItem);

    if ( (nType == BASE_ITEM_BASTARDSWORD) ||
         (nType == BASE_ITEM_BATTLEAXE) ||
         (nType == BASE_ITEM_CBLUDGWEAPON) ||
         (nType == BASE_ITEM_CPIERCWEAPON) ||
         (nType == BASE_ITEM_CSLASHWEAPON) ||
         (nType == BASE_ITEM_CSLSHPRCWEAP) ||
         (nType == BASE_ITEM_DAGGER) ||
         (nType == BASE_ITEM_DIREMACE) ||
         (nType == BASE_ITEM_DOUBLEAXE) ||
         (nType == BASE_ITEM_DWARVENWARAXE) ||
         (nType == BASE_ITEM_GREATAXE) ||
         (nType == BASE_ITEM_GREATSWORD) ||
         (nType == BASE_ITEM_HALBERD) ||
         (nType == BASE_ITEM_HANDAXE) ||
         (nType == BASE_ITEM_HEAVYCROSSBOW) ||
         (nType == BASE_ITEM_HEAVYFLAIL) ||
         (nType == BASE_ITEM_KAMA) ||
         (nType == BASE_ITEM_KATANA) ||
         (nType == BASE_ITEM_KUKRI) ||
         (nType == BASE_ITEM_LIGHTCROSSBOW) ||
         (nType == BASE_ITEM_LIGHTFLAIL) ||
         (nType == BASE_ITEM_LIGHTHAMMER) ||
         (nType == BASE_ITEM_LIGHTMACE) ||
         (nType == BASE_ITEM_LONGBOW) ||
         (nType == BASE_ITEM_LONGSWORD) ||
         (nType == BASE_ITEM_MORNINGSTAR) ||
         (nType == BASE_ITEM_QUARTERSTAFF) ||
         (nType == BASE_ITEM_RAPIER) ||
         (nType == BASE_ITEM_SCIMITAR) ||
         (nType == BASE_ITEM_SCYTHE) ||
         (nType == BASE_ITEM_SHORTBOW) ||
         (nType == BASE_ITEM_SHORTSPEAR) ||
         (nType == BASE_ITEM_SHORTSWORD) ||
         (nType == BASE_ITEM_SICKLE) ||
         (nType == BASE_ITEM_SLING) ||
         (nType == BASE_ITEM_THROWINGAXE) ||
         (nType == BASE_ITEM_TWOBLADEDSWORD) ||
         (nType == BASE_ITEM_WARHAMMER) ||
         (nType == BASE_ITEM_WHIP) )
    {
      if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS))
      {
        itemproperty iprp = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(iprp))
        {
          if (GetItemPropertyType(iprp) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
          {
            // AddedEnhancement does the work of actually enhancing the item.
            if (AddedEnhancement(oItem, iprp))
            {
              RemoveItemProperty(oItem, iprp);
            }

            break;
          }

          iprp = GetNextItemProperty(oItem);
        }
      }
      else
      {
        Enhance(oItem, 1);
      }
    }
    else
    {
      Message2("Invalid Target: Scroll must be used on a weapon.");
    }
  }
}
