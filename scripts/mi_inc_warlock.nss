/*
  mi_inc_warlock
  Library for all Warlock class related functions.

  The Warlock is an overlay for the Bard class.  A bard makes a pact with
  an abyssal/infernal creature to become a Warlock.

  This applies the following changes.
  - All Bard levels are upgraded to 8 HP (vs 6 normally).
  - Lose all Bardsong abilities.
  - Spell selection is changed to a fixed list, which varies by pact and level.
    Spells (invocations) may be cast any number of times per day.
  - ASF is reduced by 20% when equipping armor and shields.
  - Gain Uncanny Dodge at level 10, 5/- physical DR at level 10 and 10/- physical
    DR at level 20
  - Gain 5/- DR every 10 levels vs 2 elements (determined by pact).
  - Whenever a Warlock casts a spell that targets a hostile creature
    - they must make a Ranged Touch attack to hit
    - they do an additional d4 magic damage per class level in addition to other
      effects.
  - The spell change does not apply to charm or dominate spells, nor to area of
    effect spells unless the target point of the spell is a hostile creature.
  - Metamagic bonuses do not apply to the bonus damage.

  Spell lists by pact and class level.
      Fey                    Abyssal/Infernal
  1   Daze (0), Light (0)    Flare (0), Light (0)
  2   Sleep (1), Exp Ret (1) Summon Creature (1), Lesser Dispel (1)
  3   Mage Armor (1)         Balagarn's Iron Horn (1)
  4   Tasha's Laughter (2)   Bull's Strength (2)
  5   Cure Minor (0)         Resistance (0), Grease (1)
  6   Charm Person (1)       Protection from Alignment (1)
  7   Displacement (3)       Bestow Curse (3)
  8   Charm Monster (2)      Summon Creature (2)
  9   Ghostly Visage (2)     Darkness (2)
  10  Invisibility (4)       Dismissal (4)
  11  Cloud of Bewilder (2)  Ultravision (2)
                    Gust of Wind (3)
  12  Slow (3)               Summon Creature (3)
  13  Mind Fog (5)           See Invis (2)
      Hold Person (2)
  14                Dispel Magic (3)
                  Eagle's Splendour (2)
  15  Hold Monster (4)       Fear (3)
  16               Energy Buffer (6)
  17  Cure Light Wounds (1)  Summon Creature (4)
  18  Sound Burst (2)        Cat's Grace (2)
  19                         War Cry (4)
  20  Confusion (3)          Summon Creature (5)
  21
  22             Greater Dispelling (5)
  23
  24
  25  Dirge (6)              Summon Creature (6)
  26
  27
  28  Wounding Whispers (5)  Ice Storm (6)
  29
  30  Dominate Person (3)

  We have an issue in that on login, spell lists get reset based on
  the max spells known a bard normally has.  So after each login,
  we recalculate spell lists.

  This has the added benefit of migrating experienced warlocks.

*/
#include "gs_inc_pc"
#include "gs_inc_spell"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_effect"
#include "inc_spells"

const string TAG_WARLOCK_STAFF = "mi_wa_staff";
const string VAR_WARLOCK = "MI_WARLOCK";
const string VAR_WARLOCK_ELEMENT = "MI_WARLOCK_ELEMENT";
const string RESREF_WARLOCK_STAFF = "mi_wa_staff";

const int WARLOCK_ELEMENT_NONE      = 0;
const int WARLOCK_ELEMENT_MAGIC     = 1;
const int WARLOCK_ELEMENT_FIRE      = 2;
const int WARLOCK_ELEMENT_ACID      = 3;
const int WARLOCK_ELEMENT_NEGATIVE  = 4;
const int WARLOCK_ELEMENT_POSITIVE  = 5;
const int WARLOCK_ELEMENT_COLD      = 6;
const int WARLOCK_ELEMENT_LIGHTNING = 7;
const int WARLOCK_ELEMENT_SONIC     = 8;
const int WARLOCK_ELEMENT_DIVINE    = 9;
const int WARLOCK_ELEMENT_BLUDGEON  = 10;
const int WARLOCK_ELEMENT_SLASH     = 11;
const int WARLOCK_ELEMENT_PIERCE    = 12;

const int PACT_NONE     = 0;
const int PACT_ABYSSAL  = 1;
const int PACT_INFERNAL = 2;
const int PACT_FEY      = 3;

// No longer used, but kept for backwards compatibility.
const int SPELL_ELDRITCH_BLAST = 840;

// Returns the PC's warlock staff object, or OBJECT_INVALID if none.
object miWAGetWarlockStaff(object oPC);
//------------------------------------------------------------------------------
/// Returns PACT_* (PACT_NONE if not a Warlock).
int miWAGetIsWarlock(object oPC);
//------------------------------------------------------------------------------
// Applies Warlock class abilities to oPC.  Use when levelling up.
void miWAApplyAbilities(object oPC, int bLevelUp = TRUE);
//------------------------------------------------------------------------------
// Creates a warlock staff on oPC
object miWACreateWarlockStaff(object oPC);
//------------------------------------------------------------------------------
// Strips all spell abilities from oStaff.
void miWAStripStaffAbilities(object oStaff);
//------------------------------------------------------------------------------
// Applies Warlock spell abilities to oStaff based on oPC's bard levels.
void miWAApplyStaffAbilities(object oStaff, object oPC);
//------------------------------------------------------------------------------
// Turns oPC into a Warlock.
void miWATurnIntoWarlock(object oPC, int nPact = PACT_ABYSSAL);
//------------------------------------------------------------------------------
// Returns the damage type to use for eldritch blast
int miWAGetDamageType(object oPC);
//------------------------------------------------------------------------------
// Returns the animation to play for the eldritch blast beam
int miWAGetBeamVFX(object oPC);
//------------------------------------------------------------------------------
// Returns the animation to play on creatures hit by the blast
int miWAGetImpactVFX(object oPC);
//------------------------------------------------------------------------------
// Returns the animation to play for burst shape
int miWAGetAreaVFX(object oPC);
//------------------------------------------------------------------------------
// Returns the animation to play on the caster.  Also makes the caster's
// eyes glow.
int miWAGetCastingVFX(object oPC);
//------------------------------------------------------------------------------
// Return oWarlock's effective caster level for Warlock abilities.
int miWAGetCasterLevel(object oWarlock);
//------------------------------------------------------------------------------
// Method to increase the effective caster level for Warlock abilities.  Applies
// a static modifier that will be counted as well as a PC's warlock (bard)
// class levels.
void miWAIncreaseCasterLevel(object oWarlock, int nAmount);
//------------------------------------------------------------------------------
// Check for spell resistance
int miWAResistSpell(object oCaster, object oTarget);
//------------------------------------------------------------------------------
// Return TRUE if casting fails due to ASF.
int miWAArcaneSpellFailure(object oWarlock);
//------------------------------------------------------------------------------
// Return the save DC for the warlock's invocations (10 + half caster level +
// cha mod).
int miWAGetSpellDC(object oWarlock);
//------------------------------------------------------------------------------
// Set oWarlock's damage type to nDmaage (WARLOCK_ELEMENT_*)
void miWASetDamageType(int nDamageType, object oWarlock = OBJECT_SELF);
//------------------------------------------------------------------------------
// Do blast specific status effects.
void miWADoStatusEffect(int nDamageType, object oTarget, object oWarlock = OBJECT_SELF, int bFriendly = FALSE);
//------------------------------------------------------------------------------
// Internal method: make eyes glow, colour coded.
void _miWADoGlowingEyes(object oPC, int nDamageType);
//------------------------------------------------------------------------------
// Do Warlock attack.  Returns FALSE if the caster misses or the target passes their SR check -
// the calling spell should then return.  Returns TRUE if you hit and did damage.
// If the caller isn't a warlock, just does a standard SR check.
int miWADoWarlockAttack(object oCaster, object oTarget, int nSpellID, int bDoSRForNonWarlocks = TRUE);
//------------------------------------------------------------------------------
// Internal method to manipulate known spell lists.
void _miWAAddSpell(object oPC, int nSpellLevel, int nSpellID);
//------------------------------------------------------------------------------
// Internal method to manipulate known spell lists.
void _miWARemoveSpell(object oPC, int nSpellLevel, int nSpellID);
//------------------------------------------------------------------------------
// Method to update spell lists.
void miWASetSpells(object oPC);


//------------------------------------------------------------------------------

object miWAGetWarlockStaff(object oPC)
{
  object oStaff = GetItemPossessedBy(oPC, TAG_WARLOCK_STAFF);
  return oStaff;
}
//------------------------------------------------------------------------------
int miWAGetIsWarlock(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);
  return GetLocalInt(oHide, VAR_WARLOCK);
}
//------------------------------------------------------------------------------
object miWACreateWarlockStaff(object oPC)
{
  return CreateItemOnObject(RESREF_WARLOCK_STAFF, oPC);
}
//------------------------------------------------------------------------------
void miWAStripStaffAbilities(object oStaff)
{
  itemproperty iprop = GetFirstItemProperty(oStaff);

  while (GetIsItemPropertyValid(iprop))
  {
    if (GetItemPropertyType(iprop) == ITEM_PROPERTY_CAST_SPELL)
    {
      RemoveItemProperty(oStaff, iprop);
    }

    iprop = GetNextItemProperty(oStaff);
  }
}
//------------------------------------------------------------------------------
void miWAApplyStaffAbilities(object oStaff, object oPC)
{
  AddItemProperty(DURATION_TYPE_PERMANENT,
                  ItemPropertyCastSpell(IP_CONST_CASTSPELL_RAY_OF_FROST_1,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                  oStaff);
  AddItemProperty(DURATION_TYPE_PERMANENT,
                  ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
                                        IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                  oStaff);

  if (!GetPlotFlag(oStaff)) SetPlotFlag(oStaff, TRUE);

  int nLevel = miWAGetCasterLevel(oPC);

  if (nLevel > 10)
    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11,
                                          IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oStaff);

  if (nLevel > 20)
    AddItemProperty(DURATION_TYPE_PERMANENT,
                    ItemPropertyCastSpell(IP_CONST_CASTSPELL_CALL_LIGHTNING_10,
                                          IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                    oStaff);

  int nPact = miWAGetIsWarlock(oPC);

  if (nPact == PACT_ABYSSAL || nPact == PACT_INFERNAL)
  {
    if (nLevel > 5)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);


    if (nLevel > 13)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_ANIMATE_DEAD_15,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);

    if (nLevel > 16)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_WALL_OF_FIRE_9,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);


    if (nLevel > 25)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_GATE_17,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);
   }
   else if (nPact == PACT_FEY)
   {
    if (nLevel > 5)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);


    if (nLevel > 13)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOMINATE_PERSON_7,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);

    if (nLevel > 16)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_MIND_FOG_9,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);


    if (nLevel > 25)
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyCastSpell(IP_CONST_CASTSPELL_DOMINATE_MONSTER_17,
                                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE),
                      oStaff);
   }
}
//------------------------------------------------------------------------------
void _miWAAddSpell(object oPC, int nSpellLevel, int nSpellID)
{
  if (GetKnowsSpell(nSpellID, oPC, CLASS_TYPE_BARD)) return;

  if (nSpellLevel == -1)
  {
    AddInnateSpell(oPC, nSpellID, CLASS_TYPE_BARD);
  }
  else
  {
    NWNX_Creature_AddKnownSpell(oPC, CLASS_TYPE_BARD, nSpellLevel, nSpellID);
  }
}
//------------------------------------------------------------------------------
void _miWARemoveSpell(object oPC, int nSpellLevel, int nSpellID)
{
  if (nSpellLevel == -1)
  {
    RemoveSpecialAbilityById(oPC, nSpellID);
  }
  else
  {
    NWNX_Creature_RemoveKnownSpell(oPC, CLASS_TYPE_BARD, nSpellLevel, nSpellID);
  }
}
//------------------------------------------------------------------------------
void _miWACheckSpell(int bAllow, object oPC, int nSpellLevel, int nSpellID)
{
  if (bAllow) _miWAAddSpell(oPC, nSpellLevel, nSpellID);
  else _miWARemoveSpell(oPC, nSpellLevel, nSpellID);
}
//------------------------------------------------------------------------------
void _miWARemoveAllBardSpells(object oPC)
{
  // Remove all default bard spells ...
  _miWARemoveSpell(oPC, 0, SPELL_CURE_MINOR_WOUNDS);
  _miWARemoveSpell(oPC, 0, SPELL_DAZE);
  _miWARemoveSpell(oPC, 0, SPELL_FLARE);
  _miWARemoveSpell(oPC, 0, SPELL_LIGHT);
  _miWARemoveSpell(oPC, 0, SPELL_RESISTANCE);

  _miWARemoveSpell(oPC, 1, SPELL_AMPLIFY);
  _miWARemoveSpell(oPC, 1, SPELL_BALAGARNSIRONHORN);
  _miWARemoveSpell(oPC, 1, SPELL_CHARM_PERSON);
  _miWARemoveSpell(oPC, 1, SPELL_CURE_LIGHT_WOUNDS);
  _miWARemoveSpell(oPC, 1, SPELL_EXPEDITIOUS_RETREAT);
  _miWARemoveSpell(oPC, 1, SPELL_GREASE);
  _miWARemoveSpell(oPC, 1, SPELL_IDENTIFY);
  _miWARemoveSpell(oPC, 1, SPELL_LESSER_DISPEL);
  _miWARemoveSpell(oPC, 1, SPELL_MAGE_ARMOR);
  _miWARemoveSpell(oPC, 1, SPELL_MAGIC_WEAPON);
  _miWARemoveSpell(oPC, 1, 321); // protection vs alignment
  _miWARemoveSpell(oPC, 1, SPELL_SCARE);
  _miWARemoveSpell(oPC, 1, SPELL_SLEEP);
  _miWARemoveSpell(oPC, 1, SPELL_SUMMON_CREATURE_I);

  _miWARemoveSpell(oPC, 2, SPELL_BLINDNESS_AND_DEAFNESS);
  _miWARemoveSpell(oPC, 2, SPELL_BULLS_STRENGTH);
  _miWARemoveSpell(oPC, 2, SPELL_CATS_GRACE);
  _miWARemoveSpell(oPC, 2, SPELL_CLARITY);
  _miWARemoveSpell(oPC, 2, SPELL_CLOUD_OF_BEWILDERMENT);
  _miWARemoveSpell(oPC, 2, SPELL_CURE_MODERATE_WOUNDS);
  _miWARemoveSpell(oPC, 2, SPELL_DARKNESS);
  _miWARemoveSpell(oPC, 2, SPELL_EAGLE_SPLEDOR);
  _miWARemoveSpell(oPC, 2, SPELL_FOXS_CUNNING);
  _miWARemoveSpell(oPC, 2, SPELL_GHOSTLY_VISAGE);
  _miWARemoveSpell(oPC, 2, SPELL_HOLD_PERSON);
  _miWARemoveSpell(oPC, 2, SPELL_INVISIBILITY);
  _miWARemoveSpell(oPC, 2, SPELL_OWLS_WISDOM);
  _miWARemoveSpell(oPC, 2, SPELL_SEE_INVISIBILITY);
  _miWARemoveSpell(oPC, 2, SPELL_SILENCE);
  _miWARemoveSpell(oPC, 2, SPELL_SOUND_BURST);
  _miWARemoveSpell(oPC, 2, SPELL_SUMMON_CREATURE_II);
  _miWARemoveSpell(oPC, 2, SPELL_TASHAS_HIDEOUS_LAUGHTER);
  _miWARemoveSpell(oPC, 2, SPELL_DARKVISION); // ultravision

  _miWARemoveSpell(oPC, 3, SPELL_BESTOW_CURSE);
  _miWARemoveSpell(oPC, 3, SPELL_CHARM_MONSTER);
  _miWARemoveSpell(oPC, 3, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE);
  _miWARemoveSpell(oPC, 3, SPELL_CONFUSION);
  _miWARemoveSpell(oPC, 3, SPELL_CURE_SERIOUS_WOUNDS);
  _miWARemoveSpell(oPC, 3, SPELL_DISPEL_MAGIC);
  _miWARemoveSpell(oPC, 3, SPELL_DISPLACEMENT);
  _miWARemoveSpell(oPC, 3, SPELL_FEAR);
  _miWARemoveSpell(oPC, 3, SPELL_FIND_TRAPS);
  _miWARemoveSpell(oPC, 3, SPELL_GREATER_MAGIC_WEAPON);
  _miWARemoveSpell(oPC, 3, SPELL_GUST_OF_WIND);
  _miWARemoveSpell(oPC, 3, SPELL_HASTE);
  _miWARemoveSpell(oPC, 3, SPELL_INVISIBILITY_SPHERE);
  _miWARemoveSpell(oPC, 3, SPELL_KEEN_EDGE);
  _miWARemoveSpell(oPC, 3, 322); // circle vs alignment
  _miWARemoveSpell(oPC, 3, SPELL_REMOVE_CURSE);
  _miWARemoveSpell(oPC, 3, SPELL_REMOVE_DISEASE);
  _miWARemoveSpell(oPC, 3, SPELL_SLOW);
  _miWARemoveSpell(oPC, 3, SPELL_SUMMON_CREATURE_III);
  _miWARemoveSpell(oPC, 3, SPELL_WOUNDING_WHISPERS);

  _miWARemoveSpell(oPC, 4, SPELL_CURE_CRITICAL_WOUNDS);
  _miWARemoveSpell(oPC, 4, SPELL_DISMISSAL);
  _miWARemoveSpell(oPC, 4, SPELL_DOMINATE_PERSON);
  _miWARemoveSpell(oPC, 4, SPELL_HOLD_MONSTER);
  _miWARemoveSpell(oPC, 4, SPELL_IMPROVED_INVISIBILITY);
  _miWARemoveSpell(oPC, 4, SPELL_LEGEND_LORE);
  _miWARemoveSpell(oPC, 4, SPELL_NEUTRALIZE_POISON);
  _miWARemoveSpell(oPC, 4, SPELL_SUMMON_CREATURE_IV);
  _miWARemoveSpell(oPC, 4, SPELL_WAR_CRY);

  _miWARemoveSpell(oPC, 5, SPELL_ETHEREAL_VISAGE);
  _miWARemoveSpell(oPC, 5, SPELL_GREATER_DISPELLING);
  _miWARemoveSpell(oPC, 5, SPELL_HEALING_CIRCLE);
  _miWARemoveSpell(oPC, 5, SPELL_MIND_FOG);
  _miWARemoveSpell(oPC, 5, SPELL_SUMMON_CREATURE_V);

  _miWARemoveSpell(oPC, 6, SPELL_DIRGE);
  _miWARemoveSpell(oPC, 6, SPELL_ENERGY_BUFFER);
  _miWARemoveSpell(oPC, 6, SPELL_ICE_STORM);
  _miWARemoveSpell(oPC, 6, SPELL_MASS_HASTE);
  _miWARemoveSpell(oPC, 6, SPELL_SUMMON_CREATURE_VI);
}
//------------------------------------------------------------------------------
void miWASetSpells(object oPC)
{
  // Apply spell changes. Warlocks have a defined spell list by pact.  Remove any other spells.
  int nLevel = miWAGetCasterLevel(oPC);
  int nPact = miWAGetIsWarlock(oPC);

  _miWARemoveAllBardSpells(oPC);

  if (nPact == PACT_FEY)
  {
    _miWACheckSpell(nLevel >= 1, oPC, 0, SPELL_FLARE);
    _miWACheckSpell(nLevel >= 1, oPC, 0, SPELL_LIGHT);
    _miWACheckSpell(nLevel >= 2, oPC, 1, SPELL_SLEEP);
    _miWACheckSpell(nLevel >= 2, oPC, 1, SPELL_EXPEDITIOUS_RETREAT);
    _miWACheckSpell(nLevel >= 3, oPC, 1, SPELL_MAGE_ARMOR);
    _miWACheckSpell(nLevel >= 4, oPC, 2, SPELL_TASHAS_HIDEOUS_LAUGHTER);
    _miWACheckSpell(nLevel >= 5, oPC, 0, SPELL_RESISTANCE);
    _miWACheckSpell(nLevel >= 5, oPC, 1, SPELL_CURE_LIGHT_WOUNDS);
    _miWACheckSpell(nLevel >= 6, oPC, 1, SPELL_CHARM_PERSON);
    _miWACheckSpell(nLevel >= 7, oPC, 3, SPELL_DISPLACEMENT);
    _miWACheckSpell(nLevel >= 8, oPC, 3, SPELL_CHARM_MONSTER);
    _miWACheckSpell(nLevel >= 9, oPC, 2, SPELL_GHOSTLY_VISAGE);
    _miWACheckSpell(nLevel >= 10, oPC, 2, SPELL_INVISIBILITY);
    _miWACheckSpell(nLevel >= 11, oPC, 2, SPELL_CLOUD_OF_BEWILDERMENT);
    _miWACheckSpell(nLevel >= 11, oPC, 2, SPELL_HOLD_PERSON);
    _miWACheckSpell(nLevel >= 12, oPC, 3, SPELL_HASTE);
    _miWACheckSpell(nLevel >= 12, oPC, 3, SPELL_SLOW);
    _miWACheckSpell(nLevel >= 13, oPC, 5, SPELL_MIND_FOG);
    _miWACheckSpell(nLevel >= 14, oPC, 3, SPELL_DISPEL_MAGIC);
    _miWACheckSpell(nLevel >= 14, oPC, 2, SPELL_EAGLE_SPLEDOR);
    _miWACheckSpell(nLevel >= 15, oPC, 4, SPELL_HOLD_MONSTER);
    _miWACheckSpell(nLevel >= 16, oPC, 6, SPELL_ENERGY_BUFFER);
    _miWACheckSpell(nLevel >= 17, oPC, -1, SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW);
    _miWACheckSpell(nLevel >= 18, oPC, 2, SPELL_SOUND_BURST);
    _miWACheckSpell(nLevel >= 19, oPC, 4, SPELL_DOMINATE_PERSON);
    _miWACheckSpell(nLevel >= 20, oPC, 3, SPELL_CONFUSION);
    _miWACheckSpell(nLevel >= 22, oPC, 5, SPELL_GREATER_DISPELLING);
    _miWACheckSpell(nLevel >= 25, oPC, 6, SPELL_DIRGE);
    _miWACheckSpell(nLevel >= 28, oPC, -1, SPELL_SHADOW_SHIELD);
  }
  else if (nPact == PACT_ABYSSAL || nPact == PACT_INFERNAL)
  {
    _miWACheckSpell(nLevel >= 1, oPC, 0, SPELL_FLARE);
    _miWACheckSpell(nLevel >= 1, oPC, 0, SPELL_LIGHT);
    _miWACheckSpell(nLevel >= 2, oPC, 1, SPELL_LESSER_DISPEL);
    _miWACheckSpell(nLevel >= 2, oPC, 1, SPELL_SUMMON_CREATURE_I);
    _miWACheckSpell(nLevel >= 3, oPC, 1, SPELL_BALAGARNSIRONHORN);
    _miWACheckSpell(nLevel >= 4, oPC, 2, SPELL_BULLS_STRENGTH);
    _miWACheckSpell(nLevel >= 5, oPC, 0, SPELL_RESISTANCE);
    _miWACheckSpell(nLevel >= 5, oPC, 1, SPELL_GREASE);
    _miWACheckSpell(nLevel >= 6, oPC, 1, 321); // prot from alignment
    _miWACheckSpell(nLevel >= 7, oPC, 3, SPELL_BESTOW_CURSE);
    _miWACheckSpell(nLevel >= 8, oPC, 2, SPELL_SUMMON_CREATURE_II);
    _miWACheckSpell(nLevel >= 9, oPC, 2, SPELL_DARKNESS);
    _miWACheckSpell(nLevel >= 10, oPC, 4, SPELL_DISMISSAL);
    _miWACheckSpell(nLevel >= 11, oPC, 2, SPELL_DARKVISION);
    _miWACheckSpell(nLevel >= 11, oPC, 3, SPELL_GUST_OF_WIND);
    _miWACheckSpell(nLevel >= 12, oPC, 3, SPELL_SUMMON_CREATURE_III);
    _miWACheckSpell(nLevel >= 13, oPC, 2, SPELL_SEE_INVISIBILITY);
    _miWACheckSpell(nLevel >= 14, oPC, 3, SPELL_DISPEL_MAGIC);
    _miWACheckSpell(nLevel >= 14, oPC, 2, SPELL_EAGLE_SPLEDOR);
    _miWACheckSpell(nLevel >= 15, oPC, 3, SPELL_FEAR);
    _miWACheckSpell(nLevel >= 16, oPC, 6, SPELL_ENERGY_BUFFER);
    _miWACheckSpell(nLevel >= 17, oPC, 4, SPELL_SUMMON_CREATURE_IV);
    _miWACheckSpell(nLevel >= 18, oPC, 2, SPELL_CATS_GRACE);
    _miWACheckSpell(nLevel >= 19, oPC, 4, SPELL_WAR_CRY);
    _miWACheckSpell(nLevel >= 19, oPC, 2, SPELL_BLINDNESS_AND_DEAFNESS);
    _miWACheckSpell(nLevel >= 20, oPC, 3, 322); // Magic circle vs align
    _miWACheckSpell(nLevel >= 20, oPC, 5, SPELL_SUMMON_CREATURE_V);
    _miWACheckSpell(nLevel >= 22, oPC, 5, SPELL_GREATER_DISPELLING);
    _miWACheckSpell(nLevel >= 25, oPC, 6, SPELL_SUMMON_CREATURE_VI);
    _miWACheckSpell(nLevel >= 28, oPC, 6, SPELL_ICE_STORM);
  }
}
//------------------------------------------------------------------------------
void miWAApplyAbilities(object oPC, int bLevelUp = TRUE)
{
  // Not a bard level?
  int nPact = miWAGetIsWarlock(oPC);
  int nHD   = GetHitDice(oPC);

  if (!nPact) return;

  int nLevel = miWAGetCasterLevel(oPC);
  object oHide = gsPCGetCreatureHide(oPC);

  // Batra: Remove legacy Resilience traits if they exist. New ones are added as effects.
  if (nLevel >= 10 && nLevel < 20)
  {
    if (nPact == PACT_FEY)
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_5), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_5), 0.0f);
    }
    else
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_5), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_5), 0.0f);
    }
  }
  else if (nLevel >= 20 && nLevel < 30)
  {
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEIMMUNITY_5_PERCENT), 0.0f);
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEIMMUNITY_5_PERCENT), 0.0f);
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEIMMUNITY_5_PERCENT), 0.0f);

    if (nPact == PACT_FEY)
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_10), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_10), 0.0f);
    }
    else
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_10), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_10), 0.0f);
    }
  }
  else if (nLevel == 30)
  {
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), 0.0f);
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), 0.0f);
    IPSafeAddItemProperty(oHide, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEIMMUNITY_10_PERCENT), 0.0f);

    if (nPact == PACT_FEY)
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGERESIST_20), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_20), 0.0f);
    }
    else
    {
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID,IP_CONST_DAMAGERESIST_20), 0.0f);
      IPSafeAddItemProperty(oHide, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGERESIST_20), 0.0f);
    }
  }

  if (bLevelUp && NWNX_Creature_GetClassByLevel(oPC, nHD) != CLASS_TYPE_BARD) return;

  object oStaff = miWAGetWarlockStaff(oPC);

  if (bLevelUp && GetIsObjectValid(oStaff))
  {
    // Migration code.
    miWAStripStaffAbilities(oStaff);
    miWAApplyAbilities(oPC, FALSE);
    return;
  }

  // Set hit dice to d8
  NWNX_Creature_SetMaxHitPointsByLevel(oPC, nHD, 8);

  if (!bLevelUp)
  {
    // Go through each bard level and adjust its HP.
    int nCount;
    for (nCount == 1; nCount < nHD; nCount++)
    {
      if (NWNX_Creature_GetClassByLevel(oPC, nCount) == CLASS_TYPE_BARD)
      {
        NWNX_Creature_SetMaxHitPointsByLevel(oPC, nCount, 8);
      }
    }
  }



  // Apply Uncanny Dodge resilience trait.
  if (nLevel >= 10 && !GetKnowsFeat(FEAT_UNCANNY_DODGE_1, oPC)) AddKnownFeat(oPC, FEAT_UNCANNY_DODGE_1, GetHitDice(oPC));


  // Remove all 20 bard song feats (one per level up to 20).
  NWNX_Creature_RemoveFeat(oPC, FEAT_BARD_SONGS); // 257
  NWNX_Creature_RemoveFeat(oPC, 355);
  NWNX_Creature_RemoveFeat(oPC, 356);
  NWNX_Creature_RemoveFeat(oPC, 357);
  NWNX_Creature_RemoveFeat(oPC, 358);
  NWNX_Creature_RemoveFeat(oPC, 359);
  NWNX_Creature_RemoveFeat(oPC, 360);
  NWNX_Creature_RemoveFeat(oPC, 361);
  NWNX_Creature_RemoveFeat(oPC, 362);
  NWNX_Creature_RemoveFeat(oPC, 363);
  NWNX_Creature_RemoveFeat(oPC, 364);
  NWNX_Creature_RemoveFeat(oPC, 365);
  NWNX_Creature_RemoveFeat(oPC, 366);
  NWNX_Creature_RemoveFeat(oPC, 367);
  NWNX_Creature_RemoveFeat(oPC, 368);
  NWNX_Creature_RemoveFeat(oPC, 369);
  NWNX_Creature_RemoveFeat(oPC, 370);
  NWNX_Creature_RemoveFeat(oPC, 371);
  NWNX_Creature_RemoveFeat(oPC, 372);
  NWNX_Creature_RemoveFeat(oPC, 373);

  NWNX_Creature_RemoveFeat(oPC, 197); // Bardic knowledge

  miWASetSpells(oPC);
}
//------------------------------------------------------------------------------
void miWATurnIntoWarlock(object oPC, int nPact = PACT_ABYSSAL)
{
  object oHide = gsPCGetCreatureHide(oPC);
  SetLocalInt(oHide, VAR_WARLOCK, nPact);
  miWAApplyAbilities(oPC, FALSE);
}
//------------------------------------------------------------------------------
int miWAGetDamageType(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);
  int nBlastType = GetLocalInt(oHide, VAR_WARLOCK_ELEMENT);
  int nDamageType;

  if (nBlastType == 0)
  {
    if (miWAGetIsWarlock(oPC) == 1 || miWAGetIsWarlock(oPC) == 2)
    {
      nBlastType = WARLOCK_ELEMENT_FIRE;
    }

    if (miWAGetIsWarlock(oPC) == 3)
    {
      nDamageType = WARLOCK_ELEMENT_COLD;
    }
  }

  switch (nBlastType)
  {
    case WARLOCK_ELEMENT_FIRE:
      nDamageType = DAMAGE_TYPE_FIRE;
      break;
    case WARLOCK_ELEMENT_ACID:
      nDamageType = DAMAGE_TYPE_ACID;
      break;
    case WARLOCK_ELEMENT_NEGATIVE:
      nDamageType = DAMAGE_TYPE_NEGATIVE;
      break;
    case WARLOCK_ELEMENT_POSITIVE:
      nDamageType = DAMAGE_TYPE_POSITIVE;
      break;
    case WARLOCK_ELEMENT_COLD:
      nDamageType = DAMAGE_TYPE_COLD;
      break;
    case WARLOCK_ELEMENT_LIGHTNING:
      nDamageType = DAMAGE_TYPE_ELECTRICAL;
      break;
    case WARLOCK_ELEMENT_MAGIC:
      nDamageType = DAMAGE_TYPE_MAGICAL;
      break;
  }

  return nDamageType;
}
//------------------------------------------------------------------------------
int miWAGetBeamVFX(object oPC)
{
  int nDamageType = miWAGetDamageType(oPC);
  int nBeamVFX = VFX_BEAM_ODD;  // VFX_BEAM_MIND?

  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      nBeamVFX = VFX_BEAM_FIRE;
      break;
    case DAMAGE_TYPE_ACID:
      nBeamVFX = VFX_BEAM_DISINTEGRATE;
      break;
    case DAMAGE_TYPE_NEGATIVE:
      nBeamVFX = VFX_BEAM_EVIL;
      break;
    case DAMAGE_TYPE_POSITIVE:
      nBeamVFX = VFX_BEAM_HOLY;
      break;
    case DAMAGE_TYPE_COLD:
      nBeamVFX = VFX_BEAM_COLD;
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      nBeamVFX = VFX_BEAM_LIGHTNING;
      break;
    case DAMAGE_TYPE_MAGICAL:
      nBeamVFX = VFX_BEAM_ODD;
      break;
  }

  return nBeamVFX;
}
//------------------------------------------------------------------------------
int miWAGetImpactVFX(object oPC)
{
  int nDamageType = miWAGetDamageType(oPC);
  int nImpVFX = VFX_IMP_MAGBLUE;

  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      nImpVFX = VFX_IMP_FLAME_M;
      break;
    case DAMAGE_TYPE_ACID:
      nImpVFX = VFX_IMP_ACID_L;
      break;
    case DAMAGE_TYPE_NEGATIVE:
      nImpVFX = VFX_IMP_DOOM;
      break;
    case DAMAGE_TYPE_POSITIVE:
      nImpVFX = VFX_IMP_STUN;
      break;
    case DAMAGE_TYPE_COLD:
      nImpVFX = VFX_IMP_FROST_L;
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      nImpVFX = VFX_IMP_LIGHTNING_S;
      break;
    case DAMAGE_TYPE_MAGICAL:
      nImpVFX = VFX_IMP_MAGBLUE;
      break;
  }

  return nImpVFX;
}
//------------------------------------------------------------------------------
int miWAGetAreaVFX(object oPC)
{
  int nDamageType = miWAGetDamageType(oPC);
  int nBurstVFX = VFX_FNF_MYSTICAL_EXPLOSION;

  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      nBurstVFX = VFX_FNF_FIREBALL;
      break;
    case DAMAGE_TYPE_ACID:
      nBurstVFX = VFX_FNF_HORRID_WILTING;
      break;
    case DAMAGE_TYPE_NEGATIVE:
      nBurstVFX = VFX_FNF_LOS_EVIL_30;
      break;
    case DAMAGE_TYPE_POSITIVE:
      nBurstVFX = VFX_FNF_STRIKE_HOLY;
      break;
    case DAMAGE_TYPE_COLD:
      nBurstVFX = VFX_FNF_ICESTORM;
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      nBurstVFX = VFX_IMP_LIGHTNING_M;
      break;
    case DAMAGE_TYPE_MAGICAL:
      nBurstVFX = VFX_FNF_MYSTICAL_EXPLOSION;
      break;
  }

  return nBurstVFX;
}
//------------------------------------------------------------------------------
int miWAGetCastingVFX(object oPC)
{
  int nDamageType = miWAGetDamageType(oPC);
  int nCasterVFX = VFX_DUR_GLOBE_INVULNERABILITY;

  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      nCasterVFX = VFX_DUR_ELEMENTAL_SHIELD;
      break;
    case DAMAGE_TYPE_ACID:
      nCasterVFX = 448;  // Acid sheath
      break;
    case DAMAGE_TYPE_NEGATIVE:
      nCasterVFX = 496; // Mummy dust red glowy thing.
      break;
    case DAMAGE_TYPE_POSITIVE:
      nCasterVFX = VFX_IMP_DEATH_WARD;
      break;
    case DAMAGE_TYPE_COLD:
      nCasterVFX = VFX_DUR_AURA_PULSE_BLUE_WHITE;
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      nCasterVFX = VFX_DUR_SPELLTURNING;
      break;
    case DAMAGE_TYPE_MAGICAL:
      nCasterVFX = VFX_DUR_GLOBE_INVULNERABILITY;
      break;
  }

  _miWADoGlowingEyes(oPC, nDamageType);

  return nCasterVFX;
}
//------------------------------------------------------------------------------
int miWAGetCasterLevel(object oWarlock)
{
  object oHide = gsPCGetCreatureHide(oWarlock);
  int nCurrentModifier = GetLocalInt(oHide, "MI_WA_BONUS_CASTER_LEVELS");

  return GetLevelByClass(CLASS_TYPE_BARD, oWarlock) + nCurrentModifier;
}
//------------------------------------------------------------------------------
void miWAIncreaseCasterLevel(object oWarlock, int nAmount)
{
  object oHide = gsPCGetCreatureHide(oWarlock);
  int nCurrentModifier = GetLocalInt(oHide, "MI_WA_BONUS_CASTER_LEVELS");

  SetLocalInt(oHide, "MI_WA_BONUS_CASTER_LEVELS", nCurrentModifier + nAmount);
}
//------------------------------------------------------------------------------
int miWAResistSpell(object oCaster, object oTarget)
{
  // No fancy stuff, so just do the check.  This means that mantles and
  // spell immunity don't work against eldritch blast (cf ResistSpell()).
  int nCheck = d20() + miWAGetCasterLevel(oCaster);
  int bSpellPen = GetHasFeat(FEAT_SPELL_PENETRATION, oCaster);
  int bGrSpellPen = GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster);
  int bEpSpellPen = GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster);

  if (bEpSpellPen) nCheck += 6;
  else if (bGrSpellPen) nCheck += 4;
  else if (bSpellPen) nCheck += 2;

  if (nCheck < GetSpellResistance (oTarget))
  {
     SendMessageToPC(oCaster, "Spell resisted!");
     ApplyEffectToObject(DURATION_TYPE_INSTANT,
                         EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE),
                         oTarget);
     return TRUE;
  }

  return FALSE;
}
//------------------------------------------------------------------------------
int miWAArcaneSpellFailure(object oWarlock)
{
  int nASF = GetArcaneSpellFailure(oWarlock);

  if (d100() <= nASF)
  {
    SendMessageToPC(oWarlock, "Casting failed due to Arcane Spell Failure.");
    return TRUE;
  }

  return FALSE;
}
//------------------------------------------------------------------------------
int miWAGetSpellDC(object oWarlock)
{
  int nDC = 10 + (miWAGetCasterLevel(oWarlock) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oWarlock);
  return nDC;
}
//------------------------------------------------------------------------------
void miWASetDamageType(int nDamageType, object oWarlock = OBJECT_SELF)
{
  object oHide = gsPCGetCreatureHide(oWarlock);
  SetLocalInt(oHide, VAR_WARLOCK_ELEMENT, nDamageType);
}
//------------------------------------------------------------------------------
void _miWARemoveGlowingEyes(object oPC)
{
  effect eVFX = GetFirstEffect (oPC);

  while (GetIsEffectValid(eVFX))
  {
    // Hacky but we can't tell exactly what type of VFX we might have.
    if (GetEffectType(eVFX) == EFFECT_TYPE_VISUALEFFECT &&
        GetEffectDurationType(eVFX) == DURATION_TYPE_PERMANENT)
      RemoveEffect(oPC, eVFX);

    eVFX = GetNextEffect(oPC);
  }
}
//------------------------------------------------------------------------------
void _miWADoGlowingEyes(object oPC, int nDamageType)
{
  // This method abuses knowledge of the VFX numbers for the various eyes - see
  // nwscript.css or the 2da.
  _miWARemoveGlowingEyes(oPC);

  int nGenderAdjustment = GetGender(oPC) == GENDER_MALE ? 0 : 1;
  int nAppearanceAdjustment = -1;

  switch (GetAppearanceType(oPC))
  {
    case APPEARANCE_TYPE_DWARF:
      nAppearanceAdjustment = 2;
      break;
    case APPEARANCE_TYPE_ELF:
      nAppearanceAdjustment = 4;
      break;
    case APPEARANCE_TYPE_GNOME:
      nAppearanceAdjustment = 6;
      break;
    case APPEARANCE_TYPE_HALF_ELF:
      nAppearanceAdjustment = 0;
      break;
    case APPEARANCE_TYPE_HALF_ORC:
      nAppearanceAdjustment = 10;
      break;
    case APPEARANCE_TYPE_HALFLING:
      nAppearanceAdjustment = 8;
      break;
    case APPEARANCE_TYPE_HUMAN:
      nAppearanceAdjustment = 0;
      break;
    default:
      break;
  }

  // Monster races can't have glowing eyes :(
  if (nAppearanceAdjustment == -1) return;

  int nVFXNumber = 580; // Purple, for magical
  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      nVFXNumber = 360; // Flame
      break;
    case DAMAGE_TYPE_ACID:
      nVFXNumber = 567; // Green
      break;
    case DAMAGE_TYPE_NEGATIVE:
      nVFXNumber = 386; // Orange, since red isn't an option :(
      break;
    case DAMAGE_TYPE_POSITIVE:
      nVFXNumber = 373; // Yellow
      break;
    case DAMAGE_TYPE_COLD:
      nVFXNumber = 593; // Cyan
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      nVFXNumber = 606; // White
      break;
  }

  ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectVisualEffect(nVFXNumber + nAppearanceAdjustment + nGenderAdjustment),
                      oPC, 0.0, EFFECT_TAG_CONSOLE_COMMAND_DISPELLABLE);
}
//------------------------------------------------------------------------------
void miWADoStatusEffect(int nDamageType, object oTarget, object oWarlock = OBJECT_SELF, int bFriendly = FALSE)
{
  int nDC = miWAGetSpellDC(oWarlock);

  int nCasterLevel = miWAGetCasterLevel(oWarlock);
  //Do not do anything if less than 16 levels or the damage type is magickal.
  //Cold and fire start at level 16.
  if (nCasterLevel < 16 || nDamageType == DAMAGE_TYPE_MAGICAL) return;
  //Do not procede with any damage type other than fire and cold until level 20
  //Acid and Lightening start at level 20.
  else if (nCasterLevel < 20 && nDamageType != DAMAGE_TYPE_FIRE && nDamageType != DAMAGE_TYPE_COLD) return;
  //Do not procede with less than 24 levels AND the energy type is either posibive or negative
  //Positive and Negative start at 24.
  else if (nCasterLevel < 24 && (nDamageType == DAMAGE_TYPE_POSITIVE || nDamageType == DAMAGE_TYPE_NEGATIVE)) return;

  if (!bFriendly)
  {
    if (nDamageType == DAMAGE_TYPE_POSITIVE) return; // no effect yet
    // Fortitude save against effects.
    if (gsSPSavingThrow(oWarlock, oTarget, SPELL_ELDRITCH_BLAST, miWAGetSpellDC(oWarlock), SAVING_THROW_FORT))
    {
      return;
    }
  }

  switch (nDamageType)
  {
    case DAMAGE_TYPE_FIRE:
      if (!bFriendly)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectBlindness(),
                            oTarget,
                            6.0);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_DAZED_S),
                            oTarget);
      break;
    case DAMAGE_TYPE_ACID:
      if (!bFriendly)
       ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            EffectAbilityDecrease(ABILITY_CONSTITUTION, 1),
                            oTarget);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_POISON_S),
                            oTarget);
      break;
    case DAMAGE_TYPE_NEGATIVE:
      if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && bFriendly)
      {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectHeal(d6(nCasterLevel + 1) / 2),
                            oTarget);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_HEALING_L),
                            oTarget);
      }
      else if (!bFriendly)
      {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                            EffectNegativeLevel(d3()),
                            oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY),
                            oTarget);
      }
      break;
    case DAMAGE_TYPE_POSITIVE:
      if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && bFriendly)
      {
        int nHeal = d6(3);

        if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
        {
          // FL override - heal 1d6 not 3d6 since we have high resistances.
          nHeal = d6(1);
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectHeal(nHeal),
                            oTarget);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_HEALING_L),
                            oTarget);
      }
      break;
    case DAMAGE_TYPE_COLD:
      if (!bFriendly)
      {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectSlow(),
                            oTarget,
                            6.0);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_SLOW),
                            oTarget);
      }
      break;
    case DAMAGE_TYPE_ELECTRICAL:
      if (!bFriendly)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectDazed(),
                            oTarget,
                            6.0);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_IMP_DAZED_S),
                            oTarget);
      break;
  }
}
//------------------------------------------------------------------------------
int miWADoWarlockAttack(object oCaster, object oTarget, int nSpellID, int bDoSRForNonWarlocks = TRUE)
{
    if (!miWAGetIsWarlock(oCaster) || GetIsObjectValid(GetSpellCastItem()))
    {
      if(!bDoSRForNonWarlocks)
        return TRUE;
      return !gsSPResistSpell(oCaster, oTarget, nSpellID);
    }
    else
    {
        int nCasterLevel = miWAGetCasterLevel(oCaster);
        // Peppermint, 1-30-2016; Damage adjusted to (1d6 + 1) / 2 Levels
        int nDam = d6 (nCasterLevel / 2) + nCasterLevel / 2;

        if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nCasterLevel > 9)
        {
            // FL override - damage goes up by 1 not 1d4 every level.
            nDam = d4(9) + (nCasterLevel - 4);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectVisualEffect(miWAGetCastingVFX(oCaster)),
                            oCaster, 1.7);

        // Roll to hit.
        if (!TouchAttackRanged(oTarget))
        {
          // Miss! Lasers pew pew (Flare spell only).
          if (nSpellID == 416)
          {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                              EffectBeam(miWAGetBeamVFX(oCaster), oCaster, BODY_NODE_HAND, TRUE),
                              oTarget, 1.7);
          }
          return FALSE;
        }

        if(miWAResistSpell(oCaster, oTarget))
        {
          return FALSE;
        }

        // Batra: Dispels, Holds, Fear, Confusion spells deal marginal damage. Other spells are normal.
        // Damage adjusted to (1d6) / 10 levels.
        if (nSpellID == 8 || nSpellID == 26 || nSpellID == 40 || nSpellID == 41 || 
            nSpellID == 45 || nSpellID == 54 || nSpellID == 67 || nSpellID == 82 ||
            nSpellID == 83 || nSpellID == 94)
        {
          nDam = d3 (nCasterLevel / 3);
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectDamage(nDam, miWAGetDamageType(oCaster)),
                            oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(miWAGetImpactVFX(oCaster)),
                            oTarget);
        // Lasers pew pew (Flare spell only).
        if (nSpellID == 416)
        {
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectBeam(miWAGetBeamVFX(oCaster), oCaster, BODY_NODE_HAND),
                        oTarget, 1.7);
        }

      return TRUE;
    }
}
