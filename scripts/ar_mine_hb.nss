#include "gs_inc_time"
#include "inc_ore_vein"

void UpdateOre() {
    string sResRef = GetResourceTemplate(OBJECT_SELF, TRUE);

    if ( sResRef != "" ) {
        SetName(OBJECT_SELF, "Ore Vein (" + GetNameByOre(sResRef) + ")");
    }
}

void main()
{
    if ( GetLocalInt(OBJECT_SELF, "DO_ONCE") ) {
        return;
    }

    SetLocalInt(OBJECT_SELF, "DO_ONCE", TRUE);
    int nType = GetLocalInt(OBJECT_SELF, "TYPE");
    int nVisualEffectId = VFX_DUR_PETRIFY;

    //::  Set some VFX based on Ore Type
    //::  Common
    if ( nType <= 0 ) {
    }
    //::  Medium / Noble
    else if ( nType == 1 ) {
        nVisualEffectId = VFX_DUR_PETRIFY;
    }
    //::  High / Rich
    else if ( nType == 2 ) {
        nVisualEffectId = VFX_DUR_PROT_GREATER_STONESKIN;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_5), OBJECT_SELF);
    }
    //::  Top-Tier
    else {
        nVisualEffectId = VFX_DUR_PROT_STONESKIN;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_BLUE_5), OBJECT_SELF);
    }

    if ( nType != 0 )
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nVisualEffectId), OBJECT_SELF);

    //::  Update the Ore (We delay this slightly so the persistent variables can be loaded correctly before hand)
    DelayCommand(6.0, UpdateOre());
}
