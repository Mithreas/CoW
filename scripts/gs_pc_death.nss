#include "inc_common"
#include "inc_pc"
#include "inc_text"

const string GS_TEMPLATE_CORPSE = "gs_placeable016";
const string GS_TEMPLATE_SKULL  = "gs_item050";

void main()
{
    string sTarget = GetLocalString(OBJECT_SELF, "GS_TARGET");
    object oTarget = gsPCGetPlayerByID(sTarget);
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                  GS_TEMPLATE_CORPSE,
                                  GetLocation(OBJECT_SELF));
    string sName   = GetName(OBJECT_SELF);

    if (GetIsObjectValid(oTarget))
    {
        FloatingTextStringOnCreature(GS_T_16777484, oTarget, FALSE);
        DeleteLocalObject(oTarget, "GS_CORPSE");
    }

    if (GetIsObjectValid(oCorpse))
    {
        object oSkull = CreateItemOnObject(GS_TEMPLATE_SKULL,
                                           oCorpse,
                                           1,
                                           sTarget);
        if (GetIsObjectValid(oSkull)) SetName(oSkull, sName);

        SetName(oCorpse, sName);
        gsCMCreateGold(GetLocalInt(OBJECT_SELF, "GS_GOLD"), oCorpse);
    }
}
