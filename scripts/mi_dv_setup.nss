/*
  Name: mi_dv_setup
  Author: Mithreas
  Description: Sets up a PC's subrace/gender/wings/tail details in the database.
*/
#include "inc_subrace"
void main()
{
  object oPC = OBJECT_SELF;

  string sSubRace;
  int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
  if (nSubRace == GS_SU_NONE)
  {
    sSubRace = gsSUGetRaceName(GetRacialType(oPC));
  }
  else
  {
    sSubRace = gsSUGetNameBySubRace(nSubRace);
  }

  string sGender = (GetGender(oPC) == GENDER_MALE) ? "Male" : "Female";

  int nBoneArm = GetHasFeat(FEAT_UNDEAD_GRAFT_1, oPC);
  int nWings   = GetCreatureWingType(oPC);
  
  int nHairColor = GetColor(oPC, COLOR_CHANNEL_HAIR);
  int nSkinColor = GetColor(oPC, COLOR_CHANNEL_SKIN);

  if (nWings > 6) nWings = 0; // backpacks

  SQLExecStatement("UPDATE gs_pc_data SET subrace=?,gender=?,wings=?,bone_arm=?,hair_color=?,skin_color=? WHERE id=?",
                   sSubRace, sGender, IntToString(nWings), IntToString(nBoneArm), IntToString(nHairColor), IntToString(nSkinColor),
                   gsPCGetPlayerID(oPC));
}
