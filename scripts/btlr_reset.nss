//:://////////////////////////////////////////////
//::  BODY TAILOR:  reset
//::                          onconv bodytailor
//:://////////////////////////////////////////////
/*
  set all to 0

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = OBJECT_SELF;   //--reversed from copy to pc

    int iNewApp = 0;

//--WINGS:
    SetCreatureWingType(iNewApp, oPC);

//--TAIL:
    SetCreatureTailType(iNewApp, oPC);

//--HEAD:
      iNewApp = 1;
    SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp, oPC);

//--BODYPARTS:
    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, iNewApp, oPC);

    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, iNewApp, oPC);

    SetCreatureBodyPart(CREATURE_PART_NECK, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, iNewApp, oPC);
    SetCreatureBodyPart(CREATURE_PART_TORSO, iNewApp, oPC);

//--EYES
    ApplyEyes(0, oPC);

//--PHENO
    SetPhenoType(PHENOTYPE_NORMAL);

}
