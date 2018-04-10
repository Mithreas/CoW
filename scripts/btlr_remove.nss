//::///////////////////////////////////////////////
//:: BODY TAILOR remove
//::  on conv bodytailor
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on Mil Tailor by Jake E. Fitch (Milambus Mandragon)
//:://////////////////////////////////////////////
#include "btlr__inc"



void main()
{
    object oPC = GetPCSpeaker();
    string sToModify = GetLocalString(OBJECT_SELF, "ToModify");
    int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
    string s2DAFile = GetLocalString(OBJECT_SELF, "2DAFile");
    string s2DAend;
    //-- this is set by the tlr_onconv script, which has to go in the creature conv slot
    int iNewApp =0;

    //--now to get the new app ON...
//--WING SECTION vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    if(sToModify == "WINGS")
    {
      //--if it is restricted, skip ahead.
      while(WingIsInvalid(iNewApp))
      {//-- increase
        iNewApp++;

        s2DAend = Get2DACheck(s2DAFile, iNewApp);
        //-- check for blank lines
        if (s2DAend == "SKIP")
        {//-- be careful reading 2da in a fast loop.
          iNewApp++;
          s2DAend = Get2DACheck(s2DAFile, iNewApp);
        }
        //-- check we didnt hit the end
        if (s2DAend == "FAIL" || iNewApp > WINGMAX)
        {//-- if hit the end, loop back to 0
           iNewApp = 0;
        }
      }

      SetCreatureWingType(iNewApp); //--now slap the new wing on!
    }
//--END WINGS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



//--TAIL SECTION vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    if(sToModify == "TAIL")
    {
      //--if it is restricted, skip ahead.
      while(TailIsInvalid(iNewApp))
      {//-- increase
        iNewApp++;

        s2DAend = Get2DACheck(s2DAFile, iNewApp);
        //-- check for blank lines
        if (s2DAend == "SKIP")
        {//-- be careful reading 2da in a fast loop.
          iNewApp++;
          s2DAend = Get2DACheck(s2DAFile, iNewApp);
        }
        //-- check we didnt hit the end
        if (s2DAend == "FAIL" || iNewApp > TAILMAX)
        {//-- if hit the end, loop back to 0
           iNewApp = 0;
        }
      }

      SetCreatureTailType(iNewApp); //--now slap the new tail on!
    }
//--END TAIL ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



//--the rest of the parts dont have 2da files to read from.
//-- be sure you set your max numbers in the include file (btlr__inc)

  int nGender = GetGender(OBJECT_SELF);
  int nRace = GetRacialType(OBJECT_SELF);
  int nMax = 256;

//--HEAD BITS-------------------------------------------------------
  if(sToModify == "HEAD")
  {
     SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp);
  }  //-- end HEAD section


//--MISC BITS------------------------------------------------------

    if(sToModify == "PARTS")
    {
     SetCreatureBodyPart(iToModify, iNewApp);
    }


//--put eyes in here when you figure them out....


//-- and the end where we say what we're doing.

    SendMessageToPC(oPC, "New Appearance: " + IntToString(iNewApp));
}




string GetCachedACBonus(string sFile, int iRow) {
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));

    if (sACBonus == "") {
        sACBonus = Get2DAString(sFile, "ACBONUS", iRow);

        if (sACBonus == "") {
            sACBonus = "SKIP";

            string sCost = Get2DAString(sFile, "COSTMODIFIER", iRow);
            if (sCost == "" ) sACBonus = "FAIL";
        }

        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }

    return sACBonus;
}
