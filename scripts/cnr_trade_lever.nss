#include "cnr_recipe_utils"
void main()
{
  int nTrade = 0;
  string sTradeName = GetName(OBJECT_SELF);
  sTradeName = GetStringRight(sTradeName, GetStringLength(sTradeName)-7);
  if (sTradeName == "Cooking")  { nTrade = CNR_TRADESKILL_COOKING; }
  else if (sTradeName == "Weapon Crafting")  { nTrade = CNR_TRADESKILL_WEAPON_CRAFTING; }
  else if (sTradeName == "Armor Crafting")  { nTrade = CNR_TRADESKILL_ARMOR_CRAFTING; }
  else if (sTradeName == "Explosives")  { nTrade = CNR_TRADESKILL_EXPLOSIVES; }
  else if (sTradeName == "Investing")  { nTrade = CNR_TRADESKILL_INVESTING; }
  else if (sTradeName == "Imbuing")  { nTrade = CNR_TRADESKILL_IMBUING; }
  else if (sTradeName == "Carpentry")  { nTrade = CNR_TRADESKILL_WOOD_CRAFTING; }
  else if (sTradeName == "Enchanting")  { nTrade = CNR_TRADESKILL_ENCHANTING; }
  else if (sTradeName == "Jewelry")  { nTrade = CNR_TRADESKILL_JEWELRY; }
  else if (sTradeName == "Tailoring")  { nTrade = CNR_TRADESKILL_TAILORING; }
  
  if (nTrade > 0)
  {
    object oUser = GetLastUsedBy();
    int nXP = CnrGetTradeskillXPByType(oUser, nTrade);
    int nLevel = CnrDetermineTradeskillLevel(nXP);
    int nNextLevelXP = 0;
    if (nLevel != 20)
    {
      nLevel = nLevel + 1;
      nNextLevelXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(nLevel));
    }
    else
    {
      nLevel = 1;
    }
    CnrSetTradeskillXPByType(oUser, nTrade, nNextLevelXP);
    FloatingTextStringOnCreature("Your " + sTradeName + " skill is now level " + IntToString(nLevel), oUser, FALSE);
  }
}
