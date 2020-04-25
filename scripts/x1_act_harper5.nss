//::///////////////////////////////////////////////
//:: x1_act_harper5
//:://////////////////////////////////////////////
/*
    Creates an Invisibility potion.
*/
//:://////////////////////////////////////////////

void main()
{
    CreateItemOnObject("NW_IT_MPOTION008", GetPCSpeaker());
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
