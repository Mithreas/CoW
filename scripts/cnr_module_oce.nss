/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_module_oce
//
//  Desc:  This script must be run by the module's
//         OnClientEnter event handler.
//
//  Author: David Bobeck 22Feb03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  object oPC = GetEnteringObject();
  if (!GetIsPC(oPC)) return;

  ///////////////////////////////////////////////////////////
  // Make sure all players carry the new Tradeskill Journal.
  ///////////////////////////////////////////////////////////

  // First, check if they have either journal, new or old.
  object oJournal = CnrGetItemByResRef("cnrtradejournal", oPC);
  if (oJournal == OBJECT_INVALID)
  {
    //////////////////////////
    // First time in module....
    //////////////////////////
    
    // Strip player of all default game items here.
    
    //object oItem = GetFirstItemInInventory(oPC);
    //while (oItem != OBJECT_INVALID)
    //{
    //  DestroyObject(oItem);
    //  oItem = GetNextItemInInventory(oPC);
    //}

    // create a journal for the player
    oJournal = CreateItemOnObject("cnrtradejournal", oPC);
  }
  else
  {
    // The player has a journal. Now determine what type it is, new or old
    
    if (GetTag(oJournal) != "cnrTradeJournal")
    {
      // Player has the old type journal. We need to convert the XP stored in its tag
      // to the new format, then we can destroy the old journal and create a new journal.

      CnrConvertOldJournalXPToNewFormat(oJournal, oPC);
      DestroyObject(oJournal);
      CreateItemOnObject("cnrtradejournal", oPC);
    }
    //else
    //{
      // Player has the new type journal. nothing needs to be done!
    //}
    
  }


  // Allow the builder to set the trade level caps for this PC.
  // execute hook script
  ExecuteScript("hook_set_lev_cap", oPC);

  int bInitRecipesOnModuleLoad = CnrGetPersistentInt(OBJECT_SELF, "CnrBoolInitRecipesOnModuleLoad");
  bInitRecipesOnModuleLoad = bInitRecipesOnModuleLoad || CNR_BOOL_INIT_RECIPES_ON_MODULE_LOAD;
  if (bInitRecipesOnModuleLoad == TRUE)
  {
    int nRecipeCount = GetLocalInt(GetModule(), "CnrRecipeCount");
    SendMessageToPC(oPC, "Total CNR recipe count = " + IntToString(nRecipeCount));
  }
}


