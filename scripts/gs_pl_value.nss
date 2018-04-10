#include "gs_inc_common"
#include "gs_inc_text"

void main()
{
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        object oDisturbedBy = GetLastDisturbed();
        object oItem        = GetInventoryDisturbItem();

        SetIdentified(oItem, TRUE);
        SendMessageToPC(
            oDisturbedBy,
            gsCMReplaceString(
                GS_T_16777476,
                GetName(oItem),
                IntToString(gsCMGetItemValue(oItem))));
    }
}
