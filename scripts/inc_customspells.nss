// Utilities for custom spells.

#include "inc_pc"
#include "inc_spell"
#include "inc_time"
#include "inc_class"
#include "inc_common"
#include "inc_disguise"
#include "inc_favsoul"
#include "inc_generic"
#include "inc_spells"
#include "__server_config"
#include "x0_i0_position"

const int CUSTOM_SPELL_SCRY       = 1;
const int CUSTOM_SPELL_SEND_IMAGE = 2;
const int CUSTOM_SPELL_WARD       = 3;
const int CUSTOM_SPELL_YOINK      = 4;
const int CUSTOM_SPELL_TELEPORT   = 5;
const int CUSTOM_SPELL_BALANCE    = 6;
const int CUSTOM_SPELL_SURGE      = 7;
const int CUSTOM_SPELL_CHAOS      = 8;
const int CUSTOM_SPELL_FATE       = 9;
const int CUSTOM_SPELL_PORTAL     = 10;
const int CUSTOM_SPELL_COUNT      = 10;

const int STREAM_ZOMBIE = 1;
const int STREAM_GHOUL  = 2;
const int STREAM_WRAITH = 3;

const string SPELL_ID = "MI_SP_SUMMON_SPELL_ID";

const string AR_SURGE_USES = "AR_SURGE_USES";
const string AR_FATE_USE   = "AR_FATE_USE";

const string IS_SCRYING = "MI_IS_SCRYING";

// Creates a henchman and applies it to oCaster.  If nVisualEffect is set,
// will play that.
void miCreateHenchman(string sResRef, object oCaster, int nVisualEffect);
// Utility function to return the caster's bonus vs spell resistance. All in one
// place to make this easy to change if future feats are added.
int GetSpellPenetrationModifiers(object oCaster);
// Utility function to return the caster's bonuses to spell DC. This doesn't
// include their ability score or the spell level.
int GetSpellDCModifiers(object oCaster, int nSpellSchool);
// Make the specified caster look like they're casting a spell.
void miDoCastingAnimation(object oCaster);
// Mark nSpell as used.  nSpell should be one of the CUSTOM_SPELL_ constants.
void miSPHasCastSpell(object oCaster, int nSpell);
// Get whether oCaster can cast nSpell.
int miSPGetCanCastSpell(object oCaster, int nSpell);
// Used on rest to clear all spells.
void miSPClearAllCastSpells(object oCaster);
// TRUE if the last caster was a wizard, sorcerer, or
// non-FS bard.  FALSE otherwise.
int miSPGetLastSpellArcane(object oCaster);
//Custom Caster level check  - Wrapper
int AR_GetCasterLevel(object oCaster=OBJECT_SELF);
//Custom Reflex adjusted damage   - Wrapper
int AR_GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);
//Meta magic wrapper
int AR_GetMetaMagicFeat();
//Adjust damage based on caster level (and feats) vs target spell resistance
int miSPGetSRAdjustedDamage(int nDamage, object oTarget, object oCaster = OBJECT_SELF);
// Returns TRUE if oPC is a non-humanoid creature/race
int miSPGetIsPlayerNonHumanoid(object oPC);
//Saves spell slots for a wizard to be used on rest and on login
void md_SaveSpellLevel(object oPC, int nLevel);
// Returns true if a PC is in an area protected against scrying.
int IsProtected(object oPC);
// Stop scrying. Call via DelayCommand. nHP is the PC's hitpoints when they
// start.
void stopscry(object oPC, int nHP);
// Returns TRUE if the PC can use scrying.
int GetCanScry(object oPC);
// Returns TRUE if the area the PC is in is protected from scrying.
int IsProtected(object oPC);
// Fades the PC out and in again.
void blackout(object oPC);
// Remove scrying-related invis effects.
void miSCRemoveInvis(object oPC, int bAlsoRemoveAudibleEffects = FALSE);
// Jumps oPC to oTarg, putting them in cutscene mode.  You will need to
// call miSCRemoveInvis, jump the PC to
void miSCDoScrying(object oPC, object oTarg, int bMagical = TRUE);
// Returns TRUE if oPC is currently scrying.
int miSCIsScrying(object oPC);
// Overrides whether oPC can scry or not.  See mi_scry_enter (used near crystal
// balls).
void SetScryOverride(object oPC, int bCanScry);

//------------------------------------------------------------------------------
void miCreateHenchman(string sResRef, object oCaster, int nVisualEffect)
{
  object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
        GetSpellTargetLocation(), TRUE);
  AssignCommand(oCreature, SetIsDestroyable(TRUE,FALSE,FALSE));
  AssignCommand(oCaster, AddHenchman(oCaster, oCreature));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(nVisualEffect),
                        GetSpellTargetLocation());
}
//------------------------------------------------------------------------------
void _SetSpellId(object oCaster, int nSpell, int nSlot)
{
  object oCreature = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, 1);

  if (nSlot > 1)
  {
    nSlot --;
    oCreature = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, nSlot);
  }

  if (GetIsObjectValid(oCreature))  SetLocalInt(oCreature, SPELL_ID, nSpell);
  else DelayCommand(1.0f, _SetSpellId(oCaster, nSpell, nSlot));
}
//------------------------------------------------------------------------------
int GetSpellPenetrationModifiers(object oCaster)
{
  int nResult = 0;

  // Spell penetration feats
  if (GetHasFeat(FEAT_SPELL_PENETRATION, oCaster))
  {
    nResult += 2;
  }
  else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
  {
    nResult += 4;
  }
  else if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
  {
    nResult += 6;
  }

  return nResult;
}
//------------------------------------------------------------------------------
int GetSpellDCModifiers(object oCaster, int nSpellSchool)
{
  int nResult = 0;
  // Look for spell focuses etc.
  switch (nSpellSchool)
  {
    case SPELL_SCHOOL_ABJURATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_CONJURATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_DIVINATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_ENCHANTMENT:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_EVOCATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_GENERAL:
    {
      // Do nothing.
      break;
    }
    case SPELL_SCHOOL_ILLUSION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_NECROMANCY:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_TRANSMUTATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCaster))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCaster))
      {
        nResult += 2;
      }
      break;
    }
  }

  return nResult;
}
//------------------------------------------------------------------------------
void miDoCastingAnimation(object oCaster)
{
  AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 3.0));
}
//------------------------------------------------------------------------------
void miSPHasCastSpell(object oCaster, int nSpell)
{
  object oHide = gsPCGetCreatureHide(oCaster);
  SetLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(nSpell), TRUE);
}
//------------------------------------------------------------------------------
int miSPGetCanCastSpell(object oCaster, int nSpell)
{
  object oHide = gsPCGetCreatureHide(oCaster);
  if (GetLocalInt(oHide, "SPELLSWORD"))
  {
    return 0;
  }
  else
  {
    return ! GetLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(nSpell));
  }
}
//------------------------------------------------------------------------------
void miSPClearAllCastSpells(object oCaster)
{
  object oHide = gsPCGetCreatureHide(oCaster);
  int nSpell = 1;
  for (nSpell; nSpell <= CUSTOM_SPELL_COUNT; nSpell ++)
  {
    DeleteLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(nSpell));
  }

  //::  For Wild Mages only, restore used surges after rest
  //::  and remove active chaos, surge & fate spell (No abuse!)
  if ( GetLocalInt(oHide, "WILD_MAGE") == TRUE ) {
    DeleteLocalInt (oCaster, AR_SURGE_USES);
    DeleteLocalInt (oCaster, AR_FATE_USE);
    DeleteLocalInt (oCaster, "AR_SURGE_ACTIVE");
    DeleteLocalInt (oCaster, "AR_CHAOS_ACTIVE");
    DeleteLocalInt (oCaster, "AR_FATE_ACTIVE");
  }
}
//------------------------------------------------------------------------------
int miSPGetLastSpellArcane(object oCaster)
{
  int nClass = GetLastSpellCastClass();

  return (nClass == CLASS_TYPE_WIZARD ||
          nClass == CLASS_TYPE_SORCERER ||
          nClass == CLASS_TYPE_BARD);
}
//------------------------------------------------------------------------------
int AR_GetCasterLevel(object oCaster=OBJECT_SELF)
{
  int nSpellId = GetSpellId();

  if(GetCasterLevelOverride(oCaster, nSpellId))
  {
    return GetCasterLevelOverride(oCaster, nSpellId) + GetTemporaryCasterLevelBonus(oCaster);
  }

  object oItem = GetSpellCastItem();
  int nCasterLevel = GetCasterLevel(oCaster);

  if (GetIsObjectValid(oItem) && GetLocalInt(GetModule(), "STATIC_LEVEL"))
  {
    int nLevel = GetLocalInt(oItem, "SPELL_CAST_LEVEL");
    if (nLevel) return nLevel;
  }

  if(GetIsLastSpellCastSpontaneous())
  {
    // Override to allow assigned spontaneous spells (e.g. for the healer path) to exceed
    // CL 15.
    nCasterLevel = GetLevelByClass(GetSpontaneousSpellClass(oCaster, nSpellId), oCaster);
  }

  // If a PM, add half their class level to their caster level.
  int nPMBonus = GetLevelByClass(CLASS_TYPE_PALE_MASTER, oCaster) / 2;

  // Harper bonuses.
  int nHarperLevel = GetLevelByClass(CLASS_TYPE_HARPER, oCaster);
  int nHarperBonus = 0;

  if (nHarperLevel)
  {
    int nHarperPath = GetLocalInt(gsPCGetCreatureHide(oCaster), VAR_HARPER);

    switch (nHarperPath)
    {
      case MI_CL_HARPER_SCOUT:
        // Bonus at levels 1/3/5
        nHarperBonus = (nHarperLevel + 1) / 2;
        break;
      case MI_CL_HARPER_MAGE:
        // Full bonus, but for arcane spells only.
        if (miSPGetLastSpellArcane(oCaster)) nHarperBonus = nHarperLevel;
        break;
      case MI_CL_HARPER_PRIEST:
        // Full bonus, but for divine spells only.
        if (!miSPGetLastSpellArcane(oCaster)) nHarperBonus = nHarperLevel;
        break;
      case MI_CL_HARPER_PARAGON:
        // Full bonus.
        nHarperBonus = nHarperLevel;
        break;
      case MI_CL_HARPER_MASTER:
        // No bonus
        break;
    }
  }

  // Shadow Mage bonus.
  int nShadowBonus = 0;
  if (GetIsShadowMage(oCaster) &&
      (GetLastSpellCastClass() == CLASS_TYPE_WIZARD || GetLastSpellCastClass() == CLASS_TYPE_SORCERER))
  {
    nShadowBonus = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oCaster);
  }

  nCasterLevel = nCasterLevel + nPMBonus + nHarperBonus + nShadowBonus  + AR_GetCasterLevelBonus(oCaster) + GetTemporaryCasterLevelBonus(oCaster);
  
  if (nCasterLevel < 0) nCasterLevel = 0;
  return nCasterLevel;
}
//------------------------------------------------------------------------------
int AR_GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{
  return GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);
}
//------------------------------------------------------------------------------
int AR_GetMetaMagicFeat()
{
  if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT) return GetAoEMetaMagic();
  return GetMetaMagicFeat();
}
//------------------------------------------------------------------------------
int miSPGetSRAdjustedDamage(int nDamage, object oTarget, object oCaster = OBJECT_SELF)
{
  if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
  {
    int nCasterLevel = AR_GetCasterLevelBonus(oCaster);

    int bSpellPen = GetHasFeat(FEAT_SPELL_PENETRATION, oCaster);
    int bGrSpellPen = GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster);
    int bEpSpellPen = GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster);

    if (bEpSpellPen) nCasterLevel += 6;
    else if (bGrSpellPen) nCasterLevel += 4;
    else if (bSpellPen) nCasterLevel += 2;

    int nSpellRes = GetSpellResistance(oTarget);

    if (nSpellRes)
    {
       ApplyEffectToObject(DURATION_TYPE_INSTANT,
                           EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE),
                           oTarget);

      nDamage = FloatToInt(  (IntToFloat(nDamage) * IntToFloat(nCasterLevel))
                            /(IntToFloat(nCasterLevel) + IntToFloat(nSpellRes)) );
    }
  }

  return nDamage;
}

int miSPGetIsPlayerNonHumanoid(object oPC) {

    if ( !GetIsPC(oPC) || GetIsDM(oPC) )    return FALSE;

    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
    if ( nSubRace == GS_SU_SPECIAL_IMP || nSubRace == GS_SU_SPECIAL_FEY ||
         nSubRace == GS_SU_SPECIAL_DRAGON)
         return TRUE;

    return FALSE;
}
//------------------------------------------------------------------------------
void md_SaveSpellLevel(object oPC, int nLevel)
{
    if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) == 0) return;
    struct NWNX_Creature_MemorisedSpell sSpell;
    int x;
    for(x = 0; x <= NWNX_Creature_GetMaxSpellSlots(oPC, CLASS_TYPE_WIZARD, nLevel); x++)
    {
        sSpell = NWNX_Creature_GetMemorisedSpell(oPC, CLASS_TYPE_WIZARD, nLevel, x);

        if(sSpell.ready) //only save readied spells
        {
            SetLocalInt(oPC, "md_sc_savespell"+IntToString(nLevel)+IntToString(x), sSpell.id+1); //increment by 1 as spells start at 0.
        }
        else
            DeleteLocalInt(oPC, "md_sc_savespell"+IntToString(nLevel)+IntToString(x)); //remove possibly to be unused variables

    }
}
//------------------------------------------------------------------------------
int miSCIsScrying(object oPC)
{
  return GetLocalInt(oPC, IS_SCRYING);
}
//------------------------------------------------------------------------------
int miSCGetCasterLevel(object oPC)
{
  return ( GetLevelByClass(CLASS_TYPE_CLERIC, oPC) +
           GetLevelByClass(CLASS_TYPE_DRUID, oPC) +
           GetLevelByClass(CLASS_TYPE_SORCERER, oPC) +
           GetLevelByClass(CLASS_TYPE_WIZARD, oPC));
}
//------------------------------------------------------------------------------
int IsProtected(object oPC)
{
  return GetIsObjectValid(GetNearestObjectByTag("scry_protector", oPC)) ||
         GetIsObjectValid(GetNearestObjectByTag("abjurer_ward", oPC)) ||
         (GetTag(GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) == "gvd_amu_noscry");
}
//------------------------------------------------------------------------------
void blackout(object oPC)
{
  FadeToBlack(oPC,FADE_SPEED_SLOW);
  DelayCommand(2.0,FadeFromBlack(oPC,FADE_SPEED_SLOW));
}
//------------------------------------------------------------------------------
void miSCRemoveInvis(object oPC, int bAlsoRemoveAudibleEffects = FALSE)
{
  effect eRemove=GetFirstEffect(oPC);
  while (GetIsEffectValid(eRemove))
  {
    int eType=GetEffectType(eRemove);
    int eDur=GetEffectDurationType(eRemove);

    if((eType == EFFECT_TYPE_VISUALEFFECT && bAlsoRemoveAudibleEffects) ||
       (eType == EFFECT_TYPE_VISUALEFFECT && eDur == DURATION_TYPE_PERMANENT) ||
       eType == EFFECT_TYPE_INVISIBILITY ||
	   eType == EFFECT_TYPE_SANCTUARY ||
       eType == EFFECT_TYPE_ETHEREAL)
    {
         RemoveEffect(oPC, eRemove);
    }

    eRemove=GetNextEffect(oPC);
  }
}
//------------------------------------------------------------------------------
void stopscry(object oPC, int nHP)
{
  DeleteLocalInt(oPC, IS_SCRYING);
  DeleteLocalInt(oPC, "AI_IGNORE");
  AssignCommand(oPC, ClearAllActions(TRUE));
  gsCMStopFollowers(oPC);
  object oCopy = GetLocalObject(oPC, "pccopy");
  location pcLocation = GetLocation(oCopy);

  // debug code
  //WriteTimestampedLogEntry("Found copy: " + GetName(oCopy));

  SetImmortal(oCopy, FALSE);
  DestroyObject(oCopy, 0.0);

  DelayCommand(2.0, miSCRemoveInvis(oPC));

  object oServant = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  oServant = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  SetPlotFlag(oPC,FALSE);
  DelayCommand(1.2, AssignCommand(oPC, ActionJumpToLocation(pcLocation)));
  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                      EffectDamage(nHP - GetCurrentHitPoints(oCopy),
                      DAMAGE_TYPE_POSITIVE,
                      DAMAGE_POWER_NORMAL),
                      oPC);

  blackout(oPC);
  DelayCommand(3.0, SetCutsceneMode(oPC,FALSE));
}
//------------------------------------------------------------------------------
int GetCanScry(object oPC)
{
  if (ALLOW_SCRYING)
  {
    if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_scry_item"))) return TRUE;

    if (GetLocalInt(oPC, "OVERRIDE_CANSCRY")) return TRUE;

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC)) return TRUE;
  }
  return FALSE;
}
//------------------------------------------------------------------------------
void SetScryOverride(object oPC, int bCanScry)
{
  SetLocalInt(oPC, "OVERRIDE_CANSCRY", bCanScry);
}
//------------------------------------------------------------------------------
void conceal (object oPC)
{
	//------------------------------------------------------------------------------------
    // OK, this isn't simple.
	// - Regular invisibility can be pierced by True Sight etc and by standing nearby
	// - Cutscene invisibility doesn't prevent the playerlist from showing the PC as near
	// - You apparently can't stack two types of invisibility.
	// We're sticking with Cutscene Invis for now.
	//------------------------------------------------------------------------------------
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                        oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectCutsceneGhost(),
                        oPC);
}
//------------------------------------------------------------------------------
int GetCanSendImage(object oPC)
{
  //if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_send_item"))) return TRUE;

  if (ALLOW_SENDING)
  {
     if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC))
     {
       return TRUE;
     }
  }

  return FALSE;
}
//------------------------------------------------------------------------------
int Scrying(object oPC,object oTarg)
{
  // Spell resistance check.
  object oHide = gsPCGetCreatureHide(oPC);
  int nCheck = d20() + GetLevelByClass(CLASS_TYPE_WIZARD, oPC) + GetLevelByClass(CLASS_TYPE_BARD, oPC) + GetLevelByClass(CLASS_TYPE_SORCERER, oPC) + 
                GetLevelByClass(CLASS_TYPE_DRUID, oPC) + GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) + GetLevelByClass(CLASS_TYPE_CLERIC, oPC) +
				  GetLocalInt(oHide, "ATTUNEMENT_STRENGTH") / 2;

  if(GetHasSpellEffect(SPELL_SANCTUARY,oTarg) || GetHasSpellEffect(SPELL_INVISIBILITY,oTarg)
         ||GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE,oTarg) 
         ||GetHasSpellEffect(346,oTarg)  // Shadow conjuration invis
         ||GetHasSpellEffect(607,oTarg)  // Assassin invis
         ||GetHasSpellEffect(608,oTarg)  // Assassin imp invis
         ||GetHasSpellEffect(483,oTarg)  // Harper invis
         ||GetHasSpellEffect(799,oTarg)  // Vampire invis
         ||GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY,oTarg) || IsProtected(oTarg) ||
		 nCheck < GetSpellResistance(oTarg)
		 )
         {
         blackout(oPC);
         SendMessageToPC(oPC,"You see nothing.");
         SendMessageToPC(oPC,"Scrying has failed: the target is warded against such divination.");
         return FALSE;
         }

  if (GetAreaFromLocation(GetLocation(oTarg)) == OBJECT_INVALID)
  {
    SendMessageToPC(oPC, "You concentrate, but are unable to locate the target.");
    return FALSE;
  }

  // Scry time limiting now handled in chat_scry.
  int nConcentration = GetSkillRank(SKILL_CONCENTRATION, oTarg) + (GetKnowsFeat(FEAT_ARCANE_DEFENSE_DIVINATION, oTarg) ?  5 : 0) + (GetCanScry(oTarg) ?  5 : 0);
  int nSpellcraft    = GetSkillRank(SKILL_SPELLCRAFT, oPC) + 6; // ESF Divination required for scrying
  if( (d20() + nConcentration) > (d20() + nSpellcraft) )
  {
    SendMessageToPC(oTarg,"You sense you are being watched from afar.");
  }	
  
  miSCDoScrying(oPC, oTarg);
  miSPHasCastSpell(oPC, CUSTOM_SPELL_SCRY);
  
  return TRUE;
}
//------------------------------------------------------------------------------
void miSCDoScrying(object oPC, object oTarg, int bMagical = TRUE)
{
  SetLocalInt(oPC, IS_SCRYING, TRUE);
  AssignCommand(oPC, ClearAllActions());
  if (bMagical) miSCRemoveInvis (oPC, TRUE); // Avoid buff jingle noises when scrying.
  conceal (oPC);

  object oServant = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  if (GetIsObjectValid(oServant)) conceal(oServant);

  oServant = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  if (GetIsObjectValid(oServant)) conceal(oServant);

  int nHP = GetCurrentHitPoints(oPC);

  object oCopy;

  if (bMagical)
  {
    location pcLocation=GetLocation(oPC);
    float scrydur = IntToFloat(SCRYING_DURATION) + 2.0;
    DelayCommand(scrydur, stopscry(oPC, nHP));
    oCopy = CopyObject(oPC,pcLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    SetLocalObject(oPC, "pccopy", oCopy);

    AssignCommand(oCopy,
                  ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,
                  0.2,
                  3600.00));
				  
	ChangeFaction(oCopy, GetObjectByTag("factionexample12")); // plot
	SetLocalInt(oCopy, "AI_IGNORE", TRUE);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                        oCopy,
                        3600.0);
    SetImmortal(oCopy,TRUE);
  }

  SetCutsceneMode(oPC,TRUE);
  blackout(oPC);

  // Sort out camera. When the cutscene mode ends this will automatically be
  // undone.
  SetCameraMode(oPC, CAMERA_MODE_CHASE_CAMERA);

  RemoveAllAssociates(oPC);
  SetLocalInt(oPC, "AI_IGNORE", TRUE);

  DelayCommand(1.0,AssignCommand(oPC,ActionJumpToLocation(GetBehindLocation(oTarg))));
  DelayCommand(2.0,AssignCommand(oPC,ActionForceFollowObject(oTarg,IntToFloat(Random(5)) + 0.5)));
  SetPlotFlag(oPC,TRUE);
}
//------------------------------------------------------------------------------
// Used to make send images appear ghostly.
void ghost(object oTarget)
{
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND),
                      oTarget);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                      oTarget);
}
//------------------------------------------------------------------------------
void Send_Image(object oPC,object oTarg, string sText)
{
  if (GetAreaFromLocation(GetLocation(oTarg)) == OBJECT_INVALID)
  {
    SendMessageToPC(oPC, "The spell failed.");
    return;
  }

  // Send image once per rest.
  if(miSPGetCanCastSpell(oPC, CUSTOM_SPELL_SEND_IMAGE))
  {
    // Create a copy of the PC and remove their buffs.
    miSPHasCastSpell(oPC, CUSTOM_SPELL_SEND_IMAGE);
    location tempLocation = GetLocation(GetObjectByTag("MI_WP_TEMP_LOCATION"));
    object oCopy = CopyObject(oPC,tempLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    string sName;
    string sPortrait;
    if(GetIsPCDisguised(oPC))
	{
		SetLocalInt(oCopy, "disguised", 1);
		sName = svGetPCNameOverride(oPC); // Get the Disguised name
		SetName(oCopy, sName); //Set Name of the Image
		if (GetGender(oPC) == GENDER_MALE) //Hide portrait
		{ // Male
			sPortrait = "po_hu_m_99_";	
		}
		else
		{ // Female
			sPortrait = "po_hu_f_99_";	
		}
		SetPortraitResRef(oCopy, sPortrait);
	}
    miSCRemoveInvis (oCopy); // remove existing buff things
    ghost (oCopy);
	ChangeFaction(oCopy, GetObjectByTag("factionexample12")); // plot
    SetImmortal(oCopy, TRUE);
    SetPlotFlag(oCopy, TRUE);
    SetActionMode(oCopy, ACTION_MODE_STEALTH, FALSE);
	SetLocalInt(oCopy, "AI_IGNORE", TRUE);

    AssignCommand(GetModule(), DelayCommand(1.0, AssignCommand(oCopy, ActionJumpToObject(oTarg,FALSE))));
    AssignCommand(GetModule(), DelayCommand(1.1, AssignCommand(oCopy, SetFacingPoint(GetPosition(oTarg)))));
    AssignCommand(GetModule(), DelayCommand(1.5, AssignCommand(oCopy, ActionSpeakString(
     "*A ghostly visage appears before you, shrouded in magics. It speaks.*"))));

    AssignCommand(GetModule(), DelayCommand(3.5, AssignCommand(oCopy, ActionSpeakString(sText))));
    AssignCommand(GetModule(), DelayCommand(9.5, AssignCommand(oCopy, ActionSpeakString(
                    "*As mysteriously as it appeared, the vision vanishes.*"))));
    AssignCommand(GetModule(), DelayCommand(10.0, DestroyObject(oCopy)));
    AssignCommand(GetModule(), DelayCommand(10.5, SendMessageToPC(oTarg, "The message was: " + sText)));

    SendMessageToPC(oPC, "<c þ >Your image has been sent to " + GetName(oTarg));
  }
  else
  {
    SendMessageToPC(oPC,"<cþ  >You need to rest before you can use this ability again.");
  }
}
