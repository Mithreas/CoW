//::///////////////////////////////////////////////
//:: x1_act_harper2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an Eagle's Splendor potion.
*/

void main()
{
    CreateItemOnObject("NW_IT_MPOTION010", GetPCSpeaker());
    //TakeGoldFromCreature(60, GetPCSpeaker(), TRUE);
    //SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 5);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
