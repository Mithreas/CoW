#include "inc_common"
#include "inc_craft"
#include "inc_iprop"
#include "inc_language"
#include "x3_inc_string"

const int GS_LIMIT_COST = 10000;

int StartingConditional()
{
    object oItem = GetFirstItemInInventory();

    if (GetIsObjectValid(oItem))
    {
        int nPropertyID = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_ID");
        int nSubTypeID  = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE_ID");
        int nCostID     = GetLocalInt(OBJECT_SELF, "GS_COST_ID");
        int nParamID    = GetLocalInt(OBJECT_SELF, "GS_PARAM_ID");

        itemproperty ipProperty = gsIPGetItemProperty(nPropertyID, nSubTypeID, nCostID, nParamID);

        if (GetIsItemPropertyValid(ipProperty))
        {
            object oSpeaker      = GetPCSpeaker();
            int nCost            = gsIPGetCost(oItem, ipProperty);
            int nBaseCost        = nCost;
            int nChance          = 5;
            int nPropertyStrRef  = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_STRREF");
            string sPropertyName = GetStringByStrRef(nPropertyStrRef);

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
            }

            SetCustomToken(818, GetName(oItem));
            SetCustomToken(819, sPropertyName);
            SetCustomToken(820, IntToString(nCost));

            string chanceOnToken = IntToString(100 - nChance);

            if (GetLocalInt(oItem, "RUNIC"))
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
                                                     //2 has been used for all races
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

                if (extraChance)
                {
                  chanceOnToken += " " + StringToRGBString("[+" + IntToString(extraChance) + "]", "339");
                }
              }
            }

            SetCustomToken(821, chanceOnToken);
            SetCustomToken(822, IntToString(nImpossible ? nCost / 10 : 0));

            return TRUE;
        }
    }

    return FALSE;
}
