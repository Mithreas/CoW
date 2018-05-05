// CLASS library by Mithreas.
#include "inc_external"
#include "inc_iprop"
#include "inc_subrace"
#include "inc_effect"
#include "inc_generic"
#include "inc_item"
#include "inc_levelbonuses"
#include "inc_sumstream"
#include "inc_log"
#include "inc_favsoul"
#include "inc_rogue"
#include "inc_warlock"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x0_i0_match"
#include "inc_healer"
#include "inc_spellsword"

const string CLASSES = "CLASSES"; // for logging

// Applies changes to a character's sheet based on their class selection
// (e.g. no HIPS for shadowdancers)
void miCLApplyClassChanges(object oPC);
// Applies changes to a character's sheet based on their path selection
// (e.g. haste for kensai).  Only needed for subraced PCs.
void miCLApplyPathChanges(object oPC, int bReapplySpecialAbilities, int bUpdateNaturalAC = FALSE);
// Overrides PRC restrictions if appropriate.
void miCLOverridePRC(object oPC);
// Returns TRUE if oPC can cast arcane spells.
int miCLGetHasArcaneSpellCasting(object oPC);
// checks if a character is now illegal (no longer meets RPR requirements for
// their class or race).  If so, they will be put into 'lockdown' and warned
// that they cannot play that character.
//
// Now enhanced to perform CD key checking too.
void miCLCheckIsIllegal(object oPC);
// Fighter bonus: enhance weapons and armor they wear.
void miCLApplyFighterBonuses(object oItem, object oPC);
// Fighter bonus: remove bonuses on unequip from weapons and armor they wear.
void miRemoveFighterBonuses(object oItem);
//Converts Class Intenger into it's Bit value. Currently used in the crafting scripts.
int mdConvertClassToBit(int nClass, object oPC=OBJECT_INVALID);
//Gets the class name from CLASS_TYPE*
string mdGetClassName(int nClass);
//Gets the path name from the MD_BIT_* value. Only works for Warlock and Favoured Soul currently.
string mdGetPathName(int nPathBit);

// gets the classname of oPC for iClassPosition, taking all Arelith subclasses into account
string gvd_GetArelithClassNameByPosition(int iClassPosition, object oPC);
// updates the gs_pc_data table in the database with the classnames (arelith) and levels of oPC
void gvd_UpdateArelithClassesInDB(object oPC);

// Returns the bonus that the item's possessor would gain from his fighter levels for
// the specified item.
int GetFighterEnhancementBonus(object oItem);

// Returns TRUE if the PC has the healer path.
int GetIsHealer(object oPC);
// Returns TRUE if the PC has the kensai path.
int GetIsKensai(object oPC);
// Returns TRUE if the PC has the archer path.
int GetIsArcher(object oPC);
// Returns TRUE if the PC has the sniper path.
int GetIsSniper(object oPC);
// Returns TRUE if the PC is a true flame.
int GetIsTrueFlame(object oPC);
// Returns TRUE if the PC is a weavemaster.
int GetIsWeavemaster(object oPC);
// Returns TRUE if the PC is a (new style) favoured soul.
int GetIsFavouredSoul(object oPC);
// Returns TRUE if the PC is a Shadow Mage.
int GetIsShadowMage(object oPC);

// Applies ranger weapon bonuses (e.g. AC for dual-wielding).
void ApplyRangerWeaponBonuses(object oPC, int bFeedback);
// Removes dual wield feats from rangers.
void RemoveRangerDualWieldFeats(object oPC);
// Grants Woodland Stride at level 7, Evasion at level 9.
void AddRangerFeats(object oPC);
// Assassins get Evasion at level 6, Defensive Roll at level 11, and Improved Evasion at level 14.
void AddAssassinFeats(object oPC);
// Grants HiPS to Shadow Mages at mage level 20.
void AddShadowMageFeats(object oPC);
// Grants Rapid Shot, Point Blank Shot, and Called Shot to sniper path rangers. Also
// responsible for migrating old snipers, which instead received the Mobility feat.
void AddSniperFeats(object oPC);
// Updates HiPS for rangers (i.e. applied in natural areas, not in artifical areas).
void UpdateRangerHiPS(object oPC);
// Grants innate spells to PCs that have the appropriate greater spell focuses.
// Intended for mages.
void AddSpellFocusBonusSpells(object oPC, int nClass);

//Adds race options to zdlg, nBit is the currently saved bit
void md_SetUpRaceList(string sPage, int nBit, object oHolder = OBJECT_SELF);
//On selection for race options for zdlg
int md_GetRaceSelection(int selection);
//Adds class options to zdlg, nBit is the currently saved bit
void md_SetUpClassList(string sPage, int nBit, object oHolder = OBJECT_SELF, int nIgnoreHarper = TRUE);
//On selection for class options for zdlg
int md_GetClassSelection(int selection, int nIgnoreHarper = TRUE);

// Constants - variable names for allowing PRCs.
 // NB - to ENABLE a class, set the var to the value in the 2da file (default 0,
// 1 for FL).
const string ARCANE_ARCHER = "X1_AllowArcher";
const string ASSASSIN = "X1_AllowAsasin";
const string BLACKGUARD = "X1_AllowBlkGrd";
const string CHAMP_TORM = "X2_AllowDivcha";
const string DRAG_DISC = "X1_AllowDrDis";
const string DWARF_DEF = "X1_AllowDwDef";
const string HARPER_SCOUT = "X1_AllowHarper";
const string PALE_MASTER = "X2_AllowPalema";
const string SHADOW_DANCER = "X1_AllowShadow";
const string SHIFT = "X2_AllowShiftr";
const string WPN_MASTER = "X2_AllowWM";

//Adding class bits here. Makes sense - Mord
const int MD_BIT_BARB          = 0x01;
const int MD_BIT_BARD          = 0x02;
const int MD_BIT_CLERIC        = 0x04;
const int MD_BIT_DRUID         = 0x08;
const int MD_BIT_FIGHT         = 0x10;
const int MD_BIT_MONK          = 0x20;
const int MD_BIT_PALADIN       = 0x40;
const int MD_BIT_RANGER        = 0x80;
const int MD_BIT_ROGUE         = 0x100;
const int MD_BIT_SORC          = 0x200;
const int MD_BIT_WIZARD        = 0x400;
const int MD_BIT_ARCHER        = 0x800;
const int MD_BIT_ASSASSIN      = 0x1000;
const int MD_BIT_CHAMPION      = 0x2000;
const int MD_BIT_DRAG_DISCIPLE = 0x4000;
const int MD_BIT_DEFENDER      = 0x8000;
const int MD_BIT_BLACKGUARD    = 0x10000;
const int MD_BIT_HARPER        = 0x20000;
const int MD_BIT_PALEMASTER    = 0x40000;
const int MD_BIT_SHIFTER       = 0x80000;
const int MD_BIT_WEAPONMASTER  = 0x100000;
const int MD_BIT_SHADOWDANCER  = 0x200000;
const int MD_BIT_PDK           = 0x1000000;
//And a few paths
const int MD_BIT_WARLOCK       = 0x400000;
const int MD_BIT_FAVSOUL       = 0x800000;
//groups
const int MD_BIT_ARCANE        = 0x444E02;
const int MD_BIT_CLERGY        = 0x812044;
const int MD_BIT_NATURE        = 0x80088;
const int MD_BIT_DIVINE        = 0x8920CC;
const int MD_BIT_WARRIOR       = 0x111A8F1;
const int MD_BIT_THIEF         = 0x201102;

// Harper paths.
const int MI_CL_HARPER_SCOUT   = 0;
const int MI_CL_HARPER_MAGE    = 1;
const int MI_CL_HARPER_PRIEST  = 2;
const int MI_CL_HARPER_PARAGON = 3;
const int MI_CL_HARPER_MASTER  = 4;
const string VAR_HARPER        = "MI_CL_HARPER_PATH";

// PDK paths.
const int MI_CL_PDK_VANGUARD  = 1;
const int MI_CL_PDK_PROTECTOR = 2;
const int MI_CL_PDK_VALIANT   = 3;
const string VAR_PDK          = "MI_CL_PDK_PATH";

// Paths
const string PATH_OF_WARLOCK = "Path of the Warlock";
const string PATH_OF_THE_HEALER = "Path of the Healer";
const string PATH_OF_TOTEM = "Path of the Totem";
const string PATH_OF_THE_KENSAI = "Path of the Kensai";
const string PATH_OF_TRUE_FIRE = "Path of True Fire";
const string PATH_OF_THE_ARCHER = "Path of the Archer";
const string PATH_OF_THE_SNIPER = "Path of the Sniper";
const string PATH_OF_THE_TRIBESMAN = "Path of the Tribesman";
const string PATH_OF_WEAVE_MASTERY = "Path of Weave Mastery";
const string PATH_OF_FAVORED_SOUL = "Favored Soul"; // Old style, bard based
const string PATH_OF_FAVOURED_SOUL = "Favoured Soul"; // New style, cleric based
const string PATH_OF_SHADOW = "Shadow (Weave) Mage";
const string PATH_OF_WILD_MAGE = "Wild Mage";
const string PATH_OF_SPELLSWORD = "Spellsword";
const string PATH_NONE = "No path.";

// Spells granted to mages as spell focus bonuses.
const int GSF_SPELL_ABJURATION =    SPELL_ENDURE_ELEMENTS;
const int GSF_SPELL_CONJURATION =   SPELL_MELFS_ACID_ARROW;
const int GSF_SPELL_DIVINATION =    SPELL_SEE_INVISIBILITY;
const int GSF_SPELL_ENCHANTMENT =   SPELL_BLINDNESS_AND_DEAFNESS;
const int GSF_SPELL_EVOCATION =     SPELL_MAGIC_MISSILE;
const int GSF_SPELL_ILLUSION =      SPELL_COLOR_SPRAY;
const int GSF_SPELL_NECROMANCY =    SPELL_RAY_OF_ENFEEBLEMENT;
const int GSF_SPELL_TRANSMUTATION = SPELL_BURNING_HANDS;

const float FIGHTER_ENHANCEMENT_DURATION = 72000.0f; // 30 hours

const int KENSAI_MOVE_SPEED_PENALTY = 0;

void _addFeatIfNotKnown(int nFeat, object oPC, int Level = 1)
{
  if (GetKnowsFeat(nFeat, oPC)) return;
  AddKnownFeat(oPC, nFeat, Level);
}

int miCLGetHasArcaneSpellCasting(object oPC)
{
    return ( GetLevelByClass(CLASS_TYPE_BARD,oPC) ||
             GetLevelByClass(CLASS_TYPE_WIZARD,oPC) ||
             GetLevelByClass(CLASS_TYPE_SORCERER,oPC) );
}


void miCLApplyClassChanges(object oPC)
{
  Trace(CLASSES, "Applying class changes for " + GetName(oPC));

  object oItem = gsPCGetCreatureHide(oPC);

  Trace(CLASSES, "Tried to get creature armour item: " + (GetIsObjectValid(oItem) ? "SUCCESS" : "FAILURE"));

  if (!GetIsObjectValid(oItem))
  {
    oItem = CreateItemOnObject(GS_SU_TEMPLATE_PROPERTY, oPC);

    if (GetIsObjectValid(oItem))
    {
      AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CARMOUR));
    }
  }

  int nClass;

  for (nClass = 1; nClass <= 3; nClass ++) // Apply changes for each class.
  {
    int nClassType  = GetClassByPosition(nClass, oPC);
    Trace(CLASSES, "Got class " + IntToString(nClassType) + " in position " + IntToString(nClass));
    switch (nClassType)
    {
      case CLASS_TYPE_SHADOWDANCER:
        // Shadowdancers get HiPS at level 5.
        if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) < 5)
        {
          NWNX_Creature_RemoveFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT);
        }
        else
        {
          AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(OBJECT_SELF, CLASS_TYPE_SHADOWDANCER, 5));
        }

        gsIPStackSkill(
          oItem,
          SKILL_HIDE,
          GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC)
        );
        break;
      case CLASS_TYPE_DRAGONDISCIPLE:
      {
        AddKnownSummonStream(oPC, STREAM_TYPE_DRAGON, STREAM_DRAGON_RED);
        if (GetLevelByClass(nClassType, oPC) == 9)
        {
          miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "wings", "4");
        }
        break;
      }
      case CLASS_TYPE_DRUID:
      {
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_I, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_II, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_III, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_IV, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_V, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_VI, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_VII, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_VIII, CLASS_TYPE_DRUID);
        AddSpontaneousSpell(oPC, SPELL_SUMMON_CREATURE_IX, CLASS_TYPE_DRUID);
        break;
      }
      case CLASS_TYPE_PALEMASTER:
      {
        UpdateLevelBonuses(oPC, CLASS_TYPE_PALEMASTER, "pmdracolich");
        if (GetLevelByClass(nClassType, oPC) == 6)
        {
          miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "bone_arm", "1");
        }
        break;
      }
      case CLASS_TYPE_BARD:
      {
        // Check for Warlocks.
        if (miWAGetIsWarlock(oPC))
        {
          // Remove bard song and add Warlock class abilities.
          miWAApplyAbilities(oPC);
        }

        // Favored Souls.
        if (miFSGetIsFavoredSoul(oPC))
        {
          miFSApplyFavoredSoul(oPC);
        }
        break;
      }
      case CLASS_TYPE_HARPER:
      {
        int nHarperType  = GetLocalInt(oItem, VAR_HARPER);
        int nHarperLevel = GetLevelByClass(CLASS_TYPE_HARPER, oPC);

        // Remove feats no longer used - Sleep, Invisibility
        NWNX_Creature_RemoveFeat(oPC, 438); // TYMORAS_SMILE
        NWNX_Creature_RemoveFeat(oPC, 441); // HARPER_SLEEP
        NWNX_Creature_RemoveFeat(oPC, 444); // HARPER_INVISIBILITY

        // Remove feats only used by scouts
        if (nHarperType)
        {
          NWNX_Creature_RemoveFeat(oPC, 437); // DENEIRS_EYE
          NWNX_Creature_RemoveFeat(oPC, 439); // LLIIRAS_HEART
          NWNX_Creature_RemoveFeat(oPC, 440); // CRAFT_HARPER_ITEM
          NWNX_Creature_RemoveFeat(oPC, 442); // HARPER_CATS_GRACE
          NWNX_Creature_RemoveFeat(oPC, 443); // HARPER_EAGLES_SPLENDOR
          if (! GetRacialType(oPC) == RACIAL_TYPE_HALFLING)
            NWNX_Creature_RemoveFeat(oPC, 248); // Lucky
          NWNX_Creature_RemoveFeat(oPC, 382); // Luck of Heroes
        }

        switch (nHarperType)
        {
          case MI_CL_HARPER_SCOUT:
            if (nHarperLevel >= 2)
              _addFeatIfNotKnown(915, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 2)); // Skill Focus: Bluff
            if (nHarperLevel >= 3)
              _addFeatIfNotKnown(248, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 3)); // Lucky
            if (nHarperLevel >= 3)
              _addFeatIfNotKnown(382, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 3)); // Luck Of Heroes
            if (nHarperLevel >= 4)
              _addFeatIfNotKnown(917, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 4)); // Epic Skill Focus: Bluff
            break;
          case MI_CL_HARPER_MAGE:
            if (nHarperLevel >= 2)
              _addFeatIfNotKnown(189, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 2)); // Skill Focus: Spellcraft
            if (nHarperLevel >= 3)
              _addFeatIfNotKnown(857, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 3)); // Auto Quicken I
            break;
          case MI_CL_HARPER_PRIEST:
            // No feats - all boons are hooked into other scripts.
            break;
          case MI_CL_HARPER_PARAGON:
            // Remove harper knowledge unless this is a regular bard
            if (! (GetLevelByClass(CLASS_TYPE_BARD, oPC) &&
                   !miWAGetIsWarlock(oPC) &&
                   !miFSGetIsFavoredSoul(oPC)))
              NWNX_Creature_RemoveFeat(oPC, 197); // BardicKnowledge

            if (nHarperLevel >= 3)
              _addFeatIfNotKnown(217, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 3)); // Divine Grace
            if (nHarperLevel >= 4)
              _addFeatIfNotKnown(294, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 4)); // Turn Undead
            if (nHarperLevel >= 4)
              _addFeatIfNotKnown(414, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 4)); // Divine Shield
            if (nHarperLevel >= 5)
              _addFeatIfNotKnown(413, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 5)); // Divine Might
            break;
          case MI_CL_HARPER_MASTER:
            if (nHarperLevel >= 3)
              _addFeatIfNotKnown(180, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 3)); // Skill Focus Lore
            if (nHarperLevel >= 4)
              _addFeatIfNotKnown(596, oPC, GetLevelByClassLevel(oPC, CLASS_TYPE_HARPER, 4)); // Epic Skill Focus: Lore
            break;
        }
        break;
      }
      case CLASS_TYPE_FIGHTER:
      {
          // Fighters gain the following benefits:
          // * + 10 Discipline at level 28.
          // * + 1 Strength / 10 Levels
          // Note: the fighter's strength bonus will be replaced with a dexterity bonus if they have a higher base dexterity value than strength.
        int nAbility = (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) > GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)) ? ABILITY_DEXTERITY : ABILITY_STRENGTH;
        int nFighterLevel = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
        if (nFighterLevel >= 28)
        {
            AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(SKILL_DISCIPLINE, 10), oItem, 0.0f);
            AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(nAbility, 3), oItem, 0.0f);
        }
        else
        {
            if(nFighterLevel >= 10)
            {
                AddStackingItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(nAbility, nFighterLevel / 10), oItem, 0.0f);
            }
        }
        break;
      }
      case CLASS_TYPE_RANGER:
      {
          UpdateLevelBonuses(oPC, CLASS_TYPE_ANY, "rangerskills");
          AddRangerFeats(oPC);
          UpdateRangerHiPS(oPC);
          break;
      }
      case CLASS_TYPE_SORCERER:
      case CLASS_TYPE_WIZARD:
          if(!GetIsWeavemaster(oPC) && !GetIsTrueFlame(oPC))
          {
            if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0
                            && GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0
                            && nClassType == CLASS_TYPE_SORCERER                )

                        {
                                // do nothing - this is to prevent the bonus spells being added twice if you are mage/sorc dual class.
                        }
                     else
                        {
                            AddSpellFocusBonusSpells(oPC, nClassType);
                        }
          }
          //::Kirito-Spellsword path
          if(miSSGetIsSpellsword(oPC))
          {
            miSSApplyBonuses(oPC, TRUE);
          }
          break;
      case CLASS_TYPE_ASSASSIN:
      {
          UpdateLevelBonuses(oPC, CLASS_TYPE_ANY, "assassinskil");
          AddAssassinFeats(oPC);
          break;
      }
      case CLASS_TYPE_ROGUE:
      {
          RogueBonusHP(oPC, TRUE);
          RogueSkillBonus(oPC);
          RogueFeatBonus(oPC);
          RogueUpdateLightArmorAC(oPC);
          break;
      }
	  
      default:
        break;
    }
  }
}

void miCLApplyPathChanges(object oPC, int bReapplySpecialAbilities, int bUpdateNaturalAC = FALSE)
{
   object oItem = gsPCGetCreatureHide(oPC);
   object oAbility = GetItemPossessedBy(oPC, "GS_SU_ABILITY");
   int nTotem = GetLocalInt(oItem, MI_TOTEM);

   if (GetLocalInt(oItem, "KENSAI"))
   {
        /* Septire - Removed, doesn't seem to apply on level up.
        AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyFreeAction(),
                        oItem);
        */

        // Kensai Freedom removed completely.
        // effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
        // effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        // effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
        // effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

        //Link effects
        // effect eLink = EffectLinkEffects(eParal, eEntangle);
        // eLink = EffectLinkEffects(eLink, eSlow);
        // eLink = EffectLinkEffects(eLink, eMove);
		
		// 3/9/2018 - Removing Listen/Spot bonus as part of the kensai phase-out.
        // Give them +10 Listen and spot
		/*
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_LISTEN, 10),
                        oItem);
        AddStackingItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertySkillBonus(SKILL_SPOT, 10),
                        oItem);
		*/

    //Give them one extra attack and +2 natural AC
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectModifyAttacks(1)), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
    //ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
    if(bUpdateNaturalAC) NWNX_Creature_SetBaseAC(oPC, GetACNaturalBase(oPC) + 2);

	// 3/9/2018 - Removing Saving throw bonus as part of the kensai phase-out.
	/*
    if(GetHitDice(oPC) >= 5)
    {
        ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, GetHitDice(oPC) / 5, SAVING_THROW_TYPE_SPELL)),
            oPC, 0.0, EFFECT_TAG_CHARACTER_BONUS);
    }
    */
   }

   if (GetLocalInt(oItem, "ARCHER"))
   {
        if (bReapplySpecialAbilities) AddItemProperty(DURATION_TYPE_PERMANENT,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
                                              IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY),
                        oAbility);
        RemoveRangerDualWieldFeats(oPC);
   }

   if (GetLocalInt(oItem, "HEALER"))
   {
        SetOverhealLimit(oPC, GetLevelByClass(CLASS_TYPE_CLERIC, oPC) * 5, CLASS_TYPE_CLERIC);
        AddSpontaneousSpell(oPC, SPELL_HEALING_CIRCLE, CLASS_TYPE_CLERIC);
        AddSpontaneousSpell(oPC, SPELL_HEAL, CLASS_TYPE_CLERIC);
        AddSpontaneousSpell(oPC, SPELL_MASS_HEAL, CLASS_TYPE_CLERIC);
   }

   if(GetIsSniper(oPC))
   {
        RemoveRangerDualWieldFeats(oPC);
        AddSniperFeats(oPC);
   }
   
   if (GetIsFavouredSoul(oPC))
   {
     // Reflex saving throw bonus - Reflex is a favoured save for favoured souls.
	 int nBonus = 2;
	 int nLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
	 
	 switch (nLevel)
	 {
	   case 1:
	   case 3:
	     break;
	   case 2:
	   case 4:
	   case 5:
	   case 6:
	   case 7:
	   case 9:
	     nBonus = 3;
		 break;
	   case 8:
	   case 10:
	   case 11:
	   case 12:
	   case 13:
	   case 15:
	     nBonus = 4;
		 break;
	   case 14:
	   case 16:
	   case 17:
	   case 18:
	   case 19:
	     nBonus = 5;
		 break;
	   case 20:
	     nBonus = 6;
		 break;
	 }
	 
	AddItemProperty(DURATION_TYPE_PERMANENT,
	                ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, nBonus),
					oItem);
   }

   if(GetIsShadowMage(oPC))
   {
        AddShadowMageFeats(oPC);
   }

   // Bat totem
   if (nTotem == 8) {
     if (bReapplySpecialAbilities)
       AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_AMPLIFY_5, IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY), oAbility);
   }
 
}

void miCLOverridePRC(object oPC)
{
  // FL has different rules.
  int bFixedLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

  if (bFixedLevel)
  {
    // AA - Elf/halfelf, bab3, weapon focus bow.
    if(GetRacialType(oPC) == RACIAL_TYPE_ELF || GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
    {
      if(GetBaseAttackBonus(oPC) >= 3)
      {
        if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oPC) ||
           GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oPC))
        {
          SetLocalInt(oPC, ARCANE_ARCHER, 0);
        }
      }
    }

    // Assassin - leave unchanged (hide/ms 8).
    // Blackguard - evil, BAB 3.
    if(GetBaseAttackBonus(oPC) >= 3 && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
      SetLocalInt(oPC, BLACKGUARD, 0);
    }

    // Champion of Torm - non evil, BAB 3.
    if(GetBaseAttackBonus(oPC) >= 3 && GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
    {
      SetLocalInt(oPC, CHAMP_TORM, 0);
    }

    // Drag disciple - unchanged (lore 8)
    // Dw def - dwarf, lawful, BAB 3.
    if(GetBaseAttackBonus(oPC) >= 3 && GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
     && GetRacialType(oPC) == RACIAL_TYPE_DWARF)
    {
      SetLocalInt(oPC, DWARF_DEF, 0);
    }

    // Harper - non evil, lore 4, discipline 4
    if(GetSkillRank(SKILL_LORE, oPC, TRUE) >= 4 &&
       GetSkillRank(SKILL_DISCIPLINE, oPC, TRUE) >= 4 &&
       GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
    {
      SetLocalInt(oPC, HARPER_SCOUT, 0);
    }

    // Pale master - leave unchanged
    // shadowdancer - hide/ms 8, tumble 5
    if(GetSkillRank(SKILL_HIDE, oPC, TRUE) >= 8 &&
       GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE) >= 8 &&
       GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5)
    {
      SetLocalInt(oPC, SHADOW_DANCER, 0);
    }
    // Shadowdancer - Shadowmage override.
    else if (GetIsShadowMage(oPC))
    {
      SetLocalInt(oPC, SHADOW_DANCER, 0);
    }
    else
    {
      SetLocalInt(oPC, SHADOW_DANCER, TRUE);
    }

    // shifter - unchanged
    // weapon master - bab 3, dodge, expertise
    if(GetBaseAttackBonus(oPC) >= 3 &&
       GetHasFeat(FEAT_DODGE, oPC) &&
       GetHasFeat(FEAT_MOBILITY, oPC))
    {
      SetLocalInt(oPC, WPN_MASTER, 0);
    }

    return;
  }

  // Override arcane archer settings.
  int bForbidArcaneArcher = TRUE;

  if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) >= 1)
  {
    Trace(CLASSES, "Has CLASS_TYPE_ARCANE_ARCHER");
    bForbidArcaneArcher = FALSE;
  }
  else
  {
    Trace(CLASSES, "CLASS_TYPE_ARCANE_ARCHER");
    //Check to see if the PC has what it takes to be an arcane archer...
    if(GetRacialType(oPC) == RACIAL_TYPE_ELF || GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
    {
      if(GetBaseAttackBonus(oPC) >= 6)
      {
        if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oPC) ||
           GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oPC))
        {
          if(GetHasFeat(FEAT_POINT_BLANK_SHOT, oPC))
          {
            if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 1)
            {
              // OVERRIDE - allow rangers to be AAs without spells.
              bForbidArcaneArcher = FALSE;
            }
            else if (miCLGetHasArcaneSpellCasting(oPC))
            {
              bForbidArcaneArcher = FALSE;
            }
          }
        }
      }
    }
  }

  Trace(CLASSES, "Allow arcane archer for " + GetName(oPC) + "? " +
   (bForbidArcaneArcher ? "No" : "Yes"));
  SetLocalInt(oPC, ARCANE_ARCHER, bForbidArcaneArcher);

  // Forbid shadowdancer unless the PC meets the standard requirements
  // OR are a shadowmage.
  if(GetSkillRank(SKILL_HIDE, oPC, TRUE) >= 10 &&
     GetSkillRank(SKILL_MOVE_SILENTLY, oPC, TRUE) >= 8 &&
     GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5 &&
     GetKnowsFeat(FEAT_DODGE, oPC) &&
     GetKnowsFeat(FEAT_MOBILITY, oPC))
  {
    SetLocalInt(oPC, SHADOW_DANCER, 0);
  }
  else if (GetIsShadowMage(oPC))
  {
    SetLocalInt(oPC, SHADOW_DANCER, 0);
  }
  else
  {
    SetLocalInt(oPC, SHADOW_DANCER, TRUE);
  }

}

void __miCLBootDeniedPC(string sPlayerName, string sName)
{
  fbEXRuby("Bic.remove(?, ?)", sPlayerName, sName);
}

void _miCLBootDeniedPC(object oPC)
{
  // New PC? Delete 'em.
  if (GetXP(oPC) == 0)
  {
    // delete and boot
    NWNX_Administration_DeletePlayerCharacter(oPC);
  
  } else {
    // "CD Key Authentication Denied" message.
    BootPC(oPC, "CD Key or Player Name mismatch. Please attempt logging in with the same Player Name you created the character with.");

  }
  
}

void miCLCheckIsIllegal(object oPC)
{
  // Check for player legality.  This code exists so that we can live without
  // the master server without players being able to hijack each other's
  // accounts.
 
  // Dunshine: 
  // Updated for EE situation where cdkey's are autorised by Beamdog, both old and new, and the servervault is tied to the cdkey, not the playernames anymore,
  // so we no longer have to worry about characters being hijacked
  // But we will still enforce player uniqueness for Arelith, player X can never use another players playername
 
  // Since the servervault is based on cdkey in the new situation, players can always see all their characters, regardless of which playername they login with
  // Therefor we will allow players to play any of their characters with any of their playernames as well.
  
  // So the only thing that we need to check if that the playername is tied to the cdkey in gs_account_data
  // If not, we first check if it's an entirely new unique playername, which is fine and then should be linked to the cdkey in gs_account_data
  // If not, then we should check if the playername is tied to the PC that is being played, if this is the case, this means it's a 1.69 playername that is still tied to the old 1.69 cdkey
  // In that case, we update the playername - cdkey combination in gs_account_data, so all PCs tied to that playername are now also linked to the EE cdkey
    
  string sPlayerName = GetPCPlayerName(oPC);
  string sCDKey = GetPCPublicCDKey(oPC);
  string sCDKeyID = gsPCGetCDKeyID(sCDKey);

  // get the cdkey id for this playername from the database (if any)
  SQLExecStatement("SELECT cdkey_id FROM gs_account_data WHERE (playername=?)", sPlayerName);

  if (SQLFetch()) {
    // playername found, does the cdkey match?
	if (sCDKeyID == SQLGetData(1)) {
	  // playername - cdkey combination is valid, all good
	  
    } else {
      // playername exists, but cdkey doesn't match, check if this PC is linked to the same playername in the database (done for legacy 1.69 playername/characters)
      
	  // get the PC ID (if any), do not use gsPCGetPlayerID() for this, since that will create a new PC record as well, and we're not sure yet if the playername is allowed
	  string sPCID = GetLocalString(gsPCGetCreatureHide(oPC), "GS_PC_ID");
	  
	  // retrieve playername registered to this PC ID
	  SQLExecStatement("SELECT playername, cdkey FROM gs_pc_data INNER JOIN gs_player_data ON (gs_pc_data.keydata = gs_player_data.id) WHERE (gs_pc_data.id=?)", sPCID);
	  
      if (SQLFetch()) {
	    // playername the same as the one logged in?
		if (sPlayerName == SQLGetData(1)) {
		  // yes, so this must be the players character, but the playername was never used on EE before, and the playername is still linked to the old cdkey in the database. 
		  // all good, link playername to the new cdkey now
          SQLExecStatement("UPDATE gs_account_data SET cdkey_id=? WHERE (playername=?)", sCDKeyID, sPlayerName); 

          // also link all PCs for this playername to the new cdkey (this matches nicely with Beamdogs migration of all bic files for the playername to the new cdkey based servervault)
          SQLExecStatement("UPDATE gs_pc_data SET keydata=?, modified=modified WHERE (playername=?)", sCDKeyID, sPlayerName); 		  
		  
		  // this is a good place to check if this is an existing 1.69 player who is logging into EE for the first time, 
		  // in that case we will transfer their RPR and Awards to the new cdkey
		  string sCDKey169 = SQLGetData(2);
		  
		  // check if old cdkey169 is not logged for this new cdkey
		  SQLExecStatement("SELECT id FROM gs_player_data WHERE (id=?) and (cdkey169 IS NULL)", sCDKeyID);
          if (SQLFetch()) {
		    // link not made between old and new key, so link it now, and then transfer all playerdata like awards and RPR
			SQLExecStatement("UPDATE gs_player_data SET cdkey169 = ? WHERE (id=?)", sCDKey169, sCDKeyID);
            SQLExecStatement("UPDATE gs_player_data new INNER JOIN gs_player_data old ON (new.cdkey169 = old.cdkey) SET new.rp = old.rp, new.tells = old.tells, new.award1 = old.award1, new.award1_5 = old.award1_5, new.award2 = old.award2, new.award3 = old.award3, new.lastvote = old.lastvote WHERE (new.id = ?)", sCDKeyID);
		  }
		  
		} else {
          // nope, this means the playername is already in use/claimed by another person, so inform the player and boot
          _miCLBootDeniedPC(oPC);		  
        }		
	  } else {
	    // no PCID yet, so must be a new PC, since the playername is already in use by someone else, we'll not allow the PC to be created and inform the player and boot
        _miCLBootDeniedPC(oPC);		  
	  }
  	  
	}
	
  } else {
    // playername not found, so this must be a new unique playername, all good, create a link for it to the cdkey
    SQLExecStatement("INSERT INTO gs_account_data (playername, cdkey_id) VALUES (?, ?)", sPlayerName, sCDKeyID);
  }
  
}

void miCLApplyFighterBonuses(object oItem, object oPC)
{
  int nBonus = GetFighterEnhancementBonus(oItem);

  if(!nBonus || !GetIsObjectValid(oItem) || !GetIsPC(oPC) || GetIsDM(oPC)) return;

  switch(GetEquipmentType(oItem))
  {
      case EQUIPMENT_TYPE_HELMET:
      case EQUIPMENT_TYPE_ARMOR:
      case EQUIPMENT_TYPE_SHIELD:
          AddStackingItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonus(nBonus), oItem, FIGHTER_ENHANCEMENT_DURATION);
          break;
      case EQUIPMENT_TYPE_WEAPON:
          AddStackingItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nBonus), oItem, FIGHTER_ENHANCEMENT_DURATION);
      case EQUIPMENT_TYPE_AMMUNITION:
          AddStackingItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(GetMatchingIPDamageType(oItem), nBonus), oItem, FIGHTER_ENHANCEMENT_DURATION);
          break;
    }
}

void miRemoveFighterBonuses(object oItem)
{
  int nBonus = GetFighterEnhancementBonus(oItem);

  if(!nBonus || !GetIsObjectValid(oItem) || !GetIsPC(GetItemPossessor(oItem)) || GetIsDM(GetItemPossessor(oItem))) return;

  switch(GetEquipmentType(oItem))
  {
      case EQUIPMENT_TYPE_HELMET:
      case EQUIPMENT_TYPE_ARMOR:
      case EQUIPMENT_TYPE_SHIELD:
          RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_AC_BONUS, DURATION_TYPE_TEMPORARY, ITEM_PROPERTY_SUBTYPE_UNDEFINED,
            GetItemPropertyStackedValue(oItem, ItemPropertyACBonus(nBonus)));
          break;
      case EQUIPMENT_TYPE_WEAPON:
          RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ATTACK_BONUS, DURATION_TYPE_TEMPORARY, ITEM_PROPERTY_SUBTYPE_UNDEFINED,
            GetItemPropertyStackedValue(oItem, ItemPropertyAttackBonus(nBonus)));
      case EQUIPMENT_TYPE_AMMUNITION:
          RemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, GetMatchingIPDamageType(oItem),
            GetItemPropertyStackedValue(oItem, ItemPropertyDamageBonus(GetMatchingIPDamageType(oItem), nBonus)));
          break;
    }
}

int mdConvertClassToBit(int nClass, object oPC=OBJECT_INVALID)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARBARIAN: return MD_BIT_BARB;
        case CLASS_TYPE_BARD:
            if(miWAGetIsWarlock(oPC))
                return MD_BIT_WARLOCK;
            else if(miFSGetIsFavoredSoul(oPC))
                return MD_BIT_FAVSOUL;
            else
                return MD_BIT_BARD;
        case CLASS_TYPE_CLERIC: return MD_BIT_CLERIC;
        case CLASS_TYPE_DRUID: return MD_BIT_DRUID;
        case CLASS_TYPE_FIGHTER: return MD_BIT_FIGHT;
        case CLASS_TYPE_MONK: return MD_BIT_MONK;
        case CLASS_TYPE_PALADIN: return MD_BIT_PALADIN;
        case CLASS_TYPE_RANGER: return MD_BIT_RANGER;
        case CLASS_TYPE_ROGUE: return MD_BIT_ROGUE;
        case CLASS_TYPE_WIZARD: return MD_BIT_WIZARD;
        case CLASS_TYPE_SORCERER: return MD_BIT_SORC;
        case CLASS_TYPE_ARCANE_ARCHER: return MD_BIT_ARCHER;
        case CLASS_TYPE_ASSASSIN: return MD_BIT_ASSASSIN;
        case CLASS_TYPE_DIVINECHAMPION: return MD_BIT_CHAMPION;
        case CLASS_TYPE_DRAGON_DISCIPLE: return MD_BIT_DRAG_DISCIPLE;
        case CLASS_TYPE_DWARVENDEFENDER: return MD_BIT_DEFENDER;
        case CLASS_TYPE_BLACKGUARD: return MD_BIT_BLACKGUARD;
        case CLASS_TYPE_HARPER: return MD_BIT_HARPER;
        case CLASS_TYPE_PALE_MASTER: return MD_BIT_PALEMASTER;
        case CLASS_TYPE_SHIFTER: return MD_BIT_SHIFTER;
        case CLASS_TYPE_WEAPON_MASTER: return MD_BIT_WEAPONMASTER;
        case CLASS_TYPE_SHADOWDANCER: return MD_BIT_SHADOWDANCER;
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return MD_BIT_PDK;
    }

    return 0;
}

string mdGetClassName(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARBARIAN: return "Barbarian";
        case CLASS_TYPE_BARD: return "Bard";
        case CLASS_TYPE_CLERIC: return "Cleric";
        case CLASS_TYPE_DRUID: return "Druid";
        case CLASS_TYPE_FIGHTER: return "Fighter";
        case CLASS_TYPE_MONK: return "Monk";
        case CLASS_TYPE_PALADIN: return "Paladin";
        case CLASS_TYPE_RANGER: return "Ranger";
        case CLASS_TYPE_ROGUE: return "Rogue";
        case CLASS_TYPE_WIZARD: return "Wizard";
        case CLASS_TYPE_SORCERER: return "Sorcerer";
        case CLASS_TYPE_ARCANE_ARCHER: return "Arcane Archer";
        case CLASS_TYPE_ASSASSIN: return "Assassin";
        case CLASS_TYPE_DIVINECHAMPION: return "Divine Champion";
        case CLASS_TYPE_DRAGON_DISCIPLE: return "Dragon Disciple";
        case CLASS_TYPE_DWARVENDEFENDER: return "Dwarven Defender";
        case CLASS_TYPE_BLACKGUARD: return "Blackguard";
        case CLASS_TYPE_HARPER: return "Harper Scout";
        case CLASS_TYPE_PALE_MASTER: return "Palemaster";
        case CLASS_TYPE_SHIFTER: return "Shifter";
        case CLASS_TYPE_WEAPON_MASTER: return "Weapon Master";
        case CLASS_TYPE_SHADOWDANCER: return "Shadowdancer";
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: return "Knight";
    }

    return "";
}

string mdGetPathName(int nPathBit)
{
    switch(nPathBit)
    {
        case MD_BIT_WARLOCK: return "Warlock";
        case MD_BIT_FAVSOUL: return "Favored Soul";
    }

    return "";
}

string gvd_GetArelithClassNameByPosition(int iClassPosition, object oPC) {

  // gets the classname of oPC for iClassPosition, taking all Arelith subclasses into account

  int iClassType = GetClassByPosition(iClassPosition, oPC);
  object oHide = gsPCGetCreatureHide(oPC);
  string sPath = GetLocalString(oHide, "MI_PATH");
  string sClassName = "";
  string sSubClass = "";

  if (iClassType != CLASS_TYPE_INVALID) {

    switch (iClassType) {

        case CLASS_TYPE_ARCANE_ARCHER: {
          sClassName = "Arcane Archer";
          break;
        }
        case CLASS_TYPE_ASSASSIN: {
          sClassName = "Assassin";
          break;
        }
        case CLASS_TYPE_BARBARIAN: {
          // check for subclasses
          if (sPath == PATH_OF_THE_TRIBESMAN) {
            sClassName = "Tribesman";
          } else {
            sClassName = "Barbarian";
          }
          break;
        }
        case CLASS_TYPE_BARD: {
          // check for subclasses
          if (miWAGetIsWarlock(oPC) != 0) {
            sClassName = "Warlock";
          } else if (miFSGetIsFavoredSoul(oPC) != 0) {
            sClassName = "Favored Soul";
          } else {
            sClassName = "Bard";
          }
          break;
        }
        case CLASS_TYPE_BLACKGUARD: {
          sClassName = "Blackguard";
          break;
        }
        case CLASS_TYPE_DIVINECHAMPION: {
          sClassName = "Divine Champion";
          break;
        }
        case CLASS_TYPE_CLERIC: {
          // check for subclasses
          if (sPath == PATH_OF_THE_HEALER) {
            sClassName = "Healer";
		  } else if (GetIsFavouredSoul(oPC)) {
		    sClassName = "Favoured Soul";
          } else {
            sClassName = "Cleric";
          }
          break;
        }
        case CLASS_TYPE_DRUID: {
          // check for subclasses
          sSubClass = gvd_GetTotemName(oPC);

          if (sSubClass != "") {
            sClassName = "Druid (" + sSubClass + ")";
          } else {
            sClassName = "Druid";
          }
          break;
        }
        case CLASS_TYPE_DWARVENDEFENDER: {
          sClassName = "Dwarven Defender";
          break;
        }
        case CLASS_TYPE_FIGHTER: {
          sClassName = "Fighter";
          break;
        }
        case CLASS_TYPE_HARPER: {
          sClassName = "Harper Scout";
          break;
        }
        case CLASS_TYPE_MONK: {
          sClassName = "Monk";
          break;
        }
        case CLASS_TYPE_PALADIN: {
          sClassName = "Paladin";
          break;
        }
        case CLASS_TYPE_PALE_MASTER: {
          sClassName = "Pale Master";
          break;
        }
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT: {
          sClassName = "Dragon Knight";
          break;
        }
        case CLASS_TYPE_RANGER: {
          // check for subclasses
          if (sPath == PATH_OF_THE_ARCHER) {
            sClassName = "Archer";
          } else if (sPath == PATH_OF_THE_SNIPER) {
            sClassName = "Sniper";
          } else {
            sClassName = "Ranger";
          }
          break;
        }
        case CLASS_TYPE_DRAGON_DISCIPLE: {
          sClassName = "Dragon Disciple";
          break;
        }
        case CLASS_TYPE_ROGUE: {
          sClassName = "Rogue";
          break;
        }
        case CLASS_TYPE_SHADOWDANCER: {
          sClassName = "Shadowdancer";
          break;
        }
        case CLASS_TYPE_SHIFTER: {
          sClassName = "Shifter";
          break;
        }
        case CLASS_TYPE_SORCERER: {
          // check for subclasses
          if (sPath == PATH_OF_WEAVE_MASTERY) {
            sClassName = "Weave Master";
          } else if (sPath == PATH_OF_TRUE_FIRE) {
            sClassName = "True Flamer";
          } else {
            sClassName = "Sorcerer";
          }
          break;
        }
        case CLASS_TYPE_WEAPON_MASTER: {
          sClassName = "Weapon Master";
          break;
        }
        case CLASS_TYPE_WIZARD: {
          if (sPath == PATH_OF_WILD_MAGE) {
            sClassName = "Wild Mage";
          } else if (sPath == PATH_OF_SPELLSWORD) { //::Kirito-Spellsword path
            sClassName = "Spellsword";
          } else {
            sClassName = "Wizard";
          }
          break;
        }

    }

  }

  // check for kensai addition
  if ((iClassPosition == 1) && (sPath == PATH_OF_THE_KENSAI)) {
    sClassName = sClassName + " (K)";
  }

  return sClassName;

}

void gvd_UpdateArelithClassesInDB(object oPC) {

    string sID = gsPCGetPlayerID(oPC);
    miDASetKeyedValue("gs_pc_data", sID, "classname_1", gvd_GetArelithClassNameByPosition(1, oPC));
    miDASetKeyedValue("gs_pc_data", sID, "classlevel_1", IntToString(GetLevelByPosition(1, oPC)));
    miDASetKeyedValue("gs_pc_data", sID, "classname_2", gvd_GetArelithClassNameByPosition(2, oPC));
    miDASetKeyedValue("gs_pc_data", sID, "classlevel_2", IntToString(GetLevelByPosition(2, oPC)));
    miDASetKeyedValue("gs_pc_data", sID, "classname_3", gvd_GetArelithClassNameByPosition(3, oPC));
    miDASetKeyedValue("gs_pc_data", sID, "classlevel_3", IntToString(GetLevelByPosition(3, oPC)));

}

void ReapplyFighterBonuses(object oPC)
{
  if(GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) < 5 || GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) || GetIsDM(oPC)) return;

  object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
  object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
  object oMainHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

  if(oMainHand == oOffHand)
  {
    // If these are identical, then the fighter is in fact using a two-hander, not wielding an off-hand.
    oOffHand = OBJECT_INVALID;
  }

  miRemoveFighterBonuses(oArmor);
  miRemoveFighterBonuses(oHelm);
  miRemoveFighterBonuses(oMainHand);
  miRemoveFighterBonuses(oOffHand);
  miCLApplyFighterBonuses(oArmor, oPC);
  miCLApplyFighterBonuses(oHelm, oPC);
  miCLApplyFighterBonuses(oMainHand, oPC);
  miCLApplyFighterBonuses(oOffHand, oPC);
}

int GetFighterEnhancementBonus(object oItem)
{
    object oPC = GetItemPossessor(oItem);
    int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);

    if(!nFighter) return 0;

    int nBonus = (nFighter >= 28) ? 2 : (nFighter >= 25) ? 1 : 0;

    switch(GetEquipmentType(oItem))
    {
        case EQUIPMENT_TYPE_HELMET:
            if(nFighter >= 15) nBonus++;
            return nBonus;
        case EQUIPMENT_TYPE_ARMOR:
            if(nFighter >= 5) nBonus++;
            return nBonus;
        case EQUIPMENT_TYPE_SHIELD:
            if(nFighter >= 10) nBonus++;
            return nBonus;
        case EQUIPMENT_TYPE_WEAPON:
        case EQUIPMENT_TYPE_AMMUNITION:
            if(nFighter >= 23) nBonus++;
            return nBonus;
    }
    return 0;
}

// Returns TRUE if the PC is a healer.
int GetIsHealer(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetLocalInt(gsPCGetCreatureHide(oPC), "HEALER");
}

// Returns TRUE if the PC is a kensai.
int GetIsKensai(object oPC)
{
    return GetLocalInt(gsPCGetCreatureHide(oPC), "KENSAI");
}

// Returns TRUE if hte PC is an archer.
int GetIsArcher(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_RANGER, oPC) &&  GetLocalInt(gsPCGetCreatureHide(oPC), "ARCHER");
}

// Returns TRUE if the PC is a sniper.
int GetIsSniper(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_RANGER, oPC) && (GetLocalString(gsPCGetCreatureHide(oPC), "MI_PATH") == "Path of the Sniper");
}

// Returns TRUE if the PC is a true flame.
int GetIsTrueFlame(object oPC)
{
    return GetLocalInt(gsPCGetCreatureHide(oPC), "TRUE_FIRE");
}

// Returns TRUE if the PC is a weavemaster.
int GetIsWeavemaster(object oPC)
{
    return GetLocalInt(gsPCGetCreatureHide(oPC), "WEAVE_MASTER");
}

// Returns TRUE if the PC is a (new style) favoured soul.
int GetIsFavouredSoul(object oPC)
{
    return GetLocalInt(gsPCGetCreatureHide(oPC), "FAVOURED_SOUL");
}

// Returns TRUE if the PC is a Shadow Mage.
int GetIsShadowMage(object oPC)
{
    return GetLocalInt(gsPCGetCreatureHide(oPC), "SHADOW_MAGE");
}

// Applies ranger weapon bonuses (e.g. AC for dual-wielding).
void ApplyRangerWeaponBonuses(object oPC, int bFeedback)
{
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

    if(!GetIsPC(oPC) || GetIsDM(oPC) || !nRanger) return;

    int nBonus;
    string sClass;

    if(GetIsArcher(oPC) || GetIsSniper(oPC))
    {
        if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
        {
            // Changed from +1/3 to +2/4/6/8 at 4/12/20/28
            if(nRanger >= 28) nBonus = IP_CONST_DAMAGEBONUS_8;
            else if(nRanger >= 20) nBonus = IP_CONST_DAMAGEBONUS_6;
            else if(nRanger >= 12) nBonus = IP_CONST_DAMAGEBONUS_4;
            else if(nRanger >= 4) nBonus = IP_CONST_DAMAGEBONUS_2;

            if(nBonus)
            {
                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(nBonus, DAMAGE_TYPE_PIERCING)), oPC, 0.0, EFFECT_TAG_WEAPON_BONUS);
				if(bFeedback)
                {
                    if(GetIsArcher(oPC)) sClass = "Archer";
                    else if(GetIsSniper(oPC)) sClass = "Sniper";
					if (nBonus == IP_CONST_DAMAGEBONUS_6) nBonus = 6; // For proper feedback.
					else if (nBonus == IP_CONST_DAMAGEBONUS_8) nBonus = 8;
                    SendMessageToPC(oPC, sClass + " Ranged Bonus Granted: +" + IntToString(nBonus) + " Damage");
                }
            }
        }
    }
    else
    {
        if(GetIsDualWielding(oPC))
        {
            // Change scaling from +1/2 at 6/14 to +1/2/3/4 at 4/12/20/28
            if(nRanger >= 28) nBonus = 4;
            else if(nRanger >= 20) nBonus = 3;
            else if(nRanger >= 12) nBonus = 2;
            else if(nRanger >= 4) nBonus = 1;

            if(nBonus)
            {
                ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nBonus)), oPC, 0.0, EFFECT_TAG_WEAPON_BONUS);
                if(bFeedback) SendMessageToPC(oPC, "Ranger Dual-Wield Bonus Granted: +" + IntToString(nBonus) + " Armor Class");
            }
        }
    }
}

// Removes dual wield feats from rangers.
void RemoveRangerDualWieldFeats(object oPC)
{
    NWNX_Creature_RemoveFeat(oPC, 374);
    if(GetKnowsFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC) &&
        GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 9) == GetKnownFeatLevel(oPC, FEAT_IMPROVED_TWO_WEAPON_FIGHTING))
    {
        NWNX_Creature_RemoveFeat(oPC, FEAT_IMPROVED_TWO_WEAPON_FIGHTING);
    }
}

// Grants Woodland Stride at level 7, Uncanny Dodge(1) at level 8, Evasion at level 9.
void AddRangerFeats(object oPC)
{
    int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

    if(nRanger >= 7)
    {
        AddKnownFeat(oPC, FEAT_WOODLAND_STRIDE, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 7));
    }
    if(nRanger >= 8)
    {
        AddKnownFeat(oPC, FEAT_UNCANNY_DODGE_1, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 8));
    }
    if(nRanger >= 9)
    {
        AddKnownFeat(oPC, FEAT_EVASION, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 9));
    }
}

// Assassins get Evasion at level 6, Defensive Roll at level 12, and Improved Evasion at level 16.
void AddAssassinFeats(object oPC)
{
    int nAssassin = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);

    if (nAssassin >= 6)
    {
        AddKnownFeat(oPC, FEAT_EVASION, GetLevelByClassLevel(oPC, CLASS_TYPE_ASSASSIN, 6));
    }
    if (nAssassin >= 12)
    {
        AddKnownFeat(oPC,  FEAT_DEFENSIVE_ROLL, GetLevelByClassLevel(oPC, CLASS_TYPE_ASSASSIN, 12));
    }
    if (nAssassin >= 16)
    {
        AddKnownFeat(oPC,  FEAT_IMPROVED_EVASION, GetLevelByClassLevel(oPC, CLASS_TYPE_ASSASSIN, 16));
    }
    // Player Tool 2 for assassination
    if (nAssassin >= 1)
        AddKnownFeat(oPC, FEAT_PLAYER_TOOL_02, GetLevelByClassLevel(oPC, CLASS_TYPE_ASSASSIN, 1));

}

// Grants HiPS to Shadow Mages at mage level 20.
void AddShadowMageFeats(object oPC)
{
    int nSorcerer = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    int nClass;

    if(!nSorcerer && !nWizard) return;

    nClass = (nSorcerer > nWizard) ? CLASS_TYPE_SORCERER : CLASS_TYPE_WIZARD;

    if(GetLevelByClass(nClass, oPC) >= 20)
    {
        AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, nClass, 20));
    }
}

// Grants Rapid Shot, Point Blank Shot, and Called Shot to sniper path rangers. Also
// responsible for migrating old snipers, which instead received the Mobility feat.
void AddSniperFeats(object oPC)
{
    AddKnownFeat(oPC, FEAT_RAPID_SHOT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 1));
    AddKnownFeat(oPC, FEAT_POINT_BLANK_SHOT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 1));

    if(!GetKnowsFeat(FEAT_MOBILITY, oPC))
    {
        DeleteLocalInt(gsPCGetCreatureHide(oPC), "IsOldSniper");
    }

    if(GetKnowsFeat(FEAT_MOBILITY, oPC) && GetKnownFeatLevel(oPC, FEAT_MOBILITY) == -1)
    {
        // Migration code for pre-update snipers, which received mobility instead of called shot.
        // Give the feat to them at ranger level 9 (instead of no specified level) and flag them
        // as an old sniper so they don't receive called shot as well.
        NWNX_Creature_RemoveFeat(oPC, FEAT_MOBILITY);
        AddKnownFeat(oPC, FEAT_MOBILITY, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 9));
        SetLocalInt(gsPCGetCreatureHide(oPC), "IsOldSniper", 1);
    }

    if(!GetLocalInt(gsPCGetCreatureHide(oPC), "IsOldSniper") && GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 9)
    {
        AddKnownFeat(oPC, FEAT_CALLED_SHOT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 9));
    }
}

// Updates HiPS for rangers (i.e. applied in natural areas, not in artifical areas).
void UpdateRangerHiPS(object oPC)
{
    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) < 16 || GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 5) return;

    if (GetIsAreaNatural(GetArea(oPC)))
    {
        AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, 16));
        SendMessageToPC(oPC, "Hide in Plain Sight is available in this area.");
    }
    else
    {
        NWNX_Creature_RemoveFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT);
        SendMessageToPC(oPC, "Hide in Plain Sight is not available in this area.");
    }
}

// Grants innate spells to PCs that have the appropriate greater spell focuses.
// Intended for mages.
void AddSpellFocusBonusSpells(object oPC, int nClass)
{
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC)) AddInnateSpell(oPC, GSF_SPELL_ABJURATION, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC)) AddInnateSpell(oPC, GSF_SPELL_CONJURATION, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oPC)) AddInnateSpell(oPC, GSF_SPELL_DIVINATION, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC)) AddInnateSpell(oPC, GSF_SPELL_ENCHANTMENT, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC)) AddInnateSpell(oPC, GSF_SPELL_EVOCATION, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC)) AddInnateSpell(oPC, GSF_SPELL_ILLUSION, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC)) AddInnateSpell(oPC, GSF_SPELL_NECROMANCY, nClass);
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC)) AddInnateSpell(oPC, GSF_SPELL_TRANSMUTATION, nClass);
}

// Methods used to present race and class lists in Z-Dialog

void _AddBitString(int nBit, string sString, string sPage, int nRace, object oHolder)
{
    if(nRace == 0)
        return; //reject if bit is empty
    string sColor;
    if((nBit & nRace) == nRace)
        sColor = STRING_COLOR_GREEN;
    else
        sColor = STRING_COLOR_RED;

    AddStringElement(StringToRGBString(sString, sColor), sPage, oHolder);

}

void md_SetUpRaceList(string sPage, int nBit, object oHolder = OBJECT_SELF)
{
    if(GetElementCount(sPage) == 0)
    {
        //int nBit = GetLocalInt(oCzar, VAR_BIT);
        int x;
        for(x=0;x<=6;x++)
            _AddBitString(nBit, gsSUGetRaceName(x), sPage, md_ConvertRaceToBit(x), oHolder);

        for(x=1;x<=HIGHEST_SR;x++)
        {
            if(x == 15) //genasi not in system
                x = 19;
                                                                                                                                  //we don't need two listings of orog
            while(x == GS_SU_ELF_MOON || x == GS_SU_GNOME_ROCK || x == GS_SU_HALFLING_LIGHTFOOT || x == GS_SU_DWARF_SHIELD || x == GS_SU_FR_OROG)
                x++;
            _AddBitString(nBit, gsSUGetNameBySubRace(x), sPage, md_ConvertSubraceToBit(x), oHolder);
        }

        for(x=100;x<=HIGHEST_SSR;x++)
        {
            if(x == 103)
                x = 107;
            _AddBitString(nBit, gsSUGetNameBySubRace(x), sPage, md_ConvertSubraceToBit(x), oHolder);
        }

        _AddBitString(nBit, "Group: Underdark Races", sPage, MD_BIT_UNDARK, oHolder);
        _AddBitString(nBit, "Group: Surface Elves", sPage, MD_BIT_SU_ELF, oHolder);
        _AddBitString(nBit, "Group: Hin/Halflings", sPage, MD_BIT_SU_HL, oHolder);
        _AddBitString(nBit, "Group: Earthkin", sPage, MD_BIT_EARTHKIN, oHolder);

    }
}

int md_GetRaceSelection(int selection)
{
        int nBit;
        if(selection == 29)
            nBit = MD_BIT_UNDARK;
        else if(selection == 30)
            nBit = MD_BIT_SU_ELF;
        else if(selection == 31)
            nBit = MD_BIT_SU_HL;
        else if(selection == 32)
            nBit = MD_BIT_EARTHKIN;
        else if(selection > 6)
        {

            if(selection > 22)
            {
                selection += 77;
                if(selection > 102)
                    selection+=4;
            }
            else if(selection > 20)
                selection += 3;
            else if(selection >= 17)
                selection += 2;
            else
            {
                selection -= 6;

                if(selection >= GS_SU_HALFLING_LIGHTFOOT-3)
                    selection += 4;
                else if(selection >= GS_SU_GNOME_ROCK-2)
                    selection += 3;
                else if(selection >= GS_SU_ELF_MOON-1)
                    selection += 2;
                else if(selection >= GS_SU_DWARF_SHIELD)
                    selection++;


            }


            nBit = md_ConvertSubraceToBit(selection);
        }
        else
            nBit = md_ConvertRaceToBit(selection);

       return nBit;

}

void md_SetUpClassList(string sPage, int nBit, object oHolder = OBJECT_SELF, int nIgnoreHarper = TRUE)
{
    // If you add to this method, you will also need to update md_GetClassSelection accordingly.
    if(GetElementCount(sPage) == 0)
    {
        int x;
        for(x=0;x<=10;x++)
        {
            //if(x == CLASS_TYPE_PALADIN)
               // x++;

            _AddBitString(nBit, mdGetClassName(x), sPage, mdConvertClassToBit(x), oHolder);
        }

        for(x=27;x<=37;x++)
        {
            //while(x == CLASS_TYPE_ASSASSIN || x == CLASS_TYPE_SHIFTER || x == CLASS_TYPE_HARPER || x == CLASS_TYPE_BLACKGUARD || x == CLASS_TYPE_PALEMASTER)
            if(x == CLASS_TYPE_HARPER && nIgnoreHarper)
                x++;

            _AddBitString(nBit, mdGetClassName(x), sPage, mdConvertClassToBit(x), oHolder);
        }

        _AddBitString(nBit, "Knight", sPage, MD_BIT_PDK, oHolder);
        _AddBitString(nBit, "Favored Soul", sPage, MD_BIT_FAVSOUL, oHolder);
        _AddBitString(nBit, "Warlock", sPage, MD_BIT_WARLOCK, oHolder);
        _AddBitString(nBit, "Group: Warrior", sPage, MD_BIT_WARRIOR, oHolder);
        _AddBitString(nBit, "Group: Arcane", sPage, MD_BIT_ARCANE, oHolder);
        _AddBitString(nBit, "Group: Clergy", sPage, MD_BIT_CLERGY, oHolder);
        _AddBitString(nBit, "Group: Divine", sPage, MD_BIT_DIVINE, oHolder);
        _AddBitString(nBit, "Group: Thief", sPage, MD_BIT_THIEF, oHolder);
     }

}
int md_GetClassSelection(int selection, int nIgnoreHarper = TRUE)
{
    int nBit;
    if(!nIgnoreHarper && selection >= 22)
        selection--; //harpers on the list so subtract one here
    if(selection == 21)
        nBit = MD_BIT_PDK;
    else if(selection == 22)
        nBit = MD_BIT_FAVSOUL;
    else if(selection == 23)
        nBit = MD_BIT_WARLOCK;
    else if(selection == 24)
        nBit = MD_BIT_WARRIOR;
    else if(selection == 25)
        nBit = MD_BIT_ARCANE;
    else if(selection == 26)
        nBit = MD_BIT_CLERGY;
    else if(selection == 27)
        nBit = MD_BIT_DIVINE;
    else if(selection == 28)
        nBit = MD_BIT_THIEF;
    else
    {

        if(selection > 10)
        {
            selection += 16;


            if(selection >= CLASS_TYPE_HARPER && nIgnoreHarper)
                selection++;


        }


        nBit = mdConvertClassToBit(selection);
    }

    return nBit;
}
