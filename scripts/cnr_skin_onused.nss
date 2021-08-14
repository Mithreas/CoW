/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_skin_onused
//
//  Desc:  The OnUsed handler for skinnable corpses.
//
//  Author: David Bobeck 18Feb03
//
/////////////////////////////////////////////////////////
#include "cnr_config_inc"
#include "cnr_language_inc"
#include "inc_combat2"

void main()
{
  string sCorpseType = GetLocalString(OBJECT_SELF, "CnrCorpseType");
  location locCorpse = GetLocation(OBJECT_SELF);

  // prevent rapid-clicks from getting multiple skins!
  if (sCorpseType == "") return;

  object oUser = GetLastUsedBy();
  if (!GetIsPC(oUser)) return;

  // Player must have a skinning knife equipped or be in polymorph.
  int bHasKnife = gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oUser, TRUE);
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser);
  if (GetIsObjectValid(oItem))
  {
    if (GetTag(oItem) == "cnrSkinningKnife")
    {
      bHasKnife = TRUE;
    }
  }

  if (bHasKnife == FALSE)
  {
    oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser);
    if (GetIsObjectValid(oItem))
    {
      if (GetTag(oItem) == "cnrSkinningKnife")
      {
        bHasKnife = TRUE;
      }
    }
  }

  if (bHasKnife == FALSE)
  {
    FloatingTextStringOnCreature(CNR_TEXT_YOU_MUST_HOLD_A_SKINNING_KNIFE, oUser, FALSE);
    return;
  }

  DeleteLocalString(OBJECT_SELF, "CnrCorpseType");

  // sCorpseType will have a format of cnraXXXX where XXXX is the animal name
  string sAnimalName = GetStringRight(sCorpseType, GetStringLength(sCorpseType)-4);
  string sSkinTag = "cnrSkin" + sAnimalName;

  int bCreateMeat = TRUE;
  if (sAnimalName == "Rat") bCreateMeat = FALSE;
  if (sAnimalName == "Bat") bCreateMeat = FALSE;
  if (sAnimalName == "Badger") bCreateMeat = FALSE;
  if (sAnimalName == "Dragon") 
  {
    bCreateMeat = FALSE;
	sSkinTag = "dragonhide";
  }  

  if (sSkinTag != "TAG_UNKNOWN")
  {
    object oSkin = CreateObject(OBJECT_TYPE_ITEM, sSkinTag, locCorpse);
    AssignCommand(oUser, ActionPickUpItem(oSkin));
    FloatingTextStringOnCreature(CNR_TEXT_YOU_ACQUIRED_A_SKIN, oUser, FALSE);

    if (bCreateMeat)
    {
      object oMeat;
      if (CNR_BOOL_ENABLE_HCR_ITEM_CRAFTING)
      {
        oMeat = CreateObject(OBJECT_TYPE_ITEM, "it_mmidmisc006", locCorpse);
      }
      else
      {
        oMeat = CreateObject(OBJECT_TYPE_ITEM, "cnranimalmeat", locCorpse);
      }
      AssignCommand(oUser, ActionPickUpItem(oMeat));
      FloatingTextStringOnCreature(CNR_TEXT_YOU_ACQUIRED_SOME_MEAT, oUser, FALSE);
    }

    object oBones = GetLocalObject(OBJECT_SELF, "CnrCorpseBones");
    if (GetIsObjectValid(oBones))
    {
      DeleteLocalObject(OBJECT_SELF, "CnrCorpseBones");
      DestroyObject(oBones);
    }
    DestroyObject(OBJECT_SELF);
  }
}

