//::///////////////////////////////////////////////
//:: Negative Energy Protection
//:: NW_S0_NegProt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants immunity to negative damage, level drain
    and Ability Score Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "inc_customspells" 
#include "inc_effect"
#include "inc_respawn"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more
  
*/

  if (!X2PreSpellCastCode())
  {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    return;
  }

// End of Spell Cast Hook

  //Declare major variables
  object oTarget = GetSpellTargetObject();

  effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

  effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
  effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
  effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);

  int nDuration = AR_GetCasterLevel(OBJECT_SELF);
  int nMetaMagic = AR_GetMetaMagicFeat();
    
  //Enter Metamagic conditions
  if (nMetaMagic == METAMAGIC_EXTEND)
  {
    nDuration = nDuration *2; //Duration is +100%
  }
    
  //Link Effects
  effect eLink = EffectLinkEffects(eNeg, eLevel);

  // dunshine: check if target has death/subdual penalties, if so, do not add the ability decrease immunity
  string nCurrentServer = GetLocalString(GetModule(), "SERVER_NAME");
  object oSave = sepRESaveItem(oTarget);
  if (GetHasTaggedEffect(oTarget, EFFECT_TAG_DEATH) || 
      GetHasTaggedEffect(oTarget, EFFECT_TAG_SUBDUAL) || 
     (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_SURFACE") == 1 && nCurrentServer == "1") ||
     (GetLocalInt(oSave, "GS_RESPAWN_DRAIN_CANDP") == 1 && nCurrentServer == "3")) {
    FloatingTextStringOnCreature("You are too weak to receive the full potential of this spell", oTarget);
  } else {
    eLink = EffectLinkEffects(eLink, eAbil);
  }

  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));

  //Apply the VFX impact and effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

}

