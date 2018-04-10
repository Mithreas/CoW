#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_text"

void main()
{
    object oPC        = OBJECT_INVALID;
    object oDisturbed = GetLastDisturbed();
    object oItem      = GetInventoryDisturbItem();
    string sResRef    = GetResRef(oItem);
    string sTag       = GetTag(oItem);
    string sCDKey     = "";

    switch (GetInventoryDisturbType())
    {
    case INVENTORY_DISTURB_TYPE_ADDED:
        if (sResRef != "gs_item018" || sTag == "GS_BA_VOID")
        {
            if (GetIsObjectValid(oDisturbed)) ActionGiveItem(oItem, oDisturbed);
            else                              gsCMDestroyObject(oItem);
            break;
        }

        sCDKey = GetSubString(sTag, 6, GetStringLength(sTag) - 6);
        oPC    = gsPCGetPlayerByCDKey(sCDKey);

        if (GetIsObjectValid(oPC))
        {
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777422,
                    GetPCPlayerName(oPC),
                    sCDKey,
                    GetPCIPAddress(oPC),
                    GetName(oPC)));
            ApplyEffectAtLocation(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(VFX_FNF_PWKILL),
                GetLocation(oPC));
            BootPC(oPC);
        }

        WriteTimestampedLogEntry(GetName(oDisturbed) + " [" +
   GetPCPlayerName(oDisturbed) + "] banned " + GetName(oItem) + " - " + sCDKey);

        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE),
            OBJECT_SELF);
        break;

    case INVENTORY_DISTURB_TYPE_REMOVED:
    case INVENTORY_DISTURB_TYPE_STOLEN:
    }
}
