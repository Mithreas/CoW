#include "inc_shop"
#include "inc_log"
#include "inc_factions"
void _save(object oPC)
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;
    string sFID       = md_SHLoadFacID();
    if (GetLocalInt(OBJECT_SELF, "MD_SH_INV_DIS") ||
        GetIsDM(oPC) ||
        gsSHGetIsOwner(OBJECT_SELF, oPC) ||
        (fbFAGetFactionNameDatabaseID(sFID) != "" &&
        ((md_SHLoadFacABL(ABL_B_PLI) && md_GetHasPowerShop(MD_PR_PIS, oPC, sFID)) ||
        (md_SHLoadFacABL(ABL_B_TKI) && md_GetHasPowerShop(MD_PR_RIS, oPC, sFID)))))
    {
        DeleteLocalInt(OBJECT_SELF, "MD_SH_INV_DIS");
        // Edit by Mithreas: report number of items saved and log.
        // NB: Call to gsSHSave used to be delayed by 0.5s.
        // --[
        struct gsCOResults stResults =  gsSHSave(OBJECT_SELF);
        SendMessageToPC(oPC, "<c þ >" + IntToString(stResults.nSaved) + " items saved. " +
        "Shops have a limit of " + IntToString(SHOP_LIMIT) + " items.");
        if (stResults.nOverflowed) {
            SendMessageToPC(oPC, "<cþ  >Warning: " + IntToString(stResults.nOverflowed) +
                                 " items were NOT saved.");
        }
        if (stResults.nGold)
        {
          GiveGoldToCreature(oPC, stResults.nGold);
          SendMessageToPC(oPC, "<cþN >Note: you can not store gold in these chests.");
        }

        Log(SHOP, GetName(oPC) + " accessed shop " + GetLocalString(OBJECT_SELF, "GS_CLASS") + "_" + IntToString(GetLocalInt(OBJECT_SELF, "GS_INSTANCE")) +
              " and left " + IntToString(stResults.nSaved) + " stored.");
    }
}

void main()
{
  // Delay by 0.5s to prevent an exploit.
  DelayCommand(0.5, _save(GetLastClosedBy()));
}
