// mi_en_tres_use
//
// Each PC can use this once to get loot.  Will get tidied up by area cleanup
// scripts.
#include "gs_inc_common"
#include "gs_inc_treasure"
#include "gvd_inc_contain"
#include "inc_stacking"

//................................................................
// Copied this function from nw_i0_spells to avoid another include

float GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1)
{
    float fRandom = MaximumTime - fMinimumTime;
    if(fRandom < 0.0)
    {
        return 0.0;
    }
    else
    {
        int nRandom;
        nRandom = FloatToInt(fRandom  * 10.0);
        nRandom = Random(nRandom) + 1;
        fRandom = IntToFloat(nRandom);
        fRandom /= 10.0;
        return fRandom + fMinimumTime;
    }
}

//................................................................

int GetApplicableLore(object oPC)
{
    int nLoreSkill = GetSkillRank(SKILL_LORE,oPC, FALSE);

    // We're adding bardic knowledge.
    nLoreSkill += GetLevelByClass(CLASS_TYPE_BARD, oPC);

    // See if a party member has more lore.
    int nPartySkill;
    object oPartyMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oPartyMember))
    {
        nPartySkill = GetSkillRank(SKILL_LORE, oPartyMember, FALSE) + GetLevelByClass(CLASS_TYPE_BARD, oPartyMember);
        if (nPartySkill > nLoreSkill)
            nLoreSkill = nPartySkill;

        oPartyMember = GetNextFactionMember(oPC);
    }

    return nLoreSkill;

}
//................................................................

void identifyItems(object oCorpse, object oPC)
{

    object oItem = GetFirstItemInInventory(oCorpse);
    if (oItem == OBJECT_INVALID)
        return;

    int nLoreSkill = GetApplicableLore(oPC);
    if (nLoreSkill < 1)
        return;

    // max value that we can ID with this lore.  Add +1 to match skill to row #
    nLoreSkill++;
    string sMaxValue = Get2DAString("SkillVsItemCost", "DeviceCostMax", nLoreSkill);
    int nMaxValue = StringToInt(sMaxValue);

    // * Handle overflow
    if (sMaxValue == "")
    {
        nMaxValue = 120000000;
    }

    int nGPValue;
    while (GetIsObjectValid(oItem))
    {
        if (!GetIdentified(oItem)) {
            // gold value
            SetIdentified(oItem, TRUE);
            nGPValue = GetGoldPieceValue(oItem);
            SetIdentified(oItem, FALSE);

            // can identify this item
            if (nMaxValue >= nGPValue)
                SetIdentified(oItem, TRUE);
        }

        // next
        oItem = GetNextItemInInventory(oCorpse);
    }
}
//................................................................

void AutoLootItems(object oCorpse, object oPC)
{
    object oItem = GetFirstItemInInventory(oCorpse);
    if (oItem == OBJECT_INVALID)
        return;

    // Get our auto-loot settings from the player hide
    object oHide = gsPCGetCreatureHide(oPC);
    int bAutoGold = GetLocalInt(oHide, "AUTO_LOOT_GOLD");
    int bAutoJewelry = GetLocalInt(oHide, "AUTO_LOOT_JEWELRY");
    int bAutoHeads = GetLocalInt(oHide, "AUTO_LOOT_HEADS");
    int bAutoGems = GetLocalInt(oHide, "AUTO_LOOT_GEMS");
    int bAutoPotions = GetLocalInt(oHide, "AUTO_LOOT_POTIONS");
    int bAutoKits = GetLocalInt(oHide, "AUTO_LOOT_KITS");
    int bAutoScrolls = GetLocalInt(oHide, "AUTO_LOOT_SCROLLS");
    int bUnidentified = GetLocalInt(oHide, "AUTO_LOOT_UNIDENTIFIED");

    // Get containers
    object oJewelBox, oHeadbag, oGemBag, oScrollCase;
    if (bAutoJewelry) {
        oJewelBox = GetItemPossessedBy(oPC, "md_jewelbox1");
        if (oJewelBox == OBJECT_INVALID)
            oJewelBox = GetItemPossessedBy(oPC, "md_jewelbox");

        // No Jewelry Box found
        if (oJewelBox == OBJECT_INVALID)
            bAutoJewelry = FALSE;
    }

    if (bAutoHeads) {
        oHeadbag = GetItemPossessedBy(oPC, "gvd_headbag60");
        if (oHeadbag == OBJECT_INVALID)
            oHeadbag =  GetItemPossessedBy(oPC, "gvd_headbag40");
        if (oHeadbag == OBJECT_INVALID)
            oHeadbag =  GetItemPossessedBy(oPC, "gvd_headbag20");
        if (oHeadbag == OBJECT_INVALID)
            oHeadbag =  GetItemPossessedBy(oPC, "gvd_headbag");
        if (oHeadbag == OBJECT_INVALID)
        {
            oHeadbag =  GetLocalObject(oPC, "AUTOLOOTHEADBAG");

            if(GetItemPossessor(oHeadbag) != oPC)
                oHeadbag = OBJECT_INVALID;
        }
        // No headbag found
        //if (oHeadbag == OBJECT_INVALID)
           // bAutoHeads = FALSE;

    }

    if (bAutoGems)
    {
        oGemBag = GetItemPossessedBy(oPC, "gvd_gembag_");

        if(oGemBag == OBJECT_INVALID)
        {
            oGemBag = GetLocalObject(oPC, "AUTOLOOTGEMBAG");
            if(GetItemPossessor(oGemBag) != oPC)
                oGemBag = OBJECT_INVALID;
        }


    }
    if (bAutoScrolls)
    {
        oScrollCase = GetItemPossessedBy(oPC, "i_scroll_case");
        if(oScrollCase == OBJECT_INVALID)
        {
            oScrollCase = GetLocalObject(oPC, "BULKSELLSCROLLCASE");
            if(GetItemPossessor(oScrollCase) != oPC)
                oScrollCase = OBJECT_INVALID;
        }

    }

    if(oGemBag == OBJECT_INVALID && bAutoGems || oScrollCase == OBJECT_INVALID && bAutoScrolls || oHeadbag == OBJECT_INVALID && bAutoHeads)
    {
        object oInventory = GetFirstItemInInventory(oPC);
        string sOldTag;
        while(GetIsObjectValid(oInventory))
        {
            sOldTag = GetLocalString(oInventory, NO_STACK_TAG);
            if(sOldTag == "gvd_gembag_" && oGemBag == OBJECT_INVALID && bAutoGems)
            {
                SetLocalObject(oPC, "AUTOLOOTGEMBAG", oInventory);
                oGemBag = oInventory;
            }
            else if(sOldTag == "i_scroll_case" && oScrollCase == OBJECT_INVALID && bAutoScrolls)
            {
                SetLocalObject(oPC, "BULKSELLSCROLLCASE", oInventory);
                oScrollCase = oInventory;
            }
            else if(GetStringLeft(sOldTag, 11) ==  "gvd_headbag" && oHeadbag == OBJECT_INVALID && bAutoHeads)
            {
               SetLocalObject(oPC, "AUTOLOOTHEADBAG", oInventory);
               oHeadbag = oInventory;
            }
            oInventory = GetNextItemInInventory(oPC);
        }
    }

    if (oHeadbag == OBJECT_INVALID)
        bAutoHeads = FALSE;
    // Other variables
    int nContainerSuccess;
    string sTag;
    float fDelay;
    object oCreated;

    // Loop through loot
    while (oItem != OBJECT_INVALID) {

        sTag = GetStringUpperCase(GetTag(oItem));

        // Gold
        if ((GetResRef(oItem) == "nw_it_gold001" || GetBaseItemType(oItem) == BASE_ITEM_GOLD) && bAutoGold)
        {
            GiveGoldToCreature(oPC, GetItemStackSize(oItem));
            DestroyObject(oItem);
        }

        // Jewelry
        else if ((GetBaseItemType(oItem) == BASE_ITEM_RING || GetBaseItemType(oItem) == BASE_ITEM_AMULET) && bAutoJewelry)
        {
            nContainerSuccess = 1;
            if (!GetIsItemPropertyValid(GetFirstItemProperty(oItem)) &&
                (GetDroppableFlag(oItem) == TRUE) &&
                (GetItemCursedFlag(oItem) == FALSE))
                    nContainerSuccess = gvd_Container_AddObject(oJewelBox, oItem);
            if (nContainerSuccess == 0)
                SendMessageToPC(oPC, "Your jewelry box is full.");
        }

        // Heads
        else if ((GetStringLeft(sTag, 7) == "GS_HEAD" || GetStringLeft(sTag, 15) == "GVD_SLAVER_HEAD") && bAutoHeads)
        {
            nContainerSuccess = 1;
            if (GetDroppableFlag(oItem) == TRUE && GetItemCursedFlag(oItem) == FALSE)
                nContainerSuccess = gvd_Container_AddObject(oHeadbag, oItem);
            if (nContainerSuccess == 0)
                SendMessageToPC(oPC, "Your headbag is full.");
        }

        // ActionGiveItem linked to some crashes.  Trying a different method.

        // Gems
        else if (GetBaseItemType(oItem) == BASE_ITEM_GEM && bAutoGems) {
            if (oGemBag != OBJECT_INVALID) {
                nContainerSuccess = 1;
                nContainerSuccess = gvd_Container_AddObject(oGemBag, oItem);
                if (nContainerSuccess == 0)
                    SendMessageToPC(oPC, "Your gem bag is full.");
            }
            fDelay = GetRandomDelay(0.1, 0.4);
            if ((GetIdentified(oItem) || bUnidentified) && (oGemBag == OBJECT_INVALID || !nContainerSuccess)) {
                // DelayCommand(fDelay, ActionGiveItem(oItem, oPC));

                oCreated = CreateItemOnObject(GetResRef(oItem), oPC, GetItemStackSize(oItem));
                if (oCreated != OBJECT_INVALID && GetIdentified(oItem))
                    SetIdentified(oCreated, TRUE);

                // Destroy original.
                DestroyObject(oItem, fDelay);

            }
        }

        // Potions (Exclude Beer and Water tags)
        else if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS && bAutoPotions &&
                 GetTag(oItem) != "GS_ITEM" && GetTag(oItem) != "GS_ST_WATER_25")
        {
            fDelay = GetRandomDelay(0.1, 0.4);
            if (GetIdentified(oItem) || bUnidentified) {
                // DelayCommand(fDelay, ActionGiveItem(oItem, oPC));

                oCreated = CreateItemOnObject(GetResRef(oItem), oPC, GetItemStackSize(oItem));
                if (oCreated != OBJECT_INVALID && GetIdentified(oItem))
                    SetIdentified(oCreated, TRUE);

                // Destroy original.
                DestroyObject(oItem, fDelay);
            }
        }

        // Heal Kits
        else if (GetBaseItemType(oItem) == BASE_ITEM_HEALERSKIT  && bAutoKits)
        {
            fDelay = GetRandomDelay(0.1, 0.4);
            if (GetIdentified(oItem) || bUnidentified) {
                // DelayCommand(fDelay, ActionGiveItem(oItem, oPC));

                oCreated = CreateItemOnObject(GetResRef(oItem), oPC, GetItemStackSize(oItem));
                if (oCreated != OBJECT_INVALID && GetIdentified(oItem))
                    SetIdentified(oCreated, TRUE);

                // Destroy original.
                DestroyObject(oItem, fDelay);
            }
        }

        // Spell Scroll
        else if (GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL && bAutoScrolls) {
            if (oScrollCase != OBJECT_INVALID) {
                nContainerSuccess = 1;
                nContainerSuccess = gvd_Container_AddObject(oScrollCase, oItem);
                if (nContainerSuccess == 0)
                    SendMessageToPC(oPC, "Your scroll case is full.");
            }
            fDelay = GetRandomDelay(0.1, 0.4);
            if ((GetIdentified(oItem) || bUnidentified) && (oScrollCase == OBJECT_INVALID || !nContainerSuccess)) {
                // DelayCommand(fDelay, ActionGiveItem(oItem, oPC));

                oCreated = CreateItemOnObject(GetResRef(oItem), oPC, GetItemStackSize(oItem));
                if (oCreated != OBJECT_INVALID && GetIdentified(oItem))
                    SetIdentified(oCreated, TRUE);

                // Destroy original.
                DestroyObject(oItem, fDelay);

            }
        }

        oItem = GetNextItemInInventory(oCorpse);
    }

}


//................................................................
void main()
{
    object oPC = GetLastUsedBy();

    if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
    {
        // FL code - Create gold for each player using the object, once.
        string sName = GetName(oPC);
        if (GetLocalInt(OBJECT_SELF, sName)) return;
            SetLocalInt(OBJECT_SELF, sName, TRUE);

        float fRating = pow (GetLocalFloat(OBJECT_SELF, "MI_EN_CR"), 2.0f);

        int nGold = Random(FloatToInt(fRating));

        GiveGoldToCreature(oPC, nGold);
    }
    else
    {
        if (GetLocalInt(OBJECT_SELF, "SEARCHED") != 1)
        {
            SetLocalInt(OBJECT_SELF, "SEARCHED", 1);
            gsTRCreateTreasure(OBJECT_SELF,
                GetLocalInt(OBJECT_SELF, "CORPSE_RACIALTYPE"),
                GetLocalFloat(OBJECT_SELF, "MI_EN_CR"),
                GetLocalInt(OBJECT_SELF, "FB_PP_COUNT"),
                GetLocalInt(OBJECT_SELF, "FB_PP_GOLD"),
                oPC);
        }
    }

    DelayCommand(0.1, identifyItems(OBJECT_SELF, oPC));
    DelayCommand(0.2, AutoLootItems(OBJECT_SELF, oPC));
}

