//::///////////////////////////////////////////////
//:: Math Library
//:: inc_math
//:://////////////////////////////////////////////
/*
    Contains math helper functions.
*/
//:://////////////////////////////////////////////
//:: Created By: J. Persinne
//:: Created On: July 25, 2011
//:://////////////////////////////////////////////

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Rejection sampling mode for random circular coordinates.
const int CIRCLE_DISTRIBUTION_MODE_REJECTION = 0;
// Radial mode for random circular coordinates. This value corresponds to the number
// of attempts that will be made at rejection sampling before falling back on
// radial distribution.
const int CIRCLE_DISTRIBUTION_MODE_RADIAL = 5;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Clamps a float's value into the specified range.
float ClampFloat(float fFloat, float fMinValue, float fMaxValue);
// Clamps an int's value into the specified range.
int ClampInt(int nInt, int nMinValue, int nMaxValue);
// Generates a random coordinate for a circle of nRadius, with point (0, 0) representing the
// center. nModeValues:
//   - CIRCLE_DISTRIBUTION_MODE_REJECTION
//   Rejection sampling. Quick and evenly distributed, but somewhat variable
//   process consumption. Nonetheless, this is the recommended choice. Given several
//   consecutive rejection test fails, an alternate mode will be called
//   automatically.
//   - CIRCLE_DISTRIBUTION_MODE_RADIAL
//   Radial distribution. Generates a coordinate from an angle and a point. Slow
//   and provides somewhat uneven distribution, but process consumption is constant.
vector GenerateCircleCoordinate(int nRadius, int nMode = CIRCLE_DISTRIBUTION_MODE_REJECTION);
// Generates a random coordinate for a square of nRadius, with point (0, 0) representing
// the center.
vector GenerateSquareCoordinate(int nRadius);

// Returns the lowest between a and b.
int MinInt(int a, int b);
float MinFloat(float a, float b);

// Returns the higehst between a and b.
int MaxInt(int a, int b);
float MaxFloat(float a, float b);

// Convert Hex to Dec
int ConvertHexToDec(string sHex);
/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: ClampFloat
//:://////////////////////////////////////////////
/*
    Clamps a float's value into the specified range.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 2, 2016
//:://////////////////////////////////////////////
float ClampFloat(float fFloat, float fMinValue, float fMaxValue)
{
    return fFloat < fMinValue ? fMinValue :
        fFloat > fMaxValue ? fMaxValue : fFloat;
}

//::///////////////////////////////////////////////
//:: ClampInt
//:://////////////////////////////////////////////
/*
    Clamps an int's value into the specified range.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 2, 2016
//:://////////////////////////////////////////////
int ClampInt(int nInt, int nMinValue, int nMaxValue)
{
    return nInt < nMinValue ? nMinValue :
        nInt > nMaxValue ? nMaxValue : nInt;
}

//::///////////////////////////////////////////////
//:: GenerateCircleCoordinate
//:://////////////////////////////////////////////
/*
    Generates a random coordinate for a circle of
    nRadius, with point (0, 0) representing the
    center. nModeValues:
      - CIRCLE_DISTRIBUTION_MODE_REJECTION
      Rejection sampling. Quick and evenly
      distributed, but somewhat variable
      process consumption. Nonetheless, this is
      the recommended choice. Given several
      consecutive rejection test fails, an
      alternate mode will be called
      automatically.
      - CIRCLE_DISTRIBUTION_MODE_RADIAL
      Radial distribution. Generates a
      coordinate from an angle and a point. Slow
      and provides somewhat uneven distribution,
      but process consumption is constant.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 2, 2016
//:://////////////////////////////////////////////
vector GenerateCircleCoordinate(int nRadius, int nMode = CIRCLE_DISTRIBUTION_MODE_REJECTION)
{
    int nDistance;
    int nX;
    int nY;
    float fAngle;
    vector vCoordinate;

    if(nMode < CIRCLE_DISTRIBUTION_MODE_RADIAL)
    {
        // Generate a random square coordinate.
        nX -= nRadius;
        nY -= nRadius;
        nX += Random(nRadius * 2 + 1);
        nY += Random(nRadius * 2 + 1);
        // Ensure that the coordinate is within the bounds of our circle.
        nDistance = (nX * nX) + (nY * nY);
        if(nDistance > (nRadius * nRadius))
            { return GenerateCircleCoordinate(nRadius, nMode + 1); }
        // Coordinate is valid. Apply it to our vector.
        vCoordinate.x += nX;
        vCoordinate.y += nY;
    }
    else
    {
        fAngle = IntToFloat(Random(361));
        nDistance = Random(nRadius);
        vCoordinate.x += nDistance * cos(fAngle);
        vCoordinate.y += nDistance * sin(fAngle);
    }
    return vCoordinate;
}

//::///////////////////////////////////////////////
//:: GenerateSquareCoordinate
//:://////////////////////////////////////////////
/*
    Generates a random coordinate for a square
    of nRadius, with point (0, 0) representing
    the center.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 2, 2016
//:://////////////////////////////////////////////
vector GenerateSquareCoordinate(int nRadius)
{
    vector vCoordinate;

    vCoordinate.x -= nRadius;
    vCoordinate.y -= nRadius;
    vCoordinate.x += Random(nRadius * 2 + 1);
    vCoordinate.y += Random(nRadius * 2 + 1);

    return vCoordinate;
}

int MinInt(int a, int b)
{
    return a > b ? b : a;
}

float MinFloat(float a, float b)
{
    return a > b ? b : a;
}

int MaxInt(int a, int b)
{
    return a > b ? a : b;
}

float MaxFloat(float a, float b)
{
    return a > b ? a : b;
}

int ConvertHexToDec(string sHex)
{
    string sFirst = GetStringLeft(sHex, 1);
    string sSecond = GetStringRight(sHex, 1);
    if(sFirst == "A")
        sFirst = "10";
    else if(sFirst == "B")
        sFirst = "11";
    else if(sFirst == "C")
        sFirst = "12";
    else if(sFirst == "D")
        sFirst = "13";
    else if(sFirst == "E")
        sFirst = "14";
    else if(sFirst == "F")
        sFirst = "15";

    if(sSecond == "A")
        sSecond = "10";
    else if(sSecond == "B")
        sSecond = "11";
    else if(sSecond == "C")
        sSecond = "12";
    else if(sSecond == "D")
        sSecond = "13";
    else if(sSecond == "E")
        sSecond = "14";
    else if(sSecond == "F")
        sSecond = "15";
    int x = StringToInt(sFirst) * 16 + StringToInt(sSecond);

    return x;
}
