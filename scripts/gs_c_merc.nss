#include "gs_inc_common"
#include "inc_divination"

void main()
{
    miDVGivePoints(GetPCSpeaker(), ELEMENT_WATER, 8.0);

    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore)) gsCMOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
