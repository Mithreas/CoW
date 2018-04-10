//::///////////////////////////////////////////////
//:: BODY TAILOR set item
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
    SetListening(OBJECT_SELF, FALSE);

    object oPC = GetPCSpeaker();
    string sToModify = GetLocalString(OBJECT_SELF, "ToModify");
    int iToModify = GetLocalInt(OBJECT_SELF, "ToModify");
    string s2DAFile = GetLocalString(OBJECT_SELF, "2DAFile");
    string s2DAend;
    //-- this is set by the tlr_onconv script, which has to go in the creature conv slot
    int iNewApp = StringToInt(GetLocalString(OBJECT_SELF, "tlr_Spoken"));
    if (iNewApp < 0) iNewApp = 0;

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

     //--do the loop around check
     s2DAend = Get2DACheck(s2DAFile, iNewApp);
    while (s2DAend == "SKIP" || s2DAend == "FAIL")
    {
        if (s2DAend == "FAIL" || iNewApp > WINGMAX)
        {
            iNewApp = 0;
        } else {
            iNewApp++;
        }

        s2DAend = Get2DACheck(s2DAFile, iNewApp);
    }  //-- end loop around check

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

     //--do the loop around check
     s2DAend = Get2DACheck(s2DAFile, iNewApp);
    while (s2DAend == "SKIP" || s2DAend == "FAIL")
    {
        if (s2DAend == "FAIL" || iNewApp > TAILMAX)
        {
            iNewApp = 0;
        } else {
            iNewApp++;
        }

        s2DAend = Get2DACheck(s2DAFile, iNewApp);
    }  //-- end loop around check

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
  {       //-- check we didnt hit the end(s)
    if(nGender==GENDER_FEMALE)
    {
       switch(nRace)
       {
         case RACIAL_TYPE_DWARF: nMax=DFHEADMAX; break;
         case RACIAL_TYPE_ELF: nMax = EFHEADMAX; break;
         case RACIAL_TYPE_GNOME: nMax = GFHEADMAX; break;
         case RACIAL_TYPE_HALFELF:
         case RACIAL_TYPE_HUMAN: nMax = HFHEADMAX; break;
         case RACIAL_TYPE_HALFLING: nMax = AFHEADMAX; break;
         case RACIAL_TYPE_HALFORC: nMax = OFHEADMAX; break;
       }
     }
     else //--males and everything else
     {
       switch(nRace)
       {
         case RACIAL_TYPE_DWARF: nMax=DMHEADMAX; break;
         case RACIAL_TYPE_ELF: nMax = EMHEADMAX; break;
         case RACIAL_TYPE_GNOME: nMax = GMHEADMAX; break;
         case RACIAL_TYPE_HALFELF:
         case RACIAL_TYPE_HUMAN: nMax = HMHEADMAX; break;
         case RACIAL_TYPE_HALFLING: nMax = AMHEADMAX; break;
         case RACIAL_TYPE_HALFORC: nMax = OMHEADMAX; break;
       }
    }

    if(iNewApp > nMax)
    {//-- loop to 0
      iNewApp = 0;
    }

     SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp);
  }  //-- end HEAD section


//--MISC BITS------------------------------------------------------

    if(sToModify == "PARTS")
    {
     //--check the ceiling
     if(iNewApp > CUSTOMPARTS)
     { //-- more than our 3 parts
       if(iNewApp >= 255)
       { //-- if it is 256, loop to 0
         iNewApp = 0;
       }
       else
       { //-- or else jump from max custom to 256
        iNewApp = 255;
       }
     }  //-- end loop check

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
