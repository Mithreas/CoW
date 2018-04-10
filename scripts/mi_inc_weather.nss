/*
  Name: mi_inc_weather
  Author: Mithreas
  Date: 29 May 08
  Description:  Implements a module wide weather system.

   Integration:
    * Call miWHAdjustWeather() every hour in the module's heartbeat script
    * Call miWHDoWeatherEffects() every hour in the module's heartbeat script
      for each PC
    * Call miWHDoWeatherEffects() in each area's OnAreaEnter script
    * Call miWHSetWeather() in each area's OnAreaEnter initialization and
      re-initialization sections
    * Optional: set all areas to 0% rain/snow (their weather will be overridden)
    * Optional: place area property objects as follows.
      * Climate: Wet or Climate: Dry for especially damp/dry areas
      * Climate: Hot or Climate: Cold for especially warm/cool areas
      * Climate: Sheltered or Climate: Exposed ...etc.
    * Call miWHDoCombatChecks() for each PC or NPC in combat, each round
    * Call miWHDoWeatherEffects() for each creature that spawns

   Functionality:
    All three scales range from a score of 1 to 10.  Depending on the score
    different effects occur as follows.
     Heat
      rain turns to snow when heat < 4
     Humidity
      water rate drops by additional 0.5 per humidity point under 5
      rain/snow happens if humidity > 7
     Wind
      All creatures get 10% speed reduction when wind > 8
      Characters in combat must pass a discipline check or reflex save vs a DC
       of 10 + character level every round or be KD'd when wind == 10.
      Weather changes faster when wind is higher.

    Weather changes every 11 game hours minus the wind score.
*/
#include "gs_inc_fixture"
#include "gs_inc_spell"
#include "mi_log"

//--[
const string FB_T_WEATHER_LIGHTNING = "You were hit by the bolt of lightning!";
const string FB_T_WEATHER_MESSAGE_CLOUDY = "There are a fair few clouds overhead, and it is quite windy.";
const string FB_T_WEATHER_MESSAGE_COLD_CLOUDY = "It is cold out, and clouds are prominent overhead. Wrapping up warm is advised.";
const string FB_T_WEATHER_MESSAGE_COLD_FOGGY = "The wind is strong, and pretty cold. Make sure you are warm enough, and be wary of rain.";
const string FB_T_WEATHER_MESSAGE_COLD_MILD = "It is quite cold out. Wrap up warm by wearing winter clothing.";
const string FB_T_WEATHER_MESSAGE_FREEZING = "The air is bitingly cold right now. Make sure you are wrapped up warm and have plenty of rations.";
const string FB_T_WEATHER_MESSAGE_FOGGY = "The wind is very strong, and there are many clouds in the sky. It is likely to rain soon.";
const string FB_T_WEATHER_MESSAGE_MILD = "It is lovely and sunny here.";
const string FB_T_WEATHER_MESSAGE_MILD_NIGHT = "The weather is fine tonight.";
const string FB_T_WEATHER_MESSAGE_MIST = "It is still and very humid, the mist hangs in the air about you.";
const string FB_T_WEATHER_MESSAGE_WARM_CLOUDY = "It is hot, and clouds are dotted around. Travels will be tiring - you should wear light clothing.";
const string FB_T_WEATHER_MESSAGE_WARM_FOGGY = "Warm gusts of wind ripple the air here, and there are a worrying number of clouds casting shadows over the earth. We might experience thunderstorms, so be careful.";
const string FB_T_WEATHER_MESSAGE_WARM_MILD = "It is warm and calm here. Make sure you have enough to drink in the extra heat, and wear light clothing.";
const string FB_T_WEATHER_MESSAGE_RAIN_NORMAL = "It is raining. Your travels will be a little difficult because of it.";
const string FB_T_WEATHER_MESSAGE_RAIN_WARM = "It is raining, and the air is humid. Thunderstorms are likely, and it will be more difficult to make progress on your journey.";
const string FB_T_WEATHER_MESSAGE_SCORCHING = "The heat is blazing here! You should wear something to protect your face and hands, if you can.";
const string FB_T_WEATHER_MESSAGE_SNOW = "It is snowing right now! Remember to wrap up warm and pack extra provisions.";
const string FB_T_WEATHER_MESSAGE_STORM = "There is a thunderstorm at the moment. It will be quite dangerous out.";
//]--

// Call every hour in module heartbeat.  Updates the global weather settings
// and sets the appropriate weather in all areas with PCs in.
void miWHAdjustWeather();
// Call in all area enter scripts.  Sets the current weather in the area to
// reflect the global weather settings.
void miWHSetWeather(object oArea = OBJECT_SELF);
// Retrieve the current WEATHER_* weather type.
int miWHGetWeather(object oArea = OBJECT_SELF);
// Call each round on PCs in combat.  If the area is very windy, characters may
// be knocked over.
void miWHDoCombatChecks(object oPC);
// Applies acid rain damage.
void miWHApplyAcid(object oTarget, object oArea);
// Call on spawned creatures to apply the weather effects for their area (e.g.
// speed reduction if it's windy).
void miWHDoWeatherEffects(object oCreature);
// Internally used: removes existing weather effects.
void _miWHDoWeatherEffects(object oCreature);
// Retrieves the current heat index, adjusted for oArea's settings.  If oArea is
// invalid, uses the global value.
int miWHGetHeatIndex(object oArea = OBJECT_INVALID);
// Retrieves the current humidity, adjusted for oArea's settings.  If oArea is
// invalid, uses the global value.
int miWHGetHumidity(object oArea = OBJECT_INVALID);
// Retrieves the current wind strength, adjusted for oArea's settings.  If oArea
// is invalid, uses the global value.
int miWHGetWindStrength(object oArea = OBJECT_INVALID);
// Internal method to set the current global heat index.
void _miWHSetHeatIndex(int nHeat);
// Internal method to set the current global humidity
void _miWHSetHumidity(int nHumidity);
// Internal method to set the current global wind strength.
void _miWHSetWindStrength(int nWind);
// Internal method to process the KD effect on characters in windy areas.
// Calling method should only call this method after checking wind strength.
void _miWHDoWindKnockdown(object oPC);
// Randomly calls down a bolt to slap some creatures somewhere.
void fbWHThunderstorm(object oArea);
// Internally used.
void _fbWHThunderstorm(location lLocation, int nPower);

const string VAR_WEATHER_CHANGE    = "VAR_WEATHER_CHANGE";
const string VAR_WEATHER_HEAT      = "VAR_WEATHER_HEAT";
const string VAR_WEATHER_HUMIDITY  = "VAR_WEATHER_HUMIDITY";
const string VAR_WEATHER_MIST      = "VAR_WEATHER_MIST";
const string VAR_WEATHER_WIND      = "VAR_WEATHER_WIND";
const string VAR_WEATHER_ACID_RAIN = "VAR_WEATHER_ACID_RAIN";

const string VAR_EFFECTOR    = "VAR_WH_EFFECTOR";
const string VAR_INITIALIZED = "VAR_WH_INITIALIZED";
const string VAR_SKYBOX      = "VAR_WH_SKYBOX";
const string VAR_TIMESTAMP   = "VAR_WH_TIMESTAMP";
const string VAR_FOG_SUN     = "VAR_WH_FOG_SUN";
const string VAR_FOG_MOON    = "VAR_WH_FOG_MOON";
const string VAR_FOG_C_SUN   = "VAR_WH_FOG_C_SUN";
const string VAR_FOG_C_MOON  = "VAR_WH_FOG_C_MOON";

const int CLIMATE_HEAT_VERY_COLD = -8;
const int CLIMATE_HEAT_COLD      = -4;
const int CLIMATE_HEAT_NORMAL    = 0;
const int CLIMATE_HEAT_HOT       = 4;
const int CLIMATE_HEAT_VERY_HOT  = 8;

const int CLIMATE_HUMIDITY_VERY_WET = 6;
const int CLIMATE_HUMIDITY_WET      = 2;
const int CLIMATE_HUMIDITY_NORMAL   = 0;
const int CLIMATE_HUMIDITY_DRY      = -2;
const int CLIMATE_HUMIDITY_VERY_DRY = -6;

const int CLIMATE_WIND_VERY_SHELTERED = -6;
const int CLIMATE_WIND_SHELTERED      = -2;
const int CLIMATE_WIND_NORMAL         = 0;
const int CLIMATE_WIND_EXPOSED        = 1;
const int CLIMATE_WIND_VERY_EXPOSED   = 4;

// WEATHER_CLEAR = 0, WEATHER_RAIN = 1, WEATHER_SNOW = 2
const int WEATHER_FOGGY = 3;

const string WEATHER = "WEATHER"; // for tracing

void miWHAdjustWeather()
{
    Trace(WEATHER, "Adjusting module weather");
    object oMod = GetModule();

    //--------------------------------------------------------------------------
    // Always change the weather the very first time
    //--------------------------------------------------------------------------
    if (!GetLocalInt(oMod, VAR_INITIALIZED))
    {
        SetLocalInt(oMod, VAR_INITIALIZED, TRUE);
        _miWHSetHumidity(Random(10) + 1);
    }
    else if (GetTimeHour() != GetLocalInt(oMod, VAR_WEATHER_CHANGE))
    {
        Trace(WEATHER, "No change needed... yet.");
        return;
    }

    //--------------------------------------------------------------------------
    // Adjust the indices.  Only humidity is affected by the current values.
    //--------------------------------------------------------------------------
    int nHeat     = miWHGetHeatIndex();
    int nHumidity = miWHGetHumidity();
    int nWind     = miWHGetWindStrength();

    //--------------------------------------------------------------------------
    // Heat is affected by time of year.
    //--------------------------------------------------------------------------
    nHeat = Random(5) + (6 - abs(GetCalendarMonth() - 6)); // (0-4 + 0-6)
    if (nHeat < 1) nHeat = 1;

    //--------------------------------------------------------------------------
    // Humidity is random but moves slowly.
    //--------------------------------------------------------------------------
    nHumidity = nHumidity + (Random(2 * nWind + 1) - nWind);
    if (nHumidity > 10) nHumidity = 20 - nHumidity;
    if (nHumidity < 1) nHumidity = 1 - nHumidity;

    //--------------------------------------------------------------------------
    // Wind is more likely to be calm, but can change quickly.
    //--------------------------------------------------------------------------
    nWind = d10(2) - 10;
    if (nWind < 1) nWind = 1 - nWind;

    Trace(WEATHER, "New weather settings: heat - " + IntToString(nHeat) +
                                   ", humidity - " + IntToString(nHumidity) +
                                       ", wind - " + IntToString(nWind));

    _miWHSetHeatIndex(nHeat);
    _miWHSetHumidity(nHumidity);
    _miWHSetWindStrength(nWind);

    //--------------------------------------------------------------------------
    // Work out when to next change the weather.
    //--------------------------------------------------------------------------
    int nNextChange = GetTimeHour() + (11 - nWind);
    if (nNextChange > 23) nNextChange -= 24;
    Trace(WEATHER, "Change the weather next at hour " + IntToString(nNextChange));
    SetLocalInt(oMod, VAR_WEATHER_CHANGE, nNextChange);

    // Update all occupied areas with the new settings.
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
      miWHSetWeather(GetArea(oPC));
      oPC = GetNextPC();
    }
}

void miWHSetWeather(object oArea = OBJECT_SELF)
{
    if (!GetLocalInt(oArea, VAR_INITIALIZED))
    {
        if (GetIsAreaInterior(oArea) ||
            !GetIsAreaAboveGround(oArea))
            return;
        SetLocalInt(oArea, VAR_SKYBOX, GetSkyBox(oArea));
        SetLocalInt(oArea, VAR_FOG_SUN, GetFogAmount(FOG_TYPE_SUN, oArea));
        SetLocalInt(oArea, VAR_FOG_MOON, GetFogAmount(FOG_TYPE_MOON, oArea));
        SetLocalInt(oArea, VAR_FOG_C_SUN, GetFogColor(FOG_TYPE_SUN, oArea));
        SetLocalInt(oArea, VAR_FOG_C_MOON, GetFogColor(FOG_TYPE_MOON, oArea));
        SetLocalInt(oArea, VAR_INITIALIZED, TRUE);
    }

    int nHeat     = miWHGetHeatIndex(oArea);
    int nHumidity = miWHGetHumidity(oArea);
    int nWind     = miWHGetWindStrength(oArea);
    int bStormy   = GetSkyBox(oArea) == SKYBOX_GRASS_STORM;
    int bFoggy    = FALSE;

    Trace(WEATHER, "Area weather settings for area: " + GetName(oArea) +
                                          ", heat - " + IntToString(nHeat) +
                                      ", humidity - " + IntToString(nHumidity) +
                                          ", wind - " + IntToString(nWind) +
                                         ", storm - " + IntToString(bStormy));

    //--------------------------------------------------------------------------
    // Process weather rules for this area.
    //--------------------------------------------------------------------------
    if (nHumidity > 7 && nHeat > 3)
    {
      if (nHeat < 6 && nWind < 3)
      {
        SetWeather(oArea, WEATHER_CLEAR);
        bFoggy = FALSE ;  // Fog disabled :(
      }
      else SetWeather(oArea, WEATHER_RAIN);
    }
    else if (nHumidity > 7)         SetWeather(oArea, WEATHER_SNOW);
    else                            SetWeather(oArea, WEATHER_CLEAR);

    //--------------------------------------------------------------------------
    // Stormy if heat is greater than 4 only; if already stormy then 2 in 3
    // chance of storm clearing, otherwise x in 20 chance of storm starting,
    // where x is the wind level.
    //--------------------------------------------------------------------------
    if (nHeat > 4 && nHumidity > 7 &&
        ((!bStormy && d20() - nWind < 1) || (bStormy && d3() == 1)))
    {
        Trace(WEATHER, "A thunderstorm is now raging in "+GetName(oArea));
        SetSkyBox(SKYBOX_GRASS_STORM, oArea);
        fbWHThunderstorm(oArea);
        SetLocalInt(oArea, "GS_AM_SKY_OVERRIDE", TRUE);
    }
    else
    {
        SetSkyBox(GetLocalInt(oArea, VAR_SKYBOX), oArea);
        DeleteLocalInt(oArea, "GS_AM_SKY_OVERRIDE");
    }

    if (bFoggy)
    {
        SetFogAmount(FOG_TYPE_ALL, 35, oArea);
        SetFogColor(FOG_TYPE_ALL, 0xEEEEEE, oArea);
        SetLocalInt(oArea, "GS_AM_FOG_OVERRIDE", TRUE);
    }
    else
    {
        SetFogAmount(FOG_TYPE_SUN, GetLocalInt(oArea,VAR_FOG_SUN), oArea);
        SetFogAmount(FOG_TYPE_MOON, GetLocalInt(oArea,VAR_FOG_MOON), oArea);
        SetFogColor(FOG_TYPE_SUN, GetLocalInt(oArea,VAR_FOG_C_SUN), oArea);
        SetFogColor(FOG_TYPE_MOON, GetLocalInt(oArea,VAR_FOG_C_MOON), oArea);
        DeleteLocalInt(oArea, "GS_AM_FOG_OVERRIDE");
    }
}

int miWHGetWeather(object oArea = OBJECT_SELF)
{
    if (GetIsAreaInterior(oArea) || !GetIsAreaAboveGround(oArea))
	{
	  return WEATHER_INVALID;
	}

    int nHeat     = miWHGetHeatIndex(oArea);
    int nHumidity = miWHGetHumidity(oArea);
    int nWind     = miWHGetWindStrength(oArea);
	
	if (nHumidity > 7 && nHeat > 3 && nHeat < 6 && nWind < 3)
	{
	  return WEATHER_FOGGY;
	}
	
	return GetWeather(oArea);
}

void miWHDoCombatChecks(object oCreature)
{
    object oArea = GetArea(oCreature);
    if (!GetLocalInt(oArea, VAR_INITIALIZED))
        return;

    int nWind = miWHGetWindStrength(oArea);

    if (nWind > 9) _miWHDoWindKnockdown(oCreature);
}

void miWHApplyAcid(object oTarget, object oArea)
{
    if (GetArea(oTarget) != oArea) return;
    if (GetIsDead(oTarget)) return;
    if (!GetIsPC(oTarget) && !GetIsPC(GetMaster(oTarget))) return;

    //apply
    effect eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_S),
            EffectDamage(
                gsSPGetDamage(1, 6, METAMAGIC_NONE),
                DAMAGE_TYPE_ACID));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);

    DelayCommand(6.0, miWHApplyAcid(oTarget, oArea));
}

void miWHDoWeatherEffects(object oCreature)
{
    object oArea  = GetArea(oCreature);
    if (GetIsAreaInterior(oArea) || !GetIsAreaAboveGround(oArea)) return;

    if (!GetLocalInt(oArea, VAR_INITIALIZED))
    {
        _miWHDoWeatherEffects(oCreature);
    }
    int nHeat     = miWHGetHeatIndex(oArea);
    int nHumidity = miWHGetHumidity(oArea);
    int nWind     = miWHGetWindStrength(oArea);
    int bStormy   = GetSkyBox(oArea) == SKYBOX_GRASS_STORM;

    //--------------------------------------------------------------------------
    // Apply bonuses/penalties based on clothing
    //--------------------------------------------------------------------------
    //object oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
    //object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
    //if (GetIsObjectValid(oCloak))
    //    nHeat += 1;
    //if (!GetIsObjectValid(oBoots))
    //    nHeat -= 1;

    // Apply acid rain, if applicable.  Stolen shamelessly from the Melf's Acid
    // Arrow spell.
    if (GetWeather(oArea) == WEATHER_RAIN && GetLocalInt(oArea, VAR_WEATHER_ACID_RAIN))
    {
      effect eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_IMP_ACID_S),
            EffectDamage(
                gsSPGetDamage(2, 6, METAMAGIC_NONE),
                DAMAGE_TYPE_ACID));

      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oCreature);

      DelayCommand(
            6.0,
            miWHApplyAcid(oCreature, oArea));
     }

    int bIsPC = GetIsPC(oCreature);

    //--------------------------------------------------------------------------
    // Apply modifiers to this creature.
    //--------------------------------------------------------------------------
    if (nWind > 8)
    {
        SetLocalString(oCreature, VAR_EFFECTOR, GetTag(oArea));
        //----------------------------------------------------------------------
        // Apply move penalty - removed - too buggy. e.g. stacks.
        //----------------------------------------------------------------------
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        //                    SupernaturalEffect(EffectMovementSpeedDecrease(10)),
        //                    oCreature);
    }
    else
    {
        _miWHDoWeatherEffects(oCreature);
    }

    if (nHeat > 8)
    {
        //ApplyEffectToObject(DURATION_TYPE_INSTANT,
        //                    EffectDamage(nHeat - 8, DAMAGE_TYPE_FIRE),
        //                    oCreature);
    }
    else if (nHeat < 3)
    {
        //ApplyEffectToObject(DURATION_TYPE_INSTANT,
        //                    EffectDamage(3 - nHeat, DAMAGE_TYPE_COLD),
        //                    oCreature);
    }

    if (bIsPC)
    {
        string sMessage = "";
        // Stormy weather
        if (bStormy)
        {
            sMessage = FB_T_WEATHER_MESSAGE_STORM;
        }
        // Rain or mist
        else if (nHumidity > 7 && nHeat > 3)
        {
            // Mist
            if (nWind < 3)
            {
              sMessage = FB_T_WEATHER_MESSAGE_MIST;
            }
            // Humid
            else if (nHeat > 7)
            {
                sMessage = FB_T_WEATHER_MESSAGE_RAIN_WARM;
            }
            else
            {
                sMessage = FB_T_WEATHER_MESSAGE_RAIN_NORMAL;
            }
        }
        // Snow
        else if (nHumidity > 7)
        {
            sMessage = FB_T_WEATHER_MESSAGE_SNOW;
        }
        // Freezing
        else if (nHeat < 3)
        {
            sMessage = FB_T_WEATHER_MESSAGE_FREEZING;
        }
        // Boiling
        else if (nHeat > 8)
        {
            sMessage = FB_T_WEATHER_MESSAGE_SCORCHING;
        }
        // Cold
        else if (nHeat < 5)
        {
            if (nWind < 5)      sMessage = FB_T_WEATHER_MESSAGE_COLD_MILD;
            else if (nWind < 8) sMessage = FB_T_WEATHER_MESSAGE_COLD_CLOUDY;
            else                sMessage = FB_T_WEATHER_MESSAGE_COLD_FOGGY;
        }
        // Hot
        else if (nHeat > 6)
        {
            if (nWind < 5)      sMessage = FB_T_WEATHER_MESSAGE_WARM_MILD;
            else if (nWind < 8) sMessage = FB_T_WEATHER_MESSAGE_WARM_CLOUDY;
            else                sMessage = FB_T_WEATHER_MESSAGE_WARM_FOGGY;
        }
        else if (nWind < 5)
        {
            if (!GetIsNight()) sMessage = FB_T_WEATHER_MESSAGE_MILD;
            else               sMessage = FB_T_WEATHER_MESSAGE_MILD_NIGHT;
        }
        else if (nWind < 8) sMessage = FB_T_WEATHER_MESSAGE_CLOUDY;
        else                sMessage = FB_T_WEATHER_MESSAGE_FOGGY;

        SendMessageToPC(oCreature, sMessage);
    }
}
void _miWHDoWeatherEffects(object oCreature)
{
    //----------------------------------------------------------------------
    // Remove all previous penalties
    //----------------------------------------------------------------------
    object oOldArea = GetObjectByTag(GetLocalString(oCreature, VAR_EFFECTOR));
    if (GetIsObjectValid(oOldArea))
    {
        effect eBad = GetFirstEffect(oCreature);
        while (GetIsEffectValid(eBad))
        {
            if (GetEffectCreator(eBad) == oOldArea)
                RemoveEffect(oCreature, eBad);
            eBad = GetNextEffect(oCreature);
        }
    }
}

int miWHGetHeatIndex(object oArea = OBJECT_INVALID)
{
    //--------------------------------------------------------------------------
    // Areas will have one of the CLIMATE_* values stored in each weather var.
    //--------------------------------------------------------------------------
    int nHeat = GetLocalInt(GetModule(), VAR_WEATHER_HEAT);
    nHeat    += GetLocalInt(oArea, VAR_WEATHER_HEAT);
    nHeat = (GetIsNight()) ? nHeat - 1 : nHeat + 1;
    return nHeat;
}

int miWHGetHumidity(object oArea = OBJECT_INVALID)
{
    //--------------------------------------------------------------------------
    // Areas will have one of the CLIMATE_* values stored in each weather var.
    //--------------------------------------------------------------------------
    int nHumidity = GetLocalInt(GetModule(), VAR_WEATHER_HUMIDITY);
    nHumidity    += GetLocalInt(oArea, VAR_WEATHER_HUMIDITY);
    return nHumidity;
}

int miWHGetWindStrength(object oArea = OBJECT_INVALID)
{
    //--------------------------------------------------------------------------
    // Areas will have one of the CLIMATE_* values stored in each weather var.
    //--------------------------------------------------------------------------
    int nWind = GetLocalInt(GetModule(), VAR_WEATHER_WIND);
    nWind    += GetLocalInt(oArea, VAR_WEATHER_WIND);
    //--------------------------------------------------------------------------
    // Automatic cover bonus for artificial areas such as cities (lots of
    // buildings).
    //--------------------------------------------------------------------------
    if (!GetIsAreaNatural(oArea)) nWind -= 1;
    return nWind;
}

void _miWHSetHeatIndex(int nHeat)
{
    SetLocalInt(GetModule(), VAR_WEATHER_HEAT, nHeat);
}
void _miWHSetHumidity(int nHumidity)
{
    SetLocalInt(GetModule(), VAR_WEATHER_HUMIDITY, nHumidity);
}
void _miWHSetWindStrength(int nWind)
{
    SetLocalInt(GetModule(), VAR_WEATHER_WIND, nWind);
}
void _miWHDoWindKnockdown(object oCreature)
{
    Trace(WEATHER, "Checking whether " + GetName(oCreature) + " is blown over");
    int nDC = (GetHitDice(oCreature) / 2) + 10;
    int nDiscipline = GetSkillRank(SKILL_DISCIPLINE, oCreature);
    int nReflexSave = GetReflexSavingThrow(oCreature);
    int nSuccess;

    if (nDiscipline > nReflexSave)
        nSuccess = GetIsSkillSuccessful(oCreature, SKILL_DISCIPLINE, nDC);
    else
        nSuccess = ReflexSave(oCreature, nDC);

    if (!nSuccess)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectKnockdown(),
                            oCreature,
                            6.0);
        AssignCommand(oCreature, SpeakString("*is unbalanced by a strong gust*"));
    }
}
void fbWHThunderstorm(object oArea)
{
    // 1 in 3 chance of a bolt.
    if (d3() != 1) return;

    // Pick a spot. Any spot.
    int nWidth = GetAreaSize(AREA_WIDTH, oArea);
    int nHeight = GetAreaSize(AREA_HEIGHT, oArea);
    int nPointWide = Random(nWidth * 10);
    int nPointHigh = Random(nHeight * 10);
    float fStrikeX = IntToFloat(nPointWide) + (IntToFloat(Random(10)) * 0.1);
    float fStrikeY = IntToFloat(nPointHigh) + (IntToFloat(Random(10)) * 0.1);

    // Now find out the power
    int nPower = d100() + 10;

    // Fire ze thunderboltz!
    DelayCommand(IntToFloat(Random(60)),
                 _fbWHThunderstorm(Location(oArea,
                                            Vector(fStrikeX, fStrikeY),
                                            0.0),
                                   nPower)
                 );
}
void _fbWHThunderstorm(location lLocation, int nPower)
{
    float fRange = IntToFloat(nPower) * 0.1;
    // Caps on sphere of influence
    if (fRange < 3.0) fRange = 3.0;
    if (fRange > 6.0) fRange = 6.0;

    //Effects
    effect eEffBolt   = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eEffKnock  = EffectKnockdown();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffBolt, lLocation);

    effect eEffDam;
    int nType;
    int nPain;
    object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oObject) == TRUE)
    {
        nType = GetObjectType(oObject);
        if (nType & (OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE))
        {
            eEffDam = EffectDamage(
                FloatToInt(IntToFloat(nPower) - (GetDistanceBetweenLocations(lLocation, GetLocation(oObject)) * 10)),
                DAMAGE_TYPE_ELECTRICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffDam, oObject);

            if (nType == OBJECT_TYPE_CREATURE)
            {
                if (GetIsPC(oObject)) SendMessageToPC(oObject, FB_T_WEATHER_LIGHTNING);

                PlayVoiceChat(VOICE_CHAT_PAIN1,oObject);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffKnock, oObject, IntToFloat(d6(1)));
            }
            else if (nType == OBJECT_TYPE_PLACEABLE && GetStringLeft(GetTag(oObject), 6) == "GS_FX_")
            {
                Log(FIXTURES, "Fixture " + GetName(oObject) + " was struck by lightning");
                SetLocalInt(oObject, "GVD_REMAINS_LIGHTNINGSTRIKE", 1);
                DestroyObject(oObject);
            }
        }
        oObject = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
