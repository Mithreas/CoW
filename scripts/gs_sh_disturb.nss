#include "inc_shop"
#include "inc_text"
#include "inc_generic"
#include "inc_log"
#include "inc_factions"
void main()
{
    if (gsSHGetIsVacant(OBJECT_SELF)) return;

    object oDisturbed = GetLastDisturbed();
    object oItem      = GetInventoryDisturbItem();
    object oCopy      = OBJECT_INVALID;
    string sTag       = GetTag(oItem);
    string sFID       = md_SHLoadFacID();

    if (gsSHGetIsOwner(OBJECT_SELF, oDisturbed))
    {
        gsSHTouchWithNotification(OBJECT_SELF, oDisturbed);
    }

    switch (GetInventoryDisturbType())
    {
    case INVENTORY_DISTURB_TYPE_ADDED:
        if (GetIsDM(oDisturbed) ||
            gsSHGetIsOwner(OBJECT_SELF, oDisturbed) ||
            (fbFAGetFactionNameDatabaseID(sFID) != "" && md_SHLoadFacABL(ABL_B_PLI) && md_GetHasPowerShop(MD_PR_PIS, oDisturbed, sFID)))
        {
            SetLocalInt(OBJECT_SELF, "MD_SH_INV_DIS", 1);
            int nValue = gsSHImportItem(oItem, OBJECT_SELF, oDisturbed);
            SendMessageToPC(oDisturbed, "Sale value of item: " +
                                                           IntToString(nValue));
        }
        else
        {
          if (GetTag(oItem) == "NW_IT_GOLD001")
          {
             Log(SHOP, GetName(oDisturbed) + " tried to place gold in a shop.");
          }
          else
          {
            oCopy = gsCMCopyItem(oItem, oDisturbed);
            CopyVariables(oItem, oCopy, "_");

            if (GetIsObjectValid(oCopy))
            {
                DestroyObject(oItem);
                SendMessageToPC(oDisturbed, GS_T_16777420);
            }
          }
        }
        break;

    case INVENTORY_DISTURB_TYPE_REMOVED:
    case INVENTORY_DISTURB_TYPE_STOLEN:
        //bug workaround: moved to gs_m_acquired because event is not raised
        //if items are dragged from a shop into an inventory subcontainer
        break;
    }
}
