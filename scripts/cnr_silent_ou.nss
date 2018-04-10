/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_silent_ou
//
//  Desc:  This is the silent OnUsed handler for
//         devices that craft recipes. It does not
//         open a recipe convo dialog, but instead
//         automatically attemps to make a recipe.
//         Recipes are attempted first to last.
//
//         This OnUsed handler is meant to fix a Bioware
//         bug that sometimes prevents placeables from
//         getting OnOpen or OnClose events. This OnUsed
//         handler in coordination with the OnDisturbed
//         ("cnr_device_od") handler work around the bug.
//
//  Author: David Bobeck 07Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

/////////////////////////////////////////////////////////
void TestIfRecipesHaveBeenCollected(object oUser)
{
  int nStackCount = CnrGetStackCount(oUser);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenCollected(oUser));
  }
  else
  {
    if (CnrRecipeDeviceToolsArePresent(oUser, OBJECT_SELF))
    {
      string sDeviceTag = GetTag(OBJECT_SELF);

      SetLocalInt(oUser, "nCnrMenuPage", 0);
      SetLocalString(oUser , "sCnrCurrentMenu", sDeviceTag);

      int nRecipeIndex = CnrRecipeCraftFirstSatifiedRecipe(oUser, OBJECT_SELF);
      if (nRecipeIndex > 0)
      {
        string sRecipeDesc = CnrRecipeGetRecipeDesc(sDeviceTag, nRecipeIndex);
        AssignCommand(oUser, ActionDoCommand(FloatingTextStringOnCreature("Ahaa... " + sRecipeDesc, oUser, FALSE)));
      }
    }
  }
}

/////////////////////////////////////////////////////////
void TestIfRecipesHaveBeenInitialized(object oUser)
{
  int nStackCount = CnrGetStackCount(oUser);
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenInitialized(oUser));
  }
  else
  {
    // Note: A placeable will receive events in the following order...
    // OnOpen, OnUsed, OnDisturbed, OnClose, OnUsed.
    if (GetLocalInt(OBJECT_SELF, "bCnrDisturbed") != TRUE)
    {
      // Skip if the contents have not been altered.
      return;
    }

    SetLocalInt(OBJECT_SELF, "bCnrDisturbed", FALSE);

    // If the Bioware bug is in effect, simulate the closing
    if (GetIsOpen(OBJECT_SELF))
    {
      AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    }

    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    if (oItem == OBJECT_INVALID)
    {
      // Skip if empty.
      return;
    }

    int bToolInInventory = FALSE;
    int bToolIsEquipped = FALSE;

    // this call is asynchronous - it uses stack helpers to avoid TMI
    CnrCollectDeviceRecipes(oUser, OBJECT_SELF, FALSE);

    // wait until collection is done before continuing
    AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenCollected(oUser));
  }
}

/////////////////////////////////////////////////////////
void main()
{
  object oUser = GetLastUsedBy();
  //if (!GetIsPC(oUser))
  //{
  //  return;
  //}

  // this call is asynchronous - it uses stack helpers to avoid TMI
  CnrInitializeDeviceRecipes(oUser, OBJECT_SELF);

  // wait until initialization is done before continuing
  AssignCommand(OBJECT_SELF, TestIfRecipesHaveBeenInitialized(oUser));
}
