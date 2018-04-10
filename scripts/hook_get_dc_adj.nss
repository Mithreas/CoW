// hook_get_dc_adj
#include "cnr_hook_helper"
void main()
{
  // inputs
  int nTradeskillType = CnrHookHelperGetTradeskillType(OBJECT_SELF);
  string sKeyToRecipe = CnrHookHelperGetKeyToRecipeInProgress(OBJECT_SELF);

  // outputs
  //CnrHookHelperSetAdjustmentToRecipeDC(OBJECT_SELF, -20);
}
