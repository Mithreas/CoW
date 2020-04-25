//::///////////////////////////////////////////////
//:: x1_act_harper4
//:://////////////////////////////////////////////
/*
    Creates a Potion of Attunement.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    CreateItemOnObject("mi_potion_attune", GetPCSpeaker());
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
