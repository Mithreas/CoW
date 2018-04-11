#include "gs_inc_area"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void Run()
{
    object oArea = GetArea(OBJECT_SELF);

    if (!gsARGetIsAreaActive(oArea))
        return;

    //::  Delay
    float fRoundDelay = 10.0;
    if ( GetLocalFloat(OBJECT_SELF, "AR_DELAY") > 3.0 ) fRoundDelay = GetLocalFloat(OBJECT_SELF, "AR_DELAY");

    //:: Z Pos
    float zPos = 1.1;
    if ( GetLocalFloat(OBJECT_SELF, "AR_ZPOS") != 0.0 ) zPos = GetLocalFloat(OBJECT_SELF, "AR_ZPOS");

    //::  Random Point
    int nWidth      = GetAreaSize(AREA_WIDTH, oArea);
    int nHeight     = GetAreaSize(AREA_HEIGHT, oArea);
    int nPointWide  = Random(nWidth * 10);
    int nPointHigh  = Random(nHeight * 10);
    float fStrikeX  = IntToFloat(nPointWide) + (IntToFloat(Random(10)) * 0.1);
    float fStrikeY  = IntToFloat(nPointHigh) + (IntToFloat(Random(10)) * 0.1);
    vector vPoint   = Vector(fStrikeX, fStrikeY, zPos);
    location lLoc   = Location(oArea, Vector(fStrikeX, fStrikeY, zPos), 0.0);


    //::  Do the VFX
    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_METEOR_SWARM), lLoc);
    DelayCommand (1.0, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect (VFX_FNF_SCREEN_SHAKE), lLoc));

    //::  Create some fires and dust plumes
    int nXPos, nYPos, nCount;
    for(nCount = 0; nCount < 15; nCount++)
    {
        nXPos = Random(30) - 15;
        nYPos = Random(30) - 15;

        vector vNewVector = vPoint;
        vNewVector.x += nXPos;
        vNewVector.y += nYPos;

        location lFireLoc = Location(oArea, vNewVector, 0.0);
        object oFire = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_flamelarge", lFireLoc, FALSE);
        object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lFireLoc, FALSE);
        DelayCommand ( 6.0, DestroyObject (oFire) );
        DelayCommand ( 8.0, DestroyObject (oDust) );
    }

    //::  Apply Effect to nearby PCs
    nCount          = 1;
    object oTarget  = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lLoc, nCount);
    float fDist     = -1.0;
    while ( GetIsObjectValid(oTarget) ) {

        fDist = GetDistanceBetweenLocations(lLoc, GetLocation(oTarget));

        //::  Within Effect?
        if ( fDist <= RADIUS_SIZE_COLOSSAL ) {
            int nFireDmg = d6(10);
            if ( ReflexSave(oTarget, 30, SAVING_THROW_TYPE_FIRE) != 0 ) {
                nFireDmg = nFireDmg / 2;
            }

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nFireDmg, DAMAGE_TYPE_FIRE), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_FIRE), oTarget);
        }

        nCount++;
        oTarget = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lLoc, nCount);
    }


    DelayCommand(fRoundDelay, Run());
}

void main()
{
    Run();
}
