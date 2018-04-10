#include "nw_i0_plot"
#include "zzdlg_color_inc"

const string TREASURE_RESREF = "TreasureResRef";

void main() {
    object oPC   = GetLastUsedBy();
    object oArea = GetArea(OBJECT_SELF);

    if (!GetIsPC(oPC) || !GetIsDM(oPC))  return;

    location lLoc   = GetLocation(OBJECT_SELF);
    string sResRef  = GetLocalString(OBJECT_SELF, TREASURE_RESREF);

    //::  Dig Treasure
    if (HasItem(oPC, "c_shovel") == TRUE && sResRef != "") {
        object oTreasure = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc);
        SetLocalInt(oTreasure, "GS_DISABLED", TRUE);    //::  Can't respawn!

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lLoc);
        FloatingTextStringOnCreature(txtGreen + "*You've found something while digging*</c>", oPC);
        DestroyObject(OBJECT_SELF);
    }
    else {
        SendMessageToPC(oPC, txtRed + "You need a spade to dig here.</c>");
    }
}
