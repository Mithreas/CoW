// This script controls the dialogue when resting, called from gs_m_rest.
//
// OKAY! So here's how to navigate this file:
// - When the dialogue is first opened, OnInit() is called. This sets up all static categories.
// - When an option is chosen, OnSelection() is called. This is where the flow happens.
// - When a new page is loaded, OnPageInit() is called. This is where we populate all dynamic behaviour,
//   for example, anything related to the dynamic crafting menues.

#include "__server_config"
#include "inc_chatutils"
#include "gs_inc_pc"
#include "gs_inc_iprop"
#include "inc_worship"
#include "inc_class"
#include "inc_customspells"
#include "inc_emotes"
#include "inc_examine"
#include "nwnx_item"
#include "nwnx_alts"
#include "x2_inc_itemprop"
#include "x3_inc_string"
#include "zzdlg_main_inc"

// The below implement the various zzdlg event handlers.
void main(); // This is how zzdlg's magic works.
void OnInit(); // The dialogue has been opened.
void OnPageInit(string page); // A page should be initialised.
void OnSelection(string page); // A page has been selected.
void OnReset(string page); // The 'back' button has been pressed.
void OnAbort(string page); // The player exited using escape.
void OnEnd(string page); // The player exited via dialogue.
void OnContinue(string page, int continuePage) { } // The player presesd 'continue'. (unused)

// The below are non-zzdlg-interface functions.

// Changes to the provided dialogue.
void ChangeDialogue(string newDialogue);

// Changes the page from the provided page to the provided page.
// This handles pushing the dialogue stack, too.
void ChangeDialoguePage(string currentPage, string newPage);

// Pushes the provided dialogue page to the dialogue page stack.
void PushDialoguePageToStack(string page);

// Pops the most recently pushed dialogue page from the stack.
string PopDialoguePageFromStack();

// Cleans up the dialogue stack plus any dialogue pages.
void CleanupDialoguePages();

// Cleans up any REST_DYNAMIC_CRAFTING_OPTIONS.
void CleanupDynamicPages();

// Returns TRUE if the provided special ability is usable, otherwise FALSE.
// The indexes match the order which special abilities were added.
int IsSpecialAbilityIndexUsable(int index);

// Gets/sets REST_ITEM_SLOT of the speaker.
// Slots use the INVENTORY_SLOT_ constants.
int GetActiveItemSlot();
void SetActiveItemSlot(int slotId);

// Gets/sets REST_ITEM_SUBSLOT of the speaker.
// Subslots use the relevant ITEM_APPR_ constant.
void SetActiveItemSubslot(int subslotId);
int GetActiveItemSubslot();

// Gets/sets REST_DYNAMIC_CRAFTING_OPTIONS of the speaker.
// These options represent an item part.
void AddDynamicCraftingOption(string id);
string GetDynamicCraftingOptions();

// Gets/sets REST_DYNAMIC_CRAFTING_CUR_MODEL of the speaker.
void SetDynamicCraftingCurModel(int id);
int GetDynamicCraftingCurModel();

// Returns the correct ITEM_APPR_TYPE_ for the slot, aided by the boolean isColour.
int GetApperanceTypeForEqippedItem(object player, int slot, int isColour);

// Generate override string
string GenerateOverrideString(int nFrom, int nTo, int nColor, string sApp);

// Modifies / gets equipped part.
object ModifyItem(object item, int slot, int apprType, int subslot, int partId);
void ModifyEquippedItem(object player, int slot, int apprType, int subslot, int partId);
int GetEquippedPartID(object player, int slot, int apprType, int subslot);

// These are discrete pages. Not all selections have their own page.
const string PG_MAIN = "PG_MAIN";
const string PG_MAIN_EMOTES = "PG_MAIN_EMOTES";
const string PG_MAIN_CHARACTER = "PG_MAIN_CHARACTER";
const string PG_MAIN_CHARACTER_MIMIC = "PG_MAIN_CHARACTER_MIMIC";
const string PG_MAIN_CHARACTER_MIMIC_VALUE = "PG_MAIN_CHARACTER_MIMIC_VALUE";
const string PG_MAIN_CHARACTER_SPECIAL = "PG_MAIN_CHARACTER_SPECIAL";
const string PG_MAIN_CHARACTER_SETTINGS = "PG_MAIN_CHARACTER_SETTINGS";
const string PG_MAIN_CHARACTER_AUTOLOOT = "PG_MAIN_CHARACTER_AUTOLOOT";
// TODO: const string PG_MAIN_CHARACTER_SPELLBOOKS = "PG_MAIN_CHARACTER_SPELLBOOKS";
// TODO: const string PG_MAIN_CHARACTER_SPELLBOOKS_LOAD = "PG_MAIN_CHARACTER_SPELLBOOKS_LOAD";
// TODO: const string PG_MAIN_CHARACTER_SPELLBOOKS_SAVE = "PG_MAIN_CHARACTER_SPELLBOOKS_SAVE";
// TODO: const string PG_MAIN_CHARACTER_SPELLBOOKS_DELETE = "PG_MAIN_CHARACTER_SPELLBOOKS_DELETE";
const string PG_MAIN_APPEARANCE = "PG_MAIN_APPEARANCE";
// TODO: const string PG_MAIN_APPEARANCE_OUTFITS = "PG_MAIN_APPEARANCE_OUTFITS";
// TODO: const string PG_MAIN_APPEARANCE_OUTFITS_LOAD = "PG_MAIN_APPEARANCE_OUTFITS_LOAD";
// TODO: const string PG_MAIN_APPEARANCE_OUTFITS_SAVE = "PG_MAIN_APPEARANCE_OUTFITS_SAVE";
// TODO: const string PG_MAIN_APPEARANCE_OUTFITS_DELETE = "PG_MAIN_APPEARANCE_OUTFITS_DELETE";
const string PG_MAIN_APPEARANCE_ARMOUR = "PG_MAIN_APPEARANCE_ARMOUR";
const string PG_MAIN_APPEARANCE_ARMOUR_BODY = "PG_MAIN_APPEARANCE_ARMOUR_BODY";
const string PG_MAIN_APPEARANCE_ARMOUR_ARMS = "PG_MAIN_APPEARANCE_ARMOUR_ARMS";
const string PG_MAIN_APPEARANCE_ARMOUR_LEGS = "PG_MAIN_APPEARANCE_ARMOUR_LEGS";
const string PG_MAIN_APPEARANCE_HELMET = "PG_MAIN_APPEARANCE_HELMET";
const string PG_MAIN_APPEARANCE_CLOAK = "PG_MAIN_APPEARANCE_CLOAK";
// TODO: const string PG_MAIN_APPEARANCE_MAINHAND = "PG_MAIN_APPEARANCE_MAINHAND";
// TODO: const string PG_MAIN_APPEARANCE_OFFHAND = "PG_MAIN_APPEARANCE_OFFHAND";
const string PG_MAIN_MISCELLANEOUS = "PG_MAIN_MISCELLANEOUS";
const string PG_MAIN_HELP = "PG_MAIN_HELP";

// This are special pages to handle appearance crafting.
// This uses the REST_ITEM_SLOT variable to communicate which slot.
// Depending on REST_ITEM_SLOT, also uses REST_ITEM_SUBSLOT.
const string PG_DYNAMIC_CRAFTING = "PG_DYNAMIC_CRAFTING";

// This are special pages to handle colour crafting for armour and weapons.
// This uses the REST_ITEM_SLOT variable to communicate which slot.
const string PG_DYNAMIC_COLOURS = "PG_DYNAMIC_COLOURS";

void main()
{
    dlgOnMessage();
}

void OnInit()
{
    CleanupDialoguePages();
    CleanupDynamicPages();

    dlgAddResponseAction(PG_MAIN, "Rest");

    dlgAddResponseAction(PG_MAIN, "Emotes");

    int i = EMOTE_FIRST;
    while (i <= EMOTE_LAST)
    {
        dlgAddResponseAction(PG_MAIN_EMOTES, EmoteIdToString(i));
        ++i;
    }

    dlgAddResponseAction(PG_MAIN, "Character");

    dlgAddResponseAction(PG_MAIN_CHARACTER, "Special abilities");
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Chaos", IsSpecialAbilityIndexUsable(0)         ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Detect Evil", IsSpecialAbilityIndexUsable(1)   ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Fate", IsSpecialAbilityIndexUsable(2)          ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Project Image", IsSpecialAbilityIndexUsable(3) ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Respite", IsSpecialAbilityIndexUsable(4)       ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Scry", IsSpecialAbilityIndexUsable(5)          ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Surge", IsSpecialAbilityIndexUsable(6)         ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Teleport", IsSpecialAbilityIndexUsable(7)      ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Track", IsSpecialAbilityIndexUsable(8)         ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Two-Hand", IsSpecialAbilityIndexUsable(9)      ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Ward", IsSpecialAbilityIndexUsable(10)         ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Yoink", IsSpecialAbilityIndexUsable(11)        ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER_SPECIAL, "Mimic", IsSpecialAbilityIndexUsable(12)        ? DLG_DEFAULT_TXT_TALK_COLOR : txtRed);
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Settings");
    dlgAddResponseAction(PG_MAIN_CHARACTER_SETTINGS, "Tells");
    dlgAddResponseAction(PG_MAIN_CHARACTER_SETTINGS, "Reveal party");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Trade skills");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Deities");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Languages");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Factions");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Mimic");
    dlgAddResponseAction(PG_MAIN_CHARACTER, "Auto-Looting Options");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC, "Mimic Strength");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC, "Mimic Dexterity");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC, "Mimic Constitution");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC, "Mimic Charisma");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC_VALUE, "High");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC_VALUE, "Average");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC_VALUE, "Low");
    dlgAddResponseAction(PG_MAIN_CHARACTER_MIMIC_VALUE, "Stop");
    // TODO: dlgAddResponseAction(PG_MAIN_CHARACTER, "Spellbooks");
    // TODO: dlgAddResponseAction(PG_MAIN_CHARACTER_SPELLBOOKS, "Load spellbook");
    // TODO: dlgAddResponseAction(PG_MAIN_CHARACTER_SPELLBOOKS, "Save spellbook");
    // TODO: dlgAddResponseAction(PG_MAIN_CHARACTER_SPELLBOOKS, "Delete spellbook");

    dlgAddResponseAction(PG_MAIN, "Appearance");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE, "Outfits");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE_OUTFITS, "Load outfit");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE_OUTFITS, "Save outfit");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE_OUTFITS, "Delete outfit");
    dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify armour");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify body");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_BODY, "Chest");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_BODY, "Pelvis");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_BODY, "Belt");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify arms");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Right shoulder");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Left shoulder");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Right biceps");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Left biceps");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Right forearm");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Left forearm");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Right hand");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_ARMS, "Left hand");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify legs");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Right thigh");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Left thigh");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Right shin");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Left shin");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Right foot");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR_LEGS, "Left foot");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify neck");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify robe");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Modify colours");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Mirror left to right");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_ARMOUR, "Mirror right to left");
    dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify helmet");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_HELMET, "Modify appearance");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_HELMET, "Modify colours");
    dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify cloak");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_CLOAK, "Modify appearance");
    dlgAddResponseAction(PG_MAIN_APPEARANCE_CLOAK, "Modify colours");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify mainhand");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify offhand");
    // TODO: dlgAddResponseAction(PG_MAIN_APPEARANCE, "Modify back");
    dlgAddResponseAction(PG_MAIN_APPEARANCE, "Toggle hood");

    dlgAddResponseAction(PG_MAIN, "Miscellaneous");
    dlgAddResponseAction(PG_MAIN_MISCELLANEOUS, "Playerlist");

    dlgAddResponseAction(PG_MAIN, "Help");
    dlgAddResponseAction(PG_MAIN_HELP, "Manuals");
    dlgAddResponseAction(PG_MAIN_HELP, "Chat commands");
    dlgAddResponseAction(PG_MAIN_HELP, "Wiki");
    dlgAddResponseAction(PG_MAIN_HELP, "Forums");
    dlgAddResponseAction(PG_MAIN_HELP, "Updates");


    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Gold");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Jewelry");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Bounty Heads");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Gemstones");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Potions");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Heal Kits");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Scrolls");
    dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Auto-Loot Do Not Ignore Unidentified");

    dlgChangePage(PG_MAIN);
}

void OnPageInit(string page)
{
    object player = dlgGetSpeakingPC();
    object oHide = gsPCGetCreatureHide(player);

    // Back button.
    if (page == PG_MAIN)
    {
        dlgDeactivateResetResponse();
    }
    else
    {
        dlgActivateResetResponse("[Back]", txtBlue);
    }

    // Dialogue text.
    if (page == PG_MAIN)
    {
        dlgSetPrompt("Welcome to the rest menu! Please make a selection.");
    }
    else if (page == PG_DYNAMIC_COLOURS)
    {
        string sPrompt = "Please enter a colour (0-175) in chat (talk, whisper, tell to self) then make a selection.";
        if(GetActiveItemSubslot() > -1)
            sPrompt += " To remove a colour override set the colour to 255.";
        dlgSetPrompt(sPrompt);
    }
    else
    {
        dlgSetPrompt("Please make a selection.");
    }

    if (page == PG_DYNAMIC_CRAFTING)
    {
        dlgClearResponseList(PG_DYNAMIC_CRAFTING);

        int slot = GetActiveItemSlot();
        object item = GetItemInSlot(slot, player);

        if (!GetIsObjectValid(item))
        {
            OnReset(page);
            return;
        }

        if (slot == INVENTORY_SLOT_HEAD || slot == INVENTORY_SLOT_CLOAK || slot == INVENTORY_SLOT_CHEST)
        {
            int subslot = GetActiveItemSubslot();
            int tableId;

            switch (slot)
            {
                case INVENTORY_SLOT_HEAD:  tableId = gsIPGetTableID("helmetmodel"); break;
                case INVENTORY_SLOT_CLOAK: tableId = gsIPGetTableID("cloakmodel"); break;
                case INVENTORY_SLOT_CHEST: tableId = gsIPGetAppearanceTableID(subslot); break;
            }

            if (slot == INVENTORY_SLOT_HEAD)
            {
                AddDynamicCraftingOption("HIDDEN");
                dlgAddResponseAction(PG_DYNAMIC_CRAFTING, "Form_0");
            }
            else if(slot == INVENTORY_SLOT_CHEST)
            {
                AddDynamicCraftingOption("COLOUR");
                dlgAddResponseAction(PG_DYNAMIC_CRAFTING, "Colour");
            }
            int curModel = GetDynamicCraftingCurModel();

            if (curModel == -1)
            {
                curModel = GetEquippedPartID(player, slot, GetApperanceTypeForEqippedItem(player, slot, FALSE), subslot);
                SetDynamicCraftingCurModel(curModel);
            }

            int count = gsIPGetCount(tableId);

            int i = 0;
            while (i < count)
            {
                int candidateAC = gsIPGetValue(tableId, i, "AC");
                if (subslot != ITEM_APPR_ARMOR_MODEL_TORSO || gsIPGetAppearanceAC(tableId, curModel) == candidateAC)
                {
                    int candidateModel = gsIPGetValue(tableId, i, "ID");
                    string candidateModelAsStr = IntToString(candidateModel);
                    AddDynamicCraftingOption(candidateModelAsStr);

                    string str = "Form_" + candidateModelAsStr;

                    if (candidateModel == curModel)
                    {
                        str = "[" + str + "]";
                    }

                    dlgAddResponseAction(PG_DYNAMIC_CRAFTING, str);
                }

                ++i;
            }
        }
        // TODO: else if (slot == INVENTORY_SLOT_LEFTHAND || slot == INVENTORY_SLOT_RIGHTHAND)
        // TODO: {
        // TODO: }
    }
    else if (page == PG_DYNAMIC_COLOURS)
    {
        int slot = GetActiveItemSlot();
        object item = GetItemInSlot(slot, player);

        if (!GetIsObjectValid(item))
        {
            OnReset(page);
            return;
        }

        int apprType = GetApperanceTypeForEqippedItem(player, slot, TRUE);


        string cloth1 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_CLOTH1));
        string cloth2 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_CLOTH2));
        string leather1 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_LEATHER1));
        string leather2 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_LEATHER2));
        string metal1 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_METAL1));
        string metal2 = IntToString(GetEquippedPartID(player, slot, apprType, ITEM_APPR_ARMOR_COLOR_METAL2));

        dlgClearResponseList(PG_DYNAMIC_COLOURS);
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Cloth 1 [" + cloth1 + "]");
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Cloth 2 [" + cloth2 + "]");
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Leather 1 [" + leather1 + "]");
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Leather 2 [" + leather2 + "]");
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Metal 1 [" + metal1 + "]");
        dlgAddResponseAction(PG_DYNAMIC_COLOURS, "Metal 2 [" + metal2 + "]");
    }
    else if (page == PG_MAIN_CHARACTER_AUTOLOOT)
    {
        dlgClearResponseList(PG_MAIN_CHARACTER_AUTOLOOT);
        dlgSetPrompt("Choose from the following settings.");
        // Setting up Auto-Loot options with proper setting indicators.
        if (GetLocalInt(oHide, "AUTO_LOOT_GOLD"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Gold Coins automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Gold Coins automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_JEWELRY"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Add Jewelry to any possessed Jewelry Box automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Add Jewelry to any possessed Jewelry Box automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_HEADS"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Add bounty heads to any possessed headbag automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Add bounty heads to any possessed headbag automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_GEMS"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Cut Gemstones automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Cut Gemstones automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_POTIONS"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Potions automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Potions automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_KITS"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Heal Kits automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Heal Kits. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_SCROLLS"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Spell Scrolls automatically. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up Spell Scrolls automatically. [off]");
        if (GetLocalInt(oHide, "AUTO_LOOT_UNIDENTIFIED"))
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up items regardless of whether they are Identified. [ACTIVE]");
        else
            dlgAddResponseAction(PG_MAIN_CHARACTER_AUTOLOOT, "Pick up items regardless of whether they are Identified. [off]");
    }

    dlgActivatePreservePageNumberOnSelection();
    dlgActivateEndResponse("[Exit]", txtBlue);
    dlgSetActiveResponseList(page);
}

void OnSelection(string page)
{
    object player = dlgGetSpeakingPC();
    int index = dlgGetSelectionIndex();
    object oHide = gsPCGetCreatureHide(player);

    // This will be incremented at every check, starting from 0.
    // The order should align with the order of declaration in Init().
    int checkedIndex = 0;

    // Variable declaration
    string sMimicStat = "";

    if (page == PG_MAIN)
    {
        if (index == checkedIndex++ /* Rest */)
        {
            //::  Cancel if Resting is not allowed in this area (Area Flag)
            if ( gsFLGetAreaFlag("NO_REST", player) )
            {
                FloatingTextStringOnCreature("You may not rest at this time.", player, FALSE);
                AssignCommand(player, ClearAllActions());
                return;
            }

            SetLocalInt(player, "READY_TO_REST", TRUE);
            AssignCommand(player, ActionRest());
        }
        else if (index == checkedIndex++ /* Emotes */)
        {
            ChangeDialoguePage(page, PG_MAIN_EMOTES);
        }
        else if (index == checkedIndex++ /* Character */)
        {
            ChangeDialoguePage(page, PG_MAIN_CHARACTER);
        }
        else if (index == checkedIndex++ /* Appearance */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE);
        }
        else if (index == checkedIndex++ /* Miscellaneous */)
        {
            ChangeDialoguePage(page, PG_MAIN_MISCELLANEOUS);
        }
        else if (index == checkedIndex++ /* Help */)
        {
            ChangeDialoguePage(page, PG_MAIN_HELP);
        }
    }
    else if (page == PG_MAIN_EMOTES)
    {
        if (index >= EMOTE_FIRST && index <= EMOTE_LAST)
        {
            // Emotes constants should have a 1:1 mapping with dialogue order.
            PerformEmote(index, player);
        }
    }
    else if (page == PG_MAIN_CHARACTER)
    {
        if (index == checkedIndex++ /* Special abilities */)
        {
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_SPECIAL);
        }
        else if (index == checkedIndex++ /* Settings */)
        {
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_SETTINGS);
        }
        else if (index == checkedIndex++ /* Trade skills */)
        {
            AssignCommand(player, ChangeDialogue("zz_co_crafting"));
        }
        else if (index == checkedIndex++ /* Deities */)
        {
            AssignCommand(player, ChangeDialogue("zz_co_worship"));
        }
        else if (index == checkedIndex++ /* Languages */)
        {
            AssignCommand(player, SpeakString("-language"));
        }
        else if (index == checkedIndex++ /* Factions */)
        {
            AssignCommand(player, ChangeDialogue("zz_co_factions"));
        }
        else if (index == checkedIndex++ /* Mimic */)
        {
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_MIMIC);
        }
        else if (index == checkedIndex++ /* Auto-Loot */)
        {
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_AUTOLOOT);
        }

        // TODO: else if (index == checkedIndex++ /* Spellbooks */)
        // TODO: {
        // TODO:     ChangeDialoguePage(page, PG_MAIN_CHARACTER_SPELLBOOKS);
        // TODO: }
    }
    else if (page == PG_MAIN_CHARACTER_SPECIAL)
    {
        if (index == checkedIndex++ /* Chaos */)
        {
            AssignCommand(player, SpeakString("-chaos"));
        }
        else if (index == checkedIndex++ /* Detect Evil */)
        {
            AssignCommand(player, SpeakString("-detectevil"));
        }
        else if (index == checkedIndex++ /* Fate */)
        {
            AssignCommand(player, SpeakString("-fate"));
        }
        else if (index == checkedIndex++ /* Project Image */)
        {
            AssignCommand(player, SpeakString("-project_image"));
        }
        else if (index == checkedIndex++ /* Respite */)
        {
            AssignCommand(player, SpeakString("-respite"));
        }
        else if (index == checkedIndex++ /* Scry */)
        {
            AssignCommand(player, SpeakString("-scry"));
        }
        else if (index == checkedIndex++ /* Surge */)
        {
            AssignCommand(player, SpeakString("-surge"));
        }
        else if (index == checkedIndex++ /* Teleport */)
        {
            AssignCommand(player, SpeakString("-teleport"));
        }
        else if (index == checkedIndex++ /* Track */)
        {
            AssignCommand(player, SpeakString("-track"));
        }
        else if (index == checkedIndex++ /* Two-Hand */)
        {
            AssignCommand(player, SpeakString("-twohand"));
        }
        else if (index == checkedIndex++ /* Ward */)
        {
            AssignCommand(player, SpeakString("-ward"));
        }
        else if (index == checkedIndex++ /* Yoink */)
        {
            AssignCommand(player, SpeakString("-yoink"));
        }
        else if (index == checkedIndex++ /* Mimic */)
        {
            AssignCommand(player, SpeakString("-mimic"));
        }
    }
    else if (page == PG_MAIN_CHARACTER_SETTINGS)
    {
        if (index == checkedIndex++ /* Tells */)
        {
            AssignCommand(player, SpeakString("-notells"));
        }
        else if (index == checkedIndex++ /* Reveal party */)
        {
            AssignCommand(player, SpeakString("-revealparty"));
        }
    }
    // TODO: else if (page == PG_MAIN_CHARACTER_SPELLBOOKS)
    // TODO: {
    // TODO:     if (index == checkedIndex++ /* Load spellbook */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_CHARACTER_SPELLBOOKS_LOAD);
    // TODO:     }
    // TODO:     else if (index == checkedIndex++ /* Save spellbook */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_CHARACTER_SPELLBOOKS_SAVE);
    // TODO:     }
    // TODO:     else if (index == checkedIndex++ /* Delete spellbook */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_CHARACTER_SPELLBOOKS_DELETE);
    // TODO:     }
    // TODO: }
    // TODO: else if (page == PG_MAIN_CHARACTER_SPELLBOOKS_LOAD)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    // TODO: else if (page == PG_MAIN_CHARACTER_SPELLBOOKS_SAVE)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    // TODO: else if (page == PG_MAIN_CHARACTER_SPELLBOOKS_DELETE)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    else if (page == PG_MAIN_APPEARANCE)
    {
        // TODO: if (index == checkedIndex++ /* Outfits */)
        // TODO: {
        // TODO:     ChangeDialoguePage(page, PG_MAIN_APPEARANCE_OUTFITS);
        // TODO: }
        // TODO: else
        if (index == checkedIndex++ /* Modify armour */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_ARMOUR);
        }
        else if (index == checkedIndex++ /* Modify helmet */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_HELMET);
        }
        else if (index == checkedIndex++ /* Modify cloak */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_CLOAK);
        }
        // TODO: else if (index == checkedIndex++ /* Modify mainhand */)
        // TODO: {
        // TODO:     ChangeDialoguePage(page, PG_MAIN_APPEARANCE_MAINHAND);
        // TODO: }
        // TODO: else if (index == checkedIndex++ /* Modify offhand */)
        // TODO: {
        // TODO:     ChangeDialoguePage(page, PG_MAIN_APPEARANCE_MAINHAND);
        // TODO: }
        // TODO: else if (index == checkedIndex++ /* Modify back */)
        // TODO: {
        // TODO:     // TODO: Dynamic crafting transition.
        // TODO: }
        else if (index == checkedIndex++ /* Toggle hood */)
        {
            AssignCommand(player, SpeakString("-hood"));
        }
    }
    // TODO: else if (page == PG_MAIN_APPEARANCE_OUTFITS)
    // TODO: {
    // TODO:     if (index == checkedIndex++ /* Load outfit */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_APPEARANCE_OUTFITS_LOAD);
    // TODO:     }
    // TODO:     else if (index == checkedIndex++ /* Save outfit */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_APPEARANCE_OUTFITS_SAVE);
    // TODO:     }
    // TODO:     else if (index == checkedIndex++ /* Delete outfit */)
    // TODO:     {
    // TODO:         ChangeDialoguePage(page, PG_MAIN_APPEARANCE_OUTFITS_DELETE);
    // TODO:     }
    // TODO: }
    // TODO: else if (page == PG_MAIN_APPEARANCE_OUTFITS_LOAD)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    // TODO: else if (page == PG_MAIN_APPEARANCE_OUTFITS_SAVE)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    // TODO: else if (page == PG_MAIN_APPEARANCE_OUTFITS_DELETE)
    // TODO: {
    // TODO:     // TODO: Whattafuck? Bump until later?
    // TODO: }
    else if (page == PG_MAIN_APPEARANCE_ARMOUR)
    {
        int mirrorLeftToRight = FALSE;
        int mirrorRightToLeft = FALSE;

        if (index == checkedIndex++ /* Body */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_ARMOUR_BODY);
        }
        else if (index == checkedIndex++ /* Arms */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_ARMOUR_ARMS);
        }
        else if (index == checkedIndex++ /* Legs */)
        {
            ChangeDialoguePage(page, PG_MAIN_APPEARANCE_ARMOUR_LEGS);
        }
        else if (index == checkedIndex++ /* Neck */)
        {
            SetActiveItemSlot(INVENTORY_SLOT_CHEST);
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_NECK);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Robe */)
        {
            SetActiveItemSlot(INVENTORY_SLOT_CHEST);
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_ROBE);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Colours */)
        {
            SetActiveItemSlot(INVENTORY_SLOT_CHEST);
            SetActiveItemSubslot(-1);//remove subslot, modify all colors
            ChangeDialoguePage(page, PG_DYNAMIC_COLOURS);
        }
        else if (index == checkedIndex++ /* Mirror left to right */)
        {
            mirrorLeftToRight = TRUE;
        }
        else if (index == checkedIndex++ /* Mirror right to left */)
        {
            mirrorRightToLeft = TRUE;
        }

        if (mirrorLeftToRight || mirrorRightToLeft)
        {
            object helper = GetObjectByTag("MD_outhelp");

            if (!GetIsObjectValid(helper))
            {
                return;
            }

            object item = GetItemInSlot(INVENTORY_SLOT_CHEST, player);

            if (!GetIsObjectValid(item))
            {
                return;
            }

            string desc = GetDescription(item);
            object copy = CopyItem(item, helper, TRUE);

            int shoulderId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LSHOULDER : ITEM_APPR_ARMOR_MODEL_RSHOULDER);
            int bicepId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LBICEP : ITEM_APPR_ARMOR_MODEL_RBICEP);
            int forearmId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LFOREARM : ITEM_APPR_ARMOR_MODEL_RFOREARM);
            int handId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LHAND : ITEM_APPR_ARMOR_MODEL_RHAND);
            int thighId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LTHIGH : ITEM_APPR_ARMOR_MODEL_RTHIGH);
            int shinId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LSHIN : ITEM_APPR_ARMOR_MODEL_RSHIN);
            int footId = GetEquippedPartID(player, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_LFOOT : ITEM_APPR_ARMOR_MODEL_RFOOT);

            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RSHOULDER : ITEM_APPR_ARMOR_MODEL_LSHOULDER, shoulderId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RBICEP : ITEM_APPR_ARMOR_MODEL_LBICEP, bicepId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RFOREARM : ITEM_APPR_ARMOR_MODEL_LFOREARM, forearmId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RHAND : ITEM_APPR_ARMOR_MODEL_LHAND, handId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RTHIGH : ITEM_APPR_ARMOR_MODEL_LTHIGH, thighId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RSHIN : ITEM_APPR_ARMOR_MODEL_LSHIN, shinId);
            copy = ModifyItem(copy, INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, mirrorLeftToRight ? ITEM_APPR_ARMOR_MODEL_RFOOT : ITEM_APPR_ARMOR_MODEL_LFOOT, footId);

            string sApp = NWNX_Item_GetEntireItemAppearance (copy);
            int x;
            int y;
            if(mirrorLeftToRight)
            {

                for(x = 1; x<=3; x+=2)
                {
                    for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                        sApp = GenerateOverrideString(x, x-1, y, sApp);
                }

                for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                    sApp = GenerateOverrideString(ITEM_APPR_ARMOR_MODEL_LTHIGH, ITEM_APPR_ARMOR_MODEL_RTHIGH, y, sApp);


                for(x = 11; x<=17; x+=2)
                {
                    for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                        sApp = GenerateOverrideString(x, x-1, y, sApp);
                }

            }
            else
            {
                for(x = 0; x<=2; x+=2)
                {
                    for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                        sApp = GenerateOverrideString(x, x+1, y, sApp);
                }

                for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                    sApp = GenerateOverrideString(ITEM_APPR_ARMOR_MODEL_RTHIGH, ITEM_APPR_ARMOR_MODEL_LTHIGH, y, sApp);


                for(x = 10; x<=16; x+=2)
                {
                    for(y = 0; y< ITEM_APPR_ARMOR_NUM_COLORS; y++)
                        sApp = GenerateOverrideString(x, x+1, y, sApp);
                }
            }

            int nCurse = GetItemCursedFlag(copy);
            int nDrop = GetDroppableFlag(copy);
            int nPlot = GetPlotFlag(copy);
            NWNX_Item_RestoreItemAppearance (copy, sApp);
            object backToPc = CopyItem(copy, player, TRUE);
            DestroyObject(copy);

            if (GetIsObjectValid(backToPc))
            {
                SetDescription(backToPc, desc);
                SetPlotFlag(backToPc, nPlot);
                SetItemCursedFlag(backToPc, nCurse);
                SetDroppableFlag(backToPc, nDrop);
                AssignCommand(player, ActionEquipItem(backToPc, INVENTORY_SLOT_CHEST));
                DestroyObject(item);
            }
        }
    }
    else if (page == PG_MAIN_APPEARANCE_ARMOUR_BODY)
    {
        SetActiveItemSlot(INVENTORY_SLOT_CHEST);

        if (index == checkedIndex++ /* Chest */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_TORSO);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Pelvis */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_PELVIS);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Belt */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_BELT);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
    }
    else if (page == PG_MAIN_APPEARANCE_ARMOUR_ARMS)
    {
        SetActiveItemSlot(INVENTORY_SLOT_CHEST);

        if (index == checkedIndex++ /* Right shoulder */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RSHOULDER);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left shoulder */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LSHOULDER);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Right biceps */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RBICEP);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left biceps */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LBICEP);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Right forearm */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RFOREARM);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left forearm */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LFOREARM);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Right hand */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RHAND);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left hand */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LHAND);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
    }
    else if (page == PG_MAIN_APPEARANCE_ARMOUR_LEGS)
    {
        SetActiveItemSlot(INVENTORY_SLOT_CHEST);

        if (index == checkedIndex++ /* Right thigh */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RTHIGH);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left thigh */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LTHIGH);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Right shin */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RSHIN);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left shin */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LSHIN);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Right foot */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_RFOOT);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Left foot */)
        {
            SetActiveItemSubslot(ITEM_APPR_ARMOR_MODEL_LFOOT);
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
    }
    else if (page == PG_MAIN_APPEARANCE_HELMET)
    {
        SetActiveItemSlot(INVENTORY_SLOT_HEAD);

        if (index == checkedIndex++ /* Appearance */)
        {
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Colours */)
        {
            SetActiveItemSubslot(-1); //remove subslot, modify all colors
            ChangeDialoguePage(page, PG_DYNAMIC_COLOURS);
        }
    }
    else if (page == PG_MAIN_APPEARANCE_CLOAK)
    {
        SetActiveItemSlot(INVENTORY_SLOT_CLOAK);

        if (index == checkedIndex++ /* Appearance */)
        {
            ChangeDialoguePage(page, PG_DYNAMIC_CRAFTING);
        }
        else if (index == checkedIndex++ /* Colours */)
        {
            SetActiveItemSubslot(-1); //remove subslot, modify all colors
            ChangeDialoguePage(page, PG_DYNAMIC_COLOURS);
        }
    }
    else if (page == PG_MAIN_MISCELLANEOUS)
    {
        if (index == checkedIndex++ /* Playerlist */)
        {
            AssignCommand(player, SpeakString("-playerlist"));
        }
    }
    else if (page == PG_MAIN_HELP)
    {
        if (index == checkedIndex++ /* Manuals */)
        {
            AssignCommand(player, SpeakString("-manual"));
        }
        else if (index == checkedIndex++ /* Chat commands */)
        {
            AssignCommand(player, SpeakString("-help"));
        }
        else if (index == checkedIndex++ /* Wiki */)
        {
            DisplayTextInExamineWindow("Wiki",
                "You can access the wiki at http://wiki.arelith.com. " +
                "If you wish to contribute, contact an admin on the forums to register an account.",
                player);
        }
        else if (index == checkedIndex++ /* Forums */)
        {
            DisplayTextInExamineWindow("Forums",
                "You can access the forums at http://forum.arelith.com. " +
                "To register an account, use the -forum_password command. Type -forum_password ? for help.",
                player);
        }
        else if (index == checkedIndex++ /* Updates */)
        {
            AssignCommand(player, SpeakString("-updates"));
        }
    }
    else if (page == PG_DYNAMIC_CRAFTING)
    {
        int bail = FALSE;

        string craftingOptions = GetDynamicCraftingOptions();

        while (craftingOptions != "")
        {
            int slot = GetActiveItemSlot();
            string part = StringParse(craftingOptions);

            if (index == checkedIndex++)
            {
                object item = GetItemInSlot(slot, player);

                if (!GetIsObjectValid(item))
                {
                    OnReset(page);
                    return;
                }

                if (slot == INVENTORY_SLOT_HEAD)
                {
                    if (part == "HIDDEN")
                    {
                        SetHiddenWhenEquipped(item, TRUE);
                        break; // We've chosen the artifical Form_0. Set hidden then bail.
                    }
                    else
                    {
                        // If choosing non Form_0, always toggle hidden off.
                        SetHiddenWhenEquipped(item, FALSE);
                    }
                }
                else if(slot == INVENTORY_SLOT_CHEST)
                {
                    if(part == "COLOUR")
                    {
                        ChangeDialoguePage(page, PG_DYNAMIC_COLOURS);
                        return;
                    }
                }

                // TODO: if (slot == INVENTORY_SLOT_CARMOUR /* CARMOUR stands for 'wings */)
                // TODO: {
                // TODO: }
                // TODO: else
                {
                    int apprType = GetApperanceTypeForEqippedItem(player, slot, FALSE); // TODO: Weapon colour
                    int subslot = GetActiveItemSubslot();
                    int partId = StringToInt(part);

                    if (slot == INVENTORY_SLOT_CHEST && subslot == ITEM_APPR_ARMOR_MODEL_TORSO)
                    {
                        // Quickly verify that the AC is still the same.
                        // This prevents people swapping armour pieces mid dialogue.
                        int savedModel = GetDynamicCraftingCurModel();
                        int curModel = GetEquippedPartID(player, slot, GetApperanceTypeForEqippedItem(player, slot, FALSE), ITEM_APPR_ARMOR_MODEL_TORSO);

                        if (savedModel != curModel)
                        {
                            OnReset(page);
                            return;
                        }
                    }

                    ModifyEquippedItem(player, slot, apprType, subslot, partId);
                    SetDynamicCraftingCurModel(partId);
                }

                break;
            }

            craftingOptions = StringRemoveParsed(craftingOptions, part);
        }

        dlgChangePage(page); // Force a page reload to update current selections.
    }
    else if (page == PG_DYNAMIC_COLOURS)
    {
        int slot = GetActiveItemSlot();
        object item = GetItemInSlot(slot, player);

        if (!GetIsObjectValid(item))
        {
            OnReset(page);
            return;
        }

        int selectionIndex;

        if (index == checkedIndex++ /* Cloth 1 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_CLOTH1;
        }
        else if (index == checkedIndex++ /* Cloth 2 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_CLOTH2;
        }
        else if (index == checkedIndex++ /* Leather 1 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_LEATHER1;
        }
        else if (index == checkedIndex++ /* Leather 2 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_LEATHER2;
        }
        else if (index == checkedIndex++ /* Metal 1 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_METAL1;
        }
        else if (index == checkedIndex++ /* Metal 2 */)
        {
            selectionIndex = ITEM_APPR_ARMOR_COLOR_METAL2;
        }

        int nSubSlot = GetActiveItemSubslot();
        if(nSubSlot > -1)
            selectionIndex = ITEM_APPR_ARMOR_NUM_COLORS + (nSubSlot * ITEM_APPR_ARMOR_NUM_COLORS) + selectionIndex;

        int apprType = GetApperanceTypeForEqippedItem(player, slot, TRUE);
        int colour = StringToInt(chatGetLastMessage(player));
        ModifyEquippedItem(player, slot, apprType, selectionIndex, colour);
        dlgChangePage(page); // Force a page reload to update current selections.
    }
    else if (page == PG_MAIN_CHARACTER_MIMIC)
    {
        if (index == checkedIndex++ /* STR */)
        {
            SetLocalString(player, "ZZ_REST_MIMIC_STAT", "STR");
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_MIMIC_VALUE);
        }
        if (index == checkedIndex++ /* DEX */)
        {
            SetLocalString(player, "ZZ_REST_MIMIC_STAT", "DEX");
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_MIMIC_VALUE);
        }
        if (index == checkedIndex++ /* CON */)
        {
            SetLocalString(player, "ZZ_REST_MIMIC_STAT", "CON");
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_MIMIC_VALUE);
        }
        if (index == checkedIndex++ /* CHA */)
        {
            SetLocalString(player, "ZZ_REST_MIMIC_STAT", "CHA");
            ChangeDialoguePage(page, PG_MAIN_CHARACTER_MIMIC_VALUE);
        }
    }
    else if (page == PG_MAIN_CHARACTER_MIMIC_VALUE)
    {
        sMimicStat = GetLocalString(player, "ZZ_REST_MIMIC_STAT");
        if (index == checkedIndex++ /* High */)
        {
            AssignCommand(player, SpeakString("-mimic " + sMimicStat + " Hi"));
        }
        if (index == checkedIndex++ /* Average */)
        {
            AssignCommand(player, SpeakString("-mimic " + sMimicStat + " Av"));
        }
        if (index == checkedIndex++ /* Low */)
        {
            AssignCommand(player, SpeakString("-mimic " + sMimicStat + " Lo"));
        }
        if (index == checkedIndex++ /* Stop */)
        {
            AssignCommand(player, SpeakString("-mimic " + sMimicStat + " St"));
        }
        dlgChangePage(PG_MAIN_CHARACTER_MIMIC);
    }
    else if (page == PG_MAIN_CHARACTER_AUTOLOOT)
    {
        if (index == checkedIndex++ /* Gold */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_GOLD"))
                SetLocalInt(oHide, "AUTO_LOOT_GOLD", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_GOLD", TRUE);
        }
        if (index == checkedIndex++ /* Jewelry */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_JEWELRY"))
                SetLocalInt(oHide, "AUTO_LOOT_JEWELRY", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_JEWELRY", TRUE);
        }
        if (index == checkedIndex++ /* Heads */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_HEADS"))
                SetLocalInt(oHide, "AUTO_LOOT_HEADS", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_HEADS", TRUE);
        }
        if (index == checkedIndex++ /* Gems */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_GEMS"))
                SetLocalInt(oHide, "AUTO_LOOT_GEMS", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_GEMS", TRUE);
        }
        if (index == checkedIndex++ /* Pots */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_POTIONS"))
                SetLocalInt(oHide, "AUTO_LOOT_POTIONS", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_POTIONS", TRUE);
        }
        if (index == checkedIndex++ /* Kits */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_KITS"))
                SetLocalInt(oHide, "AUTO_LOOT_KITS", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_KITS", TRUE);
        }
        if (index == checkedIndex++ /* Scrolls */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_SCROLLS"))
                SetLocalInt(oHide, "AUTO_LOOT_SCROLLS", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_SCROLLS", TRUE);
        }
        if (index == checkedIndex++ /* Unidentifiables */)
        {
            if (GetLocalInt(oHide, "AUTO_LOOT_UNIDENTIFIED"))
                SetLocalInt(oHide, "AUTO_LOOT_UNIDENTIFIED", FALSE);
            else
                SetLocalInt(oHide, "AUTO_LOOT_UNIDENTIFIED", TRUE);
        }
        dlgChangePage(page); // Force a page reload to update current selections.
    }

}

void OnReset(string page)
{
    string lastPage  = PopDialoguePageFromStack();
    dlgChangePage(lastPage != "" ? lastPage : PG_MAIN);
    dlgResetPageNumber(); // Back to page 1 of the last page.
    CleanupDynamicPages(); // We do this each reset to get a fresh start.
}

void OnAbort(string page)
{
    CleanupDynamicPages();
    CleanupDialoguePages();
}

void OnEnd(string page)
{
    CleanupDynamicPages();
    CleanupDialoguePages();
}

void ChangeDialogue(string newDialogue)
{
    // It isn't clear how to transition between zzdialogs. _dlgStart doesn't work.
    // We're just going to hack our current convo closed then start a new one.
    object player = _dlgGetPcSpeaker();
    AssignCommand(player, ActionStartConversation(player, " ", TRUE, TRUE)); // Force this dialogue shut.
    DelayCommand(0.1, _dlgStart(player, player, newDialogue, TRUE, TRUE, TRUE)); // Start after a minor delay.
}

void ChangeDialoguePage(string currentPage, string newPage)
{
    PushDialoguePageToStack(currentPage);
    dlgChangePage(newPage);
}

void PushDialoguePageToStack(string page)
{
    dlgSetPlayerDataString("REST_DIALOGUE_STACK", page + " " + dlgGetPlayerDataString("REST_DIALOGUE_STACK"));
}

string PopDialoguePageFromStack()
{
    string stack = dlgGetPlayerDataString("REST_DIALOGUE_STACK");
    string page = StringParse(stack);
    dlgSetPlayerDataString("REST_DIALOGUE_STACK", StringRemoveParsed(stack, page));
    return page;
}

void CleanupDialoguePages()
{
    dlgClearResponseList(PG_MAIN);
    dlgClearResponseList(PG_MAIN_EMOTES);
    dlgClearResponseList(PG_MAIN_CHARACTER);
    dlgClearResponseList(PG_MAIN_CHARACTER_MIMIC);
    dlgClearResponseList(PG_MAIN_CHARACTER_MIMIC_VALUE);
    dlgClearResponseList(PG_MAIN_CHARACTER_SPECIAL);
    dlgClearResponseList(PG_MAIN_CHARACTER_SETTINGS);
    // TODO: dlgClearResponseList(PG_MAIN_CHARACTER_SPELLBOOKS);
    // TODO: dlgClearResponseList(PG_MAIN_CHARACTER_SPELLBOOKS_LOAD);
    // TODO: dlgClearResponseList(PG_MAIN_CHARACTER_SPELLBOOKS_SAVE);
    // TODO: dlgClearResponseList(PG_MAIN_CHARACTER_SPELLBOOKS_DELETE);
    dlgClearResponseList(PG_MAIN_APPEARANCE);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_OUTFITS);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_OUTFITS_LOAD);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_OUTFITS_SAVE);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_OUTFITS_DELETE);
    dlgClearResponseList(PG_MAIN_APPEARANCE_ARMOUR);
    dlgClearResponseList(PG_MAIN_APPEARANCE_ARMOUR_BODY);
    dlgClearResponseList(PG_MAIN_APPEARANCE_ARMOUR_ARMS);
    dlgClearResponseList(PG_MAIN_APPEARANCE_ARMOUR_LEGS);
    dlgClearResponseList(PG_MAIN_APPEARANCE_HELMET);
    dlgClearResponseList(PG_MAIN_APPEARANCE_CLOAK);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_MAINHAND);
    // TODO: dlgClearResponseList(PG_MAIN_APPEARANCE_OFFHAND);
    dlgClearResponseList(PG_MAIN_MISCELLANEOUS);
    dlgClearResponseList(PG_MAIN_HELP);

    dlgClearPlayerDataString("REST_DIALOGUE_STACK");
    dlgClearPlayerDataInt("REST_ITEM_SLOT");
    dlgClearPlayerDataInt("REST_ITEM_SUBSLOT");
    dlgClearPlayerDataString("REST_DYNAMIC_CRAFTING_OPTIONS");
    dlgClearPlayerDataInt("REST_DYNAMIC_CRAFTING_CUR_MODEL");
}

void CleanupDynamicPages()
{
    dlgClearResponseList(PG_DYNAMIC_CRAFTING);
    dlgClearResponseList(PG_DYNAMIC_COLOURS);
    dlgSetPlayerDataString("REST_DYNAMIC_CRAFTING_OPTIONS", "");
    dlgSetPlayerDataInt("REST_DYNAMIC_CRAFTING_CUR_MODEL", -1);
}

int IsSpecialAbilityIndexUsable(int index)
{
    object player = _dlgGetPcSpeaker();

    switch (index)
    {
        // I don't like that this logic is duplicated in three places: here, -help, and the chat script itself.
        // TODO: We need an inc_sabilities file which defines every special ability and whether it is available.
        case 0 /* Chaos */: return GetLocalInt(gsPCGetCreatureHide(player), "WILD_MAGE") && GetLevelByClass(CLASS_TYPE_WIZARD, player) >= 9;
        case 1 /* Detect Evil */: return GetDeity(player) != "" && gsWOGetPiety(player) >= 10.0 && GetAlignmentGoodEvil(player) == ALIGNMENT_GOOD && GetAlignmentLawChaos(player) == ALIGNMENT_LAWFUL && (GetLevelByClass(CLASS_TYPE_PALADIN, player) || GetLocalInt(gsPCGetCreatureHide(player), VAR_HARPER) == MI_CL_HARPER_PARAGON);
        case 2 /* Fate */: return GetLocalInt(gsPCGetCreatureHide(player), "WILD_MAGE") && GetLevelByClass(CLASS_TYPE_WIZARD, player) >= 21;
        case 3 /* Project Image */: return GetCanSendImage(player);
        case 4 /* Respite */: return GetIsHealer(player) && GetLevelByClass(CLASS_TYPE_CLERIC, player) >= 28;
        case 5 /* Scry */: return GetCanScry(player);
        case 6 /* Surge */: return GetLocalInt(gsPCGetCreatureHide(player), "WILD_MAGE");
        case 7 /* Teleport */: return GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, player);
        case 8 /* Track */: return GetLevelByClass(CLASS_TYPE_HARPER, player) || GetLevelByClass(CLASS_TYPE_RANGER, player);
        case 9 /* Two-hand */: return GetCreatureSize(player) >= CREATURE_SIZE_MEDIUM;
        case 10 /* Ward */: return GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, player);
        case 11 /* Yoink */: return GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, player);
    }

    return FALSE;
}

int GetActiveItemSlot()
{
    return dlgGetPlayerDataInt("REST_ITEM_SLOT");
}

void SetActiveItemSlot(int slotId)
{
    dlgSetPlayerDataInt("REST_ITEM_SLOT", slotId);
}

int GetActiveItemSubslot()
{
    return dlgGetPlayerDataInt("REST_ITEM_SUBSLOT");
}

void SetActiveItemSubslot(int subslotId)
{
    dlgSetPlayerDataInt("REST_ITEM_SUBSLOT", subslotId);
}

void AddDynamicCraftingOption(string id)
{
    string curData = GetDynamicCraftingOptions();

    if (curData != "")
    {
        curData += " ";
    }

    dlgSetPlayerDataString("REST_DYNAMIC_CRAFTING_OPTIONS", curData + id);
}

string GetDynamicCraftingOptions()
{
    return dlgGetPlayerDataString("REST_DYNAMIC_CRAFTING_OPTIONS");
}

void SetDynamicCraftingCurModel(int id)
{
    dlgSetPlayerDataInt("REST_DYNAMIC_CRAFTING_CUR_MODEL", id);
}

int GetDynamicCraftingCurModel()
{
    return dlgGetPlayerDataInt("REST_DYNAMIC_CRAFTING_CUR_MODEL");
}

int GetApperanceTypeForEqippedItem(object player, int slot, int isColour)
{
    int canBeWeapon = slot == INVENTORY_SLOT_LEFTHAND || slot == INVENTORY_SLOT_RIGHTHAND;

    if (isColour)
    {
        return canBeWeapon ? ITEM_APPR_TYPE_WEAPON_COLOR : ITEM_APPR_TYPE_ARMOR_COLOR;
    }
    else
    {
        if (canBeWeapon)
        {
            object item = GetItemInSlot(slot, player);
            int type = GetBaseItemType(item);

            if (type == BASE_ITEM_LARGESHIELD || type == BASE_ITEM_SMALLSHIELD || type == BASE_ITEM_TOWERSHIELD)
            {
                return ITEM_APPR_TYPE_SIMPLE_MODEL;
            }
            else
            {
                return ITEM_APPR_TYPE_WEAPON_MODEL;
            }
        }
        else if (slot == INVENTORY_SLOT_HEAD || slot == INVENTORY_SLOT_CLOAK)
        {
            return ITEM_APPR_TYPE_SIMPLE_MODEL;
        }
    }

    return ITEM_APPR_TYPE_ARMOR_MODEL;
}

object ModifyItem(object item, int slot, int apprType, int subslot, int partId)
{
    object copy = gsCMCopyItemAndModify(item, apprType, subslot, partId, TRUE);
    DestroyObject(item);
    return copy;
}

void ModifyEquippedItem(object player, int slot, int apprType, int subslot, int partId)
{
    object item = GetItemInSlot(slot, player);

    if (GetIsObjectValid(item))
    {
        object copy = gsCMCopyItemAndModify(item, apprType, subslot, partId, TRUE);
        AssignCommand(player, ActionEquipItem(copy, slot));
        DestroyObject(item);
    }
}

int GetEquippedPartID(object player, int slot, int apprType, int subslot)
{
    object item = GetItemInSlot(slot, player);
    if(ITEM_APPR_TYPE_ARMOR_COLOR == apprType)
    {
        int nSubSlot =  GetActiveItemSubslot();
        if(nSubSlot > -1)
        {
            string sApp = NWNX_Item_GetEntireItemAppearance (item);

            int nStart = 56 + nSubSlot * 2 + subslot * 19 * 2;
            return ConvertHexToDec(GetSubString(sApp, nStart, 2));
        }
    }
    return GetIsObjectValid(item) ? GetItemAppearance(item, apprType, subslot) : -1;
}

string GenerateOverrideString(int nFrom, int nTo, int nColor, string sApp)
{
    int nStart = 56 + nFrom * 2 + nColor * 19 * 2;
    string sMiddle = GetSubString(sApp, nStart, 2);

    nStart = 56 + nTo * 2 + nColor * 19 * 2;

    return GetStringLeft(sApp, nStart) + sMiddle + GetStringRight(sApp, GetStringLength(sApp) - 2 - nStart);
}
