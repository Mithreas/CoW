/* SHOP library by Gigaschatten */

#include "gs_inc_quarter"
#include "gs_inc_common"
#include "gs_inc_container"
#include "gs_inc_listener"
#include "inc_factions"

//void main() {}
const int SHOP_LIMIT = 20; // If you reduce this, some items will be lost!
const string SHOP = "SHOP"; // for tracing

//Local var to save the items custom price
const string CUSTOM_PRICE = "MD_CUSTOM_PRICE";

//return TRUE if oPC is owner of oShop
int gsSHGetIsOwner(object oShop, object oPC);
//return owner id of oShop
string gsSHGetOwnerID(object oShop);
//make oPC own oShop
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0);
//return owner name of oShop
string gsSHGetOwnerName(object oShop);
//update timestamp of oShop
void gsSHTouch(object oShop);
//update timestamp of oShop and informs oPC
void gsSHTouchWithNotification(object oShop, object oPC);
//return TRUE if oShop is vacant
int gsSHGetIsVacant(object oShop);
//return TRUE if oShop is available
int gsSHGetIsAvailable(object oShop);
//load inventory of oShop
void gsSHLoad(object oShop);
//save inventory of oShop
struct gsCOResults gsSHSave(object oShop);
//abandon oShop
void gsSHAbandon(object oShop);
//import oItem to oShop. Returns the sale value of oItem.
int gsSHImportItem(object oItem, object oShop, object oPC = OBJECT_INVALID);
//export oItem to oTarget
void gsSHExportItem(object oItem, object oTarget);
//set sale price of oShop to nValue
void gsSHSetSalePrice(object oShop, int nValue);
//return sale price of oShop
int gsSHGetSalePrice(object oShop);

int gsSHGetIsOwner(object oShop, object oPC)
{
  return gsQUGetIsOwner(oShop, oPC);
}
//----------------------------------------------------------------
string gsSHGetOwnerID(object oShop)
{
  return gsQUGetOwnerID(oShop);
}
//----------------------------------------------------------------
void gsSHSetOwner(object oShop, object oPC, int nTimeout = 0)
{
  gsQUSetOwner(oShop, oPC, nTimeout);
  gsQUReset(oShop);
}
//----------------------------------------------------------------
string gsSHGetOwnerName(object oShop)
{
  return gsQUGetOwnerName(oShop);
}
//----------------------------------------------------------------
void gsSHTouch(object oShop)
{
  gsQUTouch(oShop);
}
//----------------------------------------------------------------
void gsSHTouchWithNotification(object oShop, object oPC)
{
  gsSHTouch(oShop);
  FloatingTextStringOnCreature("You have refreshed your shop.", oPC, FALSE);
}
//----------------------------------------------------------------
int gsSHGetIsVacant(object oShop)
{
  return gsQUGetIsVacant(oShop);
}
//----------------------------------------------------------------
int gsSHGetIsAvailable(object oShop)
{
  return gsQUGetIsAvailable(oShop);
}
//----------------------------------------------------------------
void gsSHLoad(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    gsCOLoad(sID + "_" + IntToString(nInstance), oShop, SHOP_LIMIT, TRUE);

    object oItem  = GetFirstItemInInventory(oShop);

    while (GetIsObjectValid(oItem))
    {
        SetLocalObject(oItem, "GS_SH_CONTAINER", oShop);
        oItem = GetNextItemInInventory(oShop);
    }
}
//----------------------------------------------------------------
struct gsCOResults gsSHSave(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    return gsCOSave(sID + "_" + IntToString(nInstance), oShop, SHOP_LIMIT, TRUE);
}
//----------------------------------------------------------------
void gsSHAbandon(object oShop)
{
  gsQUAbandon(oShop);
}
//----------------------------------------------------------------
int gsSHImportItem(object oItem, object oShop, object oPC = OBJECT_INVALID)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) != "GS_SH_")
    {
        object oCopy = CopyObject(oItem,
                                  GetLocation(oShop),
                                  oShop,
                                  "GS_SH_" + sTag);

        if (GetIsObjectValid(oCopy))
        {
            SetLocalInt(oCopy, SLOT_VAR, GetLocalInt(oItem, SLOT_VAR));
            int nValue;
            string sFaction =  md_SHLoadFacID(oShop);
            int nOwner = gsSHGetIsOwner(oShop, oPC);
            int nPowCheck = GetIsObjectValid(oPC) && (nOwner || (md_SHLoadFacABL(ABL_B_SCP | ABL_B_SCI, oShop) &&
                            fbFAGetFactionNameDatabaseID(sFaction) != "" && md_GetHasPowerShop(MD_PR2_SCP | MD_PR2_SCI, oPC, sFaction, "2")));
            if(nPowCheck)
               nValue = StringToInt(chatGetLastMessage(oPC));

            if(nValue < 1)
            {
              //If they have the power to set custom prices, but not the power to take items
              //give them a second chance to set the items price.
              if(nPowCheck && !nOwner && (!md_SHLoadFacABL(ABL_B_TKI, oShop) || !md_GetHasPowerShop(MD_PR_RIS, oPC, sFaction)))
              {
                SetLocalObject(oPC, "MD_SAVED_ITEMP", oCopy);
                SetLocalString(oPC, "zzdlgCurrentDialog", "zz_co_shsetprice");
                AssignCommand(oShop, ActionStartConversation(oPC, "zzdlg_conv", TRUE, FALSE));
              }
              int nSalePrice  = gsSHGetSalePrice(oShop);
              nValue          = gsCMGetItemValue(oItem) * nSalePrice / 100;
              if (nValue < 1) nValue = 1;
            }
            else
              SetLocalInt(oCopy, CUSTOM_PRICE, nValue);

            SetLocalObject(oCopy, "GS_SH_CONTAINER", oShop);
            // Added by Mith - workaround to stop stacking.
            SetStolenFlag(oCopy, TRUE);
            DestroyObject(oItem);
            return nValue;
        }
    }

    return 0;
}
//----------------------------------------------------------------
void gsSHExportItem(object oItem, object oTarget)
{
    string sTag = GetTag(oItem);

    if (GetStringLeft(sTag, 6) == "GS_SH_")
    {
        object oShop = GetLocalObject(oItem, "GS_SH_CONTAINER");
        string sID   = GetLocalString(oShop, "GS_CLASS") + "_" +
                       IntToString(GetLocalInt(oShop, "GS_INSTANCE"));
        spCORemove(sID, oShop, oItem);

        object oCopy = CopyObject(oItem,
                                  GetLocation(oTarget),
                                  oTarget,
                                  GetStringRight(sTag, GetStringLength(sTag) - 6));

        if (GetIsObjectValid(oCopy))
        {
            // Don't give the copy any vars. We want it to stack normally.
            // SetLocalInt(oCopy, SLOT_VAR, GetLocalInt(oItem, SLOT_VAR));
            // Added by Mith - workaround to stop stacking.
            DeleteLocalInt(oCopy, CUSTOM_PRICE);
            SetStolenFlag(oCopy, FALSE);
            DestroyObject(oItem);
        }
    }
}
//----------------------------------------------------------------
void gsSHSetSalePrice(object oShop, int nValue)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");

    if (nValue < 1)         nValue =  100;
    else if (nValue > 1000) nValue = 1000;

    SetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance), nValue);
}
//----------------------------------------------------------------
int gsSHGetSalePrice(object oShop)
{
    string sID    = GetLocalString(oShop, "GS_CLASS");
    int nInstance = GetLocalInt(oShop, "GS_INSTANCE");
    int nValue    = GetCampaignInt("GS_SH_" + sID, "SALE_PRICE_" + IntToString(nInstance));

    return nValue <= 0 ? 100 : nValue;
}
