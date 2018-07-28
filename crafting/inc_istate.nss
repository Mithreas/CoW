/* ITEM STATE Library by Gigaschatten, cut down for crafting purposes */

//void main() {}

#include "cnr_config_inc"
#include "inc_craft"

//global
object gsISItem = OBJECT_INVALID;
int gsISEnabled = FALSE;

//initialize state of oItem
void gsISInitializeItemState(object oItem);
//return maximum charge of oItem
int gsISGetMaximumItemState(object oItem);
//return state of oItem
int gsISGetItemState(object oItem);
//decrease state of oItem by 1
void gsISDecreaseItemState(object oItem);
//increase state of oItem by 1
void gsISIncreaseItemState(object oItem);
//set state of oItem to nState
void gsISSetItemState(object oItem, int nState);
//return TRUE if oItem is a state item
int gsISGetIsStateItem(object oItem);
//return craft skill used to repair oItem
int gsISGetItemCraftSkill(object oItem);
//randomly corrupt equipment of caller
void gsISCorruptEquipment();
//repair oItem by oPC using nValue craft points
void gsISRepairItem(object oItem, object oPC, int nValue = 1);

void gsISInitializeItemState(object oItem)
{
    if (gsISGetIsStateItem(oItem) &&
        GetItemCharges(oItem) == 0)
    {
        SetItemCharges(oItem, gsISGetMaximumItemState(oItem));
    }
}
//----------------------------------------------------------------
int gsISGetMaximumItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return FALSE;
    
    return 20;
}
//----------------------------------------------------------------
int gsISGetItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return FALSE;

    gsISInitializeItemState(oItem);
    return GetItemCharges(oItem);
}
//----------------------------------------------------------------
void gsISDecreaseItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return;
    gsISSetItemState(oItem, gsISGetItemState(oItem) - 1);
}
//----------------------------------------------------------------
void gsISIncreaseItemState(object oItem)
{
    if (! gsISGetIsStateItem(oItem)) return;
    gsISSetItemState(oItem, gsISGetItemState(oItem) + 1);
}
//----------------------------------------------------------------
void gsISSetItemState(object oItem, int nState)
{
    if (! gsISGetIsStateItem(oItem)) return;

    object oPossessor = GetItemPossessor(oItem);
    string sName      = GetName(oItem);

    if (nState <= 0)
    {
        FloatingTextStringOnCreature(
            "Item has been destroyed: " + sName,
            oPossessor,
            FALSE);
        DestroyObject(oItem);
    }

    string sString    = "";
    int nStateMaximum = gsISGetMaximumItemState(oItem);
    int nStateCurrent = gsISGetItemState(oItem);

    if (nState > nStateMaximum)  nState  = nStateMaximum;
    if (nState == nStateCurrent) return;
    if (nState > nStateCurrent)  sString = "<cªÕþ>";
    else                         sString = "<cþ((>";

    FloatingTextStringOnCreature(
        sString + sName + " (" +
        IntToString(nState) + "/" +
        IntToString(nStateMaximum) + ")",
        oPossessor,
        FALSE);
    SetItemCharges(oItem, nState);
}
//----------------------------------------------------------------
int gsISGetIsStateItem(object oItem)
{

    if (oItem != gsISItem)
    {
        gsISItem    = oItem;
        gsISEnabled = gsISGetItemCraftSkill(oItem) != FALSE;
    }

    return gsISEnabled;
}
//----------------------------------------------------------------
int gsISGetItemCraftSkill(object oItem)
{
    return gsCRGetCraftSkillByItemType(oItem, TRUE);	
}
//----------------------------------------------------------------
void gsISCorruptEquipment()
{
  object oItem = OBJECT_INVALID;
  int nNth;

    if (Random(100) < 97) return;

    nNth = 0;
    oItem        = GetItemInSlot(INVENTORY_SLOT_ARMS);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BELT);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_BOOTS);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CHEST);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_CLOAK);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_HEAD);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);
    oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (gsISGetIsStateItem(oItem) && !GetPlotFlag(oItem) && !GetItemCursedFlag(oItem)) SetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(nNth++), oItem);

    if (nNth)
    {
        oItem = GetLocalObject(OBJECT_SELF, "GS_IS_" + IntToString(Random(nNth)));
        gsISDecreaseItemState(oItem);
    }

}
//----------------------------------------------------------------
void gsISRepairItem(object oItem, object oPC, int nValue = 1)
{
    int nMaximumItemState = gsISGetMaximumItemState(oItem);
    int nNth              = 0;

    if (GetStringLeft(GetStringUpperCase(GetTag(oItem)), 6) == "CA_GEN")
    {
      FloatingTextStringOnCreature("This item cannot be repaired.", oPC, FALSE);
      return;
    }

    for (; nNth < nValue; nNth++)
    {
            gsISIncreaseItemState(oItem);

            //complete repair
            if (gsISGetItemState(oItem) >= nMaximumItemState)
            {

                FloatingTextStringOnCreature("You have fully repaired the item.", oPC, FALSE);
                return;
            }
    }
	
    FloatingTextStringOnCreature("You repair the item a little.", oPC, FALSE);
}
