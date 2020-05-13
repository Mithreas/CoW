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
    object oPot = CreateItemOnObject("mi_potion_attune", GetPCSpeaker());
	SetIdentified(oPot, TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
