/* AMBIENCE Library by Gigaschatten */

#include "inc_area"
#include "inc_common"

//void main() {}

const int GS_AM_TYPE_NONE               =   0;
const int GS_AM_TYPE_EXTERIOR_RURAL     =   1;
const int GS_AM_TYPE_EXTERIOR_DESERT    =   2;
const int GS_AM_TYPE_EXTERIOR_FOREST    =   3;
const int GS_AM_TYPE_EXTERIOR_SNOW      =   4;
const int GS_AM_TYPE_SPECIAL_HELL       =   5;
const int GS_AM_TYPE_INTERIOR_ROOM      =   6;
const int GS_AM_TYPE_INTERIOR_RUIN      =   7;
const int GS_AM_TYPE_EXTERIOR_JUNGLE    =   8;
const int GS_AM_TYPE_EXTERIOR_CITY      =   9;
const int GS_AM_TYPE_EXTERIOR_HEAVEN    =  10;
const int GS_AM_TYPE_SPECIAL_FIRE       =  11;
const int GS_AM_TYPE_SPECIAL_WATER      =  12;
const int GS_AM_TYPE_SPECIAL_EARTH      =  13;
const int GS_AM_TYPE_SPECIAL_AIR        =  14;
const int GS_AM_TYPE_INTERIOR_SEWERAGE  =  15;
const int GS_AM_TYPE_INTERIOR_CAVE      =  16;
const int GS_AM_TYPE_SPECIAL_MAGIC      =  17;
const int GS_AM_TYPE_SPECIAL_NECROMANCY =  18;
const int GS_AM_TYPE_INTERIOR_UNDERDARK =  19;
const int GS_AM_TYPE_SPECIAL_EVIL       =  20;
const int GS_AM_TYPE_EXTERIOR_SWAMP     =  21;
const int GS_AM_TYPE_SPECIAL_NATURE     =  22;
const int GS_AM_TYPE_SPECIAL_ABERRATION =  23;
const int GS_AM_TYPE_SPECIAL_MARS       =  24;
const int GS_AM_TYPE_SPECIAL_SHADOW     =  25;
const int GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR = 26;

const int GS_AM_OPTION_NONE             =   0;
const int GS_AM_OPTION_LIGHTING         =   1;
const int GS_AM_OPTION_FOG              =   2;
const int GS_AM_OPTION_SKY              =   4;
const int GS_AM_OPTION_WEATHER          =   8;
const int GS_AM_OPTION_ALL              = 255;

object oAreaCache = OBJECT_INVALID;
object oModuleCache = OBJECT_INVALID;

//Initialise the cache items to use for local variable caching
void __gsAMInitCache(object oArea = OBJECT_INVALID);
//set ambience nType for oArea
void gsAMSetAmbienceType(int nType, object oArea = OBJECT_SELF);
//return ambience type of oArea
int gsAMGetAmbienceType(object oArea = OBJECT_SELF);
//set ambience nOption for oArea
void gsAMSetAmbienceOption(int nOption, object oArea = OBJECT_SELF);
//return ambience type of oArea
int gsAMGetAmbienceOption(object oArea = OBJECT_SELF);
//refresh ambience of oArea using set values
void gsAMRefreshAmbience(object oArea = OBJECT_SELF);
//apply ambience nType to oArea using nOption
void gsAMApplyAmbience(int nType, object oArea = OBJECT_SELF, int nOption = GS_AM_OPTION_ALL);
//apply weather effect to oArea
void gsAMApplyWeatherEffect(object oArea = OBJECT_SELF, int nForceUpdate = FALSE);
//initialize ambience data, to be called OnModuleLoad
void gsAMInitialize();

void __gsAMInitCache(object oArea = OBJECT_INVALID)
{
    oModuleCache = gsCMGetCacheItem("AMBIENCE");
    if (GetIsObjectValid(oArea))
        oAreaCache = gsCMGetCacheItemOnObject("AMBIENCE", oArea);
}

void gsAMSetAmbienceType(int nType, object oArea = OBJECT_SELF)
{
    SetLocalInt(oArea, "GS_AM_TYPE", nType);

    // Tell the weather system to re-learn the area's "natural" settings.
    DeleteLocalInt(oArea, "VAR_WH_INITIALIZED");
}
//----------------------------------------------------------------
int gsAMGetAmbienceType(object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_AM_TYPE");
}
//----------------------------------------------------------------
void gsAMSetAmbienceOption(int nOption, object oArea = OBJECT_SELF)
{
    SetLocalInt(oArea, "GS_AM_OPTION", nOption);
}
//----------------------------------------------------------------
int gsAMGetAmbienceOption(object oArea = OBJECT_SELF)
{
    return GetLocalInt(oArea, "GS_AM_OPTION");
}
//----------------------------------------------------------------
void gsAMRefreshAmbience(object oArea = OBJECT_SELF)
{
    gsAMApplyAmbience(
        gsAMGetAmbienceType(oArea),
        oArea,
        gsAMGetAmbienceOption(oArea));
}
//----------------------------------------------------------------
void gsAMApplyAmbience(int nType, object oArea = OBJECT_SELF, int nOption = GS_AM_OPTION_ALL)
{
    string sType       = IntToString(nType);
    int nMemorize      = ! GetLocalInt(oArea, "GS_AM_MEM");
    int nDay           = GetIsDay() || GetIsDusk();
    string sSunMoon    = nDay ? "S" : "M";
    int nFogColorSun   = FOG_COLOR_BLACK;
    int nFogColorMoon  = FOG_COLOR_BLACK;
    int nFogAmountSun  = 0;
    int nFogAmountMoon = 0;
    int nSkyBox        = SKYBOX_NONE;
    int nWeather       = WEATHER_USE_AREA_SETTINGS;
    int nFlag          = nOption & GS_AM_OPTION_LIGHTING;

    __gsAMInitCache(oArea);

    if (nMemorize)
    {
        nFogColorSun   = GetFogColor(FOG_TYPE_SUN, oArea);
        nFogColorMoon  = GetFogColor(FOG_TYPE_MOON, oArea);
        nFogAmountSun  = GetFogAmount(FOG_TYPE_SUN, oArea);
        nFogAmountMoon = GetFogAmount(FOG_TYPE_MOON, oArea);
        nSkyBox        = GetSkyBox(oArea);

        SetLocalInt(oArea, "GS_AM_FCS", nFogColorSun);
        SetLocalInt(oArea, "GS_AM_FCM", nFogColorMoon);
        SetLocalInt(oArea, "GS_AM_FAS", nFogAmountSun);
        SetLocalInt(oArea, "GS_AM_FAM", nFogAmountMoon);
        SetLocalInt(oArea, "GS_AM_SKY", nSkyBox);

        SetLocalInt(oArea, "GS_AM_FOG_COLOR_SUN",   nFogColorSun);
        SetLocalInt(oArea, "GS_AM_FOG_COLOR_MOON",  nFogColorMoon);
        SetLocalInt(oArea, "GS_AM_FOG_AMOUNT_SUN",  nFogAmountSun);
        SetLocalInt(oArea, "GS_AM_FOG_AMOUNT_MOON", nFogAmountMoon);

        SetLocalInt(oArea, "GS_AM_MEM", TRUE);
    }

    // Edit by Mith. We don't want to mess with pure-black tiles so don't
    // enter this code path unless we specifically want to mess with lighting.
    //if (nMemorize || nFlag)
    if (nFlag)
    {
        location lLocation;
        string sTagMC1             = "GS_AM_MC1" + sSunMoon + "_" + sType + "_";
        string sTagMC2             = "GS_AM_MC2" + sSunMoon + "_" + sType + "_";
        string sString             = "";
        float fSizeX               = gsARGetSizeX(oArea) / 10.0;
        float fSizeY               = gsARGetSizeY(oArea) / 10.0;
        float fX                   = 0.0;
        float fY                   = 0.0;
        int nCountMC1              = GetLocalInt(oModuleCache, sTagMC1 + "COUNT");
        int nCountMC2              = GetLocalInt(oModuleCache, sTagMC2 + "COUNT");
        int nMemorizedMainColor1   = 0;
        int nMemorizedMainColor2   = 0;
        int nMemorizedSourceColor1 = 0;
        int nMemorizedSourceColor2 = 0;
        int nSourceColor1          = GetLocalInt(oModuleCache, "GS_AM_SC1_" + sType);
        int nSourceColor2          = GetLocalInt(oModuleCache, "GS_AM_SC2_" + sType);
        int nColor1                = 0;
        int nColor2                = 0;

        if (nMemorize) // [Mith] This is now never hit - see above.
        {
            while (fX < fSizeX)
            {
                fY = 0.0;

                while (fY < fSizeY)
                {
                    lLocation = Location(oArea, Vector(fX, fY), 0.0);
                    sString   = FloatToString(fX, 0, 0) + "_" + FloatToString(fY, 0, 0);

                    nMemorizedMainColor1   = GetTileMainLight1Color(lLocation);
                    nMemorizedMainColor2   = GetTileMainLight2Color(lLocation);
                    nMemorizedSourceColor1 = GetTileSourceLight1Color(lLocation);
                    nMemorizedSourceColor2 = GetTileSourceLight2Color(lLocation);
                    SetLocalInt(oAreaCache, "GS_AM_ML1_" + sString, nMemorizedMainColor1);
                    SetLocalInt(oAreaCache, "GS_AM_ML2_" + sString, nMemorizedMainColor2);
                    SetLocalInt(oAreaCache, "GS_AM_SL1_" + sString, nMemorizedSourceColor1);
                    SetLocalInt(oAreaCache, "GS_AM_SL2_" + sString, nMemorizedSourceColor2);

                    //tile main light color
                    nColor1 = (nMemorizedMainColor1 == TILE_MAIN_LIGHT_COLOR_BLACK ||
                               nMemorizedMainColor1 == 255) ?
                               GetLocalInt(oModuleCache, sTagMC1 + IntToString(Random(nCountMC1))) :
                               nMemorizedMainColor1;
                    nColor2 = (nMemorizedMainColor2 == TILE_MAIN_LIGHT_COLOR_BLACK ||
                               nMemorizedMainColor2 == 255) ?
                               GetLocalInt(oModuleCache, sTagMC2 + IntToString(Random(nCountMC2))) :
                               nMemorizedMainColor2;

                    SetTileMainLightColor(lLocation, nColor1, nColor2);

                    //tile source light color
                    nColor1 = (nMemorizedSourceColor1 == TILE_SOURCE_LIGHT_COLOR_BLACK ||
                               nMemorizedSourceColor1 == 255) ?
                               nSourceColor1 :
                               nMemorizedSourceColor1;
                    nColor2 = (nMemorizedSourceColor2 == TILE_SOURCE_LIGHT_COLOR_BLACK ||
                               nMemorizedSourceColor2 == 255) ?
                               nSourceColor2 :
                               nMemorizedSourceColor2;

                    SetTileSourceLightColor(lLocation, nColor1, nColor2);

                    fY += 1.0;
                }

                fX += 1.0;
            }
        }
        else if (nType == GS_AM_TYPE_NONE)
        {
            while (fX < fSizeX)
            {
                fY = 0.0;

                while (fY < fSizeY)
                {
                    lLocation = Location(oArea, Vector(fX, fY), 0.0);
                    sString   = FloatToString(fX, 0, 0) + "_" + FloatToString(fY, 0, 0);

                    //tile main light color
                    nColor1   = GetLocalInt(oAreaCache, "GS_AM_ML1_" + sString);
                    nColor2   = GetLocalInt(oAreaCache, "GS_AM_ML2_" + sString);

                    SetTileMainLightColor(lLocation, nColor1, nColor2);

                    //tile source light color
                    nColor1   = GetLocalInt(oAreaCache, "GS_AM_SL1_" + sString);
                    nColor2   = GetLocalInt(oAreaCache, "GS_AM_SL2_" + sString);

                    SetTileSourceLightColor(lLocation, nColor1, nColor2);

                    fY += 1.0;
                }

                fX += 1.0;
            }
        }
        else
        {
            while (fX < fSizeX)
            {
                fY = 0.0;

                while (fY < fSizeY)
                {
                    lLocation = Location(oArea, Vector(fX, fY), 0.0);
                    sString   = FloatToString(fX, 0, 0) + "_" + FloatToString(fY, 0, 0);

                    nMemorizedMainColor1   = GetLocalInt(oAreaCache, "GS_AM_ML1_" + sString);
                    nMemorizedMainColor2   = GetLocalInt(oAreaCache, "GS_AM_ML2_" + sString);
                    nMemorizedSourceColor1 = GetLocalInt(oAreaCache, "GS_AM_SL1_" + sString);
                    nMemorizedSourceColor2 = GetLocalInt(oAreaCache, "GS_AM_SL2_" + sString);

                    //tile main light color
                    nColor1 = (nMemorizedMainColor1 == TILE_MAIN_LIGHT_COLOR_BLACK ||
                               nMemorizedMainColor1 == 255) ?
                               GetLocalInt(oModuleCache, sTagMC1 + IntToString(Random(nCountMC1))) :
                               nMemorizedMainColor1;
                    nColor2 = (nMemorizedMainColor2 == TILE_MAIN_LIGHT_COLOR_BLACK ||
                               nMemorizedMainColor2 == 255) ?
                               GetLocalInt(oModuleCache, sTagMC2 + IntToString(Random(nCountMC2))) :
                               nMemorizedMainColor2;

                    SetTileMainLightColor(lLocation, nColor1, nColor2);

                    //tile source light color
                    nColor1 = (nMemorizedSourceColor1 == TILE_SOURCE_LIGHT_COLOR_BLACK ||
                               nMemorizedSourceColor1 == 255) ?
                               nSourceColor1 :
                               nMemorizedSourceColor1;
                    nColor2 = (nMemorizedSourceColor2 == TILE_SOURCE_LIGHT_COLOR_BLACK ||
                               nMemorizedSourceColor2 == 255) ?
                               nSourceColor2 :
                               nMemorizedSourceColor2;

                    SetTileSourceLightColor(lLocation, nColor1, nColor2);

                    fY += 1.0;
                }

                fX += 1.0;
            }
        }
    }

//................................................................

    //fog
    if (!GetLocalInt(oArea, "GS_AM_FOG_OVERRIDE") &&
        (nOption & GS_AM_OPTION_FOG))
    {
        if (nType == GS_AM_TYPE_NONE)
        {
            nFogColorSun   = GetLocalInt(oArea, "GS_AM_FCS");
            nFogColorMoon  = GetLocalInt(oArea, "GS_AM_FCM");
            nFogAmountSun  = GetLocalInt(oArea, "GS_AM_FAS");
            nFogAmountMoon = GetLocalInt(oArea, "GS_AM_FAM");
        }
        else
        {
            nFogColorSun   = GetLocalInt(oModuleCache, "GS_AM_FCS_" + sType);
            nFogColorMoon  = GetLocalInt(oModuleCache, "GS_AM_FCM_" + sType);
            nFogAmountSun  = GetLocalInt(oModuleCache, "GS_AM_FAS_" + sType);
            nFogAmountMoon = GetLocalInt(oModuleCache, "GS_AM_FAM_" + sType);
        }

        SetLocalInt(oArea, "GS_AM_FOG_COLOR_SUN",   nFogColorSun);
        SetLocalInt(oArea, "GS_AM_FOG_COLOR_MOON",  nFogColorMoon);
        SetLocalInt(oArea, "GS_AM_FOG_AMOUNT_SUN",  nFogAmountSun);
        SetLocalInt(oArea, "GS_AM_FOG_AMOUNT_MOON", nFogAmountMoon);
    }

//................................................................

    //weather
    // Removed by Mith - inc_weather has replaced this code.
    /*if (nOption & GS_AM_OPTION_WEATHER)
    {
        if (nType != GS_AM_TYPE_NONE)
        {
            int nChanceRain = GetLocalInt(oModule, "GS_AM_WR_" + sType);
            int nChanceSnow = GetLocalInt(oModule, "GS_AM_WS_" + sType) + nChanceRain;
            int nNth        = Random(100);

            if (nNth < nChanceRain)      nWeather = WEATHER_RAIN;
            else if (nNth < nChanceSnow) nWeather = WEATHER_SNOW;
            else                         nWeather = WEATHER_CLEAR;
        }

        SetWeather(oArea, WEATHER_CLEAR);
        SetWeather(oArea, nWeather);
    }*/

//................................................................

    //sky
    if (!GetLocalInt(oArea, "GS_AM_SKY_OVERRIDE") &&
        (nOption & GS_AM_OPTION_SKY))
    {
        nSkyBox = nType == GS_AM_TYPE_NONE ?
                  GetLocalInt(oArea, "GS_AM_SKY") :
                  GetLocalInt(oModuleCache, "GS_AM_S" + sSunMoon + "_" + sType);

        SetSkyBox(nSkyBox, oArea);
    }

    gsAMApplyWeatherEffect(oArea, TRUE);
}
//----------------------------------------------------------------
void gsAMApplyWeatherEffect(object oArea = OBJECT_SELF, int nForceUpdate = FALSE)
{
    int nCurrentWeather  = GetWeather(oArea);
    int nPreviousWeather = GetLocalInt(oArea, "GS_AM_WEATHER");

    if (nForceUpdate || nCurrentWeather != nPreviousWeather)
    {
        int nFogColorSun   = GetLocalInt(oArea, "GS_AM_FOG_COLOR_SUN");
        int nFogColorMoon  = GetLocalInt(oArea, "GS_AM_FOG_COLOR_MOON");
        int nFogAmountSun  = GetLocalInt(oArea, "GS_AM_FOG_AMOUNT_SUN");
        int nFogAmountMoon = GetLocalInt(oArea, "GS_AM_FOG_AMOUNT_MOON");

        if (nCurrentWeather != WEATHER_CLEAR)
        {
            int nRed        = (nFogColorSun & 0xFF0000) >> 16;
            int nGreen      = (nFogColorSun & 0x00FF00) >>  8;
            int nBlue       =  nFogColorSun & 0x0000FF;
            int nAverage    = (nRed + nGreen + nBlue) / 3;

            nRed            = (nRed   + (nAverage - nRed)   / 3) * 3 / 4;
            nGreen          = (nGreen + (nAverage - nGreen) / 3) * 3 / 4;
            nBlue           = (nBlue  + (nAverage - nBlue)  / 3) * 3 / 4;
            nFogColorSun    = (nRed << 16) | (nGreen << 8) | nBlue;

            nRed            = (nFogColorMoon & 0xFF0000) >> 16;
            nGreen          = (nFogColorMoon & 0x00FF00) >>  8;
            nBlue           =  nFogColorMoon & 0x0000FF;
            nAverage        = (nRed + nGreen + nBlue) / 3;

            nRed            = (nRed   + (nAverage - nRed)   / 3) * 3 / 4;
            nGreen          = (nGreen + (nAverage - nGreen) / 3) * 3 / 4;
            nBlue           = (nBlue  + (nAverage - nBlue)  / 3) * 3 / 4;
            nFogColorMoon   = (nRed << 16) | (nGreen << 8) | nBlue;

            nFogAmountSun  += 10;
            nFogAmountMoon += 10;
        }

        SetFogColor(FOG_TYPE_SUN, nFogColorSun, oArea);
        SetFogColor(FOG_TYPE_MOON, nFogColorMoon, oArea);
        SetFogAmount(FOG_TYPE_SUN, nFogAmountSun, oArea);
        SetFogAmount(FOG_TYPE_MOON, nFogAmountMoon, oArea);

        SetLocalInt(oArea, "GS_AM_WEATHER", nCurrentWeather);

        RecomputeStaticLighting(oArea);
    }
}
//----------------------------------------------------------------
void gsAMMC(string sTag, int nColor, int nChance)
{
    sTag       += "_";
    int nCount  = GetLocalInt(oModuleCache, sTag + "COUNT");
    int nNth    = nCount;
    nChance    += nCount;

    for (; nNth < nChance; nNth++)
    {
        SetLocalInt(oModuleCache, sTag + IntToString(nNth), nColor);
    }

    SetLocalInt(oModuleCache, sTag + "COUNT", nNth);
}
//----------------------------------------------------------------
void gsAMMC1S(int nType, int nColor, int nChance = 1)
{
    gsAMMC("GS_AM_MC1S_" + IntToString(nType), nColor, nChance);
}
//----------------------------------------------------------------
void gsAMMC2S(int nType, int nColor, int nChance = 1)
{
    gsAMMC("GS_AM_MC2S_" + IntToString(nType), nColor, nChance);
}
//----------------------------------------------------------------
void gsAMMC1M(int nType, int nColor, int nChance = 1)
{
    gsAMMC("GS_AM_MC1M_" + IntToString(nType), nColor, nChance);
}
//----------------------------------------------------------------
void gsAMMC2M(int nType, int nColor, int nChance = 1)
{
    gsAMMC("GS_AM_MC2M_" + IntToString(nType), nColor, nChance);
}
//----------------------------------------------------------------
void gsAMMC1(int nType, int nColor, int nChance = 1)
{
    string sType = IntToString(nType);
    gsAMMC("GS_AM_MC1S_" + sType, nColor, nChance);
    gsAMMC("GS_AM_MC1M_" + sType, nColor, nChance);
}
//----------------------------------------------------------------
void gsAMMC2(int nType, int nColor, int nChance = 1)
{
    string sType = IntToString(nType);
    gsAMMC("GS_AM_MC2S_" + sType, nColor, nChance);
    gsAMMC("GS_AM_MC2M_" + sType, nColor, nChance);
}
//----------------------------------------------------------------
void gsAMSC(int nType, int nColor1, int nColor2)
{
    string sType = IntToString(nType);
    SetLocalInt(oModuleCache, "GS_AM_SC1_" + sType, nColor1);
    SetLocalInt(oModuleCache, "GS_AM_SC2_" + sType, nColor2);
}
//----------------------------------------------------------------
void gsAMFC(int nType, int nColorSun, int nAmountSun, int nColorMoon, int nAmountMoon)
{
    string sType = IntToString(nType);
    SetLocalInt(oModuleCache, "GS_AM_FCS_" + sType, nColorSun);
    SetLocalInt(oModuleCache, "GS_AM_FCM_" + sType, nColorMoon);
    SetLocalInt(oModuleCache, "GS_AM_FAS_" + sType, nAmountSun);
    SetLocalInt(oModuleCache, "GS_AM_FAM_" + sType, nAmountMoon);
}
//----------------------------------------------------------------
void gsAMS(int nType, int nSkySun, int nSkyMoon)
{
    string sType = IntToString(nType);
    SetLocalInt(oModuleCache, "GS_AM_SS_" + sType, nSkySun);
    SetLocalInt(oModuleCache, "GS_AM_SM_" + sType, nSkyMoon);
}
//----------------------------------------------------------------
void gsAMW(int nType, int nChanceRain, int nChanceSnow)
{
    string sType = IntToString(nType);
    SetLocalInt(oModuleCache, "GS_AM_WR_" + sType, nChanceRain);
    SetLocalInt(oModuleCache, "GS_AM_WS_" + sType, nChanceSnow);
}
//----------------------------------------------------------------
void gsAMInitialize()
{
    __gsAMInitCache();

    //GS_AM_TYPE_EXTERIOR_RURAL day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_YELLOW);

    //GS_AM_TYPE_EXTERIOR_RURAL night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_RURAL, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_RURAL,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_RURAL,
           0x93B6D9, 0,
           0x0B1A20, 1);

    gsAMS(GS_AM_TYPE_EXTERIOR_RURAL,
          SKYBOX_GRASS_CLEAR,
          SKYBOX_GRASS_CLEAR);

    gsAMW(GS_AM_TYPE_EXTERIOR_RURAL, 10, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_DESERT day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);

    //GS_AM_TYPE_EXTERIOR_DESERT night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_DESERT, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_DESERT,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_DESERT,
           0xFFD67D, 2,
           0x0C1B29, 0);

    gsAMS(GS_AM_TYPE_EXTERIOR_DESERT,
          SKYBOX_DESERT_CLEAR,
          SKYBOX_DESERT_CLEAR);

    gsAMW(GS_AM_TYPE_EXTERIOR_DESERT, 0, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_FOREST day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_YELLOW);

    //GS_AM_TYPE_EXTERIOR_FOREST night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_FOREST, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_FOREST,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_FOREST,
           0x868D5C, 2,
           0x30323A, 3);

    gsAMS(GS_AM_TYPE_EXTERIOR_FOREST,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_EXTERIOR_FOREST, 10, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_SNOW day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_WHITE);

    //GS_AM_TYPE_EXTERIOR_SNOW night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SNOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_SNOW,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_SNOW,
           0xCCD5DD, 1,
           0x30323A, 0);

    gsAMS(GS_AM_TYPE_EXTERIOR_SNOW,
          SKYBOX_WINTER_CLEAR,
          SKYBOX_WINTER_CLEAR);

    gsAMW(GS_AM_TYPE_EXTERIOR_SNOW, 0, 10);

//................................................................

    //GS_AM_TYPE_SPECIAL_HELL
    gsAMMC1(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC1(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMMC2(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_HELL, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMSC(GS_AM_TYPE_SPECIAL_HELL,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_SPECIAL_HELL,
           0x6A0000, 2,
           0x6A0000, 2);

    gsAMS(GS_AM_TYPE_SPECIAL_HELL,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_HELL, 0, 0);

//................................................................

    //GS_AM_TYPE_INTERIOR_ROOM day
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC1S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_WHITE);
    gsAMMC2S(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_YELLOW);

    //GS_AM_TYPE_INTERIOR_ROOM night
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_INTERIOR_ROOM, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_INTERIOR_ROOM,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_INTERIOR_ROOM,
           0x1C160f, 1,
           0x0b1115, 1);

    gsAMS(GS_AM_TYPE_INTERIOR_ROOM,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_INTERIOR_ROOM, 0, 0);

//................................................................

    //GS_AM_TYPE_INTERIOR_RUIN
    gsAMMC1(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_BLACK, 6);
    gsAMMC1(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_BLACK, 8);
    gsAMMC2(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_RUIN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMSC(GS_AM_TYPE_INTERIOR_RUIN,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_INTERIOR_RUIN,
           0x281E0D, 2,
           0x281E0D, 2);

    gsAMS(GS_AM_TYPE_INTERIOR_RUIN,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_INTERIOR_RUIN, 0, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_JUNGLE day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PURPLE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_RED);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_YELLOW);

    //GS_AM_TYPE_EXTERIOR_JUNGLE night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_JUNGLE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);

    gsAMSC(GS_AM_TYPE_EXTERIOR_JUNGLE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_JUNGLE,
           0xA6A444, 2,
           0x0C1B29, 0);

    gsAMS(GS_AM_TYPE_EXTERIOR_JUNGLE,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_EXTERIOR_JUNGLE, 20, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_CITY day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_WHITE);

    //GS_AM_TYPE_EXTERIOR_CITY night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_CITY, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_CITY,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_CITY,
           0xA29C7D, 1,
           0x0B1A20, 2);

    gsAMS(GS_AM_TYPE_EXTERIOR_CITY,
          SKYBOX_GRASS_CLEAR,
          SKYBOX_GRASS_CLEAR);

    gsAMW(GS_AM_TYPE_EXTERIOR_CITY, 10, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_HEAVEN day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_WHITE);

    //GS_AM_TYPE_EXTERIOR_HEAVEN night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_HEAVEN, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_EXTERIOR_HEAVEN,
           TILE_SOURCE_LIGHT_COLOR_WHITE,
           TILE_SOURCE_LIGHT_COLOR_WHITE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_HEAVEN,
           0xF5EDA4, 1,
           0x0A1741, 1);

    gsAMS(GS_AM_TYPE_EXTERIOR_HEAVEN,
          SKYBOX_WINTER_CLEAR,
          SKYBOX_WINTER_CLEAR);

    gsAMW(GS_AM_TYPE_EXTERIOR_HEAVEN, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_FIRE
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_RED);
    gsAMMC1(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_YELLOW);

    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_FIRE, TILE_MAIN_LIGHT_COLOR_YELLOW);

    gsAMSC(GS_AM_TYPE_SPECIAL_FIRE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_SPECIAL_FIRE,
           0x2C2E1F, 4,
           0x2C2E1F, 4);

    gsAMS(GS_AM_TYPE_SPECIAL_FIRE,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_FIRE, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_WATER
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);

    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_WATER, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);

    gsAMSC(GS_AM_TYPE_SPECIAL_WATER,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA);

    gsAMFC(GS_AM_TYPE_SPECIAL_WATER,
           0x386661, 6,
           0x386661, 6);

    gsAMS(GS_AM_TYPE_SPECIAL_WATER,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_WATER, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_EARTH
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EARTH, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMSC(GS_AM_TYPE_SPECIAL_EARTH,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_SPECIAL_EARTH,
           0x2E2610, 2,
           0x2E2610, 2);

    gsAMS(GS_AM_TYPE_SPECIAL_EARTH,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_EARTH, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_AIR
    gsAMMC1(GS_AM_TYPE_SPECIAL_AIR, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_AIR, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);

    gsAMMC2(GS_AM_TYPE_SPECIAL_AIR, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_AIR, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);

    gsAMSC(GS_AM_TYPE_SPECIAL_AIR,
           TILE_SOURCE_LIGHT_COLOR_PALE_BLUE,
           TILE_SOURCE_LIGHT_COLOR_PALE_BLUE);

    gsAMFC(GS_AM_TYPE_SPECIAL_AIR,
           0xDFE8F4, 3,
           0xDFE8F4, 3);

    gsAMS(GS_AM_TYPE_SPECIAL_AIR,
          SKYBOX_ICY,
          SKYBOX_ICY);

    gsAMW(GS_AM_TYPE_SPECIAL_AIR, 0, 0);

//................................................................

    //GS_AM_TYPE_INTERIOR_SEWERAGE
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_BLACK, 10);
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_BLACK, 12);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_SEWERAGE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMSC(GS_AM_TYPE_INTERIOR_SEWERAGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_INTERIOR_SEWERAGE,
           0x28280D, 2,
           0x28280D, 2);

    gsAMS(GS_AM_TYPE_INTERIOR_SEWERAGE,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_INTERIOR_SEWERAGE, 0, 0);

//................................................................

    //GS_AM_TYPE_INTERIOR_CAVE
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_BLACK, 7);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED);
    gsAMMC1(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_BLACK, 16);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW, 2);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_AQUA, 2);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW, 2);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_ORANGE, 2);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_RED, 2);
    gsAMMC2(GS_AM_TYPE_INTERIOR_CAVE, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW);

    gsAMSC(GS_AM_TYPE_INTERIOR_CAVE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_INTERIOR_CAVE,
           0x121B23, 1,
           0x121B23, 1);

    gsAMS(GS_AM_TYPE_INTERIOR_CAVE,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_INTERIOR_CAVE, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_MAGIC
    gsAMMC1(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_PURPLE);

    gsAMMC2(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MAGIC, TILE_MAIN_LIGHT_COLOR_PURPLE);

    gsAMSC(GS_AM_TYPE_SPECIAL_MAGIC,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE);

    gsAMFC(GS_AM_TYPE_SPECIAL_MAGIC,
           0x3B2347, 2,
           0x3B2347, 2);

    gsAMS(GS_AM_TYPE_SPECIAL_MAGIC,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_MAGIC, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_NECROMANCY
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NECROMANCY, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);

    gsAMSC(GS_AM_TYPE_SPECIAL_NECROMANCY,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA);

    gsAMFC(GS_AM_TYPE_SPECIAL_NECROMANCY,
           0x00382F, 5,
           0x00382F, 5);

    gsAMS(GS_AM_TYPE_SPECIAL_NECROMANCY,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_NECROMANCY, 0, 0);

//................................................................

    //GS_AM_TYPE_INTERIOR_UNDERDARK
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
    gsAMMC1(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_DIM_WHITE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_AQUA);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_BLUE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_GREEN);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_PALE_PURPLE);
    gsAMMC2(GS_AM_TYPE_INTERIOR_UNDERDARK, TILE_MAIN_LIGHT_COLOR_WHITE);

    gsAMSC(GS_AM_TYPE_INTERIOR_UNDERDARK,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA);

    gsAMFC(GS_AM_TYPE_INTERIOR_UNDERDARK,
           0x313729, 1,
           0x313729, 1);

    gsAMS(GS_AM_TYPE_INTERIOR_UNDERDARK,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_INTERIOR_UNDERDARK, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_EVIL
    gsAMMC1(GS_AM_TYPE_SPECIAL_EVIL, TILE_MAIN_LIGHT_COLOR_BLACK, 2);
    gsAMMC1(GS_AM_TYPE_SPECIAL_EVIL, TILE_MAIN_LIGHT_COLOR_DARK_RED);

    gsAMMC2(GS_AM_TYPE_SPECIAL_EVIL, TILE_MAIN_LIGHT_COLOR_BLACK, 3);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EVIL, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_EVIL, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMSC(GS_AM_TYPE_SPECIAL_EVIL,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED);

    gsAMFC(GS_AM_TYPE_SPECIAL_EVIL,
           0x4D0000, 1,
           0x4D0000, 1);

    gsAMS(GS_AM_TYPE_SPECIAL_EVIL,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_EVIL, 0, 0);

//................................................................

    //GS_AM_TYPE_EXTERIOR_SWAMP day
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2S(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    //GS_AM_TYPE_EXTERIOR_SWAMP night
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC1M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);

    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE);
    gsAMMC2M(GS_AM_TYPE_EXTERIOR_SWAMP, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);

    gsAMSC(GS_AM_TYPE_EXTERIOR_SWAMP,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_EXTERIOR_SWAMP,
           0x8B6827, 3,
           0x1A3129, 5);

    gsAMS(GS_AM_TYPE_EXTERIOR_SWAMP,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_EXTERIOR_SWAMP, 20, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_NATURE
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_DARK_YELLOW);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_NATURE, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW);

    gsAMSC(GS_AM_TYPE_SPECIAL_NATURE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN);

    gsAMFC(GS_AM_TYPE_SPECIAL_NATURE,
           0x2C3312, 2,
           0x2C3312, 2);

    gsAMS(GS_AM_TYPE_SPECIAL_NATURE,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_NATURE, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_ABERRATION
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_PURPLE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_BLACK);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_BLUE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_PURPLE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_ABERRATION, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMSC(GS_AM_TYPE_SPECIAL_ABERRATION,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE);

    gsAMFC(GS_AM_TYPE_SPECIAL_ABERRATION,
           0x33001D, 1,
           0x33001D, 1);

    gsAMS(GS_AM_TYPE_SPECIAL_ABERRATION,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_ABERRATION, 0, 0);

//................................................................

    //GS_AM_TYPE_SPECIAL_MARS
    gsAMMC1(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC1(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMMC2(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_DARK_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_DARK_RED);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_ORANGE);
    gsAMMC2(GS_AM_TYPE_SPECIAL_MARS, TILE_MAIN_LIGHT_COLOR_RED);

    gsAMSC(GS_AM_TYPE_SPECIAL_MARS,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE,
           TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE);

    gsAMFC(GS_AM_TYPE_SPECIAL_MARS,
           0xA66634, 2,
           0xA66634, 2);

    gsAMS(GS_AM_TYPE_SPECIAL_MARS,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_MARS, 0, 0);

//................................................................

   // GS_AM_TYPE_SPECIAL_SHADOW
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_BLACK, 5);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_AQUA);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);

   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW, TILE_MAIN_LIGHT_COLOR_PURPLE);

   gsAMSC(GS_AM_TYPE_SPECIAL_SHADOW,
          TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE,
          TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE);

   gsAMFC(GS_AM_TYPE_SPECIAL_SHADOW,
          0x777777, 85,
          0x777777, 85);

    gsAMS(GS_AM_TYPE_SPECIAL_SHADOW,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_SHADOW, 0, 0);

   // GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_BLACK, 5);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_PURPLE);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_AQUA);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_DARK_AQUA);
   gsAMMC1(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA);

   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE);
   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE);
   gsAMMC2(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, TILE_MAIN_LIGHT_COLOR_PURPLE);

   gsAMSC(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR,
          TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE,
          TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE);

   gsAMFC(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR,
          0x777777, 50,
          0x777777, 50);

    gsAMS(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR,
          SKYBOX_NONE,
          SKYBOX_NONE);

    gsAMW(GS_AM_TYPE_SPECIAL_SHADOW_INTERIOR, 0, 0);
}
