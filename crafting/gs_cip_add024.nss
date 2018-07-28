#include "inc_craft"
#include "inc_iprop"

const int GS_LIMIT_COST = 10000;

int GetIsEnchantable(object oItem)
{
  // Corpses cannot be enchanted.
  string sResRef = GetResRef(oItem);
  return !(sResRef == "gs_item_016" || sResRef == "gs_item_017");
}

int StartingConditional()
{
    object oItem = GetFirstItemInInventory();

    if (GetIsObjectValid(oItem))
    {
        if (!GetIsEnchantable(oItem))
        {
            FloatingTextStringOnCreature("That object resists enchantment.",
              GetPCSpeaker(), FALSE);
            return FALSE;
        }

        int nPropertyID = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_ID");
        int nSubTypeID  = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE_ID");
        int nCostID     = GetLocalInt(OBJECT_SELF, "GS_COST_ID");
        int nParamID    = GetLocalInt(OBJECT_SELF, "GS_PARAM_ID");

        itemproperty ipProperty = gsIPGetItemProperty(nPropertyID, nSubTypeID, nCostID, nParamID);
        int bMundane = gsIPGetIsMundaneProperty(GetItemPropertyType(ipProperty), GetItemPropertySubType(ipProperty));

        if (GetIsItemPropertyValid(ipProperty))
        {
            object oSpeaker = GetPCSpeaker();
            int nDM         = GetIsDM(oSpeaker);
            int nCost       = nDM ? 0 : gsIPGetCost(oItem, ipProperty);
            int nBaseCost   = nCost;

            if (gsCMGetItemValue(oItem) + nBaseCost - gsCRGetMaterialBaseValue(oItem) > GS_CR_FL_MAX_ITEM_VALUE)
            {
                // Max item value reached.
                SetCustomToken(100, "This item is too powerful to enchant.");
                return TRUE;
            }

            nCost = FloatToInt(IntToFloat(nCost) * gsCRGetCraftingCostMultiplier(oSpeaker, oItem, ipProperty));
           

            if (! nDM && nCost > GetGold(oSpeaker))
            {
                SetCustomToken(100, "You do not have enough gold.");
            }
            else
            {
                if (! nDM)
                {
                    int nChance = 5;
                    int nImpossible = FALSE;

                    if (nCost)
                    {
                        int nBaseItemValue = FloatToInt(gsCRGetCraftingCostMultiplier(oSpeaker, oItem, ipProperty)
                                                * IntToFloat(gsCMGetItemValue(oItem)));

                        // Impose a min cost to avoid abusing merchants.  Max possible
                        // merchant buy price is 75% of base value so make this the min
                        // for items under 300g.
                        if (nBaseItemValue + nCost < 300 && gsCRGetCraftingCostMultiplier(oSpeaker, oItem, ipProperty) < 0.75)
                        {
                           nCost = FloatToInt(IntToFloat(nBaseCost) * 0.75);
                        }

                        nChance = (nBaseItemValue + nCost) * 100 / GS_LIMIT_COST;
                        if (nChance >= 100)       nImpossible = TRUE; // No divine intervention.
                        if (nChance < 5)        nChance =   5;
                        else if (nChance > 95) nChance = 95;

                        TakeGoldFromCreature(nCost, oSpeaker, TRUE);
                    }

                    if (Random(100) < nChance)
                    {
                        nCost   /= 10;
                        SetCustomToken(100, "The attempt failed, the item has been destroyed.");
                        DestroyObject(oItem);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                            EffectVisualEffect(VFX_IMP_DEATH),
                                            OBJECT_SELF);
                        return TRUE;
                    }
                }

                SetCustomToken(100, "The property has been added to the item.");
                gsIPAddItemProperty(oItem, ipProperty);

                if (gsIPGetOwner(oItem) != GetName(oSpeaker))
                {
                  gsIPSetOwner(oItem, oSpeaker);
                }

                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
                                    OBJECT_SELF);
            }
        }

        return TRUE;
    }

    return FALSE;
}

