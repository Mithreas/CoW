void main()
{
object oObject = OBJECT_SELF;
float rSize = RADIUS_SIZE_LARGE;


// Load effects.
effect eExplotion = EffectVisualEffect(VFX_FNF_FIREBALL);
effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

// Get location of the explotion.
location lLocation = GetLocation(oObject);

    effect eDam;
    float fDelay;

//Apply the fireball explosion at the location captured above.
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplotion, lLocation);

//Declare the spell shape, size and the location.  Capture the first target object in the shape.
object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, rSize, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
int iDistance;

  while (GetIsObjectValid(oTarget)) {

        if ( (oTarget != OBJECT_SELF) && ( GetFactionEqual(oTarget) != TRUE) ) {

                iDistance = FloatToInt(GetDistanceToObject(oTarget));

                //Roll damage for each target
                int nDamage = 50 + d6((8-iDistance)*7);

                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 30, SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                fDelay = GetDistanceToObject(oTarget)/20;
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    //DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    // DestroyObject(OBJECT_SELF);
}
