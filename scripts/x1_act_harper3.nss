//::///////////////////////////////////////////////
//:: x1_act_harper3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a Cat's Grace potion and an Invisibility
	potion.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    CreateItemOnObject("NW_IT_MPOTION014", GetPCSpeaker());
    CreateItemOnObject("NW_IT_MPOTION008", GetPCSpeaker());
    //TakeGoldFromCreature(60, GetPCSpeaker(), TRUE);
    //SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 5);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
