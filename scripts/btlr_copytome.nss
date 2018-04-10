//:://////////////////////////////////////////////
//::  BODY TAILOR:  copy to me
//::                          onconv bodytailor
//:://////////////////////////////////////////////
/*
   gather the model info
   and copy to the pc

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    int iNewApp;

//--WINGS:
    iNewApp = GetCreatureWingType();
    if(iNewApp == CREATURE_WING_TYPE_DRAGON)
    {
      if(ALLOWRDDWING
       || GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 0)
      {  SetCreatureWingType(iNewApp, oPC);  }
    }
    else //-- not red dragon wing
    {
      if(ALLOWRDDREMOVAL
        || GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) <= 0)
      {  SetCreatureWingType(iNewApp, oPC);  }
    }

//--TAIL:
    iNewApp = GetCreatureTailType();
    SetCreatureTailType(iNewApp, oPC);

//--HEAD:
    iNewApp = GetCreatureBodyPart(CREATURE_PART_HEAD);
    SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp, oPC);

//--BODYPARTS:
  //--bone arm parts with checks
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP);
    if (iNewApp == CREATURE_MODEL_TYPE_UNDEAD)
    {
      if (ALLOWBONEARM
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iNewApp, oPC);  }
    }
    else
    { //-- not a bone arm.
      if (ALLOWBONEREMOVAL
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) <= 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iNewApp, oPC);  }
    }

    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM);
    if (iNewApp == CREATURE_MODEL_TYPE_UNDEAD)
    {
      if (ALLOWBONEARM
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iNewApp, oPC);  }
    }
    else
    { //-- not a bone arm.
      if (ALLOWBONEREMOVAL
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) <= 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iNewApp, oPC);  }
    }

    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND);
    if (iNewApp == CREATURE_MODEL_TYPE_UNDEAD)
    {
      if (ALLOWBONEARM
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, iNewApp, oPC);  }
    }
    else
    { //-- not a bone arm.
      if (ALLOWBONEREMOVAL
        || GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) <= 0)
      {    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, iNewApp, oPC);  }
    }

  //-- regular bodyparts
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH);
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, iNewApp, oPC);

    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, iNewApp, oPC);

    iNewApp = GetCreatureBodyPart(CREATURE_PART_NECK);
    SetCreatureBodyPart(CREATURE_PART_NECK, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_PELVIS);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_TORSO);
    SetCreatureBodyPart(CREATURE_PART_TORSO, iNewApp, oPC);

//--EYES
   ExecuteScript("btlr_applyeyes", OBJECT_SELF);


//--PHENOTYPE
   SetPhenoType(GetPhenoType(oSelf), oPC);

}
