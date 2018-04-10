#include "x2_inc_toollib"

// Create a beam between two objects.
void CreateBeam(object oOrigin, object oTarget, int iVFXNumber);

// void CreateAoEEffect(object oTarget, int iVFXNumber);
// Create an AoE visual effect at target location. iVFXNumber is used within the function to assign different AoE effects. sType is either "placeable" or "location".
// Calls _AoEEeffectHandler to convert iVFXNumber to corresponding effect.
void CreateAoEEffect(object oTarget, int iVFXNumber);

// Converts iVFX Number to corresponding VFX.
// 0 AOE_PER_DARKNESS
// 1 AOE_PER_CREEPING_DOOM
// 2 AOE_PER_DELAY_BLAST_FIREBALL
// 3 AOE_PER_ENTANGLE
// 4 AOE_PER_EVARDS_BLACK_TENTACLES
// 5 AOE_PER_FOG_OF_BEWILDERMENT
// 6 AOE_PER_FOGACID
// 7 AOE_PER_FOGFIRE
// 8 AOE_PER_FOGGHOUL
// 9 AOE_PER_FOGKILL
// 10 AOE_PER_FOGMIND
// 11 AOE_PER_FOGSTINK
// 12 AOE_PER_GLYPH_OF_WARDING
// 13 AOE_PER_GREASE
// 14 AOE_PER_INVIS_SPHERE
// 15 AOE_PER_OVERMIND
// 16 AOE_PER_STONEHOLD
// 17 AOE_PER_STORM
// 18 AOE_PER_VINE_MINE_CAMOUFLAGE
// 19 AOE_PER_WALLBLADE
// 20 AOE_PER_WALLFIRE
// 21 AOE_PER_WALLWIND
// 22 AOE_PER_WEB
effect _AoEEffectHandler(int iVFXNumber);

// Create a visual effect on a placeable or other object. Just put in the object and the visual effect number.
void CreateEffectOnObject(object oObject, int iVFXNumber);

// Create a visual effect at a location. Just put in the location and the visual effect number.
void CreateEffectAtLocation(location lLocation, int iVFXNumber);

// Move an object and return the new object created by this function. TagAppend is a phrase to tack onto the tag after a move, useful when moving
// lots of objects sequentially.
object MoveObject(object oObject, string sResRef, string sTag = "", string sTagAppend = "", float xOffset = 0.0, float yOffset = 0.0, float zOffset = 0.0);

// oObject plays its activated animation for fDuration and then reverts back to being deactivated.
void TemporaryActivation(object oObject, float fDuration);

// oObject plays its activated animation for fDuration and then reverts back to being deactivated.
void TemporaryDeactivation(object oObject, float fDuration);

// Flood an area with tile magic
// const int X2_TL_GROUNDTILE_ICE = 426;
// const int X2_TL_GROUNDTILE_WATER = 401;
// const int X2_TL_GROUNDTILE_GRASS = 402;
// const int X2_TL_GROUNDTILE_LAVA_FOUNTAIN = 349; // ugly
// const int X2_TL_GROUNDTILE_LAVA = 350;
// const int X2_TL_GROUNDTILE_CAVEFLOOR = 406;
// const int X2_TL_GROUNDTILE_SEWER_WATER = 461;
void FloodTile(int nGroundTileConst, float fZOffset);

//Set all placeables to plot provided they do not meet certain conditions
//iBreak is the local variable iBreak, if set to 1, the object should be breakable (non-plot).
void DoPlotCheck(object oObject, int iBreak);

// Creates a lake of Shadow shield by spawning the "shadowshield" placeable in a grid.
// User must input x, y, z location of the starting placeable, as well as number of rows and columns for the grid.
void FloorCover(float xloc, float yloc, float zloc, float fFacing, int nRowNum, int nColNum, int nVFX);

// Creates a 3D line of placeables from Nstart to Nend, the spacing is controlled by plcXwidth, plcYheight, plcZdepth. Resref and orientation. If Orientation is 400.0, chooses random orientation.
void PlaceableLine(float fXstart, float fXend, float fYstart, float fYend, float fZstart, float fZend, float fplcXwidth, float fplcYheight,
                   float fplcZdepth, string sResref, float fOrientation = 0.0);

// Creates a 3D placeable wall. There's alot of parameters, please check sep_plc_wall to see how it's used.
void PlaceableWall(float fXstart, float fXend, float fYstart, float fYend, float fZstart, float fZend, float fplcXwidth, float fplcYheight,
                   float fplcZdepth, string sResref, float fOrientation = 0.0, int bRandomFacing = 0, int bSmallOffset = 0, int bXstagger = 0,
                   int bYstagger = 0, int bZstagger = 0);

//------------------------------------------------------------------------------
void CreateBeam(object oOrigin, object oTarget, int iVFXNumber)
    {
        effect eBeam =  EffectBeam(iVFXNumber, oOrigin, BODY_NODE_CHEST);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam, oTarget);
        return;
    }
//------------------------------------------------------------------------------
effect _AoEEffectHandler(int iVFXNumber)
    {

    effect eEffect;

    switch(iVFXNumber)
        {
        case 0: eEffect = EffectAreaOfEffect(AOE_PER_DARKNESS, "****", "****", "****"); break;
        case 1: eEffect = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM, "****", "****", "****"); break;
        case 2: eEffect = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL, "****", "****", "****"); break;
        case 3: eEffect = EffectAreaOfEffect(AOE_PER_ENTANGLE, "****", "****", "****"); break;
        case 4: eEffect = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES, "****", "****", "****"); break;
        case 5: eEffect = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "****", "****", "****"); break;
        case 6: eEffect = EffectAreaOfEffect(AOE_PER_FOGACID, "****", "****", "****"); break;
        case 7: eEffect = EffectAreaOfEffect(AOE_PER_FOGFIRE, "****", "****", "****"); break;
        case 8: eEffect = EffectAreaOfEffect(AOE_PER_FOGGHOUL, "****", "****", "****"); break;
        case 9: eEffect = EffectAreaOfEffect(AOE_PER_FOGKILL, "****", "****", "****"); break;
        case 10: eEffect = EffectAreaOfEffect(AOE_PER_FOGMIND, "****", "****", "****"); break;
        case 11: eEffect = EffectAreaOfEffect(AOE_PER_FOGSTINK, "****", "****", "****"); break;
        case 12: eEffect = EffectAreaOfEffect(AOE_PER_GLYPH_OF_WARDING, "****", "****", "****"); break;
        case 13: eEffect = EffectAreaOfEffect(AOE_PER_GREASE, "****", "****", "****"); break;
        case 14: eEffect = EffectAreaOfEffect(AOE_PER_INVIS_SPHERE, "****", "****", "****"); break;
        case 15: eEffect = EffectAreaOfEffect(AOE_PER_OVERMIND, "****", "****", "****"); break;
        case 16: eEffect = EffectAreaOfEffect(AOE_PER_STONEHOLD, "****", "****", "****"); break;
        case 17: eEffect = EffectAreaOfEffect(AOE_PER_STORM, "****", "****", "****"); break;
        case 18: eEffect = EffectAreaOfEffect(AOE_PER_VINE_MINE_CAMOUFLAGE, "****", "****", "****"); break;
        case 19: eEffect = EffectAreaOfEffect(AOE_PER_WALLBLADE, "****", "****", "****"); break;
        case 20: eEffect = EffectAreaOfEffect(AOE_PER_WALLFIRE, "****", "****", "****"); break;
        case 21: eEffect = EffectAreaOfEffect(AOE_PER_WALLWIND, "****", "****", "****"); break;
        case 22: eEffect = EffectAreaOfEffect(AOE_PER_WEB, "****", "****", "****"); break;
        default: break;
        }

        return eEffect;

    }
//------------------------------------------------------------------------------
object _objectCreator(location lTarget)
    {
        object oNewTarget;
        oNewTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lTarget);
        return oNewTarget;
    }
//------------------------------------------------------------------------------
void CreateAoEEffect(object oTarget, int iVFXNumber)
    {

        effect eEffect = _AoEEffectHandler(iVFXNumber);
        location lTarget = GetLocation(oTarget);
        ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eEffect, lTarget);
        return;
    }
//------------------------------------------------------------------------------
void CreateEffectOnObject(object oObject, int iVFXNumber)
    {
        effect eVFX =  EffectVisualEffect(iVFXNumber);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oObject);
        return;
    }
//------------------------------------------------------------------------------
void CreateEffectAtLocation(location lLocation, int iVFXNumber)
    {
        effect eVFX =  EffectVisualEffect(iVFXNumber);
        ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eVFX, lLocation);
        return;
    }
//------------------------------------------------------------------------------
object MoveObject(object oObject, string sResRef, string sTag = "", string sTagAppend = "", float xOffset = 0.0, float yOffset = 0.0, float zOffset = 0.0)
    {
        float posx, posy, posz, orientation;
        location lLocator = GetLocation(oObject);
        vector vVectorizor =GetPositionFromLocation(lLocator);
        orientation = GetFacing(oObject);
        posx = vVectorizor.x + xOffset;
        posy = vVectorizor.y + yOffset;
        posz = vVectorizor.z + zOffset;
        vVectorizor = Vector(posx, posy, posz);
        lLocator = Location(GetArea(OBJECT_SELF), vVectorizor, orientation);
        DestroyObject(oObject);
        oObject = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocator, FALSE, sTag+sTagAppend);
        return oObject;

    }
//------------------------------------------------------------------------------
void _TemporaryFiddle(object oObject)
    {
        int Toggle = (GetLocalInt(OBJECT_SELF, "IsActivated")+1) % 2;
        ExecuteScript("sep_fcn_anim", oObject);
        SetLocalInt(oObject, "IsActivated", Toggle); //Toggle state
        return;
    }
//------------------------------------------------------------------------------
void TemporaryActivation(object oObject, float fDuration)
    {
        //Off, turn it on
        SetLocalInt(oObject, "IsActivated", 0);
        ExecuteScript("sep_fcn_anim", oObject);
        SetLocalInt(oObject, "IsActivated", 1);
        DelayCommand(fDuration, _TemporaryFiddle(oObject));
        return;
    }
//------------------------------------------------------------------------------
void TemporaryDeactivation(object oObject, float fDuration)
    {
        //On, turn it off
        SetLocalInt(oObject, "IsActivated", 1);
        ExecuteScript("sep_fcn_anim", oObject);
        SetLocalInt(oObject, "IsActivated", 0);
        DelayCommand(fDuration, _TemporaryFiddle(oObject));
        return;
    }
//------------------------------------------------------------------------------
void FloodTile(int nGroundTileConst, float fZOffset)
    {
      TLChangeAreaGroundTilesEx(GetArea(OBJECT_SELF), nGroundTileConst, fZOffset);
      return;
    }
//------------------------------------------------------------------------------
void DoPlotCheck(object oObject, int iBreak)
    {
            if (iBreak == 1)
                 {
                       SetPlotFlag(oObject, FALSE);
                 }
            else if ((!GetHasInventory(oObject))&&
            (GetObjectType(oObject) != OBJECT_TYPE_CREATURE)&&
            (GetUseableFlag(oObject) == FALSE)&&
            (GetStringLeft(GetTag(oObject), 2) != "GS")&&
            (GetStringLeft(GetTag(oObject), 2) != "MI")&&
            (GetStringLeft(GetTag(oObject), 2) != "AR")
           )
                {
                     SetPlotFlag(oObject, TRUE);
                }
    return;
    }
//------------------------------------------------------------------------------
void FloorCover(float xloc, float yloc, float zloc, float fFacing, int nRowNum, int nColNum, int nVFX)
{
    string sResRef = "x0_rugoriental";
    float PLACEABLEWIDTH = 5.0;
    float PLACEABLEHEIGHT = 6.32;
    object oCarpet;
    effect eVFX =  EffectVisualEffect(nVFX);
    object oRug;

    vector vVector;
    location lLocation;
    int verticalshift;
    int horizontalshift;

    for(verticalshift=0; verticalshift<nRowNum; verticalshift++)
    {
        for(horizontalshift=0; horizontalshift<nColNum; horizontalshift++)
        {
            vVector = Vector(xloc+(horizontalshift*PLACEABLEWIDTH), yloc+(verticalshift*PLACEABLEHEIGHT), zloc);
            lLocation = Location(GetArea(OBJECT_SELF), vVector, fFacing);
            oRug = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocation);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oRug);
            SetPlotFlag(oRug, TRUE);
        }
    }
}
//------------------------------------------------------------------------------
void DoClouds(float fZOffset = 13.00)
{
//TLChangeGroundTiles using Mist Placeables.
int nColumns = GetAreaSize(AREA_WIDTH);
int nRows = GetAreaSize(AREA_HEIGHT);
object oArea = GetArea(OBJECT_SELF);

    // * flood area with tiles
    object oCloud;
    // * put ice everywhere
    vector vPos;
    vPos.x = 5.0;
    vPos.y = 0.0;
    vPos.z = fZOffset;
    float fFace = 0.0;
    location lLoc;
    // * fill x axis
    int i, j;
    for (i=0 ; i <= nColumns; i++)
    {
        vPos.y = -5.0;
        // fill y
        for (j=0; j <= nRows; j++)
        {
            vPos.y = vPos.y + 10.0;
            lLoc = Location(oArea, vPos, fFace);
            // Ice tile (even though it says water).
            oCloud = CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_mist", lLoc, FALSE, "sep_cloud");
            SetPlotFlag(oCloud, TRUE);
            // ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nGroundTileConst), oTile);
        }
        vPos.x = vPos.x + 10.0;
    }
}

//------------------------------------------------------------------------------
void PlaceableWall(float fXstart, float fXend, float fYstart, float fYend, float fZstart, float fZend, float fplcXwidth, float fplcYheight,
                   float fplcZdepth, string sResref, float fOrientation = 0.0, int bRandomFacing = 0, int bSmallOffset = 0, int bXstagger = 0,
                   int bYstagger = 0, int bZstagger = 0)
{
    object oArea = GetArea(OBJECT_SELF);
    float xPos, yPos, zPos;
    int xLoop, yLoop, zLoop;
    int nXsign = 1;
    int nYsign = 1;
    int nZsign = 1;
    location lLoc;
    vector vLoc;

    // Determine number of loops:

    if (fplcXwidth != 0.0) xLoop = FloatToInt(fabs(fXend - fXstart) / fplcXwidth);
    if (fplcYheight != 0.0) yLoop = FloatToInt(fabs(fYend - fYstart) / fplcYheight);
    if (fplcZdepth != 0.0) zLoop = FloatToInt(fabs(fZend - fZstart) / fplcZdepth);

    //SendMessageToPC(oDebug, "xLoop = "+IntToString(xLoop)+" yLoop = "+IntToString(yLoop)+" zLoop = "+IntToString(zLoop));


    if (fXend < fXstart) nXsign = -1;
    if (fYend < fYstart) nYsign = -1;
    if (fZend < fZstart) nZsign = -1;

    //SendMessageToPC(oDebug, "nXsign = "+IntToString(nXsign)+" nYsign = "+IntToString(nYsign)+" nZsign = "+IntToString(nZsign));

    if ((fplcXwidth == 0.0)&&(fXstart != fXend)) return;
    if ((fplcYheight == 0.0)&&(fYstart != fYend)) return;
    if ((fplcZdepth == 0.0)&&(fZstart != fZend)) return;


    int xIterator  = 0;
    int yIterator  = 0;
    int zIterator  = 0;

    if (xLoop == 0) xLoop = 1;
    if (yLoop == 0) yLoop = 1;
    if (zLoop == 0) zLoop = 1;

    int nFace;
    int nVal;
    float fLocalOrientation = fOrientation + 90.0;

    for (xIterator = 0; xIterator < xLoop; xIterator++)
    {
        for (yIterator = 0; yIterator < yLoop; yIterator++)
        {
            for (zIterator = 0; zIterator < zLoop; zIterator++)
            {
                xPos = fXstart + fplcXwidth*xIterator*nXsign;
                yPos = fYstart + fplcYheight*yIterator*nYsign;
                zPos = fZstart + fplcZdepth*zIterator*nZsign;

                if (bXstagger)
                {
                        if (xIterator % 2 == yIterator % 2)
                        {
                            xPos += 0.02;
                        }
                }
                if (bYstagger)
                {
                        if (xIterator % 2 == yIterator % 2)
                        {
                            yPos += 0.02;
                        }
                }
                if (bZstagger)
                {
                        if (xIterator % 2 == yIterator % 2)
                        {
                            zPos += 0.02;
                        }
                }

                //SendMessageToPC(oDebug, "Creating Placeable at: X= " + FloatToString(xPos) + " Y = " + FloatToString(yPos) + " Z = "+ FloatToString(zPos));
                //SendMessageToPC(oDebug, " Xiterator = "+ IntToString(xIterator) + "Yiterator = " + IntToString(yIterator) + " Ziterator = "+ IntToString(zIterator));

                vLoc = Vector(xPos, yPos, zPos);
                if (bRandomFacing)
                {
                    fLocalOrientation = IntToFloat(Random(359));
                }
                else if (bSmallOffset)
                {
                   nVal = d2(1);
                   nFace = Random(30);

                   if (nVal % 2 == 0)
                   {
                        fLocalOrientation = fOrientation + 90.0 + IntToFloat(nFace);
                   }
                   else
                   {
                        fLocalOrientation = fOrientation + 90.0 - IntToFloat(nFace);
                   }
                }

                lLoc = Location(oArea, vLoc, fLocalOrientation);
                CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lLoc, FALSE, "sep_wall_"+GetTag(oArea));
             }
        }
    }
}

//------------------------------------------------------------------------------

void PlaceableLine(float fXstart, float fXend, float fYstart, float fYend, float fZstart, float fZend, float fplcXwidth, float fplcYheight, float fplcZdepth, string sResref, float fOrientation = 0.0)
{

    object oArea = GetArea(OBJECT_SELF);
    float xPos, yPos, zPos;
    int nXsign = 1;
    int nYsign = 1;
    int nZsign = 1;
    location lLoc;
    vector vLoc;

    if (fXend < fXstart) nXsign = -1;
    if (fYend < fYstart) nYsign = -1;
    if (fZend < fZstart) nZsign = -1;

    //SendMessageToPC(oDebug, "nXsign = "+IntToString(nXsign)+" nYsign = "+IntToString(nYsign)+" nZsign = "+IntToString(nZsign));

    if ((fplcXwidth == 0.0)&&(fXstart != fXend)) return;
    if ((fplcYheight == 0.0)&&(fYstart != fYend)) return;
    if ((fplcZdepth == 0.0)&&(fZstart != fZend)) return;

    int xIterator  = 0;
    int yIterator  = 0;
    int zIterator  = 0;

    float fLocalOrientation = fOrientation + 0.0;

  while (
         ((xPos < fXend)&&(fXstart != fXend))&&
         ((yPos < fYend)&&(fYstart != fYend))&&
         ((zPos < fZend)&&(fZstart != fZend))
        )
  {
                xPos = fXstart + fplcXwidth*xIterator*nXsign;
                yPos = fYstart + fplcYheight*yIterator*nYsign;
                zPos = fZstart + fplcZdepth*zIterator*nZsign;

                //SendMessageToPC(oDebug, "Creating Placeable at: X= " + FloatToString(xPos) + " Y = " + FloatToString(yPos) + " Z = "+ FloatToString(zPos));
                //SendMessageToPC(oDebug, " Xiterator = "+ IntToString(xIterator) + "Yiterator = " + IntToString(yIterator) + " Ziterator = "+ IntToString(zIterator));

                vLoc = Vector(xPos, yPos, zPos);
                if (fOrientation > (360.0 + 90.0))
                {
                    fLocalOrientation = IntToFloat(Random(359));
                }
                lLoc = Location(oArea, vLoc, fLocalOrientation);
                CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lLoc, FALSE, "sep_wall_"+GetTag(oArea));
                xIterator += 1;
                yIterator += 1;
                zIterator += 1;

    }
}
