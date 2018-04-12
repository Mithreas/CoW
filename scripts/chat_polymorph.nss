#include "inc_totem"
#include "inc_werewolf"
#include "inc_chatutils"
#include "gs_inc_subrace"
#include "gs_inc_state"
#include "inc_examine"

const string HELP = "<cþôh>-polymorph</c>\nUsed by werewolves and totem shapeshifters to change form.  Toggles you between shifted and non-shifted form.";

//Spell Time Lock duration (in seconds, use float values)
float iLockTimer = 90.0;
//Defining time variables
float f60togo = ( 60 - iLockTimer ) * -1;
float f30togo = ( 30 - iLockTimer ) * -1;
float f18togo = ( 18 - iLockTimer ) * -1;
float f6togo = ( 6 - iLockTimer ) * -1;

void _setTimer(object oSpeaker)
{
    SetLocalInt(oSpeaker, "GSTimerPoly", 1);
    SendMessageToPC(oSpeaker, "-polymorph has a timer of "+FloatToString(iLockTimer, 3, 1)+" seconds. You may not use -polymorph again for this period of time.");
    DelayCommand(f60togo, FloatingTextStringOnCreature("You have 60 seconds left on your Polymorph Lock Timer.", oSpeaker));
    DelayCommand(f30togo, FloatingTextStringOnCreature("You have 30 seconds left on your Polymorph Lock Timer.", oSpeaker));
    DelayCommand(f18togo, FloatingTextStringOnCreature("You have 18 seconds left on your Polymorph Lock Timer.", oSpeaker));
    DelayCommand(f6togo, FloatingTextStringOnCreature("You have 6 seconds left on your Polymorph Lock Timer.", oSpeaker));
    DelayCommand(iLockTimer, FloatingTextStringOnCreature("-polymorph is once again available for use.", oSpeaker));
    DelayCommand(iLockTimer, SetLocalInt(oSpeaker, "GSTimerPoly", 0));
}

void main()
{
  // Command not valid
  object oSpeaker = OBJECT_SELF;
  int nTotem = miTOGetTotemAnimalTailNumber(oSpeaker);
  int nShape = GetLocalInt(gsPCGetCreatureHide(oSpeaker), "MI_SHAPE");
  int nWerewolf = GetLocalInt(oSpeaker, "MI_AWIA");
  if (!nTotem && !nShape && !nWerewolf) return;
  int iTimer = GetLocalInt(oSpeaker, "GSTimerPoly");
  string sParams = chatGetParams(oSpeaker);

  chatVerifyCommand(oSpeaker);

  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-polymorph", HELP);
	return;
  }

  if (iTimer == 0)
  {
    // Check for dead or dying PCs, and exit.
    if (GetIsDead(oSpeaker) || GetCurrentHitPoints(oSpeaker) <= 0) return;

    effect ePoly = GetFirstEffect(oSpeaker);

    while (GetIsEffectValid(ePoly))
    {
      if (GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
      {
        RemoveEffect(oSpeaker, ePoly);
        return;
      }

      ePoly = GetNextEffect(oSpeaker);
    }

    if (nWerewolf)
	{
	  // Werewolves always shift into werewolf form, in preference to their usual totem/shape.
	  int bCurrentlyWerewolf = (GetCreatureTailType(oSpeaker) == 485);

	  if (!bCurrentlyWerewolf)
	  {
	    miAWApplyWolfEffects(oSpeaker);
        _setTimer(oSpeaker);
	  }
      else
      {
        // TODO: I don't think this case can ever be hit due to the above remove effect loop.
        //       There are probably several bufs in this script which need fixes.
	    if (miAWWillSave(oSpeaker))
	    {
          miAWRemoveWolfEffects(oSpeaker);
	    }
	  }
	  return;
	}

    if (nShape)
    {
      int nCurrentShape = GetAppearanceType(oSpeaker);
	  SetCreatureAppearanceType(oSpeaker, nShape - 1);   // Offset by 1 because Dwarf = 0.
	  SetLocalInt(gsPCGetCreatureHide(oSpeaker), "MI_SHAPE", nCurrentShape + 1);
	  return;
    }

	// All that's left is totem shapes.  Check that the character is allowed to use them.
	int bDruid = GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker);
	int bDragon = (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SPECIAL_DRAGON);
	int bVampire = (gsSUGetSubRaceByName(GetSubRace(oSpeaker)) == GS_SU_SPECIAL_VAMPIRE);

	if (!bDruid && !bDragon && !bVampire) return;

    if (bVampire)
    {
        // Shifting costs us 10% blood ...
        gsSTAdjustState(GS_ST_BLOOD, -10.0, oSpeaker);
    }

    _setTimer(oSpeaker);

    // If we're still here...
    ExecuteScript ("nw_s2_wildshape", oSpeaker);
  }
  else
  {
    SendMessageToPC(oSpeaker, "You have used -polymorph too recently. You can't shift yet!");
  }	
}

