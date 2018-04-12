#include "zdlg_include_i"
#include "zzdlg_color_inc"
#include "gs_inc_common"
#include "gs_inc_area"
#include "gs_inc_quarter"
#include "gs_inc_iprop"
#include "inc_factions"
#include "inc_divination"
#include "inc_chatutils"
#include "inc_holders"
#include "ar_utils"


//  zz_co_form
//  zz_co_color

const string PAGE_ROOT              = "PAGE_ROOT";
const string PAGE_OPT_ARMOR         = "PAGE_OPT_ARMOR";
const string PAGE_OPT_HELMET        = "PAGE_OPT_HELMET";
const string PAGE_OPT_CLOAK         = "PAGE_OPT_CLOAK";
const string PAGE_OPT_ROBE          = "PAGE_OPT_ROBE";
const string PAGE_ARMOR             = "PAGE_ARMOR";
const string PAGE_COL_ARMOR         = "PAGE_COL_ARMOR";
const string PAGE_CHEST             = "PAGE_CHEST";

const string ROOT_SELECTIONS        = "ROOT_SELECTIONS";
const string ARMOR_OPT_SELECTIONS   = "ARMOR_OPT_SELECTIONS";
const string ARMOR_SELECTIONS       = "ARMOR_SELECTIONS";
const string COLOR_SELECTIONS       = "COLOR_SELECTIONS";
const string CHEST_SELECTIONS       = "CHEST_SELECTIONS";


const string AR_STORE_VAR           = "AR_PERGUARD_";
const string AR_STORED_PART         = "AR_STORED_PART";
const string AR_PREV_PAGE           = "AR_PREV_PAGE";
const string txtSelection           = "<c þ >";




void ArmorInit();
void onArmorSelection(int nSelection);

//::-------------------------------------
//::  Internal
//::-------------------------------------
int _getMirroredPart(int nIndex);
void onStoreVars(int nInventorySlot, int nType, int nIndex, int nTable);
void onArmorVars(int nIndex);

void SavePermanent();
void CopyToGuard(object oSource, object oTarget);

void MD_ModifyItem(int nNth, object oItem, int nIndex, int nInventorySlot, object oTarget, int nTableID, int nType);
void MD_ChangeColor(object oTarget, int nPart, int nID, int nSel);
int MD_GetIndividualPieceValue(int nIndex, object oItem);


void Init()
{
    object oPC = GetPcDlgSpeaker();
    SetDlgPageString(PAGE_ROOT);

    object oQuarter   = GetArea(OBJECT_SELF);
    int bOwner        = gsQUGetIsOwner(oQuarter, oPC);
    int bAccess       = gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) || md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2");


    if ( !bOwner && !GetIsDM(oPC) )  {
        SetDlgPrompt(txtSilver + "The guard gives a firm nod.</c>");
        return;
    }


    //::  ROOT
    RemoveElements(0, GetElementCount(ROOT_SELECTIONS), ROOT_SELECTIONS, OBJECT_SELF);
    if (GetElementCount(ROOT_SELECTIONS) == 0) {
        AddStringElement(txtSelection + "[Edit Armor]", ROOT_SELECTIONS);
        AddStringElement(txtSelection + "[Edit Helmet]", ROOT_SELECTIONS);
        AddStringElement(txtSelection + "[Edit Cloak]", ROOT_SELECTIONS);
        AddStringElement(txtSelection + "[Edit Robe]", ROOT_SELECTIONS);
        AddStringElement("<c€ €>[Apply Changes]</c>", ROOT_SELECTIONS);
        AddStringElement(txtRed + "[Leave]</c>", ROOT_SELECTIONS);
    }

    //::  ARMOR
    RemoveElements(0, GetElementCount(ARMOR_OPT_SELECTIONS), ARMOR_OPT_SELECTIONS, OBJECT_SELF);
    if (GetElementCount(ARMOR_OPT_SELECTIONS) == 0) {
        AddStringElement(txtSelection + "[Appearance]", ARMOR_OPT_SELECTIONS);
        AddStringElement(txtSelection + "[Color]", ARMOR_OPT_SELECTIONS);
        AddStringElement(txtRed + "[Back]</c>", ARMOR_OPT_SELECTIONS);
    }

    RemoveElements(0, GetElementCount(ARMOR_SELECTIONS), ARMOR_SELECTIONS, OBJECT_SELF);
    if (GetElementCount(ARMOR_SELECTIONS) == 0) {
        AddStringElement(txtSelection + "Torso", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Shoulders", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Biceps", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Forearms", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Hands", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Belt", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Pelvis", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Thighs", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Shins", ARMOR_SELECTIONS);
        AddStringElement(txtSelection + "Feet", ARMOR_SELECTIONS);
        AddStringElement(txtRed + "[Back]</c>", ARMOR_SELECTIONS);
    }

    //::  COLOR
    RemoveElements(0, GetElementCount(COLOR_SELECTIONS), COLOR_SELECTIONS, OBJECT_SELF);
    if (GetElementCount(COLOR_SELECTIONS) == 0) {
        AddStringElement(txtSelection + "Cloth 1", COLOR_SELECTIONS);
        AddStringElement(txtSelection + "Cloth 2", COLOR_SELECTIONS);
        AddStringElement(txtSelection + "Leather 1", COLOR_SELECTIONS);
        AddStringElement(txtSelection + "Leather 2", COLOR_SELECTIONS);
        AddStringElement(txtSelection + "Metal 1", COLOR_SELECTIONS);
        AddStringElement(txtSelection + "Metal 2", COLOR_SELECTIONS);
        AddStringElement(txtRed + "[Back]</c>", COLOR_SELECTIONS);
    }
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage = GetDlgPageString();
    object oPC   = GetPcDlgSpeaker();

    object oQuarter   = GetArea(OBJECT_SELF);
    int bOwner        = gsQUGetIsOwner(oQuarter, oPC);
    int bAccess       = gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) || md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2");
    string sName      = GetName(oPC, TRUE);


    if ( !bOwner && !GetIsDM(oPC) )  return;

    //:: Display Conversation
    //::  Root
    if (sPage == PAGE_ROOT) {
        string sPrompt = txtSilver + "You can edit Guard appearance from here. Changes will affect all guards in this Quarter Area.</c>\n\n" +
                                     "Select <c€ €>Apply Changes</c> to permanently save the appearance and update guards.";

        PlayAnimation(ANIMATION_FIREFORGET_SALUTE);
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ROOT_SELECTIONS);
    }
    //::  Armor Options
    else if (sPage == PAGE_OPT_ARMOR) {
        string sPrompt = txtSilver + "Armor Options</c>";
        SetLocalString(OBJECT_SELF, AR_PREV_PAGE, PAGE_OPT_ARMOR);
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ARMOR_OPT_SELECTIONS);
    }
    //::  Helmet Options
    else if (sPage == PAGE_OPT_HELMET) {
        onStoreVars(INVENTORY_SLOT_HEAD, ITEM_APPR_TYPE_SIMPLE_MODEL, -2, gsIPGetTableID("helmetmodel"));
        string sPrompt = txtSilver + "Helmet Options</c>";
        SetLocalString(OBJECT_SELF, AR_PREV_PAGE, PAGE_OPT_HELMET);
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ARMOR_OPT_SELECTIONS);
    }
    //::  Cloak Options
    else if (sPage == PAGE_OPT_CLOAK) {
        onStoreVars(INVENTORY_SLOT_CLOAK, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, gsIPGetTableID("cloakmodel"));
        string sPrompt = txtSilver + "Cloak Options</c>";
        SetLocalString(OBJECT_SELF, AR_PREV_PAGE, PAGE_OPT_CLOAK);
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ARMOR_OPT_SELECTIONS);
    }
    //::  Robe Options
    else if (sPage == PAGE_OPT_ROBE) {
        onArmorVars(ITEM_APPR_ARMOR_MODEL_ROBE);
        string sPrompt = txtSilver + "Robe Options</c>";
        SetLocalString(OBJECT_SELF, AR_PREV_PAGE, PAGE_OPT_ROBE);
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ARMOR_OPT_SELECTIONS);
    }
    //::  Armor
    else if (sPage == PAGE_ARMOR) {
        string sPrompt = txtSilver + "Edit Armor Appearance</c>";
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(ARMOR_SELECTIONS);
    }
    //::  Edit Armor Color
    else if (sPage == PAGE_COL_ARMOR) {
        string sPrompt = txtSilver + "Edit Armor Color</c>\n\n<c€ €>Speak the Number you wish to Apply first!</c>";
        SetDlgPrompt(sPrompt);
        SetDlgResponseList(COLOR_SELECTIONS);
    }
    //::  Edit Armor
    else if (sPage == PAGE_CHEST) {
        ArmorInit();
        SetDlgResponseList(CHEST_SELECTIONS);
    }
    else {
        SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
    }
}

void HandleSelection()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    int nSelection  = GetDlgSelection();
    object oPC      = GetPcDlgSpeaker();

    object oQuarter   = GetArea(OBJECT_SELF);
    int bOwner        = gsQUGetIsOwner(oQuarter, oPC);
    int bAccess       = gvd_IsItemPossessedBy(oPC, gsQUGetKeyTag(oQuarter)) || md_GetHasPowerShop(MD_PR2_KEY, oPC, md_SHLoadFacID(oQuarter), "2");
    string sName      = GetName(oPC, TRUE);


    if ( !bOwner && !GetIsDM(oPC) )  return;


    //::  Root
    if (sPage == PAGE_ROOT) {
        switch (nSelection)
        {
            //::  Armor Options
            case 0:
                SetDlgPageString(PAGE_OPT_ARMOR);
                break;
            //::  Helmet Options
            case 1:
                SetDlgPageString(PAGE_OPT_HELMET);
                break;
            //::  Cloak Options
            case 2:
                SetDlgPageString(PAGE_OPT_CLOAK);
                break;
            //::  Robe Options
            case 3:
                SetDlgPageString(PAGE_OPT_ROBE);
                break;
            //::  Apply Permanently
            case 4:
                SavePermanent();
                break;
            case 5:
                EndDlg();
                break;
        }
    }
    //::  Armor Options
    else if (sPage == PAGE_OPT_ARMOR) {
        switch (nSelection)
        {
            //::  Appearance
            case 0:
                SetDlgPageString(PAGE_ARMOR);
                break;
           //::  Color
           case 1:
                SetLocalInt(OBJECT_SELF, AR_STORED_PART, INVENTORY_SLOT_CHEST);
                SetDlgPageString(PAGE_COL_ARMOR);
                break;
           //::  Back
           case 2:
                SetDlgPageString(PAGE_ROOT);
                break;
        }
    }
    //::  Helmet Options
    else if (sPage == PAGE_OPT_HELMET) {
        switch (nSelection)
        {
            //::  Appearance
            case 0:
                SetDlgPageString(PAGE_CHEST);
                break;
           //::  Color
           case 1:
                SetLocalInt(OBJECT_SELF, AR_STORED_PART, INVENTORY_SLOT_HEAD);
                SetDlgPageString(PAGE_COL_ARMOR);
                break;
           //::  Back
           case 2:
                SetDlgPageString(PAGE_ROOT);
                break;
        }
    }
    //::  Cloak Options
    else if (sPage == PAGE_OPT_CLOAK) {
        switch (nSelection)
        {
            //::  Appearance
            case 0:
                SetDlgPageString(PAGE_CHEST);
                break;
           //::  Color
           case 1:
                SetLocalInt(OBJECT_SELF, AR_STORED_PART, INVENTORY_SLOT_CLOAK);
                SetDlgPageString(PAGE_COL_ARMOR);
                break;
           //::  Back
           case 2:
                SetDlgPageString(PAGE_ROOT);
                break;
        }
    }
    //::  Robe Options
    else if (sPage == PAGE_OPT_ROBE) {
        switch (nSelection)
        {
            //::  Appearance
            case 0:
                SetDlgPageString(PAGE_CHEST);
                break;
           //::  Color
           case 1:
                SetLocalInt(OBJECT_SELF, AR_STORED_PART, INVENTORY_SLOT_CHEST);
                SetDlgPageString(PAGE_COL_ARMOR);
                break;
           //::  Back
           case 2:
                SetDlgPageString(PAGE_ROOT);
                break;
        }
    }
    //::  Armor (In-depth)
    else if (sPage == PAGE_ARMOR) {
        //::  BACK used
        if (nSelection == 10) {
            SetDlgPageString(PAGE_OPT_ARMOR);
            return;
        }

        int nIndex = ITEM_APPR_ARMOR_MODEL_TORSO;
        switch (nSelection)
        {
            //::  Torso
            case 0:
                nIndex = ITEM_APPR_ARMOR_MODEL_TORSO;
                break;
            //::  Shoulders
            case 1:
                nIndex = ITEM_APPR_ARMOR_MODEL_LSHOULDER;
                break;
            //::  Biceps
            case 2:
                nIndex = ITEM_APPR_ARMOR_MODEL_LBICEP;
                break;;
            //::  Forearms
            case 3:
                nIndex = ITEM_APPR_ARMOR_MODEL_LFOREARM;
                break;
            //::  Hands
            case 4:
                nIndex = ITEM_APPR_ARMOR_MODEL_LHAND;
                break;
            //::  Belt
            case 5:
                nIndex = ITEM_APPR_ARMOR_MODEL_BELT;
                break;
            //::  Pelvis
            case 6:
                nIndex = ITEM_APPR_ARMOR_MODEL_PELVIS;
                break;
            //::  Thighs
            case 7:
                nIndex = ITEM_APPR_ARMOR_MODEL_LTHIGH;
                break;
            //::  Shins
            case 8:
                nIndex = ITEM_APPR_ARMOR_MODEL_LSHIN;
                break;
            //::  Feet
            case 9:
                nIndex = ITEM_APPR_ARMOR_MODEL_LFOOT;
                break;
        }

        onArmorVars(nIndex);
        SetDlgPageString(PAGE_CHEST);
    }
    //::  EDIT COLOR
    else if (sPage == PAGE_COL_ARMOR) {
        if (nSelection == 6) {  //::  BACK
            SetDlgPageString(GetLocalString(OBJECT_SELF, AR_PREV_PAGE));
            return;
        }

        int nPart = GetLocalInt(OBJECT_SELF, AR_STORED_PART);
        int nCol  = StringToInt(chatGetLastMessage(oPC));
        if (nCol < 0)   nCol = 0;
        if (nCol > 175) nCol = 175;

        switch (nSelection)
        {
            //::  Cloth
            case 0:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_CLOTH1, nCol);
                break;
            case 1:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_CLOTH2, nCol);
                break;
            //::  Leather
            case 2:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_LEATHER1, nCol);
                break;
            case 3:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_LEATHER2, nCol);
                break;
            //::  Metal
            case 4:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_METAL1, nCol);
                break;
            case 5:
                MD_ChangeColor(OBJECT_SELF, nPart, ITEM_APPR_ARMOR_COLOR_METAL2, nCol);
                break;
        }
    }
    //::  EDIT ARMOR / HELMET / CLOAK / ROBE
    else if (sPage == PAGE_CHEST) {
        onArmorSelection(GetDlgSelection());
    }

}

void main()
{
    // Don't you dare!!
    int nEvent = GetDlgEventType();
    switch (nEvent)
    {
        case DLG_INIT:
            Init();
            break;

        case DLG_PAGE_INIT:
            PageInit();
            break;

        case DLG_SELECTION:
            HandleSelection();
            break;

        case DLG_ABORT:
        case DLG_END:
            break;
    }
}

void ArmorInit()
{
  object oTarget     = OBJECT_SELF;
  int nIndex         = GetLocalInt(OBJECT_SELF, "AR_INDEX");
  int nInventorySlot = GetLocalInt(OBJECT_SELF, "AR_INVENTORY_SLOT");
  object oItem       = GetItemInSlot(nInventorySlot, oTarget);
  int nTableID       = GetLocalInt(OBJECT_SELF, "AR_TABLE_ID");
  int nType          = GetLocalInt(OBJECT_SELF, "AR_TYPE");
  int nLimit         = gsIPGetCount(nTableID);
  int nNth           = 0;
  int nLMod          = 0;  //stores  the last model
  string sCurApr     = "Does not currently have the item equipped.";

  //The last model also happens to be the current model when the menu is first accessed
  //and when next and previous page is used.
  int nModelNum = GetItemAppearance(oItem, nType, nIndex); //keep the current appearance
  RemoveElements(0, GetElementCount(CHEST_SELECTIONS), CHEST_SELECTIONS, OBJECT_SELF);

  if(GetIsObjectValid(oItem))
  {
    for(; nNth < nLimit; nNth++)
    {
        //This sets the dialog value, if it's not the torso piece OR it's the torso piece of the same AC value
        //if((nIndex != ITEM_APPR_ARMOR_MODEL_TORSO || gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) == gsIPGetValue(nTableID, nNth, "AC")))
            AddStringElement("Form_" + IntToString(nNth), CHEST_SELECTIONS);

        //Get the table value that matches the model value
        if(gsIPGetValue(nTableID, nNth, "ID") == nModelNum)
            nLMod = nNth;
    }
    sCurApr = "Last Appearance: " + IntToString(nLMod) + "\n" + txtBlue + "[Select Form]</c>";
  }

  SetDlgPrompt(sCurApr);
}

void onArmorSelection(int nSelection)
{
  object oPC         = GetPcDlgSpeaker();
  object oTarget     = OBJECT_SELF;
  int nIndex         = GetLocalInt(OBJECT_SELF, "AR_INDEX");
  int nInventorySlot = GetLocalInt(OBJECT_SELF, "AR_INVENTORY_SLOT");
  int nType          = GetLocalInt(OBJECT_SELF, "AR_TYPE");
  int nTableID       = GetLocalInt(OBJECT_SELF, "AR_TABLE_ID");
  object oItem       = GetItemInSlot(nInventorySlot, oTarget);

  if (GetIsObjectValid(oItem))
  {
    // Item isn't a torso, the usual method for selection works
    if (nIndex != ITEM_APPR_ARMOR_MODEL_TORSO) {
        MD_ModifyItem(nSelection, oItem, nIndex, nInventorySlot, oTarget, nTableID, nType);
        return;
    }

    // Get nNth this way if torso. "Form_" Number start at 5
    string sName = GetDlgResponse(nSelection, oPC);
    int nNth = StringToInt(GetSubString(sName, 5, GetStringLength(sName) - 5));
    //if(gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, nType, nIndex)) == gsIPGetValue(nTableID, nNth, "AC"))
    //{
      MD_ModifyItem(nNth, oItem, nIndex, nInventorySlot, oTarget, nTableID, nType);
    //}
  }
}

void onStoreVars(int nInventorySlot, int nType, int nIndex, int nTable) {
  SetLocalInt(OBJECT_SELF, "AR_TABLE_ID", nTable);
  SetLocalInt(OBJECT_SELF, "AR_INVENTORY_SLOT", nInventorySlot);
  SetLocalInt(OBJECT_SELF, "AR_TYPE", nType);
  SetLocalInt(OBJECT_SELF, "AR_INDEX", nIndex);
}

void onArmorVars(int nIndex) {
    onStoreVars(INVENTORY_SLOT_CHEST, ITEM_APPR_TYPE_ARMOR_MODEL, nIndex, gsIPGetAppearanceTableID(nIndex));
}

void SavePermanent() {
    string sVar  = AR_STORE_VAR;
    object oSelf = OBJECT_SELF;
    object oArea = GetArea(OBJECT_SELF);

    if ( !GetIsAreaInterior(oArea) )    return; //::  Weak

    //::  Armor
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oSelf);
    if ( GetIsObjectValid(oItem) ) {

        //::  To flag a save has been done but also remove local storage
        gvd_SetAreaInt(oArea, sVar + "PER", TRUE);
        DeleteLocalInt(oArea, sVar + "PER");

        gvd_SetAreaInt(oArea, sVar + "T", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_TORSO, oItem));
        gvd_SetAreaInt(oArea, sVar + "B", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_BELT, oItem));
        gvd_SetAreaInt(oArea, sVar + "P", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_PELVIS, oItem));
        gvd_SetAreaInt(oArea, sVar + "R", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_ROBE, oItem));
        gvd_SetAreaInt(oArea, sVar + "RT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RTHIGH, oItem));
        gvd_SetAreaInt(oArea, sVar + "LT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LTHIGH, oItem));
        gvd_SetAreaInt(oArea, sVar + "RS", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHIN, oItem));
        gvd_SetAreaInt(oArea, sVar + "LS", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHIN, oItem));
        gvd_SetAreaInt(oArea, sVar + "RFT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOOT, oItem));
        gvd_SetAreaInt(oArea, sVar + "LFT", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOOT, oItem));
        gvd_SetAreaInt(oArea, sVar + "RSO", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RSHOULDER, oItem));
        gvd_SetAreaInt(oArea, sVar + "LSO", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LSHOULDER, oItem));
        gvd_SetAreaInt(oArea, sVar + "RB", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RBICEP, oItem));
        gvd_SetAreaInt(oArea, sVar + "LB", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LBICEP, oItem));
        gvd_SetAreaInt(oArea, sVar + "RF", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RFOREARM, oItem));
        gvd_SetAreaInt(oArea, sVar + "LF", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LFOREARM, oItem));
        gvd_SetAreaInt(oArea, sVar + "RH", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_RHAND, oItem));
        gvd_SetAreaInt(oArea, sVar + "LH", MD_GetIndividualPieceValue(ITEM_APPR_ARMOR_MODEL_LHAND, oItem));
        gvd_SetAreaInt(oArea, sVar + "C1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1));
        gvd_SetAreaInt(oArea, sVar + "C2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2));
        gvd_SetAreaInt(oArea, sVar + "L1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1));
        gvd_SetAreaInt(oArea, sVar + "L2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2));
        gvd_SetAreaInt(oArea, sVar + "M1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1));
        gvd_SetAreaInt(oArea, sVar + "M2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2));
    }

    //::  Helmet
    oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oSelf);
    if ( GetIsObjectValid(oItem) ) {
        gvd_SetAreaInt(oArea, sVar + "H", GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -2));
        gvd_SetAreaInt(oArea, sVar + "HC1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1));
        gvd_SetAreaInt(oArea, sVar + "HC2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2));
        gvd_SetAreaInt(oArea, sVar + "HL1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1));
        gvd_SetAreaInt(oArea, sVar + "HL2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2));
        gvd_SetAreaInt(oArea, sVar + "HM1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1));
        gvd_SetAreaInt(oArea, sVar + "HM2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2));
    }

    //::  Cloak
    oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oSelf);
    if ( GetIsObjectValid(oItem) ) {
        gvd_SetAreaInt(oArea, sVar + "C", GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1));
        gvd_SetAreaInt(oArea, sVar + "CC1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1));
        gvd_SetAreaInt(oArea, sVar + "CC2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2));
        gvd_SetAreaInt(oArea, sVar + "CL1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1));
        gvd_SetAreaInt(oArea, sVar + "CL2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2));
        gvd_SetAreaInt(oArea, sVar + "CM1", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1));
        gvd_SetAreaInt(oArea, sVar + "CM2", GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2));
    }


    //::  Apply to Guards in this Area
    object oGuard = GetFirstObjectInArea(oArea);
    while ( GetIsObjectValid(oGuard) ) {

        string sTag = GetTag(oGuard);
        if ( oGuard != oSelf && !GetIsPC(oGuard) && FindSubString(sTag, "AR_GUARD") != -1 ) {
            CopyToGuard(oSelf, oGuard);
        }

        oGuard = GetNextObjectInArea(oArea);
    }
}

void CopyToGuard(object oSource, object oTarget) {
    //::  Armor
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oSource);
    object oSelfItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    if ( GetIsObjectValid(oItem) && GetIsObjectValid(oSelfItem) ) {
        object oArmor = CopyItem(oItem, oTarget);

        if (GetIsObjectValid(oArmor)) {
            SetDroppableFlag(oArmor, FALSE);
            AssignCommand(oTarget, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
            DestroyObject(oSelfItem);
        }
    }

    //::  Helmet
    oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oSource);
    oSelfItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget);
    if ( GetIsObjectValid(oItem) && GetIsObjectValid(oSelfItem) ) {
        object oHelmet = CopyItem(oItem, oTarget);

        if (GetIsObjectValid(oHelmet)) {
            SetDroppableFlag(oHelmet, FALSE);
            AssignCommand(oTarget, ActionEquipItem(oHelmet, INVENTORY_SLOT_HEAD));
            DestroyObject(oSelfItem);
        }
    }

    //::  Cloak
    oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oSource);
    oSelfItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oTarget);
    if ( GetIsObjectValid(oItem) && GetIsObjectValid(oSelfItem) ) {
        object oCloak = CopyItem(oItem, oTarget);

        if (GetIsObjectValid(oCloak)) {
            SetDroppableFlag(oCloak, FALSE);
            AssignCommand(oTarget, ActionEquipItem(oCloak, INVENTORY_SLOT_CLOAK));
            DestroyObject(oSelfItem);
        }
    }
}



int _getMirroredPart(int nIndex) {

    if      ( nIndex == ITEM_APPR_ARMOR_MODEL_LBICEP )      return ITEM_APPR_ARMOR_MODEL_RBICEP;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LFOOT )       return ITEM_APPR_ARMOR_MODEL_RFOOT;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LFOREARM )    return ITEM_APPR_ARMOR_MODEL_RFOREARM;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LHAND )       return ITEM_APPR_ARMOR_MODEL_RHAND;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LSHIN )       return ITEM_APPR_ARMOR_MODEL_RSHIN;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LSHOULDER )   return ITEM_APPR_ARMOR_MODEL_RSHOULDER;
    else if ( nIndex == ITEM_APPR_ARMOR_MODEL_LTHIGH )      return ITEM_APPR_ARMOR_MODEL_RTHIGH;

    return -1;
}

//::  MORDERON FUNCS
void MD_ModifyItem(int nNth, object oItem, int nIndex, int nInventorySlot, object oTarget, int nTableID, int nType)
{
  int nValue       = gsIPGetValue(nTableID, nNth, "ID");
  object oCopy     = gsCMCopyItemAndModify(oItem, nType, nIndex, nValue, TRUE);
  object oMirrored = OBJECT_INVALID;

  //::  Mirror Modification
  if ( GetIsObjectValid(oCopy) ) {
      int nMirror = _getMirroredPart(nIndex);
      if ( nMirror != -1 ) {
        nTableID    = gsIPGetAppearanceTableID(nMirror);
        nValue      = gsIPGetValue(nTableID, nNth, "ID");
        oMirrored   = gsCMCopyItemAndModify(oCopy, nType, nMirror, nValue, TRUE);
        DestroyObject(oCopy);
      }
  }

  object oToEquip = GetIsObjectValid(oMirrored) ? oMirrored : oCopy;
  if ( GetIsObjectValid(oToEquip) )
  {
    AssignCommand(oTarget, ActionEquipItem(oToEquip, nInventorySlot));
    DestroyObject(oItem);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL), oTarget, 0.25);
  }
}

void MD_ChangeColor(object oTarget, int nPart, int nID, int nSel)
{
  object oItem = GetItemInSlot(nPart, oTarget);
  object oCopy;
  if (GetIsObjectValid(oItem))
  {
    oCopy = gsCMCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nID, nSel, TRUE);

    if (GetIsObjectValid(oCopy))
    {
      AssignCommand(oTarget, ActionEquipItem(oCopy, nPart));
      DestroyObject(oItem);
    }
  }
}

int MD_GetIndividualPieceValue(int nIndex, object oItem)
{
  int nNth;
  int nTableID = gsIPGetAppearanceTableID(nIndex);
  int nModelNum = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nIndex);
  int nLimit = gsIPGetCount(nTableID);
  for(nNth = 0; nNth < nLimit; nNth++)
  {
    //Get the table value that matches the model value
    if(gsIPGetValue(nTableID, nNth, "ID") == nModelNum)
      return nNth;
  }

  return -1;
}

