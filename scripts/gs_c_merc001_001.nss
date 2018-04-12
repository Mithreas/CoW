#include "inc_shop"
#include "inc_divination"
void main()
{
    miDVGivePoints(GetPCSpeaker(), ELEMENT_WATER, 8.0);

    object oStore = GetNearestObjectByTag("GS_STORE_" + GetTag(OBJECT_SELF));
    if (GetIsObjectValid(oStore)) gsSHOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
