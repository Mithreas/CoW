#include "inc_spell"
#include "inc_text"
#include "x0_i0_assoc"
// assoc included for GetPercentageHPLoss

//Spell Time Lock duration (in seconds, use float values)
float iLockTimer = 240.0;

//Defining time variables
float f120togo = ( 120 - iLockTimer ) * -1;
float f60togo = ( 60 - iLockTimer ) * -1;
float f10togo = ( 10 - iLockTimer ) * -1;

void gsTimestop()
{
    object oTarget = GetFirstObjectInArea();
    effect eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), EffectCutsceneParalyze());
    eEffect = ExtraordinaryEffect(eEffect);

    effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 125);
    eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 125));
    eImmune = EffectLinkEffects(eImmune, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 125));
    eImmune = ExtraordinaryEffect(eImmune);

    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            FloatingTextStringOnCreature(GS_T_16777432, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 9.0);
            if (GetPercentageHPLoss(oTarget) >= 50 && GetIsPC(oTarget))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmune, oTarget, 9.0);
        }

        oTarget = GetNextObjectInArea();
    }
}
//----------------------------------------------------------------
void main()
{
    if (gsSPGetOverrideSpell()) return;
    object oTarget = OBJECT_SELF;

    //Checking if caster used GS recently
    int iTimer = GetLocalInt(oTarget, "TSTimer");

    if (iTimer == 0)
    {
      SetLocalInt(oTarget, "TSTimer", 1);
      int nSpell = GetSpellId();

      SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

      ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_TIME_STOP),
        GetLocation(OBJECT_SELF));

      // Timer code.
      //Send message to DMs about spell usage
      SendMessageToAllDMs("Player "+GetName(oTarget)+" has just cast Timestop. He is currently in "+GetName(GetArea(oTarget))+".");
      SendMessageToPC(oTarget, "Timestop has a timer of "+FloatToString(iLockTimer, 3, 1)+" seconds. You may not use Timestop again for this period of time. Attempting to do so will spend the spell while producing no effect.");
      DelayCommand(f120togo, SendMessageToPC(oTarget, "You have two minutes left on your Timestop Lock Timer."));
      DelayCommand(f60togo, SendMessageToPC(oTarget, "You have one minute left on your Timestop Lock Timer."));
      DelayCommand(f10togo, SendMessageToPC(oTarget, "You have 10 seconds left on your Timestop Lock Timer."));
      DelayCommand(iLockTimer, SendMessageToPC(oTarget, "Timestop is once again available for use."));
      DelayCommand(iLockTimer, SetLocalInt(oTarget, "TSTimer", 0));

      DelayCommand(0.75, gsTimestop());
    }
    else
    {
      SendMessageToPC(oTarget, "You have used Timestop too recently, the effect has been cancelled");
    }
}

