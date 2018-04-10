/*
  Mith's Crafting System v1.0
*/
#include "x2_inc_switches"
#include "mcrft_incl"
void Enhance(object oItem, int nEnhancement)
{
  Trace(CRAFTING, "Adding AC bonus to " + GetName(oItem) + " to +" + IntToString(nEnhancement));

  DestroyObject(GetItemActivated());
  Message2("The scroll glows bright blue and disintegrates. Your item feels warm to the touch.");
  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(nEnhancement), oItem);
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

    if ( (nType == BASE_ITEM_ARMOR) ||
         (nType == BASE_ITEM_SMALLSHIELD) ||
         (nType == BASE_ITEM_TOWERSHIELD) ||
         (nType == BASE_ITEM_LARGESHIELD) ||
         (nType == BASE_ITEM_CLOAK) ||
         (nType == BASE_ITEM_BOOTS) ||
         (nType == BASE_ITEM_BELT) ||
         (nType == BASE_ITEM_BRACER) ||
         (nType == BASE_ITEM_HELMET) ||
         (nType == BASE_ITEM_GLOVES) )
    {
      if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS))
      {
        itemproperty iprp = GetFirstItemProperty(oItem);
        int nAddedNew = 1;

        while (GetIsItemPropertyValid(iprp))
        {
          if (GetItemPropertyType(iprp) == ITEM_PROPERTY_AC_BONUS)
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
      Message2("Invalid Target: Scroll must be used on armor, clothing or shield.");
    }
  }
}
