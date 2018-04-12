#include "inc_spellmatrix"

object oCaster;
location lOrigin;
int nDices;
int nDC;


void DoVFXStuff();
void SpitFire(object oCaster);
void _applyDamageAoe(location lTarget);
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
    nDices      = nLevel < 20 ? nLevel : 20;
    nDC         = ar_GetCustomSpellDC(oCaster, SPELL_SCHOOL_CONJURATION, 10);
    lOrigin     = GetLocation(OBJECT_SELF);

    //::  Check Duration
    int nSpellDuration = 2 + (nLevel/3);
    if ( nRound > nSpellDuration ) {
        ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lOrigin );
        DestroyObject(OBJECT_SELF);
        return;
    }
    SetLocalInt(OBJECT_SELF, "AR_ROUND", nRound+1);

    //::  Shake it up a bit!
    DoVFXStuff();

    //::  Spit Random Fireballs
    int i = 0;
    float fDelay = 0.0;
    int nAmount  = 3 + d4();
    for (i = 0; i < nAmount; i++) {
        fDelay = 0.75 * i;
        DelayCommand( fDelay, SpitFire(oCaster) );
    }

    //::  Firestorm AoE
    int nDmg   = d6(nDices);
    float nDur = RoundsToSeconds(1);
    AssignCommand(oCaster,
        _arDoAoeSpell(lOrigin, EffectVisualEffect(VFX_FNF_FIRESTORM), EffectDazed(), SAVING_THROW_FORT, SAVING_THROW_TYPE_FIRE, nDC, nDur, nDmg, DAMAGE_TYPE_FIRE, SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, FALSE) );
}

void DoVFXStuff() {
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lOrigin );

    object oArea = GetArea(OBJECT_SELF);
    int nXPos, nYPos, nCount;
    for(nCount = 0; nCount < 15; nCount++)
    {
        nXPos = Random(30) - 15;
        nYPos = Random(30) - 15;

        vector vNewVector = GetPositionFromLocation(lOrigin);
        vNewVector.x += nXPos;
        vNewVector.y += nYPos;

        location lFireLoc = Location(oArea, vNewVector, 0.0);
        object oFire = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_flamelarge", lFireLoc, FALSE);
        //object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lFireLoc, FALSE);
        DelayCommand ( 2.0, DestroyObject (oFire) );
        //DelayCommand ( 2.0, DestroyObject (oDust) );
    }
}

void SpitFire(object oCaster) {
    int nRandRange      = 6;
    int nDmgDices       = GetLocalInt(OBJECT_SELF, "AR_DMG_DICES");

    //::  Get new location
    float randAng   = IntToFloat( Random(360) );
    float randRange = RADIUS_SIZE_GARGANTUAN * d3();
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

    //::  Every 3 Fireball should always go to an enemy target
    int nCount = GetLocalInt(OBJECT_SELF, "AR_COUNT");
    if (++nCount%3 == 0) {
        nCount = 0;
        object oRandTarget = _arGetRandomEnemyFromShape(oCaster, lOrigin, SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN*3, d4());
        if ( GetIsObjectValid(oRandTarget) ) lTarget = GetLocation(oRandTarget);
    }
    SetLocalInt(OBJECT_SELF, "AR_COUNT", nCount);

    float dist   = GetDistanceBetweenLocations(lOrigin, lTarget);
    float fDelay = 0.3 + (0.09 * ( dist < 0.0 ? 0.0 : dist ));


    AssignCommand(OBJECT_SELF, ActionCastFakeSpellAtLocation(SPELL_FIREBALL, lTarget, PROJECTILE_PATH_TYPE_HIGH_BALLISTIC));
    DelayCommand( fDelay, AssignCommand(oCaster, _applyDamageAoe(lTarget)) );
}

void _applyDamageAoe(location lTarget) {
    effect eFire        = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eFire2       = EffectVisualEffect(VFX_IMP_FLAME_M);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire, lTarget);

    //::  Loop through affected targets and do damage
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        //::  Do damage
        if ( oTarget != oCaster && GetIsReactionTypeHostile(oTarget, oCaster) && ar_GetSpellImmune(oCaster, oTarget) == FALSE ) {
            if( !GetIsDead(oTarget) )
            {
                int nDmg    = d6(nDices);
                //int nReflex = GetReflexSavingThrow(oTarget) + d20();

                //if (ReflexSave(oTarget, nDC, SAVING_THROW_TYPE_FIRE) != 0)
                int bHasImprEvasion = GetHasFeat(FEAT_IMPROVED_EVASION, oTarget);
                int nSave = MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCaster);
                if ( nSave == 1)            nDmg = bHasImprEvasion ? 0 : nDmg / 2;
                else if (nSave == 2)        nDmg = 0;
                else if (bHasImprEvasion)   nDmg = nDmg / 2;

                effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_FIRE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire2, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE);
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
