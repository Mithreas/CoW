#include "inc_backgrounds"
#include "inc_bonuses"
#include "inc_checker"
#include "inc_class"
#include "inc_common"
#include "inc_paladin"
#include "inc_pc"
#include "inc_spellsword"
#include "inc_subrace"
#include "inc_text"
#include "inc_totem"
#include "x0_i0_match"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

void main()
{
    object oPC         = GetPCLevellingUp();
    object oPermission = OBJECT_INVALID;
    object oHide       = gsPCGetCreatureHide(oPC);
    string sString     = "";
    string sPath       = GetLocalString(oHide, "MI_PATH");
    int nLevel         = GetHitDice(oPC);
    int nXP            = GetXP(oPC);
    int nXPLevel       = nLevel * (nLevel - 1) / 2 * 1000;
    int nClassType     = 0;
    int nClassLevel    = 0;
    int nRequiredLevel = GetLocalInt(GetModule(), "GS_REQUIRED_LEVEL_PER_CLASS");
    int nNth           = 0;
    int bLawful        = FALSE;
    int bNonLawful     = FALSE;
    int bEvil          = FALSE;
    int bNonEvil       = FALSE;
    int bGood          = FALSE;
    int bNonGood       = FALSE;
    int bNeutral       = FALSE;
    int bStaticLevel   = GetLocalInt(GetModule(), "STATIC_LEVEL");
    int nFeat;

	// Allowed classes.
	if (!CoW_HasAllowedClasses(oPC))
	{
        SetXP(oPC, nXPLevel - 1);
        gsPCMemorizeClassData(oPC);
        DelayCommand(0.5, SetXP(oPC, nXP));
		
        FloatingTextStringOnCreature(
                "Sorry, your race is currently not allowed to take that class.",
                oPC,
                FALSE);
	}
	
	// Effective level.
	int nFLLevel = GetLocalInt(oHide, "FL_LEVEL");
	if (!nFLLevel) nFLLevel = GetHitDice(oPC);
	else         nFLLevel += 1;
	SetLocalInt(oHide, "FL_LEVEL", nFLLevel);
	
    //required level
    for (nNth = 1; !bStaticLevel && nNth <= 3; nNth++)
    {
        nClassType  = GetClassByPosition(nNth, oPC);
        if (nClassType == CLASS_TYPE_INVALID) break;
        nClassLevel = GetLevelByClass(nClassType, oPC);

        if (nClassLevel < nRequiredLevel)
        {
            if (nClassLevel > gsPCGetMemorizedClassLevel(nNth, oPC))
            {
              // Character just levelled up in this class.  That's OK unless
              // they're level 29 and have taken 1 level in a class, or 30 and
              // have taken 1 or 2.
              if (GetHitDice(oPC) - nClassLevel <= 27)
              {
                break;
              }
            }

            SetXP(oPC, nXPLevel - 1);
            gsPCMemorizeClassData(oPC);
            DelayCommand(0.5, SetXP(oPC, nXP));

            switch (nNth)
            {
            case 1: sString = GS_T_16777450; break;
            case 2: sString = GS_T_16777451; break;
            case 3: sString = GS_T_16777452; break;
            }

            FloatingTextStringOnCreature(
                gsCMReplaceString(
                    GS_T_16777449,
                    IntToString(nRequiredLevel),
                    sString),
                oPC,
                FALSE);
            return;
        }
    }

   // Kensai.
    if (GetLocalInt(oHide, "KENSAI"))
    {
      if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
          GetLevelByClass(CLASS_TYPE_DRUID, oPC) ||
          GetLevelByClass(CLASS_TYPE_CLERIC, oPC) ||
          GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
          GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) ||
          GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
      {
        SendMessageToPC(oPC, "A kensai cannot take levels in the sorcerer, druid, bard, favoured soul, cleric or wizard classes.");
        SetXP(oPC, nXPLevel - 1);
        DelayCommand(0.5, SetXP(oPC, nXP));
      }
    }

     //Dwarves get dwarven waraxe feats for free with any taken battle axe feat
     if (GetRacialType(oPC) == RACIAL_TYPE_DWARF) {
       if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE, oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_WEAPON_FOCUS_DWAXE);
       }
       if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE, oPC) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_DWAXE);
       }
       if (GetHasFeat(FEAT_IMPROVED_CRITICAL_BATTLE_AXE, oPC) && !GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_IMPROVED_CRITICAL_DWAXE);
       }
       if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE, oPC) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_EPIC_WEAPON_FOCUS_DWAXE);
       }
       if (GetHasFeat(FEAT_WEAPON_OF_CHOICE_BATTLEAXE, oPC) && !GetHasFeat(FEAT_WEAPON_OF_CHOICE_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_WEAPON_OF_CHOICE_DWAXE);
       }
       if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE, oPC) && !GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_WEAPON_SPECIALIZATION_DWAXE);
       }
       if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE, oPC) && !GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE);
       }
       if (GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE, oPC) && !GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE, oPC)) {
         AddKnownFeat(oPC, FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE);
       }
    }

    // Healer
    if (sPath == "Path of the Healer")
    {
      if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_HEAVY);
      if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_LIGHT);
      if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_ARMOR_PROFICIENCY_MEDIUM);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_DRUID);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_EXOTIC);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_MARTIAL);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_MONK);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_ROGUE);
      if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_WIZARD, oPC)) NWNX_Creature_RemoveFeat(oPC, FEAT_WEAPON_PROFICIENCY_WIZARD);
    }

    //Spellsword
    if (miSSGetIsSpellsword(oPC))
    {
        miSSMWPFeat(oPC);
    }	

    //devastating critical
    if (GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD,   oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CLUB,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DART,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW,  oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KAMA,           oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KATANA,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW,  oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF,   oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD,     oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN,       oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE,         oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SLING,          oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE,    oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD, oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED,        oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER,      oPC) ||
        GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WHIP,           oPC))
    {
        SetXP(oPC, nXPLevel - 1);
        gsPCMemorizeClassData(oPC);
        DelayCommand(0.5, SetXP(oPC, nXP));

        FloatingTextStringOnCreature(GS_T_16777431, oPC, FALSE);
        return;
    }

    //prestige class
    if (!bStaticLevel) {
    for (nNth = 1; nNth <= 3; nNth++)
    {
        nClassType = GetClassByPosition(nNth, oPC);

        if (nClassType == CLASS_TYPE_INVALID) break;

        switch (nClassType)
        {
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_DIVINE_CHAMPION:
        case CLASS_TYPE_DWARVEN_DEFENDER:
        case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_WEAPON_MASTER:
          break;  // Removed restrictions on the above PrCs.
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_DRAGON_DISCIPLE:
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_PALE_MASTER:
        case CLASS_TYPE_SHIFTER:
            if (gsPCGetMemorizedClassType(nNth, oPC) != nClassType)
            {
                if (! GetHasPermission(nClassType, oPC))
                {
                    SetXP(oPC, nXPLevel - 1);
                    gsPCMemorizeClassData(oPC);
                    DelayCommand(0.5, SetXP(oPC, nXP));

                    FloatingTextStringOnCreature(GS_T_16777326, oPC, FALSE);
                    return;
                }
            }

        default:
            continue;
        }

        break;
    }
    }

    if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {
        SetXP(oPC, nXPLevel - 1);
        gsPCMemorizeClassData(oPC);
        DelayCommand(0.5, SetXP(oPC, nXP));

        FloatingTextStringOnCreature("You cannot level up while polymorphed.", oPC, FALSE);
        return;
    }

    // Paladin
    if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC)) {
        palOnLevelCheck(oPC);
    }

    // Ensure totem-granted epic druid feats are still qualified for.
    if (GetLocalInt(oHide, "DRAGONSHAPE_TOTEM_RECIPIENT")) {
        if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) < 25 || GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < 25)
        {
            // We no longer qualify!
            nFeat = GetLocalInt(oHide, "DRAGONSHAPE_TOTEM_RECIPIENT") || FEAT_EPIC_WILD_SHAPE_DRAGON;
            NWNX_Creature_RemoveFeat(oPC, nFeat);
            DeleteLocalInt(oHide, "DRAGONSHAPE_TOTEM_RECIPIENT");
            FloatingTextStringOnCreature("You have lost the boon granted by the draconic totem.", oPC, FALSE);
        }
    }

	// log the choosing of dragonshape feat, so we can compare that to relevels in the logs
     if (GetLocalInt(oHide, "GVD_DRAGONSHAPE_FEAT_CHECK") == 2) {
       if (GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, oPC)) {
         // releveled PC, add the choosing of this feat in the logs, so we know the PC took it again
         WriteTimestampedLogEntry("DRAGONSHAPER CHECK: PC " + GetName(oPC) + ", level " + IntToString(GetHitDice(oPC)) + " took the Dragonshape feat.");
         DeleteLocalInt(oHide, "GVD_DRAGONSHAPE_FEAT_CHECK");
       }
     }
     // check class compositions for -relevelled characters and log them
     if(GetHitDice(oPC) == GetLocalInt(oHide, "RELEVEL_PREVIOUS_LEVEL"))
     {
         string sFormerClassComposition = GetLocalString(oHide, "RELEVEL_CLASS_COMPOSITION");
         string sClassComposition = "Class 1: " + gvd_GetArelithClassNameByPosition(1, oPC) + "(" + IntToString(GetLevelByPosition(1, oPC)) + ")" + "; Class 2: " + gvd_GetArelithClassNameByPosition(2, oPC) + "(" + IntToString(GetLevelByPosition(2, oPC)) + ")" + "; Class 3: " + gvd_GetArelithClassNameByPosition(3, oPC) + "(" + IntToString(GetLevelByPosition(3, oPC)) + ")";
 
         DeleteLocalInt(oHide, "RELEVEL_PREVIOUS_LEVEL");
         DeleteLocalString(oHide, "RELEVEL_CLASS_COMPOSITION");
 
         if(sFormerClassComposition != sClassComposition)
         {
             WriteTimestampedLogEntry("RELEVEL -- CLASS COMPOSITION CHANGE FOLLOWING RELEVEL FOR PC " + GetName(oPC) + ". OLD CLASSES: <" + sFormerClassComposition + "> NEW CLASSES: <" + sClassComposition + ">");
         }
    }

    ApplyCharacterBonuses(oPC, TRUE);

    miCLOverridePRC(oPC);

	//::Kirito Remove SkillPoint Pool
	SetLocalInt(oHide, "SkillPointPool", 0);
	
    gsPCMemorizeClassData(oPC);

    // dunshine: store class data in db
    gvd_UpdateArelithClassesInDB(oPC);

    SendMessageToAllDMs(
        gsCMReplaceString(
            GS_T_16777325,
            GetName(oPC),
            IntToString(nLevel)));
}
