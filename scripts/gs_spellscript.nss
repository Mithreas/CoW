#include "inc_flag"
#include "inc_iprop"
#include "inc_text"
#include "inc_worship"
#include "inc_spell"
#include "inc_state"
#include "inc_strack"
#include "inc_pc"
#include "inc_spells"
#include "inc_class"
#include "inc_divination"
#include "inc_relations"
#include "x2_inc_switches"
#include "inc_wildmagic"
#include "inc_spells"
#include "inc_subdual"

int _GetIsSummonSpell(int nSpellId, int bUndead = 0, int bSwords = 0)
{
  switch (nSpellId)
  {
    // Summon spells and abilities
    // Excludes undead summoning (raising)
    case SPELL_SUMMON_CREATURE_I:
    case SPELL_SUMMON_CREATURE_II:
    case SPELL_SUMMON_CREATURE_III:
    case SPELL_SUMMON_CREATURE_IV:
    case SPELL_SUMMON_CREATURE_IX:
    case SPELL_SUMMON_CREATURE_V:
    case SPELL_SUMMON_CREATURE_VI:
    case SPELL_SUMMON_CREATURE_VII:
    case SPELL_SUMMON_CREATURE_VIII:
    case 303:
    case 304:
    case SPELL_SUMMON_SHADOW:
    case SPELL_SHADES_SUMMON_SHADOW:
    case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:
    case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:
    case 378:
    case 379:
    case SPELL_ELEMENTAL_SUMMONING_ITEM:
    case 564:
    case 701:
    case SPELL_PLANAR_ALLY:
    case 610: // BG Fiendish Servant
    case SPELL_EPIC_DRAGON_KNIGHT:
      return TRUE;
      break;
    // Planar binding might be cast at a creature.  If so, not a summon.
    case SPELL_GREATER_PLANAR_BINDING:
    case SPELL_LESSER_PLANAR_BINDING:
    case SPELL_PLANAR_BINDING:
      if (!GetIsObjectValid(GetSpellTargetObject()))
        return TRUE;
  }

  if (bUndead)
  {
    switch  (nSpellId)
    {
        case SPELL_ANIMATE_DEAD:
        case SPELL_CREATE_GREATER_UNDEAD:
        case SPELL_CREATE_UNDEAD:
        case SPELL_EPIC_MUMMY_DUST:
            return TRUE;
    }
  }

  if (bSwords)
  {
    switch (nSpellId)
    {
        case SPELL_MORDENKAINENS_SWORD:
        case SPELL_SHELGARNS_PERSISTENT_BLADE:
            return TRUE;
    }
  }

  return FALSE;
}

void main()
{
    int nSpell = GetSpellId();
	int nSchool = GetSpellSchool(nSpell);
    int bBypassAntimagic = GetLocalInt(OBJECT_SELF, "BypassAntimagic");

    DeleteLocalInt(OBJECT_SELF, "BypassAntimagic");

    int bIsMundaneAbility = GetIsItemMundane(GetSpellCastItem());

    if (GetIsDM(OBJECT_SELF))                return;
    if (GetIsDMPossessed(OBJECT_SELF))       return;

    UpdateCreatureSpellVariables(OBJECT_SELF);

    if(!CheckSpontaneousCasting())
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    //spelltracker override
    if (GetLocalInt(OBJECT_SELF, "GS_SPT_OVERRIDE"))
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    //area flag
    if (gsFLGetAreaFlag("OVERRIDE_MAGIC") && !bIsMundaneAbility && !bBypassAntimagic)
    {
        if (GetIsPC(OBJECT_SELF)) FloatingTextStringOnCreature(GS_T_16777445, OBJECT_SELF, FALSE);
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    if (! GetIsPC(OBJECT_SELF))              return;
    if (GetIsPossessedFamiliar(OBJECT_SELF)) return;

    object oHide = gsPCGetCreatureHide();
    object oTarget   = GetSpellTargetObject();
    int nHarmful     = Get2DAString("spells", "HostileSetting", nSpell) == "1";

    //:: Kitito // Spellsword Imbue weapon
    if (GetLocalInt(oHide, "SPELLSWORD") && GetIsObjectValid(oTarget) && (oTarget == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF) || oTarget == GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF))) // && miSSImbueSpellList(GetSpellId()) )
    {
		if (nSchool == GetLocalInt(oHide, "MI_BLOCKEDSCHOOL1"))
		{
			SendMessageToPC (OBJECT_SELF, "You may not imbue weapons using spells from your blocked school.");
			gsSPSetOverrideSpell();
			SetModuleOverrideSpellScriptFinished();
			return;
		}
		if(GetIsObjectValid(GetSpellCastItem()))
		{
			SendMessageToPC (OBJECT_SELF, "You may not imbue weapons using spells cast from scrolls, wands, or other items.");
			gsSPSetOverrideSpell();
			SetModuleOverrideSpellScriptFinished();
			return;
		}		
		
		if (GetSpellId() == SPELL_MESTILS_ACID_SHEATH ||
			GetSpellId() == SPELL_ELEMENTAL_SHIELD ||
			GetSpellId() == SPELL_DEATH_ARMOR)
		{
			SendMessageToPC (OBJECT_SELF, "This spell cannot be imbued to a weapon");
			gsSPSetOverrideSpell();
			SetModuleOverrideSpellScriptFinished();
			return;
		}
		else if (GetStringLeft(GetStringUpperCase(GetTag(oTarget)),6) == "CA_GEN")
		{
			SendMessageToPC (OBJECT_SELF, "This item cannot be imbued");
			gsSPSetOverrideSpell();
			SetModuleOverrideSpellScriptFinished();
			return;
		}
		else
		{
		    gsSTDoCasterDamage(OBJECT_SELF, gsSPGetSpellLevel(nSpell, GetLastSpellCastClass()));
		
			SendMessageToPC (OBJECT_SELF, "Imbue weapon");
			//int nCasterLevel = GetLevelByClass(CLASS_TYPE_WIZARD);
			//float fDuration = nCasterLevel*60.0*6.0;
			//itemproperty ipProperty = ItemPropertyOnHitCastSpell(GetSpellId(),nCasterLevel);
			//AddItemProperty(DURATION_TYPE_TEMPORARY, ipProperty, oTarget, fDuration);
			miSSImbueWeapon( OBJECT_SELF, nSpell, oTarget);
			gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
			gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
			gsSPSetSpellCallback();
			return;
		}
    }
    else if(GetLocalInt(oHide, "SPELLSWORD") && GetIsObjectValid(oTarget) && oTarget == GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF))
    {
		miSSImbueArmour( OBJECT_SELF, nSpell, oTarget);
        gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
        gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
        gsSPSetSpellCallback();
        return;
    }
    else if(GetIsObjectValid(GetSpellCastItem()) && !gsIPDoUMDCheck(GetSpellCastItem(), OBJECT_SELF))
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }
//    object oTarget   = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
//    int nHarmful     = Get2DAString("spells", "HostileSetting", nSpell) == "1";

    //::  ActionReplay - Apply Wild Magic if the area is affected by it (Logic in ar_FaerzressWildMagic)
    if(!bIsMundaneAbility && !(!GetIsObjectValid(GetSpellCastItem()) && GetIsShadowMage(OBJECT_SELF)))
    {
        ar_FaerzressWildMagic(OBJECT_SELF, oTarget, lTarget, nSpell, nHarmful);
    }

    // Kensais cannot use magic.
    // Septire - modified conditions. Kensai can cast spells, but are barred from spell-casting classes in gs_m_levelup.
    // This should allow spell-like feats in non-casting classes to be cast.
    if (GetLocalInt(oHide, "KENSAI") &&
        !bIsMundaneAbility &&
        GetIsObjectValid(GetSpellCastItem()) &&
        GetSpellCastItem() != GetItemPossessedBy(OBJECT_SELF, "GS_SU_ABILITY") &&
        nSpell != SPELL_RAISE_DEAD &&
        nSpell != SPELL_RESURRECTION &&
        nSpell != SPELL_LESSER_RESTORATION &&
        nSpell != SPELL_GREATER_RESTORATION &&
        nSpell != SPELL_RESTORATION)
    {
      SendMessageToPC (OBJECT_SELF, "A kensai cannot use magic except for Raise Dead, Resurrection, and Restoration. Spell-like feats and innate abilities will function normally.");
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
    }

    // True fire sorcs can only cast evocation spells, but don't use up spell
    // slots.
    if (GetLocalInt(oHide, "TRUE_FIRE"))
    {
      if (nSchool == SPELL_SCHOOL_EVOCATION)
      {
        int ii = 0;
        for (ii; ii < 10; ii++)
        {
          NWNX_Creature_SetRemainingSpellSlots(OBJECT_SELF,
                                 CLASS_TYPE_SORCERER,
                                 ii,
                                 NWNX_Creature_GetMaxSpellSlots(OBJECT_SELF, CLASS_TYPE_SORCERER, ii));
        }

        // And carry on.
      }
      else if(!bIsMundaneAbility &&
        nSpell != SPELL_RAISE_DEAD &&
        nSpell != SPELL_RESURRECTION &&
        nSpell != SPELL_LESSER_RESTORATION &&
        nSpell != SPELL_GREATER_RESTORATION &&
        nSpell != SPELL_RESTORATION)
      {
        SendMessageToPC (OBJECT_SELF, "The Path of True Fire rejects other magics.");
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
      }
    }

    // Shadow mages cannot cast evocation spells (except Darkness).
    if (GetIsShadowMage(OBJECT_SELF) && GetSpellId() != SPELL_DARKNESS && !bIsMundaneAbility && nSchool == SPELL_SCHOOL_EVOCATION)
    {
      SendMessageToPC (OBJECT_SELF, "The Shadow Weave does not support Evocation spells (except Darkness).");
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
    }

    // Unfaithful shadow mages can't cast any arcane spells.
    if (GetIsShadowMage(OBJECT_SELF) && !bIsMundaneAbility && gsWOGetDeityByName(GetDeity(OBJECT_SELF)) != 8 && gsWOGetDeityByName(GetDeity(OBJECT_SELF)) != 23 && miSPGetLastSpellArcane(OBJECT_SELF))
    {
      SendMessageToPC (OBJECT_SELF, "Only servants of the Dark One or Sabatha can use shadow magic.");
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
    }
	
	// Unfaithful favoured souls /definitely/ can't cast any spells.
	if (GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, OBJECT_SELF) && gsWOGetCategory(gsWOGetDeityByName(GetDeity(OBJECT_SELF))) != FB_WO_CATEGORY_SEVEN_DIVINES && GetLastSpellCastClass() == CLASS_TYPE_FAVOURED_SOUL)
	{
	  SendMessageToPC(OBJECT_SELF, "Favoured Souls must be faithful to one of the Seven Divines to cast spells.");
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
	}

    //::Kirito-Spellsword path
    if (GetLocalInt(oHide, "SPELLSWORD"))
    {
    // Spellswords cannot cast from banned school,

        //requires additional attribute(s) added to creature hide - SPELLSWORD, BlockedSchool1, BlockedSchool2
        //allow healing spells through
		int bAllow = FALSE;
		
        switch (GetSpellId())
        {
            case SPELL_CURE_CRITICAL_WOUNDS:
            case SPELL_CURE_LIGHT_WOUNDS:
            case SPELL_CURE_MINOR_WOUNDS:
            case SPELL_CURE_MODERATE_WOUNDS:
            case SPELL_CURE_SERIOUS_WOUNDS:
            case SPELL_GREATER_RESTORATION:
            case SPELL_LESSER_RESTORATION:
            case SPELL_RAISE_DEAD:
            case SPELL_RESTORATION:
            case SPELL_RESURRECTION:
            case SPELL_EPIC_MAGE_ARMOR:
            {
                bAllow = TRUE;
            }
        }

        //allow potions
        if (GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_ENCHANTED_POTION ||
             GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_POTIONS)
        {
            bAllow = TRUE;
        }

        //check if the spell comes from a banned school and block it if necessary
		if (!bAllow && 
            ((nSchool == GetLocalInt(oHide, "MI_BLOCKEDSCHOOL1"))
                || (_GetIsSummonSpell(GetSpellId(), TRUE, TRUE)) // blocks all summons/undead/blades/planar
                //|| (nSchool == GetLocalInt(oHide, "MI_BLOCKEDSCHOOL2"))// blocks conjuration school
                || (GetSpellId() == SPELL_EPIC_DRAGON_KNIGHT)
                || (GetSpellId() == SPELL_EPIC_HELLBALL)
                || (GetSpellId() == SPELL_EPIC_MUMMY_DUST)
                || (GetSpellId() == SPELL_EPIC_RUIN)))
        {
          SendMessageToPC (OBJECT_SELF, "You are prohibited from casting spells of this type.");
          gsSPSetOverrideSpell();
          SetModuleOverrideSpellScriptFinished();
          return;
        }
    }

    if (gsFLGetAreaFlag("OVERRIDE_SUMMONS") && _GetIsSummonSpell(GetSpellId()) && !bIsMundaneAbility)
    {
      FloatingTextStringOnCreature("Your attempt to summon fails!" , OBJECT_SELF);
      gsSPSetOverrideSpell();
      SetModuleOverrideSpellScriptFinished();
      return;
    }

    //set target of harmful spell to hostile
    if (GetIsObjectValid(oTarget))
    {
        if (nHarmful && nSpell != SPELL_CHARM_MONSTER &&
            nSpell != SPELL_CHARM_PERSON && nSpell != SPELL_CHARM_PERSON_OR_ANIMAL)
        {
          SetPCDislike(OBJECT_SELF, oTarget);

          if (oTarget != OBJECT_SELF && GetIsPC(OBJECT_SELF) && GetIsPC(oTarget))
          {
            miRERecordCombatHit(oTarget, OBJECT_SELF);

            // dunshine: always disable subdual mode when a harmful spell is cast on a PC
            gvd_SetSubdualMode(OBJECT_SELF, 0);
          }

        }
    }
    else
    {
        object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
        oTarget          = oCreature;

        if (nHarmful && nSpell != SPELL_CHARM_MONSTER &&
            nSpell != SPELL_CHARM_PERSON && nSpell != SPELL_CHARM_PERSON_OR_ANIMAL)
        {
            while (GetIsObjectValid(oCreature))
            {
                SetPCDislike(OBJECT_SELF, oCreature);

                if (oCreature != OBJECT_SELF && GetIsPC(OBJECT_SELF) && GetIsPC(oCreature))
                {
                  miRERecordCombatHit(oCreature, OBJECT_SELF);
                }

                oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
            }
        }
    }

    // dunshine moved these variables up so they can be used in the else statement of the below if statement as wel
    string sDeity = GetDeity(OBJECT_SELF);
    float fPiety = gsWOGetPiety(OBJECT_SELF);
    float fRequired = 0.0;

    if (! GetIsObjectValid(GetSpellCastItem()))
    {
//------------------------------------------------------------------------------
// Alternate magic system.  Under this system
// - True Flame sorcs are unaffected
// - Wizards/sorcs/clerics etc can cast any number of spells, but must wait a
//   number of rounds equal to the spell level - 1 before casting another spell.
//   Sorcs halve the delay.
// - Quickened spells bypass the delay but cannot be cast during it.
//------------------------------------------------------------------------------
      int bFavoredSoul =  GetLastSpellCastClass() == CLASS_TYPE_FAVOURED_SOUL;
      int bWarlock = miWAGetIsWarlock(OBJECT_SELF) &&
                            GetLastSpellCastClass() == CLASS_TYPE_BARD;

      if (GetLocalInt(oHide, "WEAVE_MASTER") ||
          bFavoredSoul ||
          bWarlock ||
          (GetLocalInt(GetModule(), "USE_ALT_MAGIC") &&
           GetLastSpellCastClass() == CLASS_TYPE_SORCERER && // Temp add
           !GetLocalInt(oHide, "TRUE_FIRE")))
      {
        // Determine the level the spell was cast at.
        int nClass = GetLastSpellCastClass();
        string sColumn = "Innate";

        switch (nClass)
        {
          case CLASS_TYPE_BARD:
            sColumn = "Bard";
            break;
          case CLASS_TYPE_CLERIC:
            sColumn = "Cleric";
            break;
          case CLASS_TYPE_DRUID:
            sColumn = "Druid";
            break;
		  case CLASS_TYPE_FAVOURED_SOUL:
		    sColumn = "Cleric";
			break;
          case CLASS_TYPE_PALADIN:
            sColumn = "Paladin";
            break;
          case CLASS_TYPE_RANGER:
            sColumn = "Ranger";
            break;
          case CLASS_TYPE_SORCERER:
          case CLASS_TYPE_WIZARD:
            sColumn = "Wiz_Sorc";

            //:: ActionReplay - For Weave Masters get the correct spell ID for
            //:: subspells (E.g Shadow Conjuration) to get the proper nSpellLevel below.
            nSpell = _arGetCorrectSpellId(nSpell);
            break;
          default:
            break;
        }

        if (nClass == CLASS_TYPE_SORCERER || bFavoredSoul || bWarlock)
        {
          //SpeakString("Class/column: " + sColumn);

          int nSpellLevel = StringToInt(Get2DAString("spells", sColumn, nSpell));
          // Domain spells.
          if (!nSpellLevel) nSpellLevel = StringToInt(Get2DAString("spells", "Innate", nSpell));
          int nSpellBaseLevel = nSpellLevel;

          //SpeakString("Level: " + IntToString(nSpellLevel));

          // Metamagic
          switch (GetMetaMagicFeat())
          {
            case METAMAGIC_ANY:
            case METAMAGIC_NONE:
              nSpellLevel += 0;
              break;
            case METAMAGIC_EXTEND:
            case METAMAGIC_SILENT:
            case METAMAGIC_STILL:
              nSpellLevel += 1;
              break;
            case METAMAGIC_EMPOWER:
              nSpellLevel += 2;
              break;
            case METAMAGIC_MAXIMIZE:
              nSpellLevel += 3;
              break;
            case METAMAGIC_QUICKEN:
              nSpellLevel += 4;
              break;
          }

          // Reset spell slots.
          NWNX_Creature_SetRemainingSpellSlots(OBJECT_SELF,
                                 nClass,
                                 nSpellLevel,
                                 NWNX_Creature_GetMaxSpellSlots(OBJECT_SELF, GetLastSpellCastClass(), nSpellLevel));

        }
      }      
      // New style favoured souls.
      else if (GetLastSpellCastClass() == CLASS_TYPE_CLERIC && GetIsFavouredSoul(OBJECT_SELF))
	  {
		//SendMessageToPC(OBJECT_SELF, "Your god grants you this blessing.");
		ar_RestoreFavouredSoulSpell();
      }
      else
      {
        //spelltracker
        if (!GetLocalInt(oHide, "TRUE_FIRE"))
          gsSPTCast(OBJECT_SELF, nSpell, GetMetaMagicFeat());
      }
// end alt magic check

        // Rangers can only cast nature spells if they have a nature deity as patron.
        int nSpellID = GetSpellId();
        switch (nSpellID)
        {
          case SPELL_CAMOFLAGE:
          case SPELL_ENTANGLE:
          case SPELL_MAGIC_FANG:
          case SPELL_ONE_WITH_THE_LAND:
          case SPELL_GREATER_MAGIC_FANG:
          case SPELL_MASS_CAMOFLAGE:
          {
            if (!gsWOGetDeityAspect(OBJECT_SELF) & ASPECT_NATURE)
            {
              FloatingTextStringOnCreature("You need a nature deity to cast that spell.",
                 OBJECT_SELF, FALSE);
              gsSPSetOverrideSpell();
              SetModuleOverrideSpellScriptFinished();
              return;
            }
          }
        }

        int nLevel = gsSPGetSpellLevel(nSpell, GetLastSpellCastClass());
        // Temp fix for PM Create Greater Undead requiring piety/spell components.
        if(nSpell == 627) nLevel = 0;

        int nSpellCastClass = GetIsLastSpellCastSpontaneous() ? GetSpontaneousSpellClass(OBJECT_SELF, GetSpellId()) : GetLastSpellCastClass();
        if (nLevel >= 7 && (nSpellCastClass == CLASS_TYPE_DRUID || nSpellCastClass == CLASS_TYPE_CLERIC))
        {
            switch (nLevel)
            {
              case 7: fRequired = 1.0; break;
              case 8: fRequired = 2.0; break;
              case 9: fRequired = 4.0; break;
            }

            if (fPiety >= fRequired)
            {
                gsWOAdjustPiety(OBJECT_SELF, -fRequired, FALSE);
            }
            else
            {
                FloatingTextStringOnCreature(
                    "You are not pious enough for " + sDeity + " to grant you that spell now.",
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                return;
            }          
        }
        else if (nSpellCastClass == CLASS_TYPE_WIZARD || nSpellCastClass == CLASS_TYPE_SORCERER || nSpellCastClass == CLASS_TYPE_BARD)
        {
            // Arcanist - arcane spells cost stamina.
            int nHP = nLevel;			

            // Level 5 Harper-Mages can ignore spell components.
            //if (GetLocalInt(gsPCGetCreatureHide(), VAR_HARPER) == MI_CL_HARPER_MAGE &&
            //    GetLevelByClass(CLASS_TYPE_HARPER) > 4)
            //  nCharges = 0;

			gsSTDoCasterDamage(OBJECT_SELF, nHP);
        }
		else if (nSpellCastClass == CLASS_TYPE_FAVOURED_SOUL)
		{
		    gsSTAdjustState(GS_ST_PIETY, -IntToFloat(nLevel));
		}
		
		// CoW addition - sympathetic cleric magic
		if ((nSpellCastClass == CLASS_TYPE_CLERIC || nSpellCastClass == CLASS_TYPE_FAVOURED_SOUL) && 
		    GetIsObjectValid(GetSpellTargetObject()) && 
			GetSpellTargetObject() != OBJECT_SELF &&
			GetObjectType(GetSpellTargetObject()) == OBJECT_TYPE_CREATURE)
		{
		  // "Cheat cast" an instant spell on ourselves that matches the spell we cast on someone else.  
		  // This goes on the action queue.  If someone has queued several actions they could cancel a hostile spell
		  // before it hits them, so use SetCommandable(FALSE).  Of course, to make the *second* queued spell reflect,
		  // need to ensure we are commandable first.  
	      SetCommandable(TRUE, OBJECT_SELF);	
		  
		  // Override the spell level next time this is cast.  Reflected spells are always cast with CL 10 (and as if
		  // the caster had +3 to their casting stat and no focus feats for DC purposes). 
		  int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
		  int nSpellId = GetSpellId();
		  object oCaster = OBJECT_SELF;
		  int nMetaMagic = GetMetaMagicFeat();
		  ActionDoCommand(SetCasterLevelOverride(oCaster, nSpellId, nCasterLevel));
		  ActionCastSpellAtObject(GetSpellId(), OBJECT_SELF, nMetaMagic, TRUE, 0, 0, TRUE);
		  ActionDoCommand(DelayCommand(0.1f, SetCasterLevelOverride(oCaster, nSpellId, FALSE)));
		  
	      ActionDoCommand(SetCommandable(TRUE));  
	      SetCommandable(FALSE, OBJECT_SELF);		  
		}

    } else {
      // cast from item

      // Dunshine: Check for Raise Dead or Resurrection scrolls used, custom piety values for those
      if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) {

        if (GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_SPELLSCROLL) {

          switch (nSpell) {
            case SPELL_RAISE_DEAD: {
              // requires 50 piety to be cast from scroll (clerics 25)
              if (GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0) {
                fRequired = 25.0;
              } else {
                fRequired = 50.0;
              }
              break;
            }
            case SPELL_RESURRECTION: {
              // requires 75 piety to be cast from scroll (clerics 50)
              if (GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0) {
                fRequired = 50.0;
              } else {
                fRequired = 75.0;
              }
              break;
            }
            case SPELL_DIVINE_POWER: {
              // Divine Power scrolls cannot be scribed.
              FloatingTextStringOnCreature("Divine Power cannot be cast from a scroll.", OBJECT_SELF, FALSE);
              gsSPSetOverrideSpell();
              SetModuleOverrideSpellScriptFinished();
              return;
            }
          }

          if (fRequired > 0.0) {
            if (fPiety >= fRequired)
            {
                gsWOAdjustPiety(OBJECT_SELF, -fRequired, FALSE);
            }
            else
            {
              FloatingTextStringOnCreature("You are not pious enough for " + sDeity + " to grant you that spell now.", OBJECT_SELF, FALSE);
              gsSPSetOverrideSpell();
              SetModuleOverrideSpellScriptFinished();
              return;
            }
          }

        }
      }
    }

    // spell is being cast, so log it in the divination system.
    if (nSchool == SPELL_SCHOOL_NECROMANCY) 
    {
      miDVGivePoints(OBJECT_SELF, ELEMENT_DEATH, 3.0);
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
    }
	else if (nSchool == SPELL_SCHOOL_CONJURATION) // Conjuration
    {
      miDVGivePoints(OBJECT_SELF, ELEMENT_LIFE, 3.0);
		  
      switch (nSpell)
      {
        case SPELL_CURE_CRITICAL_WOUNDS:
        case SPELL_CURE_LIGHT_WOUNDS:
        case SPELL_CURE_MINOR_WOUNDS:
        case SPELL_CURE_MODERATE_WOUNDS:
        case SPELL_CURE_SERIOUS_WOUNDS:
        case SPELL_HEAL:
        case SPELL_HEALING_CIRCLE:
        case SPELL_HEALING_STING:
        case SPELL_MASS_HEAL:
        case SPELL_MONSTROUS_REGENERATION:
        case SPELL_REGENERATE:
          gsWOGiveSpellPiety(OBJECT_SELF, TRUE);
          break;
        default:
          gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
          break;
      }
    }
	else if (nSchool == SPELL_SCHOOL_EVOCATION) // Evocation
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_FIRE, 3.0);
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
	}
	else if (nSchool == SPELL_SCHOOL_ENCHANTMENT) // Enchantment
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_EARTH, 3.0);
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
	}
	else if (nSchool == SPELL_SCHOOL_TRANSMUTATION) // Transmutation
	{
      miDVGivePoints(OBJECT_SELF, ELEMENT_WATER, 3.0);
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);	
	}
	else if (nSchool == SPELL_SCHOOL_ILLUSION) // Illusion
	{
	  miDVGivePoints(OBJECT_SELF, ELEMENT_AIR, 3.0);
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
	}
	else
	{
	  // School is Abjuration or Divination - no elemental alignment. 
      gsWOGiveSpellPiety(OBJECT_SELF, FALSE);
	}

    //spell information
    gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
    gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
    gsSPSetSpellCallback();

    // Allow override of any spell script by setting a SPELL_OVERRIDE_X string on the creature
    // where X is the spell Id, and the string is the name of the script to be fired.
    if(GetSpellOverride())
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }
}
