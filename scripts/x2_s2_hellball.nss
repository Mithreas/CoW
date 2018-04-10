//::///////////////////////////////////////////////
//:: Hellball
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Long range area of effect spell
    10d6 sonic, acid, fire and lightning damage to all
    objects in the area

    10d6 points of negative energy damage to caster
    if MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER switch
    was enabled on the module.

    This spell is supposed to hurt the caster if he
    is stupid enough to stand in the area of effect
    when all hell breaks loose. It will hurt other
    players allied with the caster as well. These
    effects are dependent on your difficulty setting

    Save is 20 + relevant ability score, or, when cast
    by a placeable, equal to the placeables WILL Save

    There is no benefit from the evasion feats here
    as the are of the spell is too large to avoid it


*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Noobs, Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////

#include "mi_inc_class"
#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook
			
	// Shadow mages cannot cast evocation spells (except Darkness).
    if (GetIsShadowMage(OBJECT_SELF))
    {
      SendMessageToPC (OBJECT_SELF, "The Shadow Weave does not support Evocation spells (except Darkness).");
      return;
    }
	
    //Declare major variables
    int nDamage1, nDamage2, nDamage3, nDamage4;
    float fDelay;
    effect eExplode = EffectVisualEffect(464);
    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eVis3 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    int nBacklash = GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION) ? 0 : d6(30);

    if (nBacklash)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nBacklash), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), OBJECT_SELF);
    }

    effect eDam1, eDam2, eDam3, eDam4, eDam5, eKnock;
    eKnock= EffectKnockdown();

    location lTarget = GetSpellTargetLocation();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    int nTotalDamage;
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
           //Roll damage for each target.
            nDamage1 = d6(10);
            nDamage2 = d6(10);
            nDamage3 = d6(10);
            nDamage4 = d6(10);

            nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;
            //Set the damage effect
            eDam1 = EffectDamage(nDamage1, DAMAGE_TYPE_DIVINE);
            eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_MAGICAL);
            eDam3 = EffectDamage(nDamage3, DAMAGE_TYPE_POSITIVE);
            eDam4 = EffectDamage(nDamage4, DAMAGE_TYPE_NEGATIVE);

            if(nTotalDamage > 0)
            {
                if (nTotalDamage > 50)
                {
                    DelayCommand(fDelay+0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget,3.0f));
                }

                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam3, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam4, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay+0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                DelayCommand(fDelay+0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }


}

