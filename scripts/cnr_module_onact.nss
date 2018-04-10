/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_module_onact
//
//  Desc:  This script must be run by the module's
//         OnActivateItem event handler.
//
//  Author: David Bobeck 08Jan03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  object oItem = GetItemActivated();
  object oActivator = GetItemActivator();

  if (CnrRecipeBookOnActivateItem(oItem, oActivator))
  {
    return;
  }

  if (CnrJournalOnActivateItem(oItem, oActivator))
  {
    return;
  }
}


