#include "x2_inc_itemprop"
#include "inc_item"
const int ENABLE_NOSTACK = TRUE;
const string NO_STACK_TAG = "NS_OLD_TAG";

void ConvertItemToNoStack(object oItem, int PeformVarCheck=FALSE);
void RemoveItemNoStack(object oItem);
string ConvertedStackTag(object oItem);

void _ConvertItemToNoStackNoCheck(object oItem)
{
    if(!ENABLE_NOSTACK) return;

    if(GetLocalString(oItem, NO_STACK_TAG) != "") return; //aready converted to no stack variant

    string sTag = GetTag(oItem);

    SetLocalString(oItem, NO_STACK_TAG, sTag);

    SetTag(oItem, sTag + "_NS" + IntToString(Random(1000)));

}

void ConvertItemToNoStack(object oItem, int PeformVarCheck=FALSE)
{
  int nBaseItemType =  GetBaseItemType(oItem);
  string sResRef = GetResRef(oItem);
  //non-stackable items should be here
  if((nBaseItemType != BASE_ITEM_ARROW && nBaseItemType != BASE_ITEM_BOLT && nBaseItemType != BASE_ITEM_BULLET && nBaseItemType != BASE_ITEM_DART && nBaseItemType != BASE_ITEM_THROWINGAXE) && (nBaseItemType == BASE_ITEM_MISCLARGE || IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)  ||
    nBaseItemType == BASE_ITEM_BLANK_SCROLL || nBaseItemType == BASE_ITEM_BLANK_WAND || nBaseItemType == BASE_ITEM_BLANK_POTION ||
    nBaseItemType == BASE_ITEM_ENCHANTED_POTION || nBaseItemType == BASE_ITEM_ENCHANTED_SCROLL || nBaseItemType == BASE_ITEM_ENCHANTED_WAND ||
    nBaseItemType == BASE_ITEM_KEY || nBaseItemType == BASE_ITEM_MAGICROD || nBaseItemType == BASE_ITEM_MAGICWAND ||  nBaseItemType == BASE_ITEM_BOOK || GetIsItemEquippable(oItem)))
    RemoveItemNoStack(oItem);
  else if(sResRef == "gs_item434" || sResRef == "gs_item432" || sResRef == "gs_item052" || sResRef == "gs_item049" || sResRef == "gs_item433" || sResRef == "gs_item431")
  {
    RemoveItemNoStack(oItem);
    DeleteLocalString(oItem, NO_STACK_TAG);
  }
  else if(GetLocalInt(oItem, "_nostack") || GetLocalInt(oItem, "_NOSTACK") || GetLocalInt(oItem, "_RANDOM") || PeformVarCheck)
    _ConvertItemToNoStackNoCheck(oItem);

}

void RemoveItemNoStack(object oItem)
{
  if(!ENABLE_NOSTACK) return;

  string sOldTag = GetLocalString(oItem, NO_STACK_TAG);
  if(sOldTag != "")
  {
   // DeleteLocalString(oItem, NO_STACK_TAG);
    SetTag(oItem, sOldTag);
  }

}

string ConvertedStackTag(object oItem)
{
    string sOldTag = GetLocalString(oItem, NO_STACK_TAG);
    if(sOldTag != "") return sOldTag;

    return GetTag(oItem);

}
