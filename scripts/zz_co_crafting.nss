/*
zz_co_crafting

Gigaschatten's Crafting Conversation (gs_cr_recipe) converted to ZZ-Dialog by
Fireboar. I've split this up into seven pages - each has their own initialization
and selection functions so it should be pretty easy to work out what goes on where.
Will work for both crafting book conversations and workstation conversations.

Page 1: Select trade skill
Page 2: Select item category
Page 3: Select product
Page 4: Confirm product selection
Page 5: Remove product (for DMs only)
Page 6: Increase skill rank
Page 7: Proceed with crafting/repairing (split into 3 sub-parts)
Page 8: Decrease skill rank

The "handle fixture object" conversation option relies on zz_co_fixture (a port
of gs_fx_use also converted to ZZ-Dialog). Also, this script MUST be called
zz_co_crafting for it to work (to change this, do a find+replace on all the places
where zz_co_crafting is mentioned).
*/

#include "gs_inc_istate"
#include "fb_inc_chatutils"
#include "zzdlg_main_inc"
#include "md_inc_conclrace"
#include "gs_inc_pc"

const string FB_RESPONSES = "FB_RESPONSES";

const string FB_VAR_CHOSEN_CATEGORY = "FB_DL_CHOSEN_CATEGORY";
const string FB_VAR_CHOSEN_PRODUCT  = "FB_DL_CHOSEN_PRODUCT";
const string FB_VAR_CHOSEN_TRADE    = "FB_DL_CHOSEN_TRADE";
const string FB_VAR_ITEM            = "GS_ITEM";
const string FB_VAR_OFFSET_CATEGORY = "FB_DL_OFFSET_CATEGORY";
const string FB_VAR_OFFSET_PRODUCT  = "FB_DL_OFFSET_PRODUCT";
const string FB_VAR_SKILL           = "GS_SKILL";
const string FB_VAR_WORK_PROGRESS   = "FB_DL_WORK_PROGRESS";

const string MD_LIST_FEAT_ID        = "LIST_FEAT_ID";

const string LIST_IDS               = "CR_LIST_ID";
// Function declaration

void Init1();
void Init2();
void Init3();
void Init4();
void Init5();
void Init6();
void Init7();
void Init8();
void Race();
void Class();
void Placeable();
void Sel1();
void Sel2();
void Sel3();
void Sel4();
void Sel5();
void Sel6();
void Sel7();
void Sel8();
void RaceS();
void ClassS();
void PlaceableS();
void Cleanup();
void Category();
void CategoryS();
void Skill();
void SkillS();
void Feat();
void FeatS();
void Setting();
void SettingS();

// Helper function to add a response with less typing :)
void fbResponse(string sResponse, int bIsAction = FALSE);
void fbResponse(string sResponse, int bIsAction = FALSE)
{
    if (bIsAction) dlgAddResponseAction(FB_RESPONSES, sResponse);
    else           dlgAddResponseTalk(FB_RESPONSES, sResponse);
}
// Helper functions for the Open inventory response
void fbOpen();
void fbOpen()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF))
        fbResponse("[Open inventory]", TRUE);
}
void fbOpenAction();
void fbOpenAction()
{
    object oSelf = OBJECT_SELF;
    AssignCommand(dlgGetSpeakingPC(), ActionInteractObject(oSelf));
    dlgEndDialog();
}

void OnInit()
{
    dlgSetActiveResponseList(FB_RESPONSES);
    dlgActivateEndResponse("[Done]", DLG_DEFAULT_TXT_ACTION_COLOR);
    // Is this a placeable or an item?
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF))
    {
        dlgChangePage("7");
    }
    else dlgChangePage("1");
}
void OnPageInit(string sPage)
{
    dlgClearResponseList(FB_RESPONSES);
    switch (StringToInt(sPage))
    {
        case 1: Init1(); break;
        case 2: Init2(); break;
        case 3: Init3(); break;
        case 4: Init4(); break;
        case 5: Init5(); break;
        case 6: Init6(); break;
        case 7: Init7(); break;
        case 8: Race(); break;
        case 9: Class(); break;
        case 10: Placeable(); break;
        case 11: Category(); break;
        case 12: Skill(); break;
        case 13: Feat(); break;
        case 14: Setting(); break;
        case 15: Init8(); break;
   }
}
void OnSelection(string sPage)
{
    switch (StringToInt(sPage))
    {
        case 1: Sel1(); break;
        case 2: Sel2(); break;
        case 3: Sel3(); break;
        case 4: Sel4(); break;
        case 5: Sel5(); break;
        case 6: Sel6(); break;
        case 7: Sel7(); break;
        case 8: RaceS(); break;
        case 9: ClassS(); break;
        case 10: PlaceableS(); break;
        case 11: CategoryS(); break;
        case 12: SkillS(); break;
        case 13: FeatS(); break;
        case 14: SettingS(); break;
        case 15: Sel8() ; break;
    }
}
// Continue strings not used here
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
    if (sPage == "5") dlgChangePage("4");
    else if (sPage == "6") dlgChangePage("2");
    else if (sPage == "15") dlgChangePage("2");
    else if (sPage == "7") dlgClearPlayerDataInt(FB_VAR_WORK_PROGRESS);
}
void OnEnd(string sPage)
{
    Cleanup();
}
void OnAbort(string sPage)
{
    Cleanup();
}
void main()
{
    dlgOnMessage();
}

// Initialization pages
void Init1()
{
    object oSpeaker = dlgGetSpeakingPC();
    string sProductCount = IntToString(gsCRGetRecipeCount());
    int bStaticLevel = GetLocalInt(GetModule(), "STATIC_LEVEL");

    int nDailyMaxPoints = (GetLocalInt(gsPCGetCreatureHide(oSpeaker), "GIFT_CRAFTSMANSHIP") == 1) ? 60 : 50;

    dlgSetPrompt(txtBlue + "Select trade skill</c>"
                         + "\n\nTotal number of defined products: " + sProductCount
                         + "\nCrafting points available today: " + IntToString(gsCRGetCraftPoints(oSpeaker))
                                                           + "/" + IntToString(nDailyMaxPoints)
                         + "\n\nSR = Your skill rank");
    fbResponse(gsCRGetSkillName(GS_CR_SKILL_FORGE)     + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_FORGE,     oSpeaker))+"]");
    if (!bStaticLevel) fbResponse(gsCRGetSkillName(GS_CR_SKILL_CARPENTER) + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_CARPENTER, oSpeaker))+"]");
    fbResponse(gsCRGetSkillName(GS_CR_SKILL_SEW)       + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_SEW,       oSpeaker))+"]");
    fbResponse(gsCRGetSkillName(GS_CR_SKILL_MELD)      + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_MELD,      oSpeaker))+"]");
    fbResponse(gsCRGetSkillName(GS_CR_SKILL_CRAFT_ART) + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_CRAFT_ART, oSpeaker))+"]");
    fbResponse(gsCRGetSkillName(GS_CR_SKILL_COOK)      + " [SR="+IntToString(gsCRGetSkillRank(GS_CR_SKILL_COOK,      oSpeaker))+"]");
    // No reset required
    dlgDeactivateResetResponse();
}
void Init2()
{
    object oSpeaker = dlgGetSpeakingPC();
    object oHide = gsPCGetCreatureHide(oSpeaker);
    int nSkill      = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);

    dlgSetPrompt(gsCRGetSkillName(nSkill)+"\n"+txtBlue+"Select item category</c>\n\n"+
        "Your skill rank: "+IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));

    // Find 5 categories starting from the offset
    int nFirst    = GetLocalInt(oSpeaker, FB_VAR_OFFSET_CATEGORY+IntToString(nSkill)); // save page across uses
    int nCategory = gsCRGetFirstCategory(nSkill, nFirst);
    int nSlot     = 1;

    int nTrueCategory;
    while (TRUE)
    {
        dlgSetSpeakeeDataInt("GS_SLOT_" + IntToString(nSlot), nCategory);
        nTrueCategory = md_ConvertToCategory(nCategory);
        if (nCategory != -1)
        {
            fbResponse(gsCRGetCategoryName(nTrueCategory)+"("+IntToString(gsCRGetCategoryCount(nSkill, nTrueCategory))+" products)");
        }

        if (++nSlot > 5) break;

        if (nCategory != -1)  nCategory = gsCRGetNextCategory(nSkill, nCategory);
    }

    // Menu options
    if (gsCRGetSkillPoints(oSpeaker) > 0)
        fbResponse("[Increase skill rank]", TRUE);
    if (GetLocalInt(oHide,"SkillPointPool") > 0)
        fbResponse("[Decrease skill rank]", TRUE);
    if (nCategory > 0 && gsCRGetNextCategory(nSkill, nCategory) != -1)
        fbResponse("[Next page]", TRUE);
    if (dlgGetSpeakeeDataInt("GS_SLOT_1") > 0 && gsCRGetPreviousCategory(nSkill, dlgGetSpeakeeDataInt("GS_SLOT_1")) != -1)
        fbResponse("[Previous page]", TRUE);
    fbResponse("[Back]", TRUE); // Shame this isn't the last option, or I would use OnReset...
    fbOpen();
    dlgDeactivateResetResponse();
}
void Init3()
{
    object oSpeaker = dlgGetSpeakingPC();
    int nSkill      = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nCategory   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY);

    dlgSetPrompt(gsCRGetSkillName(nSkill)+"\n"+gsCRGetCategoryName(nCategory)+"\n"+
        txtBlue+"Select product</c>\n\nYour skill rank: "+
        IntToString(gsCRGetSkillRank(nSkill, oSpeaker))+"\nDC = Severity (difficulty check)");

    // Find 5 recipes in nCategory starting from the offset
    int nFirst  = dlgGetPlayerDataInt(FB_VAR_OFFSET_PRODUCT);
    int nRecipe = gsCRGetFirstRecipe(nSkill, nCategory, nFirst);
    int nSlot   = 1;
    struct gsCRRecipe stRecipe;

    while (TRUE)
    {

        if (nRecipe != -1)
        {
            stRecipe = gsCRGetRecipeInSlot(nSkill, nRecipe);
            if(mdCRShowRecipe(stRecipe, oSpeaker))
            {
                WriteTimestampedLogEntry("Reading... zz_co_crafting ID: " + stRecipe.sID + " Slot: " + IntToString(nRecipe) + " Name: " + stRecipe.sName + " Skill: " + IntToString(nSkill));
                fbResponse(stRecipe.sName+" [DC="+IntToString(gsCRGetRecipeDC(stRecipe))+"] [ID: " + stRecipe.sID + "]");
                dlgSetSpeakeeDataInt("GS_SLOT_" + IntToString(nSlot), nRecipe);
            }
            else
                --nSlot;  //have to let nslot accumilate outside of this if. But lower it if recipe is hidden
        }

         if (++nSlot > 5) break;
        if (nRecipe != -1)  nRecipe = gsCRGetNextRecipe(nSkill, nCategory, nRecipe);
    }

    // Menu options
    if (nRecipe > 0 && gsCRGetNextRecipe(nSkill, nCategory, nRecipe) != -1)
        fbResponse("[Next page]", TRUE);
    if (dlgGetSpeakeeDataInt("GS_SLOT_1") > 1&& gsCRGetPreviousRecipe(nSkill, nCategory, dlgGetSpeakeeDataInt("GS_SLOT_1")) != -1)
        fbResponse("[Previous page]", TRUE);
    fbResponse("[Back]", TRUE); // Shame this isn't the last option, or I would use OnReset...
    fbOpen();
    dlgDeactivateResetResponse();
}
void Init4()
{
    object oSpeaker = dlgGetSpeakingPC();
    int nSkill      = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nCategory   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY);
    int nRecipe     = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    int bPlaceable  = GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF);
    struct gsCRRecipe stRecipe;

    // dunshine: check to see if this is the remains of a fixture, in that case we won't have an item, but still want to be able to repair
    // status 1 means the materials are still required to start reparations
    // status 2 means the materials are already used and repairment is underway
    int iRemains = StringToInt(GetLocalString(OBJECT_SELF, "GVD_REMAINS_STATUS"));

    if (iRemains == 1) {
      // fixture repair recipe
      stRecipe = gsCRGetRecipeByID(nSkill, gvd_CRGetRecipeForResRef(GetLocalString(OBJECT_SELF, "GVD_REMAINS_RESREF_ITEM")));

    } else {
      // normal crafting recipe
      stRecipe = gsCRGetRecipeInSlot(nSkill, nRecipe);
    }

    // struct gsCRQuantity stQuantity;

    // Slightly different output for the placeable versus the book
    string sRequirement = "";
    if (bPlaceable)
    {
          gsCRGetQuantity(stRecipe);
          sRequirement = gsCRGetQuantityList(stRecipe);
    }
    else
    {
        sRequirement = gsCRGetRecipeInputList(stRecipe);
    }

    string sRaces = "";
    sRaces = mdCRGetRecipeRaceList(stRecipe);
    if(sRaces != "")
        sRaces = txtBlue+"(Sub)Racial Requirements:</c>"+sRaces+"\n";

    string sClass = "";
    sClass = mdCRGetRecipeClassList(stRecipe);
    if(sClass != "")
        sClass = txtBlue+"Class Requirements (Minimum Level: " + IntToString(stRecipe.nLevel) + "/"+ (stRecipe.nSettings & SETTING_LVLADDITIVE ? "additive":"singular") +"):</c>"+sClass+"\n";

    string sSkill = "";
    sSkill = mdCRGetRecipeSkillList(stRecipe);
    if(sSkill != "")
        sSkill = txtBlue+"Skill Requirements (Match " + (stRecipe.nSettings & SETTING_ONESKILL ? "one.":"all.") + " Feat bonuses: " + (stRecipe.nSettings & SETTING_SKILLFEAT ? "Enabled.":"Disabled.") + " Base Ability: " + (stRecipe.nSettings & SETTING_ABILITY ? "Enabled.":"Disabled.")+ "):</c>"+sSkill+"\n";

    string sFeat = "";
    sFeat = mdCRGetRecipeFeatList(stRecipe);
    if(sFeat != "")
        sFeat = txtBlue+"Feat Requirements (Match " + (stRecipe.nSettings & SETTING_ONEFEAT ? "one.":"all.")+ "):</c>"+sFeat+"\n";
    // A humongous string of output for the compiler to churn through - what fun!
    if (iRemains == 1) {
      dlgSetPrompt(gsCRGetSkillName(nSkill)+"\n"+stRecipe.sName+"\n\n"+
        txtBlue+"Severity (DC):</c> 10"+"\n"+
        txtBlue+"Required crafting points:</c> 25"+"\n"+
        txtBlue+"Material requirement:</c>"+sRequirement+"\n"+
        sRaces+
        sClass+
        txtBlue+"End product:</c>"+gsCRGetRecipeOutputList(stRecipe)+"\n\n"+
        "Your skill rank: "+IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
    } else {
      dlgSetPrompt(gsCRGetSkillName(nSkill)+"\n"+gsCRGetCategoryName(nCategory)+"\n"+stRecipe.sName+"\n\n"+
        txtBlue+"Severity (DC):</c> "+IntToString(gsCRGetRecipeDC(stRecipe))+"\n"+
        txtBlue+"Required crafting points:</c> "+IntToString(gsCRGetRecipeCraftPoints(stRecipe))+"\n"+
        txtBlue+"Total value:</c> "+IntToString(stRecipe.nValue)+" gold\n"+
        txtBlue+"Material requirement:</c>"+sRequirement+"\n"+
        sRaces+
        sClass+
        sSkill+
        sFeat+
        txtBlue+"End product:</c>"+gsCRGetRecipeOutputList(stRecipe)+"\n\n"+
        "Your skill rank: "+IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
    }

    if (bPlaceable)
    {
        if (gsCRGetIsQuantitySufficient(stRecipe) && mdCRMeetsRequirements(stRecipe, oSpeaker))
            fbResponse("[OK]", TRUE);

        fbResponse("[Preview properties]", TRUE);
    }

    if (GetIsDM(oSpeaker))
    {
        fbResponse("[Remove product]", TRUE);
        if(GetTag(GetArea(oSpeaker)) == "GS_AREA_TRADE")
        {
            fbResponse("[Set DC [Speak Before Selecting]]", TRUE);
            fbResponse("[Set Points [Speak Before Selecting]]", TRUE);
            fbResponse("[Set Value [Speak Before Selecting]]", TRUE);
            fbResponse("[Set Name [Speak Before Selecting]]", TRUE);
            fbResponse("[Set Race]", TRUE);
            fbResponse("[Set Class]", TRUE);
            fbResponse("[Set Skills]", TRUE);
            fbResponse("[Set Feats]", TRUE);
            fbResponse("[Set Class Level [Speak Before Selecting]]", TRUE);
            fbResponse("[Set Category [Speak Name Before Selecting]]", TRUE);
            //fbResponse("[Set Hidden]", TRUE);
            //fbResponse("[Set Additive Levels]", TRUE);
            fbResponse("[Set Settings]", TRUE);
            fbResponse("[Set Placeable Tag]", TRUE);
            fbResponse("[Replace Input with Input Barrel]", TRUE);
            fbResponse("[Replace Output with Output Barrel]", TRUE);
        }
    }
    if (iRemains == 0) {
      fbResponse("[Back]", TRUE); // Shame this isn't the last option, or I would use OnReset...
    }
    fbOpen();
    dlgDeactivateResetResponse();
}
void Init5()
{
    struct gsCRRecipe stRecipe;
    int nSkill  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe    = gsCRGetRecipeInSlot(nSkill, nRecipe);

    dlgSetPrompt("Are you sure you want to remove the product "+txtLime+stRecipe.sName+
        "</c> from the trade system?");
    fbResponse("[OK]", TRUE);
    dlgActivateResetResponse("[Cancel]", txtLime);
}
void Init6()
{
    object oSpeaker = dlgGetSpeakingPC();
    int nSkill  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);

    dlgSetPrompt("Increase skill rank\n\nDo you want to increase your skill rank at "+
        gsCRGetSkillName(nSkill)+"?\n\nYour skill rank: "+IntToString(gsCRGetSkillRank(nSkill, oSpeaker))+
        "\nRemaining trade skill points: "+IntToString(gsCRGetSkillPoints(oSpeaker)));
    fbResponse("[OK]", TRUE);
    dlgActivateResetResponse("[Back]", txtLime);
}
void Init7()
{
    // 3 possible prompts: proceed, repair or standard.
    object oSpeaker   = dlgGetSpeakingPC();
    object oItem      = GetFirstItemInInventory();
    int nSkill        = dlgGetSpeakeeDataInt(FB_VAR_SKILL);
    int nRank         = gsCRGetSkillRank(nSkill, oSpeaker);
    string sRank      = IntToString(nRank);
    int nPoints       = gsCRGetCraftPoints(oSpeaker);
    string sPoints    = IntToString(nPoints);
    string sString    = "GS_CR_" + IntToString(nSkill) + "_";
    int nCount        = GetStringLength(sString);
    int nState        = 0;
    int nStateMaximum = 0;
    int bProgress     = dlgGetPlayerDataInt(FB_VAR_WORK_PROGRESS);

    // dunshine: check to see if this is the remains of a fixture, in that case we won't have an item, but still want to be able to repair
    // status 1 means the materials are still required to start reparations
    // status 2 means the materials are already used and repairment is underway
    int iRemains = StringToInt(GetLocalString(OBJECT_SELF, "GVD_REMAINS_STATUS"));

    while (GetIsObjectValid(oItem) || (iRemains == 2))
    {
        // Candidate found for response 1
        if ((GetStringLeft(ConvertedStackTag(oItem), nCount) == sString) || (iRemains == 2))
        {
            struct gsCRProduction stProduction;

            if (iRemains == 2) {
              stProduction.nSkill = GetLocalInt(OBJECT_SELF, "GS_SKILL");
              stProduction.sRecipe = gvd_CRGetRecipeForResRef(GetLocalString(OBJECT_SELF, "GVD_REMAINS_RESREF_ITEM"));
              stProduction.nCraftPoints = StringToInt(GetLocalString(OBJECT_SELF, "GVD_REMAINS_CRAFTPOINTS"));

            } else {
              stProduction = gsCRGetProductionData(oItem);

            }
            struct gsCRRecipe stRecipe         = gsCRGetRecipeByID(stProduction.nSkill, stProduction.sRecipe);
            int nCraftPoints                   = gsCRGetRecipeCraftPoints(stRecipe);

            int nDC                            = gsCRGetRecipeDC(stRecipe);

            // flat 25 and 10 for repairs
            if (iRemains == 2) {
              nCraftPoints = 25;
              nDC = 10;
            }

            string sPercent                    = IntToString(100 * stProduction.nCraftPoints / nCraftPoints);

            // This is going to be one heck of a long string but here we go...
            dlgSetPrompt("Started production ("+sPercent+"% completed)\n\n"+
                txtBlue+"Product name:</c> "+stRecipe.sName+"\n"+
                txtBlue+"Item category:</c> "+gsCRGetCategoryName(stRecipe.nCategory)+"\n"+
                txtBlue+"Severity (DC):</c> "+IntToString(nDC)+"\n"+
                txtBlue+"Required crafting points:</c> "+txtRed+IntToString(stProduction.nCraftPoints)+
                "</c> / "+txtLime+IntToString(nCraftPoints)+"</c>\n"+
                txtBlue+"Total value:</c> "+IntToString(stRecipe.nValue)+" gold\n"+
                txtBlue+"End product:</c>"+gsCRGetRecipeOutputList(stRecipe)+"\n\n"+
                "Your skill rank: "+sRank+"\nRemaining daily crafting points: "+sPoints);

            if (nPoints > 0 && !bProgress && stProduction.sRecipe == stRecipe.sID) fbResponse("[Proceed with production]", TRUE);

            dlgSetSpeakeeDataObject(FB_VAR_ITEM, oItem);
            break;
        }
        // Candidate found for response 2
        else if (gsISGetItemCraftSkill(oItem) == nSkill)
        {
            nState        = gsISGetItemState(oItem);
            nStateMaximum = gsISGetMaximumItemState(oItem);

            if (nState < nStateMaximum)
            {
                dlgSetPrompt("Damaged item\n\n"+txtBlue+"Item:</c> "+GetName(oItem)+"\n"+
                    txtBlue+"State:</c> "+txtRed+IntToString(nState)+"</c> / "+
                    txtLime+IntToString(nStateMaximum)+"</c>\n"+
                    txtBlue+"Severity (DC):</c> "+IntToString(gsISGetItemRepairDC(oItem))+"\n\n"+
                    "Your skill rank: "+sRank+"\nRemaining daily crafting points: "+sPoints);

                if (nPoints > 0 && !bProgress) fbResponse("[Repair item]", TRUE);

                dlgSetSpeakeeDataObject(FB_VAR_ITEM, oItem);
                break;
            }
        }

        oItem = GetNextItemInInventory();
    }
    // No candidate found, use response 3
    if (!GetIsObjectValid(oItem) && (iRemains != 2))
    {
        dlgSetPrompt(txtBlue+"[Select action]</c>\n\nYour skill rank: "+sRank+"\nRemaining daily crafting points: "+sPoints);
    }

    // Display work options
    if (bProgress)
    {
        if (nRank > 0)
        {
            fbResponse("[Use 1 crafting point]", TRUE);
            fbResponse("[Use 5 crafting points]", TRUE);
            fbResponse("[Use 10 crafting points]", TRUE);
            fbResponse("[Use 25 crafting points]", TRUE);
            fbResponse("[Use required crafting points]", TRUE);
        }
        if (iRemains == 0) {
          dlgActivateResetResponse("[Back]", txtLime);
        }
    }
    // Display generic options
    else
    {
        if (iRemains == 0) {
          if (nRank > 0) fbResponse("[Create new production]", TRUE);
          if (nRank > 0) fbResponse("[Create new production by ID. Enter ID before selecting]", TRUE);
          if (nRank > 0) fbResponse("[Improve Item]", TRUE);
          fbOpen();
        } else if (iRemains == 1) {
          if (nRank > 0) fbResponse("[Repair this fixture]", TRUE);
        }
        if (GetStringLeft(GetTag(OBJECT_SELF), 6) == "GS_FX_") fbResponse("[Handle fixture object]", TRUE);
        dlgDeactivateResetResponse();
    }

    // Store the trade for the remainder of the conversation
    dlgSetPlayerDataInt(FB_VAR_CHOSEN_TRADE, nSkill);
}

void Init8()
{
    object oSpeaker = dlgGetSpeakingPC();
    object oHide = gsPCGetCreatureHide(oSpeaker);

    int nSkill  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);

    dlgSetPrompt("Decrease skill rank\n\nDo you want to decrease your skill rank at "+
        gsCRGetSkillName(nSkill)+"?\n\nYour skill rank: "+IntToString(gsCRGetSkillRank(nSkill, oSpeaker))+
        "\nAvailable skill points to transfer: "+IntToString(GetLocalInt(oHide,"SkillPointPool")));
    fbResponse("[OK]", TRUE);
    dlgActivateResetResponse("[Back]", txtLime);
}

// Private function for the selection pages to jump the PC straight back into
// the conversation after a brief animation
void _Sel(object oObject)
{
    // Play animation
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.5);

    // Gets conversation parameters from placeable.
    int nMakeprivate = GetLocalInt(oObject, DLG_VARIABLE_MAKEPRIVATE);
    int nNoHello     = GetLocalInt(oObject, DLG_VARIABLE_NOHELLO);
    int nNoZoom      = GetLocalInt(oObject, DLG_VARIABLE_NOZOOM);

    // Start the dialog between the placeable and the player
    ActionDoCommand(_dlgStart(OBJECT_SELF, oObject, "zz_co_crafting", nMakeprivate, nNoHello, nNoZoom));
}

// Selection pages
void Sel1()
{
    int nResponse;
    int nSelection = dlgGetSelectionIndex();

    // Carpentering is removed in FL.
    if (GetLocalInt(GetModule(), "STATIC_LEVEL") && nSelection) nSelection++;

    switch (nSelection)
    {
    case 0:
        nResponse = GS_CR_SKILL_FORGE;
        break;
    case 1:
        nResponse = GS_CR_SKILL_CARPENTER;
        break;
    case 2:
        nResponse = GS_CR_SKILL_SEW;
        break;
    case 3:
        nResponse = GS_CR_SKILL_MELD;
        break;
    case 4:
        nResponse = GS_CR_SKILL_CRAFT_ART;
        break;
    case 5:
        nResponse = GS_CR_SKILL_COOK;
        break;
    }
    dlgSetPlayerDataInt(FB_VAR_CHOSEN_TRADE, nResponse);
    dlgChangePage("2");
}
void Sel2()
{
    object oSpeaker  = dlgGetSpeakingPC();
    string sResponse = dlgGetSelectionName();
    int nSkill       = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);

    if (sResponse == "[Increase skill rank]")
        dlgChangePage("6");
    else if (sResponse == "[Decrease skill rank]")
        dlgChangePage("15");
    else if (sResponse == "[Next page]")
        SetLocalInt(oSpeaker, FB_VAR_OFFSET_CATEGORY+IntToString(nSkill), gsCRGetNextCategory(nSkill, dlgGetSpeakeeDataInt("GS_SLOT_5")));
    else if (sResponse == "[Previous page]")
    {
        int nNth1 = GetLocalInt(oSpeaker, FB_VAR_OFFSET_CATEGORY+IntToString(nSkill));
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 5; nNth2++)
        {
            nNth3 = gsCRGetPreviousCategory(nSkill, nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }
        SetLocalInt(oSpeaker, FB_VAR_OFFSET_CATEGORY+IntToString(nSkill), nNth1);
    }
    else if (sResponse == "[Back]")
    {
        // Is this a placeable or an item?
        if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF))
        {
            dlgChangePage("7");
        }
        else dlgChangePage("1");
        dlgClearPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        DeleteLocalInt(oSpeaker, FB_VAR_OFFSET_CATEGORY+IntToString(nSkill));
    }
    else if (sResponse == "[Open inventory]") fbOpenAction();
    // Category selected
    else
    {
        string sSlot = IntToString(dlgGetSelectionIndex() + 1);
        dlgSetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY, md_ConvertToCategory(dlgGetSpeakeeDataInt("GS_SLOT_"+sSlot)));
        dlgChangePage("3");
    }
}
void Sel3()
{
    object oSpeaker  = dlgGetSpeakingPC();
    string sResponse = dlgGetSelectionName();
    int nSkill       = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nCategory    = dlgGetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY);

    if (sResponse == "[Next page]")
        dlgSetPlayerDataInt(FB_VAR_OFFSET_PRODUCT, gsCRGetNextRecipe(nSkill, nCategory, dlgGetSpeakeeDataInt("GS_SLOT_5")));
    else if (sResponse == "[Previous page]")
    {
        int nNth1 = dlgGetPlayerDataInt(FB_VAR_OFFSET_PRODUCT);
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 5; nNth2++)
        {
            nNth3 = gsCRGetPreviousRecipe(nSkill, nCategory, nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }
        dlgSetPlayerDataInt(FB_VAR_OFFSET_PRODUCT, nNth1);
    }
    else if (sResponse == "[Back]")
    {
        // Go back one page
        dlgChangePage("2");
        dlgClearPlayerDataInt(FB_VAR_CHOSEN_CATEGORY);
        dlgClearPlayerDataInt(FB_VAR_OFFSET_PRODUCT);
    }
    else if (sResponse == "[Open inventory]") fbOpenAction();
    // Product selected
    else
    {
        string sSlot = IntToString(dlgGetSelectionIndex() + 1);
        dlgSetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT, dlgGetSpeakeeDataInt("GS_SLOT_"+sSlot));
        dlgChangePage("4");
    }
}
void Sel4()
{
    object oSpeaker = GetPCSpeaker();
    string sResponse = dlgGetSelectionName();

    // Begin crafting
    if (sResponse == "[OK]")
    {
        struct gsCRRecipe stRecipe;
        object oSelf = OBJECT_SELF;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);

        // Start a new production (skip this for fixture repairs)
        if (GetLocalString(OBJECT_SELF, "GVD_REMAINS_STATUS") == "") {
          gsCRCreateProduction(stRecipe, oSpeaker);
        } else {
          // update repair status from needing resources to repairing
          gsCRGetQuantity(stRecipe, OBJECT_SELF);
          //check material quantity
          if (gsCRGetIsQuantitySufficient(stRecipe, OBJECT_SELF)) {
            gsCRConsumeMaterial(stRecipe, OBJECT_SELF);
            gsFXSetLocalString(OBJECT_SELF, "GVD_REMAINS_STATUS", "2");
          }
        }

        // Play an appropriate sound and animation
        gsCRPlaySound(nSkill);
        AssignCommand(oSpeaker, _Sel(oSelf));

        // End the dialog - it'll come straight back up afterwards.
        dlgEndDialog();
    }
    else if (sResponse == "[Preview properties]")
    {
        struct gsCRRecipe recipe = gsCRGetRecipeInSlot(dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE), dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT));
        string resref = GetLocalString(oSkillCache, recipe.sSlot + "_OUTPUT_RESREF_1");
        object item = CreateItemOnObject(resref, GetObjectByTag("gvd_tempchest"));
        DestroyObject(item, 2.0f);

        if (GetIsObjectValid(item))
        {
            SetIdentified(item, TRUE);
            SetLocalInt(item, "DO_NOT_REVERT", 1);
            DelayCommand(0.25f, AssignCommand(oSpeaker, ActionExamine(item)));
            DelayCommand(1.75f, SendMessageToPC(oSpeaker, GetDescription(item)));
        }
    }
    // Remove chosen product (DM only)
    else if (sResponse == "[Remove product]")
    {
        dlgChangePage("5");
    }
    else if(sResponse == "[Set DC [Speak Before Selecting]]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sSpeak = chatGetLastMessage(oSpeaker);
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "DC", sSpeak);
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_DC", StringToInt(sSpeak));
        SendMessageToPC(oSpeaker, "DC set to: " + sSpeak);
    }
    else if(sResponse == "[Set Points [Speak Before Selecting]]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sSpeak = chatGetLastMessage(oSpeaker);
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_POINTS", StringToInt(sSpeak));
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Points", sSpeak);
        SendMessageToPC(oSpeaker, "Points set to: " + sSpeak);
    }
    else if(sResponse == "[Set Value [Speak Before Selecting]]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sSpeak = chatGetLastMessage(oSpeaker);
        if(StringToInt(sSpeak) <= 0)
        {
            SendMessageToPC(oSpeaker, "Cannot set value to 0 or less");
            return;
        }
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_VALUE", StringToInt(sSpeak));
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Value", sSpeak);
        SendMessageToPC(oSpeaker, "Value set to: " + sSpeak);
    }
    else if(sResponse == "[Set Name [Speak Before Selecting]]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sSpeak = chatGetLastMessage(oSpeaker);
        SetLocalString(oSkillCache, IntToString(nRecipe) + "_NAME", sSpeak);
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Name", sSpeak);
        SendMessageToPC(oSpeaker, "Name set to: " + sSpeak);
    }
    else if(sResponse ==  "[Set Race]")
    {
        dlgChangePage("8");
    }
    else if(sResponse == "[Set Class]")
    {
        dlgChangePage("9");
    }
    else if(sResponse == "[Set Skills]")
        dlgChangePage("12");
    else if(sResponse == "[Set Feats]")
        dlgChangePage("13");
    else if(sResponse == "[Set Category [Speak Name Before Selecting]]")
    {
        dlgChangePage("11");

    }
    else if(sResponse == "[Set Class Level [Speak Before Selecting]]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sSpeak = chatGetLastMessage(oSpeaker);
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_LEVEL", StringToInt(sSpeak));
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Class_Level", sSpeak);
        SendMessageToPC(oSpeaker, "Class level set to: " + sSpeak);
    }
    else if(sResponse == "[Set Settings]")
    {
        dlgChangePage("14");
    }
   /* else if(sResponse == "[Set Hidden]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        int nSettings =  StringToInt(miDAGetKeyedValue("md_cr_recipes", stRecipe.sID, "Settings"));
        if(SETTING_HIDDEN & nSettings)
        {
            SendMessageToPC(oSpeaker, "Recipe no longer hidden");
            nSettings = nSettings & ~SETTING_HIDDEN;
        }
        else
        {
            SendMessageToPC(oSpeaker, "Recipe hidden");
            nSettings = nSettings | SETTING_HIDDEN;

        }
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_SETTINGS", nSettings);
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Settings", IntToString(nSettings));
    }
    else if(sResponse == "[Set Additive Levels]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        int nSettings =  stRecipe.nSettings;
        if(SETTING_LVLADDITIVE & nSettings)
        {
            SendMessageToPC(oSpeaker, "Recipe no longer additive");
            nSettings = nSettings & ~SETTING_LVLADDITIVE;
        }
        else
        {
            SendMessageToPC(oSpeaker, "Recipe additive");
            nSettings = nSettings | SETTING_LVLADDITIVE;

        }
        SetLocalInt(oSkillCache, IntToString(nRecipe) + "_SETTINGS", nSettings);
        miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Settings", IntToString(nSettings));
    } */
    else if(sResponse == "[Set Placeable Tag]")
    {
        dlgChangePage("10");
    }
    else if(sResponse == "[Replace Input with Input Barrel]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_1");
        int x = 1;
        while(sResRef != "")
        {
            DeleteLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_"+sResRef);
            DeleteLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_NAME_" + sResRef);
            DeleteLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_"  + IntToString(x));
            sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + IntToString(++x));
        }

        SQLExecStatement("DELETE FROM md_cr_input WHERE Recipe_ID=?", stRecipe.sID);
        object oInput = GetObjectByTag("GS_CR_INPUT");
        _gsCRAddRecipe(oInput);

        string sx;
        int nQty;
        string sName;
        for(x = 1; x<= GetLocalInt(oInput, "MD_CR_COUNT"); x++)
        {
            sx = IntToString(x);
            sName = GetLocalString(oInput, "GS_CR_NAME_" + sx);
            nQty  = GetLocalInt(oInput, "GS_CR_COUNT_" + sx);
            sResRef = GetLocalString(oInput, "GS_CR_RESREF_" + sx);
            SQLExecStatement("INSERT INTO md_cr_input (Name, Qty, Resref, Recipe_ID) VALUES(?,?,?,?)",
            sName, IntToString(nQty), sResRef, stRecipe.sID);

            SetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" +  sResRef, nQty);
            SetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + sx, sResRef);
            SetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_NAME_" + sResRef, sName);
        }
    }
    else if(sResponse == "[Replace Output with Output Barrel]")
    {
        struct gsCRRecipe stRecipe;
        int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
        int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
        stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
        string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_1");
        int x = 1;
        while(sResRef != "")
        {
            DeleteLocalInt(oSkillCache, stRecipe.sSlot + "_OUTPUT_COUNT_"+sResRef);
            DeleteLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_NAME_" + sResRef);
            DeleteLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_"  + IntToString(x));
            sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_" + IntToString(++x));
        }

        SQLExecStatement("DELETE FROM md_cr_output WHERE Recipe_ID=?", stRecipe.sID);
        object oOutput = GetObjectByTag("GS_CR_OUTPUT");
        _gsCRAddRecipe(oOutput);

        string sx;
        int nQty;
        string sName;

        for(x = 1; x<= GetLocalInt(oOutput, "MD_CR_COUNT"); x++)
        {
            sx = IntToString(x);
            sName = GetLocalString(oOutput, "GS_CR_NAME_" + sx);
            nQty  = GetLocalInt(oOutput, "GS_CR_COUNT_" + sx);
            sResRef = GetLocalString(oOutput, "GS_CR_RESREF_" + sx);
            SQLExecStatement("INSERT INTO md_cr_output (Name, Qty, Resref, Recipe_ID) VALUES(?,?,?,?)",
                sName, IntToString(nQty), sResRef, stRecipe.sID);

            SetLocalInt(oSkillCache, stRecipe.sSlot + "_OUTPUT_COUNT_" + sResRef, nQty);
            SetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_" + sx, sResRef);
            SetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_NAME_" + sResRef, sName);
        }
    }
    else if (sResponse == "[Back]")
    {
        // Go back one page
        string sAltPage = dlgGetPlayerDataString("MD_CR_ALT_PAGE");
        if(sAltPage == "")
            sAltPage = "3";
        dlgChangePage(sAltPage);
        dlgClearPlayerDataString("MD_CR_ALT_PAGE");
        dlgClearPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    }
    else fbOpenAction();
}
void Sel5()
{
    // The only thing that could have been selected is OK, so we remove it.
    int nSkill  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    gsCRRemoveRecipeInSlot(nSkill, nRecipe);
    dlgClearPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    dlgChangePage("3");
}
void Sel6()
{
    // The only thing that could have been selected is OK, so we add skill points.
    int nSkill = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    gsCRIncreaseSkillRank(nSkill, dlgGetSpeakingPC());
    dlgChangePage("2");
}
void Sel7()
{
    object oSpeaker = dlgGetSpeakingPC();
    if (!dlgGetPlayerDataInt(FB_VAR_WORK_PROGRESS))
    {
        string sName = dlgGetSelectionName();
        if (sName == "[Create new production]") dlgChangePage("2");
        else if (sName == "[Improve Item]")
        {
            Cleanup();
            object oSelf = OBJECT_SELF;
            AssignCommand(oSpeaker, ActionStartConversation(oSelf,"gs_ip_add", TRUE, FALSE));
        }
        else if (sName == "[Open inventory]") fbOpenAction();
        else if (sName == "[Create new production by ID. Enter ID before selecting]")
        {
            struct gsCRRecipe stRecipe;
            int nSkill = dlgGetSpeakeeDataInt(FB_VAR_SKILL);

            string sID = chatGetLastMessage(oSpeaker);
            stRecipe = gsCRGetRecipeByID(nSkill, sID);
            //check if recipe exists
            if(stRecipe.sName == "" || !mdCRShowRecipe(stRecipe, oSpeaker))
                SendMessageToPC(oSpeaker, "That recipe does not exist.");
            else
            {
                dlgSetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT, StringToInt(stRecipe.sSlot));
                dlgSetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY, stRecipe.nCategory);
                dlgSetPlayerDataString("MD_CR_ALT_PAGE", "7");
                dlgChangePage("4");
            }

        }
        else if (sName == "[Repair this fixture]")
        {
            // jump to the creation page for this fixture immediately
            struct gsCRRecipe stRecipe = gsCRGetRecipeByID(GetLocalInt(OBJECT_SELF, "GS_SKILL"), gvd_CRGetRecipeForResRef(GetLocalString(OBJECT_SELF, "GVD_REMAINS_RESREF_ITEM")));
            dlgSetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT, StringToInt(stRecipe.sSlot));
            dlgSetPlayerDataInt(FB_VAR_CHOSEN_CATEGORY, stRecipe.nCategory);
            dlgChangePage("4");
        }
        else if (sName == "[Handle fixture object]")
        {
            Cleanup();
            dlgChangeDlgScript(dlgGetSpeakingPC(), "zz_co_fixture");
        }
        else dlgSetPlayerDataInt(FB_VAR_WORK_PROGRESS, TRUE);
    }
    else
    {
        // Decide how much to repair or produce by
        int nValue = 0;
        switch (dlgGetSelectionIndex())
        {
            case 0: nValue = 1;     break;
            case 1: nValue = 5;     break;
            case 2: nValue = 10;    break;
            case 3: nValue = 25;    break;
            case 4: nValue = FALSE; break;
        }
        object oSelf = OBJECT_SELF;
        int nSkill   = dlgGetSpeakeeDataInt(FB_VAR_SKILL);

        // dunshine: check if this is the repairing of a fixture first
        if (GetLocalString(OBJECT_SELF, "GVD_REMAINS_STATUS") != "") {
          int iRepair = gvd_CRRepairFixture(oSelf, oSpeaker, nValue);
          if (iRepair == 2) {
            // fixture is fully repaired, do the animations but quit the convo as well
            gsCRPlaySound(nSkill);
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.5));
            Cleanup();
            dlgEndDialog();
            return;
          }

        } else {
          object oItem = dlgGetSpeakeeDataObject(FB_VAR_ITEM);
          string sString    = "GS_CR_" + IntToString(nSkill) + "_";
          int nCount        = GetStringLength(sString);

          // Decide whether to repair or produce
          if (GetStringLeft(ConvertedStackTag(oItem), nCount) == sString)
              gsCRProduce(oItem, oSpeaker, nValue);
          else
              gsISRepairItem(oItem, oSpeaker, nValue);
        }

        // Play an appropriate sound and animation
        gsCRPlaySound(nSkill);
        AssignCommand(oSpeaker, _Sel(oSelf));

        // End the dialog - it'll come straight back up afterwards.
        dlgEndDialog();
    }
}
void Sel8()
{
    // The only thing that could have been selected is OK, so we remove skill points.
    int nSkill = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    gsCRDecreaseSkillRank(nSkill, dlgGetSpeakingPC());
    Log("LOSECRAFT", "PC " + GetName(dlgGetSpeakingPC()) + "has decreased their " + IntToString(nSkill) + " skill by 1 point.");
    dlgChangePage("2");
}
// Cleanup
void Cleanup()
{
    dlgClearResponseList(FB_RESPONSES);
    dlgClearPlayerDataInt(FB_VAR_CHOSEN_CATEGORY);
    dlgClearPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    dlgClearPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    dlgClearPlayerDataInt(FB_VAR_OFFSET_PRODUCT);
    dlgClearPlayerDataInt(FB_VAR_WORK_PROGRESS);
    dlgClearSpeakeeDataObject(FB_VAR_ITEM);
}
//Race Init
void Race()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    md_SetUpRaceList(FB_RESPONSES, stRecipe.nRace, _dlgGetPcSpeaker());
    dlgSetPrompt("Race select: ");
    //dlgSetActiveResponseList("Race");
    dlgActivatePreservePageNumberOnSelection();
    md_dlgRecoverPageNumber();
}
void Class()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    md_SetUpClassList(FB_RESPONSES, stRecipe.nClass, _dlgGetPcSpeaker(), FALSE);
    dlgSetPrompt("Class select: ");
    dlgActivatePreservePageNumberOnSelection();
    md_dlgRecoverPageNumber();
}
void Placeable()
{
    dlgSetPrompt("Warning! Only change the tag if you know what you're doing. Most often you'll need the aid of a dev to support it.");
    dlgAddResponseAction(FB_RESPONSES, "[Speak new placeable tag]");
}
void Category()
{
    dlgSetPrompt("Select Category.");
    dlgClearResponseList(LIST_IDS);
    SQLExecStatement("SELECT id,name FROM md_cr_category WHERE lower(name) LIKE ?", "%"+GetStringLowerCase(chatGetLastMessage(dlgGetSpeakingPC()))+"%");
    while(SQLFetch())
    {
         dlgAddResponse(LIST_IDS, SQLGetData(1));
         fbResponse(SQLGetData(2));
    }
}
void RaceS()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    int nBit = md_GetRaceSelection(dlgGetSelectionIndex());
    int nNewBit = stRecipe.nRace;
    if((nNewBit & nBit) == nBit)
        nNewBit &= ~nBit;
    else
        nNewBit |= nBit;

    SetLocalInt(oSkillCache, IntToString(nRecipe) + "_RACE", nNewBit);
    miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "SubRace", IntToString(nNewBit));

    md_dlgSavePageNumber();

}
void ClassS()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    int nBit = md_GetClassSelection(dlgGetSelectionIndex(), FALSE);
    int nNewBit = stRecipe.nClass;
    if((nNewBit & nBit) == nBit)
        nNewBit &= ~nBit;
    else
        nNewBit |= nBit;

    SetLocalInt(oSkillCache, IntToString(nRecipe) + "_CLASS", nNewBit);
    miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Class", IntToString(nNewBit));

    md_dlgSavePageNumber();
}
void PlaceableS()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    object oSpeaker = dlgGetSpeakingPC();
    string sSpeak = chatGetLastMessage(oSpeaker);
    miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Placeable_Tag", sSpeak);
    SetLocalString(oSkillCache, IntToString(nRecipe) + "_TAG", sSpeak);
    SendMessageToPC(oSpeaker, "Tag set to: " + sSpeak);

}
void CategoryS()
{
    struct gsCRRecipe stRecipe;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    object oSpeaker = dlgGetSpeakingPC();
    SendMessageToPC(oSpeaker, "Category Changed to: " + dlgGetSelectionName());
    miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "category", GetStringElement(dlgGetSelectionIndex(), LIST_IDS, oSpeaker));
}
void Skill()
{
    int x;
    string sRank;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    string sText;
    dlgSetPrompt("Skill select, type number of rank before selecting skill 0 or less will remove skill: ");
    for(x = 0; x<= 27; x++)
    {
        SQLExecStatement("SELECT Rank FROM md_cr_skills WHERE Skill=? AND Recipe_ID=?", IntToString(x), stRecipe.sID);
        SQLFetch();
        sRank = SQLGetData(1);
        if(sRank != "")
            sText = txtGreen;
        else
            sText = txtRed;

        fbResponse(sText + GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", x))) + " " + sRank + "</c>");
    }
}

void Feat()
{
    int x;
    string sFeat;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    string sText;
    dlgSetPrompt("Feat select, type number of feat before selecting Add Feat. Selecting a feat will remove it. ");
    fbResponse("[Add Feat]", TRUE);
    SQLExecStatement("SELECT Feat FROM md_cr_feats WHERE Recipe_ID=?", stRecipe.sID);
    DeleteList(MD_LIST_FEAT_ID);
    while(SQLFetch())
    {
       sFeat = SQLGetData(1);
       fbResponse(sText + GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", StringToInt(sFeat)))));
       AddStringElement(sFeat, MD_LIST_FEAT_ID);
    }

}

void SkillS()
{
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    string sSkill = IntToString(dlgGetSelectionIndex());
    SQLExecStatement("SELECT Rank FROM md_cr_skills WHERE Skill=? AND Recipe_ID=?", sSkill, stRecipe.sID);
    string sMsg = chatGetLastMessage(dlgGetSpeakingPC());
    if(SQLFetch())
    {
        if(StringToInt(sMsg) > 0)
            SQLExecStatement("UPDATE md_cr_skills SET Rank=? WHERE Skill=? AND Recipe_ID=?", sMsg, sSkill, stRecipe.sID);
        else
            SQLExecStatement("DELETE FROM md_cr_skills WHERE Skill=? AND Recipe_ID=?", sSkill, stRecipe.sID);


    }
    else if(StringToInt(sMsg) > 0)
        SQLExecStatement("INSERT INTO md_cr_skills (Rank, Skill, Recipe_ID) VALUES (?,?,?)", sMsg, sSkill, stRecipe.sID);


}

void FeatS()
{
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    int nIndex = dlgGetSelectionIndex();

    if(nIndex == 0)
    {
        string sMsg = chatGetLastMessage(dlgGetSpeakingPC());
        if(StringToInt(sMsg) > 0)
            SQLExecStatement("INSERT INTO md_cr_feats (Feat, Recipe_ID) VALUES (?,?)", sMsg, stRecipe.sID);
    }
    else
        SQLExecStatement("DELETE FROM md_cr_feats WHERE Feat=? AND Recipe_ID=?", GetStringElement(nIndex-1, MD_LIST_FEAT_ID), stRecipe.sID);

}
string _ColorText(string sText, int nSetting, int nAllSetting)
{
    if(nSetting & nAllSetting)
        sText = txtGreen + sText;
    else
        sText = txtRed + sText;

    return sText + "</c>";
}
void Setting()
{
    dlgSetPrompt("Turn on/off settings");
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);
    fbResponse(_ColorText("Hidden", SETTING_HIDDEN, stRecipe.nSettings));
    fbResponse(_ColorText("Class Levels Additive", SETTING_LVLADDITIVE, stRecipe.nSettings));
    fbResponse(_ColorText("Match One Feat", SETTING_ONEFEAT, stRecipe.nSettings));
    fbResponse(_ColorText("Match One Skill", SETTING_ONESKILL, stRecipe.nSettings));
    fbResponse(_ColorText("Skills add in ability modifier", SETTING_ABILITY, stRecipe.nSettings));
    fbResponse(_ColorText("Skills add in feats/spells/other effects", SETTING_SKILLFEAT, stRecipe.nSettings));
}
void SettingS()
{
    int nSetting;
    int nSkill   = dlgGetPlayerDataInt(FB_VAR_CHOSEN_TRADE);
    int nRecipe  = dlgGetPlayerDataInt(FB_VAR_CHOSEN_PRODUCT);
    struct gsCRRecipe stRecipe     = gsCRGetRecipeInSlot(nSkill, nRecipe);

    switch(dlgGetSelectionIndex())
    {
    case 0: nSetting = SETTING_HIDDEN; break;
    case 1: nSetting = SETTING_LVLADDITIVE; break;
    case 2: nSetting = SETTING_ONEFEAT; break;
    case 3: nSetting = SETTING_ONESKILL; break;
    case 4: nSetting = SETTING_ABILITY; break;
    case 5: nSetting = SETTING_SKILLFEAT; break;
    }

    if(nSetting & stRecipe.nSettings)
      stRecipe.nSettings = stRecipe.nSettings & ~nSetting;
    else
      stRecipe.nSettings = stRecipe.nSettings | nSetting;



    SetLocalInt(oSkillCache, IntToString(nRecipe) + "_SETTINGS", stRecipe.nSettings);
    miDASetKeyedValue("md_cr_recipes", stRecipe.sID, "Settings", IntToString(stRecipe.nSettings));
}
