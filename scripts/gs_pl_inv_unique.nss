// 12/11/2017 Replacing artefact system with crafted runes.
/*
1-25:  Runic Catalyst Material
26-40: Bejeweld Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
41-55: Woven Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
56-70: Forged Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
71-85: Etched Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
86-95: Other Material (Secondary Roll:  50% Random Elkstone, 25% Star Sapphire, 25% Mithril Dust)
96-100: Blade Rune Material (Secondary Roll: 80% Lesser, 15% Greater, 5% Masterwork material)
*/

#include "inc_common"
#include "inc_time"

// const int GS_LIMIT_GOLD = 5000;


void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED"))      return;
    if (GetIsObjectValid(GetFirstItemInInventory())) return;
    int nOpened       = ! GetIsObjectValid(GetLastKiller());
    object oDiscoverer = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    object oHide = gsPCGetCreatureHide(oDiscoverer);
    // object oDestroyer = GetLastKiller();

    // Adding in 18 hour check for the same discoverer discovering a rune material.
    if (gsTIGetActualTimestamp() - GetLocalInt(oHide, "nTimestampArtefact") < 64800)
    {
        if (nOpened)
        {
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
            DelayCommand(10800.0 + IntToFloat(Random(10800)), DeleteLocalInt(OBJECT_SELF, "GS_ENABLED"));
        } else {
            gsCMCreateRecreator(10800 + Random(10800));
        }
        return;
    }
    // Random start.  Wait for 3-6 hours if we don't trigger now.
    if (d3() == 1)
    {
        if (nOpened)
        {
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
            DelayCommand(10800.0 + IntToFloat(Random(10800)), DeleteLocalInt(OBJECT_SELF, "GS_ENABLED"));
        } else {
            gsCMCreateRecreator(10800 + Random(10800));
        }
        return;
    }

    SetLocalInt(oHide, "nTimestampArtefact", gsTIGetActualTimestamp());
    // Cycle through and give everyone in the party this same time stamp.
    object oPartyMember = GetFirstFactionMember(oDiscoverer, TRUE);

    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
        oHide = gsPCGetCreatureHide(oPartyMember);
        SetLocalInt(oHide, "nTimestampArtefact", gsTIGetActualTimestamp());
        oPartyMember = GetNextFactionMember(oDiscoverer, TRUE);
    }

    // If opened, will regenerate a new object in 3-6 hours.
    if (nOpened)
    {
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
        DelayCommand(10800.0 + IntToFloat(Random(10800)), DeleteLocalInt(OBJECT_SELF, "GS_ENABLED"));
    }


    int nPrimaryRoll = d100();
    int nSecondaryRoll = d100();
    string sResRef;

    // Add gold
    gsCMCreateGold(Random(1000));


    if (nPrimaryRoll < 26)  //1-25:  Runic Catalyst Material
    {
        sResRef = "euklian";
    }
    else if (nPrimaryRoll < 41 && nPrimaryRoll > 25) // 26-40: Bejeweled Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
    {
        if (nSecondaryRoll < 61)
            sResRef = "theurglass_s";
        else if (nSecondaryRoll < 91)
            sResRef = "theurglass_m";
        else if (nSecondaryRoll > 90)
            sResRef = "theurglass_l";
    }
    else if (nPrimaryRoll < 56 && nPrimaryRoll > 40) // 41-55: Woven Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
    {
        if (nSecondaryRoll < 61)
            sResRef = "djinnuther_s";
        else if (nSecondaryRoll < 91)
            sResRef = "djinnuther_m";
        else if (nSecondaryRoll > 90)
            sResRef = "djinnuther_l";
    }
    else if (nPrimaryRoll < 71 && nPrimaryRoll > 55) // 56-70: Forged Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
    {
        if (nSecondaryRoll < 61)
            sResRef = "chardalyn_s";
        else if (nSecondaryRoll < 91)
            sResRef = "chardalyn_m";
        else if (nSecondaryRoll > 90)
            sResRef = "chardalyn_l";
    }
    else if (nPrimaryRoll < 86 && nPrimaryRoll > 70) // 71-85: Etched Rune Material  (Secondary Roll: 60% Lesser, 30% Greater, 10% Masterwork material)
    {
        if (nSecondaryRoll < 61)
            sResRef = "blueleaf_s";
        else if (nSecondaryRoll < 91)
            sResRef = "blueleaf_m";
        else if (nSecondaryRoll > 90)
            sResRef = "blueleaf_l";
    }
    else if (nPrimaryRoll < 96 && nPrimaryRoll > 85) // 86-95: Other Material (Secondary Roll:  50% Random Elkstone, 25% Star Sapphire, 25% Mithril Dust)
    {
        if (nSecondaryRoll < 51)
        {
            if (d2() == 1)
                sResRef = "ar_item_rogsto";
            else
                sResRef = "ar_item_beljur";
        }
        else if (nSecondaryRoll < 76)
            sResRef = "ar_item_stsaph";
        else if (nSecondaryRoll > 75)
            sResRef = "ar_it_mithrildus";
    }
    else if (nPrimaryRoll < 101 && nPrimaryRoll > 95) // Blade Rune Material (Secondary Roll: 80% Lesser, 15% Greater, 5% Masterwork material)
    {
        if (nSecondaryRoll < 81)
            sResRef = "zardazik_s";
        else if (nSecondaryRoll < 96)
            sResRef = "zardazik_m";
        else if (nSecondaryRoll > 95)
            sResRef = "zardazik_l";
    }

    object oItem = CreateItemOnObject(sResRef);

    // Recreate object in 3-6 hours if bashed
    if (!nOpened) {
        gsCMCreateRecreator(10800 + Random(10800));
    }

}


/*// Utility method to return a basic object of that type.
string _GetResRefByItemType(int nItemType)
{
  switch (nItemType)
  {
    case BASE_ITEM_AMULET:
      return "gs_item209";
    case BASE_ITEM_ARMOR:
    {
      switch (d4())
      {
        case 1:
          return "nw_cloth027";
        case 2:
          return "nw_aarcl001";
        case 3:
          return "nw_aarcl003";
        case 4:
          return "nw_aarcl007";
      }
    }
    case BASE_ITEM_BASTARDSWORD:
      return "nw_wswbs001";
    case BASE_ITEM_BATTLEAXE:
      return "nw_waxbt001";
    case BASE_ITEM_BELT:
      return "gs_item258";
    case BASE_ITEM_BOOTS:
      return "gs_item311";
    case BASE_ITEM_BRACER:
      return "gs_item270";
    case BASE_ITEM_CLOAK:
      return "gs_item284";
    case BASE_ITEM_CLUB:
      return "nw_wblcl001";
    case BASE_ITEM_DAGGER:
      return "nw_wswdg001";
    case BASE_ITEM_DIREMACE:
      return "nw_wdbma001";
    case BASE_ITEM_DOUBLEAXE:
      return "nw_wdbax001";
    case BASE_ITEM_DWARVENWARAXE:
      return "x2_wdwraxe001";
    case BASE_ITEM_GLOVES:
      return "gs_item294";
    case BASE_ITEM_GREATAXE:
      return "nw_waxgr001";
    case BASE_ITEM_GREATSWORD:
      return "nw_wswgs001";
    case BASE_ITEM_HALBERD:
      return "nw_wplhb001";
    case BASE_ITEM_HANDAXE:
      return "nw_waxhn001";
    case BASE_ITEM_HEAVYCROSSBOW:
      return "nw_wbwxh001";
    case BASE_ITEM_HEAVYFLAIL:
      return "nw_wblfh001";
    case BASE_ITEM_HELMET:
      return "x2_it_arhelm03";
    case BASE_ITEM_KAMA:
      return "nw_wspka001";
    case BASE_ITEM_KATANA:
      return "nw_wswka001";
    case BASE_ITEM_KUKRI:
      return "nw_wspku001";
    case BASE_ITEM_LARGESHIELD:
      return "nw_ashlw001";
    case BASE_ITEM_LIGHTCROSSBOW:
      return "nw_wbwxl001";
    case BASE_ITEM_LIGHTFLAIL:
      return "nw_wblfl001";
    case BASE_ITEM_LIGHTHAMMER:
      return "nw_wblhl001";
    case BASE_ITEM_LIGHTMACE:
      return "nw_wblml001";
    case BASE_ITEM_LONGBOW:
      return "nw_wbwln001";
    case BASE_ITEM_LONGSWORD:
      return "nw_wswls001";
    case BASE_ITEM_MORNINGSTAR:
      return "nw_wblms001";
    case BASE_ITEM_QUARTERSTAFF:
      return "nw_wdbqs001";
    case BASE_ITEM_RAPIER:
      return "nw_wswrp001";
    case BASE_ITEM_RING:
      return "gs_item252";
    case BASE_ITEM_SCIMITAR:
      return "nw_wswsc001";
    case BASE_ITEM_SCYTHE:
      return "nw_wplsc001";
    case BASE_ITEM_SHORTBOW:
      return "nw_wbwsh001";
    case BASE_ITEM_SHORTSPEAR:
      return "nw_wplss001";
    case BASE_ITEM_SHORTSWORD:
      return "nw_wswss001";
    case BASE_ITEM_SICKLE:
      return "nw_wspsc001";
    case BASE_ITEM_SLING:
      return "nw_wbwsl001";
    case BASE_ITEM_SMALLSHIELD:
      return "nw_ashsw001";
    case BASE_ITEM_TOWERSHIELD:
      return "nw_ashto001";
    case BASE_ITEM_TRIDENT:
      return "nw_wpltr001";
    case BASE_ITEM_TWOBLADEDSWORD:
      return "nw_wdbsw001";
    case BASE_ITEM_WARHAMMER:
      return "nw_wblhw001";
    case BASE_ITEM_WHIP:
      return "x2_it_wpwhip";
  }

  return "";
}
*/


/*
    // Random start.  Wait for 3 hours if we don't trigger now.
    if (d4() != 4)
    {
       if (nOpened)
       {
         SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
         DelayCommand(10800.0, DeleteLocalInt(OBJECT_SELF, "GS_ENABLED"));
       }

       return;
    }


    // Batra: Anti-farming. 24-hr timeout w/ epoch check written by Dunshine.
    object oModule = GetModule();
    int nTimestamp = GetLocalInt(oModule, "GS_TIMESTAMP");
    int nTimestampArtefact = GetLocalInt(oHide,"nTimestampArtefact");

    // If the character has discovered an artefact within the past real 24 hours,
    // run the default treasure script (which will assume _HIGH treasure).
    if (((nTimestamp - nTimestampArtefact) < 864000) || (nTimestampArtefact > nTimestamp))
    {
        ExecuteScript("gs_pl_inventory", OBJECT_SELF);
        return;
    }

    // If the character has NEVER discovered an artefact before, behave as normal.
    // If they have, there's a 50% chance the container will only give _HIGH loot.

    // Currently inactive.

    //if (GetLocalInt(oHide, "found_artefact") && d2() == 2)
    //{
    //    ExecuteScript("gs_pl_inventory", OBJECT_SELF);
    //    return;
    //}


    // Record that this character has discovered an artefact.
    SetLocalInt(oHide, "found_artefact", 1);

    // Record the timestamp at which the character last discovered an artefact.
    SetLocalInt(oHide, "found_artefact_last", nTimestamp);

    //create inventory
    string sTag       = GetTag(OBJECT_SELF);

    // Account for 1% chance of getting an artefact from _HIGH containers
    if (sTag == "GS_WEAPON_HIGH") sTag = "GS_WEAPON_UNIQUE";
    else if (sTag == "GS_TREASURE_HIGH") sTag = "GS_TREASURE_UNIQUE";
    else if (sTag == "GS_ARMOR_HIGH") sTag = "GS_ARMOR_UNIQUE";

    object oItem;
    int nItemType;
    int bRanged = FALSE;
    int bContinue = TRUE;
    string sResRef;
    int nNumProperties = d4();
    int nCount = 0;

    // Create a random item with random properties.
    if (sTag == "GS_WEAPON_UNIQUE")
    {
      // Base item type.
      while (bContinue)
      {
        bContinue = FALSE;
        nItemType = Random(62);

        switch (nItemType)
        {
          case 61: // sling
          case 11: //shortbow
          case 8: //longbow
          case 7:
          case 6: //crossbows
            bRanged = TRUE;
            break;
          case 14: // small shield
            nItemType = 95; // trident
            break;
          case 15: // torch
            nItemType = 108; // waraxe
            break;
          case 16: // armor
            nItemType = 111; // whip
            break;
          case 17: // helmet
          case 19: // amulet
          case 20: // arrow
          case 21: // belt
          case 23: // invalid
          case 24: // misc small
          case 25: // bolts
          case 26: // boots
          case 27: // bullets
          case 29: // misc med
          case 30: // invalid
          case 31: // dart
          case 24: // misc large
          case 36: // gloves
          case 39: // healers kit
          case 43: // invalid
          case 44: // rod
          case 46: // wand
          case 48: // invalid
          case 49: // potion
          case 52: // ring
          case 54: // invalid
          case 56: // large shield
          case 57: // tower shield
          case 59: // shuriken
          case BASE_ITEM_MAGICSTAFF:
           bContinue = TRUE;
           break;
        }
      }

      sResRef = _GetResRefByItemType (nItemType);
      oItem = CreateItemOnObject(sResRef);

      if (!GetIsObjectValid(oItem)) return;

      for (nCount = 0; nCount < nNumProperties; nCount++)
      {
        // Weapon properties:
        // +d4 enhancement
        // +d4 attack
        // +d6 enh vs race
        // +1 to d10 elemental damage
        // +d4 to an ability
        // +d10 to a skill
        // +d10 massive criticals
        // glowy appearance or freedom or fear immunity or light
        // unlimited ammo (if ranged) or vamp regen (if not)
        // usage restriction (class or alignment or race)

        switch (d10())
        {
          case 1:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(d4()), oItem);
            break;
          case 2:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(d4()), oItem);
            break;
          case 3:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsRace(Random(26), d6()), oItem);
            break;
          case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(d8() + 5, d10()), oItem);
            break;
          case 5:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(Random(6), d4()), oItem);
            break;
          case 6:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(Random(28), d10()), oItem);
            break;
          case 7:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(d10()), oItem);
            break;
          case 8:
          {
            switch (d4())
            {
              case 1:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(Random(7)), oItem);
                break;
              case 2:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyFreeAction(), oItem);
                break;
              case 3:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), oItem);
                break;
              case 4:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(d4(), Random(7)), oItem);
                break;
            }
            break;
          }
          case 9:
          {
            if (bRanged)
            {
              AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo(d3() + 10), oItem);
            }
            else
            {
              AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(d6()), oItem);
            }
            break;
          }
          case 10:
          {
            switch (d2())
            {
              case 1:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(Random(11)), oItem);
                break;
              case 2:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByRace(Random(7)), oItem);
                break;
            }
            break;
          }
        }
      }
    }
    else if (sTag == "GS_TREASURE_UNIQUE")
    {
      // Select item type.
      switch (d8())
      {
        case 1:
          nItemType = BASE_ITEM_AMULET;
          break;
        case 2:
          nItemType = BASE_ITEM_BELT;
          break;
        case 3:
          nItemType = BASE_ITEM_BRACER;
          break;
        case 4:
          nItemType = BASE_ITEM_CLOAK;
          break;
        case 5:
          nItemType = BASE_ITEM_GLOVES;
          break;
        case 6:
        case 7:
          nItemType = BASE_ITEM_RING;
          break;
        case 8:
          nItemType = BASE_ITEM_BOOTS;
          break;
      }

      sResRef = _GetResRefByItemType (nItemType);
      oItem = CreateItemOnObject(sResRef);

      if (!GetIsObjectValid(oItem)) return;

      // Properties for misc items
      // +d4 AC
      // +d6 AC vs race
      // +d2 save bonus
      // +d4 specific save bonus
      // 5/ to 20/ elemental damage resistance
      // +d2 to an ability
      // +d6 to a skill
      // usage restriction (class or alignment or race)

      for (nCount = 0; nCount < nNumProperties; nCount++)
      {
        switch (d8())
        {
          case 1:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(d4()), oItem);
            break;
          case 2:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsRace(Random(26),d6()), oItem);
            break;
          case 3:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, d2()), oItem);
            break;
          case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(d3(), d4()), oItem);
            break;
          case 5:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(d8() + 5, d4()), oItem);
            break;
          case 6:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(Random(6), d2()), oItem);
            break;
          case 7:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(Random(28), d6()), oItem);
            break;
          case 8:
          {
            switch (d2())
            {
              case 1:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(Random(11)), oItem);
                break;
              case 2:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByRace(Random(7)), oItem);
                break;
            }
            break;
          }
        }
      }
    }
    else if (sTag == "GS_ARMOR_UNIQUE")
    {
      // Select item type.
      switch (d8())
      {
        case 1:
        case 2:
        case 3:
        case 4:
          nItemType = BASE_ITEM_ARMOR;
          break;
        case 5:
          nItemType = BASE_ITEM_HELMET;
          break;
        case 6:
          nItemType = BASE_ITEM_SMALLSHIELD;
          break;
        case 7:
          nItemType = BASE_ITEM_LARGESHIELD;
          break;
        case 8:
          nItemType = BASE_ITEM_TOWERSHIELD;
          break;
      }

      sResRef = _GetResRefByItemType (nItemType);
      oItem = CreateItemOnObject(sResRef);

      if (!GetIsObjectValid(oItem)) return;

      // Properties for armor items
      // +d4 AC
      // +d6 AC vs race
      // +d4 save bonus
      // +d4 specific save bonus
      // 5/ to 20/ elemental damage resistance
      // +d4 to an ability
      // +d10 to a skill
      // usage restriction (class or alignment or race)

      for (nCount = 0; nCount < nNumProperties; nCount++)
      {
        switch (d8())
        {
          case 1:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(d4()), oItem);
            break;
          case 2:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsRace(Random(26),d6()), oItem);
            break;
          case 3:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, d4()), oItem);
            break;
          case 4:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(d3(), d4()), oItem);
            break;
          case 5:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(d8() + 5, d4()), oItem);
            break;
          case 6:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(Random(6), d4()), oItem);
            break;
          case 7:
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(Random(28), d10()), oItem);
            break;
          case 8:
          {
            switch (d2())
            {
              case 1:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(Random(11)), oItem);
                break;
              case 2:
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByRace(Random(7)), oItem);
                break;
            }
            break;
          }
        }
      }
    }

    SetName(oItem, "Artefact");
    string sArea = GetSubString(GetName(GetArea(OBJECT_SELF)), 0, FindSubString(GetName(GetArea(OBJECT_SELF)), "(") -1);
    SetDescription(oItem, "A curious artefact of unknown origin, discovered by " +
      GetName(oDiscoverer) + " in the " + sArea + ".");
    SetIdentified (oItem, FALSE);

        // Dunshine: added to be able to track these things down later
        SetLocalInt(oItem, "gvd_artifact_legacy_confirmed", 1);

    gsCMCreateGold(Random(1000));

    if (nOpened) SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
*/
