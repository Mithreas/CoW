//::///////////////////////////////////////////////
//:: Name zz_co_color
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The conversation file for primsatic mirrors
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: 12/11/2010
//:://////////////////////////////////////////////

#include "zzdlg_main_inc"
#include "inc_text"
#include "inc_common"
#include "inc_chatutils"
//These hold the responses that aren't going to change
const string STARTER_MENU  = "STARTER_MENU";
const string MATERIAL_MENU = "MATERIAL_MENU";
const string COLOR_MENU    = "COLOR_MENU";
const string ENTNUM_MENU   = "ENTNUM_MENU";


//OnPageInit, these set the dialog prompts
void onColor();
void onMaterial();
void onEntNum();

//onSelection
//Sets the color of the item
void onSColor();
void onSEntNum();

//cleans variables
void Cleanup();

//Adds the "Enter number" response where needed
//nYth is the nNth value one BEFORE it should be added
//Enter a number response should be the last
//before next/previous/done responses
int AddEnterNumRes(int nNth, int nYth);

void OnInit()
{
  dlgClearResponseList(STARTER_MENU);
  dlgAddResponseAction(STARTER_MENU, "All clothing (Helmet, Outfit, Cloak)");
  dlgAddResponseAction(STARTER_MENU, "Helmet only");
  dlgAddResponseAction(STARTER_MENU, "Outfit only");
  dlgAddResponseAction(STARTER_MENU, "Cloak only");
  //below responses only show in the renaming area:
  if(GetLocalInt(GetArea(OBJECT_SELF), "MI_RENAME"))
  {
    dlgAddResponseAction(STARTER_MENU, "Skin");
    dlgAddResponseAction(STARTER_MENU, "Hair");
    dlgAddResponseAction(STARTER_MENU, "Tattoo 1");
    dlgAddResponseAction(STARTER_MENU, "Tattoo 2");
  }

  dlgClearResponseList(MATERIAL_MENU);
  dlgAddResponse(MATERIAL_MENU, "Leather 1");
  dlgAddResponse(MATERIAL_MENU, "Leather 2");
  dlgAddResponse(MATERIAL_MENU, "Cloth 1");
  dlgAddResponse(MATERIAL_MENU, "Cloth 2");
  dlgAddResponse(MATERIAL_MENU, "Metal 1");
  dlgAddResponse(MATERIAL_MENU, "Metal 2");

  dlgClearResponseList(COLOR_MENU);
  int nNth;
  int nYth = 10;
  for(nNth = 0; nNth < 176; nNth++)
  {
    dlgAddResponse(COLOR_MENU, "Color " + IntToString(nNth));
    nYth = AddEnterNumRes(nNth, nYth);
  }
  dlgAddResponseAction(COLOR_MENU, "[Enter a number]");

  dlgClearResponseList(ENTNUM_MENU);
  dlgAddResponseAction(ENTNUM_MENU, "[Select]");

  dlgActivateEndResponse("[Done]", txtBlue);
  dlgChangeLabelNext(DLG_DEFAULTLABEL_NEXT, DLG_DEFAULT_TXT_ACTION_COLOR);
  dlgChangeLabelPrevious(DLG_DEFAULTLABEL_PREV, DLG_DEFAULT_TXT_ACTION_COLOR);

  dlgChangePage(STARTER_MENU);
}
void OnPageInit(string sPage)
{

  // Conversation options
  if(sPage == STARTER_MENU)
    dlgSetPrompt(txtBlue + "[Select material]</c>");
  else
  {
    //Only set up reset response on pages not the first
    dlgActivateResetResponse(DLG_DEFAULTLABEL_RESET, DLG_DEFAULT_TXT_ACTION_COLOR);
    if(sPage == MATERIAL_MENU)
      onMaterial();
    else if(sPage == COLOR_MENU)
    {
      dlgActivatePreservePageNumberOnSelection();
      onColor();
    }
    else //Enter number
    {
      onEntNum();
    }
  }


  dlgSetActiveResponseList(sPage);

}
void OnSelection(string sPage)
{
  int nSel = dlgGetSelectionIndex();
  if(sPage == STARTER_MENU)
  {
    int nID;
    switch(nSel)
    {
    case 0: nID = -1; dlgChangePage(MATERIAL_MENU); break; //all
    case 1: nID = INVENTORY_SLOT_HEAD; dlgChangePage(MATERIAL_MENU); break;
    case 2: nID = INVENTORY_SLOT_CHEST; dlgChangePage(MATERIAL_MENU); break;
    case 3: nID = INVENTORY_SLOT_CLOAK; dlgChangePage(MATERIAL_MENU); break;
    //big offset, to differentirate between body parts and clothing
    default: nID = nSel + 50; dlgChangePage(ENTNUM_MENU);
    }
    dlgSetSpeakeeDataInt("MD_Part", nID);
  }
  else if(sPage == MATERIAL_MENU)
  {
    dlgSetSpeakeeDataString("MD_LPage", sPage);
    //saves the material type, nSel just happens to match up with
    //ITEM_APPR_ARMOR_COLOR_* numbers
    dlgSetSpeakeeDataInt("GS_ID", nSel);
    dlgChangePage(COLOR_MENU);
  }
  else if(sPage == COLOR_MENU)
  {
   // dlgSetSpeakeeDataString("MD_LPage", MATERIAL_MENU);
    onSColor();
  }
  else if(sPage == ENTNUM_MENU)
  {
   //only one option
    onSEntNum();
  }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{
  dlgResetPageNumber();
  string sLPage = dlgGetSpeakeeDataString("MD_LPage");
  if(sLPage == "")
   dlgChangePage(STARTER_MENU);
  else
  {
    dlgChangePage(sLPage);
    dlgClearSpeakeeDataString("MD_LPage");
  }
  dlgDeactivateResetResponse();
}
void OnAbort(string sPage)
{
  Cleanup();
}
void OnEnd(string sPage)
{
  Cleanup();
}
void main()
{
  dlgOnMessage();
}

void Cleanup()
{
  dlgClearResponseList(STARTER_MENU);
  dlgClearResponseList(MATERIAL_MENU);
  dlgClearResponseList(COLOR_MENU);
  dlgClearResponseList(ENTNUM_MENU);
  dlgClearSpeakeeDataInt("GS_ID");
  dlgClearSpeakeeDataInt("MD_Part");
  dlgClearSpeakeeDataString("MD_LPage");
  dlgDeactivateResetResponse();
}
//Now supports body parts
string MD_CurrentColor(int nPart, int nId)
{
  string sPart;
  int nColor;
  if(nPart > 50)
  {
     object oPC = dlgGetSpeakingPC();
     nPart -= 54;
     nColor = GetColor(oPC, nPart);
     if(nPart == COLOR_CHANNEL_TATTOO_1)
       sPart = "tattoo 1";
     else if(nPart == COLOR_CHANNEL_TATTOO_2)
       sPart  = "tattoo 2";
     else if(nPart == COLOR_CHANNEL_HAIR)
       sPart = "hair";
     else if(nPart == COLOR_CHANNEL_SKIN)
       sPart = "skin";
  }
  else
  {
    object oItem = GetItemInSlot(nPart, dlgGetSpeakingPC());
    if(nPart == INVENTORY_SLOT_CHEST)
      sPart = "chest";
    else if(nPart == INVENTORY_SLOT_CLOAK)
      sPart = "cloak";
    else //helmet
      sPart = "helmet";

     nColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nId);
  }
  return "Current " + sPart + " color: " + IntToString(nColor)+"\n";
}
void onColor()
{
  string sPrompt;
  int nId = dlgGetSpeakeeDataInt("GS_ID");
  switch (nId)
  {
   case ITEM_APPR_ARMOR_COLOR_CLOTH1:
        sPrompt =  GS_T_16777241 + " 1\n";
        break;

   case ITEM_APPR_ARMOR_COLOR_CLOTH2:
        sPrompt = GS_T_16777241 + " 2\n";
        break;

   case ITEM_APPR_ARMOR_COLOR_LEATHER1:
        sPrompt =  GS_T_16777242 + " 1\n";
        break;

   case ITEM_APPR_ARMOR_COLOR_LEATHER2:
        sPrompt = GS_T_16777242 + " 2\n";
        break;

   case ITEM_APPR_ARMOR_COLOR_METAL1:
        sPrompt = GS_T_16777243 + " 1\n";
        break;

   case ITEM_APPR_ARMOR_COLOR_METAL2:
        sPrompt = GS_T_16777243 + " 2\n";
        break;
  }
  string sCurColor;
  int nPart = dlgGetSpeakeeDataInt("MD_Part");
  if(nPart == -1)
   sCurColor = MD_CurrentColor(INVENTORY_SLOT_CHEST, nId) +
               MD_CurrentColor(INVENTORY_SLOT_CLOAK, nId) +
               MD_CurrentColor(INVENTORY_SLOT_HEAD, nId);
  else
   sCurColor = MD_CurrentColor(nPart, nId);
  sPrompt += sCurColor + txtBlue + "[Select Color]</c>";

  dlgSetPrompt(sPrompt);
}

void onMaterial()
{
  object oItem;
  int nPart = dlgGetSpeakeeDataInt("MD_Part");
  if(nPart != -1)
    oItem = GetItemInSlot(nPart, dlgGetSpeakingPC());

  if(GetIsObjectValid(oItem) || nPart == -1)
    dlgSetPrompt(txtBlue + "[Select material]</c>");
  else
    dlgSetPrompt("You do not currently have the item equipped");

}

void onEntNum()
{
   string sPrompt = txtBlue + "[Type a number and click select]</c>\n";
   int nPart = dlgGetSpeakeeDataInt("MD_Part");
   int nId = dlgGetSpeakeeDataInt("GS_ID");
   if(nPart == -1)
     sPrompt +=  MD_CurrentColor(INVENTORY_SLOT_CHEST, nId) +
                 MD_CurrentColor(INVENTORY_SLOT_CLOAK, nId) +
                 MD_CurrentColor(INVENTORY_SLOT_HEAD, nId);
   else
     sPrompt += MD_CurrentColor(nPart, nId);
   dlgSetPrompt(sPrompt);
}
int AddEnterNumRes(int nNth, int nYth)
{
  if(nNth == nYth)
  {
    dlgAddResponseAction(COLOR_MENU, "[Enter a number]");
    return nYth += 10;
  }

  return nYth;
}
//helper function for onSColor, changes an items colors
void MD_ChangeColor(int nPart, int nID, int nSel)
{
  object oPC = dlgGetSpeakingPC();
  object oItem = GetItemInSlot(nPart, oPC);
  object oCopy;
  if (GetIsObjectValid(oItem))
  {
    oCopy = gsCMCopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nID, nSel, TRUE);

    if (GetIsObjectValid(oCopy))
    {
      AssignCommand(oPC, ActionEquipItem(oCopy, nPart));
      DestroyObject(oItem);
    }
  }
}
void onSColor()
{
   //Getting it through an index number would be difficult
   //due to Enter  anumber responses.
   string sRes = dlgGetSelectionName();
   if(sRes != "[Enter a number]")
   {
     int nSel = StringToInt(GetSubString(sRes, 6, GetStringLength(sRes)));
     int nPart = dlgGetSpeakeeDataInt("MD_Part");
     int nId = dlgGetSpeakeeDataInt("GS_ID");
     if(nPart == -1)
     {
       MD_ChangeColor(INVENTORY_SLOT_CHEST, nId, nSel);
       MD_ChangeColor(INVENTORY_SLOT_CLOAK, nId, nSel);
       MD_ChangeColor(INVENTORY_SLOT_HEAD, nId, nSel);
     }
     else
       MD_ChangeColor(nPart, nId, nSel);
   }
   else
   {
     dlgDeactivatePreservePageNumberOnSelection();
     dlgChangePage(ENTNUM_MENU);
   }

}

void onSEntNum()
{
  object oPC = dlgGetSpeakingPC();

  int nSel = StringToInt(chatGetLastMessage(oPC));

  int nPart = dlgGetSpeakeeDataInt("MD_Part");
  int nId = dlgGetSpeakeeDataInt("GS_ID");
  if(nPart == -1)
  {
    MD_ChangeColor(INVENTORY_SLOT_CHEST, nId, nSel);
    MD_ChangeColor(INVENTORY_SLOT_CLOAK, nId, nSel);
    MD_ChangeColor(INVENTORY_SLOT_HEAD, nId, nSel);
  }
  else
  {
    if(nPart > 50)
      SetColor(oPC, nPart - 54, nSel);
    else
      MD_ChangeColor(nPart, nId, nSel);
  }

}
