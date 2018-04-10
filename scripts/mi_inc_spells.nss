// Utilities for custom spells.

#include "mi_inc_class"
#include "gs_inc_pc"
#include "gs_inc_spell"
#include "inc_spells"
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

// Creates a henchman and applies it to oCaster.  If nVisualEffect is set,
// will play that.
void miCreateHenchman(string sResRef, object oCaster, int nVisualEffect);
// Summons undead based on caster's necromantic feats.
void miSummonUndead(string sResRef, object oCaster, float fDuration, int nVisualEffect = VFX_FNF_SUMMON_UNDEAD);
// Removes all undead summons.  Use in other summoning spells.
void miUnsummonUndead(object oCaster);
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
// Retrieve any caster level bonus oCaster has
int AR_GetCasterLevelBonus(object oCaster=OBJECT_SELF);
// Set a caster level bonus for oCaster.
void AR_SetCasterLevelBonus(int nBonus, object oCaster=OBJECT_SELF);
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
void miUnsummonUndead(object oCaster)
{
  object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, 1);
  object oHench1 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, 1);
  object oHench2 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, 2);

  if (GetIsObjectValid(oSummon) && GetLocalInt(oSummon, SPELL_ID))
  {
    RemoveSummonedAssociate(oCaster, oSummon);
  }
  else if (GetIsObjectValid(oHench1) && GetLocalInt(oHench1, SPELL_ID))
  {
    RemoveHenchman(oCaster, oHench1);
  }
  else if (GetIsObjectValid(oHench2) && GetLocalInt(oHench2, SPELL_ID))
  {
    RemoveHenchman(oCaster, oHench2);
  }
}
//------------------------------------------------------------------------------
void miSummonUndead(string sResRef, object oCaster, float fDuration, int nVisualEffect = VFX_FNF_SUMMON_UNDEAD)
{
  //----------------------------------------------------------------------------
  // This method should be used by all summon undead abilities (Animate Dead,
  // Create Undead, Create Greater Undead, Summon Undead, Summon Greater Undead).
  //
  // It needs to be called from a spell script (i.e. GetSpellId() should work!).
  //
  // Casters can have up to one minion per Spell Focus in Necromancy (min 1).
  // The first is summoned as a usual creature (i.e. in the summon slot).
  // The second and third, if applicable, take up henchman slots.
  // Each distinct spell can only summon one minion (so casting animate dead
  // twice won't net you a second minion, even with GSF).
  // There are three streams of undead (zombie, ghoul and wraith).  Zombie is
  // the default.  PCs can do rituals to change stream.
  // There are 4 tiers of creature. Tier 2 kicks in at level 11, Tier 3 at 16,
  // and Tier 4 when you have the Mummy Dust spell.
  //----------------------------------------------------------------------------

  // Set up variables.
  int nSpell = GetSpellId();
  int nLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster) +
               GetLevelByClass(CLASS_TYPE_SORCERER, oCaster) +
               GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) +
               GetLevelByClass(CLASS_TYPE_PALE_MASTER, oCaster) +
               AR_GetCasterLevelBonus(oCaster);

  int nTier  = 1;

  if (GetKnowsFeat(FEAT_EPIC_SPELL_MUMMY_DUST, oCaster)) nTier = 4;
  else if (nLevel > 15) nTier = 3;
  else if (nLevel > 10) nTier = 2;

  //----------------------------------------------------------------------------
  // Work out which slot to use for summoning and clean out any creature
  // already in it.
  //----------------------------------------------------------------------------
  int nNumHenchman = 0;
  if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster)) nNumHenchman = 2;
  else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster)) nNumHenchman = 1;

  object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, 1);
  object oHench1 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, 1);
  object oHench2 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oCaster, 2);

  int nSlot = 0;
  //----------------------------------------------------------------------------
  // If we have a non-undead summon, dismiss it.
  //----------------------------------------------------------------------------
  if (GetIsObjectValid(oSummon) && !GetLocalInt(oSummon, SPELL_ID))
  {
    RemoveSummonedAssociate(oCaster, oSummon);
  }

  if (GetIsObjectValid(oSummon) && GetLocalInt(oSummon, SPELL_ID) == nSpell)
  {
    RemoveSummonedAssociate(oCaster, oSummon);
    nSlot = 1;
  }
  else if (GetIsObjectValid(oHench1) && GetLocalInt(oHench1, SPELL_ID) == nSpell)
  {
    RemoveHenchman(oCaster, oHench1);
    nSlot = 2;
  }
  else if (GetIsObjectValid(oHench2) && GetLocalInt(oHench2, SPELL_ID) == nSpell)
  {
    RemoveHenchman(oCaster, oHench2);
    nSlot = 3;
  }

  if (!nSlot)
  {
    // We are not replacing an existing summon.  Find the first available slot.
    if (!GetIsObjectValid(oSummon)) nSlot = 1;
    else if (!GetIsObjectValid(oHench1) && nNumHenchman) nSlot = 2;
    else if (!GetIsObjectValid(oHench2) && nNumHenchman > 1) nSlot = 3;
  }

  if (!nSlot)
  {
    // We don't have a spare slot!  Dismiss our summon and use slot 1.
    RemoveSummonedAssociate(oCaster, oSummon);
    nSlot = 1;
  }

  // Only PCs can have henchmen without side effects, it seems.
  if (!GetIsPC(oCaster)) nSlot = 1;

  //----------------------------------------------------------------------------
  // Determine which creature to summon.
  //----------------------------------------------------------------------------
  int nStream;
  if (!GetIsPC(oCaster)) nStream = d3();
  else nStream = GetLocalInt(gsPCGetCreatureHide(oCaster), "MI_SP_UNDEAD_STREAM");

  if (!nStream) nStream = STREAM_ZOMBIE;

  // Resref by level.
  switch (nStream)
  {
    case STREAM_ZOMBIE:
    {
      switch (nTier)
      {
        case 1:
          sResRef = "nw_s_zombie";
          break;
        case 2:
          sResRef = "nw_s_skeleton";
          break;
        case 3:
          sResRef = "x2_s_mummy";
          break;
        case 4:
          sResRef = "x2_s_mummy_9";
          break;
      }
      break;
    }
    case STREAM_GHOUL:
    {
      switch (nTier)
      {
        case 1:
          sResRef = "nw_s_ghoul";
          break;
        case 2:
          sResRef = "nw_s_ghast";
          break;
        case 3:
          sResRef = "nw_s_wight";
          break;
        case 4:
          sResRef = "nw_s_vampire";
          break;
      }
      break;
    }
    case STREAM_WRAITH:
    {
      switch (nTier)
      {
        case 1:
          sResRef = "nw_s_spectre";
          break;
        case 2:
          sResRef = "nw_s_wraith";
          break;
        case 3:
          sResRef = "nw_s_banshee";
          break;
        case 4:
          sResRef = "nw_s_lich";
          break;
      }
      break;
    }
  }

  // Actually summon the creature.
  if (nSlot == 1)
  {
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                      EffectSummonCreature(sResRef,nVisualEffect, 0.5, TRUE),
                          GetSpellTargetLocation(),
                          fDuration);
  }
  else
  {
      miCreateHenchman(sResRef, oCaster, nVisualEffect);
  }

  // Set their spell ID variable.
  DelayCommand(1.0, _SetSpellId(oCaster, nSpell, nSlot));
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
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_CONJURATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_DIVINATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_ENCHANTMENT:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_EVOCATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION))
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
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_NECROMANCY:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY))
      {
        nResult += 2;
      }
      break;
    }
    case SPELL_SCHOOL_TRANSMUTATION:
    {
      if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION))
      {
        nResult += 6;
      }
      else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION))
      {
        nResult += 4;
      }
      else if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION))
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
  int bFavSoul = miFSGetIsFavoredSoul(oCaster);

  return (nClass == CLASS_TYPE_WIZARD ||
          nClass == CLASS_TYPE_SORCERER ||
          (nClass == CLASS_TYPE_BARD && !bFavSoul));
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

  return nCasterLevel + AR_GetCasterLevelBonus(oCaster) + nPMBonus + nHarperBonus + nShadowBonus  + GetTemporaryCasterLevelBonus(oCaster);
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
int AR_GetCasterLevelBonus(object oCaster=OBJECT_SELF)
{
  return GetLocalInt(gsPCGetCreatureHide(oCaster), "AR_BONUS_CASTER_LEVELS");
}
//------------------------------------------------------------------------------
void AR_SetCasterLevelBonus(int nBonus, object oCaster=OBJECT_SELF)
{
  SetLocalInt(gsPCGetCreatureHide(oCaster), "AR_BONUS_CASTER_LEVELS", nBonus);
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
