//:://////////////////////////////////////////////
//::  BODY TAILOR:  copy to model
//::                          onconv bodytailor
//:://////////////////////////////////////////////
/*
   gather the pc info
   and copy to the model

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = OBJECT_SELF;   //--reversed from copy to pc
    object oSelf = GetPCSpeaker();

    int iNewApp;

//--WINGS:
    iNewApp = GetCreatureWingType(oSelf);
    SetCreatureWingType(iNewApp, oPC);

//--TAIL:
    iNewApp = GetCreatureTailType(oSelf);
    SetCreatureTailType(iNewApp, oPC);

//--HEAD:
    iNewApp = GetCreatureBodyPart(CREATURE_PART_HEAD, oSelf);
    SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp, oPC);

//--BODYPARTS:
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, oSelf);
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, iNewApp, oPC);

    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, oSelf);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, iNewApp, oPC);

    iNewApp = GetCreatureBodyPart(CREATURE_PART_NECK, oSelf);
    SetCreatureBodyPart(CREATURE_PART_NECK, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_PELVIS, oSelf);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, iNewApp, oPC);
    iNewApp = GetCreatureBodyPart(CREATURE_PART_TORSO, oSelf);
    SetCreatureBodyPart(CREATURE_PART_TORSO, iNewApp, oPC);

//--EYES
   //--this can't be done from pc to npc. (easily). live with it.

//--PHENOTYPE
   SetPhenoType(GetPhenoType(oSelf), oPC);

}
