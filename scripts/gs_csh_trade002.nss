#include "gs_inc_common"
#include "gs_inc_finance"
#include "gs_inc_shop"
#include "gs_inc_text"

// Edit by Mithreas - work around the fact that we now log when people add stuff
// to their shop.
void SaveShop(object oShop)
{
  gsSHSave(oShop);
}

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
    object oSelf    = OBJECT_SELF;
    int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
    int nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
    if (nValue < 1) nValue = 1;

    if (GetGold(oSpeaker) < nValue)
    {
        SendMessageToPC(oSpeaker, GS_T_16777238);
    }
    else
    {
        string sID  = gsSHGetOwnerID(OBJECT_SELF);
        string sNationName = GetLocalString(GetArea(OBJECT_SELF), VAR_NATION);

        if (sNationName == "")
        {
          // No tax payable.
        }
        else
        {
          string sNation = miCZGetBestNationMatch(sNationName);
          float fTax = miCZGetTaxRate(sNation);
          int nTax = FloatToInt(fTax * IntToFloat(nValue));
          nValue -= nTax;
          AssignCommand(oSpeaker, gsFITransfer("N" + sNation, nTax));
        }

        AssignCommand(oSpeaker, gsFITransfer(sID, nValue));
        gsSHExportItem(oItem, oSpeaker);
        ActionDoCommand(DelayCommand(0.5, SaveShop(OBJECT_SELF)));
    }

    AssignCommand(oSpeaker, ActionInteractObject(oSelf));
}
