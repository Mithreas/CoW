#include "ar_spellmatrix"

object oCaster;
location lOrigin;
int nDices;
int nDC;

void LightningStrike();
object _arGetRandomEnemyFromShape(object oCaster, location lLoc, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int nth = -1);

void main()
{
    oCaster = GetLocalObject(OBJECT_SELF, "AR_CASTER");

    //::  Invalid Caster, destroy!
    if ( GetIsObjectValid(oCaster) == FALSE ) {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nRound  = GetLocalInt(OBJECT_SELF, "AR_ROUND");
    int nLevel  = ar_GetHighestSpellCastingClassLevel(oCaster);
    nDices      = nLevel < 10 ? nLevel : 10;
    nDC         = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_EVOCATION, 9);
    lOrigin     = GetLocation(OBJECT_SELF);

    //::  Check Duration
    int nSpellDuration = 2 + (nLevel/3);
    if ( nRound > nSpellDuration ) {
        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lOrigin );
        DestroyObject(OBJECT_SELF);
        return;
    }
    SetLocalInt(OBJECT_SELF, "AR_ROUND", nRound+1);


    //::  Random Lightning
    int i = 0;
    float fDelay = 0.0;
    int nAmount  = 4 + d4();
    for (i = 0; i < nAmount; i++) {
        fDelay = 0.75 * i;
        DelayCommand( fDelay, AssignCommand(oCaster, LightningStrike() ) );
    }
}


void LightningStrike() {
    int nRandRange      = 4;
    int nDmgDices       = GetLocalInt(OBJECT_SELF, "AR_DMG_DICES");
    effect eStrikeImp   = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eStrikeHit   = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
    effect eLightning   = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

    //::  Get new location
    float randAng   = IntToFloat( Random(360) );
    float randRange = RADIUS_SIZE_HUGE * d3();
    vector vPos     = GetPositionFromLocation(lOrigin);
    vPos.x += cos(randAng) * randRange;
    vPos.y += sin(randAng) * randRange;

    //::  Randomize Target a bit
    int half  = nRandRange / 2;
    int nXPos = Random(nRandRange) - half;
    int nYPos = Random(nRandRange) - half;
    vPos.x += nXPos;
    vPos.y += nYPos;

    location lTarget = Location(GetArea(OBJECT_SELF), vPos, 0.0);

    //::  Every 3 Lightning Strikes should always go to an enemy target
    int nCount = GetLocalInt(OBJECT_SELF, "AR_COUNT");
    if (++nCount%3 == 0) {
        nCount = 0;
        object oRandTarget = _arGetRandomEnemyFromShape(oCaster, lOrigin, SHAPE_SPHERE, RADIUS_SIZE_HUGE*3, d4());
        if ( GetIsObjectValid(oRandTarget) ) lTarget = GetLocation(oRandTarget);
    }
    SetLocalInt(OBJECT_SELF, "AR_COUNT", nCount);


    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLightning, lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid(oTarget) && GetIsDead(oTarget) == FALSE )
    {
        //::  Do damage
        if ( oTarget != oCaster && GetIsReactionTypeHostile(oTarget, oCaster) && ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {
            if( !GetIsDead(oTarget) ) {
                int nDmg = d6(nDices);

                //if (ReflexSave(oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY) != 0)
                int bHasImprEvasion = GetHasFeat(FEAT_IMPROVED_EVASION, oTarget);
                int nSave = MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);
                if ( nSave == 1)            nDmg = bHasImprEvasion ? 0 : nDmg / 2;
                else if (nSave == 2)        nDmg = 0;
                else if (bHasImprEvasion)   nDmg = nDmg / 2;

                effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_ELECTRICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrikeImp, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrikeHit, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

object _arGetRandomEnemyFromShape(object oCaster, location lLoc, int nShape = SHAPE_SPHERE, float fSize = RADIUS_SIZE_HUGE, int nth = -1) {
    object oTarget = GetFirstObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    object oReturn = OBJECT_INVALID;
    int nCount = 0;

    while( GetIsObjectValid(oTarget) )
    {
        if( GetIsReactionTypeHostile(oTarget, oCaster) && oTarget != oCaster ) {
            if (nth <= 0)  return oTarget;
            else {
                oReturn = oTarget;
                if (++nCount == nth) {
                    return oTarget;
                }
            }
        }

        oTarget = GetNextObjectInShape(nShape, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }

    return oReturn;
}
