// fl_check_legal
//
// Script to check that PCs are legally built according to the latest
// class and feat restrictions etc.
//
// Not currently used, but keeping this around in case we need to do a similar rework
#include "inc_pc"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_iprop"
void _RefundGoldLvl(object oPC)
{
  int nPCLevel = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") - 1;
  SetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL", nPCLevel);

  float fPCLevel = IntToFloat(nPCLevel);
  // Older characters won't have an ECL.  If an ECL exists it's
  // baselined at 10.0 - see zdlg_subrace.
  float fCurrentECL = GetLocalFloat(gsPCGetCreatureHide(oPC), "ECL");
  if (fCurrentECL > 0.0) fCurrentECL -= 10.0f;

  fPCLevel += fCurrentECL;
  if (fPCLevel < 1.0f) fPCLevel = 1.0f;

  fPCLevel -= IntToFloat(GetHitDice(oPC));
  fPCLevel += 5.0f;  
  
  int nGoldCost = FloatToInt(fPCLevel * 500.0f);

  GiveGoldToCreature(oPC, nGoldCost);
}
void _RemoveFeat(object oPC, int nFeat)
{
  NWNX_Creature_RemoveFeat(oPC, nFeat);
  _RefundGoldLvl(oPC);
  SendMessageToPC(oPC, "Feat " + GetStringByStrRef(StringToInt(Get2DAString("feat", "name", nFeat))) + " has been refunded.");
}

void _Relevel(object oPC)
{
  int nXP = GetXP(oPC);
  SetXP(oPC, 1);

  DelayCommand(0.5, SetXP(oPC, nXP));
}

void main()
{
  object oPC = OBJECT_SELF;
  object oHide = gsPCGetCreatureHide(oPC);
  
  int nCL = GetLocalInt(oHide, "AR_BONUS_CASTER_LEVELS");
  
  if (nCL)
  {
    // Refund and remove.
	DeleteLocalInt(oHide, "AR_BONUS_CASTER_LEVELS");
	while (nCL > 0)
	{
	  _RefundGoldLvl(oPC);
	  nCL -= 2;
	}
	
	DelayCommand (15.0f, FloatingTextStringOnCreature("Your purchased Caster Level feats have been refunded as they no longer apply.  You will need to bind or pact a spirit to improve your Caster Level", oPC)); 
  }
}


/* Old code kept for future reference.
void main()
{
  object oPC = OBJECT_SELF;

  // Banned or restricted feats.
  if (GetKnowsFeat(FEAT_EPIC_DAMAGE_REDUCTION_9 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_DAMAGE_REDUCTION_9);
  if (GetKnowsFeat(FEAT_EPIC_TOUGHNESS_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_TOUGHNESS_3);
  if (GetKnowsFeat(FEAT_EPIC_TOUGHNESS_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_TOUGHNESS_4);
  if (!GetLevelByClass(CLASS_TYPE_PALEMASTER ,oPC) && GetKnowsFeat(FEAT_ANIMATE_DEAD ,oPC)) _RemoveFeat(oPC, FEAT_ANIMATE_DEAD);
  if (GetKnowsFeat(FEAT_EPIC_AUTOMATIC_QUICKEN_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_AUTOMATIC_QUICKEN_3);
  if (GetKnowsFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3);
  if (GetKnowsFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_3);
  //refund barb rage 7
  if (GetKnowsFeat(331 ,oPC)) _RemoveFeat(oPC, 331);
  if (GetKnowsFeat(FEAT_SUMMON_FAMILIAR ,oPC) && !GetLevelByClass(CLASS_TYPE_WIZARD ,oPC) && !GetLevelByClass(CLASS_TYPE_SORCERER ,oPC)) _RemoveFeat(oPC, FEAT_SUMMON_FAMILIAR);

  //4 Jun 2013
  if (GetKnowsFeat(FEAT_EPIC_DAMAGE_REDUCTION_6 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_DAMAGE_REDUCTION_6);
  if (GetKnowsFeat(FEAT_EPIC_DAMAGE_REDUCTION_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_DAMAGE_REDUCTION_3);
  if (GetKnowsFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_2);
  if (GetKnowsFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_AUTOMATIC_STILL_SPELL_1);
  if (GetKnowsFeat(FEAT_EPIC_SELF_CONCEALMENT_50 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_SELF_CONCEALMENT_50);
  if (GetKnowsFeat(FEAT_EPIC_SELF_CONCEALMENT_40 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_SELF_CONCEALMENT_40);
  if (GetKnowsFeat(FEAT_EPIC_SELF_CONCEALMENT_30 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_SELF_CONCEALMENT_30);
  if (GetKnowsFeat(FEAT_EPIC_SELF_CONCEALMENT_20 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_SELF_CONCEALMENT_20);
  // if (GetKnowsFeat(FEAT_EPIC_ARMOR_SKIN ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ARMOR_SKIN); - removed, this is now allowed for dragons.

  // Restrict monk AC bonus to monks that have 6+ monk levels.  No reimbursement.
  if (GetKnowsFeat(FEAT_MONK_AC_BONUS ,oPC) && GetLevelByClass(CLASS_TYPE_MONK, oPC) < 6 && GetHitDice(oPC) > GetLevelByClass(CLASS_TYPE_MONK, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_MONK_AC_BONUS);

  // Restore monk AC bonus to characters it was wrongly taken from
  if (GetLevelByClass(CLASS_TYPE_MONK, oPC) >= 6 && !GetKnowsFeat(FEAT_MONK_AC_BONUS ,oPC)) AddKnownFeat(oPC, FEAT_MONK_AC_BONUS);

  // Check for sniper path.
  object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
  int bSniper = FindSubString(GetDescription(oAbility), "Path of the Sniper") > 0 ? TRUE : FALSE;

  // Correct sniper feats accidentally stripped :(
  if (bSniper)
  {
    if (!GetHasFeat(FEAT_MOBILITY, oPC)) AddKnownFeat(oPC, FEAT_MOBILITY);
    if (!GetHasFeat(FEAT_RAPID_SHOT, oPC)) AddKnownFeat(oPC, FEAT_RAPID_SHOT);
  }
  
  // 30 Jul 2015
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ACID_3);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ACID_4);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ACID_5 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ACID_5);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_COLD_3);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_COLD_4);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_COLD_5 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_COLD_5);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4);
  if (GetKnowsFeat(FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5 ,oPC)) _RemoveFeat(oPC, FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5);
  
  // 6th July 2025
  if (GetKnowsFeat(FEAT_MOUNTED_COMBAT, oPC)) _RemoveFeat(oPC, FEAT_MOUNTED_COMBAT);
  // TODO - Ride skill.
  // TODO - something with summon mount?

  //Every other feat
  int x;
  int nFeat;
  int nCont = TRUE;
  while(nCont)
  {
    nCont = FALSE;
    for(x = 0; x <= NWNX_Creature_GetFeatCount(oPC); x++)
    {
      nFeat = NWNX_Creature_GetFeatByIndex(oPC, x);
      if(nFeat != 1089 &&
         nFeat != -1 &&
         !(bSniper && FEAT_POINT_BLANK_SHOT) &&
         !(bSniper && FEAT_MOBILITY) &&
         !NWNX_Creature_GetMeetsFeatRequirements(oPC, nFeat))
      {

        //Remove the feat if it's not two weapon fighting or if they don't have dual-wield - Exception for ranger improved dual-wield
        if((nFeat != FEAT_IMPROVED_TWO_WEAPON_FIGHTING  || !GetHasFeat(374, oPC)) &&
          ((nFeat!= FEAT_CLEAVE && nFeat != FEAT_STUNNING_FIST) || !GetLevelByClass(CLASS_TYPE_MONK, oPC)) && //remove the feat if it isn't cleave (and sturnning fist) or remove it because they have no monk levels
          ((nFeat != FEAT_KNOCKDOWN && nFeat != FEAT_IMPROVED_KNOCKDOWN) || GetLevelByClass(CLASS_TYPE_MONK, oPC) < 6) && //remove the feat if it isn't knockdoown or if they have less then 6 levels of monk
          (nFeat != FEAT_IMPROVED_EVASION || GetLevelByClass(CLASS_TYPE_MONK, oPC) < 9))
          {
            _RemoveFeat(oPC, nFeat);
            nCont = TRUE;
          }
       }
    }
  }

  object oHide = gsPCGetCreatureHide(oPC);
  //Handle custom feats
  if ((!GetHasFeat(FEAT_BREW_POTION, oPC) ||
      !GetHasFeat(FEAT_CRAFT_WAND, oPC) ||
      !GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)) &&
      GetLocalInt(oHide, "CRAFT_WONDROUS_ITEM"))
  {
    DeleteLocalInt(oHide, "CRAFT_WONDROUS_ITEM");
    _RefundGoldLvl(oPC);

  }

  if(!GetLevelByClass(CLASS_TYPE_BARD, oPC))
  {
    int nCL = GetLocalInt(oHide, "MI_WA_BONUS_CASTER_LEVELS")/2;
    int nWL = TRUE;
    if(nCL == 0)
    {
      nWL = FALSE;
      nCL = GetLocalInt(oHide, "FL_BONUS_BARD_LEVELS")/4;
    }

    for(x = 1; x <= nCL; x++)
    {
      _RefundGoldLvl(oPC);
    }

    if(nCL > 1)
    {
      if(nWL)
        DeleteLocalInt(oHide, "MI_WA_BONUS_CASTER_LEVELS");
      else
      {
        gsIPStackSkill(oHide, SKILL_PERFORM, -4*nCL);
        DeleteLocalInt(oHide, "FL_BONUS_BARD_LEVELS");
      }
    }
  }

  // Classes.
  if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) > 6) _Relevel(oPC);
  if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 6) _Relevel(oPC);
  if (GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION, oPC) > 6) _Relevel(oPC);
  if (GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC) > 6) _Relevel(oPC);
  if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) > 4) _Relevel(oPC);
  if (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) > 6) _Relevel(oPC);

}
*/