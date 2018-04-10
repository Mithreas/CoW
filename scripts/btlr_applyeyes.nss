//:://////////////////////////////////////////////
//::  BODY TAILOR:  apply eyes
//::                          onconv bodytailor
//:://////////////////////////////////////////////
/*
  this will slap the eyes from the npc to the pc.
  not vice versa.
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nEye = GetLocalInt(OBJECT_SELF, "EYES");

    if(ALLOWEYES
      || GetLevelByClass(CLASS_TYPE_MONK) > 0)
    {  ApplyEyes(nEye, oPC);  }
    //--i dont think you can take eyes off a monk.

}
