//::///////////////////////////////////////////////
//:: Executed Script: Fire Shield
//:: exe_fireshield
//:://////////////////////////////////////////////
/*
    Creates a fire shield on the calling
    object. The shield deals 1d8 + (Hit Dice / 2)
    damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 8, 2016
//:://////////////////////////////////////////////

void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageShield(GetHitDice(OBJECT_SELF) / 2, DAMAGE_BONUS_1d8, DAMAGE_TYPE_FIRE)), OBJECT_SELF);
}
