/* CRAFT library by Gigaschatten */

#include "cnr_recipe_utils"
#include "inc_time"
#include "inc_worship"
#include "inc_backgrounds"
#include "inc_database"
#include "inc_divination"
#include "inc_class"
#include "inc_stacking"

//void main() {}

const string GS_CR_TEMPLATE_CARPENTER = "gs_item049";
const string GS_CR_TEMPLATE_COOK      = "gs_item052";
const string GS_CR_TEMPLATE_CRAFT_ART = "gs_item431";
const string GS_CR_TEMPLATE_FORGE     = "gs_item432";
const string GS_CR_TEMPLATE_MELD      = "gs_item433";
const string GS_CR_TEMPLATE_SEW       = "gs_item434";

const int GS_CR_LIMIT_RECIPE          = 500;
const int GS_CR_LIMIT_CATEGORY        = 200;
const int GS_CR_OFFSET_DC             =   0;
const int GS_CR_MODIFIER_DC           = 100;
const int GS_CR_MODIFIER_CRAFT_POINTS = 125;

const int GS_CR_SKILL_CARPENTER       =   1;
const int GS_CR_SKILL_COOK            =   2;
const int GS_CR_SKILL_CRAFT_ART       =   3;
const int GS_CR_SKILL_FORGE           =   4;
const int GS_CR_SKILL_MELD            =   5;
const int GS_CR_SKILL_SEW             =   6;

const int GS_CR_FL_MAX_ITEM_VALUE     = 100000;

const int SETTING_HIDDEN              = 0x01;
const int SETTING_NOSUR               = 0x02;
const int SETTING_NOUND               = 0x04;
const int SETTING_LVLADDITIVE         = 0x08;
const int SETTING_ONESKILL            = 0x10;
const int SETTING_ONEFEAT             = 0x20;
const int SETTING_ABILITY             = 0x40;
const int SETTING_SKILLFEAT           = 0x80;

struct gsCRRecipe
{
    string sID;
    string sName;
    string sSlot;
    int nSkill;
    int nCategory;
    int nValue;
    int nDC;
    int nPoints;

    //Race & Subrace
    int nRace;
    int nSettings;

    //Placeable
    string sTag;

    //Classes
    int nClass;
    int nLevel;
};


struct gsCRProduction
{
    int nSkill;
    string sRecipe;
    int nCraftPoints;
};

//return rank of oPC at nSkill, including racial and background bonuses or not.
int gsCRGetSkillRank(int nSkill, object oPC = OBJECT_SELF, int nBonuses = TRUE);
//return TRUE if oPC is successfull at nSkill against nDC
int gsCRGetIsSkillSuccessful(int nSkill, int nDC, object oPC = OBJECT_SELF);
//return crafting skill points of oPC available for distribution
int gsCRGetSkillPoints(object oPC = OBJECT_SELF);
//internally used
int _gsCRGetSkillPoints(object oPC);
//increase rank of oPC at nSkill by 1
void gsCRIncreaseSkillRank(int nSkill, object oPC = OBJECT_SELF);
//decrease rank of oPC at nSkill by 1
void gsCRDecreaseSkillRank(int nSkill, object oPC = OBJECT_SELF);
//reset skill rank of oPC
void gsCRResetSkillRank(object oPC = OBJECT_SELF);
//return name of nSkill
string gsCRGetSkillName(int nSkill);

//increase craft points of oPC by nValue
void gsCRIncreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF);
//decrease craft points of oPC by nValue
void gsCRDecreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF);
//set craft points of oPC to nValue
void gsCRSetCraftPoints(object oPC, int nValue);
//return craft points of oPC
int gsCRGetCraftPoints(object oPC);
//set craft timeout of oPC to nValue
void gsCRSetCraftTimeout(object oPC, int nValue);
//return craft timeout of oPC
int gsCRGetCraftTimeout(object oPC);

//add recipe for nSkill using contents of oInputContainer and oOutputContainer, if sID is not given, a random id is created
struct gsCRRecipe gsCRAddRecipe(object oInputContainer, object oOutputContainer, int nSkill, string sID = "");
//internally used
void _gsCRAddRecipe(object oContainer);
//internally used, only used to add recipe to md_cr_recipe SQL TABLE
int __gsCRAddRecipe(struct gsCRRecipe stRecipe);
//internally used, used to for output and input tables
void __mdCRaddRecipe(string sID, object oInput, object oOutput, int nSlot);
//return recipe in nSlot of nSkill
struct gsCRRecipe gsCRGetRecipeInSlot(int nSkill, int nSlot);
//return recipe sID of nSkill
struct gsCRRecipe gsCRGetRecipeByID(int nSkill, string sID);
//return slot of first recipe in nCategory of nSkill at or after nSlot, return -1 if at end
int gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot = 0);
//internally used
int _gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot, int nStep = 1);
//return slot of recipe in nCategory of nSkill following nSlot, return -1 if at end
int gsCRGetNextRecipe(int nSkill, int nCategory, int nSlot = 0);
//return slot of recipe in nCategory of nSkill preceding nSlot, return -1 if at start
int gsCRGetPreviousRecipe(int nSkill, int nCategory, int nSlot = 0);
//remove recipe in nSlot from nSkill
void gsCRRemoveRecipeInSlot(int nSkill, int nSlot);
//remove recipe sID from nSkill
void gsCRRemoveRecipeByID(int nSkill, string sID);
//return dc of stRecipe
int gsCRGetRecipeDC(struct gsCRRecipe stRecipe);
//return number of craft points needed to finish stRecipe
int gsCRGetRecipeCraftPoints(struct gsCRRecipe stRecipe);
//return list of input material for stRecipe
string gsCRGetRecipeInputList(struct gsCRRecipe stRecipe);
//return list of output products of stRecipe
string gsCRGetRecipeOutputList(struct gsCRRecipe stRecipe);
//load recipe list of nSkill
void gsCRLoadRecipeList(int nSkill);
//internally used
void _gsCRLoadRecipeList(int nSkill, int nStart);
//internally used
int __gsCRLoadRecipeList(int nSkill, int nSlot);
//internally used
string __gsGetResRef(object oObject);
//return total number of recipes
int gsCRGetRecipeCount();
//List races & Subraces
string mdCRGetRecipeRaceList(struct gsCRRecipe stRecipe);
//List Classes & Paths
string mdCRGetRecipeClassList(struct gsCRRecipe stRecipe);
//List Skills
string mdCRGetRecipeSkillList(struct gsCRRecipe stRecipe);
//List Feats
string mdCRGetRecipeFeatList(struct gsCRRecipe stRecipe);
//Checks if recipe is hidden or can be shown for this placeable
int mdCRShowRecipe(struct gsCRRecipe stRecipe, object oPC, object oPlaceable=OBJECT_SELF);
// Item cache for skill-specific crafting local variables
object oSkillCache = OBJECT_INVALID;
// Item cache for skill-independent crafting local variables
object oCraftCache = OBJECT_INVALID;
//Select the cache item for a crafting skill's recipes
void _gsCRGetSkillCache(int nSkill=-1);

//return first category containing recipes of nSkill at or after nCategory, return -1 if at end
int gsCRGetFirstCategory(int nSkill, int nCategory = 0);
//internally used
int _gsCRGetFirstCategory(int nSkill, int nCategory, int nStep = 1);
//return category containing recipes of nSkill following nCategory, return -1 if at end
int gsCRGetNextCategory(int nSkill, int nCategory = 0);
//return category containing recipes of nSkill preceding nCategory, return -1 if at start
int gsCRGetPreviousCategory(int nSkill, int nCategory = 0);
//increase number of recipes in nCategory of nSkill by 1
void gsCRIncreaseCategoryCount(int nSkill, int nCategory);
//internally used
void _gsCRIncreaseCategoryCount(int nSkill, int nCategory, int nValue = 1);
//decrease number of recipes in nCategory of nSkill by 1
void gsCRDecreaseCategoryCount(int nSkill, int nCategory);
//return number of recipes in nCategory of nSkill
int gsCRGetCategoryCount(int nSkill, int nCategory);
//return name of nCategory
string gsCRGetCategoryName(int nCategory);
//load category list
void gsCRLoadCategoryList();

//return quantity of material in oContainer required for stRecipe
void gsCRGetQuantity(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF);
//return TRUE if stQuantity is sufficient for stRecipe
int gsCRGetIsQuantitySufficient(struct gsCRRecipe stRecipe, object oContainer=OBJECT_SELF);
//return list of input material and stQuantity for stRecipe
string gsCRGetQuantityList(struct gsCRRecipe stRecipe, object oContainer=OBJECT_SELF);
//consume material in oContainer required for stRecipe
void gsCRConsumeMaterial(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF);
//internally used
int _gsCRConsumeMaterial(object oItem, int nCount);
//Returns True if character meets racial requirements
int mdCRMeetsRaceRequirements(struct gsCRRecipe stRecipe, object oSpeaker);
//Returns True if character meets class requirements
int mdCRMeetsClassRequirements(struct gsCRRecipe stRecipe, object oPC);
//Returns True if character meets skill requirements
int mdCRMeetsSkillRequirements(struct gsCRRecipe stRecipe, object oPC);
//Returns True if character meets feat requirements
int mdCRMeetsFeatRequirements(struct gsCRRecipe stRecipe, object oPC);
//Returns True if character meets race, class, and custom requirements
int mdCRMeetsRequirements(struct gsCRRecipe stRecipe, object oPC, object oPlaceable = OBJECT_SELF);
//Returns True if character meets custom requirements
int mdCRMeetsCustomRequirements(struct gsCRRecipe stRecipe, object oPC, object oPlaceable = OBJECT_SELF);

//return production of stRecipe using material in oContainer
void gsCRCreateProduction(struct gsCRRecipe stRecipe, object oPC, object oContainer = OBJECT_SELF);
//return production data of oItem
struct gsCRProduction gsCRGetProductionData(object oItem);
//return template of production item for nSkill
string gsCRGetProductionTemplate(int nSkill);
//produce oItem in oContainer by oPC using nValue craft points
void gsCRProduce(object oItem, object oPC, int nValue = 1, object oContainer = OBJECT_SELF);
//internally used
void _gsCRProduce(int nCount, string sResRef, object oContainer, struct gsCRRecipe stRecipe, object oPC = OBJECT_INVALID);
//play sound for nSkill
void gsCRPlaySound(int nSkill);
// returns the racial crafting bonus for this character's race.
int gsCRGetRacialCraftingBonus(object oPC, int nSkill);
// Uses item base type, material and property type to return the appropriate craft skill
// NB: currently set up for FL only.
int gsCRGetCraftSkillByItemType(object oItem, int bMundaneProperty);
// Get the multiplier for nMaterial.  Materials have a mundane and a magical
// multiplier that determine how easy they are to improve by mundane or magical
// means.
int gsCRGetMaterialMultiplier(int nMaterial, int bMundaneProperty = TRUE);
// Return the skill bonus for any bonus (gem) properties on the item.  e.g.
// an amethyst ring gives you +3 to your effective skill while adding properties
// to the ring. 
int gsCRGetMaterialSkillBonus(object oItem);
// Used to adjust the actual value of an item based on the PC's craft skill,
// and the item's material.
float gsCRGetCraftingCostMultiplier(object oPC, object oItem, itemproperty ip);
// Returns TRUE if nIP is permitted on oItem.  On FL, adds restrictions based
// on material.
int gsCRGetIsValid(object oItem, int nProperty);
// Returns TRUE if an essence application attempt was successful.  On FL, this
// can fail if the material isn't magically attuned enough.
int gsCRGetEssenceApplySuccess(object oItem);
// Returns the base gold cost of an item based on its material property.
// Used for the FL crafting system to disregard base cost when assessing the
// item value cap.
int gsCRGetMaterialBaseValue(object oItem);
//Fires after each time an item is created, can be used to add item properties.
void _mdAddItemProperties(struct gsCRRecipe stRecipe, object oItem);

// function that handles repairing of oFixture by oPC for nValue craftpoints, returns 2 when completed, 1 on progress, 0 on failure
int gvd_CRRepairFixture(object oFixture, object oPC, int nValue = 1);

// restores the original fixture at the location of oRemains, owner becomes oPC
void gvd_CRRestoreFixture(object oRemains, object oPC);

// gets the first recipe in the db for output item with sResRef (this will be used to get the recipe from fixtures that can be repaired)
string gvd_CRGetRecipeForResRef(string sResRef);

//Convert nNth to the proper category
int md_ConvertToCategory(int nNth);

//Obtain the crafting ResRef of an object.  Honours any crafting resref
//aliases set on the object.
string __gsGetResRef(object oObject)
{
    string sResRef = GetResRef(oObject);

    // Try resref-based aliasing: strip off any trailing "__NN" suffix.
    string sSuffix = GetStringRight(sResRef, 4);
    if (TestStringAgainstPattern("__*n", sSuffix))
    {
        sResRef = GetStringLeft(sResRef, GetStringLength(sResRef) - 4);
    }
    return sResRef;
}

int gsCRGetRecipeCount()
{
    _gsCRGetSkillCache();
    return GetLocalInt(oCraftCache, "GS_CR_RECIPE_COUNT");
}

int gsCRGetSkillRank(int nSkill, object oPC = OBJECT_SELF, int nBonuses = TRUE)
{
    if (GetIsDM(oPC)) return 60;

    string sString = "GS_CR_SKILL_" + IntToString(nSkill);
    int nRank      = GetLocalInt(oPC, sString);

    if (! nRank)
    {
        nRank = StringToInt(miDAGetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c" + IntToString(nSkill)));
        SetLocalInt(oPC, sString, nRank == 0 ? -1 : nRank);
        return nRank;
    }

    if (nRank < 0) nRank = 0;
    if (nBonuses)
    {
      nRank += gsCRGetRacialCraftingBonus(oPC, nSkill);
      nRank += miBAGetCraftSkillBonus(oPC, nSkill);
    }

    return nRank;
}
//----------------------------------------------------------------
int gsCRGetIsSkillSuccessful(int nSkill, int nDC, object oPC = OBJECT_SELF)
{
    int nRank   = gsCRGetSkillRank(nSkill, oPC);
    // Edit by Fireboar: Roll a dice for players, take 20 for DMs.
    int nDice   = (GetIsDM(oPC)) ? 20 : d20();
    int nResult = nRank + nDice;
    int nFlag   = FALSE;

    while (nDice   !=  1 &&
           nDice   != 20 &&
           nResult == nDC)
    {
        nDice   = d20();
        nResult = nRank + nDice;
    }

    nFlag       = nDice == 20 || (nDice != 1 && nResult > nDC);

    // Edit by Fireboar: I've switched round nDice and nRank to conform to the
    // format of everything else in NWN.
    SendMessageToPC(oPC,
                    "<c™þþ>" + GetName(oPC) + " <c fþ>: " +
                    GS_T_16777219 + " (" + gsCRGetSkillName(nSkill) + "<c fþ>) : " +
                    (nFlag ? GS_T_16777217 : GS_T_16777218) + " : " +
                    "(" + IntToString(nDice) + " " +
                    "+ " + IntToString(nRank) + " " +
                    "= " + IntToString(nResult) + " " +
                    GS_T_16777220 + ": " + IntToString(nDC) + ")");

    return nFlag;
}
//----------------------------------------------------------------
int gsCRGetSkillPoints(object oPC = OBJECT_SELF)
{
    int nRetVal;
    int nCraftPoints = GetHitDice(oPC);

    // On the FL server, use effective level for craft points.  Each feat gives
    // +1 craft point. Total CP = 9*2 + bonus feats.
    if (GetLocalInt(GetModule(), "STATIC_LEVEL")  &&
        GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") > 0)
    {

      nRetVal = GetLocalInt(gsPCGetCreatureHide(oPC), "FL_LEVEL") + nCraftPoints
                  - _gsCRGetSkillPoints(oPC);;
    }
    else
    {
       nRetVal = GetHitDice(oPC) * 2 - _gsCRGetSkillPoints(oPC);
    }

    if (GetLocalInt(gsPCGetCreatureHide(oPC), "GIFT_CRAFTSMANSHIP"))
    {
      nRetVal += 10;
    }

    return nRetVal;
}
//----------------------------------------------------------------
int _gsCRGetSkillPoints(object oPC)
{
    return gsCRGetSkillRank(GS_CR_SKILL_CARPENTER, oPC, FALSE) +
           gsCRGetSkillRank(GS_CR_SKILL_COOK,      oPC, FALSE) +
           gsCRGetSkillRank(GS_CR_SKILL_CRAFT_ART, oPC, FALSE) +
           gsCRGetSkillRank(GS_CR_SKILL_FORGE,     oPC, FALSE) +
           gsCRGetSkillRank(GS_CR_SKILL_MELD,      oPC, FALSE) +
           gsCRGetSkillRank(GS_CR_SKILL_SEW,       oPC, FALSE);
}
//----------------------------------------------------------------
void gsCRIncreaseSkillRank(int nSkill, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return;

    if (gsCRGetSkillPoints(oPC))
    {
        string sString = "GS_CR_SKILL_" + IntToString(nSkill);
        int nRank      = gsCRGetSkillRank(nSkill, oPC, FALSE) + 1;

        SetLocalInt(oPC, sString, nRank == 0 ? -1 : nRank);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c"+IntToString(nSkill), IntToString(nRank));
        gsCRIncreaseCraftPoints(1, oPC);
    }
}
//----------------------------------------------------------------
void gsCRDecreaseSkillRank(int nSkill, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return;
	
	object oHide = gsPCGetCreatureHide(oPC);
	
    if (GetLocalInt(oHide,"SkillPointPool"))
    {
        string sString = "GS_CR_SKILL_" + IntToString(nSkill);
        int nRank      = gsCRGetSkillRank(nSkill, oPC, FALSE) - 1;

        SetLocalInt(oPC, sString, nRank == 0 ? -1 : nRank);
		SetLocalInt(oHide, "SkillPointPool", GetLocalInt(oHide, "SkillPointPool") - 1);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c"+IntToString(nSkill), IntToString(nRank));
        gsCRIncreaseCraftPoints(1, oPC);
    }
}
//----------------------------------------------------------------
void gsCRResetSkillRank(object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return;

    string sPlayerID = gsPCGetPlayerID(oPC);
    string sString   = "";

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_CARPENTER);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c1", "0");

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_COOK);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c2", "0");

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_CRAFT_ART);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c3", "0");

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_FORGE);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c4", "0");

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_MELD);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c5", "0");

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_SEW);
    SetLocalInt(oPC, sString, -1);
    miDASetKeyedValue("gs_pc_data", sPlayerID, "c6", "0");
}
//----------------------------------------------------------------
string gsCRGetSkillName(int nSkill)
{
  if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
  {
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER: return "<cz  >REMOVED</c>"; // Removed for FL
    case GS_CR_SKILL_COOK:      return "<cýÄˆ>" + GS_T_16777222 + "<cþþþ>";
    case GS_CR_SKILL_CRAFT_ART: return "<c¡Òš>Handicrafting<cþþþ>";
    case GS_CR_SKILL_FORGE:     return "<cmÎö>" + GS_T_16777224 + "<cþþþ>";
    case GS_CR_SKILL_MELD:      return "<c»‹¾>" + GS_T_16777225 + "<cþþþ>";
    case GS_CR_SKILL_SEW:       return "<cÄ›m>" + GS_T_16777226 + "<cþþþ>";
    }
  }
  else
  {
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER: return "<c¡Òš>" + GS_T_16777221 + "<cþþþ>";
    case GS_CR_SKILL_COOK:      return "<cýÄˆ>" + GS_T_16777222 + "<cþþþ>";
    case GS_CR_SKILL_CRAFT_ART: return "<cþ÷˜>" + GS_T_16777223 + "<cþþþ>";
    case GS_CR_SKILL_FORGE:     return "<cmÎö>" + GS_T_16777224 + "<cþþþ>";
    case GS_CR_SKILL_MELD:      return "<c»‹¾>" + GS_T_16777225 + "<cþþþ>";
    case GS_CR_SKILL_SEW:       return "<cÄ›m>" + GS_T_16777226 + "<cþþþ>";
    }
  }

  return "";
}
//----------------------------------------------------------------
void gsCRIncreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF)
{
    gsCRSetCraftPoints(oPC, gsCRGetCraftPoints(oPC) + nValue);
}
//----------------------------------------------------------------
void gsCRDecreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF)
{
    // Divination hook - increment Earth count by number of points spent.
    miDVGivePoints(oPC, ELEMENT_EARTH, IntToFloat(nValue));

    // Worship hook - increase Piety by number of points spent / 10.
    int nAspect = gsWOGetDeityAspect(oPC);
    if (nAspect & ASPECT_KNOWLEDGE_INVENTION)
    {
      gsWOAdjustPiety(oPC, IntToFloat(nValue) / 10.0);
    }

    gsCRIncreaseCraftPoints(-nValue, oPC);
}
//----------------------------------------------------------------
void gsCRSetCraftPoints(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_CR_CRAFT_POINTS", nValue <= 0 ? -1 : nValue);
    miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c_points", IntToString(nValue));
}
//----------------------------------------------------------------
int gsCRGetCraftPoints(object oPC)
{
    if (GetIsDM(oPC)) return 120;

    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = gsCRGetCraftTimeout(oPC);
    int nValue     = 0;

    if (nTimeout < nTimestamp)
    {
        // Time to reset crafting points available to oPC.

        nTimeout = nTimestamp + 86400; //24 hours

        // Septire - Changed this 21/05/2016. The daily remaining crafting points is 50. If they have gift of Craftsmanship, it's 60.
        // nValue   = _gsCRGetSkillPoints(oPC);
        // Septire - Changed this 06/09/2016. Daily crafting points are modified by (Craft Weapon + Craft Armor) /2
        //         - Changed again 09/09/2016. Now calculates base ranks + feats.
        nValue = 50;
        int nArmor = GetSkillRank(SKILL_CRAFT_ARMOR, oPC, TRUE);
        int nWeapon = GetSkillRank(SKILL_CRAFT_WEAPON, oPC, TRUE);

        if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR, oPC))
        {
            nArmor += 10;
        }
        if (GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_ARMOR, oPC))
        {
            nArmor += 3;
        }
        if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON, oPC))
        {
            nWeapon += 10;
        }
        if (GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_WEAPON, oPC))
        {
            nWeapon += 3;
        }
        if (nArmor + nWeapon > 0)
        {
            nValue += FloatToInt((nArmor + nWeapon) / 2.0f);
        }
        if (GetLocalInt(gsPCGetCreatureHide(oPC), "GIFT_CRAFTSMANSHIP"))
        {
            nValue += 10;
        }
        gsCRSetCraftTimeout(oPC, nTimeout);
        gsCRSetCraftPoints(oPC, nValue);
    }
    else
    {
        // Not yet time to reset crafting points for oPC.
        nValue   = GetLocalInt(oPC, "GS_CR_CRAFT_POINTS");
        if (! nValue)
        {
            nValue = StringToInt(miDAGetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c_points"));
            SetLocalInt(oPC, "GS_CR_CRAFT_POINTS", nValue <= 0 ? -1 : nValue);
            return nValue;
        }
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
void gsCRSetCraftTimeout(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT", nValue <= 0 ? -1 : nValue);
    miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c_timeout", IntToString(nValue));
}
//----------------------------------------------------------------
int gsCRGetCraftTimeout(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT");

    if (! nValue)
    {
        nValue = StringToInt(miDAGetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "c_timeout"));
        SetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
string _LoadRecipe(int nSlot, struct gsCRRecipe stRecipe)
{
    string sID = "";
    SQLExecStatement("SELECT ID FROM md_cr_recipes ORDER BY ID DESC LIMIT 1");
    if(SQLFetch())
    {
        sID = SQLGetData(1);
        string sSlot = IntToString(nSlot);
        SetLocalInt(oSkillCache, sID, nSlot);
        SetLocalString(oSkillCache, sSlot + "_ID", sID);
        SetLocalString(oSkillCache, sSlot + "_NAME", stRecipe.sName);
        SetLocalInt(oSkillCache, sSlot + "_CATEGORY", stRecipe.nCategory);
        SetLocalInt(oSkillCache, sSlot + "_VALUE", stRecipe.nValue);
        SetLocalInt(oSkillCache, sSlot + "_RACE", stRecipe.nRace);
        SetLocalInt(oSkillCache, sSlot + "_SETTINGS", stRecipe.nSettings);
    }
    return sID;
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRAddRecipe(object oInputContainer, object oOutputContainer, int nSkill, string sID = "")
{
    struct gsCRRecipe stRecipe;
    int nSlot                = 0;

    _gsCRGetSkillCache(nSkill);

    _gsCRAddRecipe(oInputContainer);
    _gsCRAddRecipe(oOutputContainer);

    stRecipe.sName           = GetLocalString(oOutputContainer, "GS_CR_NAME");
    stRecipe.nSkill          = nSkill;
    stRecipe.nCategory       = GetLocalInt(oOutputContainer, "GS_CR_CATEGORY");
    if(stRecipe.nCategory == 0)
        stRecipe.nCategory = 113; //change short swords category,
    stRecipe.nValue          = GetLocalInt(oOutputContainer, "GS_CR_VALUE");




    stRecipe.nRace           = GetLocalInt(oInputContainer, "MD_CR_RACE");

    stRecipe.nSettings       =  GetLocalInt(oInputContainer, "MD_CR_SETTINGS");




    nSlot                    = __gsCRAddRecipe(stRecipe);
    if (nSlot)
    {
        string sID = _LoadRecipe(nSlot, stRecipe); //must do this so i can get the correct id
        if(sID != "")
        {
            gsCRIncreaseCategoryCount(nSkill, stRecipe.nCategory);
            SetLocalInt(oCraftCache, "GS_CR_RECIPE_COUNT", GetLocalInt(oCraftCache, "GS_CR_RECIPE_COUNT") + 1);
            __mdCRaddRecipe(sID, oInputContainer, oOutputContainer, nSlot); // this also caches it
        }
    }

    return stRecipe;
}
//----------------------------------------------------------------
void _gsCRAddRecipe(object oContainer)
{
    object oItem1     = OBJECT_INVALID;
    object oItem2     = OBJECT_INVALID;
    string sName      = "";
    string sResRef1   = "";
    string sResRef2   = "";
    string sNth       = "";
    int nValueTotal   = 0;
    int nValueMaximum = 0;
    int nValue        = 0;
    int nCount        = 0;
    int nNth          = 1;
    int nRace         = 0;
    int nSettings     = 0;
    //stores input and output count, given we use different containers for each we only need one variable
    int nICount        = GetLocalInt(oContainer, "MD_CR_COUNT");
    //reset list
    for (; nNth <= nICount; nNth++)
    {
        sNth = IntToString(nNth);
        DeleteLocalInt(oContainer, "GS_CR_COUNT_" + sNth);
        DeleteLocalString(oContainer, "GS_CR_RESREF_" + sNth);
        DeleteLocalString(oContainer, "GS_CR_NAME_" + sNth);
    }
    DeleteLocalInt(oContainer, "MD_CR_SETTINGS");
    DeleteLocalInt(oContainer, "MD_CR_RACE");

    //build list
    oItem1 = GetFirstItemInInventory(oContainer);

    nNth = 1;
    nICount = 0;
    while (GetIsObjectValid(oItem1))
    {
        sResRef1     = __gsGetResRef(oItem1);
        nValue       = gsCMGetItemValue(oItem1);
        nValueTotal += nValue;

        //find most valuable item
        if (nValue > nValueMaximum)
        {
            oItem2        = oItem1;
            nValueMaximum = nValue;
        }

        //treat some items   differently
        if(GetStringLeft(sResRef1, 6) == "md_cr_")
        {

            if(GetStringLeft(sResRef1, 7) == "md_cr_r")
                nRace = nRace |  md_ConvertRaceToBit(StringToInt(GetStringRight(sResRef1, 2)));
            else if(GetStringLeft(sResRef1, 8) == "md_cr_sr")
                nRace = nRace | md_ConvertSubraceToBit(StringToInt(GetStringRight(sResRef1, 3)));
            else if(sResRef1 == "md_cr_nu")
                nSettings = nSettings | SETTING_NOUND;
            else if(sResRef1 == "md_cr_ns")
                nSettings = nSettings | SETTING_NOSUR;
            else if(sResRef1 == "md_cr_hid")
                nSettings = nSettings | SETTING_HIDDEN;
        }
        else
        {
            for (nNth = 1; nNth <= 5; nNth++)
            {
                sNth     = IntToString(nNth);
                sResRef2 = GetLocalString(oContainer, "GS_CR_RESREF_" + sNth);

                //not in list
                if (sResRef2 == "")
                {
                    SetLocalInt(oContainer, "GS_CR_COUNT_" + sNth, GetItemStackSize(oItem1));
                    SetLocalString(oContainer, "GS_CR_RESREF_" + sNth, sResRef1);
                    SetLocalString(oContainer, "GS_CR_NAME_" + sNth, GetName(oItem1, TRUE));
                    nICount++;
                    break;
                }

                //already in list, increase count
                if (sResRef1 == sResRef2)
                {
                    nCount = GetLocalInt(oContainer, "GS_CR_COUNT_" + sNth) +
                        GetItemStackSize(oItem1);
                    SetLocalInt(oContainer, "GS_CR_COUNT_" + sNth, nCount);
                    break;
                }
            }
        }

         //if (nNth == 6) break; no longer limited to 5 items

        oItem1   = GetNextItemInInventory(oContainer);
    }

    SetLocalString(oContainer, "GS_CR_NAME", GetName(oItem2, TRUE));
    SetLocalInt(oContainer, "GS_CR_CATEGORY", GetBaseItemType(oItem2));
    SetLocalInt(oContainer, "GS_CR_VALUE", nValueTotal);
    SetLocalInt(oContainer, "MD_CR_COUNT", nICount);
    SetLocalInt(oContainer, "MD_CR_SETTINGS", nSettings);
    SetLocalInt(oContainer, "MD_CR_RACE", nRace);
}
//----------------------------------------------------------------
int __gsCRAddRecipe(struct gsCRRecipe stRecipe)
{

    string sSlot     = "";
    int nSlot        = 1;

    //find empty slot for skill
    for (; nSlot <= GS_CR_LIMIT_RECIPE; nSlot++)
    {
        sSlot = IntToString(nSlot);
        if (GetLocalString(oSkillCache,  sSlot + "_ID") == "") break;
    }

    if (nSlot > GS_CR_LIMIT_RECIPE) return FALSE; //no empty slot

    SQLExecStatement("INSERT INTO md_cr_recipes (Name, Category, Skill, Value, SubRace, Settings) VALUES(?,?,?,?,?,?)",
        stRecipe.sName, IntToString(stRecipe.nCategory), IntToString(stRecipe.nSkill), IntToString(stRecipe.nValue), IntToString(stRecipe.nRace), IntToString(stRecipe.nSettings));



    return nSlot;
}
//----------------------------------------------------------------
void __mdCRaddRecipe(string sID, object oInput, object oOutput, int nSlot)
{
    int x;
    string sx;
    string sSlot = IntToString(nSlot);
    int nQty;
    string sName;
    string sResRef;
    for(x = 1; x<= GetLocalInt(oInput, "MD_CR_COUNT"); x++)
    {
        sx = IntToString(x);
        sName = GetLocalString(oInput, "GS_CR_NAME_" + sx);
        nQty  = GetLocalInt(oInput, "GS_CR_COUNT_" + sx);
        sResRef = GetLocalString(oInput, "GS_CR_RESREF_" + sx);
        SQLExecStatement("INSERT INTO md_cr_input (Name, Qty, Resref, Recipe_ID) VALUES(?,?,?,?)",
            sName, IntToString(nQty), sResRef, sID);

        SetLocalInt(oSkillCache, sSlot + "_INPUT_COUNT_" +  sResRef, nQty);
        SetLocalString(oSkillCache, sSlot + "_INPUT_RESREF_" + sx, sResRef);
        SetLocalString(oSkillCache, sSlot + "_INPUT_NAME_" + sResRef, sName);
    }

    for(x = 1; x<= GetLocalInt(oOutput, "MD_CR_COUNT"); x++)
    {
        sx = IntToString(x);
        sName = GetLocalString(oOutput, "GS_CR_NAME_" + sx);
        nQty  = GetLocalInt(oOutput, "GS_CR_COUNT_" + sx);
        sResRef = GetLocalString(oOutput, "GS_CR_RESREF_" + sx);
        SQLExecStatement("INSERT INTO md_cr_output (Name, Qty, Resref, Recipe_ID) VALUES(?,?,?,?)",
            sName, IntToString(nQty), sResRef, sID);

        SetLocalInt(oSkillCache, sSlot + "_OUTPUT_COUNT_" + sResRef, nQty);
        SetLocalString(oSkillCache, sSlot + "_OUTPUT_RESREF_" + sx, sResRef);
        SetLocalString(oSkillCache, sSlot + "_OUTPUT_NAME_" + sResRef, sName);
    }
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRGetRecipeInSlot(int nSkill, int nSlot)
{
    _gsCRGetSkillCache(nSkill);
    struct gsCRRecipe stRecipe;
    string sSlot = IntToString(nSlot);
    string sID               = GetLocalString(oSkillCache, sSlot + "_ID");

    if (sID == "") return stRecipe;

    stRecipe.sID             = sID;
    stRecipe.sName           = GetLocalString(oSkillCache, sSlot + "_NAME");
    stRecipe.nSkill          = nSkill;
    stRecipe.nCategory       = GetLocalInt(oSkillCache, sSlot + "_CATEGORY");
    stRecipe.nValue          = GetLocalInt(oSkillCache, sSlot + "_VALUE");
    stRecipe.sSlot           = IntToString(nSlot);
    stRecipe.nDC             = GetLocalInt(oSkillCache, sSlot + "_DC");
    stRecipe.nPoints         = GetLocalInt(oSkillCache, sSlot + "_POINTS");

    stRecipe.nRace           = GetLocalInt(oSkillCache, sSlot + "_RACE");
    stRecipe.nSettings       = GetLocalInt(oSkillCache, sSlot + "_SETTINGS");
    stRecipe.sTag            = GetLocalString(oSkillCache, sSlot + "_TAG");

    stRecipe.nClass          = GetLocalInt(oSkillCache, sSlot + "_CLASS");
    stRecipe.nLevel          = GetLocalInt(oSkillCache, sSlot + "_LEVEL");

    return stRecipe;
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRGetRecipeByID(int nSkill, string sID)
{
    _gsCRGetSkillCache(nSkill);
    int nSlot      = GetLocalInt(oSkillCache, sID);

    return gsCRGetRecipeInSlot(nSkill, nSlot);
}
//----------------------------------------------------------------
int gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot);
}
//----------------------------------------------------------------
int _gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot, int nStep = 1)
{
    _gsCRGetSkillCache(nSkill);

    string sSlot   = "";

    for (; nSlot >= 0 && nSlot < GS_CR_LIMIT_RECIPE; nSlot += nStep)
    {
        sSlot = IntToString(nSlot);

        if (GetLocalString(oSkillCache, sSlot + "_ID") != "" &&
            GetLocalInt(oSkillCache, sSlot + "_CATEGORY") == nCategory)
        {
            return nSlot;
        }
    }

    return -1;
}
//----------------------------------------------------------------
int gsCRGetNextRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot + 1);
}
//----------------------------------------------------------------
int gsCRGetPreviousRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot - 1, -1);
}
//----------------------------------------------------------------
void gsCRRemoveRecipeInSlot(int nSkill, int nSlot)
{
    _gsCRGetSkillCache(nSkill);

    string sSlot     = IntToString(nSlot);

    string sID       = GetLocalString(oSkillCache, sSlot + "_ID");
    int nCategory    = GetLocalInt(oSkillCache, sSlot + "_CATEGORY");

    DeleteLocalInt(oSkillCache, sID);
    DeleteLocalString(oSkillCache, sSlot + "_ID");
    SQLExecStatement("DELETE FROM md_cr_recipes WHERE ID=?", sID);

    gsCRDecreaseCategoryCount(nSkill, nCategory);
}
//----------------------------------------------------------------
void gsCRRemoveRecipeByID(int nSkill, string sID)
{
    _gsCRGetSkillCache(nSkill);

    int nSlot      = GetLocalInt(oSkillCache, sID);

    gsCRRemoveRecipeInSlot(nSkill, nSlot);
}
//----------------------------------------------------------------
int gsCRGetRecipeDC(struct gsCRRecipe stRecipe)
{
    int nDC = stRecipe.nDC;
    if(nDC <= 0)
    {
        nDC =
            GS_CR_OFFSET_DC +
            gsCMGetItemLevelByValue(
                stRecipe.nValue * GS_CR_MODIFIER_DC);
    }

    return nDC < 1 ? 1 : nDC;
}
//----------------------------------------------------------------
int gsCRGetRecipeCraftPoints(struct gsCRRecipe stRecipe)
{

    int nCraftPoints = stRecipe.nPoints;
    if(nCraftPoints <= 0)
    {
        nCraftPoints = stRecipe.nValue / GS_CR_MODIFIER_CRAFT_POINTS;
    }

    return nCraftPoints < 1 ? 1 : nCraftPoints;
}
//----------------------------------------------------------------
string gsCRGetRecipeInputList(struct gsCRRecipe stRecipe)
{

    string sString = "";
    int x = 1;
    string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_1");
    int nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);

    while(nQty)
    {
        sString  += "\n" + IntToString(nQty) + " " + GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_NAME_" + sResRef);
        x++;
        sResRef =  GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_"+ IntToString(x));
        nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);
    }

    return sString;
}
//----------------------------------------------------------------
string gsCRGetRecipeOutputList(struct gsCRRecipe stRecipe)
{
    string sString = "";
    int x = 1;


    string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_1");
    int nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_OUTPUT_COUNT_" + sResRef);

    while(nQty)
    {
        sString  += "\n" + IntToString(nQty) + " " + GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_NAME_" + sResRef);
        x++;
        sResRef =  GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_"+ IntToString(x));
        nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_OUTPUT_COUNT_" + sResRef);
    }

    return sString;
}
//----------------------------------------------------------------
void gsCRLoadRecipeList(int nSkill)
{
    int nStart = 0;
    //int nEnd   = 0;
    object oObject;

    for (; nStart <= GS_CR_LIMIT_RECIPE; nStart += 15)
    {
        ActionDoCommand(_gsCRLoadRecipeList(nSkill, nStart));
    }
}
//----------------------------------------------------------------
void _gsCRLoadRecipeList(int nSkill, int nStart)
{
    _gsCRGetSkillCache(nSkill);
    int nCount     = GetLocalInt(oCraftCache, "GS_CR_RECIPE_COUNT");

    int nEnd = nStart + 15;

    while (nStart < nEnd)
    {
        nCount += __gsCRLoadRecipeList(nSkill, nStart);
        nStart ++;
    }

    SetLocalInt(oCraftCache, "GS_CR_RECIPE_COUNT", nCount);
}
//----------------------------------------------------------------
void _LoadInputOutput(string sSlot, string sID)
{
    SQLExecStatement("SELECT Resref,Name,Qty FROM md_cr_input WHERE Recipe_ID=?", sID);

    int nNth = 0;
    string sNth;
    string sResRef;
    while(SQLFetch())
    {
        ++nNth;
        sNth = IntToString(nNth);
        sResRef = SQLGetData(1);
        SetLocalInt(
            oSkillCache,
            sSlot + "_INPUT_COUNT_" + sResRef,
            StringToInt(SQLGetData(3)));
        SetLocalString(
            oSkillCache,
            sSlot + "_INPUT_RESREF_" + sNth,
            sResRef);
        SetLocalString(
            oSkillCache,
            sSlot + "_INPUT_NAME_" + sResRef,
            SQLGetData(2));
    }
    //input and output likely to have 2 different counts so.. got to do it like this
    SQLExecStatement("SELECT Resref,Name,Qty FROM md_cr_output WHERE Recipe_ID=?", sID);
    nNth = 0;
    while(SQLFetch())
    {
        nNth++;
        sNth = IntToString(nNth);
        sResRef = SQLGetData(1);
        SetLocalInt(
            oSkillCache,
            sSlot + "_OUTPUT_COUNT_" + sResRef,
            StringToInt(SQLGetData(3)));
        SetLocalString(
            oSkillCache,
            sSlot + "_OUTPUT_RESREF_" + sNth,
            sResRef);
        SetLocalString(
            oSkillCache,
            sSlot + "_OUTPUT_NAME_" + sResRef,
            SQLGetData(2));
    }
}
//----------------------------------------------------------------
int __gsCRLoadRecipeList(int nSkill, int nSlot)
{
    SQLExecStatement("SELECT ID,Category,Name,Value,SubRace,Settings,DC,Points,Placeable_Tag,Class,Class_Level FROM md_cr_recipes WHERE Skill=? ORDER BY DC,Value,Name,ID LIMIT " + IntToString(nSlot) + ",1", IntToString(nSkill));

    if (!SQLFetch()) return FALSE;

    string sID       = SQLGetData(1);
    string sSlot     = IntToString(nSlot);
    WriteTimestampedLogEntry("Loading... inc_craft ID: " + sID + " Slot: " + sSlot + " Name: " + SQLGetData(3) + " Skill: " + IntToString(nSkill));
    int nCategory    =  StringToInt(SQLGetData(2));
    SetLocalInt(oSkillCache, sID, nSlot);
    SetLocalString(oSkillCache, sSlot + "_ID", sID);
    SetLocalString(oSkillCache, sSlot + "_NAME", SQLGetData(3));
    SetLocalInt(oSkillCache, sSlot + "_CATEGORY", nCategory);
    SetLocalInt(oSkillCache, sSlot + "_VALUE", StringToInt(SQLGetData(4)));
    SetLocalInt(oSkillCache, sSlot + "_RACE", StringToInt(SQLGetData(5)));
    SetLocalInt(oSkillCache, sSlot + "_SETTINGS", StringToInt(SQLGetData(6)));
    SetLocalInt(oSkillCache, sSlot + "_DC", StringToInt(SQLGetData(7)));
    SetLocalInt(oSkillCache, sSlot + "_POINTS", StringToInt(SQLGetData(8)));
    SetLocalString(oSkillCache, sSlot + "_TAG", SQLGetData(9));
    SetLocalInt(oSkillCache, sSlot + "_CLASS", StringToInt(SQLGetData(10)));
    SetLocalInt(oSkillCache, sSlot + "_LEVEL", StringToInt(SQLGetData(11)));

    _LoadInputOutput(sSlot, sID);

    gsCRIncreaseCategoryCount(nSkill, nCategory);
    return TRUE;
}
//----------------------------------------------------------------
void _gsCRGetSkillCache(int nSkill=-1)
{
    if (nSkill >= 0)
        oSkillCache = gsCMGetCacheItem("CRAFT_" + IntToString(nSkill));
    oCraftCache = gsCMGetCacheItem("CRAFT");
}
//----------------------------------------------------------------
int gsCRGetFirstCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory);
}
//----------------------------------------------------------------
int _gsCRGetFirstCategory(int nSkill, int nCategory, int nStep = 1)
{
    for (; nCategory >= 0 && nCategory < GS_CR_LIMIT_CATEGORY; nCategory += nStep)
    {
        if (gsCRGetCategoryCount(nSkill, md_ConvertToCategory(nCategory))) return nCategory;
    }

    return -1;
}
//----------------------------------------------------------------
int gsCRGetNextCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory + 1);
}
//----------------------------------------------------------------
int gsCRGetPreviousCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory - 1, -1);
}
//----------------------------------------------------------------
void gsCRIncreaseCategoryCount(int nSkill, int nCategory)
{
    _gsCRIncreaseCategoryCount(nSkill, nCategory);
}
//----------------------------------------------------------------
void _gsCRIncreaseCategoryCount(int nSkill, int nCategory, int nValue = 1)
{
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nSkill) + "_" +
                     IntToString(nCategory) + "_" +
                     "COUNT";
    int nCount;

    _gsCRGetSkillCache(nSkill);
    nCount = GetLocalInt(oSkillCache, sString) + nValue;
    SetLocalInt(oSkillCache, sString, nCount < 0 ? 0 : nCount);
}
//----------------------------------------------------------------
void gsCRDecreaseCategoryCount(int nSkill, int nCategory)
{
    _gsCRIncreaseCategoryCount(nSkill, nCategory, -1);
}
//----------------------------------------------------------------
int gsCRGetCategoryCount(int nSkill, int nCategory)
{
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nSkill) + "_" +
                     IntToString(nCategory) + "_" +
                     "COUNT";

    _gsCRGetSkillCache(nSkill);
    return GetLocalInt(oSkillCache, sString);
}
//----------------------------------------------------------------
string gsCRGetCategoryName(int nCategory)
{
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nCategory) + "_" +
                     "NAME";

    _gsCRGetSkillCache();
    return GetLocalString(oCraftCache, sString);
}
//----------------------------------------------------------------
void gsCRLoadCategoryList()
{
    string sName   = "";
    string sString = "";
    int nNth       = 0;

    _gsCRGetSkillCache();
    SQLExecStatement("SELECT id,name FROM md_cr_category ORDER BY tier ASC, name ASC");
    if(!SQLFetch())
    {
        for (; nNth < GS_CR_LIMIT_CATEGORY; nNth++)
        {
            sName = Get2DAString("baseitems", "Name", nNth);
            if (sName != "" && sName != "0")
            {
                sName   = GetStringByStrRef(StringToInt(sName));
                sString = "GS_CR_CATEGORY_" + IntToString(nNth) + "_NAME";

                SetLocalString(oCraftCache, sString, sName);
                SQLExecStatement("INSERT INTO md_cr_category(name,original,id,tier) VALUES (?,?,?,'100')", sName,IntToString(nNth),IntToString((nNth == 0 ? 113 : nNth)));
            }
        }
        SQLExecStatement("UPDATE md_cr_recipes SET category=113 WHERE category=0");
    }
    else
    {
	    // NB - the ints below are not set up in the branch above, so this may not work correctly
		// when the data is first populated.
        SetLocalInt(oCraftCache, "MD_USING_CAT_TABLE", 1);
        string sID = SQLGetData(1);
        SetLocalString(oCraftCache, "GS_CR_CATEGORY_"+sID+"_NAME", SQLGetData(2));
        SetLocalInt(oCraftCache, "GS_CR_CATEGORY_0_ID", StringToInt(sID));
        while(SQLFetch())
        {
            sID = SQLGetData(1);
            SetLocalString(oCraftCache, "GS_CR_CATEGORY_"+sID+"_NAME", SQLGetData(2));
            SetLocalInt(oCraftCache, "GS_CR_CATEGORY_"+IntToString(++nNth)+"_ID", StringToInt(sID));
        }
    }
}
//----------------------------------------------------------------
void gsCRGetQuantity(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF)
{

    object oItem   = GetFirstItemInInventory(oContainer);
    string sResRef = "";
    int nCount     = 0;


    //Delete relevant counts
    int x = 1;
    sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + IntToString(x));
    while(sResRef != "")
    {
        DeleteLocalInt(oContainer, "COUNT_" + sResRef);

        // remains will leave some materials behind, to reflect this, we'll add all qty needed of the first material in the list
        if (GetLocalString(oContainer, "GVD_REMAINS_STATUS") != "") {
          if (x == 1) {
            SetLocalInt(oContainer, "COUNT_" + sResRef, GetLocalInt(oSkillCache,  stRecipe.sSlot + "_INPUT_COUNT_" + sResRef));
          }
        }

        sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + IntToString(++x));
    }

    while (GetIsObjectValid(oItem))
    {
        if (GetIdentified(oItem))
        {
            sResRef = __gsGetResRef(oItem);
            nCount  = GetItemStackSize(oItem);

            //Check if there's  a match
            if(GetLocalInt(oSkillCache,  stRecipe.sSlot + "_INPUT_COUNT_" + sResRef))
                SetLocalInt(oContainer, "COUNT_" + sResRef, GetLocalInt(oContainer, "COUNT_" + sResRef) + nCount);

        }

        oItem   = GetNextItemInInventory(oContainer);
    }


}
//----------------------------------------------------------------
int gsCRGetIsQuantitySufficient(struct gsCRRecipe stRecipe, object oContainer=OBJECT_SELF)
{

    string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_1");
    int nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);
    int nQty1 = GetLocalInt(oContainer, "COUNT_" + sResRef);
    int x = 1;
    while(nQty1 >= nQty && nQty > 0)
    {
        x++;
        sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + IntToString(x));
        if(sResRef == "") return TRUE; //no new item
        nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);
        nQty1 = GetLocalInt(oContainer, "COUNT_" + sResRef);
    }

    return FALSE;
}
//----------------------------------------------------------------
string gsCRGetQuantityList(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF)
{

    string sString = "";
    int x = 1;

    string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_1");
    int nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);
    int nQty1 = GetLocalInt(oContainer, "COUNT_" + sResRef);
    while(nQty)
    {
        sString  += "\n" + IntToString(nQty1) + "/" + IntToString(nQty) + " " + GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_NAME_" + sResRef);
        x++;
        sResRef =  GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_"+ IntToString(x));
        nQty = GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef);
        nQty1 = GetLocalInt(oContainer, "COUNT_" + sResRef);
    }

    return sString;
}
//----------------------------------------------------------------
void gsCRConsumeMaterial(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF)
{
    object oItem   = GetFirstItemInInventory(oContainer);


    int nCount;
    //Create the variables
    int x = 1;
    string sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_1");

    while(sResRef != "")
    {
        SetLocalInt(oContainer, "CONSUME_" + sResRef, GetLocalInt(oSkillCache, stRecipe.sSlot + "_INPUT_COUNT_" + sResRef));
        sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_INPUT_RESREF_" + IntToString(++x));
    }
    while (GetIsObjectValid(oItem))
    {
        if (GetIdentified(oItem))
        {
            sResRef = __gsGetResRef(oItem);
            nCount = GetLocalInt(oContainer, "CONSUME_" + sResRef);
            nCount = _gsCRConsumeMaterial(oItem, nCount);
            if(nCount > 0)
                SetLocalInt(oContainer, "CONSUME_" + sResRef, nCount);
            else
                DeleteLocalInt(oContainer, "CONSUME_" + sResRef);

        }

        oItem   = GetNextItemInInventory(oContainer);
    }
}
//----------------------------------------------------------------
int _gsCRConsumeMaterial(object oItem, int nCount)
{
    int nStackSize = GetItemStackSize(oItem);

    if (nCount > 0)
    {
        if (nStackSize > nCount)
        {
            SetItemStackSize(oItem, nStackSize - nCount);
            nCount  = 0;
        }
        else
        {
            DestroyObject(oItem);
            nCount -= nStackSize;
        }
    }

    return nCount;
}
//----------------------------------------------------------------
void gsCRCreateProduction(struct gsCRRecipe stRecipe, object oPC,object oContainer = OBJECT_SELF)
{

    gsCRGetQuantity(stRecipe, oContainer);
    //check material quantity
    if (! gsCRGetIsQuantitySufficient(stRecipe, oContainer)) return;

    gsCRConsumeMaterial(stRecipe, oContainer);

    //check skill
    if (! gsCRGetIsSkillSuccessful(stRecipe.nSkill, gsCRGetRecipeDC(stRecipe), oPC))
    {
        // Deity insert.  Check whether the crafter's patron deity intercedes to
        // rescue the production.
        string sDeity = GetDeity(oPC);
        if (gsWOGetDeityAspect(oPC) & ASPECT_KNOWLEDGE_INVENTION &&
            gsWOGrantBoon(oPC) )
        {
          FloatingTextStringOnCreature(sDeity + " intercedes to aid your work.", oPC);
        }
        else
        {
          FloatingTextStringOnCreature(GS_T_16777227, oPC, FALSE);
          return;
        }
    }

    //create production item
    string sTemplate = gsCRGetProductionTemplate(stRecipe.nSkill);
    string sTag      = "GS_CR_" +
                       IntToString(stRecipe.nSkill) + "_" +
                       stRecipe.sID + "_" +
                       "0_" +
                       IntToString(Random(1000) + 1000);
    object oItem     = CreateItemOnObject(sTemplate,
                                          oContainer,
                                          1,
                                          sTag);

    if (GetIsObjectValid(oItem))
    {
        SetName(oItem, stRecipe.sName + " (0%)");
        SetLocalString(oItem, GetPCPublicCDKey(oPC, TRUE), gsPCGetPlayerID(oPC));
        SetLocalInt(oItem, "MD_CON_PRO", 1);
    }

    FloatingTextStringOnCreature(GS_T_16777228, oPC, FALSE);
}
//----------------------------------------------------------------
struct gsCRProduction gsCRGetProductionData(object oItem)
{
    struct gsCRProduction stProduction;
    string sTag    = ConvertedStackTag(oItem); //GS_CR_{skill}_{recipe_id}_{craft_points}_{random}

    if (GetStringLeft(sTag, 6) != "GS_CR_") return stProduction;

    string sString = "";
    string sChar   = "";
    int nCount     = GetStringLength(sTag);
    int nFlag      = 0;
    int nNth       = 6;

    for (; nNth < nCount; nNth++)
    {
        sChar = GetSubString(sTag, nNth, 1);

        if (sChar == "_")
        {
            switch (nFlag)
            {
            case 0:
                stProduction.nSkill  = StringToInt(sString);
                break;

            case 1:
                stProduction.sRecipe = sString;
                break;

            case 2:
                stProduction.nCraftPoints = StringToInt(sString);
                break;
            }

            sString  = "";
            nFlag   += 1;
        }
        else
        {
            sString += sChar;
        }
    }

    return stProduction;
}
//----------------------------------------------------------------
string gsCRGetProductionTemplate(int nSkill)
{
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER: return GS_CR_TEMPLATE_CARPENTER;
    case GS_CR_SKILL_COOK:      return GS_CR_TEMPLATE_COOK;
    case GS_CR_SKILL_CRAFT_ART: return GS_CR_TEMPLATE_CRAFT_ART;
    case GS_CR_SKILL_FORGE:     return GS_CR_TEMPLATE_FORGE;
    case GS_CR_SKILL_MELD:      return GS_CR_TEMPLATE_MELD;
    case GS_CR_SKILL_SEW:       return GS_CR_TEMPLATE_SEW;
    }

    return "";
}
//----------------------------------------------------------------
void gsCRProduce(object oItem, object oPC, int nValue = 1, object oContainer = OBJECT_SELF)
{
    //Muling Code AKA: Same CD-KEY Workers check
    string sCDKey = GetPCPublicCDKey(oPC, TRUE);
    if(!GetIsDM(oPC) && (sCDKey != ""))  //make sure cd key exist and they're not a DM
    {
        if ((GetLocalString(oItem, sCDKey) != "") && //make sure the variable exists
           (GetLocalString(oItem, sCDKey) != gsPCGetPlayerID(oPC)) ) //uh oh.. we have someone on the same cd-key but not the same character
        {
            gsCRDecreaseCraftPoints(gsCRGetCraftPoints(oPC), oPC); //Drain the crafting points
            string sLog = "Same Player craft attempt detected: " + GetName(oPC, TRUE) + " (" + GetPCPlayerName(oPC) +
            ", " + sCDKey + ") from IP " + GetPCIPAddress(oPC) + " within area " + GetName(GetArea(oPC)) + ". Item was " + GetName(oItem);
            Warning("Crafting Log:", sLog);
            SendMessageToAllDMs(sLog);
            DestroyObject(oItem);
            return; //end it here
        }
        else {
          if (GetLocalString(oItem, sCDKey) == "") {
            //oh a new pc/player, so lets save them too.
            SetLocalString(oItem, sCDKey, gsPCGetPlayerID(oPC));

            // multiple PCs worked on the same item, it will no longer be possible to get adventure xp for it for the one finishing it
            SetLocalInt(oItem, "GVD_NO_ADV_XP", 1);

          }

        }

    }

    struct gsCRProduction stProduction  = gsCRGetProductionData(oItem);
    struct gsCRRecipe stRecipe          = gsCRGetRecipeByID(stProduction.nSkill,
                                                            stProduction.sRecipe);

    if (stRecipe.sID == "")                  return;

     if(GetLocalInt(oItem, "MD_CON_PRO") == 0 && (StringToInt(stRecipe.sSlot) > 50))
    {
        SendMessageToPC(oPC, "Continueing production on this product is currently disabled. Please be patient." +
            "You can start a new production of the same type without any issues.");

        return;
    }

    int nRecipeDC                       = gsCRGetRecipeDC(stRecipe);
    int nRecipeCraftPoints              = gsCRGetRecipeCraftPoints(stRecipe);
    int nCraftPoints                    = gsCRGetCraftPoints(oPC);
    int nFlag                           = FALSE;
    int nNth                            = 0;
    string sResRef                      = "";
    int x                               = 1;
    object oHide                        = gsPCGetCreatureHide(oPC);
    int iQtyFinished;

    if (nValue < 1 || nValue > nCraftPoints) nValue = nCraftPoints;

    for (; nNth < nValue; nNth++)
    {
        //check skill
        if (gsCRGetIsSkillSuccessful(stRecipe.nSkill, nRecipeDC, oPC))
        {
            stProduction.nCraftPoints += 1;

            //finish production
            if (stProduction.nCraftPoints >= nRecipeCraftPoints)
            {
                gsCRDecreaseCraftPoints(nNth + 1, oPC);

                sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_1");
                while(sResRef != "")
                {
                    _gsCRProduce(GetLocalInt(oSkillCache, stRecipe.sSlot + "_OUTPUT_COUNT_"+sResRef), sResRef, oContainer, stRecipe, oPC);
                    sResRef = GetLocalString(oSkillCache, stRecipe.sSlot + "_OUTPUT_RESREF_" + IntToString(++x));
                }

                // first time PC finishes this product (and did all the work himself)?
                iQtyFinished = GetLocalInt(oHide, "GVD_CRAFT_" + stRecipe.sID);
                if (iQtyFinished == 0) {
                  // check if 100% of the crafting was done by the same PC
                  if (GetLocalInt(oItem, "GVD_NO_ADV_XP") == 0) {

                    // first time PC finishes this product all by itself, adventure xp award (DC * 10)
                    gvd_AdventuringXP_GiveXP(oPC, (nRecipeDC * 10), "Crafting");

                    // keep track on PC hide that this item is finished
                    SetLocalInt(oHide, "GVD_CRAFT_" + stRecipe.sID, 1);
                  }
                } else {

                  // let's keep track of qty finished of each item while we're at it, who knows we like to do something with that later
                  SetLocalInt(oHide, "GVD_CRAFT_" + stRecipe.sID, iQtyFinished + 1);
                }

                DestroyObject(oItem);

                FloatingTextStringOnCreature(GS_T_16777230, oPC, FALSE);
                return;
            }

            nFlag                      = TRUE; //progress
        }
    }

    gsCRDecreaseCraftPoints(nNth, oPC);

    if (nFlag)
    {
        //create proceeded production
        string sTemplate = gsCRGetProductionTemplate(stRecipe.nSkill);
        string sTag      = "GS_CR_" +
                           IntToString(stRecipe.nSkill) + "_" +
                           stRecipe.sID + "_" +
                           IntToString(stProduction.nCraftPoints) +
                           "_" +
                           IntToString(Random(1000) + 1000);
        object oNew      = CopyObject(oItem,
                                       GetLocation(oContainer),
                                       oContainer,
                                       sTag);

        if (GetIsObjectValid(oNew))
        {
            string sPercent = IntToString(100 * stProduction.nCraftPoints / nRecipeCraftPoints);

            SetName(oNew, stRecipe.sName + " (" + sPercent + "%)");
            DestroyObject(oItem);
        }

        FloatingTextStringOnCreature(GS_T_16777231, oPC, FALSE);
    }
    else
    {
        //no progress
        FloatingTextStringOnCreature(GS_T_16777229, oPC, FALSE);
    }
}
//----------------------------------------------------------------
void _gsCRProduce(int nCount, string sResRef, object oContainer, struct gsCRRecipe stRecipe, object oPC = OBJECT_INVALID)
{
    object oItem       = OBJECT_INVALID;
    location lLocation = GetLocation(oContainer);
    int nNth           = 0;

    if (GetIsObjectValid(oPC))
    {
        string sName = GetName(oPC);
        int nSize = 0;
        nNth = nCount;

        while (nNth > 0)
        {
            // Always create up to the max needed, even if we know nSize.
            oItem = CreateItemOnObject(sResRef, oContainer, nNth);

            // If we don't know what size we're getting yet...
            if (!nSize)
            {
                nSize = GetItemStackSize(oItem);
                // Safety net: invalid item ResRef
                if (nSize < 1)
                {
                    return;
                }
            }

            gsIPSetOwner(oItem, oPC);
            SetIdentified(oItem, TRUE);
            _mdAddItemProperties(stRecipe, oItem);
            nNth -= nSize;
        }
    }
    else
    {
        for (; nNth < nCount; nNth++)
        {
            oItem = CreateItemOnObject(sResRef, oContainer);
            SetIdentified(oItem, TRUE);
        }
    }
}
//----------------------------------------------------------------
void gsCRPlaySound(int nSkill)
{
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER:
        PlaySound("as_cv_sawing1");
        break;

    case GS_CR_SKILL_COOK:
        PlaySound("as_cv_shopjugs1");
        break;

    case GS_CR_SKILL_CRAFT_ART:
        PlaySound("as_cv_chiseling2");
        break;

    case GS_CR_SKILL_FORGE:
        PlaySound("as_cv_smithhamr1");
        break;

    case GS_CR_SKILL_MELD:
        PlaySound("al_mg_beaker1");
        break;

    case GS_CR_SKILL_SEW:
        PlaySound("as_na_leafmove1");
        break;
    }
}

// Addition by Mithreas --[
int gsCRGetRacialCraftingBonus(object oPC, int nSkill)
{
  switch (GetRacialType(oPC))
  {
    case RACIAL_TYPE_DWARF:
        if(gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_DWARF_WILD)
            return ((nSkill == GS_CR_SKILL_COOK) ? 1 : 0);
        else
            return ((nSkill == GS_CR_SKILL_FORGE) ? 1 : 0);
    case RACIAL_TYPE_ELF:
        if (gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_ELF_DROW)
        {
          return ((nSkill == GS_CR_SKILL_SEW) ? 1 : 0);
        }
        else
        {
          if (GetLocalInt(GetModule(), "STATIC_LEVEL")) return ((nSkill == GS_CR_SKILL_CRAFT_ART) ? 1 : 0);
          else return ((nSkill == GS_CR_SKILL_CARPENTER) ? 1 : 0);
        }
    case RACIAL_TYPE_GNOME:
        return ((nSkill == GS_CR_SKILL_MELD) ? 1 : 0);
    case RACIAL_TYPE_HALFLING:
        return ((nSkill == GS_CR_SKILL_COOK) ? 1 : 0);
    case RACIAL_TYPE_HALFELF:
        if (gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SPECIAL_HOBGOBLIN)
        {
          return ((nSkill == GS_CR_SKILL_FORGE) ? 1 : 0);
        }
        else
        {
            return ((nSkill == GS_CR_SKILL_CRAFT_ART) ? 1 : 0);
        }
    case RACIAL_TYPE_HALFORC:
        return ((nSkill == GS_CR_SKILL_FORGE) ? 1 : 0);
    case RACIAL_TYPE_HUMAN:
        return ((nSkill == GS_CR_SKILL_SEW) ? 1 : 0);
  }

  return 0;
}
//------------------------------------------------------------------------------
int gsCRGetCraftSkillByItemType(object oItem, int bMundaneProperty)
{
  int nType = GetBaseItemType(oItem);
  int nRetVal = CNR_TRADESKILL_JEWELRY; // Default to jewelry

  switch (nType)
  {
    case BASE_ITEM_ARMOR:
    case BASE_ITEM_BRACER:
      nRetVal = CNR_TRADESKILL_ARMOR_CRAFTING;
      break;
    case BASE_ITEM_LARGESHIELD:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_SMALLSHIELD:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_ARMOR_CRAFTING : CNR_TRADESKILL_INVESTING);
	  break;
    case BASE_ITEM_ARROW:
    case BASE_ITEM_BOLT:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SHORTBOW:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_WOOD_CRAFTING : CNR_TRADESKILL_IMBUING);
      break;
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_HELMET:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TRIDENT:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_WEAPON_CRAFTING : CNR_TRADESKILL_IMBUING);
      break;
    case BASE_ITEM_BELT:
    case BASE_ITEM_BOOTS:
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_GLOVES:
    case BASE_ITEM_SLING:
    case BASE_ITEM_WHIP:
      nRetVal = (bMundaneProperty ? CNR_TRADESKILL_TAILORING: CNR_TRADESKILL_INVESTING);
      break;
	case BASE_ITEM_RING:
	case BASE_ITEM_AMULET:
	  nRetVal = (bMundaneProperty ? CNR_TRADESKILL_JEWELRY : CNR_TRADESKILL_INVESTING);
	  break;
  }

  return nRetVal;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialMultiplier(int nMaterial, int bMundaneProperty = TRUE)
{
  int nMaterialBonus = 1;

  if (bMundaneProperty)
  {
    switch (nMaterial)
    {
      case 3: // bronze
      case 13: // silver
      case 17: // hide
	  case 18: // arachne chitin
      case 36: // wool
      case 38: // ironwood
	  case 40: // entwood
        nMaterialBonus = 2;
        break;
      case 9: // iron
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 30: // dragonhides
      case 31: // leather
      case 39: // duskwood
        nMaterialBonus = 3;
        break;
      case 11: // mithril
      case 15: // steel
      case 32: // ankheg (scale)
        nMaterialBonus = 4;
        break;

    }
  }
  else
  {
    switch (nMaterial)
    {
      case 13: // silver
      case 32: // ankheg (scale)
      case 36: // wool
      case 38: // ironwood
        nMaterialBonus = 2;
        break;
      case 8: // gold
      case 11: // mithril
	  case 18: // arachne chitin
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 35: // silk
      case 30: // dragonhides
      case 39: // duskwood
      case 40: // entwood
        nMaterialBonus = 3;
        break;
    }
  }

  return nMaterialBonus;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialSkillBonus(object oItem)
{
  int nMaterial = gsIPGetBonusMaterialType(oItem);
  int nBonus    = 0;
  
  switch (nMaterial)
  {
    case 61: // Fire Agate
	case 65: // Greenstone
	case 68: // Malachite
	  nBonus = 1;
	  break;
	case 54: // Aventurine
	case 70: // Phenalope
	  nBonus = 2;
	  break;
	case 53: // Amethyst
	case 63: // Fluorspar
	  nBonus = 3;
	  break;
	case 52: // Alexandrite
	case 64: // Garnet
	  nBonus = 4;
	  break;
	case 75: // Topaz
	  nBonus = 5; 
	  break;
	case 73: // Sapphire
	case 62: // Fire Opal
	  nBonus = 6;
	  break;
	case 59: // Diamond
	case 72: // Ruby
	case 60: // Emerald
	  nBonus = 7;
	  break;
  }
  
  if (nBonus) return nBonus;
  
  int nQuality = gsIPGetQuality(oItem);
  
  switch (nQuality)
  {
    case 0:  // unknown
	case 1:  // destroyed
	case 2:  // ruined
	case 13: // raw
	case 14: // cut
	case 15: // polished
	  // No bonus.
	  break;
	default:
      nBonus = nQuality - 6; // penality for poor quality, zero for average, bonus above that. 	
	  break;
  }
 
  return nBonus; 
}

//------------------------------------------------------------------------------
float gsCRGetCraftingCostMultiplier(object oPC, object oItem, itemproperty ip)
{
  if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) return 1.0f;
  
  int nMaterial = gsIPGetMaterialType(oItem);
  int nMundaneProperty = gsIPGetIsMundaneProperty(GetItemPropertyType(ip), GetItemPropertySubType(ip));
  int nMaterialBonus = gsCRGetMaterialMultiplier(nMaterial, nMundaneProperty);

  // Scale cost by craft skill level and item type.
  int nXP = CnrGetTradeskillXPByType(oPC, gsCRGetCraftSkillByItemType(oItem, nMundaneProperty));
  int nSkill = CnrDetermineTradeskillLevel(nXP);
  if (nSkill < 3) nSkill = 3;
  
  // Bonus material.
  nSkill += gsCRGetMaterialSkillBonus(oItem);

  float fMiscBonus = 1.0f;

  if (nMaterial == 7 && nMundaneProperty)  // Darksteel, Ondaran
  {
    fMiscBonus = 0.5f;  // Make mundane work twice as expensive.  
  }
 
  // Higher grade materials can be improved more easily.  Higher skill PCs
  // can improve items more easily.  With 15 skill and a master quality item
  // (x4) you can get to 120,000gp value rather than the usual 10,000.
  // With 5 skill and item quality 1, your value is unchanged.
  return (5.0 / (IntToFloat(nMaterialBonus) * IntToFloat(nSkill) * fMiscBonus));
}

int gsCRGetIsValid(object oItem, int nProperty)
{
  if (GetLocalInt(GetModule(), "STATIC_LEVEL"))
  {
    int nCraftSkill = gsCRGetCraftSkillByItemType(oItem, gsIPGetIsMundaneProperty(nProperty, 0));
    int nRestriction = gsIPGetIsValid(oItem, nProperty);

    // The restriction in the 2da file is a bitwise flag.
    int nFlag = 0;
    switch (nCraftSkill)
    {
      case CNR_TRADESKILL_COOKING:
	  case CNR_TRADESKILL_CHEMISTRY:
        nFlag = 1;
        break;
      case CNR_TRADESKILL_WOOD_CRAFTING:
      case CNR_TRADESKILL_JEWELRY:
        nFlag = 2;
        break;
      case CNR_TRADESKILL_WEAPON_CRAFTING:
      case CNR_TRADESKILL_ARMOR_CRAFTING:
        nFlag = 4;
        break;
      case CNR_TRADESKILL_ENCHANTING:
	  case CNR_TRADESKILL_IMBUING:
	  case CNR_TRADESKILL_INVESTING:
        nFlag = 8;
        break;
      case CNR_TRADESKILL_TAILORING:
        nFlag = 16;
        break;
    }

    return (nRestriction & nFlag);
  }
  else
  {
    return gsIPGetIsValid(oItem, nProperty);
  }
}
//------------------------------------------------------------------------------
int gsCRGetEssenceApplySuccess(object oItem)
{
  if (!GetLocalInt(GetModule(), "STATIC_LEVEL")) return TRUE;

  int nMultiplier = gsCRGetMaterialMultiplier(gsIPGetMaterialType(oItem), FALSE);

  if (d3() <= nMultiplier) return TRUE;

  return FALSE;
}
//------------------------------------------------------------------------------
int gsCRGetMaterialBaseValue(object oItem)
{
  int nMaterial = gsIPGetMaterialType(oItem);
  int nBaseCost = 0;

  switch (nMaterial)
  {
      case 3: // bronze
        nBaseCost = 0;
        break;
      case 8: // gold
        nBaseCost = 15000;
        break;
      case 9: // iron
        nBaseCost = 2000;
        break;
      case 11: // mithril
        nBaseCost = 25000;
        break;
      case 13: // silver
        nBaseCost = 7000;
        break;
      case 15: // steel
        nBaseCost = 6000;
        break;
      case 17: // hide
        nBaseCost = 2000;
        break;
	  case 18: // chitin
	    nBaseCost = 6000;
		break;
      case 20: // wyvern
      case 21: // dragonhides
      case 22:
      case 23:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28: // dragonhide (red)
      case 29:
      case 30: // dragonhides
        nBaseCost = 20000;
        break;
      case 31: // leather
        nBaseCost = 7000;
        break;
      case 32: // ankheg (scale)
        nBaseCost = 20000;
        break;
      case 35: // silk
        nBaseCost = 7000;
        break;
      case 36: // wool
        nBaseCost = 2000;
        break;
      case 38: // ironwood
        nBaseCost = 6500;
        break;
      case 39: // duskwood
        nBaseCost = 18000;
        break;
      case 40: // entwood
	    nBaseCost = 6000;
		break;

  }

  return nBaseCost;
}

//------------------------------------------------------------------------------
string mdCRGetRecipeRaceList(struct gsCRRecipe stRecipe)
{
    string sString = "";


    int x;
    int nBit;
    for(x=0; x<= 6; x++)
    {
        nBit = md_ConvertRaceToBit(x);
        if(nBit & stRecipe.nRace)
            sString += "\n" + gsSUGetRaceName(x);
    }

    //Going to do all subraces here, maybe they'd be added later
    for(x = 1; x <= HIGHEST_SR; x++)
    {
        nBit = md_ConvertSubraceToBit(x);
        if(nBit & stRecipe.nRace)
            sString += "\n" + gsSUGetNameBySubRace(x);
    }

    for(x = 100; x <= HIGHEST_SSR; x++)
    {
        nBit = md_ConvertSubraceToBit(x);
        if(nBit & stRecipe.nRace)
            sString += "\n" + gsSUGetNameBySubRace(x);
    }

    if(SETTING_NOSUR & stRecipe.nSettings)
        sString += "\n" + "No Surface (Sub)Races";
    else if(SETTING_NOUND & stRecipe.nSettings)
        sString += "\n" + "No Underdark (Sub)Races";
    return sString;
}
//------------------------------------------------------------------------------
int mdCRMeetsRequirements(struct gsCRRecipe stRecipe, object oPC, object oPlaceable=OBJECT_SELF)
{
    if(GetIsDM(oPC))
        return TRUE;

    if(mdCRMeetsRaceRequirements(stRecipe, oPC) && mdCRMeetsClassRequirements(stRecipe, oPC) && mdCRMeetsFeatRequirements(stRecipe, oPC) && mdCRMeetsSkillRequirements(stRecipe, oPC) && mdCRMeetsCustomRequirements(stRecipe, oPC, oPlaceable))
        return TRUE;

    return FALSE;
}
//------------------------------------------------------------------------------
int mdCRMeetsRaceRequirements(struct gsCRRecipe stRecipe, object oSpeaker)
{
    if(GetIsDM(oSpeaker))  //Dm's always pass
        return TRUE;
    int nSubrace = gsSUGetSubRaceByName(GetSubRace(oSpeaker));
    int nUndSR = gsSUGetIsUnderdarker(nSubrace);
    if((stRecipe.nSettings & SETTING_NOUND) && nUndSR)  //no underdark races
        return FALSE;

    if((stRecipe.nSettings & SETTING_NOSUR) && !nUndSR)//no surface races
        return FALSE;

    //If no subrace or race was set, pass on through
    if(!stRecipe.nRace)
        return TRUE;

    if(md_IsSubRace(stRecipe.nRace, oSpeaker))
        return TRUE;


    return FALSE;
}
//------------------------------------------------------------------------------
int mdCRMeetsSkillRequirements(struct gsCRRecipe stRecipe, object oSpeaker)
{
    if(GetIsDM(oSpeaker))  //Dm's always pass
        return TRUE;
    SQLExecStatement("SELECT Skill, Rank FROM md_cr_skills WHERE Recipe_ID=?", stRecipe.sID);
    int nFetch = SQLFetch();

    if(!nFetch)   //nothing fetched so no skills
        return TRUE;

    int nBonus;
    int nSkill;
    string sAbility;
    int nAbility;
    int nRank;
    int nSAbility = stRecipe.nSettings & SETTING_ABILITY;
    int nSFeat = stRecipe.nSettings & SETTING_SKILLFEAT;
    int nSOne = stRecipe.nSettings & SETTING_ONESKILL;
    while(nFetch)
    {
        nSkill = StringToInt(SQLGetData(1));


        if(nSAbility || nSFeat)
        {
            sAbility = Get2DAString("skills", "KeyAbility", nSkill);
            if(sAbility == "CHA")
                nAbility = ABILITY_CHARISMA;
            else if(sAbility == "CON")
                nAbility = ABILITY_CONSTITUTION;
            else if(sAbility == "INT")
                nAbility = ABILITY_INTELLIGENCE;
            else if(sAbility == "STR")
                nAbility = ABILITY_STRENGTH;
            else if(sAbility == "DEX")
                nAbility = ABILITY_DEXTERITY;
            else if(sAbility == "WIS")
                nAbility = ABILITY_WISDOM;

            nBonus = gsCMGetBaseAbilityModifier(oSpeaker, nAbility);

        }

        if(nSFeat)
        {
            nRank = gsCMGetBaseSkillRank(nSkill, nAbility, oSpeaker);

            if(!nSAbility)
            {
                nRank -= nBonus;  //won't remove ability scores due to magic.
            }
        }
        else
            nRank =  GetSkillRank(nSkill, oSpeaker, TRUE) + nBonus;

        if(nSOne)
        {
            if(nRank >= StringToInt(SQLGetData(2)))
                return TRUE;
        }
        else if(nRank < StringToInt(SQLGetData(2)))
            return FALSE;
        nFetch = SQLFetch();
    }

    if(nSOne) //no match if it made it this far.
        return FALSE;

    return TRUE;
}
//------------------------------------------------------------------------------
int mdCRMeetsFeatRequirements(struct gsCRRecipe stRecipe, object oPC)
{
    if(GetIsDM(oPC))  //Dm's always pass
        return TRUE;

    SQLExecStatement("SELECT Feat FROM md_cr_feats WHERE Recipe_ID=?", stRecipe.sID);
    int nFetch = SQLFetch();

    if(!nFetch)   //nothing fetched so no feats
        return TRUE;

    int nSOne = SETTING_ONEFEAT & stRecipe.nSettings;
    int nKnowFeat;
    while(nFetch)
    {
        nKnowFeat = GetKnownFeatLevel(oPC, StringToInt(SQLGetData(1)));
        if(nSOne)
        {
            if(nKnowFeat > -1)
                return TRUE;
        }
        else if(nKnowFeat == -1)
            return FALSE;

        nFetch = SQLFetch();
    }

    if(nSOne) //no match if it made it this far.
        return FALSE;

    return TRUE;
}
//------------------------------------------------------------------------------
int mdCRShowRecipe(struct gsCRRecipe stRecipe, object oPC, object oPlaceable=OBJECT_SELF)
{
    if(GetIsDM(oPC)) return TRUE; //always show for dms
    if(stRecipe.nSettings & SETTING_HIDDEN &&  !mdCRMeetsRequirements(stRecipe, oPC, oPlaceable))
        return FALSE; //recipe is hidden and no applicable race

    string sTag = GetTag(oPlaceable);
         //No tag specified     //recipe tag is marked for exlusive placeables, so it shows for all. the recipe isn't exclusive, the placeable is
    if(((stRecipe.sTag == "" || GetStringRight(stRecipe.sTag, 3) == "_ex")  && GetStringRight(sTag, 3) != "_ex") ||  //nothing special, show for all but those exlusive placeables
        stRecipe.sTag == sTag || //Tag match, so show
        GetLocalInt(oPlaceable, stRecipe.sTag) ||   //variable set so show
        GetLocalInt(oPlaceable, "MD_CR_" + stRecipe.sID)) //other variable set so show
         return TRUE;

    return FALSE;
}
//------------------------------------------------------------------------------
string mdCRGetRecipeClassList(struct gsCRRecipe stRecipe)
{
    int nClass;
    string sString = "";
    for(nClass = 0; nClass <= 41; nClass++)
    {

        if(stRecipe.nClass & mdConvertClassToBit(nClass))
            sString += "\n" + mdGetClassName(nClass);
    }

    //Lets do the paths too.
    if(stRecipe.nClass & MD_BIT_WARLOCK)
        sString += "\n" + mdGetPathName(MD_BIT_WARLOCK);

    //Lets do the paths too.
    if(stRecipe.nClass & MD_BIT_FAVSOUL)
        sString += "\n" + mdGetPathName(MD_BIT_FAVSOUL);


    return sString;
}
//------------------------------------------------------------------------------
string mdCRGetRecipeSkillList(struct gsCRRecipe stRecipe)
{
    string sString;

    SQLExecStatement("SELECT Skill, Rank FROM md_cr_skills WHERE Recipe_ID=?", stRecipe.sID);

    while(SQLFetch())
    {

        sString += "\n"+ GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", StringToInt(SQLGetData(1))))) + ": " + SQLGetData(2);
    }

    return sString;
}
//------------------------------------------------------------------------------
string mdCRGetRecipeFeatList(struct gsCRRecipe stRecipe)
{
    string sString;

    SQLExecStatement("SELECT Feat FROM md_cr_feats WHERE Recipe_ID=?", stRecipe.sID);

    while(SQLFetch())
    {
      sString += "\n"+ GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", StringToInt(SQLGetData(1)))));
    }

    return sString;
}
//------------------------------------------------------------------------------
int mdCRMeetsClassRequirements(struct gsCRRecipe stRecipe, object oPC)
{
    if(!stRecipe.nClass || GetIsDM(oPC)) //no class restrictions
        return TRUE;

    int x;
    int nClass;
    object oItem = gsPCGetCreatureHide(oPC);
    int nWarlock = GetLocalInt(oItem, VAR_WARLOCK);
    int nFavSoul = GetLocalInt(oItem, VAR_FAV_SOUL);

    int nLevel = stRecipe.nLevel;

    if(nLevel <= 3)
        nLevel = 3;
    if(stRecipe.nSettings & SETTING_LVLADDITIVE)
    {
        int nAddLvl;
        for(x = 1; x <= 3; x++)
        {
            nClass = GetClassByPosition(x, oPC);
            if(nClass == CLASS_TYPE_BARD && (nWarlock || nFavSoul))
                nClass = -1; //warlocks and favored souls are not bards!
            if(nClass >= 0 && (mdConvertClassToBit(nClass) & stRecipe.nClass))
                nAddLvl += GetLevelByPosition(x, oPC);
        }

        if(nWarlock && stRecipe.nClass & MD_BIT_WARLOCK)
            nAddLvl += GetLevelByPosition(CLASS_TYPE_BARD, oPC);
        else if(nFavSoul && stRecipe.nClass & MD_BIT_FAVSOUL)
            nAddLvl += GetLevelByPosition(CLASS_TYPE_BARD, oPC);

        if(nAddLvl >= nLevel)
            return TRUE;
    }
    else
    {

        for(x = 1; x <= 3; x++)
        {
            nClass = GetClassByPosition(x, oPC);
            if(nClass == CLASS_TYPE_BARD && (nWarlock || nFavSoul))
                nClass = -1; //warlocks and favored souls are not bards!
            if(nClass >= 0 && (mdConvertClassToBit(nClass) & stRecipe.nClass) && GetLevelByPosition(x, oPC) >= nLevel)
                return TRUE;
        }

        if(nWarlock && stRecipe.nClass & MD_BIT_WARLOCK && GetLevelByClass(CLASS_TYPE_BARD, oPC) >= nLevel)
            return TRUE;
        else if(nFavSoul && stRecipe.nClass & MD_BIT_FAVSOUL && GetLevelByClass(CLASS_TYPE_BARD, oPC) >= nLevel)
            return TRUE;
    }
    return FALSE;
}
//------------------------------------------------------------------------------
int mdCRMeetsCustomRequirements(struct gsCRRecipe stRecipe, object oPC, object oPlaceable = OBJECT_SELF)
{
    //How to use
    //stRecipe.sID if you want to filter by ID.
    //FindSubString(stRecipe.sName, [string to search for]) if you want to filter by name
    //stRecipe.sTag if you want to filter by unique recipe tag has the advantage over the above with varied names
    //make sure to the tag ends with _ex if you want the recipe to show up on most fixtures.
    //SendMessageToAllDMs("Custom requirements fired on");
    return TRUE;
}
//------------------------------------------------------------------------------
void _mdAddItemProperties(struct gsCRRecipe stRecipe, object oItem)
{
    ConvertItemToNoStack(oItem);
    //Use SetTag to set the items tag to some standarized tag standard based off of material & item type
    //In case we ever need to retrieve the items later.
    //How to use
    //stRecipe.sID if you want to filter by ID.
    //FindSubString(stRecipe.sName, [string to search for]) if you want to filter by name
    //stRecipe.sTag if you want to filter by unique recipe tag has the advantage over the above with varied names
    //make sure to the tag ends with _ex if you want the recipe to show up on most fixtures.
    //may have to further filter by item type
    //SendMessageToAllDMs("Add item properties fired on" + GetName(oItem));
    return;
}
//]--


int gvd_CRRepairFixture(object oFixture, object oPC, int nValue = 1) {

    int nSkill                      = GetLocalInt(oFixture, "GS_SKILL");
    string sRecipe                  = gvd_CRGetRecipeForResRef(GetLocalString(oFixture, "GVD_REMAINS_RESREF_ITEM"));
    struct gsCRRecipe stRecipe      = gsCRGetRecipeByID(nSkill, sRecipe);
    int nItemRepairDC               = gsCRGetRecipeDC(stRecipe);
    int nCraftPoints                = gsCRGetCraftPoints(oPC);
    int iFixtureRequiredCraftPoints = gsCRGetRecipeCraftPoints(stRecipe);
    int iFixtureCurrentCraftPoints  = StringToInt(GetLocalString(oFixture, "GVD_REMAINS_CRAFTPOINTS"));
    int nFlag                       = FALSE;
    int nNth                        = 0;

    // maximize the needed repair craft points to 25
    if (iFixtureRequiredCraftPoints > 25) {
      iFixtureRequiredCraftPoints = 25;
    }
    // maximize repair dc to 10
    if (nItemRepairDC > 10) {
      nItemRepairDC = 10;
    }

    if (nValue < 1 || nValue > nCraftPoints) nValue = nCraftPoints;

    for (; nNth < nValue; nNth++)
    {
        //check skill
        if (gsCRGetIsSkillSuccessful(nSkill, nItemRepairDC, oPC))
        {
            iFixtureCurrentCraftPoints = iFixtureCurrentCraftPoints + 1;

            //complete repair
            if (iFixtureCurrentCraftPoints >= iFixtureRequiredCraftPoints)
            {
                gsCRDecreaseCraftPoints(nNth + 1, oPC);
                gvd_CRRestoreFixture(oFixture, oPC);
                FloatingTextStringOnCreature("You succesfully restored this fixture", oPC, FALSE);
                return 2;
            }

            nFlag = TRUE; //progress
        }
    }

    gsCRDecreaseCraftPoints(nNth, oPC);

    if (nFlag) {
      // progress
      gsFXSetLocalString(oFixture, "GVD_REMAINS_CRAFTPOINTS", IntToString(iFixtureCurrentCraftPoints));
      FloatingTextStringOnCreature("You succesfully restored part of this fixture", oPC, FALSE);
      return 1;
    } else {
      // no progress
      FloatingTextStringOnCreature("You failed to restore this fixture", oPC, FALSE);
      return 0;
    }

}

void gvd_CRRestoreFixture(object oRemains, object oPC) {

  // grab all the data from oRemains and then destroy it
  string sTag = GetLocalString(oRemains, "GVD_REMAINS_TAG");
  string sResRef = GetLocalString(oRemains, "GVD_REMAINS_RESREF");
  string sResRefItem = GetLocalString(oRemains, "GVD_REMAINS_RESREF_ITEM");
  string sName = GetLocalString(oRemains, "GVD_REMAINS_NAME");
  string sDescription = GetLocalString(oRemains, "GVD_REMAINS_DESCRIPTION");
  location lLocation = GetLocation(oRemains);

  object oFixture = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocation, FALSE, sTag);

  if (oFixture != OBJECT_INVALID) {

    WriteTimestampedLogEntry("FIXTURE REPAIR: Recreating object with tag: " + sTag + " in area " + GetTag(GetArea(oRemains)));

    // delete the remains from the database before we save the recreated fixture, so it won't block the saving proces
    gsFXDeleteFixture(GetTag(GetArea(oRemains)));

    SetName(oFixture, sName);
    SetDescription(oFixture, sDescription);

    // Change owner.
    gsIPSetOwner(oFixture, oPC);

    if (!gsFXSaveFixture(GetTag(GetArea(oFixture)), oFixture)) {
      SendMessageToPC(oPC, "Fixture object not saved! Max 60 per area.");
      Log(FIXTURES, "Fixture " + GetName(oFixture) + " was placed in area " + GetName(GetArea(oFixture)) + " by " + GetName(oPC) + ", but could not be saved.");
    } else {
      Log(FIXTURES, "Fixture " + GetName(oFixture) + " was placed in area " + GetName(GetArea(oFixture)) + " by " + GetName(oPC) + ".");

      // Migrate variables.
      string sVarName = GetFirstStringElement("VAR_LIST", oRemains);

      while (sVarName != "") {
        // skip the variables that are no longer relevant
        if (GetStringLeft(sVarName, 11) != "GVD_REMAINS") {
          gsFXSetLocalString(oFixture, sVarName, GetLocalString(oRemains, sVarName));
          AddStringElement(sVarName, "VAR_LIST", oFixture);
        }
        sVarName = GetNextStringElement();
      }

    }

    // destroy remains
    DestroyObject(oRemains);

  } else {

    WriteTimestampedLogEntry("FIXTURE REPAIR: Failed to recreate object with tag: " + sTag + " in area " + GetTag(GetArea(oRemains)));

  }

}

string gvd_CRGetRecipeForResRef(string sResRef) {

    // in case of messageboards, there is an additional __number behind the resref, that needs to be removed to be able to find the recipe
    int __index = FindSubString(sResRef, "__");
    if (__index > 0)
    {
      sResRef = GetStringLeft(sResRef, __index);
    }

    SQLExecStatement("SELECT Recipe_ID FROM md_cr_output WHERE Resref=? LIMIT 1", sResRef);

    if (SQLFetch()) {
      return SQLGetData(1);
    } else {
      return "";
    }
}

/* craftpoints required for fixtures are so low, this is pretty useless, leaving the code for any future use though
int gvd_CRGetRemainsCraftPoints(struct gsCRRecipe stRecipe, object oRemains) {

  // first get the regular craft points for stRecipe
  int iCraftPoints = gsCRGetRecipeCraftPoints(stRecipe);

  // check if we're indeed calculating for an remains object, and not something else
  if (GetLocalString(oRemains, "GVD_REMAINS_STATUS") != "") {

    // adjust required craftpoints based on the age of the remains, 10% more needed for each RL day it's around, after 10 RL days it will be auto-destroyed on server load
    int iRemainsTimestamp = GetLocalInt(oRemains, "GVD_REMAINS_TIMESTAMP");
    int iTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    iCraftPoints = FloatToInt(iCraftPoints * (100 + ((gsTIGetRealTimestamp(iTimestamp) - gsTIGetRealTimestamp(iRemainsTimestamp)) / 8640.0)) / 100);

  }

  return iCraftPoints;
}
*/
int md_ConvertToCategory(int nNth)
{
    _gsCRGetSkillCache();
    if(!GetLocalInt(oCraftCache, "MD_USING_CAT_TABLE"))
    {
        return nNth;
    }
    return GetLocalInt(oCraftCache, "GS_CR_CATEGORY_"+IntToString(nNth)+"_ID");
}


