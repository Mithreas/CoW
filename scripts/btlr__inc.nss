//::///////////////////////////////////////////////
//:: BODY TAILOR: include file
//:: btlr_* scripts
//:://////////////////////////////////////////////
/*
   allows restrictions for wings/tails.
   sets MAX for wings, tails, heads.
   and misc switches for control.

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the mil tailor by Jake E. Fitch (Milambus Mandragon)
//:://////////////////////////////////////////////

//-- CONSTANTS for the soft MAX of each type;
//-- the wing/tail 2das can't go above 255 anyway.
//-- change these to reflect the max number of whatever
//-- that you have in your module. (or that the user may have in their override)
//-- ie: you may not have 200 female human heads, though it is possible.
int WINGMAX     =   255;
int TAILMAX     =   255;

int HFHEADMAX   =   200;    //-- human female
int HMHEADMAX   =   200;    //-- human male
int AFHEADMAX   =   100;    //-- halfling female
int AMHEADMAX   =   50;     //-- halfling male
int EFHEADMAX   =   150;    //-- elf female
int EMHEADMAX   =   50;     //-- elf male
int GFHEADMAX   =   50;     //-- gnome female
int GMHEADMAX   =   50;     //-- gnome male
int DFHEADMAX   =   150;    //-- dwarf female
int DMHEADMAX   =   50;     //-- dwarf male
int OFHEADMAX   =   50;     //-- halforc female
int OMHEADMAX   =   50;     //-- halforc male

int CUSTOMPARTS =    2;     //-- set this to how many pc parts you have
                            //-- before it should switch up to part 255. default is 0, 1, 2.
int MAXPHENO    =    2;     //-- set to your highest phenotype you are using. 2 if you dont have pheno haks


//--CONSTANTS for switches;  set to 0 to turn off,  1 to turn on
int SKIP2DALINES    =   0;  //--my wings/tails skip 2da lines, so finding a blank
                //--is not an end-of-file indication. use 1 if your 2das skip,
                //--and then use the restrictions list and MAX constants
                //--to define the wing/tail limits.
                //--use 1 for CEP2/Universal Wings/Tails

int ALLOWBONEARM    =   1;  //-- anybody can get a palemaster arm
int ALLOWBONEREMOVAL=   1;  //-- palemasters can remove bone arms
int ALLOWRDDWING    =   1;  //-- anybody can get red dragon wings
int ALLOWRDDREMOVAL =   1;  //-- red dragon disciples can remove wings
int ALLOWEYES       =   1;  //-- let anybody get glowing eyes
//--REMOVED //-- allow monks to remove glowing eyes -- THEY CANT anyway.

//--notes on EYE numbers; i dont know what the real numbers are,
//-- so i set these as tracking numbers.
//-- 0=none, 1=red, 2=green, 3=yellow

//--RESTRICTION LISTS: WINGS/TAILS
/* instructions:
   you can set individual wings/tails or ranges of them
   to be un-selectable in the body shop tailor.
   for example, if you dont want people to have angel or demon wings,
   set a case # for those, like this:
   case CREATURE_WING_TYPE_ANGEL:
   case CREATURE_WING_TYPE_DEMON:
     return TRUE;

   you can also use straight numbers, which match the 2da line numbers.
   ie: demon = 1 and angel = 2. custom wings will use plain numbers.
   the scripts should skip blank 2da lines, but to make this process
   run more smoothly, you should indicate any large gaps in your 2da files,
   using the invalid range sets, thus:
     if(n >= 43 && n <= 93)  return TRUE;

   this will skip lines 43-93.

   if you touch nothing, there won't be any restrictions.
   you can still use the soft max constants to tell the scripts
   when to loop back to the beginning.

*/


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int WingIsInvalid(int n)
{
    //-- restriction list switch
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;
//--CEP2/Universal Wings/Tails 2 Blank Section (uncomment next line to use)
   // if(n >= 58 && n <= 109)  return TRUE;
//--CEP2/Universal Wings/Tails 2 FX Section (uncomment next line to disable selection of all fx)
//--(or set the soft MAX to either 58 or 109)
  // if(n >= 110 && n <= 256)  return TRUE;
    return FALSE;
}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int TailIsInvalid(int n)
{
    //-- restriction list switch
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;
//--CEP2/Universal Wings/Tails 2 Blank Section (uncomment next line to use)
   // if(n >= 59 && n <= 109)  return TRUE;
//--CEP2/Universal Wings/Tails 2 FX Section (uncomment next line to disable selection of all fx)
//--(or set the soft MAX to either 59 or 109)
  // if(n >= 110 && n <= 256)  return TRUE;
    return FALSE;
}



//--OUTSIDE FUNCTIONS-----------------------------------------------
//-- do not modify stuff below

// Remove an effect of the given type
void RemoveEffectOfType(object oTarget, int nEffectType)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if ( GetEffectType(eEff) == nEffectType) {
            RemoveEffect(oTarget, eEff);
        }
        eEff = GetNextEffect(oTarget);
    }
}



//--sticks nFX eyes on oCreature
//--with routine by the guy who figured out how to figure out eye numbers,
//-- but didnt put his/her name on the scripts
void ApplyEyes(int nFX, object oCreature)
{
  int nGender = GetGender(oCreature);
  int nRace = GetAppearanceType(oCreature);
  //--FX EYE # LIST: 0=none, 1=red, 2=green, 3=yellow.  there.

  switch(nRace)
  {//-- this will make the races translate to proper advances on the fx constants.  trust me.
    case 0: nRace = 2; break;
    case 1: nRace = 4; break;
    case 2: nRace = 6; break;
    case 3: nRace = 8; break;
    case 4: nRace = 0; break;
    case 5: nRace = 10; break;
    default: nRace = 0; break;
  }

  switch (nFX)
  {
  case 1:
    {
    RemoveEffectOfType(oCreature, EFFECT_TYPE_VISUALEFFECT);
    effect eEyes = SupernaturalEffect(EffectVisualEffect( VFX_EYES_RED_FLAME_HUMAN_MALE+nGender+nRace));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEyes, oCreature);
    break;
    }
  case 2:
    {
    RemoveEffectOfType(oCreature, EFFECT_TYPE_VISUALEFFECT);
    effect eEyes = SupernaturalEffect(EffectVisualEffect( VFX_EYES_GREEN_HUMAN_MALE+nGender+nRace));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEyes, oCreature);
    break;
    }
  case 3:
    {
    RemoveEffectOfType(oCreature, EFFECT_TYPE_VISUALEFFECT);

    effect eEyes1 = SupernaturalEffect(EffectVisualEffect( VFX_EYES_GREEN_HUMAN_MALE+nGender+nRace));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEyes1, oCreature);

    effect eEyes2 = SupernaturalEffect(EffectVisualEffect( VFX_EYES_RED_FLAME_HUMAN_MALE+nGender+nRace));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEyes2, oCreature);
    break;
    }
  case 0:
    {
    RemoveEffectOfType(oCreature, EFFECT_TYPE_VISUALEFFECT);
    break;
    }
  }
}




string Get2DACheck(string sFile, int iRow)
{
   //-- this reads a string from the module...!?
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));
    //-- if the module string is blank...
    if (sACBonus == "")
    {  //--read the 2da of the file, for the MODEL column, on our current row.
        sACBonus = Get2DAString(sFile, "MODEL", iRow);

    if (sACBonus == "" && iRow != 0)//-- dont skip blank row 0, none
        {//-- if that is blank, we SKIP that line.
            sACBonus = "SKIP";
           //-- unless the LABEL row is also blank...
            string sCost = Get2DAString(sFile, "LABEL", iRow);
            if (sCost == "" && !SKIP2DALINES) sACBonus = "FAIL";
            //--AND we are not skipping blank 2da lines.
            //-- in which case its a FAIL.
        }
       //--store the 2da row/column value on the module.
        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }
   //--this returns a number-string, or SKIP or FAIL.
    return sACBonus;
}



int GetCachedLimit(string sFile)
{
    if(!SKIP2DALINES)
    {//-- we're not skipping blank lines
      if(sFile == "wingmodel.2da")
      {  return WINGMAX;  }
      else //--its tails
      {  return TAILMAX;  }
    }
    //-- if we ARE skipping blank lines, we can find the max
    //-- line number of the 2da using this

    int iLimit = GetLocalInt(GetModule(), sFile + "Limit");

    if (iLimit == 0)
    {
        int iCount = 0;

        while (Get2DAString(sFile, "MODEL", iCount + 1) != "")
        {
            iCount++;
        }

        iLimit = iCount;
    }

    if (iLimit >= 256) iLimit = 255; //--error checking, gah.
    SetLocalInt(GetModule(), sFile + "Limit", iLimit);
    return iLimit;
}


/*
void main(){}
*/
