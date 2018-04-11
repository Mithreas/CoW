/*
    On-hit damage triggered by the Assassinate ability.
*/

void main()
{
    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;

    int nDamage = GetLocalInt(oItem, "ASSASSIN_DAMAGE");
    if (!nDamage) return;

    if (oSpellTarget != GetLocalObject(oItem, "ASSASSIN_TARGET"))
        return;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL)), oSpellTarget);
}
