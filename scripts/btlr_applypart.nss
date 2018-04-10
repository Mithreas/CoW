//::///////////////////////////////////////////////
//:: BODY TAILOR: apply part
//:: onconv bodytailor
//:://////////////////////////////////////////////
/*
   whatever part you are working on,
   you can apply just that part to yourself.

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the mil tailor by Jake E. Fitch (Milambus Mandragon)
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = GetPCSpeaker();

    string sToModify = GetLocalString(OBJECT_SELF, "ToModify");
    //-- WINGS, TAIL, HEAD, EYES, PARTS...
    int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
    //-- bodypart #...
    int iNewApp;


//--PUT ON WINGS----------------------------------------------------
   if(sToModify == "WINGS")
   {
     iNewApp = GetCreatureWingType();

     //--check rdd allowances
     if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 0
     && !ALLOWRDDREMOVAL)
     { //-- its an rdd and its not allowed to remove/change wings
       SpeakString("Red Dragon Disciples cannot change wings.");
       return;
     }
     if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) == 0
     && !ALLOWRDDWING)
     { //-- not an rdd and cant get rdd wings
       if(iNewApp == CREATURE_WING_TYPE_DRAGON)
       { //-- not allowed
         SpeakString("Your class is not allowed to have red dragon wings.");
         return;
       }
     }  //-- end RDD checks  if you get past here, slap them on.

     SetCreatureWingType(iNewApp, oPC);
     return;
   }



//--PUT ON TAIL----------------------------------------------------
   if(sToModify == "TAIL")
   {
     iNewApp = GetCreatureTailType();

     SetCreatureTailType(iNewApp, oPC);
     return;
   }


//--PUT ON HEAD----------------------------------------------------
   if(sToModify == "HEAD")
   {
     iNewApp = GetCreatureBodyPart(CREATURE_PART_HEAD);

     SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp, oPC);
     return;
   }


//--PUT ON BODYPART------------------------------------------------
   if(sToModify == "PARTS")
   {
    iNewApp = GetCreatureBodyPart(iToModify);

    //--pm arm checks
    if( (iToModify == CREATURE_PART_LEFT_BICEP
       || iToModify == CREATURE_PART_LEFT_FOREARM
       || iToModify == CREATURE_PART_LEFT_HAND) //--any left arm part
       && iNewApp == CREATURE_MODEL_TYPE_UNDEAD //-- and changing to bone
       && (!ALLOWBONEARM
           && GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) <=0))   //-- and not a pm and bone arms not allowed on non pms
    { //-- left arm parts & trying to put on undead on a non pm. just say NO!
      SpeakString("Your class is not allowed to have bone arms.");
      return;
    }
    if (!ALLOWBONEREMOVAL
        && GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0
        && (iToModify == CREATURE_PART_LEFT_BICEP
        || iToModify == CREATURE_PART_LEFT_FOREARM
        || iToModify == CREATURE_PART_LEFT_HAND))
    {//-- its a pm and pm bone removal not allowed and its the left arm
      SpeakString("Pale Masters are not allowed to change the undead grafts.");
      return;
    }  //-- end pm arm checks, whew!  if you get past here, change the part.

    SetCreatureBodyPart(iToModify, iNewApp, oPC);
    return;
   }


//--OH THE EYES, THE EYES!-----------------------------------------

    if(sToModify == "EYES")
    {
      int iEyes = GetLocalInt(OBJECT_SELF, "EYES");
      ApplyEyes(iEyes, oPC);
      return;
    }


}
