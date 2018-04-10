/*
  Name: mi_objopenstore
  Author: Mithreas
  Date: 22 Apr 06
  Description: Generic merchant open store script. Put in the OnUsed slot of a
  placeable object (and make it useable!).

*/
#include "nw_i0_plot"
void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore))
    {
        gplotAppraiseOpenStore(oStore, GetLastUsedBy());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
