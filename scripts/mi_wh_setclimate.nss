#include "inc_weather"
void main()
{
  object oArea = GetArea(OBJECT_SELF);
  string sTag = GetTag(OBJECT_SELF);

  // Natural climates
  if (sTag == "CLIMATE_COLD") SetLocalInt(oArea, VAR_WEATHER_HEAT, CLIMATE_HEAT_COLD);
  else if (sTag == "CLIMATE_HOT") SetLocalInt(oArea, VAR_WEATHER_HEAT, CLIMATE_HEAT_HOT);
  else if (sTag == "CLIMATE_WET") SetLocalInt(oArea, VAR_WEATHER_HUMIDITY, CLIMATE_HUMIDITY_WET);
  else if (sTag == "CLIMATE_DRY") SetLocalInt(oArea, VAR_WEATHER_HUMIDITY, CLIMATE_HUMIDITY_DRY);
  else if (sTag == "CLIMATE_SHELTERED") SetLocalInt(oArea, VAR_WEATHER_WIND, CLIMATE_WIND_SHELTERED);
  else if (sTag == "CLIMATE_EXPOSED") SetLocalInt(oArea, VAR_WEATHER_WIND, CLIMATE_WIND_EXPOSED);

  // Unnatural climates
  else if (sTag == "CLIMATE_ACID_RAIN") SetLocalInt(oArea, VAR_WEATHER_ACID_RAIN, TRUE);
  else if (sTag == "CLIMATE_VERY_COLD") SetLocalInt(oArea, VAR_WEATHER_HEAT, CLIMATE_HEAT_VERY_COLD);
  else if (sTag == "CLIMATE_VERY_HOT") SetLocalInt(oArea, VAR_WEATHER_HEAT, CLIMATE_HEAT_VERY_HOT);
  else if (sTag == "CLIMATE_VERY_WET") SetLocalInt(oArea, VAR_WEATHER_HUMIDITY, CLIMATE_HUMIDITY_VERY_WET);
  else if (sTag == "CLIMATE_VERY_DRY") SetLocalInt(oArea, VAR_WEATHER_HUMIDITY, CLIMATE_HUMIDITY_VERY_DRY);
  else if (sTag == "CLIMATE_VETY_SHELTERED") SetLocalInt(oArea, VAR_WEATHER_WIND, CLIMATE_WIND_VERY_SHELTERED);
  else if (sTag == "CLIMATE_VERY_EXPOSED") SetLocalInt(oArea, VAR_WEATHER_WIND, CLIMATE_WIND_VERY_EXPOSED);

  DestroyObject (OBJECT_SELF);
}
