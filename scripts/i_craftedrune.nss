// i_craftedrune
// Item activation script for crafted runes.
// Make sure to set local string "runecraft"
// to "art", "tailoring", "forging", "carpentry", or "blade"
// and local int "runequality"
// 1 = Lesser, 2 = Greater, 3 = Masterwork

#include "x3_inc_string"
#include "gs_inc_language"

// ---------------------------------------------------------
// Checks whether the PC knows the language in question
int runeKnowsLanguage(int nLanguage, object oPC)
{
    if (gsLAGetLanguageProgress(nLanguage, oPC) >= 0.99)
        return TRUE;

    return FALSE;
}

// ---------------------------------------------------------
// Adds a rune of the given language to an item
void runeAddRuneToObject(int nLanguage, object oItem)
{

    SetLocalInt(oItem, "RUNIC", 1);
    SetLocalInt(oItem, "RUNIC_LANGUAGE", nLanguage + 1);

    // Runic items have blue names because those are mystical.  Apparently.
    SetName(oItem, StringToRGBString(GetName(oItem), "339"));

    // Track that this object has been rune-infused.
    SetLocalInt(oItem, "RUNIC_INFUSED", 1);

}

// ---------------------------------------------------------
// Counts up the applicable properties on an item
int runeCountProperties(object oItem)
{
    int nReturn = 0;
    itemproperty ipCurrent = GetFirstItemProperty(oItem);
    int bExclude;
    while (GetIsItemPropertyValid(ipCurrent))
    {
        bExclude = FALSE;
        // We are excluding negative properties, weight and material properties, restrictions, and light/visual properties.
        // Also excluding Mighty and spell use properties.
        if (GetItemPropertyDurationType(ipCurrent) != DURATION_TYPE_PERMANENT ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_ABILITY_SCORE ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_AC ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_DAMAGE ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_SAVING_THROWS ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_LIGHT ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_MATERIAL ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_NO_DAMAGE ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_QUALITY ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_VISUALEFFECT ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_MIGHTY ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_WEIGHT_INCREASE ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_CAST_SPELL)
        {
            bExclude = TRUE;
        }
		
        // Exclude saving throw bonuses that aren't universal.  (fear, acid, etc.)
        if ((GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_SAVING_THROW_BONUS  &&
            GetItemPropertySubType(ipCurrent) >= 1) ||
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
        {
            bExclude = TRUE;
        }

        // Exclude arcane spell failure, so long as the arcane spell failure adjustment is positive.
        if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE &&
            GetItemPropertyCostTableValue(ipCurrent) >= 10)
        {
            bExclude = TRUE;
        }

        // Exclude 5/- Elemental Resists, likely from essences.
        if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DAMAGE_RESISTANCE &&
            GetItemPropertySubType(ipCurrent) > 5 &&
            GetItemPropertyCostTableValue(ipCurrent) < 2)
        {
            bExclude = TRUE;
        }


        if (!bExclude)
            nReturn++;

        // Add to the count if the item has a damage property
        if (GetItemPropertyDurationType(ipCurrent) == DURATION_TYPE_PERMANENT &&
            GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_DAMAGE_BONUS &&
            GetBaseItemType(oItem) != BASE_ITEM_LONGBOW &&
            GetBaseItemType(oItem) != BASE_ITEM_SHORTBOW &&
            GetBaseItemType(oItem) != BASE_ITEM_LIGHTCROSSBOW &&
            GetBaseItemType(oItem) != BASE_ITEM_HEAVYCROSSBOW)
        {
            // +2 if the damage property is >4. +1 if less.
            if (GetItemPropertyCostTableValue(ipCurrent) > 5)
                nReturn += 2;
            else
                nReturn += 1;
        }

        ipCurrent = GetNextItemProperty(oItem);
    }

    // Get specific item adjustments.
    string sRef = GetResRef(oItem);
    if (sRef == "it_silkshirt") nReturn -= 3; // Fine Silk Shirt
    if (sRef == "jjsilkshirt") nReturn -= 3; // Enchanted Fine Silk Shirt
    if (sRef == "co_assassincloth") nReturn -= 2; // Murderer's Raiment
    if (sRef == "jjfineelvenboots") nReturn -= 2; // Fine Elven Boots
    if (sRef == "co_guardarmor") nReturn -= 2; // Guard Armor heavy plate
    if (sRef == "co_grsorcstaf") nReturn -= 1; // Staff of Arcane Locus
    if (sRef == "co_huntstaff") nReturn -= 2; // Icon of the Hunt
    if (sRef == "nxt_rngr01") nReturn -= 1; // Ranger Runic Studded
    if (sRef == "gs_item869") nReturn += 1; // Adamantine Helm
	if (sRef == "gs_item845") nReturn += 1; // Adamantine Armor
	if (sRef == "gs_item865") nReturn += 1; // Adamantine Shield
	
    return nReturn;
}

// ---------------------------------------------------------


void main()
{
    // Targeted Item Activation Script
    object oPC          = GetItemActivator();
    object oItem        = GetItemActivatedTarget();
    location lLocation  = GetItemActivatedTargetLocation();
    object oRune       = GetItemActivated();

    string sType = GetStringLowerCase(GetLocalString(oRune, "runecraft"));
    int nQuality = GetLocalInt(oRune, "runequality");

    // Applicable to items only
    if (oItem == OBJECT_INVALID || GetObjectType(oItem) != OBJECT_TYPE_ITEM)
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be used on an item.");
        return;
    }

    if (GetLocalInt(oItem, "RUNIC"))
    {
        SendMessageToPC(oPC, GetName(oRune) + " cannot be used on an item that has an existing rune.");
        return;
    }

    if (GetLocalInt(oItem, "RUNIC_INFUSED"))
    {
        SendMessageToPC(oPC, GetName(oItem) + " has already been infused with a crafted rune.  It may not be infused again.");
        return;
    }

    if (GetItemStackSize(oRune) != 1)
    {
        SendMessageToPC(oPC, GetName(oRune) + " may not be used while stacked.");
        return;
    }

    if (GetItemStackSize(oItem) != 1)
    {
        SendMessageToPC(oPC, GetName(oRune) + " may not be used on stacked items.");
        return;
    }

    if (GetLocalInt(oItem, "gvd_artifact_legacy"))
    {
        SendMessageToPC(oPC, "Artefacts may not be infused with a crafted rune.");
        return;
    }

    // Ensure the rune is being applied to the appropriate category of items
    if (sType == "art" && (GetBaseItemType(oItem) != BASE_ITEM_AMULET &&
                           GetBaseItemType(oItem) != BASE_ITEM_RING &&
                           GetBaseItemType(oItem) != BASE_ITEM_HELMET &&
                           GetBaseItemType(oItem) != BASE_ITEM_BRACER))
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be applied to a ring, an amulet, a helmet, or bracers.");
        return;
    }
    if (sType == "tailoring" && (GetBaseItemType(oItem) != BASE_ITEM_BOOTS &&
                                 GetBaseItemType(oItem) != BASE_ITEM_BELT &&
                                 GetBaseItemType(oItem) != BASE_ITEM_GLOVES &&
                                 GetBaseItemType(oItem) != BASE_ITEM_CLOAK &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SLING &&
                                 GetBaseItemType(oItem) != BASE_ITEM_WHIP &&
                                 GetBaseItemType(oItem) != BASE_ITEM_ARMOR))
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be applied to boots, a belt, gloves, a cloak, a sling, a whip, or armor.");
        return;
    }
    if (sType == "carpentry" && (GetBaseItemType(oItem) != BASE_ITEM_LARGESHIELD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SMALLSHIELD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_TOWERSHIELD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SHORTBOW &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LONGBOW &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LIGHTCROSSBOW &&
                                 GetBaseItemType(oItem) != BASE_ITEM_HEAVYCROSSBOW &&
                                 GetBaseItemType(oItem) != BASE_ITEM_CLUB &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SHORTSPEAR &&
                                 GetBaseItemType(oItem) != BASE_ITEM_QUARTERSTAFF &&
                                 GetBaseItemType(oItem) != BASE_ITEM_MAGICSTAFF))
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be applied to a shield, a bow, a club, a spear, a magic staff, or a quarterstaff.");
        return;
    }
    if (sType == "forging" && (GetBaseItemType(oItem) != BASE_ITEM_HELMET &&
                                 GetBaseItemType(oItem) != BASE_ITEM_BRACER &&
                                 GetBaseItemType(oItem) != BASE_ITEM_ARMOR &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LARGESHIELD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_TOWERSHIELD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SMALLSHIELD))
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be applied to a helmet, bracers, armor, or a shield.");
        return;
    }
    if (sType == "blade" && (GetBaseItemType(oItem) != BASE_ITEM_BASTARDSWORD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_BATTLEAXE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_DAGGER &&
                                 GetBaseItemType(oItem) != BASE_ITEM_DIREMACE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_DOUBLEAXE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_DWARVENWARAXE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_GREATAXE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_GREATSWORD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_HALBERD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_HANDAXE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_KAMA &&
                                 GetBaseItemType(oItem) != BASE_ITEM_KATANA &&
                                 GetBaseItemType(oItem) != BASE_ITEM_KUKRI &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LIGHTFLAIL &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LIGHTHAMMER &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LIGHTMACE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_LONGSWORD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_MORNINGSTAR &&
                                 GetBaseItemType(oItem) != BASE_ITEM_RAPIER &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SCIMITAR &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SCYTHE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SHORTSWORD &&
                                 GetBaseItemType(oItem) != BASE_ITEM_SICKLE &&
                                 GetBaseItemType(oItem) != BASE_ITEM_TRIDENT &&
                                 GetBaseItemType(oItem) != BASE_ITEM_WARHAMMER))
    {
        SendMessageToPC(oPC, GetName(oRune) + " must be applied to melee weapon that is not a whip, club, spear, magic staff, or quarterstaff.");
        return;
    }

    // Improperly set up rune.
    if (sType != "art" && sType != "tailoring" && sType != "carpentry" && sType != "forging" && sType != "blade")
    {
        SendMessageToPC(oPC, "Something is odd about " + GetName(oRune) + ".  It will not function.");
        return;
    }

    int nProperties = runeCountProperties(oItem);

    // Quality: 1 = lesser, 2 = greater, 3 = masterwork
    // Lesser = 2 properties or fewer
    // Greater = 3 properties or fewer
    // Masterwork = 4 properties or fewer

    if ((nQuality < 2 && nProperties > 2) || (nQuality == 2 && nProperties > 3) || (nQuality > 2 && nProperties > 4))
    {
        SendMessageToPC(oPC, GetName(oItem) + " is too heavily enchanted for you to be able to safely apply this crafted rune to it.  You must seek a less-enchanted item, or a more powerful rune.");
        if (GetIsDM(oPC)) SendMessageToPC(oPC, "DM DEBUGGING: " + IntToString(nProperties) + " properties.");
        return;
    }

    int nLanguage = GetLocalInt(oPC, "CHAT_LANGUAGE");

    if (nLanguage > 0 && !runeKnowsLanguage(nLanguage, oPC))
    {
        SendMessageToPC(oPC, "You do not know " + gsLAGetLanguageColor(nLanguage) + gsLAGetLanguageName(nLanguage) + "</c> well enough to use it as the basis of a magical rune.");
        return;
    }

    // See if the language spoken fits into the runic possibilities.
    if (nLanguage > 0 && nLanguage != GS_LA_LANGUAGE_ELVEN &&
                         nLanguage != GS_LA_LANGUAGE_DWARVEN &&
                         nLanguage != GS_LA_LANGUAGE_DRACONIC &&
                         nLanguage != GS_LA_LANGUAGE_ABYSSAL &&
                         nLanguage != GS_LA_LANGUAGE_CELESTIAL &&
                         nLanguage != GS_LA_LANGUAGE_INFERNAL)
    {
        SendMessageToPC(oPC, "As far as you are aware, you can not use " + gsLAGetLanguageColor(nLanguage) + gsLAGetLanguageName(nLanguage) + " as the basis of a magical rune.");
        return;
    }

    int nConfirmLang = GetLocalInt(oRune, "confirmation_language");
    object oConfirmObj = GetLocalObject(oRune, "confirmation_target");

    string sText;
    if (nLanguage < 2)
        sText = StringToRGBString("an arcane", "339");
    else if (nLanguage == GS_LA_LANGUAGE_ELVEN || nLanguage == GS_LA_LANGUAGE_ABYSSAL || nLanguage == GS_LA_LANGUAGE_INFERNAL)
        sText = "an " + gsLAGetLanguageColor(nLanguage) + gsLAGetLanguageName(nLanguage);
    else
        sText = "a " + gsLAGetLanguageColor(nLanguage) + gsLAGetLanguageName(nLanguage);

    // We've already confirmed this action.
    if (nConfirmLang == nLanguage && oConfirmObj == oItem) {
        effect eVis;

        if (nQuality < 2)
            eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
        else if (nQuality == 2)
            eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
        else
            eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);

        runeAddRuneToObject(nLanguage, oItem);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        SendMessageToPC(oPC, "After uttering the activation words, you have infused " + GetName(oItem) + " with " + sText + " rune.");
        DelayCommand(0.1, DestroyObject(oRune));
    } else {
        SendMessageToPC(oPC, "Use " + GetName(oRune) + " on " + GetName(oItem) + " again to CONFIRM that you wish to add " + sText + " rune.");
        SendMessageToPC(oPC, "If you wish to add a different type of rune, change your language via console command.");
        SetLocalInt(oRune, "confirmation_language", nLanguage);
        SetLocalObject(oRune, "confirmation_target", oItem);
    }
}
