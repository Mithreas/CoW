//::///////////////////////////////////////////////
//:: Actuvate Item Script
//:: NW_S3_ActItem01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This fires the event on the module that allows
    for items to have special powers.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2001
//:: Updated by Mithreas 25.03.07 to add DMFI.
//:://////////////////////////////////////////////

void main()
{
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    location lLocal = GetSpellTargetLocation();

    if (GetStringLeft(GetTag(oItem), 5) == "dmfi_" ||
    GetStringLeft(GetTag(oItem), 8) == "hlslang_")
    {
        SetLocalObject(OBJECT_SELF, "dmfi_item", oItem);
        SetLocalObject(OBJECT_SELF, "dmfi_target", oTarget);
        SetLocalLocation(OBJECT_SELF, "dmfi_location", lLocal);
        ExecuteScript("dmfi_activate", OBJECT_SELF);
        return;
    }
    else if (GetStringLeft(GetTag(oItem), 4) == "obj_")
    {
      ExecuteScript(GetTag(oItem), OBJECT_SELF);
      return;
    }
    SignalEvent(GetModule(), EventActivateItem(oItem, lLocal, oTarget));
}
