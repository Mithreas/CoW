//::///////////////////////////////////////////////
//:: FileName  md_inc_spell
//::///////////////////////////////////////////////
/*  Include file for functions for setting an
    AOE spell as cast by a warlock and determining
    the proper SpellDC and SpellResistance
    functions to use.
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: October 24, 2010
//:://////////////////////////////////////////////

//Included for Warlock Staff Tag and Warlock Spell
//Resistance
#include "mi_inc_warlock"
//Included for GetSpellDCModifiers
#include "mi_inc_spells"
#include "nw_i0_spells"

//A variable that stores if a warlock casted an AoE
const string md_WLAoE = "md_CastByWL";

//Loops through AoES and determines if it was created
//by a warlock; and then sets the AoE as warlock
//created.
void mdSetAOECreatedByWarlock(object oItem, location lTarget, object oCaster);

//Chooses between miWAResistSpell and
//Bioware's MyResistSpell, depending if
//a Warlock created the spell or not
//Only to be used in AoEs
int mdWLBWResistSpell(object oCaster, object oTarget);

//Chooses between miWAGetSpellDC and
//Bioware's GetSpellSaveDC, depending if
//a Warlock created the spell or not
//Only to be used in AoEs
int mdWLBWSpellDC(object oCaster, int nSpellSchool);

void mdSetAOECreatedByWarlock(object oItem, location lTarget, object oCaster)
{
  //Only do this if we know the spell was created by a warlock staff
  if (GetIsObjectValid(oItem) && GetTag(oItem) == TAG_WARLOCK_STAFF)
  {
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget);
    int x = 1;
    //Loops through the AoEs...
    while(GetIsObjectValid(oAOE))
    {

      //.. And break after we find one without
      //the variable set AND created by the caster.
      if(GetAreaOfEffectCreator(oAOE) == oCaster && !GetLocalInt(oAOE, md_WLAoE))
      {
        SetLocalInt(oAOE, md_WLAoE, 1);
        break;
      }

      x++;
      oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, x);
    }
  }
}

int mdWLBWResistSpell(object oCaster, object oTarget)
{
    //if was casted by a warlock
  if(GetLocalInt(OBJECT_SELF, md_WLAoE))
    return miWAResistSpell(oCaster, oTarget);
  else //not a warlock
    return MyResistSpell(oCaster, oTarget);
}

int mdWLBWSpellDC(object oCaster, int nSpellSchool)
{

    //if was casted by a warlock
  if(GetLocalInt(OBJECT_SELF, md_WLAoE))
    return miWAGetSpellDC(oCaster) + GetSpellDCModifiers(oCaster, nSpellSchool);
  else //not a warlock
    return GetSpellSaveDC();
}
