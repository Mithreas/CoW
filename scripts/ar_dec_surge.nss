#include "gs_inc_state"
#include "inc_boon"

void main()
{
    object oPC          = GetPCSpeaker();
    object oHide        = gsPCGetCreatureHide(oPC);
    int isWildMage      = GetLocalInt(oHide, "WILD_MAGE");

    if ( !GetIsPC(oPC) || !isWildMage)    return;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oPC);
    DeleteLocalInt(oPC, "AR_WM_BONUS");

    bnRemoveTimestampedBoonVar(oPC, BOON_WILD_MAGE);
}
