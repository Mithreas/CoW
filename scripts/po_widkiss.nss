#include "ar_sys_poison"

/*
  Poison Widow's Kiss
  Initial       1d4 CON Damage
  Secondary     1 + d3 Spiders Explodes from the Host Body (Will be summons for the Poison owner)
                Damage is equal to 5d6 base damage and a d12 damage for each spider being hatched
  DC            24
*/

void SummonSwarmOnTarget(object oCaster, object oTarget, struct SummonGroup swarm, float fDuration, int nVFX = VFX_NONE);
void secondaryEffect();

void main()
{
    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  The DC oSpellTarget has to make or face the consequences!
    int nDC = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    //::  Initial Effect
    if( !arPOGetIsPoisoned(oSpellTarget) && !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        effect ePoi  = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4());
               ePoi  = EffectLinkEffects( ePoi, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );

        arPONotifyTarget(oSpellTarget);

        //::  Tagged Poison Effect
        RemoveAndReapplyNEP(oSpellTarget);
        AssignCommand(oSpellTarget, _arPOStackPoisonPenalty(oSpellTarget, ePoi));
        DelayCommand(60.0, secondaryEffect());
    }
}

void secondaryEffect() {
    object oItem        = GetSpellCastItem();
    object oSpellTarget = GetSpellTargetObject();
    object oSpellOrigin = OBJECT_SELF;
    int nDC             = arPOGetPoisonDC(oItem) + arPOGetClassDC(oSpellOrigin);

    if ( !GetIsDead(oSpellTarget) && arPOGetIsPoisoned(oSpellTarget) &&
         !MySavingThrow(SAVING_THROW_FORT, oSpellTarget, nDC, SAVING_THROW_TYPE_POISON) &&
         !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {

        //::  Summon Spider Swarm at Target and dealing damage (Spiders are literally exploding out from the body)
        int nAmount         = 1 + d3();
        int nDuration       = 1;
        string sResRef      = "ar_widowspider";

        //::  Damage
        int nDmg = d12(nAmount) + d6(5);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), EffectDamage(nDmg)), oSpellTarget);

        //::  Spider hatchlings
        SummonSwarmOnTarget(oSpellOrigin, oSpellTarget, CreateSummonGroup(nAmount, sResRef), HoursToSeconds(nDuration), VFX_COM_CHUNK_RED_SMALL);
    }
}

void SummonSwarmOnTarget(object oCaster, object oTarget, struct SummonGroup swarm, float fDuration, int nVFX = VFX_NONE)
{
    float fVector = 0.0;
    int i = 1;
    int nSummonIndex;
    location lSpawn;
    location lTarget = GetLocation(oTarget);
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    string sSummonBlueprint;

    while(GetIsObjectValid(oSummon))
    {
        UnsummonCreature(oSummon);
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }

    for(nSummonIndex = 1; nSummonIndex <= 4; nSummonIndex++)
    {
        switch(nSummonIndex)
        {
            case 1:
                sSummonBlueprint = swarm.summon1;
                break;
            case 2:
                sSummonBlueprint = swarm.summon2;
                break;
            case 3:
                sSummonBlueprint = swarm.summon3;
                break;
            case 4:
                sSummonBlueprint = swarm.summon4;
                break;
        }
        if(sSummonBlueprint == "") continue;
        if(nSummonIndex == 1)
        {
            // The game will unsummon the first spawn of a new batch. So create one dummy.
            lSpawn = GenerateNewLocationFromLocation(lTarget, 1.5, fVector, fVector);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummonBlueprint), lSpawn, fDuration);
        }
        for(i = 0; i < swarm.numSummons; i++)
        {
            lSpawn = GenerateNewLocationFromLocation(lTarget, 1.5, fVector, fVector);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummonBlueprint, nVFX), lSpawn, fDuration);
            fVector += 40;
        }
    }
    DelayCommand(0.0, _FlagSwarmSummons(oCaster));
}
