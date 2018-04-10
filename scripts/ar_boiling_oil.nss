/*
    Boiling Oil effect set OnUsed for a placeable and pours oil at AR_BOILING_OIL_WP location.
*/

float RELOAD_TIME = 6.0;

void DoDamage(location lLocation);

void main()
{
    object oPC      = GetLastUsedBy();

    if (!GetIsPC(oPC)) return;

    object oWP      = GetObjectByTag("AR_BOILING_OIL_WP");
    location lLoc   = GetLocation(oWP);
    int canFire     = GetLocalInt(OBJECT_SELF, "AR_BOIL_OIL_READY");

    if (!canFire)
    {
        FloatingTextStringOnCreature("The boiling oil is not ready yet...", oPC);
        return;
    }

    //::  FIRE!
    SetLocalInt(OBJECT_SELF, "AR_BOIL_OIL_READY", FALSE);

    effect eSmoke       = EffectVisualEffect(VFX_DUR_SMOKE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, OBJECT_SELF);
    DelayCommand(1.0, DoDamage(lLoc));
    DelayCommand(RELOAD_TIME, SetLocalInt(OBJECT_SELF, "AR_BOIL_OIL_READY", TRUE));
}

void DoDamage(location lLocation)
{
    object oTarget      = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, FALSE, OBJECT_TYPE_CREATURE);

    effect eFire        = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eExplosion   = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
    effect eFire2       = EffectVisualEffect(VFX_FNF_FIRESTORM);
    //effect eFire3       = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire, lLocation);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplosion, lLocation, 4.0);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFire2, lLocation, 3.0);
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFire3, lLocation, 4.0);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        //::  Do damage
        if(GetIsObjectValid(oTarget))
        {
            int nDmg = d6(8);
            int nReflex = GetReflexSavingThrow(oTarget) + d20();

            if (ReflexSave(oTarget, 20, SAVING_THROW_TYPE_FIRE) != 0)
                nDmg = nDmg / 2;

            effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
        }

        //::  Next...
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lLocation, FALSE, OBJECT_TYPE_CREATURE);
    }
}
