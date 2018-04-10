/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_recycler_ou
//
//  Desc:  This is OnUsed handler for the ingot recycler.
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
void PurgeRecycler()
{
  // destroy all remaining items... like a trash can
  object oItem = GetFirstItemInInventory(OBJECT_SELF);
  while (oItem != OBJECT_INVALID)
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(OBJECT_SELF);
  }
}

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
    string sDeviceTag = GetTag(OBJECT_SELF);

    // Loop thru each recipe until we're able to craft one
    int nResult = 0;
    int nRecipeCount = CnrRecipeGetRecipeCount(sDeviceTag);
    int nRecipeIndex;
    for (nRecipeIndex=1; (nRecipeIndex<=nRecipeCount) && (nResult==0); nRecipeIndex++)
    {
      // If successful, returns a positive value.
      // If failure, returns a negative value.
      // The magnitude of the float indicatates the time required by the animation script.
      nResult = CnrRecipeAttemptToCraft(oUser, OBJECT_SELF, nRecipeIndex, CNR_SILENT_CRAFTING);
    }

    float fAnimationDelay = 0.0;

    if (nResult != 0)
    {
      fAnimationDelay = GetLocalFloat(oUser, "fCnrAnimationDelay");
    }

    if (nResult > 0)
    {
      // success
      string sRecipeDesc = CnrRecipeGetRecipeDesc(sDeviceTag, nRecipeIndex-1);
      DelayCommand(fAnimationDelay, FloatingTextStringOnCreature("Ahaa... " + sRecipeDesc, oUser, FALSE));
    }
    else
    {
      // failure or no attempt
      string sFloat;
      int nFloat = d6(1);
      if (nFloat == 1)      {sFloat = CNR_TEXT_RECYCLER_MUMBLE_1;}
      else if (nFloat == 2) {sFloat = CNR_TEXT_RECYCLER_MUMBLE_2;}
      else if (nFloat == 3) {sFloat = CNR_TEXT_RECYCLER_MUMBLE_3;}
      else if (nFloat == 4) {sFloat = CNR_TEXT_RECYCLER_MUMBLE_4;}
      else if (nFloat == 5) {sFloat = CNR_TEXT_RECYCLER_MUMBLE_5;}
      else if (nFloat == 6) {sFloat = CNR_TEXT_RECYCLER_MUMBLE_6;}
      DelayCommand(fAnimationDelay, FloatingTextStringOnCreature(sFloat, oUser, FALSE));
    }

    DelayCommand(fAnimationDelay+0.2, PurgeRecycler());
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
