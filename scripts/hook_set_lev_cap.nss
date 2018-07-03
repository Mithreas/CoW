/////////////////////////////////////////////////////////////////////
//
// hook_set_lev_cap
//
// Use this script to define the trade level caps for the calling PC
//
/////////////////////////////////////////////////////////////////////
#include "cnr_recipe_utils"
void main()
{
  // Set the trade level caps for this PC
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_COOKING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_WEAPON_CRAFTING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_ARMOR_CRAFTING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_CHEMISTRY, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_INVESTING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_IMBUING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_WOOD_CRAFTING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_ENCHANTING, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_JEWELRY, 20);
  CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_TAILORING, 20);

  int nPrimaryClassType = GetClassByPosition(1, OBJECT_SELF);
  int nRacialType = GetRacialType(OBJECT_SELF);
  
  // Humans can handle explosives, but are less effective mages.
  if (nRacialType != RACIAL_TYPE_HUMAN)
  {
    CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_CHEMISTRY, 5);
  }
  else
  {
    CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_INVESTING, 10);
    CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_IMBUING, 10);
    CnrSetTradeskillLevelCapByType(OBJECT_SELF, CNR_TRADESKILL_ENCHANTING, 10);
  }

}
