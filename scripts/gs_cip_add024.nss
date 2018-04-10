#include "gs_inc_common"
#include "gs_inc_craft"
#include "gs_inc_iprop"
#include "gs_inc_text"
#include "gs_inc_worship"
#include "gs_inc_xp"

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

        //::   Disable Appraise enchanting for now
        if ( nPropertyID == 52 && nSubTypeID == 20 ) {
            SendMessageToPC(GetPCSpeaker(), "Huh... Something is amiss with the Basin.");
            return FALSE;
        }

        itemproperty ipProperty = gsIPGetItemProperty(nPropertyID, nSubTypeID, nCostID, nParamID);
        int bMundane = gsIPGetIsMundaneProperty(ipProperty);

        if (GetIsItemPropertyValid(ipProperty))
        {
            object oSpeaker = GetPCSpeaker();
            int nDM         = GetIsDM(oSpeaker);
            int nCost       = nDM ? 0 : gsIPGetCost(oItem, ipProperty);
            int nBaseCost   = nCost;

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

                    if (nImpossible && GetXP(oSpeaker) < nCost/10)
                    {
                      SetCustomToken(100, "You don't have enough XP.");
                      return TRUE;
                    }

                    int runic = GetLocalInt(oItem, "RUNIC");

                    if (runic)
                    {
                      int permittedRace = GetLocalInt(oItem, "RUNIC_TYPE");
                      int runicLang = GetLocalInt(oItem, "RUNIC_LANGUAGE") - 1;
                      int runicLang2 = -1;
                      int actualRace = GetRacialType(oSpeaker);
                      if(runicLang == -1)
                      {
                        if(permittedRace == RACIAL_TYPE_DWARF)
                            runicLang = GS_LA_LANGUAGE_DWARVEN;
                        else if(permittedRace == RACIAL_TYPE_ELF)
                          runicLang = GS_LA_LANGUAGE_ELVEN;

                      }
                      if(runicLang == GS_LA_LANGUAGE_ELVEN)
                        runicLang2 = GS_LA_LANGUAGE_XANALRESS;
                      else if(runicLang == GS_LA_LANGUAGE_XANALRESS)
                        runicLang2 = GS_LA_LANGUAGE_ELVEN;

                      object oHide = gsPCGetCreatureHide(oSpeaker);
                                                            // 2 has been used to mean all races
                      if (permittedRace == RACIAL_TYPE_ALL || permittedRace == 2 || runicLang == GS_LA_LANGUAGE_COMMON || (runicLang != -1 && GetLocalInt(oHide, "GS_LA_LANGUAGE_"+IntToString(runicLang))) || (runicLang2 != -1 && GetLocalInt(oHide, "GS_LA_LANGUAGE_"+IntToString(runicLang2))))
                      {
                        int extraChance = 0;

                        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
                        {
                          extraChance = 100;
                        }
                        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
                        {
                          extraChance = 66;
                        }
                        else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
                        {
                          extraChance = 33;
                        }

                        // This might bring the chance of failure below 0, but that's fine, the code below will cope with it.
                        nChance -= extraChance;
                      }
                    }

                    if (Random(100) < nChance)
                    {
                        // divine invervention
                        string sDeity = GetDeity(oSpeaker);
                        int nAspect = ASPECT_MAGIC;

                        if (!nImpossible &&
                            gsWOGetDeityAspect(oSpeaker) & nAspect &&
                            d2() == 2 &&
                            gsWOGrantBoon(oSpeaker) )
                        {
                            SendMessageToPC(oSpeaker,sDeity + " augments your skill and grants you success.");
                        }
                        else
                        {
                          nCost   /= 10;
                          int xpLoss = nImpossible ? nCost : 0;
                          SetCustomToken(100, gsCMReplaceString(GS_T_16777239, IntToString(xpLoss)));
                          DestroyObject(oItem);
                          if (xpLoss) gsXPGiveExperience(oSpeaker, -xpLoss);
                          ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                              EffectVisualEffect(VFX_IMP_DEATH),
                                              OBJECT_SELF);
                          return TRUE;
                        }
                    }

                    if (runic)
                    {
                      DeleteLocalInt(oItem, "RUNIC");
                      DeleteLocalInt(oItem, "RUNIC_TYPE");
                      DeleteLocalInt(oItem, "RUNIC_LANGUAGE");
                      // Remove the name color.
                      string name = GetName(oItem);
                      name = GetSubString(name, 6, GetStringLength(name) - 10);
                      SetName(oItem, name);
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
