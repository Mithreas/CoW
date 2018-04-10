/*
  Name: mi_openstore_na
  Author: Mithreas
  Date: 03 Dec 05
  Description: Generic merchant open store script. Put in the Actions Taken When
               slot of a conversation, and set a string variable on the speaking
               NPC with name "store" and value of the tag of the store (case
               sensitive).
               The _na version opens the store with no Appraise checks.

*/
#include "nw_i0_plot"
void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore))
    {
        OpenStore(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
