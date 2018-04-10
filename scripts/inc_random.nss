// This file exposes an API which provides useful random number generation capabilities.

// ----- PUBLIC API ------

// Returns random value between the two values provided.
int ClampedRandom(int min, int max);

// Given a percentage between 0.0f and 100.0f, returns TRUE or FALSE.
// If you pass in 25.0f, you have a 25% chance to receive TRUE back.
int PercentageRandom(float percentage);

//
// -----
//

int ClampedRandom(int min, int max)
{
    return min + Random((max - min + 1));
}

int PercentageRandom(float percentage)
{
    if (percentage == 0.0f)
    {
        return FALSE;
    }

    int randMax = 65000;
    int toMatch = FloatToInt(randMax / (100.0f / percentage));
    return Random(randMax) <= toMatch;
}
