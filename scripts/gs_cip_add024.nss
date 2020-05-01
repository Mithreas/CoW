#include "inc_common"
#include "inc_craft"
#include "inc_divination"
#include "inc_iprop"
#include "inc_language"
#include "inc_text"
#include "inc_worship"
#include "inc_xp"

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
        int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

        itemproperty ipProperty = gsIPGetItemProperty(nPropertyID, nSubTypeID, nCostID, nParamID);
        int bMundane = gsIPGetIsMundaneProperty(GetItemPropertyType(ipProperty), GetItemPropertySubType(ipProperty));

        if (GetIsItemPropertyValid(ipProperty))
        {
            object oSpeaker = GetPCSpeaker();
            int nDM         = GetIsDM(oSpeaker);
            int nCost       = nDM ? 0 : gsIPGetCost(oItem, ipProperty);
            int nBaseCost   = nCost;

            if (bStaticLevel)
            {
              if ( (gsCMGetItemValue(oItem) + nBaseCost - gsCRGetMaterialBaseValue(oItem)) > GS_CR_FL_MAX_ITEM_VALUE)
              {
                // Max item value reached.
                SetCustomToken(100, "This item is too powerful to enchant.");
                return TRUE;
              }

              nCost = FloatToInt(IntToFloat(nCost) * gsCRGetCraftingCostMultiplier(oSpeaker, oItem, ipProperty));
            }
            else
            {
              // Addition by Mithreas. Enchanters are better at enchanting. --[
              if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
              {
                nCost = FloatToInt(IntToFloat(nCost) * 0.65); // 35% discount
              }
              else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
              {
                nCost = FloatToInt(IntToFloat(nCost) * 0.80); // 20% discount
              }
              else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
              {
                nCost = FloatToInt(IntToFloat(nCost) * 0.90); // 10% discount
              }
              // ]-- End addition.
            }

            if (! nDM && nCost > GetGold(oSpeaker))
            {
                SetCustomToken(100, GS_T_16777238);
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
                                                * IntToFloat(gsCMGetItemValue(oItem) - gsCRGetMaterialBaseValue(oItem)));

                        // Impose a min cost to avoid abusing merchants.  Max possible
                        // merchant buy price is 75% of base value so make this the min
                        // for items under 300g.
                        if ( ((gsCMGetItemValue(oItem) + nBaseCost) < 400) && (gsCRGetCraftingCostMultiplier(oSpeaker, oItem, ipProperty) < 0.75))
                        {
                           nCost = FloatToInt(IntToFloat(nBaseCost) * 0.75);
                        }

                        nChance = ((nBaseItemValue + nCost) * 100) / GS_LIMIT_COST;
                        if (nChance >= 100)       nImpossible = TRUE; // No divine intervention.
                        if (nChance < 5)        nChance =   5;
                        else if (nChance > 95) nChance = 95;

                        TakeGoldFromCreature(nCost, oSpeaker, TRUE);
                    }

                    if (!bStaticLevel && GetXP(oSpeaker) < nCost/10)
                    {
                      SetCustomToken(100, "You don't have enough XP.");
                      return TRUE;
                    }
					
					// Making things - divination hook.
					if (bMundane) miDVGivePoints(oSpeaker, ELEMENT_EARTH, 4.0);
					else miDVGivePoints(oSpeaker, ELEMENT_FIRE, 4.0);

                    if (Random(100) < nChance)
                    {
                        // divine intervention
                        string sDeity = GetDeity(oSpeaker);
                        int nAspect = ASPECT_MAGIC;
                        if (bStaticLevel && bMundane) nAspect = ASPECT_KNOWLEDGE_INVENTION;

						// Runic
						int nRunic = GetLocalInt(oItem, "RUNIC");
						int nRunicLang = GetLocalInt(oItem, "RUNIC_LANGUAGE");

                        if (!nImpossible &&
                            gsWOGetDeityAspect(oSpeaker) & nAspect &&
                            d2() == 2 &&
                            gsWOGrantBoon(oSpeaker) )
                        {
                          FloatingTextStringOnCreature(sDeity + " augments your skill and grants you success.", oSpeaker);
                        }
						else if (!nImpossible && 
						         nRunic && 
						         gsLAGetCanSpeakLanguage(nRunicLang, oSpeaker) &&
								 !bMundane && 
								 d2() == 2)
						{
						  FloatingTextStringOnCreature("The runes on this item glow brightly for a moment, and the enchantment takes.", oSpeaker);
						}
                        else
                        {
                          nCost   /= 10;
                          SetCustomToken(100, gsCMReplaceString(GS_T_16777239, bStaticLevel ? "0" : IntToString(nCost)));
                          DestroyObject(oItem);
                          if (!bStaticLevel) gsXPGiveExperience(oSpeaker, -nCost);
                          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                              EffectVisualEffect(VFX_IMP_DEATH),
                                              OBJECT_SELF);
                          return TRUE;
                        }
                    }
                }

                SetCustomToken(100, GS_T_16777240);
                gsIPAddItemProperty(oItem, ipProperty);

                if (gsIPGetOwner(oItem) != gsPCGetPlayerID(oSpeaker))
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

