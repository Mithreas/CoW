/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_skin_ondeath
//
//  Desc:  The OnDeath handler for skinnable animals.
//
//  Author: David Bobeck 18Feb03
//
/////////////////////////////////////////////////////////
#include "cnr_config_inc"

void FadeCorpse()
{
  object oBones = GetLocalObject(OBJECT_SELF, "CnrCorpseBones");
  if (GetIsObjectValid(oBones))
  {
    DeleteLocalObject(OBJECT_SELF, "CnrCorpseBones");
    DestroyObject(oBones);
  }
  DestroyObject(OBJECT_SELF);
}

void main()
{
  ExecuteScript("nw_c2_default7" , OBJECT_SELF);
 
  location locDeath = GetLocation(OBJECT_SELF);
  object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrcorpseskin", locDeath, FALSE);
  object oBones = CreateObject(OBJECT_TYPE_PLACEABLE, "cnrcorpsebones", locDeath, FALSE);
  SetLocalObject(oCorpse, "CnrCorpseBones", oBones);
  SetLocalString(oCorpse, "CnrCorpseType", GetTag(OBJECT_SELF));

  AssignCommand(oCorpse, DelayCommand(CNR_FLOAT_SKINNABLE_CORPSE_FADE_TIME_SECS, FadeCorpse()));
}
