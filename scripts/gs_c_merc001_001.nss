#include "gs_inc_common"
#include "inc_divination"
void main()
{
    miDVGivePoints(GetPCSpeaker(), ELEMENT_WATER, 8.0);

    object oStore = GetNearestObjectByTag("GS_STORE_" + GetTag(OBJECT_SELF));
    if (GetIsObjectValid(oStore)) gsCMOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}