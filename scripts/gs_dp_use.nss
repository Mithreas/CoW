#include "inc_iprop"

void main()
{
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED)
    {
        object oUser = GetLastDisturbed();

        if ((GetLevelByClass(CLASS_TYPE_PALADIN, oUser) ||
             GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oUser)) &&
            GetAlignmentLawChaos(oUser) == ALIGNMENT_LAWFUL &&
            GetAlignmentGoodEvil(oUser) == ALIGNMENT_GOOD)
        {
            object oItem = GetInventoryDisturbItem();

            if (GetBaseItemType(oItem) == BASE_ITEM_GREATSWORD)
            {
                itemproperty ipProperty = GetFirstItemProperty(oItem);
                int nFlag               = FALSE;

                while (GetIsItemPropertyValid(ipProperty))
                {
                    if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT) return;

                    ipProperty = GetNextItemProperty(oItem);
                }

                if (! nFlag)
                {
                    float fDuration = HoursToSeconds(2);

                    ApplyEffectAtLocation(
                        DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_STRIKE_HOLY),
                        GetLocation(OBJECT_SELF));
                    ApplyEffectAtLocation(
                        DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_10),
                        GetLocation(OBJECT_SELF));
                    gsIPAddItemProperty(
                        oItem,
                        ItemPropertyHolyAvenger(),
                        fDuration);
                    gsIPAddItemProperty(
                        oItem,
                        ItemPropertyLight(
                            IP_CONST_LIGHTBRIGHTNESS_BRIGHT,
                            IP_CONST_LIGHTCOLOR_YELLOW),
                        fDuration);
                    gsIPAddItemProperty(
                        oItem,
                        ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN),
                        fDuration);
                    gsIPAddItemProperty(
                        oItem,
                        ItemPropertyLimitUseBySAlign(IP_CONST_ALIGNMENT_LG),
                        fDuration);
                }
            }
        }
    }
}
