// include file for container object functions (such as keychains and headbags)

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "inc_log"
// version 1.0:
// objectnames and qty are stored as string variables on the container item, with the resref + || + tagname of the object stored as variable name.
// The variable value consists 4 positions for qty, then objectname, so for instance 0002akey
// We need the tagname as well as the resref because for instance quarter keys are identified based on tagname

// version 2.0:
// object descriptions and qty are stored as string variables on the container item, with the resref + || + tagname + || + objectname of the object stored as variable name.
// We need the tagname as well as the resref because for instance quarter keys are identified based on tagname, also added objectname for the sake of keeping
// uniquely named items seperate and unique. And added the description to the variable value instead, to be able to keep those as well.

// there is also a zdlg_gvd_contain for the Container object handling by the PC

// you need to create non-stackable items as containers and add a gvd_container_item int variable with value 1 on it for identication in scripts,
// and they should have a cast spell, unique power unlimited and a cast spell, unique power unlimited self only.
// the first one being for the using on other items suchs as keys or leaderheads, so they can get added to the container item and the last power to get access to the
// zdlg where PCs can retrieve the objects from the container again. Example of this: Custome, Misc, Other, Keychain

// Don't forget to handle the activation of the item in gs_m_activate, again look at the example for the gvd_keychain item.
// gs_m_activate is the only place you need to add some scripting, the inc_holders and zdlg_gvd_contain should be able to handle the rest

// you can add a gvd_container_max int variable to set the maximum weight (in 0.1 lbs, so 1000 = 100 lbs) that can be stored in the container,
// if not it defaults to 100 lbs, this doesn't take into effect the possible weight reduction properties on a container. So always calculate the normal weight
// of the container item itself + the number of items you want to go in as maximum. For instance, leaderhead weight 10.5 each, the bag itself 0.5.
// a Headbag with a maximum of 10 pieces, would get 10*10.5 + 0.5 = 105.5 (times 10 to get it in 0.1 lbs equals 1055).


//////////////////////////
// function definitions //
//////////////////////////


// adds oObject item to oContainer item, returns 1 for succes, 0 for failure (container full), 9 for failure (item does not exist in palette)
int gvd_Container_AddObject(object oContainer, object oObject);

// retrieves an object with resref sResRef and tag sTag from oContainer and puts it in oPCs inventory
void gvd_Container_GetObject(object oContainer, string sResRef, string sTag, string sObjectName, object oPC);

// checks if PC has an item with sTag in possession, does the regular GetItemPossessedBy() check, but also checks the container items
// doesn't return the object itself, but 1 or 0 found/not found
int gvd_IsItemPossessedBy(object oPC, string sTag);

// set item weight using IP_CONST_WEIGHTINCREASE properties as a work-around for SetItemWeight (nwnx) which doesn't save across resets, and doesn't automatically
// update the characters total inventory weight. This always rounds down in steps of 5 LBS and only can be used if the new weight > original base item weight
// iWeight is in 0,1 lbs, so iWeight = 10, means 1 lbs. To be compatible with the GetWeight function
void gvd_SetItemWeight(object oItem, int iWeight);

//////////////////////////////
// function implementations //
//////////////////////////////


// adds oObject to oContainer
int gvd_Container_AddObject(object oContainer, object oObject) {

  object oTempChest;
  object oTest;
  int nDestroy = FALSE;
  //jewelry boxes need special treatment.. as not all items are in pallet, this needs to be checked first
  if(GetStringLeft(GetTag(oContainer), 11) == "md_jewelbox")
  {
    oTempChest = GetObjectByTag("mo_jeweltreas");
    string sTag = GetTag(oObject);
    string sName = GetName(oObject);
    oTest = GetLocalObject(oTempChest, sName+sTag);
    if(!GetIsObjectValid(oTest))
    {
        oTest = GetItemPossessedBy(oTempChest, sTag);
        if(GetName(oTest) != sName)
        {
            Trace("!!JEWELRY TREASURE MISMATCH!!", GetName(oTest) + "Tag: "+ sTag);
            oTest = GetFirstItemInInventory(oTempChest);
            while(GetIsObjectValid(oTest))
            {
                if(GetTag(oTest) == sTag)
                {
                    if(GetName(oTest) != sName)
                        Trace("!!JEWELRY TREASURE MISMATCH!!", GetName(oTest) + "Tag: "+ sTag);
                    else
                        break;
                }

                oTest = GetNextItemInInventory(oTempChest);
            }
        }
    }
    //save the item to easily grab later
    if(GetIsObjectValid(oTest))
    {
        SetLocalObject(oTempChest, sName+sTag, oTest);
    }
  }

  if(!GetIsObjectValid(oTest))
  {
    // first check if the item is in the palette, otherwise it cannot be recreated later
    oTempChest = GetObjectByTag("gvd_tempchest");
    oTest = CreateItemOnObject(GetResRef(oObject), oTempChest);
    nDestroy = TRUE;
  }
  else
    nDestroy = FALSE;

  if (oTest != OBJECT_INVALID) {

    if(nDestroy)
    {
        // item exists, continue
        AssignCommand(oTest, SetIsDestroyable(TRUE));
        DestroyObject(oTest);
    }
    // check if the container has variables on them already, if not, it's been acquired from a merchant with infinite flag. In this case initialise the item with default values
    if (GetLocalInt(oContainer, "gvd_container_item") == 0) {
      SetLocalInt(oContainer, "gvd_container_item", 1);
      SetLocalInt(oContainer, "_NOSTACK", 1);
      SetLocalInt(oContainer, "gvd_container_max", 1055);
    }

    // check if adding the object, won't surpass the weight limit of the container
    int iWeight = GetLocalInt(oContainer, "gvd_container_weight");

    if (iWeight == 0) {
      // start with weight of the container itself
      iWeight = GetWeight(oContainer);
    }

    // add the weight of the new item
    iWeight = iWeight + GetWeight(oObject);

    int iMax = GetLocalInt(oContainer, "gvd_container_max");

    // max weight defaults to 100 lbs (=1055)
    if (iMax == 0) {
      iMax = 1055;
    }

    if (iWeight <= iMax) {
      // weight okay, go ahead

      string sObject = GetResRef(oObject) + "||" + GetTag(oObject) + "||" + GetName(oObject);
      string sObjectDesc = GetDescription(oObject);
      int iObjectQty = 0;

      // retrieve the number of objects with this resref, tag and name in the container
      string sObjectValue = GetLocalString(oContainer, sObject);

      if (sObjectValue != "") {
        iObjectQty = StringToInt(GetStringLeft(sObjectValue, 4));
      }

      // add stacksize more object(s)
      SetLocalString(oContainer, sObject, GetStringRight(IntToString(10000 + iObjectQty + GetItemStackSize(oObject)), 4) + sObjectDesc);

      // adjust weight of the container, also store it on local variable so we can use it for recalculation later on
      // note, SetItemWeight (nwnx) has a bug, that it doesn't recalcule total inventory weight until the inventory is disturbed and doesn't save accross
      // resets, so we use weight property instead using the gvd_SetItemWeight function instead
      gvd_SetItemWeight(oContainer, iWeight);

      // destroy original object
      AssignCommand(oObject, SetIsDestroyable(TRUE));
      DestroyObject(oObject);

      // success
      return 1;

    } else {
      // weight maximum reached
      return 0;

    }

  } else {
    // item not in palette, do not allow it to be added
    return 9;
  }

}

// retrieves an object with resref sResRef + tag sTag + name sObjectName from oContainer and puts it in oPCs inventory
void gvd_Container_GetObject(object oContainer, string sResRef, string sTag, string sObjectName, object oPC) {

  // variable name
  string sObject;
  if (sObjectName == "") {
    // old version of the bag (1.0), didn't store objectnames in the variable name
    sObject = sResRef + "||" + sTag;
  } else {
    sObject = sResRef + "||" + sTag + "||" + sObjectName;
  }
  int iObjectQty = 0;
  string sObjectDesc = "";

  // retrieve the number of objects with this resref + tag + name in the container
  string sObjectValue = GetLocalString(oContainer, sObject);

  if (sObjectValue != "") {
    iObjectQty = StringToInt(GetStringLeft(sObjectValue, 4));
    if (sObjectName == "") {
      // old version (1.0) had the objectname as part of the variable value, retrieve it here
      sObjectName = GetStringRight(sObjectValue, GetStringLength(sObjectValue)-4);

      // delete the old version variable now, it will be replaced by the new one
      DeleteLocalString(oContainer, sObject);
      sObject = sResRef + "||" + sTag + "||" + sObjectName;

    } else {
      // new version (2.0) has the object description as part of the variable value
      sObjectDesc = GetStringRight(sObjectValue, GetStringLength(sObjectValue)-4);
    }
  }

  if (iObjectQty == 0) {
    // no object with this resref/tag/name combination in the container (shouldn't be possible)
    SendMessageToPC(oPC, "You can't find the object you are looking for in the container.");

  } else {
    // remove 1 object
    iObjectQty = iObjectQty - 1;

    if (iObjectQty == 0) {
      // delete variable
      DeleteLocalString(oContainer, sObject);
    } else {
      // update variable
      SetLocalString(oContainer, sObject, GetStringRight(IntToString(10000 + iObjectQty), 4) + sObjectDesc);
    }
    object oObject;
    //jewelrybox needs special treatment, items are in a chest
    if(GetStringLeft(GetTag(oContainer), 11) == "md_jewelbox")
    {
        object oTempChest = GetObjectByTag("mo_jeweltreas");
        oObject = GetLocalObject(oTempChest, sObjectName+sTag);
        if(!GetIsObjectValid(oObject))
        {
            oObject = GetFirstItemInInventory(oTempChest);
            while(GetIsObjectValid(oObject))
            {
                if(GetTag(oObject) == sTag && GetName(oObject) == sObjectName)
                {
                    SetLocalObject(oTempChest, sObjectName+sTag, oObject);
                    break;
                }

                oObject = GetNextItemInInventory(oTempChest);
            }
        }
        if(GetIsObjectValid(oObject))
            oObject = CopyItem(oObject, oPC, TRUE);
    }

    // create the object item, add something to the tag temporarily so that it doesn't stack automatically when retrieved from the bag
    if(!GetIsObjectValid(oObject))
        oObject = CreateItemOnObject(sResRef, oPC, 1, sTag + "_nostack");
    // now set the tag right back to the correct value, so it can be stacked afterwards if the player so wishes
    SetTag(oObject, sTag);

    // Added by Batra: Re-identify received for the player (vanilla trap kits in mind)
    SetIdentified(oObject, TRUE);

    // in case it's a stackable object, oObject might end up being a stack, so calculate the weight of just 1 of the item
    int iObjectWeight = GetWeight(oObject) / GetItemStackSize(oObject);

    // adjust weight of the container, also store it on local variable for calculation purposes
    int iWeight = GetLocalInt(oContainer, "gvd_container_weight") - iObjectWeight;
    gvd_SetItemWeight(oContainer, iWeight);

    // in case players renamed the original object (or leader head names), go with that name instead of the palette name of the item
    if (sObjectName != "") {
      SetName(oObject, sObjectName);
    }
    // in case players made a unique description for the original object, restore that as well
    if (sObjectDesc != "") {
      SetDescription(oObject, sObjectDesc);
    }

  }

}

int gvd_IsItemPossessedBy(object oPC, string sTag) {

  object oItem = GetItemPossessedBy(oPC, sTag);

  if (oItem != OBJECT_INVALID) {
    // item found the regular way, done here
    return 1;

  } else {
    // check any container items on the PC
    struct NWNX_Object_LocalVariable lvKey;
    int iVars;
    int iVar;

    // loop through inventory
    object oInvItem = GetFirstItemInInventory(oPC);
    while (oInvItem != OBJECT_INVALID) {

      // has the gvd_container_item variable on it, meaning it is a container and has items?
      if (GetLocalInt(oInvItem, "gvd_container_item") > 0) {
        // yup, loop through all variables to see if there is one with sTag between them

        iVars = NWNX_Object_GetLocalVariableCount(oInvItem);
        iVar = 0;
        lvKey = NWNX_Object_GetLocalVariable(oInvItem, iVar);

        while (iVar < iVars) {

          // check if the variable name container || + sTag we're looking for, since the tag is stored to the right of the || seperator in the variable name
          if (FindSubString(lvKey.key, "||" + sTag + "||") >= 0) {
            // item found
            return 1;
          }

          // next variable
          iVar = iVar + 1;
          lvKey = NWNX_Object_GetLocalVariable(oInvItem, iVar);

        }

      }

      // next item
      oInvItem = GetNextItemInInventory(oPC);
    }

  }

  // if we come here, item was not found
  return 0;

}

void _gvd_SetItemWeight(object oItem, int iWeight) {

  // get the base weight of the container
  int iBaseWeight = GetWeight(oItem);

  // do we need to add weight?
  if (iWeight > iBaseWeight) {
    // increase

    while ((iWeight - iBaseWeight) >= 1000) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oItem);
      iBaseWeight = iBaseWeight + 1000;
    }
    while ((iWeight - iBaseWeight) >= 500) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS), oItem);
      iBaseWeight = iBaseWeight + 500;
    }
    while ((iWeight - iBaseWeight) >= 300) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_30_LBS), oItem);
      iBaseWeight = iBaseWeight + 300;
    }
    while ((iWeight - iBaseWeight) >= 150) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_15_LBS), oItem);
      iBaseWeight = iBaseWeight + 150;
    }
    while ((iWeight - iBaseWeight) >= 100) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_10_LBS), oItem);
      iBaseWeight = iBaseWeight + 100;
    }
    // use 25 here instead of 50, to make sure a weight of 2.5 lbs, gets round up to 5.0 lbs.
    while ((iWeight - iBaseWeight) >= 25) {
      AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_5_LBS), oItem);
      iBaseWeight = iBaseWeight + 50;
    }

  }

}

void gvd_SetItemWeight(object oItem, int iWeight) {

  // first strip off all item weight modifications
  itemproperty _ipProperty = GetFirstItemProperty(oItem);
  while (GetIsItemPropertyValid(_ipProperty)) {
    if (GetItemPropertyType(_ipProperty) == ITEM_PROPERTY_WEIGHT_INCREASE) {
      RemoveItemProperty(oItem, _ipProperty);
    } else {
      // strip of all item weight reduction as well, for the mundane versions (needed bugfix, because some were sold from merchants with infinite flag, losing all the variables
      if (GetItemPropertyType(_ipProperty) == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) {
        if ((GetTag(oItem) == "gvd_headbag") || (GetTag(oItem) == "gvd_huntbag") || (GetTag(oItem) == "gvd_minebag")) {
          RemoveItemProperty(oItem, _ipProperty);
        }
      }
    }

    _ipProperty = GetNextItemProperty(oItem);
  }

  // keep track of real unrounded weight with a variable
  SetLocalInt(oItem, "gvd_container_weight", iWeight);

  // delay the script here, because the removal of item properties takes place after script ends
  DelayCommand(0.1f, _gvd_SetItemWeight(oItem, iWeight));

}

