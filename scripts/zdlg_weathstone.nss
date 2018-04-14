#include "inc_weather"
#include "inc_zdlg"
#include "zzdlg_color_inc"

const string MAIN_SELECTIONS = "MAIN_SELECTIONS";
const string WEATHER_SELECTIONS = "WEATHER_SELECTIONS";

//::  Alters the weather across the isle globally with the given parameters.
//::  Also removes 50 XP from the PC using this power.
void AlterWeather(object oPC, int nHeat, int nHumidity, int nWind);

//::  Based on the 'miWHAdjustWeather' function from  inc_weather but makes
//::  certain the applied effects from the weather stone happens EVERYWHERE no matter
//::  an area's climate.  Giving a more forced effect.
void ExAdjustWeather();


void Init()
{
    object oPC = GetPcDlgSpeaker();
    SetDlgPageString("root");

    //::  Removes all previous elements, we do this so we can setup MAIN_SELECTIONS differently
    //RemoveElements(0, GetElementCount(MAIN_SELECTIONS), MAIN_SELECTIONS, OBJECT_SELF);

    if (GetElementCount(MAIN_SELECTIONS) == 0)
    {
        AddStringElement("Change the Weather.", MAIN_SELECTIONS);
        AddStringElement(txtRed + "[Leave]</c>", MAIN_SELECTIONS);
    }

    if (GetElementCount(WEATHER_SELECTIONS) == 0)
    {
        AddStringElement("<c þ >Change to Cold.</c>", WEATHER_SELECTIONS);
        AddStringElement("<c þ >Change to Storms.</c>", WEATHER_SELECTIONS);
        AddStringElement("<c þ >Change to Drought.</c>", WEATHER_SELECTIONS);
        AddStringElement("<c þ >Return weather back to Normal.</c>", WEATHER_SELECTIONS);
        AddStringElement(txtRed + "[Leave]</c>", WEATHER_SELECTIONS);
    }
}

void PageInit()
{
    // This is the function that sets up the prompts for each page.
    string sPage = GetDlgPageString();
    object oPC   = GetPcDlgSpeaker();

    //:: Display Conversation
    //::  Root
    if (sPage == "root")
    {
        SetDlgPrompt("The weatherstone glows before you.");

        int nSkill = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);

        //::  Show options if PC is skilled enough
        if (nSkill >= 30)
            SetDlgResponseList(MAIN_SELECTIONS);
    }
    //::  Weather
    else if (sPage == "weather")
    {
        SetDlgPrompt("By investing something of yourself you will be able to use the Weatherstone to alter the weather across the isle.");
        SetDlgResponseList(WEATHER_SELECTIONS);
    }
    else
    {
        SendMessageToPC(oPC, "You've found a bug. Oops! Please report it.");
    }
}

void HandleSelection()
{
    // This is the function that sets up the prompts for each page.
    string sPage    = GetDlgPageString();
    int nSelection  = GetDlgSelection();
    object oPC      = GetPcDlgSpeaker();

    //::  Root
    if (sPage == "root")
    {
        switch (nSelection)
        {
            case 0:
                SetDlgPageString("weather");
                break;
            case 1:
                EndDlg();
                break;
        }
    }
     //::  Weather
    else if (sPage == "weather")
    {
        switch (nSelection)
        {
            case 0:     //::  Cold
                AlterWeather(oPC, 2, 10, 8);
                EndDlg();
                break;
            case 1:     //::  Storms
                AlterWeather(oPC, 5, 10, 9);
                EndDlg();
                break;
            case 2:     //::  Drought
                AlterWeather(oPC, 9, 2, 5);
                EndDlg();
                break;
            case 3:     //::  Normal
                AlterWeather(oPC, 5, 5, 5);
                EndDlg();
                break;
            case 4:
                EndDlg();
                break;
        }
    }
}

void main()
{
    // Don't you dare!!
    int nEvent = GetDlgEventType();
    switch (nEvent)
    {
        case DLG_INIT:
            Init();
            break;

        case DLG_PAGE_INIT:
            PageInit();
            break;

        case DLG_SELECTION:
            HandleSelection();
            break;

        case DLG_ABORT:
        case DLG_END:
            break;
    }
}

void AlterWeather(object oPC, int nHeat, int nHumidity, int nWind)
{
    _miWHSetHeatIndex(nHeat);
    _miWHSetHumidity(nHumidity);
    _miWHSetWindStrength(nWind);
    SetLocalInt(GetModule(), VAR_WEATHER_CHANGE, GetTimeHour());
    //miWHAdjustWeather();
    ExAdjustWeather();

    //::  Create an effect
    effect eBright = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    effect eStrike = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eShake  = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oPC, 2.0f);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetLocation(GetWaypointByTag("AR_WP_LIGHT_STRIKE")));
    DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBright, GetLocation(OBJECT_SELF)));
    DelayCommand(0.4, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBright, GetLocation(GetWaypointByTag("AR_WP_LIGHT_STRIKE"))));
}

void ExAdjustWeather()
{
    Trace(WEATHER, "Adjusting module weather (Extended Edition)");
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

    //int nHeat     = GetLocalInt(GetModule(), VAR_WEATHER_HEAT);
    //int nHumidity = GetLocalInt(GetModule(), VAR_WEATHER_HUMIDITY);
    //int nWind     = GetLocalInt(GetModule(), VAR_WEATHER_WIND);

    //--------------------------------------------------------------------------
    // Heat is affected by time of year.
    //--------------------------------------------------------------------------
    //nHeat = Random(5) + (6 - abs(GetCalendarMonth() - 6)); // (0-4 + 0-6)
    if (nHeat < 1) nHeat = 1;

    //--------------------------------------------------------------------------
    // Humidity is random but moves slowly.
    //--------------------------------------------------------------------------
    //nHumidity = nHumidity + (Random(2 * nWind + 1) - nWind);
    //if (nHumidity > 10) nHumidity = 20 - nHumidity;
    if (nHumidity < 1) nHumidity = 1;

    //--------------------------------------------------------------------------
    // Wind is more likely to be calm, but can change quickly.
    //--------------------------------------------------------------------------
    //nWind = d10(2) - 10;
    if (nWind < 1) nWind = 1;

    Trace(WEATHER, "New weather settings (EXTENDED): heat - " + IntToString(nHeat) +
                                        ", humidity - " + IntToString(nHumidity) +
                                        ", wind - " + IntToString(nWind));

    //_miWHSetHeatIndex(nHeat);
    //_miWHSetHumidity(nHumidity);
    //_miWHSetWindStrength(nWind);

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
